package entities 
{
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class Trigger extends KIActor 
	{
		protected var tag:int;
		public function Trigger(_sx:int, _sy:int) 
		{
			super(_sx, _sy);
			visible = false;
		}
		
		public function CauseAction():void
		{
			
		}
		
	}

}