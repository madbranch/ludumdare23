package
{
	import org.flixel.*;
	
	public class Star extends FlxSprite
	{
		// Star's graphic.
		[Embed(source='/../resources/star.png')] private var StarGraphic:Class;
		
		// Pickup sound;
		[Embed(source = "/../resources/pickup_star.mp3")] public var PickupSfx:Class;
		
		public function Star(X:Number=0, Y:Number=0)
		{
			super();
			
			loadGraphic(StarGraphic, true, false, 23, 25, true);
			
			addAnimation("idle", [0, 0, 1, 2, 1], 6);
			play("idle");
			
			width = 8;
			height = 8;
			offset.x = 8;
			offset.y = 8;
			
			x = X * Level.TILE_SIZE;
			y = Y * Level.TILE_SIZE;
			
			solid = true;
		}
		
		public override function kill() : void
		{
			FlxG.play(PickupSfx);
			
			super.kill();
		}
	}
}