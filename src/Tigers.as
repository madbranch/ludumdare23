package
{
	import org.flixel.FlxGroup;
	
	public class Tigers extends FlxGroup
	{
		public function Tigers()
		{
			super();
		}
		
		public function addTiger(x:uint, y:uint) : void
		{
			add(new Tiger(x, y));
		}
	}
}