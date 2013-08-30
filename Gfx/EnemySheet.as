package Gfx
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;

	public class EnemySheet
	{
		[Embed(source = "../graphics/lpc_base_assets/sprites/bat.png",mimeType = "image/png")]
		static const SpriteSheet00:Class;

		[Embed(source = "../graphics/lpc_base_assets/sprites/bee.png",mimeType = "image/png")]
		static const SpriteSheet01:Class;

		[Embed(source = "../graphics/lpc_base_assets/sprites/big_worm.png",mimeType = "image/png")]
		static const SpriteSheet02:Class;

		[Embed(source = "../graphics/lpc_base_assets/sprites/eyeball.png",mimeType = "image/png")]
		static const SpriteSheet03:Class;

		[Embed(source = "../graphics/lpc_base_assets/sprites/ghost.png",mimeType = "image/png")]
		static const SpriteSheet04:Class;

		[Embed(source = "../graphics/lpc_base_assets/sprites/man_eater_flower.png",mimeType = "image/png")]
		static const SpriteSheet05:Class;

		[Embed(source = "../graphics/lpc_base_assets/sprites/pumpking.png",mimeType = "image/png")]
		static const SpriteSheet06:Class;

		[Embed(source = "../graphics/lpc_base_assets/sprites/slime.png",mimeType = "image/png")]
		static const SpriteSheet07:Class;

		[Embed(source = "../graphics/lpc_base_assets/sprites/small_worm.png",mimeType = "image/png")]
		static const SpriteSheet08:Class;

		[Embed(source = "../graphics/lpc_base_assets/sprites/snake.png",mimeType = "image/png")]
		static const SpriteSheet09:Class;

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

		private const wide:uint = 32;
		private const pt:Point = new Point();

		public function EnemySheet()
		{
			// setup spritesheet container
			sprites = new Vector.<BitmapData > (10);

			generateBitmapData(new SpriteSheet00() ,0);
			generateBitmapData(new SpriteSheet01(), 1);
			generateBitmapData(new SpriteSheet02(), 2);
			generateBitmapData(new SpriteSheet03(), 3);
			generateBitmapData(new SpriteSheet04(), 4);
			generateBitmapData(new SpriteSheet05(), 5);
			generateBitmapData(new SpriteSheet06(), 6);
			generateBitmapData(new SpriteSheet07(), 7);
			generateBitmapData(new SpriteSheet08(), 8);
			generateBitmapData(new SpriteSheet09(), 9);

			// containers to hold where sprites are and their size
			chars_up = new Vector.<Rectangle > (3);
			chars_down = new Vector.<Rectangle > (3);
			chars_left = new Vector.<Rectangle > (3);
			chars_right = new Vector.<Rectangle > (3);

			// store sprite locations and sizes
			for (var i=0; i!=chars_up.length; i++)
			{
				chars_up[i] = new Rectangle(wide*i, wide*0, wide, wide);
				chars_left[i] = new Rectangle(wide*i, wide*1, wide, wide);
				chars_down[i] = new Rectangle(wide*i, wide*2, wide, wide);
				chars_right[i] = new Rectangle(wide*i, wide*3, wide, wide);
			}
		}

		public function getCharPos(facing:uint=1, position:uint=0, spriteImage:uint=0):BitmapData
		{
			// blank canvas to draw our sprites
			var canvas:BitmapData = makeCanvas(wide,wide);

			// find out which direction we're facing
			switch (facing)
			{
				case 0 :
					canvas.copyPixels(sprites[spriteImage], chars_up[position], pt, null, null, true);
					break;

				case 1 :
					canvas.copyPixels(sprites[spriteImage], chars_down[position], pt, null, null, true);
					break;

				case 2 :
					canvas.copyPixels(sprites[spriteImage], chars_left[position], pt, null, null, true);
					break;

				case 3 :
					canvas.copyPixels(sprites[spriteImage], chars_right[position], pt, null, null, true);
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