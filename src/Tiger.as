package
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Sine;
	
	import org.flixel.*;
	
	public class Tiger extends FlxSprite
	{
		[Embed(source='/../resources/tiger_0.png')] private var Tiger0Graphic:Class;
		[Embed(source = "/../resources/tiger_kill.mp3")] private var KillSfx:Class;
		
		public var dying:Boolean = false;
		
		public function Tiger(X:uint=0, Y:uint=0)
		{
			super(X * Level.TILE_SIZE, Y * Level.TILE_SIZE);
			
			setCurrentLevel(0);
			
			addAnimation("walk", [0, 1], 6, true);
			play("walk");
			
			acceleration.y = 50;
			velocity.x = -30;
			facing = FlxObject.LEFT;
		}
		
		public override function kill(): void
		{
			FlxG.play(KillSfx);
			
			dying = true;
			
			frame = 1;
			
			velocity.x = 0;
			velocity.y = 0;
			
			angle = 180;
			
			TweenMax.to(this, 1.5, { bezier: [ {x:"64", y:"-64"}, {x:"80", y:"200"} ], onComplete: removeSprite } );
		}
		
		private function removeSprite() : void
		{
			exists = false;
		}
		
		public override function update(): void
		{
			super.update();
			
			var tx:uint = uint(x / Level.TILE_SIZE);
			var ty:uint = uint(y / Level.TILE_SIZE);
			
			if (facing == FlxObject.LEFT)
			{
				if (Level.isTileIdCollidable(Registry.level.map.getTile(tx - 1, ty)))
				{
					turnAround();
					return;
				}
			}
			else
			{
				if (Level.isTileIdCollidable(Registry.level.map.getTile(tx + 2, ty)))
				{
					turnAround();
					return;
				}
			}
			
			//if (!isTouching(FlxObject.FLOOR) && dying == false)
			//{
				//turnAround();
			//}
		}
		
		private function turnAround() : void
		{
			if (facing == FlxObject.RIGHT)
			{
				facing = FlxObject.LEFT;
				velocity.x = -30;
			}
			else
			{
				facing = FlxObject.RIGHT;
				velocity.x = 30;
			}
		}
		
		public function setCurrentLevel(newCurrentLevel:int):void
		{
			switch(newCurrentLevel)
			{
				case 0:
					loadGraphic(Tiger0Graphic, true, true, 16, 10);
					break;
			}
			width = 14;
			height = 8;
			offset.x = 1;
			offset.y = 2;
		}
	}
}