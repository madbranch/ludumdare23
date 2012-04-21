package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Player extends FlxSprite
	{
		// Player's graphic.
		[Embed(source='/../resources/char.png')] private var PlayerGraphic:Class;
		
		public function Player(X:Number=0, Y:Number=0)
		{
			// We call FlxSprite's constructor.
			super(X, Y);
			
			// We initialize the player's graphic.
			this.loadGraphic(PlayerGraphic, true, true, 5, 9, true);
			
			this.width = 3;
			this.height = 8;
			
			this.offset.x = 1;
			this.offset.y = 1;
			
			// We initialize the player's animations.
			this.addAnimation("idle", [0], 0, false);
			this.addAnimation("walk", [1, 2, 3, 2, 1, 4, 2], 20, true);
			this.addAnimation("jump", [3], 0, false);
			this.addAnimation("hurt", [5], 0, false);
			
			// We activate the plugin for the controls.
			if ( FlxG.getPlugin(FlxControl) == null)
			{
				FlxG.addPlugin(new FlxControl);
			}
			
			FlxControl.create(this, FlxControlHandler.MOVEMENT_ACCELERATES, FlxControlHandler.STOPPING_DECELERATES, 1, true, false);
			
			FlxControl.player1.setCursorControl(false, false, true, true);
			FlxControl.player1.setJumpButton("SPACE", FlxControlHandler.KEYMODE_PRESSED, 100, FlxObject.FLOOR, 125, 100);
			FlxControl.player1.setMovementSpeed(200, 0, 50, 100, 200, 0);
			FlxControl.player1.setGravity(0, 200);
			
			this.facing = FlxObject.RIGHT;
		}
		
		override public function update():void
		{
			super.update();
			
			if (x < 0)
			{
				x = 0;
			}
			
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
	}
}