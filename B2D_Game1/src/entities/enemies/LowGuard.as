package entities.enemies 
{
	import entities.*;
	import entities.base.*;
	import entities.debug.EnemyDebugText;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Draw;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class LowGuard extends Enemy 
	{
		public function LowGuard(_sx:int, _sy:int, _d:int=0) 
		{
			super(_sx, _sy, 24, 24);
			
			direction = _d;
			ssheet = new Spritemap(Assets.SPR_LOWGUARD, 24, 24);
			attackTimeMax = 300;
			health = 6;
			
			sfxHScan = new Sfx(Assets.SFX_BULLET);
			
			ssheet.add("walk", [0], 0, false);
			ssheet.add("fire", [1, 0], 15, false);
			ssheet.add("pain", [2], 0, false);
			ssheet.add("dead", [2, 3, 4, 5], 15, false);
			
			graphic = ssheet;
			
			gibHealth = -5;
			pointsToPlayer = 100;
			
			speed = 1;
			damage = 2;
			
			R_SetAngleFromDir();
			
			if (Version.debugMode)
			{
				FP.world.add(new EnemyDebugText(this));
			}
		}
		
		public override function render():void
		{
			super.render();
			
			if (state == KIActor.STATE_SEEKING || state == KIActor.STATE_CHASING)
			{
				ssheet.play("walk");
			}
			if (state == KIActor.STATE_MISSILE)
			{
				ssheet.play("fire");
			}
			if (state == KIActor.STATE_PAIN)
			{
				ssheet.play("pain");
			}
			if (state == KIActor.STATE_DEAD)
			{
				ssheet.play("dead");
			}
		}
		
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
					A_Look(8)
				}
				if (state == KIActor.STATE_CHASING)
				{
					A_Chase();
					
					if (attacktime > 0)
						attacktime += 8;
						
					if (attacktime >= attackTimeMax)
						attacktime = 0;
					
					if (distanceFrom(target) < 64 && distanceFrom(target) > 24 && attacktime == 0)
					{
						state = KIActor.STATE_MISSILE;
					}
				}
				if ((state == KIActor.STATE_MISSILE || state == KIActor.STATE_MISSILE) && distanceFrom(target) < 64 && distanceFrom(target) > 24 && attacktime == 0)
				{
					P_ShootHitScan(8, Math.random() * 5);
					state = KIActor.STATE_CHASING;
					attacktime += 2;
				}
				if (state == KIActor.STATE_PAIN)
				{
					if (paintime == 0)
					{
						Spritemap(graphic).alpha = 0.5;
						Spritemap(graphic).color = 0xFF0000;
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
						addMonsterKill();
					}
					removaltime++;
					if (removaltime >= REM_TIME_MAX)
					{
						flagForRemoval = true;
					}
				}
				target = null;
			}
		}
		
	}

}