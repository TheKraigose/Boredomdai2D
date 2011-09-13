package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class GameOver extends Entity 
	{
		
		public function GameOver() 
		{
			graphic = new Text("Game Over");
			layer = 0;
			x = FP.camera.x + (FP.halfWidth / 2);
			y = FP.camera.y + (FP.halfHeight / 2);
		}
		
	}

}