package entities 
{
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
			Image(graphic).scale = Assets.SCALE_SPR_XY;
		}
		
		public override function removed():void
		{
			super.removed();
		}
		
	}

}