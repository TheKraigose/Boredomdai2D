package worlds 
{
	import entities.ui.MusicPlayer;
	import gui.BackgroundGraphic;
	import gui.ButtonBase;
	import gui.error.ErrorText;
	import gui.GraphicsPage;
	import gui.SimpleText;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class TitleScreens extends World 
	{
		private const STR_HUMOR_ERROR:String = "TS_ErrorScreen(): I told you bro. I warned you about buttons!\n"
		
		private var buttonNewGame:ButtonBase = new ButtonBase(16, 32, "New Game");
		private var buttonLoadGame:ButtonBase = new ButtonBase(16, 64, "Load Game");
		private var buttonError:ButtonBase = new ButtonBase(16, 96, "This causes a big error!");
		private var buttonReadMe:ButtonBase = new ButtonBase(16, 128, "Help Me!");
		private var buttonOptions:ButtonBase = new ButtonBase(16, 160, "Options");
		private var buttonFeedMe:ButtonBase = new ButtonBase(16, 192, "Feed Me!");
		
		private var buttonDiffPie:ButtonBase = new ButtonBase(16, 32, "Easy as Pinkie Pie!");
		private var buttonDiffAlgebra:ButtonBase = new ButtonBase(16, 64, "Harder than Chinese Algebra!");
		private var buttonDiffTakei:ButtonBase = new ButtonBase(16, 96, "George Takei Approved.");
		private var buttonGoBack:ButtonBase = new ButtonBase(16, 160, "Back To Main Menu!");
		
		private var buttonSfxVolDown:ButtonBase = new ButtonBase(16, 32, "<<");
		private var buttonSfxVolUp:ButtonBase = new ButtonBase(160, 32, ">>");
		
		private var stextSfxVolume:SimpleText = new SimpleText(48, 32, "SFX Vol: " + Options.soundFxVolume.toString());
		
		private var buttonMusVolDown:ButtonBase = new ButtonBase(16, 64, "<<");
		private var buttonMusVolUp:ButtonBase = new ButtonBase(160, 64, ">>");
		
		private var stextMusVolume:SimpleText = new SimpleText(48, 64, "MUS Vol: " + Options.musicVolume.toString());
		
		private var gfxHelpPage:GraphicsPage;
		private var gfxFeedMePage:GraphicsPage;
		private var gfxBackGround:BackgroundGraphic = new BackgroundGraphic(Assets.GFX_TITLEPIC, 0, 0);
		
		private var sfxDifficulty:Sfx;
		private var difficulty:int = 0;
		private var levelnumber:int = 1;
		
		private var currentSection:int = 0;
		
		public static const SECTION_UNKNOWN:int = -1;
		public static const SECTION_MAINMENU:int = 0;
		public static const SECTION_NEWGAME:int = 1;
		public static const SECTION_OPTIONS:int = 2;
		
		protected const CONST_VOL_INC:Number = 0.10;
		
		private var sfxFeedMe:Sfx;
		
		private var freeze:Boolean;
		
		public function TitleScreens() 
		{
			freeze = false;
			add(new MusicPlayer(0));
			add(gfxBackGround);
			TS_InstallHelpPages();
			TS_InstallFeedMe();
			TS_SetupButtonCallbacks();
			TS_MainMenuSetup();
		}
		
		private function TS_InstallHelpPages():void
		{
			var helpArray:Array = [];
			
			helpArray.push(new Image(Assets.GFX_CREDITS));
			
			gfxHelpPage = new GraphicsPage(helpArray, 0, 0);
		}
		
		private function TS_InstallFeedMe():void
		{
			sfxFeedMe = new Sfx(Assets.SFX_FEED_ME_NOW);
		}
		
		private function TS_SetupButtonCallbacks():void
		{
			buttonNewGame.setCallback(TS_SetupNewGameMenu);
			buttonLoadGame.setCallback(TS_LoadGame);
			if (Version.debugMode || Version.BETA_VERSION)
			{
				buttonError.setCallback(TS_ErrorScreen);
			}
			buttonReadMe.setCallback(TS_ShowHelpPage);
			buttonOptions.setCallback(TS_SetupOptions);
			buttonFeedMe.setCallback(TS_FeedMeNow);
			
			buttonDiffPie.setCallback(TS_SetupEasy);
			buttonDiffAlgebra.setCallback(TS_SetupMedium);
			buttonDiffTakei.setCallback(TS_SetupHard);
			
			buttonGoBack.setCallback(TS_MainMenuSetup);
			
			gfxHelpPage.setCallback(TS_MainMenuSetup);
			
			buttonSfxVolDown.setCallback(TS_LowerSfxVol);
			buttonSfxVolUp.setCallback(TS_RaiseSfxVol);
			
			buttonMusVolDown.setCallback(TS_LowerMusVol);
			buttonMusVolUp.setCallback(TS_RaiseMusVol);
			
		}
		
		private function TS_LowerSfxVol():void
		{
			var newVol:Number = Options.soundFxVolume;
			
			newVol -= CONST_VOL_INC;
			
			if (newVol < 0.0)
			{
				newVol = 0.0;
				Options.soundFxEnabled = false;
			}
			
			newVol = int((newVol) * 100) / 100;
			Options.soundFxVolume = newVol;
			
			if (Options.soundFxVolume == 0.0)
				stextSfxVolume.setText("SFX OFF!");
			else
				stextSfxVolume.setText("SFX Vol: " + Options.soundFxVolume.toString());
		}
		
		private function TS_RaiseSfxVol():void
		{
			var newVol:Number = Options.soundFxVolume;
			
			newVol += CONST_VOL_INC;
			
			if (newVol > 1.0)
			{
				newVol = 1.0;
			}
			
			newVol = int((newVol) * 100) / 100;
			
			Options.soundFxVolume = newVol;
			Options.soundFxEnabled = true;
			
			if (Options.soundFxVolume == 1.0)
				stextSfxVolume.setText("SFX ON FULL!");
			else
				stextSfxVolume.setText("SFX Vol: " + Options.soundFxVolume.toString());
		}
		
		private function TS_LowerMusVol():void
		{
			var newVol:Number = Options.musicVolume;
			
			newVol -= CONST_VOL_INC;
			
			if (newVol < 0.0)
			{
				newVol = 0.0;
				Options.musicEnabled = false;
			}
			
			newVol = int((newVol) * 100) / 100;
			
			Options.musicVolume = newVol;
			
			if (Options.musicVolume == 0.0)
				stextMusVolume.setText("MUSIC OFF!");
			else
				stextMusVolume.setText("MUS Vol: " + Options.musicVolume.toString());
		}
		
		private function TS_RaiseMusVol():void
		{
			var newVol:Number = Options.musicVolume;
			
			newVol += CONST_VOL_INC;
			
			if (newVol > 1.0)
			{
				newVol = 1.0;
			}
			
			newVol = int((newVol) * 100) / 100;
			
			Options.musicVolume = newVol;
			Options.musicEnabled = true;
			
			if (Options.musicVolume == 1.0)
				stextMusVolume.setText("MUS ON FULL!");
			else
				stextMusVolume.setText("MUS Vol: " + Options.musicVolume.toString());
		}
		
		private function TS_ErrorScreen():void
		{
			TS_RemoveMusic();
			
			FP.world = new ErrorScreen(STR_HUMOR_ERROR);
		}
		
		private function TS_FeedMeNow():void
		{
			if (!sfxFeedMe.playing)
				sfxFeedMe.play(0.35);
		}
		
		private function TS_ShowHelpPage():void
		{
			TS_TearDownMenu();
			add(gfxHelpPage);
		}
		
		private function TS_SetupEasy():void
		{
			if (!freeze)
			{
				freeze = true;
				TS_SetupDifficulty(1);
			}
		}
		
		private function TS_SetupMedium():void
		{
			if (!freeze)
			{
				freeze = true;
				TS_SetupDifficulty(2);
			}
		}
		
		private function TS_SetupHard():void
		{
			if (!freeze)
			{
				freeze = true;
				TS_SetupDifficulty(3);
			}
		}
		
		private function TS_SetupNewGameMenu():void
		{
			TS_TearDownMenu();
			currentSection = TitleScreens.SECTION_NEWGAME;
			add(buttonDiffPie);
			add(buttonDiffAlgebra);
			add(buttonDiffTakei);
			add(buttonGoBack);
		}
		
		private function TS_SetupDifficulty(_d:int):void
		{
			difficulty = _d;
			
			if (difficulty < 1 || difficulty > 3)
			{
				FP.world = new ErrorScreen("TS_SetupDifficulty: " + difficulty.toString() + " is not a proper difficulty!");
				return;
			}
				
			if (difficulty == 1)
				sfxDifficulty = new Sfx(Assets.SFX_PINKIEPIE, TS_SetupActualGame);
			else if (difficulty == 2)
				sfxDifficulty = new Sfx(Assets.SFX_C_ALGEBRA, TS_SetupActualGame);
			else if (difficulty == 3)
				sfxDifficulty = new Sfx(Assets.SFX_OH_MY, TS_SetupActualGame);
			
			if (sfxDifficulty == null)
				TS_SetupActualGame();
			else
			{
				if (Options.soundFxEnabled)
					sfxDifficulty.play(0.35 * Options.soundFxVolume);
			}
		}
		
		private function TS_SetupActualGame():void
		{
			TS_TearDownMenu();
			TS_RemoveMusic();
			FP.world = new Game(difficulty, levelnumber);
		}
		
		private function TS_LoadGame():void
		{
			add(buttonGoBack);
			if (SaveManager.loadXMLSaveState())
			{
				TS_TearDownMenu();
			}
			else
			{
				trace("Load Failed");
				remove(buttonGoBack);
				TS_MainMenuSetup();
			}
		}
		
		private function TS_SetupOptions():void
		{
			TS_TearDownMenu();
			currentSection = TitleScreens.SECTION_OPTIONS;
			add(buttonGoBack);
			add(buttonSfxVolDown);
			add(buttonSfxVolUp);
			add(stextSfxVolume);
			add(buttonMusVolDown);
			add(buttonMusVolUp);
			add(stextMusVolume);
		}
		
		private function TS_MainMenuSetup():void
		{
			TS_TearDownMenu();
			
			if (currentSection == TitleScreens.SECTION_OPTIONS)
			{
				Options.setSettings();
			}
			
			currentSection = TitleScreens.SECTION_MAINMENU;
			add(buttonNewGame);
			if (SaveManager.sharedobj.data.b2dsaves != undefined)
			{
				add(buttonLoadGame);
			}
			
			if (Version.debugMode || Version.BETA_VERSION)
			{
				add(buttonError);
			}
			add(buttonOptions);
			add(buttonReadMe);
			add(buttonFeedMe);
		}
		
		private function TS_RemoveMusic():void
		{
			var lmus:Array = [];
			getClass(MusicPlayer, lmus);
			lmus[0].MP_StopPlaying();
			removeList(lmus);
		}
		
		private function TS_TearDownMenu():void
		{
			var lstbtn:Array = [];
			getClass(ButtonBase, lstbtn);
			removeList(lstbtn);
			
			var lststx:Array = [];
			getClass(SimpleText, lststx);
			removeList(lststx);
		}
	}

}