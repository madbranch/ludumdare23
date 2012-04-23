package
{
	import org.flixel.FlxGroup;
	
	public class ParticleManager extends FlxGroup
	{
		public static const NB_PARTICLES_MAX:uint = 4;
		
		private var currentIndex:uint;
		
		public function ParticleManager()
		{
			super(NB_PARTICLES_MAX);
			
			for (var i : uint = 0;i < NB_PARTICLES_MAX; ++i)
			{
				add(new Particle());
			}
			
			currentIndex = 0;
		}
		
		public function boom(bx:Number, by:Number) : void
		{
			Particle(members[currentIndex]).boom(bx, by);
			++currentIndex;
			
			if (currentIndex >= NB_PARTICLES_MAX)
			{
				currentIndex = 0;
			}
		}
	}
}