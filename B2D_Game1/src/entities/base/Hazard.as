package entities.base 
{
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class Hazard extends KIActor 
	{
		public function Hazard(_sx:int, _sy:int, _w:int=24, _h:int=24) 
		{
			super(_sx, _sy, _w, _h);
			type = "hazard";
			damage = 5;
		}
		
		public function getDamage():int
		{
			return damage;
		}
		
	}

}