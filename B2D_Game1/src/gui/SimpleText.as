package gui 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class SimpleText extends Entity 
	{
		protected var text:Text;
		protected var func:Function;
		
		public function SimpleText(_sx:int, _sy:int, _str:String, _fgc:uint=0xFFFFFF) 
		{
			super(_sx, _sy);
			
			layer = -2;
			
			text = new Text(_str);
			text.color = _fgc;
			
			graphic = text;
		}
		
		public function setText(_str:String):void
		{
			text.text = _str;
		}
		
		public override function update():void
		{
			super.update();
		}
	}

}