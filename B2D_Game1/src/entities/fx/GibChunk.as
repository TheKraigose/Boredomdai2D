package entities.fx 
{
	import entities.base.*;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Emitter;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	
	// GibChunk Class
	// The GibChunk is like a projectile. 
	// Unlike a projectile, it really doesn't do
	// any collision detection. Instead, it
	// serves as a particle emitter and a
	// special effects entity, showing the
	// enemy who spawned it is very much
	// destroyed.
	public class GibChunk extends KIActor 
	{
		// Emitter and Assets
		private var em:Emitter;
		// End Emitter and Assets
		
		private const SPEED_TO_MOVE:int = 3;	// Const for the speed for the gib to move
		
		private var bloodtime:int = 0;			// bloodtime makes it so we don't spam particles.
		private const BLOOD_INTERVALS:int = 8;	// A constant for controlling the amount of blood particles.
		
		private var removetime:int = 0;			// Remove time, to remove the gib after some time.
		private const REMOVE_TIME_MAX:int = 24;	// A constant for controlling when the object is removed.
		
		// Constructor.
		public function GibChunk(_sx:int, _sy:int, _dir:int, _clr:uint) 
		{
			super(_sx, _sy);
			layer = 6;
			graphic = new Image(Assets.SPR_GIB);
			direction = _dir;
			em = new Emitter(Assets.SPR_PARTICLE, 8, 8);
			em.newType("blood", [0]);
			em.setAlpha("blood", 1, 0);
			em.setMotion("blood", 0, 0, 1, 15, 5, 1);
			em.setColor("blood", _clr);
		}
		
		// The beastly update function.
		public override function update():void
		{
			// Check if we should emit a blood
			// particle.
			if (bloodtime == 0)
				em.emit("blood", x, y);
			else if (bloodtime >= BLOOD_INTERVALS)
				bloodtime = -1;
			bloodtime += 1;
			
			// Check if it needs removed.
			if (removetime >= REMOVE_TIME_MAX)
				FP.world.remove(this);	
			removetime++;
				
			if (direction == 0)
				x += SPEED_TO_MOVE;
			else if (direction == 1)
			{
				x += SPEED_TO_MOVE;
				y += SPEED_TO_MOVE;
			}
			else if (direction == 2)
				y += SPEED_TO_MOVE;
			else if (direction == 3)
			{
				x -= SPEED_TO_MOVE;
				y += SPEED_TO_MOVE;
			}
			else if (direction == 4)
				x -= SPEED_TO_MOVE;
			else if (direction == 5)
			{
				x -= SPEED_TO_MOVE;
				y -= SPEED_TO_MOVE;
			}
			else if (direction == 6)
				y -= SPEED_TO_MOVE;
			else if (direction == 7)
			{
				x += SPEED_TO_MOVE;
				y -= SPEED_TO_MOVE;
			}
			else
				x += SPEED_TO_MOVE;
			
			// Check if the GibChunk is out of bounds.
			/* if (x < 0 || y < 0 || x > FP.width || y > FP.height)
				FP.world.remove(this); */
		}
		
		// Render function calls a super.render()
		// and updates the emitter.
		public override function render():void
		{
			super.render();
			em.render(FP.buffer, new Point, FP.camera);
		}
		
	}

}