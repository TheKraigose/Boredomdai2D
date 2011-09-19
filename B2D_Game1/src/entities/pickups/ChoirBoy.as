package entities.pickups 
{
	import entities.base.WeaponPickup;
	import net.flashpunk.graphics.Image;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class ChoirBoy extends WeaponPickup 
	{
		
		public function ChoirBoy(_sx:int, _sy:int, _ammo:int=8) 
		{
			super(_sx, _sy, _ammo);
			
			graphic = new Image(Assets.SPR_WEAPONS, new Rectangle(24, 24, 24, 24));
		}
		
	}

}