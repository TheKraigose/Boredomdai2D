/**
 * Kraigose Studios/Kraigose Interactive License
 * 
 * This software is under an MIT-like license:
 * 
 * 1.) You may use the source code files for any purpose but you must credit Kraig Culp for the code with this header.
 * 2.) This code comes without a warranty of any kind.
 * 
 * Written by Kraig "Kraigose" Culp 2011, 2012
 */

package worlds 
{
	import entities.ui.*;
	import entities.special.*;
	import entities.debug.*;
	import entities.base.*;
	import entities.enemies.*;
	import entities.pickups.*;
	import entities.geom.LevelGround;
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
		public var inter:Intermission
		public var hud:HeadsUpDisplay;
		public var healthhud:HealthBarHUD;
		public var ammohud:AmmoBarHUD;
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
			ammohud = new AmmoBarHUD();
			healthhud = new HealthBarHUD();
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
				
			pauseGfx = new SimpleGraphic(FP.halfWidth / 5, FP.halfHeight / 5, Assets.GFX_PAUSED, true);
			pauseGfx.visible = false;
			add(pauseGfx);
			pause = false;
		}
		
		public function difficultyFlagCheck(easy:Boolean, hard:Boolean, ohmy:Boolean):Boolean
		{
			if (difficulty == 3)
			{
				return ohmy;
			}
			else if (difficulty == 2)
			{
				return hard;
			}
			else if (difficulty == 1)
			{
				return easy;
			}
			
			return false;
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
			
			mapwidth * 2;
			mapheight * 2;
			
			var px:int;
			var py:int;
			
			var df1:Boolean;
			var df2:Boolean;
			var df3:Boolean;
			
			var sx:int;
			var sy:int;
			var sdir:int;
			
			var tx:int;
			var ty:int;
					
			
			// Build the tilemap
			lg = new LevelGround(xml);
			add(lg);
			
			if (xml.pushwalls[0] != null)
			{
				for each (var tile:XML in xml.pushwalls[0].tile)
				{
					sx = tile.@x;
					sy = tile.@y;
					
					sx = ((sx / 12) * 24);
					sy = ((sy / 12) * 24);
					
					tx = tile.@tx;
					ty = tile.@ty;
					
					tx = tx / 12;
					ty = ty / 12;
					
					add(new Pushwall(sx, sy, tx, ty));
					scrtcount++;
				}
			}
				
			if (xml.actors[0] != null)
			{
				for each (var playerspawn:XML in xml.actors[0].playerspawn)
				{
					px = playerspawn.@x;
					py = playerspawn.@y;
					
					px = ((px / 12));
					py = ((py / 12));
					
					px *= 24;
					py *= 24;
					
					player.setLocation(px + 12, py + 12);
					if (Version.debugMode)
					{
						add(new PlayerDebugText());
					}
					//adjustToPlayer();
				}
			
				for each (var lowguard:XML in xml.actors[0].lowguard)
				{
					df1 = lowguard.@dfeasy;
					df2 = lowguard.@dfhard;
					df3 = lowguard.@dfohmy;
					
					if (difficultyFlagCheck(df1, df2, df3))
					{
						sx = lowguard.@x;
						sy = lowguard.@y;
						sdir = lowguard.@dir;
						
						sx = ((sx / 12) * 24);
						sy = ((sy / 12) * 24);
						
						add(new LowGuard(sx + 12, sy + 12, sdir));
						mobjcount++;
					}
				}
				
				for each (var highguard:XML in xml.actors[0].highguard)
				{
					df1 = highguard.@dfeasy;
					df2 = highguard.@dfhard;
					df3 = highguard.@dfohmy;
					
					if (difficultyFlagCheck(df1, df2, df3))
					{
						sx = highguard.@x;
						sy = highguard.@y;
						sdir = highguard.@dir;
						
						sx = ((sx / 12) * 24);
						sy = ((sy / 12) * 24);
						
						add(new HighGuard(sx + 12, sy + 12, sdir));
						mobjcount++;
					}
				}
				
				for each (var moneybag:XML in xml.actors[0].moneybag)
				{
					sx = moneybag.@x;
					sy = moneybag.@y;

					sx = ((sx / 12) * 24);
					sy = ((sy / 12) * 24);
					add(new MoneyBag(sx, sy));
					itemcount++;
				}
				
				for each (var term:XML in xml.actors[0].pwallterm)
				{
					sx = term.@x;
					sy = term.@y;

					sx = ((sx / 12) * 24);
					sy = ((sy / 12) * 24);
					add(new PWallTerminus(sx, sy));
				}
				
				for each (var smac:XML in xml.actors[0].submachinegun)
				{
					sx = smac.@x;
					sy = smac.@y;

					sx = ((sx / 12) * 24);
					sy = ((sy / 12) * 24);
					add(new MachineGun(sx, sy));
				}
				
				for each (var bazooka:XML in xml.actors[0].bazooka)
				{
					sx = bazooka.@x;
					sy = bazooka.@y;

					sx = ((sx / 12) * 24);
					sy = ((sy / 12) * 24);
					add(new Bazooka(sx, sy));
				}
				
				for each (var heatzooka:XML in xml.actors[0].heatzooka)
				{
					sx = heatzooka.@x;
					sy = heatzooka.@y;

					sx = ((sx / 12) * 24);
					sy = ((sy / 12) * 24);
					add(new HeatSeeker(sx, sy));
				}
				
				for each (var dinnergun:XML in xml.actors[0].dinnergun)
				{
					sx = dinnergun.@x;
					sy = dinnergun.@y;

					sx = ((sx / 12) * 24);
					sy = ((sy / 12) * 24);
					add(new DinnerLauncher(sx, sy));
				}
				
				for each (var cboy:XML in xml.actors[0].choirboy)
				{
					sx = cboy.@x;
					sy = cboy.@y;

					sx = ((sx / 12) * 24);
					sy = ((sy / 12) * 24);
					add(new ChoirBoy(sx, sy));
				}
				
				for each (var isotrope:XML in xml.actors[0].isotrope)
				{
					sx = isotrope.@x;
					sy = isotrope.@y;

					sx = ((sx / 12) * 24);
					sy = ((sy / 12) * 24);
					add(new Isotrope(sx, sy));
				}
				
				for each (var fslice:XML in xml.actors[0].fslice)
				{
					sx = fslice.@x;
					sy = fslice.@y;

					sx = ((sx / 12) * 24);
					sy = ((sy / 12) * 24);
					add(new PizzaSlice(sx, sy, fslice.@ishot));
				}
				
				for each (var poutine:XML in xml.actors[0].poutine)
				{
					sx = poutine.@x;
					sy = poutine.@y;

					sx = ((sx / 12) * 24);
					sy = ((sy / 12) * 24);
					add(new Poutine(sx, sy, poutine.@ishot));
				}
				
				for each (var door:XML in xml.actors[0].doorobj)
				{
					sx = door.@x;
					sy = door.@y;

					sx = ((sx / 12) * 24);
					sy = ((sy / 12) * 24);
					add(new Door(sx, sy, door.@northsouth));
				}
				
				for each (var exit:XML in xml.actors[0].exittrigger)
				{
					//if(exit.@issecret == "true")
					//	add(new ExitSecret(sx, sy));
					
					sx = exit.@x;
					sy = exit.@y;
					
					sx = ((sx / 12) * 24);
					sy = ((sy / 12) * 24);
					
					add(new ExitNormal(sx, sy));
				}
				
				for each (var pwallfx:XML in xml.actors[0].pwallfx)
				{
					sx = pwallfx.@x;
					sy = pwallfx.@y;
					
					sx = ((sx / 12) * 24);
					sy = ((sy / 12) * 24);
					
					add(new PWallTagObj(sx, sy, pwallfx.@tag, pwallfx.@dir));
				}
				
				for each (var switchobj:XML in xml.actors[0].switchobj)
				{
					sx = touchplate.@x;
					sy = touchplate.@y;
					
					sx = ((sx / 12) * 24);
					sy = ((sy / 12) * 24);
					
					add(new TileSwitch(sx, sy, switchobj.@tag, switchobj.@tile));
				}
				
				for each (var touchplate:XML in xml.actors[0].touchplate)
				{
					sx = touchplate.@x;
					sy = touchplate.@y;
					
					sx = ((sx / 12) * 24);
					sy = ((sy / 12) * 24);
					
					add(new Touchplate(sx, sy, touchplate.@tag));
				}
			}
			
			inter.setMonsterTotal(mobjcount);
			inter.setItemTotal(itemcount);
			inter.setSecretTotal(scrtcount);
			
			add(hud);
			add(healthhud);
			add(ammohud);
			add(inter);
			add(musBox);
		}
		
		public function returnMap(num:int):Class
		{
			switch(num)
			{
				default:
				case 1:
					return Assets.E1A1_MAP;
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
			
			ammohud.x = healthhud.x = hud.x = FP.camera.x;
			ammohud.y = healthhud.y = hud.y = FP.camera.y;
			
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