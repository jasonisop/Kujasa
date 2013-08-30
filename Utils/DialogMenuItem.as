package Utils
{
	// display objects
	import flash.display.Sprite;

	// text related
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	import flash.text.TextField;

	// events
	import flash.events.Event;
	import flash.events.MouseEvent;

	// ui elements
	import flash.ui.Mouse;

	public class DialogMenuItem extends Sprite
	{
		public var func:Function;
		public var choice:Function;
		public var text:String;
		public var format:TextFormat;
		private var bg:uint = 0x000000;
		private var tx:uint = 0xFFFFFF;
		private var txf:TextField;

		public function DialogMenuItem(Text:String, Callback:Function, choiceHandler:Function, Formatter:TextFormat)
		{
			// defome display text
			text = Text;
			format = Formatter;

			// setup menu choices callback function
			func = Callback;
			choice = choiceHandler;

			// event listener for when added to stage
			addEventListener(Event.ADDED_TO_STAGE, AddedToStage, false, 0, true);
		}

		// function to handle being added to stage
		private function AddedToStage(e:Event):void
		{
			// remove event listener
			removeEventListener(Event.ADDED_TO_STAGE, AddedToStage);

			// setup textfield
			txf = new TextField();
			txf.multiline = true;
			txf.wordWrap = true;
			txf.embedFonts = true;
			txf.defaultTextFormat = format;
			txf.textColor = tx;
			txf.width = stage.stageWidth - 85;

			// figure out what to display as text
			txf.text = '- ' + this.text;

			// add text field to display children
			addChild(txf);

			// set menu background height to text height
			txf.height = txf.textHeight;

			// mouse event handlers
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
			addEventListener(MouseEvent.CLICK, mouseClickHandler, false, 0, false);
		}

		// change text color on mouse over
		public function mouseOverHandler(me:MouseEvent):void
		{
			txf.textColor = 0x00FF00;
			Mouse.cursor = "button";
		}

		// change text color on mouse out
		public function mouseOutHandler(me:MouseEvent):void
		{
			txf.textColor = tx;
			Mouse.cursor = "arrow";
		}
		
		public function mouseClickHandler(me:MouseEvent):void
		{
			// call the choiceHandler function in DialogMenu
			choice(this);
		}

		// remove children and clear graphics
		public function Trash():void
		{
			// remove event listeners
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
			removeEventListener(MouseEvent.CLICK, mouseClickHandler);

			// remove all children objects;
			while (numChildren)
			{
				removeChildAt(0);
			}

			// set all references to null
			func = null;
			text = null;
			bg = 0;
			tx = 0;
		}
	}
}