package entities.pickups 
{
	import entities.base.Pickup;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class HealthKit extends Pickup 
	{
		
		public function HealthKit(sx:int, sy:int) 
		{
			super(sx, sy, 24, 24);
			type = "healthkit";
			graphic = new Image(Assets.SPR_HPKIT);
		}
		
		public override function removed():void
		{
			super.removed();
		}
		
	}

}