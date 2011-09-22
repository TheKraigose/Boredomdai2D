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

package entities.base 
{
	import entities.debug.RaycastShot;
	import entities.fx.GibChunk;
	import entities.special.Intermission;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import util.Angle;
	import worlds.Game;
	import flash.geom.Point;
	import net.flashpunk.FP;
	
	/**
	 * Enemy KIActor.
	 * @author Kraig Culp
	 */
	public class Enemy extends KIActor
	{
		// Static Constants for AI hitscan types.
		public static const FOUND_NONE:int = 0;
		public static const FOUND_WALL:int = 1;
		public static const FOUND_PLAYER:int = 2;
		public static const FOUND_ENEMY:int = 3;
		
		// Static Constants for AI
		public static const REM_TIME_MAX:int = 300;			// A constant for how long it takes to remove an enemy.
		public static const PAIN_TIME_MAX:int = 128;
		
		protected var attacktime:int = 0;				// Time to attack
		protected var removaltime:int = 0;				// Removal time.
		protected var attackTimeMax:int;				// Attack time max (storage for per subclass const values)
		protected var paintime:int = 0;
		protected var painTimeMax:int;
		protected var pointsToPlayer:int;
		protected var looktime:int;		
		protected var chasetime:int;
		protected var taunttime:int;
		protected var deathtime:int;
		
		/**
		 * Spawn an Enemy.
		 * @param	_sx x position in the world to spawn
		 * @param	_sy y position in the world to spawn
		 * @param	_w width of the enemy
		 * @param	_h height of the enemy
		 */
		public function Enemy(_sx:int, _sy:int, _w:int=24, _h:int=24) 
		{
			super(_sx, _sy, _w, _h);
			layer = 8;
			type = "enemy";	// all enemies are labled as such for the FlashPunk collision system. Further collision
							// detection is done on a class detection basis.
			state = KIActor.STATE_SEEKING;
			pointsToPlayer = 100;
			
			speed = 1;
			
			chasetime = taunttime = looktime = deathtime = 0;
		}
		
		/**
		 * Take health from a player's htiscan.
		 * @param	_dam Damage to take.
		 * @param	_e Entity who fired.
		 */
		public function takeHealthFromHitscan(_dam:int, _e:KIActor):void
		{
			if (state != KIActor.STATE_PAIN || state != KIActor.STATE_DEAD && health > 0)
			{
				state = KIActor.STATE_PAIN;
				health -= _dam;
				if (health <= 0)
				{
					state = KIActor.STATE_DEAD
					if (_e is Player)
					{
						var _p:Player = _e as Player;
						_p.addToScore(pointsToPlayer);
						if (health <= gibHealth)
						{
							visible = false;
							SpawnGibs(5);
						}
					}
				}
			}
		}
		
		/**
		 * Check if the Enemy collides with a Projectile fired by a non-player.
		 */
		public function checkPlayerProjectileCollide():void
		{
			var prj:Projectile = collide("playermissile", x, y) as Projectile;
			if (prj && ((state != KIActor.STATE_PAIN) || state != KIActor.STATE_DEAD))
			{
				state = KIActor.STATE_PAIN;
				health -= prj.getDamage();
				if (health <= 0)
				{
					state = KIActor.STATE_DEAD;
					prj.givePlayerPoints(pointsToPlayer);
					if (health <= gibHealth)
					{
						visible = false;
						SpawnGibs(5);
					}
				}
				prj.stopSpeed();
			}
		}
		
		/**
		 * Check if the enemy is meleeing. Not used at the moment.
		 * @return Enemy is in melee state.
		 */
		public function checkMeleeAttack():Boolean
		{
			if (state == KIActor.STATE_MELEE)
				return true;
			else
				return false;
		}
				
		/**
		 * Check if the enemy is alive.
		 * @return If health is greater than 0.
		 */
		public function isAlive():Boolean
		{
			if (health > 0)
				return true;
			else
				return false;
		}
		
		/**
		 * Get the damage a melee or direct shot (hitscan) attack makes.
		 * @return damage dealt.
		 */
		public function getDamage():int
		{
			return damage;
		}
		
		/**
		 * Function that tries to get an opposite direction.
		 * @param	od direction
		 * @return direction
		 */
		private function oppositeDir(od:int):int
		{
			var retdir:int = od;
			if (retdir >= 0 && retdir < 4)
				retdir += 4;
			else if (retdir >= 5 && retdir <= 7)
				retdir -= 4;
			return retdir;
		}
		
		/**
		 * Gets the current state of the enemy as a string for debugging.
		 * @return state as a string.
		 */
		public function getState():String
		{
			var retstr:String = "";
			if (state == KIActor.STATE_SEEKING)
				retstr = "Seeking";
			else if (state == KIActor.STATE_CHASING)
				retstr = "Chasing";
			else if (state == KIActor.STATE_DEAD)
				retstr = "Dead";
			else if (state == KIActor.STATE_MELEE)
				retstr = "Melee";
			else if (state == KIActor.STATE_MISSILE)
				retstr = "Missile";
			else
				retstr = "!!Unknown!!";
			return retstr;
		}
		
		/**
		 * Gets the direction as an int.
		 * @return direction.
		 */
		public function getDir():int
		{
			return direction;
		}
		
		/**
		 * A_Chase AI routine.
		 */
		protected function A_Chase():void
		{
			var ctx:int = Math.ceil(x / 24);
			var cty:int = Math.ceil(y / 24);
			
			AI_GoToNextTile(ctx, cty);
		}
		
		/**
		 * Private AI routine for going to the next available slot.
		 * @param	tx TileX
		 * @param	ty TileY
		 */
		private function AI_GoToNextTile(tx:int, ty:int):void
		{
			calcDirection();
			
			var tardir:int;
			
			tardir = oppositeDir(direction);
			
			if (TryMoving())
					return;
					
			var findOtherDir:int = 0;
			var oldDir:int = direction;
			while (findOtherDir < 8)
			{
				angle = direction * 45;
				if (!(findOtherDir == direction || findOtherDir == tardir))
				{
					direction = findOtherDir;
					if (TryMoving())
						return;
				}
				direction = oldDir;
				findOtherDir++;
			}
			
			direction = tardir;
			
			if (TryMoving())
				return;
		}
		
		/**
		 * Checks if the Enemy can move in the current angle.
		 * @return if successful.
		 */
		private function TryMoving():Boolean
		{
			var newX:int = Math.round(x + Math.cos(Angle.AU_DegreesToRadians(angle)) * speed);
			var newY:int = Math.round(y - Math.sin(Angle.AU_DegreesToRadians(angle)) * speed);
			
			if (!colliding(new Point(newX, newY)) && !collide("player", newX, newY))
			{
				x = newX;
				y = newY;
				return true;
			}
			else if (collide("player", newX, newY))
			{
				state = KIActor.STATE_MISSILE;
				return false;
			}
			
			return false;
		}
		
		/**
		 * A_Look routine.
		 * @param	_dist Distance in tiles
		 */
		protected function A_Look(_dist:int = 4):void
		{
			var rs:int = Enemy.FOUND_NONE;
			var ctx:int = Math.ceil(x / 24);
			var cty:int = Math.ceil(y / 24);
			
			var coneang:int = FP.angle(x, y, target.x, target.y);

			
			if (coneang > (angle - 5) && coneang < (angle +5))
			{
				if (FP.distance(x, y, target.x, target.y) <= _dist * Assets.TILE_SIZE_X)
				{
					if (!AI_CheckSightBlocked(_dist * Assets.TILE_SIZE_X))
					{
						state = KIActor.STATE_CHASING;
					}
				}
			}
		}
		
		/**
		 * Check if line of sight is blocked by a solid object.
		 * @param	_distact Actual distance in map units to check.
		 * @return true if line of sight is blocked by a solid object or no player is found.
		 */
		protected function AI_CheckSightBlocked(_distact:int):Boolean
		{
			var rx:int = x;
			var ry:int = y;
			var hitsolid:Boolean = false;
			var hitplayer:Boolean = false;
			
			while (FP.distance(x, y, rx, ry) <= _distact)
			{
				rx += Math.cos(Angle.AU_DegreesToRadians(angle)) * Assets.TILE_SIZE_X;
				ry -= Math.sin(Angle.AU_DegreesToRadians(angle)) * Assets.TILE_SIZE_Y;
				
				if (collide("solid", rx, ry))
				{
					hitsolid = true;
					break;
				}
				else if (collide("player", rx, ry))
				{
					hitplayer = true;
					break;
				}
			}
			
			if (hitplayer && !hitsolid)
			{
				FP.world.add(new RaycastShot(x, y, rx, ry, 0x00FF00));
				return false;
			}
			else
			{
				FP.world.add(new RaycastShot(x, y, rx, ry, 0xFF0000));
				return true;
			}
		}
		
		/**
		 * 
		 * @param	tx
		 * @param	ty
		 * @return
		 */
		protected function checkIfEnemyCollide(tx:int, ty:int):Boolean
		{
			var e:Enemy = collide("enemy", tx * 24, ty * 24) as Enemy;
			if (e && e != this && e.isAlive())
			{
				return true;
			}
			else
				return false;
		}
		
		/**
		 * 
		 * @param	tx
		 * @param	ty
		 * @return
		 */
		protected function checkIfPlayerCollide(tx:int, ty:int):Boolean
		{
			if (collide("player", tx * 24, ty * 24))
				return true;
			else
				return false;
		}
		
		protected function checkIfWallCollide(tx:int, ty:int):Boolean
		{
			if (collide("solid", tx * 24, ty * 24))
				return true;
			else
				return false;
		}
		
		protected function calcDirection():void
		{
			var tmpang:int = Math.round(FP.angle(x, y, target.x, target.y));
			tmpang = Angle.AU_CheckAngleRange(tmpang);
			
			var i:int;
			var counter:int = 0;
			for (i = 0; i <= 359; i += 45)
			{
				if (angle >= i && angle <= i + 45)
				{
					direction = counter;
					if (direction >= 0 && direction <= 7)
						break;
				}
				counter++;
			}
			
			if (tmpang >= angle)
			{
				angle += 2;
			}
			else if (tmpang < angle)
			{
				angle -= 2;
			}
		}
		
		protected function calcNewPos():Point
		{
			var rp:Point = new Point();
			if (direction == 0)
			{
				rp.x = x + 6;
			}
			else if (direction == 1)
			{
				rp.x = x + 6;
				rp.y = y - 6;
			}
			else if (direction == 2)
			{
				rp.y = y - 6;
			}
			else if (direction == 3)
			{
				rp.x = x - 6;
				rp.y = y - 6;
			}
			else if (direction == 4)
			{
				rp.x = x - 6;
			}
			else if (direction == 5)
			{
				rp.x = x - 6;
				rp.y = y + 6;
			}
			else if (direction == 6)
			{
				rp.y = y + 6;
			}
			else if (direction == 7)
			{
				rp.x = x + 6;
				rp.y = y + 6;
			}
			else
			{
				rp.x = x;
				rp.y = y;
			}
			return rp;
		}
		
		protected function shiftDirection():void
		{
			direction++;
			if (direction >= 8)
				direction = 0;
		}
		
		// This function spawns the amount of gibs requested
		// and the color requested. (Currently "none", "white",
		// "red", "green", and "blue" are valid. Anything else
		// defaults to "none" or "white"
		public function SpawnGibs(amt:int=2, color:String="none"):void
		{
			var gibc:uint = 0xFFFFFF;	// Color in uint format.
			
			// Determine the color based on supplied string.
			if (color == "none" || color == "white")
				gibc = 0xFFFFFF;
			else if (color == "red")
				gibc = 0xFF0000;
			else if (color == "green")
				gibc = 0x00FF00;
			else if (color == "blue")
				gibc = 0x0000FF;
			else
				gibc = 0xFFFFFF;	// Default to white in uint if any other string is identified.
				
			var gibamount:int = amt;
			if (gibamount > 8)
			{
				gibamount = 7;
			}
			else if (gibamount < 1)
			{
				gibamount = 1;
			}
			
			// Spawn the gibs (add them to the Enemy's world)
			for (var i:int = 0; i < gibamount; i++)
			{
				world.add(new GibChunk(x, y, i, gibc));
			}
		}
		
		public function colliding(pos:Point):Boolean
		{
			if (collide("solid", pos.x, pos.y))
				return true;
			else
				return false;
		}
		
		// This flag returns the flagForRemoval flag. Used
		// to determine if the enemy is dead/needs removed
		// based on the time it's been dead/inactive.
		public function isRemovable():Boolean
		{
			return flagForRemoval;
		}
		
		public function addMonsterKill():void
		{
			var im:Array = [];
			FP.world.getClass(Intermission, im);
			im[0].setMonsterKilled();
		}
		
		public override function render():void
		{
			super.render();
			Image(graphic).angle = angle;
			Image(graphic).centerOO();
		}
	}

}