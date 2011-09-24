package entities.ui 
{
	import entities.base.*;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class HealthBarHUD extends Entity 
	{
		protected var health:int;
		protected var prevhealthten:int;
		protected var glist:Graphiclist;
		
		public function HealthBarHUD() 
		{
			glist = new Graphiclist;
			graphic = glist;
			
			for (var i:int = 0; i <= 10; i++)
			{
				var img:Image = new Image(Assets.GFX_HUD_HPICON_GREEN);
				img.x = ((i + 1) * 10);
				img.y = Assets.STAGE_SIZE_Y - 24;
				glist.add(img);
			}
		}
		
		public override function update():void
		{
			var playerList:Array = [];
			FP.world.getClass(Player, playerList);
			health = playerList[0].returnHealth();
			var hpten:int = health / 10;
			
			if (hpten != prevhealthten)
			{
				
				for (var i:int = 0; i <= 10; i++)
				{
					if (i <= hpten)
						glist.children[i].visible = true;
					else
						glist.children[i].visible = false;
				}
				
				prevhealthten = hpten;
			}
		}
		
	}

}