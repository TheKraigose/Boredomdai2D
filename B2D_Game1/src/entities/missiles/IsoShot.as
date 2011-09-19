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
	public class IsoShot extends Projectile 
	{
		private var fakeangle:int;
		private var sprExplosion:Image = new Image(Assets.SPR_FROCKET, new Rectangle(24, 0, 24, 24));
			
		private var sprFRocket:Image = new Image(Assets.SPR_FROCKET, new Rectangle(3, 7, 16, 9));
		private var sfxShoot:Sfx = new Sfx(Assets.SFX_ROCKET);
		private var sfxExplode:Sfx = new Sfx(Assets.SFX_EXPLODE);
		private var removetime:int;
		private var weavetime:int;
		
		public function IsoShot(_sx:int, _sy:int, _a:int, _p:Player)
		{
			super(_sx, _sy, 16, 10, _a, 6, _p);	// Call super constructor
			
			fakeangle = angle;
			
			Image(sprFRocket).angle = fakeangle;
			
			graphic = sprFRocket;
			
			damage = 20;			// Does a ton more damage...
			sfxShoot.play(0.35);	// Play sound effect.
			removetime = 0;
			weavetime = 0;
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
		
		public override function render():void
		{
			super.render();
			if (speed > 0)
				Image(sprFRocket).angle = fakeangle;
			else
				Image(sprFRocket).angle = angle;
		}
		
		public override function update():void
		{
			super.update();
			
			weavetime++;
			
			fakeangle = Angle.AU_CheckAngleRange(fakeangle + 45);
			
			if (weavetime >= 16)
			{
				weavetime = 0;
				if (Math.random() * 2 == 1)
					angle += Math.random() * 25;
				else
					angle -= Math.random() * 25;
			}
			
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