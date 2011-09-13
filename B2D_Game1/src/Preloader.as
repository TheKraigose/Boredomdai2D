package
{
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.getDefinitionByName;

	[SWF(width = "720", height = "480")]
	
	// This preloader is by Draknek
	// and is perfect.
	public class Preloader extends Sprite
	{
		// Change these values
		private static const mustClick: Boolean = true;
		private static const mainClassName: String = "Main";
		
		private static const BG_COLOR:uint = 0x000000;
		private static const FG_COLOR:uint = 0xFFFFFF;
		
		[Embed(source = 'net/flashpunk/graphics/04B_03__.TTF', embedAsCFF="false", fontFamily = 'default')]
		private static const FONT:Class;
		
		
		
		// Ignore everything else
		
		
		
		// private var progressBar: Shape;
		private var text: TextField;
		
		private var px:int;
		private var py:int;
		private var w:int;
		private var h:int;
		private var sw:int;
		private var sh:int;
		private var pct:Number = 0.0;
		
		private var strDisplay:String;
		
		public function Preloader ()
		{
			sw = stage.stageWidth;
			sh = stage.stageHeight;
			
			w = stage.stageWidth * 0.8;
			h = 20;
			
			px = (sw - w) * 0.5;
			py = (sh - h) * 0.5;
			
			graphics.beginFill(BG_COLOR);
			graphics.drawRect(0, 0, sw, sh);
			graphics.endFill();
			
			strDisplay = "";
			
			text = new TextField();
			
			text.textColor = FG_COLOR;
			text.selectable = false;
			text.mouseEnabled = false;
			text.defaultTextFormat = new TextFormat("default", 16);
			text.embedFonts = true;
			text.autoSize = "left";
			text.text = strDisplay;
			text.x = 0;
			text.y = 0;
			
			addChild(text);
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			if (mustClick) {
				stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}

		public function onEnterFrame (e:Event): void
		{
			pct = (loaderInfo.bytesLoaded / loaderInfo.bytesTotal);
			strDisplay = GameStrings.getPreloaderMessages(pct * 100);
			text.text = strDisplay;
			if (hasLoaded())
			{
				graphics.clear();
				graphics.beginFill(BG_COLOR);
				graphics.drawRect(0, 0, sw, sh);
				graphics.endFill();
				
				if (! mustClick)
					startup();
				else
				{
					strDisplay = GameStrings.getPreloaderMessages(pct * 100);
				}
			}
			else
			{
				pct = (loaderInfo.bytesLoaded / loaderInfo.bytesTotal);	
			}
		}
		
		private function onMouseDown(e:MouseEvent):void {
			if (hasLoaded())
			{
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				startup();
			}
		}
		
		private function hasLoaded (): Boolean {
			return (loaderInfo.bytesLoaded >= loaderInfo.bytesTotal);
		}
		
		private function startup (): void {
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			var mainClass:Class = getDefinitionByName(mainClassName) as Class;
			parent.addChild(new mainClass as DisplayObject);
			
			parent.removeChild(this);
		}
	}
}