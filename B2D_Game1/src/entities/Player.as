package entities 
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import worlds.TitleScreens;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class Player extends KIActor 
	{
		private var isHurt:Boolean = false;	// If true, you are currently invulnerable from being hurt.
		private const PAIN_TIME_MAX:int = 50;	// Constant for the maximum amount of paintime before resetting.
		private var paintime:int = 0;		// The amount of time passed since pain. Invulnerable during this time.
		private var rocketAmmo:int = 0;		// The missiles the player has.
		private var currentScore:int = 0;	// Current Score for level.
		private var tries:int = 0;			// "Lives" or "Tries".
		private var useRockets:Boolean = false;	// If true, use rockets until ammo is dried out.
		private var lives:int = 5;
		private var freeze:Boolean = false;
		private var intermission:Boolean = false;
		private var readyToAdvance:Boolean = false;
		private var timetotitle:int = 0;
		private const TIME_TO_TITLE:int = 256;
		private var gameOver:Boolean = false;
		private var tileX:int;
		private var tileY:int;
		private var oneUpLevel:int = 1;
		public const SCORE_INCREMENT_1UP:int = 16000;
		public const SPEED_PLAYER:int = 2;
		public var speedModified:Boolean = false;
		
		// Constructor.
		public function Player(_sx:int, _sy:int, _d:int) 
		{
			super(_sx, _sy, 14, 20);
			ssheet = new Spritemap(Assets.SANYA_SPR, 24, 24);
			
			ssheet.add("walk", [0], 0, false);
			ssheet.add("fire", [0, 1, 0], 15, false);
			ssheet.add("pain", [2], 0, false);
			ssheet.add("dead", [2, 3, 4, 5], 15, false);
			
			/*ssheet.add("stand_down", [0], 0, false);
			ssheet.add("stand_up", [8], 0, false);
			ssheet.add("stand_left", [12], 0, false);
			ssheet.add("stand_right", [4], 0, false);
			ssheet.add("walk_down", [0, 1, 2, 3], 20, true);
			ssheet.add("walk_right", [4, 5, 6, 7], 20, true);
			ssheet.add("walk_up", [8, 9, 10, 11], 20, true);
			ssheet.add("walk_left", [12, 13, 14, 15], 20, true);
			ssheet.add("dead", [16, 17, 18, 19], 20, false); */
			
			graphic = ssheet;
			type = "player";
			direction = _d;
			
			if (direction == 0)
			{
				angle = 0;
			}
			
			health = 100;
			layer = 1;
			
			speed = SPEED_PLAYER;
			
			sfxPain = new Sfx(Assets.SFX_SANYA_PAIN);
			sfxDead = new Sfx(Assets.SFX_SANYA_DEAD);
		}
		
		protected function A_PlayPlayerSound(_type:int=KIActor.CHAN_CHASE):void
		{
			A_PlaySound(_type, 0.45);
		}
		
		public function getScoreForSave():int
		{
			return returnScore();
		}
		
		public function getAmmoForSave():int
		{
			return rocketAmmo;
		}
		
		public function getLivesForSave():int
		{
			return lives;
		}
		
		public function getHealthForSave():int
		{
			return health;
		}
		
		public function setSave(ssi:SaveStateInfo):void
		{
			currentScore = ssi.score;
			health = ssi.health;
			lives = ssi.lives;
			rocketAmmo = ssi.rocketammo;
			
			var reached:Boolean = false;
			
			while (!reached)
			{
				if (oneUpLevel < (currentScore / SCORE_INCREMENT_1UP))
					oneUpLevel++;
				else
					reached = true;
			}
		}
		
		public function makeSoundFromShots():Boolean
		{
			if (Input.pressed(Key.C))
				return true;
			else
				return false;
		}
		
		// This method checks if the player is alive.
		public function isAlive():Boolean
		{
			if (health <= 0)
				return false;
			else
				return true;
		}
		
		public function returnAdvance():Boolean
		{
			return readyToAdvance;
		}
		
		// This method only checks to see how much
		// health the player has for HUD purposes.
		public function returnHealth():int
		{
			return health;
		}
		
		// This method adds to the current score based on
		// pickups or enemy events. Trying to figure out
		// how to get the bullets to damage enemies and
		// then give the player who fired the shot the
		// points.
		public function addToScore(amt:int):void
		{
			currentScore += amt;
			checkScoreForOneUp();
		}
		
		// Return the amount of rockets the player has.
		// This is for HUD purposes.
		public function returnRockets():int
		{
			return rocketAmmo;
		}
		
		// This adds rockets. 50 rockets max
		// at the moment.
		public function addToRockets(amt:int):Boolean
		{
			if (rocketAmmo >= 50)
				return false;
			else
			{
				rocketAmmo += amt;
				if (rocketAmmo > 50)
					rocketAmmo = 50;
				return true;
			}
		}
		
		// This adds Health. 100 hp max
		public function addToHealth(amt:int):Boolean
		{
			if (health >= 100)
				return false;
			else
			{
				health += amt;
				if (health > 100)
					health = 100;
				return true;
			}
		}
		
		public function checkRocketMode():Boolean
		{
			if (rocketAmmo > 0 && useRockets)
				return true;
			else
				return false;
		}
		
		public function returnScore():int
		{
			return currentScore;
		}
		
		public function checkScoreForOneUp():void
		{
			if (currentScore >= (oneUpLevel * SCORE_INCREMENT_1UP))
			{
				health = 100;
				lives++;
				oneUpLevel++;
			}
		}
		
		public function setLocation(sx:int, sy:int):void
		{
			x = sx;
			y = sy;
			trace("Player placed at X: " + x, " and Y: " + y + " with center at (" + (x - originX) + "," + (y - originY) + ").");
		}
		
		public function freezePlayer():void
		{
			freeze = true;
		}
		
		public function unfreezePlayer():void
		{
			freeze = false;
		}
		
		public function checkFrozen():Boolean
		{
			return freeze;
		}
		
		public function toggleIntermission():Boolean
		{
			if (intermission)
			{
				intermission = false;
			}
			else
			{
				intermission = true;
			}
			return intermission;
		}
		
		public function checkIntermission():Boolean
		{
			return intermission;
		}
		
		public function colliding(pos:Point):Boolean
		{
			if (collide("solid", pos.x, pos.y))
				return true;
			else
				return false;
		}
		
		public function returnLives():int
		{
			return lives;
		}
		
		public function checkGameOver():Boolean
		{
			if (gameOver && timetotitle >= TIME_TO_TITLE)
				return true;
			else
				return false;
		}
		
		public override function render():void
		{
			super.render();
			Image(graphic).angle = angle;
			Image(graphic).centerOO();
		}
		
		// Update method for player.
		// A complex beast.
		public override function update():void
		{
			// Do not update majority of
			// input if player is dead.
			if (health > 0 && !intermission && !gameOver)
			{
				
				tileX = Math.ceil(x / 24);
				tileY = Math.ceil(y / 24);
				
				var movement:int = 0;
				var rotdir:int = 0;
				
				if (Input.pressed(Key.CAPS_LOCK))
				{
					speedModified = !speedModified;
				}
				
				if (Input.check(Key.LEFT))
				{
					rotdir = 1;
				}
				else if (Input.check(Key.RIGHT))
				{
					rotdir = -1;
				}
				
				if (Input.check(Key.UP))
				{
					movement = 1;
				}
				else if (Input.check(Key.DOWN))
				{
					movement = -1;
				}
				
				if (speedModified)
					movement *= 2;
				
				var movestep:int = SPEED_PLAYER * movement;
				angle += (rotdir * SPEED_PLAYER);
				
				if (angle >= 360)
					angle -= 360;
				else if (angle < 0)
					angle += 360;
					
				var radrot:Number = (Math.PI / 180) * angle;
				
				// trace("A: " + angle + " R: " + radrot);
				
				var newX:int = Math.round(x + Math.cos(radrot) * movestep);
				var newY:int = Math.round(y - Math.sin(radrot) * movestep);
				
				if (!colliding(new Point(newX - SPEED_PLAYER, newY - SPEED_PLAYER)))
				{
					x = newX;
					y = newY;
				}
				
				
				/* if (Input.check(Key.DOWN))
				{
					if (Input.check(Key.LEFT))
					{
						direction = 5;
						ssheet.play("walk_left");
						if (!colliding(new Point(x - SPEED_PLAYER, y + SPEED_PLAYER)))
						{
							x -= SPEED_PLAYER;
							y += SPEED_PLAYER;
						}
					}
					else if (Input.check(Key.RIGHT))
					{
						direction = 7;
						ssheet.play("walk_right");
						if (!colliding(new Point(x + SPEED_PLAYER, y + SPEED_PLAYER)))
						{
							x += SPEED_PLAYER;
							y += SPEED_PLAYER;
						}
					}
					else
					{
						direction = 6;
						ssheet.play("walk_down");
						if (!colliding(new Point(x, y + SPEED_PLAYER)))
							y += SPEED_PLAYER;
					}
				}
				else if (Input.check(Key.UP))
				{
					if (Input.check(Key.LEFT))
					{
						direction = 3;
						ssheet.play("walk_left");
						if (!colliding(new Point(x - SPEED_PLAYER, y - SPEED_PLAYER)))
						{
							x -= SPEED_PLAYER;
							y -= SPEED_PLAYER;
						}
					}
					else if (Input.check(Key.RIGHT))
					{
						direction = 1;
						ssheet.play("walk_right");
						if (!colliding(new Point(x + SPEED_PLAYER, y - SPEED_PLAYER)))
						{
							x += SPEED_PLAYER;
							y -= SPEED_PLAYER;
						}
					}
					else
					{
						direction = 2;
						ssheet.play("walk_up");
						if (!colliding(new Point(x, y - SPEED_PLAYER)))
							y -= SPEED_PLAYER;
					}
				}
				else if (Input.check(Key.LEFT))
				{
					direction = 4;
					ssheet.play("walk_left");
					if (!colliding(new Point(x - SPEED_PLAYER, y)))
						x -= SPEED_PLAYER;
				}
				else if (Input.check(Key.RIGHT))
				{
					direction = 0;
					ssheet.play("walk_right");
					if (!colliding(new Point(x + SPEED_PLAYER, y)))
						x += SPEED_PLAYER;
				} */
				
				
				if (Input.pressed(Key.V))
				{
					if (rocketAmmo > 0)
					{
						if (useRockets)
							useRockets = false;
						else
							useRockets = true;
					}
					else
						useRockets = false;
				}
				
				if (Input.pressed(Key.C))
				{
					
					if (!useRockets)
					{
						world.add(new Bullet(x - originX, y - originY, angle, this));
					}
					else
					{
						if (rocketAmmo > 0)
						{
							world.add(new Rocket(x - originX, y - originY, angle, this));
							rocketAmmo -= 1;
							if (rocketAmmo <= 0)
								useRockets = false;
						}

					}
				}
				
				if (Input.pressed(Key.Z))
				{
					var pwlist:Array = [];
					FP.world.getClass(Pushwall, pwlist);
					for each(var pw:Pushwall in pwlist)
					{
						pw.push();
					}
					
					var tswlist:Array = [];
					FP.world.getClass(TileSwitch, tswlist);
					for each(var tsw:TileSwitch in tswlist)
					{
						tsw.activate();
					}
				}
			}
			else if (health <= 0)
			{
				// Press any action key to restart at the moment.
				// We should place text or something in the HUD indicating so.
				if (Input.pressed(Key.C) || Input.pressed(Key.X) || Input.pressed(Key.Z) && lives >= 0 && !gameOver)
				{
					lives -= 1;
					health = 100;
					isHurt = false;
					direction = 0;
					rocketAmmo = 0;
					currentScore;
				}
				if (lives < 0)
				{
					lives = 0;
					gameOver = true;
					FP.world.add(new GameOver())
				}
			}
			
			if (!gameOver)
			{
				if (intermission && health > 0)
				{
					if (Input.pressed(Key.C) || Input.pressed(Key.X) || Input.pressed(Key.Z))
					{
						toggleIntermission();
					}
				}
				
				// Check if we collide with an enemy and it's
				// Melee attacking us.
				var e:Enemy = collide("enemy", x, y) as Enemy;
				if ((e) && !(isHurt) && e.checkMeleeAttack() && e.isAlive())
				{
					health -= e.getDamage();
					isHurt = true;
					Image(graphic).alpha = 0.5;
					Image(graphic).color = 0xFF0000;
				}
				
				var ep:Projectile = collide("enemymissile", x, y) as Projectile
				if (ep && !isHurt)
				{
					if (ep is Bullet)
					{
						health -= ep.getDamage();
						isHurt = true;
						Image(graphic).alpha = 0.5;
						Image(graphic).color = 0xFF0000;
					}
				}
				
				// Check if we "pick up" RocketAmmo
				var ra:RocketAmmo = collide("rocketammo", x, y) as RocketAmmo;
				if (ra)
				{
					if (addToRockets(5))
					{
						FP.world.remove(ra);
					}
				}
				
				var hp:HealthKit = collide("healthkit", x, y) as HealthKit;
				if (hp)
				{
					if (addToHealth(15))
					{
						FP.world.remove(hp);
					}
				}
				
				var haz:Hazard = collide("hazard", x, y) as Hazard;
				if (haz && !isHurt)
				{
					health -= haz.getDamage();
					isHurt = true;
				}
				
				// Check if the player just got attacked by a zalgorfield or other enemy.
				if (isHurt)
				{
					if (paintime == 0)
					{
						A_PlayPlayerSound(KIActor.CHAN_PAIN);
					}
					
					paintime += 1;
					if (paintime >= PAIN_TIME_MAX && health > 0)
					{
						paintime = 0;
						isHurt = false;
						Image(graphic).alpha = 1;
						Image(graphic).color = 0xFFFFFF;
					}
					else if (health <= 0)
					{

						if (paintime != 0)
						{
							A_StopSound(KIActor.CHAN_PAIN);
							A_PlayPlayerSound(KIActor.CHAN_DEAD);
						}
						paintime = 0;
						Image(graphic).alpha = 1;
						Image(graphic).color = 0xFFFFFF;
						ssheet.play("dead");
					}
				}
				
				var exitobj:ExitNormal = collide("exit", x, y) as ExitNormal;
				if (exitobj)
				{
					if (exitobj is ExitNormal)
					{
						toggleIntermission();
					}
				}
			}
			else if (gameOver)
			{
				timetotitle++;
				if (timetotitle > TIME_TO_TITLE)
				{
					timetotitle = 0;
					FP.world = new TitleScreens();
				}
			}
		}
		
	}

}