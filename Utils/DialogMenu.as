package Utils
{
	// display objects
	import flash.display.Sprite;
	import flash.display.BitmapData;

	// text related
	import flash.text.TextFormat;
	import flash.text.TextField;

	// events
	import flash.events.MouseEvent;
	import flash.events.Event;

	// ui elements
	import flash.ui.Mouse;

	// geometry related
	import flash.geom.Rectangle;

	// utility classes
	import Utils.DialogMenuItem;
	import MapLogic.MapLoader;
	import Gfx.GfxFuncs;

	public class DialogMenu extends Sprite
	{
		private var dialogTxt:String;
		private var listener:Object;
		private var choice:Vector.<DialogMenuItem > ;
		private var bg:uint = 0x000000;
		private var tx:uint = 0xFFFFFF;
		private var format:TextFormat;
		private var ml:MapLoader;

		public function DialogMenu(mapLoader:MapLoader, Text:String)
		{
			// map loader object reference
			ml = mapLoader;
			
			// defome display information
			dialogTxt = Text;

			// setup menu choices
			choice = new Vector.<DialogMenuItem>();

			// text formatting
			format = new TextFormat();
			format.font = new Game_Font().fontName;
			format.size = 40;

			// event listener for when added to stage
			addEventListener(Event.ADDED_TO_STAGE, AddedToStage, false, 0, true);
		}

		// function to handle being added to stage
		private function AddedToStage(e:Event):void
		{
			// remove event listener
			removeEventListener(Event.ADDED_TO_STAGE, AddedToStage);

			// stop normal mouse and keyboard controls
			listener = stage.getChildAt(0);
			listener['removeListeners']();

			// default to stage width
			var wide:uint = stage.stageWidth;
			var high:uint = 100;

			// setup textfield
			var txf:TextField = new TextField();
			txf.multiline = true;
			txf.wordWrap = true;
			txf.embedFonts = true;
			txf.defaultTextFormat = format;
			txf.textColor = tx;
			txf.x = 20;
			txf.y = 20;

			// text field positioning
			txf.width = wide - 40;

			// figure out what to display as text
			txf.htmlText = '<p>' + dialogTxt + '</p><br />';

			// add text field to display children
			this.addChild(txf);

			// container to click on over choice items
			var sp:DialogMenuItem;

			// add menu choices
			for (var i=0; i!=choice.length; i++)
			{
				// identify click region
				sp = choice[i];

				// place click region in appropriate location
				sp.x = 45;
				sp.y = txf.textHeight;

				// add click region to menu
				addChild(sp);

				// make click region the same width as the text
				//sp.width = txf.width - 45;

				// add menu choice text
				txf.htmlText +=  '<ul><li>' + sp.text + '</li></ul>';
			}

			// set menu background height to text height
			if (txf.textHeight > 100)
			{
				txf.height = txf.textHeight;
				high = txf.textHeight-7;
			}

			// draw box around text and image
			this.graphics.beginFill(bg, .7);
			if (txf.height > 107)
			{
				// make box bigger if text takes more than 100 pixels
				this.graphics.drawRect(16, 16, wide-32, txf.height);
			}
			else
			{
				// default 100 pixel box minimum
				this.graphics.drawRect(16, 16, wide-32, 107);
			}
			this.graphics.endFill();

			// draw border;
			var frame = ml.bckgnd.Frame_Corner();

			// left side filler
			var border = GfxFuncs.cropBitmapData(frame,new Rectangle(0,0,64,16));
			ml.paintBackground(border, new Rectangle(12, 12, 64, high+16),this);

			// bottom filler
			border = GfxFuncs.cropBitmapData(frame,new Rectangle(48,0,16,32));
			ml.paintBackground(border, new Rectangle(32, high-4, wide-76, 32),this);

			// bottom left corner of frame
			ml.paintBackground(frame, new Rectangle(12, high-4, 64, 32), this);

			// top left corner of frame
			frame = GfxFuncs.flipBitmapData(frame,'y');
			ml.paintBackground(frame, new Rectangle(12, 12, 64, 32), this);

			// flip graphic around to fill right side
			frame = GfxFuncs.flipBitmapData(frame,'x');

			// top filler
			border = GfxFuncs.cropBitmapData(frame,new Rectangle(0,0,16,32));
			ml.paintBackground(border, new Rectangle(32, 12, wide-64, 32),this);

			// right side filler
			border = GfxFuncs.cropBitmapData(frame,new Rectangle(0,16,64,16));
			ml.paintBackground(border, new Rectangle(wide-76, 12, 64, high+16),this);

			// top right corner of frame
			ml.paintBackground(frame, new Rectangle(wide-76, 12, 64, 32), this);

			// bottom left corner of frame
			frame = GfxFuncs.flipBitmapData(frame,'y');
			ml.paintBackground(frame, new Rectangle(wide-76, high-4, 64, 32), this);
			
			// remove html markup and choice items
			txf.htmlText = '';
			txf.text = dialogTxt;
		}

		public function addChoice(Text:String, Callback:Function):void
		{
			// done building menu choice, add to our list of choices
			choice.push(new DialogMenuItem(Text, Callback, choiceHandler, format));
		}

		public function choiceHandler(dmi:DialogMenuItem):void
		{
			// call assigned menu item function
			ml.asyncEvent(dmi.func, 5);
			
			// continue to play dialog
			ml.asyncEvent(ml.unloadDialog, 10);
			
			// remove this dialog and continue playing
			ml.asyncEvent(ml.playDialog, 15);
		}

		// remove children and clear graphics
		public function Trash():void
		{
			// change mouse back to arrow
			Mouse.cursor = "arrow";
			
			// reinstate the event listeners for normal game play
			listener['addListeners']();
			listener = null;

			// clear graphics drawn
			this.graphics.clear();

			// empty menu choice list;
			while (choice.length)
			{
				choice[0].Trash();
				choice.shift();
			}

			// remove all children objects;
			while (numChildren)
			{
				removeChildAt(0);
			}

			// set all references to null
			ml = null;
			dialogTxt = null;
			format = null;
			bg = 0;
			tx = 0;
		}
	}
}