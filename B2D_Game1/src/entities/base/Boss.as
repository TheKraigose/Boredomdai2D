package entities.base 
{
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class Boss extends Enemy 
	{
		protected var EndsLevel:Boolean = true;
		protected var timeTillExit:int = 0;
		protected var timeExitMax:int = 64;
		
		public function Boss(_sx:int, _sy:int, w:int=24, h:int=24) 
		{
			super(_sx, _sy);
			setHitbox(w, h, -(w / 2), 0);
			speed = 2;
		}
		
		protected function A_PlayBossSound(_type:int=KIActor.CHAN_CHASE):void
		{
			A_PlaySound(_type, 0.5);
		}
		
		protected function EndLevel():void
		{
			var lstPlayers:Array = new Array();
			FP.world.getClass(Player, lstPlayers);
			lstPlayers[0].toggleIntermission();
		}
		
		protected function A_BossLook(tileamt:int = 8):int
		{
			var rs:int = Enemy.FOUND_NONE;
			var ctx:int = Math.ceil(x / 24);
			var cty:int = Math.ceil(y / 24);
			
			return AI_CheckRadius(ctx, cty, tileamt);
		}
		
		
		// Will be used to eventually show Boss Obituaries like
		// in Rise of the Triad. Overridden by each
		// boss for customize.
		
		// call EndLevel() sometime though. For now
		// it's the default "sequence".
		protected function BossDeathSequence():void
		{
			EndLevel();
		}
		
		public override function checkPlayerProjectileCollide():void
		{
			var prj:Projectile = collide("playermissile", x, y) as Projectile;
			if (prj && ((state != KIActor.STATE_PAIN) || state != KIActor.STATE_DEAD))
			{
				state = KIActor.STATE_PAIN;
				health -= prj.getDamage();
				if (health <= 0)
				{
					state = KIActor.STATE_DEAD;
					prj.givePlayerPoints(pointsToPlayer);
				}
				FP.world.remove(prj);
			}
		}
		
		public override function removed():void
		{
			if (EndsLevel)
			{
				if (health <= 0)
				{
					BossDeathSequence();
				}
			}
			super.removed();
		}
		
		private function AI_CheckRadius(tx:int, ty:int, tam:int):int
		{
			var retstate:int = Enemy.FOUND_NONE;
			var slicecount:int;
			var wallcount:int;
			var i:int;
			var j:int;
			
			for (j = ty - tam; j <= ty + tam; j++)
			{
				for (i = tx - tam; i <= tx + tam; i++)
				{
					if (checkIfPlayerCollide(i, j))
					{
						retstate = Enemy.FOUND_PLAYER;
					}
				}
			}
			
			/**var k:int;
			var l:int;
			
			for (l = ty + tam; l >= ty; l--)
			{
				for (k = tx + tam; k <= tx + tam; k++)
				{
					if (checkIfPlayerCollide(k, l))
					{
						retstate = Enemy.FOUND_PLAYER;
					}
				}
			}**/
			
			return retstate;
		}

		public override function update():void
		{
			super.update();
		}
	}

}