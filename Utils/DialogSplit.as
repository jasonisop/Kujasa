package Utils
{
	// display related
	import flash.display.Sprite;
	import flash.display.BitmapData;
	
	// text related
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	import flash.text.TextField;
	
	// events
	import flash.events.Event;
	
	// geometry related
	import flash.geom.Rectangle;

	// custom classes
	import MapLogic.MapLoader;
	import Gfx.GfxFuncs;

	public class DialogSplit extends Sprite
	{
		private var ml:MapLoader;
		private var dialogTxt1:String;
		private var dialogTxt2:String;
		private var bg:uint = 0x000000;
		private var tx1:uint = 0xFFFFFF;
		private var tx2:uint;

		public function DialogSplit(mapLoader:MapLoader, Text1:String, Text2:String, TextColor:uint)
		{
			// define maploader object
			ml = mapLoader;

			// define how stuff should look
			dialogTxt1 = Text1;
			dialogTxt2 = Text2;
			tx2 = TextColor;

			// event listener for when we're added to the stage
			addEventListener(Event.ADDED_TO_STAGE, AddedToStage, false, 0, true);
		}

		// handle when we're added to the stage
		private function AddedToStage(e:Event)
		{
			// remove event listener
			removeEventListener(Event.ADDED_TO_STAGE, AddedToStage);

			// stage width can be found after dialog has been added to the stage
			var wide:uint = stage.stageWidth;
			var high:uint = 100;

			// simple text formatting
			var format:TextFormat = new TextFormat();
			format.font = new Game_Font().fontName;
			format.size = 40;

			// stylesheet for HTML formatting
			var style:StyleSheet = new StyleSheet();
			style.parseCSS('.item{color:#'+tx2.toString(16)+'; margin-left:45px;}');

			// setup textfield for top dialog;
			var txf:TextField = new TextField();
			txf.multiline = true;
			txf.wordWrap = true;
			txf.embedFonts = true;
			txf.defaultTextFormat = format;
			txf.styleSheet = style;
			txf.textColor = tx1;
			txf.x = 20;
			txf.y = 20;
			txf.width = wide - 40;
			txf.htmlText = '<p>' + dialogTxt1 + "</p><p class='item'>" + dialogTxt2 + "</p>";

			// add textfields to display list;
			addChild(txf);

			// draw semi-transparent background box below text
			this.graphics.beginFill(bg, .7);
			if (txf.textHeight > 100)
			{
				// set menu background height to text height
				txf.height = txf.textHeight;

				// make box bigger if text takes more than 100 pixels
				this.graphics.drawRect(16, 16, wide-32, txf.textHeight);
				
				high = txf.textHeight;
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
			ml.paintBackground(border, new Rectangle(12, 16, 64, high+8),this);

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
			ml.paintBackground(border, new Rectangle(wide-76, 16, 64, high+8),this);

			// top right corner of frame
			ml.paintBackground(frame, new Rectangle(wide-76, 12, 64, 32), this);

			// bottom left corner of frame
			frame = GfxFuncs.flipBitmapData(frame,'y');
			ml.paintBackground(frame, new Rectangle(wide-76, high-4, 64, 32), this);
		}

		// remove children and clear graphics
		public function Trash()
		{
			// clear graphics drawn
			this.graphics.clear();

			// remove all children objects;
			while (numChildren)
			{
				removeChildAt(0);
			}

			// set all references to null or zero
			dialogTxt1 = null;
			dialogTxt2 = null;
			bg = 0;
			tx1 = 0;
			tx2 = 0;
		}
	}
}