package entities.base 
{
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class WeaponPickup extends Pickup
	{
		protected var ammogive:int;
		protected var cooldown:int;
		protected var dropped:int;
		
		public function WeaponPickup(_sx:int, _sy:int, _ammo:int=-1 ) 
		{
			super(_sx, _sy, 24, 24);
			
			ammogive = _ammo;
			
			type = "weaponup";
		}
		
		public function getAmmo():int
		{
			return ammogive;
		}
	}

}