package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.Sfx;
	import net.flashpunk.FP;
	import worlds.ErrorScreen;
	import worlds.Game;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class MusicPlayer extends Entity 
	{
		protected var musMain:Sfx;
		public function MusicPlayer(_ln:int, _state:int=0, _loop:Boolean=true) 
		{
			MP_StartPlaying(_ln, _state, _loop);
		}
		
		protected function MP_LoadMusic(_ln:int):Class
		{
			if (_ln == 1 || _ln == 2)
			{
				return Assets.MUS_TRACK1;
			}
			else if (_ln == 3)
			{
				return Assets.MUS_TRACK2;
			}
			else
			{
				FP.world = new ErrorScreen("MP_LoadMusic(): Invalid music!\n");
				return null;
			}
		}
		
		public function MP_StartPlaying(_ln:int, _state:int=0, _loop:Boolean=true):void
		{
			if (Options.musicEnabled)
			{
				var cls:Class;
				
				if (_state == Game.GAME_STATE_INGAME)
				{
					cls = MP_LoadMusic(_ln);
				}
				else if (_state == Game.GAME_STATE_INTERMISSION)
				{
					cls = Assets.MUS_INTER;
				}
				else if (_state == 0)	// Title Screen!
				{
					cls = Assets.MUS_TITLE;
				}
				
				if (cls != null && _state != Game.GAME_STATE_LOADING)
				{
					musMain = new Sfx(cls);
					if (_loop)
						musMain.loop(Options.musicVolume);
					else
						musMain.play(Options.musicVolume);
				}
			}
		}
		
		public function MP_StopPlaying():void
		{
			musMain.stop();
		}
		
		public override function update():void
		{
			super.update();
			
			musMain.volume = Options.musicVolume;
		}
	}

}