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
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class HealthPickup extends Pickup 
	{
		public static const FIRE_CHECK_GFX:Image = new Image(Assets.SPR_FROCKET, new Rectangle(24, 0, 24, 24));
		
		protected var isHot:Boolean
		protected var healAmount:int;
		protected var cooldown:int;
		
		public function HealthPickup(_sx:int, _sy:int, _healamt:int=10, _ishot:Boolean = false) 
		{
			super(_sx, _sy, 24, 24);
			
			type = "healthitem";
			
			healAmount = _healamt;
			
			isHot = _ishot;
			
			if (isHot)
			{
				healAmount *= 2;
			}
		}
		
		public function checkIfHeated():void
		{
			var expfire:Projectile = (collide("playermissile", x, y)) as Projectile;
			var expfirealt:Projectile = (collide("enemymissile", x, y)) as Projectile;
			
			if (expfire)
			{
				if (expfire.graphic == HealthPickup.FIRE_CHECK_GFX)
				{
					isHot = true;
				}
			}
			else if (expfirealt)
			{
				if (expfirealt.graphic == HealthPickup.FIRE_CHECK_GFX)
				{
					isHot = true;
				}
			}
			
			if (isHot && cooldown == 0)
			{
				cooldown = 128;
			}
		}
		
		public function getHealAmount():int
		{
			return healAmount;
		}
		
		public override function update():void
		{
			super.update();
			checkIfHeated();
			if (isHot && cooldown <= 128 && cooldown >= 0)
			{
				cooldown--;
				if (cooldown == 0)
				{
					isHot = false;
					healAmount /= 2;
				}
			}
		}
	}

}