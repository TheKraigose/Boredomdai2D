package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class ExitNormal extends Entity 
	{
		[Embed(source = '../assets/sprites/exitsteps.png')]
		private const SPR_EXIT:Class;
		
		public function ExitNormal(sx:int, sy:int) 
		{
			type = "exit";
			layer = 10;
			graphic = new Image(SPR_EXIT);
			width = height = 24;
			x = sx;
			y = sy;
		}
		
	}

}