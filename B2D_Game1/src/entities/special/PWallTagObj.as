package entities.special 
{
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class PWallTagObj extends Entity 
	{
		private var tag:int;
		private var direction:int = -1;
		
		public function PWallTagObj(sx:int, sy:int, t:int = 0, dir:int = 0) 
		{
			visible = false;
			x = sx;
			y = sy;
			
			width = height = Assets.TILE_SIZE_X;
			
			tag = t;
			
			direction = dir;
			
			type = "pwalltag";
		}
		
		public function GetTag():int
		{
			return tag;
		}
		
		public function GetDirection():int
		{
			return direction;
		}
		
	}

}