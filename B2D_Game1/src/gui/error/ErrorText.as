package gui.error 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class ErrorText extends Entity 
	{
		protected var txtError:Text;
		private const STR_VICTIM:String = "VicTIM " + Version.VERSION_NUMBER + " caught an ungodly heathen of an error and closed the sodomite game!\n";
		private const STR_VICTIM_DEUX:String = "\nHe is not sorry for the inconvenience, naturally.\n\n";
		private const STR_TRAP:String = "Thank god for this error:\n\n";
		
		public function ErrorText(_err:String) 
		{
			super(0, 0);
			
			layer = -10;
			
			var strtmp:String = STR_VICTIM + STR_VICTIM_DEUX;
			
			strtmp = strtmp + STR_TRAP + _err;
			
			txtError = new Text(strtmp);
			txtError.color = 0xFFFFFF;
			txtError.size = 8;
			
			graphic = txtError;
		}
		
	}

}