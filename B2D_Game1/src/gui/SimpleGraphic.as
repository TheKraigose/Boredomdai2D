package gui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class SimpleGraphic extends Entity 
	{
		
		public function SimpleGraphic(_x:int, _y:int, _cls:Class, _aligncenter:Boolean=false, _lyr:int=-15) 
		{
			super(_x, _y);
			
			layer = _lyr;
			
			graphic = new Image(_cls);
			
			if (_aligncenter)
			{
				Image(graphic).centerOO();
			}
		}
		
	}

}