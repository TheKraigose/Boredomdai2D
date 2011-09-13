package  
{
	import flash.utils.ByteArray;
	import util.Base64;
	import flash.net.SharedObject;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class Options 
	{
		public static var sharedobj:SharedObject = SharedObject.getLocal("b2dconf");
		
		public static var soundFxVolume:Number = 0.50;
		public static var musicVolume:Number = 0.50;
		public static var soundFxEnabled:Boolean = true;
		public static var musicEnabled:Boolean = true;
		
		public function Options() 
		{
			
		}
		
		public static function setSettings():void
		{
			var configXML:XML = <d2config></d2config>;
			
			var playerlist:Array = [];
			
			var audioXML:XML = <audio />
			audioXML.@soundenabled = Base64.encode(convertToByteArray(soundFxEnabled.toString()));
			audioXML.@soundvolume = Base64.encode(convertToByteArray(soundFxVolume.toString()));
			audioXML.@musicenabled = Base64.encode(convertToByteArray(musicEnabled.toString()));
			audioXML.@musicvolume = Base64.encode(convertToByteArray(musicVolume.toString()));
			
			configXML.appendChild(audioXML);
			
			sharedobj.data.b2dconf = configXML;
			sharedobj.flush();
		}
		
		public static function getSettings():Boolean
		{
			if (sharedobj.data.b2dconf != undefined)
			{
				var xml:XML = sharedobj.data.b2dconf;
				
				var sndFlagBAR:ByteArray;
				var sndVolBAR:ByteArray;
				var musFlagBAR:ByteArray;
				var musVolBAR:ByteArray;
				
				for each (var a:XML in xml.audio[0])
				{
					sndFlagBAR = Base64.decode(a.@soundenabled);
					sndVolBAR = Base64.decode(a.@soundvolume);
					musFlagBAR = Base64.decode(a.@musicenabled);
					musVolBAR = Base64.decode(a.@musicvolume);
				}
				
				var sndFlag:Boolean = convertFromByteArrayToBool(sndFlagBAR);
				var sndVol:Number = convertFromByteArrayToFloat(sndVolBAR);
				var musFlag:Boolean = convertFromByteArrayToBool(musFlagBAR);
				var musVol:Number = convertFromByteArrayToFloat(musVolBAR);
				
				soundFxEnabled = sndFlag;
				soundFxVolume = sndVol;
				musicEnabled = musFlag;
				musicVolume = musVol;
				
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private static function convertToByteArray(_str:String):ByteArray
		{
			var bar:ByteArray = new ByteArray();
			bar.writeMultiByte(_str, "iso-8859-1");
			return bar;
		}
		
		private static function convertFromByteArrayToBool(_bar:ByteArray):Boolean
		{
			var strtmp:String = convertFromByteArrayToString(_bar);
			
			if (strtmp == "true")
				return true;
			else if (strtmp == "false")
				return false;
			
			return false;
		}
		
		private static function convertFromByteArrayToFloat(_bar:ByteArray):Number
		{
			return parseFloat(convertFromByteArrayToString(_bar));
		}
		
		private static function convertFromByteArrayToString(_bar:ByteArray):String
		{
			var strtmp:String = "";
			_bar.position = 0;
			strtmp = _bar.readMultiByte(_bar.length, "iso-8859-1");
			return strtmp;
		}
		
	}

}