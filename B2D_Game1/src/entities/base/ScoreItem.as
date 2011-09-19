package entities.base 
{
	import entities.special.Intermission;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class ScoreItem extends Pickup 
	{
		protected var scoreValue:int;
		public function ScoreItem(_sx:int, _sy:int, _sv:int=100) 
		{
			super(_sx, _sy, 24, 24);
			scoreValue = _sv;
		}
		
		public function addItem():void
		{
			var im:Array = [];
			FP.world.getClass(Intermission, im);
			im[0].setItemsFound();
		}
		
		public override function update():void
		{
			var p:Entity = collide("player", x, y) as Entity;
			if (p && p is Player)
			{
				var plyr:Player = p as Player;
				plyr.addToScore(scoreValue);
				addItem();
				FP.world.remove(this);
			}
		}
		
	}

}