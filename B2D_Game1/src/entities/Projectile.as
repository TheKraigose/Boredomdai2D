package entities 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */

	// Projectile Class
	// Projectile Class is an entity that travels constantly.
	// Unlike GibChunk, the missile travels in the approximate direction
	// the entity is facing (one of the N/S/E/W or diagonal directions.
	// Also, Projectile usually does damage to enemies and/or players,
	// depending on who fired.
	public class Projectile extends KIActor 
	{
		protected var angle:int;		// Angle is determined by the direction (45 degree increments)
		
		// Constructor
		public function Projectile(_sx:int, _sy:int, _w:int, _h:int, _d:int, _a:int, _s:int, _e:Entity) 
		{
			super(_sx, _sy, _w, _h);
			
			setOrigin(0, 0);
			
			layer = 4;		// Set layer to be below Player and enemies?
			target = _e;
			speed = _s;
			direction = _d;
			angle = _a;
			if (target is Player)
				type = "playermissile";
			else
				type = "enemymissile";
		}
		
		protected function changeWidthNHeight():void
		{
			if (angle == 90 || angle == 270)
			{
				setHitbox(height, width);
			}
			else if (angle == 45 || angle == 135 || angle == 225 || angle == 315)
			{
				setHitbox(width, width);
			}
		}
		
		// getDamage is called by the colliding actor
		// to determine damage calculations.
		public function getDamage():int
		{
			return damage;
		}
		
		// If the target (entity who fired the object)
		// is a Player, then cast the entity as a Player
		// and give the player points.
		public function givePlayerPoints(amt:int):void
		{
			if (target is Player)
			{
				var p:Player = target as Player;
				p.addToScore(amt);
			}
		}
		
		public function colliding(pos:Point):Boolean
		{
			if (collide("solid", pos.x, pos.y))
			{
				return true;
			}
			else
				return false;
		}
		
		// Update method.
		public override function update():void
		{
			if (speed > 0)
			{
				if (direction == 0)
				{
					if (!colliding(new Point(x + speed, y)))
						x += speed;
				}
				else if (direction == 7)
				{
					if (!colliding(new Point(x + speed, y + speed)))
					{
						x += speed;
						y += speed;
					}
				}
				else if (direction == 6)
				{
					if (!colliding(new Point(x, y + speed)))
						y += speed;
				}
				else if (direction == 5)
				{
					if (!colliding(new Point(x - speed, y + speed)))
					{
						x -= speed;
						y += speed;
					}
				}
				else if (direction == 4)
				{
					if (!colliding(new Point(x - speed, y)))
						x -= speed;
				}
				else if (direction == 3)
				{
					if (!colliding(new Point(x - speed, y - speed)))
					{
						x -= speed;
						y -= speed;
					}
				}
				else if (direction == 2)
				{
					if (!colliding(new Point(x, y - speed)))
						y -= speed;
				}
				else if (direction == 1)
				{
					if (!colliding(new Point(x + speed, y - speed)))
					{
						x += speed;
						y -= speed;
					}
				}
				else
				{
					if (!colliding(new Point(x + speed, y)))
						x += speed;
				}
			}
		}
		
	}

}