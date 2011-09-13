package 
{
	import net.flashpunk.Engine;
	import worlds.Game;
	import worlds.TitleScreens;
	
	import net.flashpunk.FP;

	/**
	 * ...
	 * @author Kraig Culp
	 */
	
	// This is a FlashPunk Game I am writing.
	// The FlashPunk library is under an MIT-like
	// License and is written by many
	// people at http://www.flashpunk.net
	// but primarily ChevyRay.
	
	// Everything stored in the net folder
	// belongs to him and his team/contributors.
	
	// That said, this program serves many purposes:
	// +Showing further, more complex Object Orientation (Including inheritance)
	// +Showing my ability to creatively use existing libraries and frameworks
	// +To teach myself game development in the style of old arcade game style
	
	// This game isn't done yet by any means. However it is my most complex project to date
	
	[Frame(factoryClass="Preloader")]
	public class Main extends Engine 
	{
		public function Main() 
		{
			super(Assets.STAGE_SIZE_X, Assets.STAGE_SIZE_Y, 60, false);
			FP.screen.scale = 2;
			Options.getSettings();
			FP.world = new TitleScreens();
		}
	}

}