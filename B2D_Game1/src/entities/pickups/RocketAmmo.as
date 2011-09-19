package entities.pickups 
{
	import entities.base.Pickup;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	
	// RocketAmmo Class
	// is a pickup type
	// that actually doesn't
	// do much. Most of the
	// calculation is done
	// on the player.
	public class RocketAmmo extends Pickup 
	{
		// Constructor.
		public function RocketAmmo(_sx:int, _sy:int) 
		{
			super(_sx, _sy, 24, 24);
			type = "rocketammo";
			graphic = new Image(Assets.SPR_ROCKBOX);
			
		}
		
		// Removed. Upon being removed,
		// Play superclass' removed/pickup sound.
		public override function removed():void
		{
			super.removed();
		}
		
	}

}