package gui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class GraphicsPage extends Entity 
	{
		protected var imgArray:Array;
		protected var maxImages:int;
		protected var currImageIndex:int;
		protected var cbackFunc:Function;
		protected var sfxSound:Sfx = new Sfx(Assets.SFX_MENU_CLICK);
		
		public function GraphicsPage(_images:Array, _sx:int = 0, _sy:int = 0) 
		{
			super(_sx, _sy);
			imgArray = _images;
			
			layer = -4;
			
			maxImages = _images.length;
			
			currImageIndex = 0;
			
			if ((imgArray[currImageIndex] is Image) && imgArray[0] != null)
			{
				graphic = imgArray[currImageIndex];
			}
		}
		
		public function setCallback(_func:Function):void
		{
			cbackFunc = _func;
		}
		
		public override function render():void
		{
			super.render();
			graphic = imgArray[currImageIndex];
		}
		
		public override function update():void
		{
			super.update();
			
			if (Input.pressed(Key.ANY) || Input.mousePressed)
			{				
				sfxSound.play(0.35);
				currImageIndex++;
			}
				
			if (currImageIndex == maxImages)
			{
				if (cbackFunc != null)
					cbackFunc.call();
				
				FP.world.remove(this);
			}
		}
		
	}

}