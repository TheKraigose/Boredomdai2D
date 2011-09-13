package worlds 
{
	import gui.error.ErrorOverlay;
	import gui.error.ErrorText;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class ErrorScreen extends World
	{
		
		protected var sfxError:Sfx = new Sfx(Assets.SFX_ERROR_MAJOR);
		protected var timetoshow:int;
		protected var error:ErrorText;
		protected var stopCycle:Boolean;
		
		public function ErrorScreen(_err:String) 
		{
			FP.screen.color = 0x000000;
			
			
			error = new ErrorText(_err);
			
			timetoshow = 0;
			stopCycle = false;
		}
		
		public override function update():void
		{
			timetoshow++;
			if (timetoshow >= 96 && !stopCycle)
			{
				add(new ErrorOverlay());
				add(error);
				sfxError.play(1);
				timetoshow = 0;
				stopCycle = true;
			}
		}
		
	}

}