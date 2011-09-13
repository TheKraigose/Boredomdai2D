package  
{
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class Assets 
	{
		// Spritesheet & Graphics Assets
		[Embed(source = 'assets/sprites/cmama.png')]
		public static const CMAMA_SPR:Class;
		[Embed(source = 'assets/sprites/bullet.png')]
		public static const SPR_BULLET:Class;
		[Embed(source = "assets/tilesets/tiles.png")]
		public static const TILESET:Class;
		[Embed(source = "assets/tilesets/switches.png")]
		public static const SWITCHSET:Class;
		[Embed(source = 'assets/sprites/sanya.png')]
		public static const SANYA_SPR:Class;
		[Embed(source = 'assets/sprites/grunt.png')]
		public static const SPR_LOWGUARD:Class;
		[Embed(source = 'assets/sprites/dango_96px.png')]
		public static const SPR_HPKIT:Class;
		[Embed(source = 'assets/sprites/ammo_rocket.png')]
		public static const SPR_ROCKBOX:Class;
		[Embed(source = 'assets/sprites/particles.png')]
		public static const SPR_PARTICLE:Class;
		[Embed(source = 'assets/sprites/gib.png')]
		public static const SPR_GIB:Class;
		[Embed(source = 'assets/sprites/missile.png')]
		public static const SPR_FROCKET:Class;
		[Embed(source = 'assets/sprites/money.png')]
		public static const SPR_MONEY:Class;
		
		[Embed(source = 'assets/graphics/title.png')]
		public static const GFX_TITLEPIC:Class;
		[Embed(source = 'assets/graphics/newcred.png')]
		public static const GFX_CREDITS:Class;
		[Embed(source = 'assets/graphics/results.png')]
		public static const GFX_RESULTPAGE:Class;
		
		[Embed(source = 'assets/graphics/VicTIM_Logo.png')]
		public static const GFX_ERROR_VICTIM:Class;
		
		[Embed(source = 'assets/graphics/paused.png')]
		public static const GFX_PAUSED:Class;
		
		/* [Embed(source = 'assets/graphics/help.png')]
		public static const GFX_HELP:Class; */
		
		// Sound Assets
		[Embed(source = 'assets/sfx/okiedokie.mp3')]
		public static const SFX_PINKIEPIE:Class;
		[Embed(source = 'assets/sfx/algebra.mp3')]
		public static const SFX_C_ALGEBRA:Class;
		[Embed(source = 'assets/sfx/takei.mp3')]
		public static const SFX_OH_MY:Class;
		[Embed(source = 'assets/sfx/shoot_a.mp3')]
		public static const SFX_BULLET:Class;
		[Embed(source = 'assets/sfx/shoot_b.mp3')]
		public static const SFX_ROCKET:Class;
		[Embed(source = 'assets/sfx/explosion.mp3')]
		public static const SFX_EXPLODE:Class;
		[Embed(source = 'assets/sfx/switch.mp3')]
		public static const SFX_SWITCH:Class;
		[Embed(source = 'assets/sfx/pushwall.mp3')]
		public static const SFX_PWALL:Class;
		[Embed(source = 'assets/sfx/pickup.mp3')]
		public static const SFX_PICKUP:Class;
		[Embed(source = 'assets/sfx/menu_select.mp3')]
		public static const SFX_MENU_CLICK:Class;
		[Embed(source = 'assets/sfx/money.mp3')]
		public static const SFX_MONEY:Class;
		[Embed(source = 'assets/sfx/feedme.mp3')]
		public static const SFX_FEED_ME_NOW:Class;
		
		[Embed(source = 'assets/sfx/girl_pain.mp3')]
		public static const SFX_SANYA_PAIN:Class;
		[Embed(source = 'assets/sfx/girl_dead.mp3')]
		public static const SFX_SANYA_DEAD:Class;
		[Embed(source = 'assets/sfx/girl_taunt.mp3')]
		public static const SFX_SANYA_TAUNT:Class;
		
		[Embed(source = 'assets/sfx/smitheroons.mp3')]
		public static const SFX_GIBBING:Class;
		
		[Embed(source = 'assets/sfx/cmama_dessert.mp3')]
		public static const SFX_CMAMA_DESSERT:Class;
		[Embed(source = 'assets/sfx/cmama_pain.mp3')]
		public static const SFX_CMAMA_PAIN:Class;
		[Embed(source = 'assets/sfx/cmama_tryagain.mp3')]
		public static const SFX_CMAMA_TAUNT:Class;
		[Embed(source = 'assets/sfx/cmama_better.mp3')]
		public static const SFX_CMAMA_BETTER:Class;
		
		[Embed(source = 'assets/sfx/error/error_main.mp3')]
		public static const SFX_ERROR_MAJOR:Class;
		
		// Music
		[Embed(source = 'assets/music/mus_title.mp3')]
		public static const MUS_TITLE:Class;
		[Embed(source = 'assets/music/mus_track1.mp3')]
		public static const MUS_TRACK1:Class;
		[Embed(source = 'assets/music/mus_track2.mp3')]
		public static const MUS_TRACK2:Class;
		[Embed(source = 'assets/music/mus_track3.mp3')]
		public static const MUS_TRACK3:Class;
		[Embed(source = 'assets/music/mus_track4.mp3')]
		public static const MUS_TRACK4:Class;
		[Embed(source = 'assets/music/mus_track5.mp3')]
		public static const MUS_TRACK5:Class;
		[Embed(source = 'assets/music/mus_track6.mp3')]
		public static const MUS_TRACK6:Class;
		
		public static const MUS_INTER:Class = Assets.MUS_TITLE;
		
		// XML Assets (Maps & Other)
		[Embed(source = "assets/levels/level01.oel", mimeType = "application/octet-stream")]
		public static const LEVEL01_MAP:Class;
		[Embed(source = "assets/levels/level02.oel", mimeType = "application/octet-stream")]
		public static const LEVEL02_MAP:Class;
		[Embed(source = "assets/levels/level03.oel", mimeType = "application/octet-stream")]
		public static const LEVEL03_MAP:Class;
		
		// Constants "globally" used by many classes
		public static const TILE_SIZE_X:int = 24;
		public static const TILE_SIZE_Y:int = TILE_SIZE_X;
		
		public static const SCALE_SPR_XY:Number = 0.25;
		
		// Screen values
		public static const STAGE_SIZE_X:int = 360;
		public static const STAGE_SIZE_Y:int = 240;
		
		// Global variables and global limits
		public static var pushwallSoundCount:int = 0;	// This is to prevent a grating sound that happens when a pushwall chain is activated.
		public static const PWALL_SND_LIMIT:int = 1;
		
		public function Assets() 
		{
			
		}
		
	}

}