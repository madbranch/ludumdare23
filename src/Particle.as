package
{
	import org.flixel.FlxEmitter;
	
	public class Particle extends FlxEmitter
	{
		// Block particles.
		[Embed(source = "/../resources/particle.png")] public var ParticleGraphic:Class;
		
		public function Particle(X:Number=0, Y:Number=0)
		{
			super(X, Y, 20);
			
			makeParticles(ParticleGraphic, 10, 8, false, 0);
		}
		
		public function boom(bx:Number, by:Number) : void
		{
			x = bx;
			y = by;
			start(true, 0.3);
		}
	}
}