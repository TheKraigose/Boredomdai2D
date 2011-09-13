package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Sfx;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	
	// Pickup Class
	// Pickups only do one thing really - make a
	// sound upon pickup. Most pickup activity
	// is done on a Player/Enemy basis.
	public class Pickup extends KIActor 
	{
		protected var sfxPickup:Sfx = new Sfx(Assets.SFX_PICKUP);
		
		public function Pickup(_sx:int, _sy:int, _w:int=24, _h:int=24) 
		{
			super(_sx, _sy, _w, _h);
			layer = 6;
		}
		
		public override function removed():void
		{
			if (collide("player", x, y))
				sfxPickup.play(0.35);
		}
		
	}

}