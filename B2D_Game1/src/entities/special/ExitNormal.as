package entities.special 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class ExitNormal extends Entity 
	{
		
		public function ExitNormal(sx:int, sy:int) 
		{
			type = "exit";
			layer = 10;
			graphic = new Image(Assets.SPR_EXIT);
			width = height = 24;
			x = sx;
			y = sy;
		}
		
	}

}