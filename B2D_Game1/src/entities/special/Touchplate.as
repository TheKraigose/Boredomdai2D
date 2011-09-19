package entities.special 
{
	import entities.base.*;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class Touchplate extends Trigger 
	{
		
		public function Touchplate(_sx:int, _sy:int, _t:int)
		{
			super(_sx, _sy);
			type = "touchplate";
			tag = _t;
			
			width = height = Assets.TILE_SIZE_X;
		}
		
		public override function CauseAction():void
		{
			var pwlist:Array = [];
			FP.world.getClass(Pushwall, pwlist);
			for each (var pw:Pushwall in pwlist)
			{
				pw.trigger(tag);
			}
			FP.world.remove(this);
		}
		public override function update():void
		{
			if (collide("player", x, y))
			{
				if (tag > 0 && tag <= 768)
				{
					CauseAction();
				}
				else
					FP.world.remove(this);
			}
		}
		
		
	}

}