package  
{
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class GameStrings 
	{
		public static const STR_LDR_HDR1:String = "Loading Boredomdai 2D Game I\n";
		public static const STR_LDR_HDR2:String = "Downward Spiral!\n";
		
		public static const STR_LDR_MSG1:String = "Loading FlashPunk-Boredomdai 2D Refresh Daemon\n";
		public static const STR_LDR_MSG2:String = "F_Rollo(): A baby? A MONSTER! *throws in well*\n";
		public static const STR_LDR_MSG3:String = "I_PopoToast(): Making Toast! :)\n";
		public static const STR_LDR_MSG4:String = "I_PopoButterToast(): Buttering Toast! :)\n";
		public static const STR_LDR_MSG5:String = "G_Aston(): No one starts games up like Gaston!\n";
		public static const STR_LDR_MSG6:String = "I_CheckForMario(): MARIO WHERE ARE YOU?!\n";
		public static const STR_LDR_MSG7:String = "Z_PootisDSpencer(): [Insert Francis Trollface].\n";
		public static const STR_LDR_MSG8:String = "N_Blather(): Hrum. What. Pretty Much.\n";
		public static const STR_LDR_MSG9:String = "K_Init(): Okay, let's get our junk together!\n";
		
		public static const STR_LDR_BETA:String = "\n\n\n== Version: " + Version.VERSION_NUMBER + " Beta Version! For Testing only! ==\n\n\n";
		
		public static const STR_LDR_FINAL:String = "\n\n\n== Version: " + Version.VERSION_NUMBER + " ==\n\n\n";
		
		public static const STR_LDR_READY:String = "Click your mouse button to continue!\n";
		
		public function GameStrings() 
		{
			
		}
		
		public static function getPreloaderMessages(_pct:Number):String
		{
			var strReturn:String;
			if (_pct >= 0)
			{
				strReturn = (STR_LDR_HDR1 + STR_LDR_HDR2);
			}
			if (_pct >= 10)
			{
				strReturn += STR_LDR_MSG1;
			}
			if (_pct >= 20)
			{
				strReturn += STR_LDR_MSG2;
			}
			if (_pct >= 30)
			{
				strReturn += STR_LDR_MSG3;
			}
			if (_pct >= 40)
			{
				strReturn += STR_LDR_MSG4;
			}
			if (_pct >= 50)
			{
				strReturn += STR_LDR_MSG5;
			}
			if (_pct >= 70)
			{
				strReturn += STR_LDR_MSG6;
			}
			if (_pct >= 80)
			{
				strReturn += STR_LDR_MSG7
			}
			if (_pct >= 90)
			{
				strReturn += STR_LDR_MSG8;
			}
			if (_pct >= 100)
			{
				strReturn += STR_LDR_MSG9;
				if (Version.BETA_VERSION)
					strReturn += STR_LDR_BETA;
				else
					strReturn += STR_LDR_FINAL;
				
				strReturn += STR_LDR_READY;
			}
			return strReturn;
		}
		
	}

}