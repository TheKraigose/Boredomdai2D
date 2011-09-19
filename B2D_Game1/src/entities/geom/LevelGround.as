package entities.geom 
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.Grid;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class LevelGround extends Entity 
	{
		
		private var tilemap:Tilemap;
		private var grid:Grid;
		
		public function LevelGround(map:XML) 
		{
			type = "solid";	// Collision type.
			
			// set the tilemap.
			graphic = tilemap = new Tilemap(Assets.TILESET, map.width * 2, map.height * 2, Assets.TILE_SIZE_X, Assets.TILE_SIZE_Y);
			
			var px:int;
			var py:int;
			var ptx:int;
			var pty:int;
			
			for each (var tile:XML in map.walls[0].tile)
			{
				px = tile.@x;
				py = tile.@y;
				ptx = tile.@tx;
				pty = tile.@ty;
				
				px = ((px / 12));
				py = ((py / 12));
				ptx = ((ptx / 12));
				pty = ((pty / 12));
				
				tilemap.setTile(px, py, tilemap.getIndex(ptx, pty));
			}
			
			mask = grid = new Grid(map.width * 2, map.height * 2, Assets.TILE_SIZE_X, Assets.TILE_SIZE_Y);
			
			var sw:int;
			var sh:int;
			
			// set the mask property
			for each (var solid:XML in map.solid[0].rect)
			{
				px = solid.@x;
				py = solid.@y;
				
				sw = solid.@w;
				sh = solid.@h;
				
				px = ((px / 12));
				py = ((py / 12));
				
				sw = ((sw / 12));
				sh = ((sh / 12));
				
				grid.setRect(px, py, sw, sh);
			}
		}
		
	}

}