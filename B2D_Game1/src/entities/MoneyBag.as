package entities 
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class MoneyBag extends ScoreItem 
	{
		
		public function MoneyBag(_sx:int, _sy:int) 
		{
			super(_sx, _sy, 100);
			
			sfxPickup = new Sfx(Assets.SFX_MONEY);
			
			graphic = new Image(Assets.SPR_MONEY);
		}
		
	}

}