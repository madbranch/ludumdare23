package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Level extends FlxGroup
	{
		// We load the tile map information.
		[Embed(source='/../resources/mapCSV_Group1_Main.csv', mimeType='application/octet-stream')] public var mapCSV:Class;
		
		[Embed(source='/../resources/tileset.png')] public var tilesetGraphic:Class;
		
		public static const TILE_SIZE:Number = 8;
		private static const TILESET_WIDTH:int = 18;
		private static const TILESET_HEIGHT:int = 8;
		private static const TILESET_SIZE:int = TILESET_WIDTH * TILESET_HEIGHT;
		
		public var map:FlxTilemap;
		
		public var width:int;
		public var height:int;
		private var _currentLevel:int;
		
		public function Level()
		{
			super(10);
			
			map = new FlxTilemap();
			map.loadMap(new mapCSV, tilesetGraphic, TILE_SIZE, TILE_SIZE, FlxTilemap.OFF, 0, 1, 144);

			initTileProperties();
			
			width = map.width - TILE_SIZE;
			height = map.height;
			
			add(map);
			
			_currentLevel = 0;
		}
		
		public function get currentLevel() : int
		{
			return _currentLevel;
		}
		
		public function set currentLevel(value : int) : void
		{
			// We calculate the value to add to each of the tiles' id's.
			const tileIdDelta : int = (value - _currentLevel) * TILESET_WIDTH;
			
			// We update the tile id's.
			for (var i:uint = 0; i < map.totalTiles; ++i)
			{
				map.setTileByIndex(i, map.getTileByIndex(i) + tileIdDelta);
			}
			
			// We update the current level.
			_currentLevel = value;
		}
		
		public function increaseLevel() : void
		{
			currentLevel = _currentLevel + 1;
		}
		
		public function getCurrentPickable() : uint
		{
			return _currentLevel * TILESET_WIDTH + 2;
		}
		
		public function getCurrentEmpty() : uint
		{
			return _currentLevel * TILESET_WIDTH;
		}
		
		private function initTileProperties() : void
		{
			var offset:int;
			for (var i:int = 0; i < TILESET_SIZE; i += TILESET_WIDTH)
			{
				map.setTileProperties(1 + i, FlxObject.UP);
				map.setTileProperties(2 + i, FlxObject.ANY);
			}
		}
	}
}