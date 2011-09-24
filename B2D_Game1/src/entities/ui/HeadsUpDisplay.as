package entities.ui 
{
	import entities.base.*;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	
	// HeadsUpDisplay Class
	// Controls the current "HUD"
	// by displaying text at a location
	// in the world, on top of everything else.
	public class HeadsUpDisplay extends Entity 
	{
		private var txtHUD:Text = null;		// Text object, so it can be updated dynamically.
		
		// Constructor.
		public function HeadsUpDisplay() 
		{
			txtHUD = new Text("Lives: ### Health: ### Score: ### Rockets: ##", 0, 0);	// Placeholder, is updated frequently.
			txtHUD.size = 8;
			txtHUD.scale = 2;	// Make the text 8 instead of 12 point
			graphic = txtHUD;	// assign graphic to the txtHUD object
		}
		
		// Update method.
		public override function update():void
		{
			// There should be a better way to do this.
			// This assumed currently there is
			// One, and ONLY one player object
			// in the world.
			
			var playerList:Array = [];
			FP.world.getClass(Player, playerList);
			
			// Put the text strings all together.
			txtHUD.text = "Lives: " + playerList[0].returnLives().toString() + " "  + "Score: " + playerList[0].returnScore().toString();
		}
		
	}

}