package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Sfx;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	
	/**
	 * A bullet fired from an enemy or player.
	 */
	public class Bullet extends Projectile 
	{
		
		private var sfxShoot:Sfx = new Sfx(Assets.SFX_BULLET);		// Sound effect.
		
		/**
		 * Constructor
		 * @param	spawnx Place to spawn the bullet on the x axis.
		 * @param	spawny Place to spawn the bullet on the y axis.
		 * @param	dir    Direction to spawn the bullet (0-7).
		 * @param	e      The entity who spawned the bullet.
		 */
		public function Bullet(_sx:int, _sy:int, _d:int, _e:Entity)
		{
			super(_sx, _sy, 8, 4, _d, 0, 3, _e);
			
			graphic = new Image(Assets.SPR_BULLET);
			
			
			// Apparently this rotates counter-clockwise
			// instead of clockwise. Dunno why.
			// This caused me to recode the
			// spawning of the Rocket class.
			if (direction == 0)
				angle = 0;
			else if (direction == 1)
				angle = 45;
			else if (direction == 2)
				angle = 90;
			else if (direction == 3)
				angle = 135;
			else if (direction == 4)
				angle = 180;
			else if (direction == 5)
				angle = 225;
			else if (direction == 6)
				angle = 270;
			else if (direction == 7)
				angle = 315;
			else
				angle = 0;
				
			changeWidthNHeight();
			
			Image(graphic).angle = angle;
				
			damage = 10;	// set the damage the projectile deals.
			sfxShoot.play(0.35);	// play sound effect.
			trace("Bullet placed at X: " + x, " and Y: " + y + " with center at (" + (x - originX) + "," + (y - originY) + ").");
		}
		
				
		public override function colliding(pos:Point):Boolean
		{
			if (collide("solid", pos.x, pos.y))
			{
				speed = 0;
				FP.world.remove(this);
				return true;
			}
			else
				return false;
		}
	}

}