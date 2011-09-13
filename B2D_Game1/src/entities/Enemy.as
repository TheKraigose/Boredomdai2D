package entities 
{
	import net.flashpunk.Entity;
	import worlds.Game;
	import flash.geom.Point;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	
	// Enemy Class
	// A base for enemies in Dominion Arcade. This includes some functions
	// Used by the derived classes. It should not be used on it's own.
	public class Enemy extends KIActor
	{
		public static const FOUND_NONE:int = 0;
		public static const FOUND_WALL:int = 1;
		public static const FOUND_PLAYER:int = 2;
		public static const FOUND_ENEMY:int = 3;
		
		public static const REM_TIME_MAX:int = 300;			// A constant for how long it takes to remove an enemy.
		public static const PAIN_TIME_MAX:int = 128;
		
		protected var attacktime:int = 0;				// Time to attack
		protected var removaltime:int = 0;				// Removal time.
		protected var attackTimeMax:int;				// Attack time max (storage for per subclass const values)
		protected var paintime:int = 0;
		protected var painTimeMax:int;
		protected var pointsToPlayer:int;
		protected var taunttime:int;
		protected var deathtime:int;
		
		// Constructor.
		public function Enemy(_sx:int, _sy:int) 
		{
			super(_sx, _sy);
			layer = 8;
			type = "enemy";	// all enemies are labled as such for the FlashPunk collision system. Further collision
							// detection is done on a class detection basis.
			state = KIActor.STATE_SEEKING;
			pointsToPlayer = 100;
			
			speed = 1;
		}
		
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
				FP.world.remove(prj);
			}
		}
		
		// return if the enemy is melee attacking or not.
		public function checkMeleeAttack():Boolean
		{
			if (state == KIActor.STATE_MELEE)
				return true;
			else
				return false;
		}
				
		// Check if the enemy is alive or dead
		public function isAlive():Boolean
		{
			if (health > 0)
				return true;
			else
				return false;
		}
		
		// return enemy damage value
		public function getDamage():int
		{
			return damage;
		}
		
		private function oppositeDir(od:int):int
		{
			var retdir:int = od;
			if (retdir >= 0 && retdir < 4)
				retdir += 4;
			else if (retdir >= 5 && retdir <= 7)
				retdir -= 4;
			return retdir;
		}
		
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
		
		public function getDir():int
		{
			return direction;
		}
		
		protected function A_Chase():void
		{
			var ctx:int = Math.ceil(x / 24);
			var cty:int = Math.ceil(y / 24);
			
			AI_GoToNextTile(ctx, cty);
		}
		
		private function AI_GoToNextTile(tx:int, ty:int):void
		{
			calcDirection();
			var tardir:int;
			
			tardir = oppositeDir(direction);
			
			if (TryMoving(tx, ty))
					return;
					
			var findOtherDir:int = 0;
			var oldDir:int = direction;
			while (findOtherDir < 8)
			{
				if (!(findOtherDir == direction || findOtherDir == tardir))
				{
					direction = findOtherDir;
					if (TryMoving(tx, ty))
						return;
				}
				direction = oldDir;
				findOtherDir++;
			}
			
			direction = tardir;
			
			if (TryMoving(tx, ty))
				return;
		}
		
		private function TryMoving(tx:int, ty:int):Boolean
		{
			var node:Point = new Point();
			
			if (direction == 0)
			{
				node.x = (tx + speed);
				node.y = (ty);
			}
			else if (direction == 1)
			{
				node.x = (tx + speed);
				node.y = (ty - speed);
			}
			else if (direction == 2)
			{
				node.x = (tx);
				node.y = (ty - speed);
			}
			else if (direction == 3)
			{
				node.x = (tx - speed);
				node.y = (ty - speed);
			}
			else if (direction == 4)
			{
				node.x = (tx - speed);
				node.y = (ty);
			}
			else if (direction == 5)
			{
				node.x = (tx - speed);
				node.y = (ty + speed);
			}
			else if (direction == 6)
			{
				node.x = (tx);
				node.y = (ty + speed);
			}
			else if (direction == 7)
			{
				node.x = (tx + speed);
				node.y = (ty + speed);
			}
			
			if (!(checkIfWallCollide(node.x, node.y) || checkIfEnemyCollide(node.x, node.y)))
			{
				moveTowards(Math.floor(node.x * 24), Math.floor(node.y * 24), 1);
				return true;
			}
			else
				return false;
		}
		
		protected function A_Look(tileamt:int = 4):int
		{
			var rs:int = Enemy.FOUND_NONE;
			var ctx:int = Math.ceil(x / 24);
			var cty:int = Math.ceil(y / 24);
			
			if (AI_ListenForShots(ctx, cty, 8))
			{
				return Enemy.FOUND_PLAYER;
			}
			
			if (direction == 0)
			{
				rs = AI_CheckEast(ctx, cty, tileamt);
			}
			else if (direction == 1)
			{
				rs = AI_CheckNE(ctx, cty, tileamt);
			}
			else if (direction == 2)
			{
				rs =  AI_CheckNorth(ctx, cty, tileamt);
			}
			else if (direction == 3)
			{
				rs = AI_CheckNW(ctx, cty, tileamt);
			}
			else if (direction == 4)
			{
				rs =  AI_CheckWest(ctx, cty, tileamt);
			}
			else if (direction == 5)
			{
				rs = AI_CheckSW(ctx, cty, tileamt);
			}
			else if (direction == 6)
			{
				rs =  AI_CheckSouth(ctx, cty, tileamt);
			}
			else if (direction == 7)
			{
				rs = AI_CheckSE(ctx, cty, tileamt);
			}
			return rs;
		}
		
		protected function AI_ListenForShots(tx:int, ty:int, tam:int):Boolean
		{
			if (distanceFrom(target) < (tam * Assets.TILE_SIZE_X))
			{
				if (target is Player)
				{
					var plyr:Player = target as Player;
					if (plyr.makeSoundFromShots())
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
		protected function AI_CheckEast(tx:int, ty:int, tam:int):int
		{
			var retstate:int = Enemy.FOUND_NONE;
			var wallcount:int;
			var i:int;
			var j:int;
			
			for (i = tx;  i <= (tx + tam); i++)
			{
				var xx:int = i;
				var yy:int = ty;
				
				if (checkIfWallCollide(xx, yy))
					retstate = Enemy.FOUND_WALL;
				
				if (checkIfPlayerCollide(xx, yy) && retstate != Enemy.FOUND_WALL)
				{
					retstate = Enemy.FOUND_PLAYER;
				}
				
				if (retstate == Enemy.FOUND_PLAYER)
					break;
			}
			
			return retstate;
		}
		
				
		protected function AI_CheckSE(tx:int, ty:int, tam:int):int
		{
			var retstate:int = Enemy.FOUND_NONE;
			var wallcount:int;
			var i:int;
			var j:int = ty;
			
			for (i = tx;  i <= (tx + tam); i++)
			{
				var xx:int = i;
				var yy:int = j;
				
				if (checkIfWallCollide(xx, yy))
					retstate = Enemy.FOUND_WALL;
				
				if (checkIfPlayerCollide(xx, yy) && retstate != Enemy.FOUND_WALL)
				{
					retstate = Enemy.FOUND_PLAYER;
				}
				
				if (retstate == Enemy.FOUND_PLAYER)
					break;
				
				j++;
			}
			
			return retstate;
		}
		
		protected function AI_CheckSW(tx:int, ty:int, tam:int):int
		{
			var retstate:int = Enemy.FOUND_NONE;
			var wallcount:int;
			var i:int;
			var j:int = ty;
			
			for (i = tx;  i >= (tx - tam); i--)
			{
				var xx:int = i;
				var yy:int = j;
				
				if (checkIfWallCollide(xx, yy))
					retstate = Enemy.FOUND_WALL;
				
				if (checkIfPlayerCollide(xx, yy) && retstate != Enemy.FOUND_WALL)
				{
					retstate = Enemy.FOUND_PLAYER;
				}

				if (retstate == Enemy.FOUND_PLAYER)
					break;
				
				j++;
			}
			
			return retstate;
		}
		
		protected function AI_CheckWest(tx:int, ty:int, tam:int):int
		{
			var retstate:int = Enemy.FOUND_NONE;
			var wallcount:int;
			var i:int;
			var j:int;
			var cone:int = 7;
			
			for (i = tx;  i >= (tx - tam); i--)
			{
				var xx:int = i;
				var yy:int = ty;
				
				if (checkIfWallCollide(xx, yy))
					retstate = Enemy.FOUND_WALL;
				
				if (checkIfPlayerCollide(xx, yy) && retstate != Enemy.FOUND_WALL)
				{
					retstate = Enemy.FOUND_PLAYER;
				}

				if (retstate == Enemy.FOUND_PLAYER)
					break;
				
			}
			
			return retstate;
		}
		
		protected function AI_CheckNE(tx:int, ty:int, tam:int):int
		{
			var retstate:int = Enemy.FOUND_NONE;
			var wallcount:int;
			var i:int;
			var j:int = ty;
			
			for (i = tx;  i <= (tx + tam); i++)
			{
				var xx:int = i;
				var yy:int = j;
				
				if (checkIfWallCollide(xx, yy))
					retstate = Enemy.FOUND_WALL;
				
				if (checkIfPlayerCollide(xx, yy) && retstate != Enemy.FOUND_WALL)
				{
					retstate = Enemy.FOUND_PLAYER;
				}
				
				if (retstate == Enemy.FOUND_PLAYER)
					break;
				
				j--;
			}
			
			return retstate;
		}

		protected function AI_CheckNW(tx:int, ty:int, tam:int):int
		{
			var retstate:int = Enemy.FOUND_NONE;
			var wallcount:int;
			var i:int;
			var j:int = ty;
			
			for (i = tx;  i >= (tx - tam); i--)
			{
				var xx:int = i;
				var yy:int = j;
				
				if (checkIfWallCollide(xx, yy))
					retstate = Enemy.FOUND_WALL;
				
				if (checkIfPlayerCollide(xx, yy) && retstate != Enemy.FOUND_WALL)
				{
					retstate = Enemy.FOUND_PLAYER;
				}
				
				if (retstate == Enemy.FOUND_PLAYER)
					break;
				
				j--;
			}
			
			return retstate;
		}

		protected function AI_CheckNorth(tx:int, ty:int, tam:int):int
		{
			var retstate:int = Enemy.FOUND_NONE;
			var wallcount:int;
			var i:int;
			var j:int;
			var cone:int = 7;
			
			for (i = ty;  i >= ty - tam; i--)
			{
				var xx:int = tx;
				var yy:int = i;
				
				if (checkIfWallCollide(xx, yy))
					retstate = Enemy.FOUND_WALL;
				
				if (checkIfPlayerCollide(xx, yy) && retstate != Enemy.FOUND_WALL)
				{
					retstate = Enemy.FOUND_PLAYER;
				}

				if (retstate == Enemy.FOUND_PLAYER)
					break;
				
			}
			
			return retstate;
		}
		
		protected function AI_CheckSouth(tx:int, ty:int, tam:int):int
		{
			var retstate:int = Enemy.FOUND_NONE;
			var wallcount:int;
			var i:int;
			var j:int;
			var cone:int = 7;
			
			for (i = ty;  i <= ty + tam; i++)
			{
				var xx:int = tx;
				var yy:int = i;
				
				if (checkIfWallCollide(xx, yy))
					retstate = Enemy.FOUND_WALL;
				
				if (checkIfPlayerCollide(xx, yy) && retstate != Enemy.FOUND_WALL)
				{
					retstate = Enemy.FOUND_PLAYER;
				}
				
				if (retstate == Enemy.FOUND_PLAYER)
					break;
				
			}
			
			return retstate;
		}
		
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
			var ang:Number = Math.round(FP.angle(x, y, target.x, target.y));
			var i:int;
			var counter:int = 0;
			for (i = 0; i <= 360; i += 45)
			{
				if (ang >= i && ang <= i + 45)
				{
					direction = counter;
					if (direction >= 0 && direction <= 7)
						break;
				}
				counter++;
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
	}

}