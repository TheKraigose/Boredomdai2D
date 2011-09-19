package entities.special 
{
	import entities.base.*;
	import entities.special.*;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class TileSwitch extends Trigger 
	{
		public static const SWITCH_METAL_1:int = 0;
		public static const SWITCH_METAL_2:int = 1;
		public static const SWITCH_BROWN_1:int = 2;
		public static const SWITCH_BROWN_2:int = 3;
		
		public static const MAX_SWITCHES:int = 3;
		
		protected var tilenum:int;
		
		protected var activated:Boolean;
		
		protected var tmap:Tilemap;
		
		protected var sfxSwitch:Sfx = new Sfx(Assets.SFX_SWITCH);
		
		public function TileSwitch(sx:int, sy:int, t:int, n:int=TileSwitch.SWITCH_METAL_1) 
		{
			super(sx, sy);
			tag = t;
			tilenum = n;
			setHitbox(Assets.TILE_SIZE_X, Assets.TILE_SIZE_Y, 0, 0);
			graphic = tmap = new Tilemap(Assets.SWITCHSET, Assets.TILE_SIZE_X, Assets.TILE_SIZE_Y, Assets.TILE_SIZE_X, Assets.TILE_SIZE_Y);
			
			if (tilenum > MAX_SWITCHES)
				tilenum = MAX_SWITCHES;
			else if (tilenum < 0)
				tilenum = 0;
				
			tmap.setTile(1, 1, tilenum);
			height = width = Assets.TILE_SIZE_X;
			
			var lstPlayer:Array = [];
			FP.world.getClass(Player, lstPlayer);
			target = lstPlayer[0];
			visible = true;
			type = "solid";
		}
		
		public override function CauseAction():void
		{
			if (tag > 0 && tag <= 768)
			{
				var pwlist:Array = [];
				FP.world.getClass(Pushwall, pwlist);
				for each (var pw:Pushwall in pwlist)
				{
					pw.trigger(tag);
				}
			}
		}
		
		public function activate():void
		{
			if (!activated && tag > 0 && tag <= 256)
			{
				if (collideWith(target, x + 20, y) || collideWith(target, x - 20, y) || collideWith(target, x, y - 20) || collideWith(target, x, y + 20))
				{
					activated = true;
					
					if (Options.soundFxEnabled)
						sfxSwitch.play(0.35 * Options.soundFxVolume);
					
					if (tilenum % 2 != 0)
						tmap.setTile(1, 1, tilenum += 1);
					else
						tmap.setTile(1, 1, tilenum -= 1);
						
					CauseAction();
				}
			}
		}
		
	}

}