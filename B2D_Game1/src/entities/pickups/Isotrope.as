package entities.pickups 
{
	import entities.base.WeaponPickup;
	import net.flashpunk.graphics.Image;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class Isotrope extends WeaponPickup 
	{
		
		public function Isotrope(_sx:int, _sy:int, _ammo:int=6) 
		{
			super(_sx, _sy, _ammo);
			
			graphic = new Image(Assets.SPR_WEAPONS, new Rectangle(24, 48, 24, 24));
		}
		
	}

}