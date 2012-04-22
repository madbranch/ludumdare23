package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.FX.*;
	
	public class Level extends FlxGroup
	{
		// We load the tile map information.
		[Embed(source='/../resources/mapCSV_Group1_Main.csv', mimeType='application/octet-stream')] public var mapCSV:Class;
		
		[Embed(source='/../resources/tileset.png')] public var TilesetGraphic:Class;
		
		private static const LEVEL_0_BG_COLOR:uint = 0xff444444;
		private static const LEVEL_1_BG_COLOR:uint = 0xff575290;
		private static const LEVEL_2_BG_COLOR:uint = 0xff85beff;
		
		public static const TILE_SIZE:Number = 8;
		public static const TILESET_WIDTH:int = 53;
		public static const TILESET_HEIGHT:int = 8;
		public static const TILESET_SIZE:int = TILESET_WIDTH * TILESET_HEIGHT;
		
		public var map:FlxTilemap;
		public var tigers:Tigers;
		public var star:Star;
		public var sun:Sun;
		public var leaf:Leaf;
		
		public var width:int;
		public var height:int;
		private var _currentLevel:int;
		private var _plasma:PlasmaFX;
		private var _soPretty:FlxSprite;
		
		public function Level()
		{
			super();
			
			FlxG.bgColor = LEVEL_0_BG_COLOR;
			
			map = new FlxTilemap();
			map.loadMap(new mapCSV, TilesetGraphic, TILE_SIZE, TILE_SIZE, FlxTilemap.OFF, 0, 1, TILESET_SIZE);

			initTileProperties();
			
			width = map.width - TILE_SIZE;
			height = map.height;
			
			_currentLevel = 0;
			
			if (FlxG.getPlugin(FlxSpecialFX) == null)
			{
				FlxG.addPlugin(new FlxSpecialFX);
			}
			
			_plasma = FlxSpecialFX.plasma();
			_soPretty = _plasma.create(0, 0, 109, 71, 8, 8);
			_soPretty.allowCollisions = FlxObject.NONE;
			
			initializeTigers();
			initializePickups();
			
			add(_soPretty);
			add(map);
			
			_soPretty.visible = false;
		}
		
		public override function update() : void
		{
			super.update();
			_soPretty.x = FlxG.camera.x;
			_soPretty.y = FlxG.camera.y;
		}
		
		public override function destroy() : void
		{
			super.destroy();
			
			_plasma.destroy();
			_plasma = null;
			
			FlxSpecialFX.clear();
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
			
			// We update the background color.
			switch (value)
			{
				case 0:
					FlxG.bgColor = LEVEL_0_BG_COLOR;
					break;
				case 1:
					FlxG.bgColor = LEVEL_1_BG_COLOR;
					break;
				default:
					FlxG.bgColor = LEVEL_2_BG_COLOR;
					break;
			}
			
			_soPretty.visible = (value == 3);
			
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
		
		public function getCurrentSpike() : uint
		{
			return _currentLevel * TILESET_WIDTH + 52;
		}
		
		private function initTileProperties() : void
		{
			var offset:int;
			for (var i:int = 0; i < TILESET_SIZE; i += TILESET_WIDTH)
			{
				map.setTileProperties(i, FlxObject.NONE);
				map.setTileProperties(1 + i, FlxObject.UP);
				for (var j : int = 2; j < TILESET_WIDTH; ++j)
				{
					map.setTileProperties(j + i, FlxObject.ANY);
				}
				map.setTileProperties(52 + i, FlxObject.NONE);
			}
			
			// Unlocked level 1 tiles.
			map.setTileProperties(TILESET_WIDTH * 1 + 49, FlxObject.NONE);
			
			// Unlocked level 2 tiles.
			map.setTileProperties(TILESET_WIDTH * 2 + 49, FlxObject.NONE);
			map.setTileProperties(TILESET_WIDTH * 2 + 50, FlxObject.NONE);
			
			// Unlocked level 3 tiles.
			map.setTileProperties(TILESET_WIDTH * 3 + 49, FlxObject.NONE);
			map.setTileProperties(TILESET_WIDTH * 3 + 50, FlxObject.NONE);
			map.setTileProperties(TILESET_WIDTH * 3 + 51, FlxObject.NONE);
		}
		
		private function initializeTigers() : void
		{
			tigers = new Tigers();
			
			tigers.addTiger(12, 11);
			tigers.addTiger(3, 22);
			tigers.addTiger(33, 15);
			tigers.addTiger(48, 16);
			tigers.addTiger(40, 18);
		}
		
		private function initializePickups() : void
		{
			star = new Star(3, 12);
			sun = new Sun(56, 3);
			leaf = new Leaf(27, 13);
		}
		
		public static function isTileIdCollidable(tileId:uint) : Boolean
		{
			return tileId % TILESET_WIDTH >= 2;
		}
	}
}