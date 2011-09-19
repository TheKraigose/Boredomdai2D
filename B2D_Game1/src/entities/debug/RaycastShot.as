package entities.debug 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Draw;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class RaycastShot extends Entity 
	{
		private var drawx1:int;
		private var drawx2:int;
		private var drawy1:int;
		private var drawy2:int;
		private var timeonscreen:int;
		private var color:uint;
		
		public function RaycastShot(_dx1:int, _dy1:int, _dx2:int, _dy2:int, _clr:uint=0xED9121) 
		{
			drawx1 = _dx1;
			drawx2 = _dx2;
			drawy1 = _dy1;
			drawy2 = _dy2;
			color = _clr;
		}
		
		public override function render():void
		{
			Draw.line(drawx1, drawy1, drawx2, drawy2, color);
		}
		
		public override function update():void
		{
			timeonscreen++;
			if (timeonscreen >= 8)
			{
				FP.world.remove(this);
			}
		}
		
	}

}