package gui 
{
	import adobe.utils.CustomActions;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Mask;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	
	/**
	 * ...
	 * @author Kraig Culp
	 */
	public class ButtonBase extends Entity 
	{
		public static const BTN_STATE_IDLE:int = 0;
		public static const BTN_STATE_HOVER:int = 1;
		public static const BTN_STATE_CLICK:int = 2;
		public static const BTN_STATE_VISITED:int = 4;
		
		protected var btnText:Text;
		protected var btnColor:uint;
		protected var btnHoverColor:uint;
		protected var btnClickColor:uint;
		protected var btnVisitedColor:uint;
		protected var btnState:int;
		protected var btnPrevState:int;
		protected var btnRectangle:Rectangle;
		protected var btnIsOneTime:Boolean;
		protected var btnClickedNoise:Sfx = new Sfx(Assets.SFX_MENU_CLICK);
		protected var btnClicked:Boolean
		private var btnCallbackFunction:Function;
		
		public function ButtonBase(_sx:int=0, _sy:int=0, _txtString:String="Default", _tcolor:uint=0x000000, _bcolor:uint=0xFFFFFF, _bhcolor:uint=0xFF00FF, _bacolor:uint=0xFFFF00, _bvcolor:uint = 0x00FFFF, _otime:Boolean=false) 
		{
			super(_sx, _sy);
			btnText = new Text(_txtString);
			btnText.color = _tcolor;
			btnText.align = "left";
			
			layer = -3;
			btnColor = _bcolor;
			btnHoverColor = _bhcolor;
			btnClickColor = _bacolor;
			btnVisitedColor = _bvcolor;
			
			width = btnText.scaledWidth;
			height = btnText.scaledHeight;
			
			addGraphic(btnText);
			btnIsOneTime = _otime;
			
			if (btnIsOneTime)
			{
				btnClicked = false;
			}
			
			btnRectangle = new Rectangle(x, y, width, height);
			btnState = ButtonBase.BTN_STATE_IDLE;
			btnPrevState = btnState;
			btnCallbackFunction == null;
		}
		
		public function getState():int
		{
			return btnState;
		}
		
		public function setCallback(f:Function):void
		{
			btnCallbackFunction = f;
		}
		
		protected function checkMouseRange():void
		{
			var mRect:Rectangle = new Rectangle(Input.mouseX, Input.mouseY, 8, 8);
			if (mRect.intersects(btnRectangle))
			{
				btnState = ButtonBase.BTN_STATE_HOVER;
				if (Input.mousePressed && ((!btnClicked && btnIsOneTime) || !btnIsOneTime))
				{
					btnPrevState = btnState;
					btnState = ButtonBase.BTN_STATE_CLICK;
					if (btnIsOneTime)
					{
						btnClicked = true;
					}
				}
				else
				{
					if (btnState == ButtonBase.BTN_STATE_CLICK)
						btnState = ButtonBase.BTN_STATE_IDLE;
				}
			}
			else
			{
				if (btnState == ButtonBase.BTN_STATE_HOVER)
					btnState = ButtonBase.BTN_STATE_IDLE;
				else if (btnState == ButtonBase.BTN_STATE_CLICK)
					btnState = ButtonBase.BTN_STATE_IDLE;
			}
		}
		
		public override function render():void
		{
			var btnDrawcolor:uint;
			switch(btnState)
			{
				default:
				case ButtonBase.BTN_STATE_IDLE:
					btnDrawcolor = btnColor;
					break;
				case ButtonBase.BTN_STATE_HOVER:
					btnDrawcolor = btnHoverColor;
					break;
				case ButtonBase.BTN_STATE_CLICK:
					btnDrawcolor = btnClickColor;
					break;
				case ButtonBase.BTN_STATE_VISITED:
					btnDrawcolor = btnVisitedColor;
			}
			
			Draw.rect(x, y, width, height, btnDrawcolor, 1, false);
			super.render();
		}
		
		public override function update():void
		{
			super.update();
			checkMouseRange();
			if (btnState == ButtonBase.BTN_STATE_CLICK)
			{
				btnClickedNoise.play(Options.soundFxVolume);
				if (btnCallbackFunction != null)
					btnCallbackFunction.call();
			}
		}
		
		private function PlayClickSnd():void
		{
			if (Options.soundFxEnabled)
			{
				btnClickedNoise.play(Options.soundFxVolume);
				btnClickedNoise.volume = Options.soundFxVolume;
			}
		}
	}

}