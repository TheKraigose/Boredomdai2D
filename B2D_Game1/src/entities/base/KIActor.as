/**
 * Kraigose Studios/Kraigose Interactive License
 * 
 * This software is under an MIT-like license:
 * 
 * 1.) You may use the source code files for any purpose but you must credit Kraig Culp for the code with this header.
 * 2.) This code comes without a warranty of any kind.
 * 
 * Written by Kraig "Kraigose" Culp 2011, 2012
 */

package entities.base 
{
	import entities.debug.RaycastShot;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Draw;
	import util.Angle;
	
	/**
	 * A Kraigose Interactive Actor
	 * @author Kraig Culp
	 */
	public class KIActor extends Entity 
	{
		// Constants for direction.
		public static const DIR_NONE:int = -1;
		public static const DIR_EAST:int = 0;
		public static const DIR_NORTH:int = 2;
		public static const DIR_WEST:int = 4;
		public static const DIR_SOUTH:int = 6;
		public static const DIR_N_E:int = 1;
		public static const DIR_N_W:int = 3;
		public static const DIR_S_W:int = 5;
		public static const DIR_S_E:int = 7;
		
		// Constants for states.
		public static const STATE_PROPNONE:int = -1;
		public static const STATE_SEEKING:int = 0;
		public static const STATE_CHASING:int = 1;
		public static const STATE_MISSILE:int = 2;
		public static const STATE_MELEE:int = 3;
		public static const STATE_PAIN:int = 4;
		public static const STATE_DEAD:int = 5;
		public static const STATE_GIBS:int = 6;
		
		// Constants for sound channels.
		public static const CHAN_CHASE:int = 1;
		public static const CHAN_TAUNT:int = 2;
		public static const CHAN_MELEE:int = 4;
		public static const CHAN_SHOOT:int = 8;
		public static const CHAN_PAIN:int = 16;
		public static const CHAN_DEAD:int = 32;
		public static const CHAN_XDEAD:int = 64;
		
		protected var direction:int;					// Direction variable.
		protected var health:int;						// Health. All actors have health. How it's used is up to the subclasses.
		protected var target:Entity;					// Player target
		protected var damage:int = 0;					// Damage dealt. All actors have a damage variable.
		protected var flagForRemoval:Boolean = false;	// If true, will be removed.
		protected var state:int;						// State variable. additional states can be made based on the actor as long as they're greater than 6.
		protected var angle:int;						// Rotation Angle in degrees [since FP uses degrees]. Radians are converted using util/Angle.as
		protected var gibHealth:int = -5;				// Default gibbing health		
		protected var ssheet:Spritemap;					// Every entity has a sprite sheet. use this instead of creating a new one in most cases.
		protected var speed:int;						// Speed of travel in pixels
		
		// Sound effects
		protected var sfxSee:Sfx;
		protected var sfxPain:Sfx;
		protected var sfxDead:Sfx;
		protected var sfxTaunt:Sfx;
		protected var sfxMelee:Sfx;
		protected var sfxHScan:Sfx;
		protected var sfxGibbing:Sfx;
		// End Sound effects
		
		public function KIActor(_sx:int, _sy:int, _w:int=24,_h:int=24) 
		{
			super(_sx, _sy);
			type = "none";
			setHitbox(_w, _h);
			setOrigin((halfWidth),(halfHeight));
			state = KIActor.STATE_PROPNONE;
			direction = KIActor.DIR_NONE;
			sfxGibbing = new Sfx(Assets.SFX_GIBBING);
		}
		
		/**
		 * Play a sound if one is available.
		 * @param	_type channel to operate on.
		 * @param	_v volume to play sound at (0.1-1.0)
		 */
		public function A_PlaySound(_type:int=KIActor.CHAN_CHASE, _v:Number=0.35):void
		{
			if (Options.soundFxEnabled)
			{
				var vol:Number = Options.soundFxVolume * _v;
				
				if (_type == KIActor.CHAN_CHASE && sfxSee != null)
					sfxSee.play(vol);
				else if (_type == KIActor.CHAN_TAUNT && sfxTaunt != null)
					sfxTaunt.play(vol);
				else if (_type == KIActor.CHAN_MELEE && sfxMelee != null)
					sfxMelee.play(vol);
				else if (_type == KIActor.CHAN_SHOOT && sfxHScan != null)
					sfxHScan.play(vol);
				else if (_type == KIActor.CHAN_PAIN && sfxPain != null)
					sfxPain.play(vol);
				else if (_type == KIActor.CHAN_DEAD && sfxDead != null)
					sfxDead.play(vol);
				else if (_type == KIActor.CHAN_XDEAD && sfxGibbing != null)
					sfxGibbing.play(vol);
			}
		}
		
		/**
		 * Stop all KIActor inherited sounds playing to prevent overlap.
		 */
		public function A_StopAllSounds():void
		{
			if (sfxSee != null)
				sfxSee.stop();
			if (sfxTaunt != null)
				sfxTaunt.stop();
			if (sfxMelee != null)
				sfxMelee.stop();
			if (sfxHScan != null)
				sfxHScan.stop();
			if (sfxPain != null)
				sfxPain.stop();
			if (sfxDead != null)
				sfxDead.stop();
			if (sfxGibbing != null)
				sfxGibbing.stop();
		}
		
		/**
		 * Stop a specific KIActor sound.
		 * @param	_type Channel to stop
		 */
		public function A_StopSound(_type:int=KIActor.CHAN_CHASE):void
		{
			if (_type == KIActor.CHAN_CHASE && sfxSee != null)
				sfxSee.stop();
			else if (_type == KIActor.CHAN_TAUNT && sfxTaunt != null)
				sfxTaunt.stop();
			else if (_type == KIActor.CHAN_MELEE && sfxMelee != null)
				sfxMelee.stop();
			else if (_type == KIActor.CHAN_SHOOT && sfxHScan != null)
				sfxHScan.stop();
			else if (_type == KIActor.CHAN_PAIN && sfxPain != null)
				sfxPain.stop();
			else if (_type == KIActor.CHAN_DEAD && sfxDead != null)
				sfxDead.stop();
			else if (_type == KIActor.CHAN_XDEAD && sfxGibbing != null)
				sfxGibbing.stop();
		}
		
		/**
		 * Generic function for playing the pain sound.
		 */
		public function A_Pain():void
		{
			A_PlaySound(KIActor.CHAN_PAIN);
		}
		
		/**
		 * Generic function for playing the death sound.
		 */
		public function A_Scream():void
		{
			A_PlaySound(KIActor.CHAN_DEAD);
		}
		
		/**
		 * Generic function for playing the proper XDeath sound.
		 */
		public function A_Smitheroons():void
		{
			if (health <= gibHealth && state == KIActor.STATE_GIBS)
			{
				A_PlaySound(KIActor.CHAN_XDEAD);
			}
			else
			{
				A_PlaySound(KIActor.CHAN_DEAD);
			}
		}
		
		/**
		 * Set angle based on the current direction set.
		 */
		public function R_SetAngleFromDir():void
		{
			if (direction != -1)
				angle = direction * 45;
			else if (direction == -1)
				angle = 0;
		}
		
		/**
		 * Turn towards direction the KIActor wishes to face.
		 */
		public function R_TurnTowardsDirection():void
		{
			if (Angle.AU_CheckAngleRange(angle) != direction * 45)
			{
				if (angle < direction * 45)
				{
					angle += speed;
				}
				else if (angle > direction * 45)
				{
					angle -= speed;
				}
			}
		}
		
		/**
		 * Shoot a hitscan attack based on the direction the KIActor is facing.
		 * @param	_distact Distance to fire.
		 * @param	_dam Damage to deal. Use negative amounts to heal.
		 */
		public function P_ShootHitScan(_distact:int = 8, _dam:int = 4 ):void
		{
			A_PlaySound(KIActor.CHAN_SHOOT);
			var rx:int = x;
			var ry:int = y;
			
			var ox:int = rx;
			var oy:int = ry;
			
			var dist:int = _distact * Assets.TILE_SIZE_X;
			var hit:Boolean = false;
			
			while (FP.distance(ox, oy, rx, ry) <= dist)
			{
				rx += Math.cos(Angle.AU_DegreesToRadians(angle)) * Assets.TILE_SIZE_X;
				ry -= Math.sin(Angle.AU_DegreesToRadians(angle)) * Assets.TILE_SIZE_Y;
				
				if (collide("solid", rx, ry))
				{
					FP.world.add(new RaycastShot(ox, oy, rx, ry));
					hit = true;
					break;
				}
				
				if (this is Enemy && !hit)
				{
					var pl:Player = collide("player", rx, ry) as Player;
					if (pl && pl.isAlive())
					{
						pl.takeHealthFromHitscan(_dam, this);
						hit = true;
						FP.world.add(new RaycastShot(ox, oy, rx, ry));
						break;
					}
				}
				else if (this is Player && !hit)
				{
					var en:Enemy = collide("enemy", rx, ry) as Enemy;
					if (en && en.isAlive())
					{
						en.takeHealthFromHitscan(_dam, this);
						hit = true;
						FP.world.add(new RaycastShot(ox, oy, rx, ry));
						break;
					}
				}
			}
			
			if (!hit)
				FP.world.add(new RaycastShot(ox, oy, rx, ry));
		}
		
		public override function render():void
		{
			super.render();
			if(Version.debugMode)
				Draw.rect(x - originX, y - originY, width, height, 0xFF0000, 0.5);
		}
		
		// All subclasses should call super.update()
		// Once the object is dead/served it's
		// purpose/etc.
		public override function update():void
		{
			if (flagForRemoval)
				FP.world.remove(this);
		}
		
	}

}