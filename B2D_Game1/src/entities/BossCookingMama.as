package entities 
{
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.Sfx;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class BossCookingMama extends Boss 
	{
		
		public function BossCookingMama(_sx:int, _sy:int, _elf:Boolean) 
		{
			super(_sx, _sy);
			ssheet = new Spritemap(Assets.CMAMA_SPR, 24, 24);
			
			ssheet.add("stand", [0], 0, false);
			ssheet.add("walk", [0, 1, 0, 2], 10, true);
			ssheet.add("attack", [3, 4, 5, 3], 10, true);
			ssheet.add("death", [6, 7, 8], 10, false);
			
			graphic = ssheet;
			
			sfxSee = new Sfx(Assets.SFX_CMAMA_DESSERT);
			sfxPain = new Sfx(Assets.SFX_CMAMA_PAIN);
			sfxDead = new Sfx(Assets.SFX_CMAMA_BETTER);
			sfxTaunt = new Sfx(Assets.SFX_CMAMA_TAUNT);
			
			ssheet.play("stand");
			EndsLevel = _elf;
			attackTimeMax = 128;
			timeExitMax = 128;
			health = 640;
			setHitbox(width, height, -(width / 2), 0);
			pointsToPlayer = 2000;
			
			speed = 3;
			
			if (Version.debugMode)
			{
				FP.world.add(new EnemyDebugText(this));
			}
		}
		
		// The beastly update function for
		// Zalgorfield.
		public override function update():void
		{
			if (health > 0)
			{
				checkPlayerProjectileCollide();
				if (target == null)
				{
					var playerList:Array = [];
					FP.world.getClass(Player, playerList);
					target = playerList[0];
				}
				if (state == KIActor.STATE_SEEKING)
				{
					calcDirection();
					if (state == KIActor.STATE_SEEKING)
					{
						switch(A_BossLook())
						{
							default:
							case Enemy.FOUND_WALL:
							case Enemy.FOUND_NONE:
								state = KIActor.STATE_SEEKING;
								break;
							case Enemy.FOUND_PLAYER:
								A_PlayBossSound(KIActor.CHAN_CHASE);
								state = KIActor.STATE_CHASING;
								break;
						}
					}
				}
				if (state == KIActor.STATE_CHASING)
				{
					if (taunttime >= 256)
					{
						if (!sfxTaunt.playing || !sfxSee.playing)
						{
							if (Math.ceil(Math.random() * 2) == 1)
								A_PlayBossSound(KIActor.CHAN_TAUNT);
							else
								A_PlayBossSound(KIActor.CHAN_CHASE);
						}
						taunttime = 0;
					}
					
					A_Chase();
					if (distanceFrom(target) < 64 && distanceFrom(target) > 24)
					{
						state = KIActor.STATE_MISSILE;
					}
					if (distanceFrom(target) < 6)
					{
						state = KIActor.STATE_MELEE;
					}
					
					taunttime++;
				}
				if (state == KIActor.STATE_MELEE && distanceFrom(target) < 6)
				{
					ssheet.play("attack");
					attacktime++;
					if (attacktime >= attackTimeMax)
					{
						ssheet.play("walk");
						attacktime = 0;
						state = KIActor.STATE_CHASING;
					}
				}
				else if (state == KIActor.STATE_MISSILE && distanceFrom(target) < 64 && distanceFrom(target) > 24)
				{
					ssheet.play("attack");
					
					if (attacktime <= 96)
						attacktime += 4;
					else
						attacktime += 1;
					
					if ((attacktime % 24) == 0 && (attacktime <= 96))
					{
						FP.world.add(new Bullet(x + 12, y + 12, direction, this));
					}
					
					if (attacktime >= attackTimeMax)
					{
						ssheet.play("walk");
						attacktime = 0;
						state = KIActor.STATE_CHASING;
					}
				}
				else
				{
					ssheet.play("walk");
					attacktime = 0;
					if (state == KIActor.STATE_MELEE || state == KIActor.STATE_MISSILE)
						state = KIActor.STATE_CHASING;
				}
				
				if (state == KIActor.STATE_PAIN)
				{
					if (paintime == 0)
					{
						A_PlayBossSound(KIActor.CHAN_PAIN);
					}
					paintime++;
					
					if (paintime >= painTimeMax)
					{
						state = KIActor.STATE_CHASING;
						paintime = 0;
						Spritemap(graphic).alpha = 1;
						Spritemap(graphic).color = 0xFFFFFF;
					}
				}
			}
			else
			{
				if (state == KIActor.STATE_DEAD)
				{
					if (removaltime == 0)
					{
						A_StopSound(KIActor.CHAN_PAIN);
						A_PlayBossSound(KIActor.CHAN_DEAD);
						addMonsterKill();
						ssheet.play("death");
					}
					removaltime++;
					if (removaltime >= REM_TIME_MAX)
					{
						flagForRemoval = true;
					}
				}
				target = null;
			}
			super.update();
		}
		
		/** public override function update():void
		{
			if (health > 0)
			{
				checkPlayerProjectileCollide();
				if (target == null)
				{
					var playerList:Array = [];
					world.getClass(Player, playerList);
					for each(var p:Player in playerList)
					{
						if (distanceFrom(p, true) < 64)
						{
							CMamaSee(p);
							if (p != null)
							{
								target = p;
								break;
							}
						}
					}
				}
				else
				{
					CMamaSee(target);
				}
			}
			else
			{
				super.update();
			}
		}**/
		
	}

}