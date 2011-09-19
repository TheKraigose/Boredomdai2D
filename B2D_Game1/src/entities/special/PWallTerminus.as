package entities.special 
{
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class PWallTerminus extends Entity 
	{
		
		public function PWallTerminus(_sx:int, _sy:int) 
		{
			super(_sx, _sy);
			visible = false;
			
			width = height = Assets.TILE_SIZE_X;
			
			type = "pwallterm";
		}
		
	}

}