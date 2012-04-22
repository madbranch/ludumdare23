package
{
	import flash.display3D.IndexBuffer3D;
	import flash.globalization.CurrencyFormatter;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class PlayState extends FlxState
	{
		[Embed(source='/../resources/tileset.png')] public var TilesetGraphic:Class;
		[Embed(source='/../resources/press_a.png')] public var Level0ControlGraphic:Class;
		[Embed(source='/../resources/press_s.png')] public var Level1ControlGraphic:Class;
		[Embed(source='/../resources/press_d.png')] public var Level2ControlGraphic:Class;
		[Embed(source='/../resources/press_f.png')] public var Level3ControlGraphic:Class;
		private var player:Player;
		private var level:Level;
		private var score:FlxText;
		private var blockScore:FlxSprite;
		private var unlockedLevel:int = 0;
		private var level0Control:FlxSprite;
		private var level1Control:FlxSprite;
		private var level2Control:FlxSprite;
		private var level3Control:FlxSprite;
		
		override public function create():void
		{
			// We initialize the tile map.
			level = new Level();
			Registry.level = level;
			
			// We initialize the player at the right position.
			player = new Player(2, 8);
			
			// We tell Flixel how big our game world is.
			FlxG.worldBounds = new FlxRect(0, 0, level.width, level.height);
			
			// We make sure the camera doesn't wander off the edges of the map.
			FlxG.camera.setBounds(0, 0, level.width, level.height);
			
			// We make the camera follow the player.
			FlxG.camera.follow(player, FlxCamera.STYLE_PLATFORMER);
			
			score = new FlxText(0, FlxG.camera.height - (Level.TILE_SIZE + 4), FlxG.camera.width - (Level.TILE_SIZE + 1), "0");
			score.alignment = "right";
			score.color = 0xffffffff;
			score.shadow = 0xff000000;
			score.scrollFactor.x = 0;
			score.scrollFactor.y = 0;
			
			blockScore = new FlxSprite(FlxG.camera.width - (Level.TILE_SIZE + 1), FlxG.camera.height - (Level.TILE_SIZE + 1));
			blockScore.loadGraphic(TilesetGraphic, true, false, 8, 8);
			blockScore.addAnimation("0", [2]); 
			blockScore.addAnimation("1", [2 + Level.TILESET_WIDTH * 1]); 
			blockScore.addAnimation("2", [2 + Level.TILESET_WIDTH * 2]); 
			blockScore.addAnimation("3", [2 + Level.TILESET_WIDTH * 3]);
			blockScore.scrollFactor.x = 0;
			blockScore.scrollFactor.y = 0;
			blockScore.play("0");
			
			initializeControlDisplay();
			
			add(level);
			add(player);
			add(level.tigers);
			add(level.star);
			add(score);
			add(blockScore);
			add(level0Control);
			add(level1Control);
			add(level2Control);
			add(level3Control);
			
			setCurrentLevel(0);
			// Watches for debugging.
			//FlxG.watch(player.acceleration, "x", "ax");
			//FlxG.watch(player.velocity, "x", "vx");
			//FlxG.watch(player.velocity, "y", "vy");
			FlxG.watch(FlxG.camera.bounds, "width", "camera width");
			FlxG.watch(FlxG.camera.bounds, "height", "camera height");
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.justPressed("Z"))
			{
				if (level.map.getTile(player.tileInFront.x, player.tileInFront.y) == level.getCurrentEmpty() && player.nbTiles > 0)
				{
					level.map.setTile(player.tileInFront.x, player.tileInFront.y, level.getCurrentPickable(), true);
					--player.nbTiles;
					score.text = player.nbTiles.toString();
				}
			}
			else if (FlxG.keys.justPressed("X"))
			{
				if (level.map.getTile(player.tileInFront.x, player.tileInFront.y) == level.getCurrentPickable())
				{
					level.map.setTile(player.tileInFront.x, player.tileInFront.y, level.getCurrentEmpty(), true);
					++player.nbTiles;
					score.text = player.nbTiles.toString();
				}
			}
			else if (FlxG.keys.justPressed("A"))
			{
				setCurrentLevel(0);
			}
			else if (FlxG.keys.justPressed("S") && unlockedLevel >= 1)
			{
				setCurrentLevel(1);
			}
			else if (FlxG.keys.justPressed("D") && unlockedLevel >= 2)
			{
				setCurrentLevel(2);
			}
			else if (FlxG.keys.justPressed("F") && unlockedLevel >= 3)
			{
				setCurrentLevel(3);
			}
			
			// We make the player collide with the level.
			FlxG.collide(player, level);
			FlxG.collide(level.tigers, level);
			
			FlxG.overlap(player, level.tigers, hitTiger);
			if (level.star.alive)
			{
				FlxG.overlap(player, level.star, hitStar);
			}
		}
		
		public function setCurrentLevel(newCurrentLevel:int): void
		{
			if (newCurrentLevel != level.currentLevel)
			{
				FlxG.flash(0xffffffff, 0.7, null, true);
			}
			level.currentLevel = newCurrentLevel;
			player.currentLevel = newCurrentLevel;
			blockScore.play(newCurrentLevel.toString());
		}
		
		private function hitTiger(player : FlxObject, tiger : FlxObject) : void
		{
			if (Tiger(tiger).dying)
			{
				return;
			}
			
			if (player.y < tiger.y)
			{
				tiger.kill();
			}
			else
			{
				Player(player).restart();
				FlxG.flash(0xffff0000);
			}
		}
		
		private function hitStar(player : FlxObject, star : FlxObject) : void
		{
			setCurrentLevel(1);
			unlockedLevel = 1;
			refreshControlDisplay();
			level.star.kill();
		}
		
		private function initializeControlDisplay() : void
		{
			const space : int = 12;
			level0Control = new FlxSprite(1, FlxG.camera.height - (Level.TILE_SIZE + 1), Level0ControlGraphic);
			level0Control.scrollFactor.x = 0;
			level0Control.scrollFactor.y = 0;

			level1Control = new FlxSprite(level0Control.x + level0Control.width + space, FlxG.camera.height - (Level.TILE_SIZE + 1), Level1ControlGraphic);
			level1Control.scrollFactor.x = 0;
			level1Control.scrollFactor.y = 0;
			
			level2Control = new FlxSprite(level1Control.x + level1Control.width + space, FlxG.camera.height - (Level.TILE_SIZE + 1), Level2ControlGraphic);
			level2Control.scrollFactor.x = 0;
			level2Control.scrollFactor.y = 0;
			
			level3Control = new FlxSprite(level2Control.x + level2Control.width + space, FlxG.camera.height - (Level.TILE_SIZE + 1), Level3ControlGraphic);
			level3Control.scrollFactor.x = 0;
			level3Control.scrollFactor.y = 0;
			
			refreshControlDisplay();
		}
		
		private function refreshControlDisplay() : void
		{
			level0Control.visible = unlockedLevel >= 1;
			level1Control.visible = unlockedLevel >= 1;
			level2Control.visible = unlockedLevel >= 2;
			level3Control.visible = unlockedLevel >= 3;
		}
	}
}