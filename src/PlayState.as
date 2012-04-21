package
{
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		private var player:Player;
		private var floor:FlxTileblock;
		
		override public function create():void
		{
			FlxG.bgColor = 0xff144954;
			
			player = new Player(20, 10);
			
			floor = new FlxTileblock(0, 100, 160, 20);
			floor.makeGraphic(160, 20, 0xff689c16);
			
			this.add(player);
			this.add(floor);
			
			FlxG.watch(player.acceleration, "x", "ax");
			FlxG.watch(player.velocity, "x", "vx");
			FlxG.watch(player.velocity, "y", "vy");
		}
		
		override public function update():void
		{
			super.update();
			
			FlxG.collide(player, floor);
		}
	}
}