package Gfx
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;

	public class CharSheet
	{
		[Embed(source = "../graphics/lpc_base_assets/sprites/princess.png",mimeType = "image/png")]
		static const SpriteSheet00:Class;

		[Embed(source = "../graphics/lpc_base_assets/sprites/soldier.png",mimeType = "image/png")]
		static const SpriteSheet01:Class;

		[Embed(source = "../graphics/lpc_base_assets/sprites/soldier_altcolor.png",mimeType = "image/png")]
		static const SpriteSheet02:Class;

		// the character sheet to be read
		var bmd:BitmapData;

		// character direction storage
		var chars_up:Vector.<Rectangle > ;
		var chars_down:Vector.<Rectangle > ;
		var chars_left:Vector.<Rectangle > ;
		var chars_right:Vector.<Rectangle > ;

		// don't put comments above the constants, makes adobe CS 5.5 freak out
		// used to store the sprite sheets used
		private var sprites:Vector.<BitmapData > ;

		public const UP:uint = 0;
		public const DOWN:uint = 1;
		public const LEFT:uint = 2;
		public const RIGHT:uint = 3;

		private const wide:uint = 64;
		private const pt:Point = new Point();

		public function CharSheet()
		{
			// setup spritesheet container
			sprites = new Vector.<BitmapData > (3);

			generateBitmapData(new SpriteSheet00(), 0);
			generateBitmapData(new SpriteSheet01() ,1);
			generateBitmapData(new SpriteSheet02(), 2);

			// containers to hold where sprites are and their size
			chars_up = new Vector.<Rectangle > (9);
			chars_down = new Vector.<Rectangle > (9);
			chars_left = new Vector.<Rectangle > (9);
			chars_right = new Vector.<Rectangle > (9);

			// store sprite locations and sizes
			for (var i=0; i!=chars_up.length; i++)
			{
				chars_up[i] = new Rectangle(wide*i, wide*0, wide, wide);
				chars_left[i] = new Rectangle(wide*i, wide*1, wide, wide);
				chars_down[i] = new Rectangle(wide*i, wide*2, wide, wide);
				chars_right[i] = new Rectangle(wide*i, wide*3, wide, wide);
			}
		}

		public function getCharPos(facing:uint=1, position:uint=0, spriteImage:String=''):BitmapData
		{
			// blank canvas to draw our sprites
			var canvas:BitmapData = makeCanvas(wide,wide);
			var img:int;

			// determine which sprite sheet to use
			switch(spriteImage)
			{
				case 'princess':
					img = 0;
					break;

				case 'soldier':
					img = 1;
					break;

				case 'soldier alt':
					img = 2;
					break;

				default:
				case 'hero':
					img = 1;
					break;
			}

			// find out which direction we're facing
			switch (facing)
			{
				case 0 :
					canvas.copyPixels(sprites[img], chars_up[position], pt, null, null, true);
					break;

				case 1 :
					canvas.copyPixels(sprites[img], chars_down[position], pt, null, null, true);
					break;

				case 2 :
					canvas.copyPixels(sprites[img], chars_left[position], pt, null, null, true);
					break;

				case 3 :
					canvas.copyPixels(sprites[img], chars_right[position], pt, null, null, true);
					break;
			}

			// done, return the sprite bitmap data
			return canvas;
		}

		// create a transparent BitmapData suitable for these sprite sheets
		public function makeCanvas(Width:int, Height:int, TransparentColor:uint=0x00FFFFFF):BitmapData
		{
			return new BitmapData(Width, Height, true, TransparentColor);
		}
		
		/*
		Start of helper functions, private or protected only
		*/

		private function generateBitmapData(img:Bitmap, spriteNum:uint):void
		{
			sprites[spriteNum] = img.bitmapData;
		}
	}
}