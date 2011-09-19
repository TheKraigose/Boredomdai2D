package entities.pickups 
{
	import entities.base.WeaponPickup;
	import net.flashpunk.graphics.Image;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class Bazooka extends WeaponPickup
	{
		
		public function Bazooka(_sx:int, _sy:int, _ammo:int=10) 
		{
			super(_sx, _sy, _ammo);
			
			graphic = new Image(Assets.SPR_WEAPONS, new Rectangle(24, 0, 24, 24));
		}
		
	}

}