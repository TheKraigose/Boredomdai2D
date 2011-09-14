package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class Pushwall extends KIActor 
	{
		private var tm:Tilemap;
		private var waspushed:Boolean;
		private var stopped:Boolean;
		private var tag:int;
		private var traveltime:int;
		private const TRAVEL_TIME_MAX:int = 96;
		private var sfxPWall:Sfx = new Sfx(Assets.SFX_PWALL);
		private var isSecret:Boolean;
		
		public function Pushwall(_sx:int, _sy:int, tx:int, ty:int) 
		{
			super(_sx, _sy);
			type = "solid";
			graphic = tm = new Tilemap(Assets.TILESET, 24, 24, Assets.TILE_SIZE_X, Assets.TILE_SIZE_Y);
			setHitbox(Assets.TILE_SIZE_X, Assets.TILE_SIZE_Y);
			waspushed = false;
			stopped = false;
			var lstPlayer:Array = [];
			FP.world.getClass(Player, lstPlayer);
			target = lstPlayer[0];
			tm.setTile(0, 0, tm.getIndex(tx / Assets.TILE_SIZE_X, ty / Assets.TILE_SIZE_Y));
			isSecret = true;
		}
		
		public function push():void
		{
			if (!waspushed && tag <= 0)
			{
				waspushed = true;
				if (collideWith(target, x + 24, y))
					direction = 4;
				else if (collideWith(target, x - 24, y))
					direction = 0;
				else if (collideWith(target, x, y - 24))
					direction = 6;
				else if (collideWith(target, x, y + 24))
					direction = 2;
				else
				{
					direction = -1;
					waspushed = false;
				}
			}
		}
		
		public function trigger(ttc:int):void
		{
			if (ttc == tag)
				waspushed = true;
		}
		
		public function getSndPlaying():Boolean
		{
			return sfxPWall.playing;
		}
		
		public function addSecretPushed():void
		{
			var im:Array = [];
			FP.world.getClass(Intermission, im);
			im[0].setSecretFound();
			isSecret = false;
		}
		
		public override function update():void
		{
			var pwobj:PWallTagObj = collide("pwalltag", x, y) as PWallTagObj;
			if (pwobj)
			{
				tag = pwobj.GetTag();
				direction = pwobj.GetDirection();
				FP.world.remove(pwobj);
				isSecret = false;
				var im:Array = [];
				FP.world.getClass(Intermission, im);
				if (!isSecret)
				{
					im[0].subFromSecretTotal();
				}
			}
			
			if (waspushed && !stopped)
			{
				if (isSecret)
				{
					addSecretPushed();
				}
				if (Assets.pushwallSoundCount < Assets.PWALL_SND_LIMIT && traveltime <= (TRAVEL_TIME_MAX / 2))
				{
					if (Options.soundFxEnabled)
						sfxPWall.loop(0.35 * Options.soundFxVolume);
						
					Assets.pushwallSoundCount++;
				}
				
				if (direction == 0 && !collide("solid", x + 1, y) && !collideWith(target, x + 1, y))
				{
					x++;
				}
				else if (direction == 2 && !collide("solid", x, y - 1) && !collideWith(target, x, y - 1))
				{
					y--;
				}
				else if (direction == 4 && !collide("solid", x - 1, y) && !collideWith(target, x - 1, y))
				{
					x--;
				}
				else if (direction == 6 && !collide("solid", x, y + 1) && !collideWith(target, x, y + 1))
				{
					y++;
				}
				else
				{
					stopped = true;
				}
				
				traveltime++;
				if (traveltime >= TRAVEL_TIME_MAX)
				{
					traveltime = 0;
					stopped = true;
				}
				
				if (stopped)
				{
					if (Assets.pushwallSoundCount >= Assets.PWALL_SND_LIMIT)
					{
						Assets.pushwallSoundCount--;
						if (Assets.pushwallSoundCount < 0)
							Assets.pushwallSoundCount = 0;
					}
					sfxPWall.stop();
				}
			}
		}
		
	}

}