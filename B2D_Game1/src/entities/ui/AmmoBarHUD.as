package entities.ui 
{
	import entities.base.Player;
	import flash.display.GradientType;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class AmmoBarHUD extends Entity 
	{
		protected var ammo:int;
		protected var ammotype:int;
		protected var previousammo:int;
		protected var previoustype:int;
		protected var isRocketMode:Boolean;
		protected var hasSubmachine:Boolean;
		protected var bullglist:Graphiclist;
		protected var smacglist:Graphiclist;
		protected var rcktglist:Graphiclist;
		protected var heatglist:Graphiclist;
		protected var dinrglist:Graphiclist;
		protected var isotglist:Graphiclist;
		protected var cboyglist:Graphiclist;
		protected var amt:int = -1;
		
		public function AmmoBarHUD() 
		{
			graphic = bullglist;
			
			var i:int = 0;
			var img:Image;
			
			bullglist = new Graphiclist;
			smacglist = new Graphiclist;
			
			rcktglist = new Graphiclist;
			heatglist = new Graphiclist;
			dinrglist = new Graphiclist;
			isotglist = new Graphiclist;
			
			for (i = 1; i <= 10; i++)
			{
				img = new Image(Assets.GFX_HUD_AMICON_ROCKET);
				img.x = Assets.STAGE_SIZE_X / 2 + 32 + (i * 10);
				img.y = Assets.STAGE_SIZE_Y - 24;
				rcktglist.add(img);
			}
			
			for (i = 1; i <= 8; i++)
			{
				img = new Image(Assets.GFX_HUD_AMICON_HEAT);
				img.x = Assets.STAGE_SIZE_X / 2 + 32 + (i * 10);
				img.y = Assets.STAGE_SIZE_Y - 24;
				heatglist.add(img);
			}
			
			for (i = 1; i <= 8; i++)
			{
				img = new Image(Assets.GFX_HUD_AMICON_DINNER);
				img.x = Assets.STAGE_SIZE_X / 2 + 32 + (i * 10);
				img.y = Assets.STAGE_SIZE_Y - 24;
				dinrglist.add(img);
			}
			
			for (i = 1; i <= 6; i++)
			{
				img = new Image(Assets.GFX_HUD_AMICON_ISOTROPE);
				img.x = Assets.STAGE_SIZE_X / 2 + 32 + (i * 10);
				img.y = Assets.STAGE_SIZE_Y - 24;
				isotglist.add(img);
			}
			
			var bulletimg:Image = new Image(Assets.GFX_HUD_BULLICON);
			bulletimg.x = Assets.STAGE_SIZE_X - 32;
			bulletimg.y = Assets.STAGE_SIZE_Y - 24;
			
			var turboimg:Image = new Image(Assets.GFX_HUD_TURBOICON);
			turboimg.x = Assets.STAGE_SIZE_X - 32;
			turboimg.y = Assets.STAGE_SIZE_Y - 32;
			
			bullglist.add(bulletimg);
			
			smacglist.add(bulletimg);
			smacglist.add(turboimg);
			
			previousammo = -1;
			previoustype = -1;
		}
		
		public override function update():void
		{
			getAmmoAndType();
		}
		
		protected function getAmmoAndType():void
		{
			var playerList:Array = [];
			
			FP.world.getClass(Player, playerList);
			ammotype = playerList[0].returnRocketType();
			ammo = playerList[0].returnAmmo();
			hasSubmachine = playerList[0].returnHasSubmac();
			isRocketMode = playerList[0].checkRocketMode();
			
			if (isRocketMode) 
			{
				if (ammo != previousammo)
				{
					if (ammotype != previoustype)
					{
						changeAmmoIcon();
						previoustype = ammotype;
					}
					
					if (graphic is Graphiclist)
					{
						var gltmp:Graphiclist = graphic as Graphiclist;
						for (var i:int = gltmp.count - 1; i >= 0; i--)
						{
							if (i >= ammo)
								gltmp.children[i].visible = false;
							else
								gltmp.children[i].visible = true;
						}
					}
					
					previousammo = ammo;
				}
			}
			else
			{
				if (hasSubmachine)
				{
					graphic = smacglist;
				}
				graphic = bullglist;
			}
		}
		
		protected function changeAmmoIcon():void
		{
			if (ammotype == Player.RW_TYPE_BAZOOKA)
			{
				graphic = rcktglist;
			}
			else if (ammotype == Player.RW_TYPE_HEATSEEK)
			{
				graphic = heatglist;
			}
			else if (ammotype == Player.RW_TYPE_DINNERGUN)
			{
				graphic = dinrglist;
			}
			else if (ammotype == Player.RW_TYPE_ISOTROPE)
			{
				graphic = isotglist;
			}
		}
		
	}

}