package gui.error 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class ErrorOverlay extends Entity 
	{
		private var image:Image;
		public function ErrorOverlay(_img:Class=null) 
		{
			
			layer = -9;
			
			if (_img == null)
				image = new Image(Assets.GFX_ERROR_VICTIM);
			else
				image = new Image(_img);
			
			image.alpha = 0.25;
			
			graphic = image;
		}
		
	}

}