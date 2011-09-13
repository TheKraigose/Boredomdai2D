package entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class PlayerDebugText extends Entity 
	{
		private var txtDebug:Text = new Text("tx: ###\nty: ###");
		
		private var tileX:int;
		private var tileY:int;
		private var playerList:Array = [];
		
		public function PlayerDebugText() 
		{
			txtDebug.size = 8;
			graphic = txtDebug;
			FP.world.getClass(Player, playerList);
		}
		
		public function UpdateStats():void
		{
			tileX = Math.ceil(playerList[0].x / 24);
			tileY = Math.ceil(playerList[0].y / 24);
			txtDebug.text = "tx: " + tileX + "\nty: " + tileY;
		}
		
		public override function update():void
		{
			UpdateStats();
			x = playerList[0].x - 24;
			y = playerList[0].y - 24;
		}
	}

}