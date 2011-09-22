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

package entities.pickups 
{
	import entities.base.WeaponPickup;
	import net.flashpunk.graphics.Image;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class HeatSeeker extends WeaponPickup 
	{
		
		public function HeatSeeker(_sx:int, _sy:int, _ammo:int=8) 
		{
			super(_sx, _sy, _ammo);
			
			graphic = new Image(Assets.SPR_WEAPONS, new Rectangle(0, 48, 24, 24));
		}
		
	}

}