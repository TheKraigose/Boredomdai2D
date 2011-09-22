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

package entities.missiles 
{
	import entities.base.*;
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import flash.geom.Point;
	import util.Angle;
	
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
	public class DinnerShot extends Projectile 
	{
		// Assets

		// End Assets
		
		// Sfx objects
		private var sprExplosion:Image = new Image(Assets.SPR_FROCKET, new Rectangle(24, 0, 24, 24));
			
		private var sprFRocket:Image = new Image(Assets.SPR_DINNERSHOT);
		private var sfxShoot:Sfx = new Sfx(Assets.SFX_DINNER_LAUNCHER);
		private var sfxExplode:Sfx = new Sfx(Assets.SFX_EXPLODE);
		private var removetime:int;
		private var angletotravel:int;
		private var timetillground:int;
		
		// Constructor
		public function DinnerShot(_sx:int, _sy:int, _a:int, _a2:int, _p:Player) 
		{
			super(_sx, _sy, 16, 10, _a, 4, _p);	// Call super constructor
			
			Image(sprFRocket).angle = angle;
			
			angletotravel = _a2;
			
			graphic = sprFRocket;
			
			damage = 10;			// Does a ton more damage...
			
			if (Options.soundFxEnabled)
				sfxShoot.play(Options.soundFxVolume * 0.35);	// Play sound effect.
			
			removetime = 0;
			timetillground = 0;
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
			if (speed > 0)
			{
				var newX:int = Math.round(x + Math.cos(Angle.AU_DegreesToRadians(angle)) * speed);
				var newY:int = Math.round(y - Math.sin(Angle.AU_DegreesToRadians(angle)) * speed);
				
				if (!colliding(new Point(newX, newY)))
				{
					x = newX;
					y = newY;
				}
				
				if (timetillground < 32)
					timetillground++;
				
				if (timetillground >= 32)
				{
					angle = angletotravel;
				}
				
			}
			if (speed <= 0)
			{
				if (graphic != sprExplosion)
					graphic = sprExplosion;
				
				if (removetime == 0)
				{
					sfxShoot.stop();		// stop sound effect to prevent overlap
					if (Options.soundFxEnabled)
						sfxExplode.play(Options.soundFxVolume * 0.35);	// Play sound effect.
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