package entities.pickups 
{
	import entities.base.WeaponPickup;
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class MachineGun extends WeaponPickup 
	{
		
		public function MachineGun(_sx:int, _sy:int) 
		{
			super(_sx, _sy);
			
			graphic = new Image(Assets.SPR_WEAPONS, new Rectangle(0, 0, 24, 24));
		}
		
	}

}