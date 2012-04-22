package
{
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		private var player:Player;
		private var level:Level;
		
		override public function create():void
		{
			FlxG.bgColor = 0xff444444;
			
			// We initialize the tile map.
			level = new Level();
			add(level);
			
			// We initialize the player.
			player = new Player(20, 10);
			add(player);
			
			// We tell Flixel how big our game world is.
			FlxG.worldBounds = new FlxRect(0, 0, level.width, level.height);
			
			// We make sure the camera doesn't wandef off the edges of the map.
			FlxG.camera.setBounds(0, 0, level.width, level.height);
			
			// We make the camera follow the player.
			FlxG.camera.follow(player, FlxCamera.STYLE_PLATFORMER);
			
			// Watches for debugging.
			//FlxG.watch(player.acceleration, "x", "ax");
			//FlxG.watch(player.velocity, "x", "vx");
			//FlxG.watch(player.velocity, "y", "vy");
		}
		
		override public function update():void
		{
			super.update();
			
			// We make the player collide with the level.
			FlxG.collide(player, level);
			
			if (FlxG.keys.justPressed("Z"))
			{
				if (level.map.getTile(player.tileInFront.x, player.tileInFront.y) == level.getCurrentEmpty() && player.nbTiles > 0)
				{
					level.map.setTile(player.tileInFront.x, player.tileInFront.y, level.getCurrentPickable(), true);
					--player.nbTiles;
				}
			}
			else if (FlxG.keys.justPressed("X"))
			{
				if (level.map.getTile(player.tileInFront.x, player.tileInFront.y) == level.getCurrentPickable())
				{
					level.map.setTile(player.tileInFront.x, player.tileInFront.y, level.getCurrentEmpty(), true);
					++player.nbTiles;
				}
			}
			else if (FlxG.keys.justPressed("T"))
			{
				setCurrentLevel(0);
			}
			else if (FlxG.keys.justPressed("Y"))
			{
				setCurrentLevel(1);
			}
			else if (FlxG.keys.justPressed("U"))
			{
				setCurrentLevel(2);
			}
			else if (FlxG.keys.justPressed("I"))
			{
				setCurrentLevel(3);
			}
		}
		
		public function setCurrentLevel(newCurrentLevel:int): void
		{
			level.currentLevel = newCurrentLevel;
			player.currentLevel = newCurrentLevel;
		}
	}
}