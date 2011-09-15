package worlds 
{
	import entities.*;
	import flash.utils.ByteArray;
	import gui.SimpleGraphic;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.utils.*;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	
	// This is nothing more than a
	// Mere Test Arena
	public class Game extends World 
	{
		
		public static const GAME_STATE_LOADING:int = 1;
		public static const GAME_STATE_INGAME:int = 2;
		public static const GAME_STATE_INTERMISSION:int = 3;
		public static const GAME_STATE_VICTORY:int = 4;
		
		public static const MAX_LEVELS_INT:int = 3;
		public static const CAMERA_OFFSET:int = 128;
		public static const CAMERA_SPEED:int = 1;
		public static const DIFF_BABY:int = 1;
		public static const DIFF_EASY:int = 2;
		public static const DIFF_HARD:int = 3;
		
		public var player:Player;
		public var interbg:IntermissionBackdrop;
		public var inter:Intermission;
		public var hud:HeadsUpDisplay;
		public var lg:LevelGround;
		public var levelNumber:int = 1;
		public var gameState:int = 0;
		public var mapwidth:int;
		public var mapheight:int;
		public var levelDone:Boolean;
		public var difficulty:int;
		public var musBox:MusicPlayer;
		public var pause:Boolean;
		public var musposPause:Number;
		public var pauseGfx:SimpleGraphic;
		
		public function Game(diff:int, lnum:int, ssi:SaveStateInfo = null) 
		{
			gameState = GAME_STATE_LOADING;
			difficulty = diff;
			player = new Player(0, 0, 0);
			hud = new HeadsUpDisplay();
			interbg = new IntermissionBackdrop();
			inter = new Intermission();
			musBox = new MusicPlayer(levelNumber, gameState, true);
			if (ssi != null)
			{
				player.setSave(ssi);
			}
			add(player);
			if (lnum >= 1 && lnum <= MAX_LEVELS_INT)
				levelNumber = lnum;
			else
				levelNumber = 1;
				
			pauseGfx = new SimpleGraphic(FP.halfWidth / 5, FP.halfHeight / 5 ,Assets.GFX_PAUSED, true);
			pauseGfx.visible = false;
			add(pauseGfx);
			pause = false;
		}
		
		public function loadXMLMap(num:int):void
		{
			// Helper variables
			var o:XML;
			var i:int;
			var c:Class;
			
			var mobjcount:int;
			var itemcount:int;
			var scrtcount:int;
			
			c = returnMap(num);
			
			// Obtain an XML instance
			var bytes:ByteArray = new c;
			var xml:XML = new XML(bytes.readUTFBytes(bytes.length));
			
			mapwidth = xml.width;
			mapheight = xml.height;
			
			// Build the tilemap
			lg = new LevelGround(xml);
			add(lg);
			
			if (xml.pushwalls[0] != null)
			{
				for each (var tile:XML in xml.pushwalls[0].tile)
				{
					add(new Pushwall(tile.@x, tile.@y, tile.@tx, tile.@ty));
					scrtcount++;
				}
			}
				
			if (xml.actors[0] != null)
			{
				for each (var playerSpawn:XML in xml.actors[0].playerSpawn)
				{
					var px:int = playerSpawn.@x;
					var py:int = playerSpawn.@y
					player.setLocation(px + 12, py + 12);
					if (Version.debugMode)
					{
						add(new PlayerDebugText());
					}
					//adjustToPlayer();
				}
			
				for each (var enemygrunt:XML in xml.actors[0].enemygrunt)
				{
					if (enemygrunt.@dflag <= difficulty)
					{
						add(new LowGuard(enemygrunt.@x, enemygrunt.@y, enemygrunt.@dir));
						mobjcount++;
					}
				}
				
				/* for each (var zalgawesome:XML in xml.actors[0].zalgawesome)
				{
					if (zalgawesome.@dflag <= difficulty)
					{
						add(new Zalgawesome(zalgawesome.@x, zalgawesome.@y));
						mobjcount++;
					}
				} */
				
				for each (var moneybag:XML in xml.actors[0].moneybag)
				{
					add(new MoneyBag(moneybag.@x, moneybag.@y));
					itemcount++;
				}
				
				for each (var boss1peta:XML in xml.actors[0].boss1peta)
				{
					var endlevel:Boolean = false;
					if (boss1peta.@endslevel == "true")
						endlevel = true;
					else
						endlevel = false;
					
					add(new BossCookingMama(boss1peta.@x, boss1peta.@y, endlevel));
					mobjcount++;
				}
				
				for each (var rocketammo:XML in xml.actors[0].rocketammo)
				{
					add(new RocketAmmo(rocketammo.@x, rocketammo.@y));
				}
				
				for each (var healthkit:XML in xml.actors[0].healthkit)
				{
					add(new HealthKit(healthkit.@x, healthkit.@y));
				}
				
				for each (var exitNormal:XML in xml.actors[0].exitNormal)
				{
					add(new ExitNormal(exitNormal.@x, exitNormal.@y));
				}
				
				for each (var pwallfx:XML in xml.actors[0].pwallfx)
				{
					add(new PWallTagObj(pwallfx.@x, pwallfx.@y, pwallfx.@tag, pwallfx.@dir));
				}
				
				for each (var switchobj:XML in xml.actors[0].switchobj)
				{
					add(new TileSwitch(switchobj.@x, switchobj.@y, switchobj.@tag, switchobj.@tile));
				}
				
				for each (var touchplate:XML in xml.actors[0].touchplate)
				{
					add(new Touchplate(touchplate.@x, touchplate.@y, touchplate.@tag));
				}
			}
			
			inter.setMonsterTotal(mobjcount);
			inter.setItemTotal(itemcount);
			inter.setSecretTotal(scrtcount);
			
			add(hud);
			add(inter);
			add(musBox);
		}
		
		public function returnMap(num:int):Class
		{
			switch(num)
			{
				default:
				case 1:
					return Assets.LEVEL01_MAP;
					break;
				case 2:
					return Assets.LEVEL02_MAP;
					break;
				case 3:
					return Assets.LEVEL03_MAP;
					break;
			}
		}
		
		public function followPlayer():void
		{
			FP.camera.x = player.x - FP.halfWidth;
			FP.camera.y = player.y - FP.halfHeight;
		}
		
		public function adjustToPlayer():void
		{
			var newCameraX:int = (player.x + player.width) - FP.halfWidth;
			var newCameraY:int = (player.y + player.height) - FP.halfHeight;
			
			if (newCameraX < 0) newCameraX = 0;
			else if (newCameraX + FP.halfWidth < mapwidth) newCameraX = mapwidth - FP.halfWidth;
			
			if (newCameraY < 0) newCameraY = 0;
			else if (newCameraY + FP.halfHeight < mapheight) newCameraY = mapheight - FP.halfHeight;
			
			FP.camera.x = newCameraX;
			FP.camera.y = newCameraY;
		}
		
		public override function render():void
		{
			hud.x = FP.camera.x;
			hud.y = FP.camera.y;
				
			super.render();
		}
		
		public override function update():void 
		{
			if (!pause)
			{
				super.update();
				inter.updateLevelNum(levelNumber);
				if (gameState == GAME_STATE_LOADING)
				{
					inter.resetBonuses();
					inter.visible = false;
					interbg.visible = false;
					inter.startingNewLevel();
					levelDone = false;
					if (levelNumber > MAX_LEVELS_INT)
						levelNumber = MAX_LEVELS_INT;
					player.visible = true;
					loadXMLMap(levelNumber);
					musBox.MP_StartPlaying(levelNumber, Game.GAME_STATE_INGAME);
					gameState = GAME_STATE_INGAME;
				}
				
				if (gameState == GAME_STATE_INGAME)
				{
					// To Prevent a visit to Bog City, Manitoba
					// We need to clean up dead actors.
					// However, instead of removing them
					// immediately, we compromise, and
					// wait a while until they are
					// flagged properly for removal.
					var enemylist:Array = [];
					this.getClass(Enemy, enemylist);
					for each(var e:Enemy in enemylist)
					{
						if (e.isRemovable())
							remove(e);
					}
					if (player.checkIntermission() /* && player.collide("exit", player.x, player.y) */)
					{
						gameState = GAME_STATE_INTERMISSION;
						player.setLocation( -128, -128);
					}
					followPlayer();
				}
				
				if (gameState == GAME_STATE_INTERMISSION)
				{
					if (levelDone == false)
					{
						FP.camera.x = 0;
						FP.camera.y = 0;
						var entitylist:Array = [];
						this.getClass(Entity, entitylist);
						for each(var ee:Entity in entitylist)
						{
							if (!(ee is Player) && !(ee is Intermission) && !(ee is IntermissionBackdrop)
							&& !(ee is MusicPlayer) &&!(ee is SimpleGraphic))
								remove(ee);
						}
						musBox.MP_StopPlaying();
						musBox.MP_StartPlaying(levelNumber, gameState);
						player.visible = false;
						inter.visible = true;
						interbg.visible = true;
						inter.levelFinished();
						levelDone = true;
					}
					else
					{
						if (!player.checkIntermission())
						{
							musBox.MP_StopPlaying();
							levelNumber++;
							SaveManager.saveXMLSaveState();
							gameState = GAME_STATE_LOADING;
						}
					}
				}
			}
			else
			{
			}
			if (Input.pressed(Key.P))
			{
				if (pause)
				{
					pauseGfx.visible = false;
					musBox.MP_StartPlaying(levelNumber, gameState, true);
					pause = false;
				}
				else if (!pause)
				{
					pauseGfx.visible = true;
					musBox.MP_StopPlaying();
					pause = true;
				}
			}
		}
		
	}

}