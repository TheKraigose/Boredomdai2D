package entities.pickups 
{
	import entities.base.WeaponPickup;
	import net.flashpunk.graphics.Image;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class DinnerLauncher extends WeaponPickup 
	{
		
		public function DinnerLauncher(_sx:int, _sy:int, _ammo:int=8) 
		{
			super(_sx, _sy, _ammo);
			
			graphic = new Image(Assets.SPR_WEAPONS, new Rectangle(0, 48, 24, 24));
		}
		
	}

}