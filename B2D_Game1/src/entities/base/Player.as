package entities.base 
{
	import entities.missiles.*;
	import entities.pickups.*;
	import entities.special.*;
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import util.Angle;
	import worlds.TitleScreens;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class Player extends KIActor 
	{
		public static const RW_TYPE_NOTHING:int = 0;
		public static const RW_TYPE_BAZOOKA:int = 1;
		public static const RW_TYPE_HEATSEEK:int = 2;
		public static const RW_TYPE_DINNERGUN:int = 3;
		public static const RW_TYPE_CHOIRBOY:int = 4;
		public static const RW_TYPE_ISOTROPE:int = 5;
		
		private var isHurt:Boolean = false;	// If true, you are currently invulnerable from being hurt.
		private const PAIN_TIME_MAX:int = 24;	// Constant for the maximum amount of paintime before resetting.
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
		public var hasSubmachineGun:int = 0;
		public var hasRocketWeapon:int = 0;
		public var currentRocketAmmo:int = 0;
		public var rocketWeaponType:int = -1;
		public var weaponPickupCooldown:int = 0;
		private var machineGunTimer:int = 0;
		
		// Constructor.
		public function Player(_sx:int, _sy:int, _d:int) 
		{
			super(_sx, _sy, 14, 20);
			ssheet = new Spritemap(Assets.SANYA_SPR, 24, 24);
			
			ssheet.add("walk", [0], 0, false);
			ssheet.add("fire", [0, 1, 0], 20, false);
			ssheet.add("pain", [2], 0, false);
			ssheet.add("dead", [2, 3, 4, 5], 20, false);
			
			sfxHScan = new Sfx(Assets.SFX_BULLET);
			
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
		
		public function getRocketTypeForSave():int
		{
			return rocketWeaponType;
		}
		
		public function getSubmacstatus():int
		{
			return hasSubmachineGun;
		}
		
		public function setSave(ssi:SaveStateInfo):void
		{
			currentScore = ssi.score;
			health = ssi.health;
			lives = ssi.lives;
			rocketAmmo = ssi.rocketammo;
			rocketWeaponType = ssi.rtype;
			hasSubmachineGun = ssi.smac;
			
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
		
		public function setDirAndAngle(_d:int):void
		{
			direction = _d;
			angle = _d * 45;
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
		
		public function takeHealthFromHitscan(_dam:int, _e:KIActor):void
		{
			if (!isHurt && health > 0)
			{
				isHurt = true;
				health -= _dam;
				Image(graphic).alpha = 0.5;
				Image(graphic).color = 0xFF0000;
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
				var strafemod:int = 0;
				
				if (Input.pressed(Key.CAPS_LOCK))
				{
					speedModified = !speedModified;
				}
				
				if (!Input.check(Key.X))
				{
					if (Input.check(Key.LEFT))
					{
						rotdir = 1;
						strafemod = 0;
					}
					else if (Input.check(Key.RIGHT))
					{
						rotdir = -1;
						strafemod = 0;
					}
					
					if (Input.check(Key.UP))
					{
						movement = 1;
					}
					else if (Input.check(Key.DOWN))
					{
						movement = -1;
					}
				}
				else
				{
					if (Input.check(Key.LEFT))
					{
						if (Input.check(Key.UP))
						{
							movement = 1;
							strafemod = 45;
						}
						else if (Input.check(Key.DOWN))
						{
							movement = -1;
							strafemod = -45;
						}
						else
						{
							movement = 1;
							strafemod = -90;
						}
					}
					else if (Input.check(Key.RIGHT))
					{
						if (Input.check(Key.UP))
						{
							movement = 1;
							strafemod = -45;
						}
						else if (Input.check(Key.DOWN))
						{
							movement = -1;
							strafemod = 45;
						}
						else
						{
							movement = -1;
							strafemod = -90;
						}
					}
					else if (Input.check(Key.UP))
					{
						movement = 1;
						strafemod = 0;
					}
					else if (Input.check(Key.DOWN))
					{
						movement = -1;
						strafemod = 0;
					}
				}
				
				if (speedModified)
					movement *= 2;
				
				var movestep:int = SPEED_PLAYER * movement;
				angle += (rotdir * SPEED_PLAYER);
				
				angle = Angle.AU_CheckAngleRange(angle);
				
				// trace("A: " + angle + " R: " + radrot);
				
				var newX:Number = x + Math.cos(Angle.AU_DegreesToRadians(angle + strafemod)) * movestep;
				var newY:Number = y - Math.sin(Angle.AU_DegreesToRadians(angle + strafemod)) * movestep;
				
				if (!colliding(new Point(newX, newY)))
				{
					x = newX;
					y = newY;
				}
				
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
				
				if (Input.check(Key.C))
				{
					if (hasSubmachineGun == 1 && !useRockets)
					{
						machineGunTimer++;
						if (machineGunTimer >= 12)
						{
							P_ShootHitScan(10);
							machineGunTimer = 0;
						}
					}
				}
				
				if (Input.pressed(Key.C))
				{
					if (!useRockets && (hasSubmachineGun != 1))
					{
						P_ShootHitScan(8);
					}
					else if (useRockets)
					{
						if (rocketAmmo > 0)
						{
							if (rocketWeaponType == Player.RW_TYPE_BAZOOKA)
							{
								FP.world.add(new Rocket(x, y, angle, this));
								rocketAmmo -= 1;
								if (rocketAmmo <= 0)
								{
									rocketWeaponType = Player.RW_TYPE_NOTHING
									useRockets = false;
								}
							}
							else if (rocketWeaponType == Player.RW_TYPE_HEATSEEK)
							{
								FP.world.add(new HeatMissile(x, y, angle, this));
								rocketAmmo -= 1;
								if (rocketAmmo <= 0)
								{
									rocketWeaponType = Player.RW_TYPE_NOTHING
									useRockets = false;
								}
							}
							else if (rocketWeaponType == Player.RW_TYPE_DINNERGUN)
							{
								var i:int;
								for (i = 1; i <= 8; i++)
								{
									FP.world.add(new DinnerShot(x, y, angle - (i * 4), angle, this));
								}
								rocketAmmo -= 1;
								if (rocketAmmo <= 0)
								{
									rocketWeaponType = Player.RW_TYPE_NOTHING
									useRockets = false;
								}
							}
							else if (rocketWeaponType == Player.RW_TYPE_ISOTROPE)
							{
								for (var j:int = 1; j <= 4; j++) 
								{
									FP.world.add(new IsoShot(x, y, angle - (j * 4), this));
								}
								rocketAmmo -= 1;
								if (rocketAmmo <= 0)
								{
									rocketWeaponType = Player.RW_TYPE_NOTHING
									useRockets = false;
								}
							}
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
					
					var doorlist:Array = [];
					FP.world.getClass(Door, doorlist);
					for each(var dr:Door in doorlist)
					{
						dr.openDoor();
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
					health -= ep.getDamage();
					isHurt = true;
					Image(graphic).alpha = 0.5;
					Image(graphic).color = 0xFF0000;
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
				
				var hp:HealthPickup = collide("healthitem", x, y) as HealthPickup;
				if (hp)
				{
					var healthtogive:int = hp.getHealAmount();
					if (addToHealth(healthtogive))
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
				
				var wpkup:WeaponPickup = collide("weaponup", x, y) as WeaponPickup;
				if (wpkup && weaponPickupCooldown == 0)
				{
					if (wpkup is MachineGun)
					{
						if (hasSubmachineGun == 0)
						{
							hasSubmachineGun = 1;
							FP.world.remove(wpkup);
							return;
						}
					}
					
					if (rocketWeaponType == Player.RW_TYPE_BAZOOKA)
						FP.world.add(new Bazooka(wpkup.x, wpkup.y, rocketAmmo));
					else if (rocketWeaponType == Player.RW_TYPE_HEATSEEK)
						FP.world.add(new HeatSeeker(wpkup.x, wpkup.y, rocketAmmo));
					else if (rocketWeaponType == Player.RW_TYPE_DINNERGUN)
						FP.world.add(new DinnerLauncher(wpkup.x, wpkup.y, rocketAmmo));
					else if (rocketWeaponType == Player.RW_TYPE_CHOIRBOY)
						FP.world.add(new ChoirBoy(wpkup.x, wpkup.y, rocketAmmo));
					else if (rocketWeaponType == Player.RW_TYPE_ISOTROPE)
						FP.world.add(new Isotrope(wpkup.x, wpkup.y, rocketAmmo));
					
					rocketAmmo = 0;
					rocketWeaponType = Player.RW_TYPE_NOTHING;
					rocketAmmo = wpkup.getAmmo();
					
					if (wpkup is Bazooka)
					{
						rocketWeaponType = Player.RW_TYPE_BAZOOKA;
						useRockets = true;
						weaponPickupCooldown += 2;
					}
					else if (wpkup is HeatSeeker)
					{
						rocketWeaponType = Player.RW_TYPE_HEATSEEK;
						useRockets = true;
						weaponPickupCooldown += 2;
					}
					else if (wpkup is DinnerLauncher)
					{
						rocketWeaponType = Player.RW_TYPE_DINNERGUN;
						useRockets = true;
						weaponPickupCooldown += 2;
					}
					else if (wpkup is ChoirBoy)
					{
						rocketWeaponType = Player.RW_TYPE_CHOIRBOY;
						useRockets = true;
						weaponPickupCooldown += 2;
					}
					else if (wpkup is Isotrope)
					{
						rocketWeaponType = Player.RW_TYPE_ISOTROPE;
						useRockets = true;
						weaponPickupCooldown += 2;
					}
					
					FP.world.remove(wpkup);
				}
				
				if (weaponPickupCooldown <= 96 && weaponPickupCooldown >= 2)
				{
					weaponPickupCooldown++;
					
					if (weaponPickupCooldown > 64)
						weaponPickupCooldown = 0;
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