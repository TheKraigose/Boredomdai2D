package entities 
{
	import entities.*;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class LowGuard extends Enemy 
	{
		public function LowGuard(_sx:int, _sy:int, _d:int=0) 
		{
			super(_sx, _sy);
			direction = _d;
			ssheet = new Spritemap(Assets.SPR_LOWGUARD, 24, 24);
			attackTimeMax = 300;
			health = 20;
			ssheet.add("stand_down", [0], 0, false);
			ssheet.add("stand_up", [3], 0, false);
			ssheet.add("stand_left", [9], 0, false);
			ssheet.add("stand_right", [6], 0, false);
			ssheet.add("move_down", [0, 1, 0, 2], 15, true);
			ssheet.add("move_up", [3, 4, 3, 5], 15, true);
			ssheet.add("move_right", [6, 7, 6, 8], 15, true);
			ssheet.add("move_left", [9, 10, 9, 11], 15, true);
			ssheet.add("shoot_down", [12, 13, 12], 15, false);
			ssheet.add("shoot_up", [18, 19, 18], 15, false);
			ssheet.add("shoot_right", [15, 16, 15], 15, false);
			ssheet.add("shoot_left", [21, 22, 21], 15, false);
			ssheet.add("dead", [24, 25, 26, 27], 15, false);
			
			graphic = ssheet;
			
			gibHealth = -5;
			pointsToPlayer = 100;
			
			speed = 2;
			
			if (Version.debugMode)
			{
				FP.world.add(new EnemyDebugText(this));
			}
		}
		
		public override function render():void
		{
			super.render();
			if (state == KIActor.STATE_SEEKING)
			{
				if (direction == 0 || direction == 1)
					ssheet.play("stand_right");
				else if (direction == 2 || direction == 3)
					ssheet.play("stand_up");
				else if (direction == 4 || direction == 5)
					ssheet.play("stand_left");
				else if (direction == 6 || direction == 7)
					ssheet.play("stand_down");
			}
			if (state == KIActor.STATE_CHASING)
			{
				if (direction == 0 || direction == 1)
					ssheet.play("move_right");
				else if (direction == 2 || direction == 3)
					ssheet.play("move_up");
				else if (direction == 4 || direction == 5)
					ssheet.play("move_left");
				else if (direction == 6 || direction == 7)
					ssheet.play("move_down");
			}
			if (state == KIActor.STATE_MISSILE)
			{
				if (direction == 0 || direction == 1)
					ssheet.play("shoot_right");
				else if (direction == 2 || direction == 3)
					ssheet.play("shoot_up");
				else if (direction == 4 || direction == 5)
					ssheet.play("shoot_left");
				else if (direction == 6 || direction == 7)
					ssheet.play("shoot_down");
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
					switch(A_Look(8))
					{
						default:
						case Enemy.FOUND_WALL:
						case Enemy.FOUND_NONE:
							state = KIActor.STATE_SEEKING;
							break;
						case Enemy.FOUND_PLAYER:
							state = KIActor.STATE_CHASING;
							break;
					}
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
				if (state == KIActor.STATE_MISSILE && distanceFrom(target) < 64 && distanceFrom(target) > 24 && attacktime == 0)
				{
					FP.world.add(new Bullet(centerX, centerY, direction, this));
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