package util 
{
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class Angle 
	{
		public static function AU_CheckAngleRange(_a:int):int
		{
			if (_a >= 360)
				_a -= 360;
			else if (_a < 0)
				_a += 360;
				
			return _a;
		}
		
		public static function AU_DegreesToRadians(_a:int):Number
		{
			return ((Math.PI / 180) * AU_CheckAngleRange(_a));
		}
		
		public function Angle() 
		{
			
		}
		
	}

}