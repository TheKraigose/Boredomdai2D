package entities.missiles 
{
	import entities.base.*;
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */

	// Rocket Class
	// Derived from Projectile, it is a stronger
	// missile than the Bullet, capable of gibbing
	// enemies if they reach the gib threshold.
	// Bullets don't do much damage, thus more
	// unlikely to "gib" enemies.
	public class Rocket extends Projectile 
	{
		// Assets

		// End Assets
		
		// Sfx objects
		private var sprExplosion:Image = new Image(Assets.SPR_FROCKET, new Rectangle(24, 0, 24, 24));
			
		private var sprFRocket:Image = new Image(Assets.SPR_FROCKET, new Rectangle(3, 7, 16, 9));
		private var sfxShoot:Sfx = new Sfx(Assets.SFX_ROCKET);
		private var sfxExplode:Sfx = new Sfx(Assets.SFX_EXPLODE);
		private var removetime:int;
		
		// Constructor
		public function Rocket(_sx:int, _sy:int, _a:int, _p:Player) 
		{
			super(_sx, _sy, 16, 10, _a, 5, _p);	// Call super constructor
			
			Image(sprFRocket).angle = angle;
			
			graphic = sprFRocket;
			
			damage = 25;			// Does a ton more damage...
			sfxShoot.play(0.35);	// Play sound effect.
			removetime = 0;
		}
		
		public override function colliding(pos:Point):Boolean
		{
			if (collide("solid", pos.x, pos.y) && graphic != sprExplosion )
			{
				graphic = sprExplosion;
				speed = 0;
				return true;
			}
			else
				return false;
		}
		
		public override function update():void
		{
			super.update();
			sprExplosion.originX = x + halfWidth;
			sprExplosion.originY = halfHeight;
			if (speed <= 0)
			{
				if (graphic != sprExplosion)
					graphic = sprExplosion;
				
				if (removetime == 0)
				{
					sfxShoot.stop();		// stop sound effect to prevent overlap
					sfxExplode.play(0.35);	// Play explosion sound effect.
				}
				damage = 0;
				removetime++;
				if (removetime >= 128)
				{
					FP.world.remove(this);
				}
			}
		}
		
	}

}