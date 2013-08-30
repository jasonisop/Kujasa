package Utils
{
	// display related
	import flash.display.Sprite;
	import flash.display.BitmapData;
	
	// text related
	import flash.text.TextFormat;
	import flash.text.TextField;
	
	// events
	import flash.events.Event;
	
	// geometry related
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	// custom classes
	import MapLogic.MapLoader;
	import Gfx.GfxFuncs;

	public class Dialog extends Sprite
	{
		private var ml:MapLoader;
		
		private var dialogTxt:String;
		private var imageRight:Boolean;
		private var bmd:BitmapData;
		private var offset:Point;
		private var wide:uint;
		private var bg:uint = 0x000000;
		private var tx:uint = 0xFFFFFF;

		public function Dialog(mapLoader:MapLoader, Text:String, Image:BitmapData=null, ImageRight:Boolean=false, Width:uint=0, Offset:Point=null)
		{
			// define map loader object
			ml = mapLoader;
			
			// defome display information
			imageRight = ImageRight;
			dialogTxt = Text;
			offset = Offset;
			wide = Width;
			bmd = Image;

			// event listener for when added to stage
			addEventListener(Event.ADDED_TO_STAGE, AddedToStage, false, 0, true);
		}

		// function to handle being added to stage
		private function AddedToStage(e:Event)
		{
			// remove event listener
			removeEventListener(Event.ADDED_TO_STAGE, AddedToStage);

			// make sure offset is a real object
			if (offset==null)
			{
				offset = new Point();
			}

			// make sure the value passed for width is valid
			if (wide<100)
			{
				// default to stage width
				wide = stage.stageWidth;
			}

			// ensure width is less than screen width
			if (wide+offset.x > stage.stageWidth)
			{
				wide = stage.stageWidth - offset.x;
			}

			// ensure height is less than screen height
			if (offset.y > stage.stageHeight - 134)
			{
				offset.y = stage.stageHeight - 134;
			}

			// how high the background is
			var high:uint = 100;

			// stage width can be found after dialog has been added to the stage
			var matrix:Matrix = new Matrix();

			// text formatting
			var format:TextFormat = new TextFormat();
			format.font = new Game_Font().fontName;
			format.size = 40;

			// setup textfield
			var txf:TextField = new TextField();
			txf.multiline = true;
			txf.wordWrap = true;
			txf.embedFonts = true;
			txf.defaultTextFormat = format;
			txf.textColor = tx;
			txf.x = 20;
			txf.y = 20;
			txf.width = wide - 40;

			// figure out what to display as text
			txf.htmlText = dialogTxt;

			// add text field to display children
			addChild(txf);

			// draw box around text and image
			this.graphics.beginFill(bg, .7);
			if (txf.textHeight > 107)
			{
				// make sure height of text box matches actual text height
				txf.height = txf.textHeight;

				// make box taller if text takes more than 100 pixels
				this.graphics.drawRect(16, 16, wide-32, txf.textHeight);
				
				high = txf.textHeight;
			}
			else
			{
				// 107 pixel box height minimum
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
			
			// text field positioning;
			if (bmd == null)
			{
				// no picture, just display text in the box
				txf.width = wide - 40;
			}
			else if (imageRight)
			{
				// make room for image to the right of the text
				txf.width = wide - 50 - bmd.width;

				// draw the image
				matrix.tx = wide - 20 - bmd.width;
				matrix.ty = 20;
				this.graphics.beginBitmapFill(bmd, matrix, false, false);
				this.graphics.drawRect(matrix.tx, matrix.ty, bmd.width, bmd.height);
				this.graphics.endFill();
			}
			else
			{
				// image to the left, adjust text position and width
				txf.width = wide - 50 - bmd.width;
				txf.x = 25 + bmd.width;

				// draw the image
				matrix.tx = 20;
				matrix.ty = 20;
				this.graphics.beginBitmapFill(bmd, matrix, false, false);
				this.graphics.drawRect(matrix.tx, matrix.ty, bmd.width, bmd.height);
				this.graphics.endFill();
			}
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

			// set all references to null, false, or zero
			imageRight = false;
			dialogTxt = null;
			bmd = null;
			bg = 0;
			tx = 0;
		}
	}
}