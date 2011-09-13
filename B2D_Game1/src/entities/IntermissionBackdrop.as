package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class IntermissionBackdrop extends Entity 
	{
		
		public function IntermissionBackdrop() 
		{
			visible = false;
			layer = -1;
			graphic = new Image(Assets.GFX_RESULTPAGE);
		}
		
	}

}