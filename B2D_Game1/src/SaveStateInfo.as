package  
{
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class SaveStateInfo 
	{
		public var difficulty:int;
		public var levelnumber:int;
		public var rocketammo:int;
		public var score:int;
		public var health:int;
		public var lives:int;
		public var rtype:int;
		public var smac:int;
		
		public function SaveStateInfo(_diff:int, _ln:int, _lives:int, _rammo:int, _score:int, _hp:int, _rtype:int, _smac:int) 
		{
			difficulty = _diff;
			levelnumber = _ln;
			rocketammo = _rammo;
			score = _score;
			health = _hp;
			lives = _lives;
			rtype = _rtype;
			smac = _smac;
		}
		
	}

}