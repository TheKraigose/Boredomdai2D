package entities.special 
{
	import entities.base.KIActor;
	import entities.base.Player;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Draw;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class Door extends KIActor 
	{
		public static const DOOR_CLOSED:int = 0;
		public static const DOOR_CLOSING:int = 3;
		public static const DOOR_OPENED:int = 2;
		public static const DOOR_OPENING:int = 1;
		
		
		protected var northsouth:Boolean;
		protected var closeamt:int;
		protected var opentime:int;
		protected var status:int;
		
		protected var sfxDoorOpen:Sfx = new Sfx(Assets.SFX_DOOR_OPEN);
		protected var sfxDoorClose:Sfx = new Sfx(Assets.SFX_DOOR_CLOSE);
		
		public function Door(_sx:int, _sy:int, _northsouth:Boolean = false) 
		{
			super(_sx, _sy, 24, 24);
			setOrigin();
			
			type = "solid";
			
			northsouth = _northsouth;
			
			closeamt = 24;
			opentime = 0;
			
			var lstPlayer:Array = [];
			FP.world.getClass(Player, lstPlayer);
			target = lstPlayer[0];
			
			status = Door.DOOR_CLOSED;
		}
		
		public function openDoor():void
		{
			if (northsouth)
			{
				if (collideWith(target, x, y - 24) || collideWith(target, x, y + 24))
				{
					if (status == Door.DOOR_CLOSED || status == Door.DOOR_CLOSING)
					{
						status = Door.DOOR_OPENING;
					}
					else if (status == Door.DOOR_OPENING || status == Door.DOOR_OPENED)
					{
						status = Door.DOOR_CLOSING;
					}
				}
			}
			else
			{
				if (collideWith(target, x + 24, y) || collideWith(target, x - 24, y))
				{
					if (status == Door.DOOR_CLOSED || status == Door.DOOR_CLOSING)
					{
						status = Door.DOOR_OPENING;
					}
					else if (status == Door.DOOR_OPENING || status == Door.DOOR_OPENED)
					{
						status = Door.DOOR_CLOSING;
					}
				}
			}
		}
		
		public override function render():void
		{
			super.render();
			
			if (northsouth)
				Draw.line(x, y + halfHeight, x + closeamt, y + halfHeight, 0x00FFFF, 1.0);
			else
				Draw.line(x + halfWidth, y, x + halfWidth, y + closeamt, 0x00FFFF, 1.0);
			
		}
		
		public override function update():void
		{
			super.update();
			
			if (status == Door.DOOR_OPENING)
			{
				if (!sfxDoorOpen.playing && Options.soundFxEnabled)
				{
					sfxDoorClose.stop();
					sfxDoorOpen.play(Options.soundFxVolume * 0.35);
				}
				
				closeamt--;
				if (closeamt <= 0)
				{
					status = Door.DOOR_OPENED;
				}
			}
			
			if (status == Door.DOOR_OPENED)
			{
				type = "none";
				opentime++;
				if (opentime >= 128)
				{
					status = Door.DOOR_CLOSING;
				}
			}
			
			if (status == Door.DOOR_CLOSING)
			{
				if (!collideWith(target, x, y) || !collide("enemy", x, y))
				{
					if (!sfxDoorClose.playing && Options.soundFxEnabled)
					{
						sfxDoorOpen.stop();
						sfxDoorClose.play(Options.soundFxVolume * 0.35);
					}
					opentime = 0;
					closeamt++;
					if (closeamt >= 24)
					{
						status = Door.DOOR_CLOSED;
					}
				}
				else
					opentime = 0;
			}
			
			if (status == Door.DOOR_CLOSED)
			{
				type = "solid";
			}
		}
		
	}

}