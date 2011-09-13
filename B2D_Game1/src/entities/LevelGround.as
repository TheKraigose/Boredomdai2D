package entities 
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
			graphic = tilemap = new Tilemap(Assets.TILESET, map.width, map.height, Assets.TILE_SIZE_X, Assets.TILE_SIZE_Y);
			
			for each (var tile:XML in map.walls[0].tile)
			{
				tilemap.setTile(tile.@x / Assets.TILE_SIZE_X, tile.@y / Assets.TILE_SIZE_Y,
				tilemap.getIndex(tile.@tx / Assets.TILE_SIZE_X,
				tile.@ty / Assets.TILE_SIZE_Y));
			}
			
			mask = grid = new Grid(map.width, map.height, Assets.TILE_SIZE_X, Assets.TILE_SIZE_Y);
			
			// set the mask property
			for each (var solid:XML in map.solid[0].rect)
			{
				grid.setRect(solid.@x / Assets.TILE_SIZE_X,
							solid.@y / Assets.TILE_SIZE_Y,
							solid.@w / Assets.TILE_SIZE_X,
							solid.@h / Assets.TILE_SIZE_Y);
			}
		}
		
	}

}