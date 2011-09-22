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
	import entities.base.HealthPickup;
	import net.flashpunk.graphics.Image;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class PizzaSlice extends HealthPickup 
	{
		
		public function PizzaSlice(_sx:int, _sy:int, _ishot:Boolean=false) 
		{
			super(_sx, _sy, 20, _ishot);
			
			graphic = new Image(Assets.SPR_PICKUPS, new Rectangle(0, 0, 24, 24));
		}
		
	}

}