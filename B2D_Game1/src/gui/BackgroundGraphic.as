package gui 
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class BackgroundGraphic extends Entity 
	{
		public function BackgroundGraphic(_img:Class, _sx:int=0, _sy:int=0) 
		{
			super(_sx, _sy);
			
			layer = -2;
			
			graphic = new Image(_img, new Rectangle(0, 0, Assets.STAGE_SIZE_X, Assets.STAGE_SIZE_Y));
		}
		
	}

}