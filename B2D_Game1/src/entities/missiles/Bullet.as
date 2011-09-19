package entities.missiles 
{
	import entities.base.Projectile;
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
		public function Bullet(_sx:int, _sy:int, _a:int, _e:Entity)
		{
			super(_sx, _sy, 8, 4, _a, 3, _e);
			
			graphic = new Image(Assets.SPR_BULLET);
			
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