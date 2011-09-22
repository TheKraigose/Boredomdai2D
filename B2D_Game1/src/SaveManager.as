package  
{
	import entities.base.Player;
	import entities.ui.MusicPlayer;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import net.flashpunk.FP;
	import util.Base64;
	import worlds.Game;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class SaveManager 
	{
		public static var sharedobj:SharedObject = SharedObject.getLocal("b2dsaves");
		
		public function SaveManager() 
		{
			
		}
		
		public static function saveXMLSaveState():void
		{
			var levelData:XML = <d2dsave></d2dsave>;
			var levelNum:int;
			var difficulty:int;
			var playerLives:int;
			var playerScore:int;
			var playerRockets:int;
			var playerHealth:int;
			var playerRType:int;
			var playerSubmac:int;
			
			var playerlist:Array = [];
			
			var gw:Game = FP.world as Game;
			levelNum = gw.levelNumber;
			difficulty = gw.difficulty;
			
			gw.getClass(Player, playerlist);
			
			playerScore = playerlist[0].getScoreForSave();
			playerRockets = playerlist[0].getAmmoForSave();
			playerLives = playerlist[0].getLivesForSave();
			playerHealth = playerlist[0].getHealthForSave();
			playerRType = playerlist[0].getRocketTypeForSave();
			playerSubmac = playerlist[0].getSubmacstatus();
			
			var playerXML:XML = <player />
			playerXML.@levelnum = Base64.encode(convertToByteArray(levelNum.toString()));
			playerXML.@score = Base64.encode(convertToByteArray(playerScore.toString()));
			playerXML.@rockets = Base64.encode(convertToByteArray(playerRockets.toString()));
			playerXML.@lives = Base64.encode(convertToByteArray(playerLives.toString()));
			playerXML.@diff = Base64.encode(convertToByteArray(difficulty.toString()));
			playerXML.@health = Base64.encode(convertToByteArray(playerHealth.toString()));
			playerXML.@rtype = Base64.encode(convertToByteArray(playerRType.toString()));
			playerXML.@smac = Base64.encode(convertToByteArray(playerSubmac.toString()));
			levelData.appendChild(playerXML);
			
			sharedobj.data.b2dsaves = levelData;
			sharedobj.flush();
		}
		
		private static function convertToByteArray(_str:String):ByteArray
		{
			var bar:ByteArray = new ByteArray();
			bar.writeMultiByte(_str, "iso-8859-1");
			return bar;
		}
		
		private static function convertFromByteArrayToInt(_bar:ByteArray):int
		{
			return parseInt(convertFromByteArrayToString(_bar));
		}
		
		private static function convertFromByteArrayToString(_bar:ByteArray):String
		{
			var strtmp:String = "";
			_bar.position = 0;
			strtmp = _bar.readMultiByte(_bar.length, "iso-8859-1");
			return strtmp;
		}
		
		public static function loadXMLSaveState():Boolean
		{
			if (sharedobj.data.b2dsaves != undefined)
			{
				var xml:XML = sharedobj.data.b2dsaves;
				
				var diffBAR:ByteArray;
				var levelBAR:ByteArray;
				var livesBAR:ByteArray;
				var rcktBAR:ByteArray; 
				var scoreBAR:ByteArray;
				var hpBAR:ByteArray;
				var RTBAR:ByteArray;
				var SMacBAR:ByteArray;
				
				for each (var plyr:XML in xml.player)
				{
					diffBAR = Base64.decode(plyr.@diff);
					levelBAR = Base64.decode(plyr.@levelnum);;
					livesBAR = Base64.decode(plyr.@lives);
					rcktBAR = Base64.decode(plyr.@rockets);
					scoreBAR = Base64.decode(plyr.@score);
					hpBAR = Base64.decode(plyr.@health);
					RTBAR = Base64.decode(plyr.@rtype);
					SMacBAR = Base64.decode(plyr.@smac);
				}
				
				var diff:int = convertFromByteArrayToInt(diffBAR);
				var lnum:int = convertFromByteArrayToInt(levelBAR);
				var lives:int = convertFromByteArrayToInt(livesBAR);
				var rckts:int = convertFromByteArrayToInt(rcktBAR);
				var score:int = convertFromByteArrayToInt(scoreBAR);
				var health:int = convertFromByteArrayToInt(hpBAR);
				var rtype:int = convertFromByteArrayToInt(RTBAR);
				var smac:int = convertFromByteArrayToInt(SMacBAR);
				
				var sstate:SaveStateInfo = new SaveStateInfo(diff, lnum, lives, rckts, score, health, rtype, smac);
				
				if (sstate.levelnumber > 3)
					sstate.levelnumber = 3;
				
				var mblst:Array = [];
				FP.world.getClass(MusicPlayer, mblst);
				
				mblst[0].MP_StopPlaying();
					
				var gw:Game = new Game(sstate.difficulty, sstate.levelnumber, sstate);
				
				FP.world = gw;
				return true;
			}
			else
			{
				// FP.world = new ErrorScreen("SaveManager.loadXMLSaveState(): Invalid or missing save state!");
				return false;
			}
		}
		
	}

}