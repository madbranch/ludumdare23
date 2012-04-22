package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Player extends FlxSprite
	{
		// Player's graphic.
		[Embed(source='/../resources/char.png')] private var PlayerGraphic:Class;
		// Cursor's graphic
		[Embed(source='/../resources/cursor.png')] private var CursorGraphic:Class;
		
		// Jump sound effects.
		[Embed(source = "/../resources/jump_01.mp3")] public var Jump1Sfx:Class;
		[Embed(source = "/../resources/jump_02.mp3")] public var Jump2Sfx:Class;
		[Embed(source = "/../resources/jump_03.mp3")] public var Jump3Sfx:Class;
		[Embed(source = "/../resources/jump_04.mp3")] public var Jump4Sfx:Class;
		
		public var tilePosition:FlxPoint;
		public var tileInFront:FlxPoint;
		public var nbTiles:uint;
		
		private var _cursor:FlxSprite;
		private var _currentLevel:int;
		private var _start:FlxPoint;
		
		/**
		 * Default and parameterized constructor.
		 * @param X Starting x position.
		 * @param Y Starting y position.
		 */
		public function Player(X:Number=0, Y:Number=0)
		{
			// We call FlxSprite's constructor.
			super(X * Level.TILE_SIZE, Y * Level.TILE_SIZE);
			
			_start = new FlxPoint(x, y);
			
			// We initialize the player's graphic.
			loadGraphic(PlayerGraphic, true, true, 5, 9, true);
			
			// We make the colliding box a bit smaller than the graphic.
			width = 3;
			height = 8;
			
			offset.x = 1;
			offset.y = 1;
			
			// We initialize the player's animations.
			addAnimation("idle", [0], 0, false);
			addAnimation("walk", [1, 2, 3, 2, 1, 4, 2], 20, true);
			addAnimation("jump", [3], 0, false);
			addAnimation("hurt", [5], 0, false);
			
			// We activate the plugin for the controls.
			if ( FlxG.getPlugin(FlxControl) == null)
			{
				FlxG.addPlugin(new FlxControl);
			}
			
			// We initialize the controls.
			FlxControl.create(this, FlxControlHandler.MOVEMENT_ACCELERATES, FlxControlHandler.STOPPING_DECELERATES, 1, true, false);
			
			FlxControl.player1.setCursorControl(false, false, true, true);
			FlxControl.player1.setJumpButton("UP", FlxControlHandler.KEYMODE_PRESSED, 100, FlxObject.FLOOR, 125, 100);
			FlxControl.player1.setMovementSpeed(200, 0, 50, 100, 200, 0);
			FlxControl.player1.setGravity(0, 200);
			
			var fs:FlxSound = new FlxSound();
			fs.loadEmbedded(Jump1Sfx);
			FlxControl.player1.setSounds(fs);
			
			// We initialize the cursor.
			_cursor = new FlxSprite(0, 0, CursorGraphic);
			
			// When created, the player faces right by default.
			facing = FlxObject.RIGHT;
		
			// We initialize the player's position in tiles.
			tilePosition = new FlxPoint();
			// We initialize position of the tile in front of the player.
			tileInFront = new FlxPoint();
			
			// We update the tile positions.
			updateTilePositions();
			
			// We initialize the initial number of tiles.
			nbTiles = 0;
			
			_currentLevel = 0; 
			
			// We initialize the variable watchers.
			FlxG.watch(tilePosition, "x", "tile X");
			FlxG.watch(tilePosition, "y", "tile Y");
			FlxG.watch(tileInFront, "x", "dst X");
			FlxG.watch(tileInFront, "y", "dst Y");
			FlxG.watch(this, "nbTiles", "nb of tiles");
		}
		
		public function restart() : void
		{
			reset(_start.x, _start.y);
		}
		
		override public function destroy(): void
		{
			super.destroy();
			_cursor.destroy();
			_cursor = null;
			tilePosition = null;
			tileInFront = null;
		}
		
		private function updateTilePositions():void
		{
			tilePosition.x = Math.floor((x) / Level.TILE_SIZE);
			tilePosition.y = Math.floor((y + height * 0.5) / Level.TILE_SIZE);
			if (facing & FlxObject.LEFT)
			{
				tileInFront.x = tilePosition.x - 1;
			}
			else if (facing & FlxObject.RIGHT)
			{
				tileInFront.x = tilePosition.x + 1;
			}
			tileInFront.y = tilePosition.y;
			_cursor.x = tileInFront.x * Level.TILE_SIZE;
			_cursor.y = tileInFront.y * Level.TILE_SIZE;
		}
		
		override public function update():void
		{
			super.update();
			_cursor.update();
			
			// We make sure the player doesn't leave the screen.
			if (x < 0)
			{
				x = 0;
			}
			else if (x + width > FlxG.camera.bounds.right)
			{
				x = FlxG.camera.bounds.right - width;
			}
			
			if (y < 0)
			{
				y = 0;
			}
			else if (y + height > FlxG.camera.bounds.bottom)
			{
				y = FlxG.camera.bounds.bottom - height;
			}
			
			updateTilePositions();
			
			// We set the animations according to the player's behaviour.
			if (touching == FlxObject.FLOOR)
			{
				if (velocity.x != 0)
				{
					play("walk");
				}
				else
				{
					play("idle");
				}
			}
			else if (velocity.y < 0)
			{
				play("jump");
			}
		}
		
		override public function preUpdate(): void
		{
			super.preUpdate();
			_cursor.preUpdate();
		}
		
		override public function postUpdate(): void
		{
			super.postUpdate();
			_cursor.postUpdate();
		}
		
		override public function draw(): void
		{
			super.draw();
			_cursor.draw();
		}
		
		public function get currentLevel(): int
		{
			return _currentLevel;
		}
		
		public function set currentLevel(value:int) : void
		{
			var fs:FlxSound = new FlxSound();
			switch (value)
			{
				case 0:
					fs.loadEmbedded(Jump1Sfx);
					break;
				case 1:
					fs.loadEmbedded(Jump2Sfx);
					break;
				case 2:
					fs.loadEmbedded(Jump3Sfx);
					break;
				case 3:
					fs.loadEmbedded(Jump4Sfx);
					break;
				default:
					fs.loadEmbedded(Jump1Sfx);
					break;
			}
			FlxControl.player1.setSounds(fs);
			_currentLevel = value;
		}
	}
}