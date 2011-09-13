package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class Intermission extends Entity 
	{
		public static const STR_ALL_MOBJ_BON:String = "Gotta Kill \'em All Bonus! [1000pts]\n";
		public static const STR_ALL_SCRT_BON:String = "Pushy Girl Bonus! [1000pts]\n";
		public static const STR_ALL_ITEM_BON:String = "Packrat Bonus! [1000pts]\n";
		public static const STR_NON_MOBJ_BON:String = "Pacifist Bonus! [1000pts]\n";
		public static const STR_NO_ITEMS_BON:String = "No Loot For You Bonus! [1000pts]\n";
		public static const STR_PERFECTO_BON:String = "PERFECT CLEAR! [2000pts]\n";
		public static const STR_END_TEXT_PT1:String = "\nLevel ";
		public static const STR_END_TEXT_PT2:String = " completed! Press C, X or Z to continue!";
		
		private var levelnum:int = 0;
		private var textobj:Text;
		
		private var bonusStr:String;
		
		private var monsterTotal:int;
		private var monstersKilled:int;
		private var monsterCalc:Number;
		
		private var secretTotal:int;
		private var secretFound:int;
		private var secretCalc:Number;
		
		private var itemTotal:int;
		private var itemFound:int;
		private var itemCalc:Number;
		
		private var killAllBon:Boolean = false;
		private var killNoneBon:Boolean = false;
		private var PackratBon:Boolean = false;
		private var pwallBon:Boolean = false;
		private var noLootBon:Boolean = false;
		private var perfectBon:Boolean = false;
		
		private var bonusSnd:Sfx;
		private var bonusPlayed:Boolean = false;
		
		private var finished:Boolean = false;
		
		public function Intermission() 
		{
			visible = false;
			layer = -2;
			textobj = new Text("");
			textobj.size = 8;
			graphic = textobj;
			bonusSnd = new Sfx(Assets.SFX_MONEY);
			bonusStr = "";
		}
		
		public function updateLevelNum(ln:int):void
		{
			levelnum = ln;
		}
		
		public function setMonsterTotal(_mt:int):void
		{
			monsterTotal = _mt;
		}
		
		public function setMonsterKilled():void
		{
			monstersKilled++;
		}
		
		public function setSecretTotal(_st:int):void
		{
			secretTotal = _st;
		}
		
		public function setSecretFound():void
		{
			secretFound++;
		}
		
		public function addToSecretTotal():void
		{
			secretTotal++;
		}
		
		public function subFromSecretTotal():void
		{
			secretTotal--;
		}
		
		public function setItemTotal(_it:int):void
		{
			itemTotal = _it;
		}
		
		public function setItemsFound():void
		{
			itemFound++;
		}
		
		private function calculateMonsters():void
		{
			var pct:Number;
			if (monsterTotal > 0)
				pct = ((monstersKilled / monsterTotal) * 100) as Number;
			else
			{
				pct = 0;
				monsterCalc = pct;
				return;
			}
			
			if (pct >= 100 || pct == 0)
			{
				if (pct >= 100)
					killAllBon = true;
				else if (pct == 0)
					killNoneBon = true;
			}
			
			monsterCalc = pct;
		}
		
		private function calculateSecrets():void
		{
			var pct:Number;
			if (secretTotal > 0)
				pct = ((secretFound / secretTotal) * 100) as Number;
			else
			{
				pct = 0;
				secretCalc = pct;
				return;
			}
				
			if (pct >= 100)
			{
				pwallBon = true;
			}
			
			secretCalc = pct;
		}
		
		private function calculateItems():void
		{
			var pct:Number;
			if (itemTotal > 0)
				pct = ((itemFound / itemTotal) * 100) as Number;
			else
			{
				pct = 0;
				itemCalc = pct;
				return;
			}
			
			if (pct >= 100 || pct == 0)
			{
				if (pct >= 100)
				{
					PackratBon = true;
				}
				else if (pct == 0)
				{
					noLootBon = true;
				}
			}
			
			itemCalc = pct;
		}
		
		private function calculatePerfect():void
		{
			if (killAllBon)
			{
				perfectBon = true;
			}
			else if (!killAllBon && monsterTotal == 0)
			{
				perfectBon = true;
			}
			else
			{
				perfectBon = false;
			}
			
			// skip if perfectBon is false
			if (perfectBon == true)
			{
				if (PackratBon)
				{
					perfectBon = true;
				}
				else if (!PackratBon && itemTotal == 0)
				{
					perfectBon = true;
				}
				else
				{
					perfectBon = false;
				}
			}
			
			// Skip if perfectBon is false
			if (perfectBon == true)
			{
				if (pwallBon)
				{
					perfectBon = true;
				}
				else if (!pwallBon && secretTotal == 0)
				{
					perfectBon = true;
				}
				else
				{
					perfectBon = false;
				}
			}
		}
		
		private function givePlayerBonus(_sc:int=1000):void
		{
			var plist:Array = [];
			world.getClass(Player, plist);
			plist[0].addToScore(_sc);
		}
		
		public function resetBonuses():void
		{
			killAllBon = killNoneBon = PackratBon = noLootBon = pwallBon = perfectBon = false;
			itemCalc = monsterCalc = secretCalc = 0;
			itemTotal = monsterTotal = secretTotal = 0;
			itemFound = monstersKilled = secretFound = 0;
			bonusStr = "";
		}
		
		public function levelFinished():void
		{
			finished = true;
		}
		
		public function startingNewLevel():void
		{
			finished = false;
			bonusPlayed = false;
		}
		
		private function BuildBonusString():void
		{
			if (bonusStr == "")
			{
				if (killAllBon && !killNoneBon)
					bonusStr += Intermission.STR_ALL_MOBJ_BON;
				if (killNoneBon && !killAllBon)
					bonusStr += Intermission.STR_NON_MOBJ_BON;
				if (PackratBon && !noLootBon)
					bonusStr += Intermission.STR_ALL_ITEM_BON;
				if (noLootBon && !PackratBon)
					bonusStr += Intermission.STR_NO_ITEMS_BON;
				if (pwallBon)
					bonusStr += Intermission.STR_ALL_SCRT_BON;
				if (perfectBon)
					bonusStr += Intermission.STR_PERFECTO_BON;
				
				var tmpstr:String = Intermission.STR_END_TEXT_PT1 + levelnum.toString() + Intermission.STR_END_TEXT_PT2;
				
				bonusStr += tmpstr;
			}
		}
		
		public override function render():void
		{
			super.render();
			textobj.text = bonusStr;
		}
		
		public override function update():void
		{
			if (finished)
			{
				calculateMonsters();
				calculateItems();
				calculateSecrets();
				calculatePerfect();
			}
			if (finished /* && visible */ && (killAllBon || killNoneBon || PackratBon || noLootBon || pwallBon) && !bonusSnd.playing && !bonusPlayed)
			{
				if (killAllBon && !killNoneBon)
					givePlayerBonus();
				if (killNoneBon && !killAllBon)
					givePlayerBonus();
				if (PackratBon && !noLootBon)
					givePlayerBonus();
				if (noLootBon && !PackratBon)
					givePlayerBonus();
				if (pwallBon)
					givePlayerBonus();
				if (perfectBon)
					givePlayerBonus(2000);
				
				bonusPlayed = true;
				bonusSnd.play(0.35);
				BuildBonusString();
			}
			else if (finished)
			{
				BuildBonusString();
			}
		}
	}

}