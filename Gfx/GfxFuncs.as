package Gfx
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class GfxFuncs
	{
		private static const pt:Point = new Point();

		// originally inspired by the function found at this url:
		// http://stackoverflow.com/questions/10722267/as3-scale-bitmapdata
		// modified by William Thompson, 22 June 2013
		public static function scaleBitmapData(bmd:BitmapData, scale:Number):BitmapData
		{
			// make sure scale is a positive number
			scale = Math.abs(scale);

			// figure out minimum values for width and height
			var w:int = (bmd.width * scale) || 1;
			var h:int = (bmd.height * scale) || 1;

			// make matrix to transform the bitmap data
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);

			// make a transparent canvas to draw upon
			var canvas:BitmapData = makeCanvas(w,h);

			// draw the newly scaled bitmap data onto our canvas
			canvas.draw(bmd, matrix);

			// return the new bitmap data
			return canvas;
		}

		// originally taken from the following url:
		// http://plasticsturgeon.com/2010/09/flipping-a-bitmapdata-image/
		// modified by William Thompson, 22 June 2013
		// helped with info from this url:
		// http://stackoverflow.com/questions/542716/flipping-bitmapdata-horizontally-in-flash-9-or-10
		public static function flipBitmapData(bmd:BitmapData, axis:String = "x"):BitmapData
		{
			// setup variables
			var matrix:Matrix = new Matrix();

			if (axis == "x")
			{
				// flip x
				matrix.scale(-1,1);
				matrix.translate(bmd.width, 0);
			}
			else
			{
				// flip y
				matrix.scale(1,-1);
				matrix.translate(0, bmd.height);
			}

			// make a transparent canvas to draw upon
			var canvas:BitmapData = makeCanvas(bmd.width,bmd.height);

			// draw bitmap data
			canvas.draw(bmd, matrix);

			// return newly flipped copy of bitmap data
			return canvas;
		}

		// copy a portion of a bitmap data
		public static function cropBitmapData(bmd:BitmapData, rect:Rectangle):BitmapData
		{
			// make canvas the appropriate size
			var canvas:BitmapData = makeCanvas(rect.width,rect.height);

			// copy the correct bitmap data
			canvas.copyPixels(bmd, rect, pt, null, null, true);

			// return the new bitmap
			return canvas;
		}

		// tile a bitmap data to make more of the same thing
		public static function tileBitmapData(bmd:BitmapData, qtyX:uint=1, qtyY:uint=1):BitmapData
		{
			if (qtyX==0)
			{
				qtyX = 1;
			}

			if (qtyY==0)
			{
				qtyY = 1;
			}

			// figure out minimum values for width and height
			var w:uint = (bmd.width * qtyX);
			var h:uint = (bmd.height * qtyY);

			// make a transparent canvas to draw upon
			var canvas:BitmapData = makeCanvas(w,h);

			// rectangle used for drawing
			var rect:Rectangle = new Rectangle(0,0,bmd.width,bmd.height);
			var point:Point = new Point(0,0);

			// used for tiling
			var i:uint;
			var j:uint;

			// copy bitmap data from original to canvas, tile across y
			for (i=0; i!=qtyY+1; i++)
			{
				// copy bitmap data from original to canvas, tile across x
				for (j=0; j!=qtyX+1; j++)
				{
					canvas.copyPixels(bmd, rect, point, null, null, true);
					point.x = j * bmd.width;
				}
				point.y = i * bmd.height;
			}

			// return the new bitmap data
			return canvas;
		}

		// create a transparent BitmapData
		public static function makeCanvas(Width:int, Height:int, TransparentColor:uint=0x00FFFFFF):BitmapData
		{
			return new BitmapData(Width, Height, true, TransparentColor);
		}

	}
}