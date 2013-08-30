package Gfx
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.geom.Matrix;

	public class Background
	{
		// embed resources from raw source
		[Embed(source = '../graphics/lpc_base_assets/barrel.png',mimeType = 'image/png')]
		static const SpriteSheet01:Class;

		[Embed(source = '../graphics/lpc_base_assets/brackish.png',mimeType = 'image/png')]
		static const SpriteSheet02:Class;

		[Embed(source = '../graphics/lpc_base_assets/bridges.png',mimeType = 'image/png')]
		static const SpriteSheet03:Class;

		[Embed(source = '../graphics/lpc_base_assets/buckets.png',mimeType = 'image/png')]
		static const SpriteSheet04:Class;

		[Embed(source = '../graphics/lpc_base_assets/cabinets.png',mimeType = 'image/png')]
		static const SpriteSheet05:Class;

		[Embed(source = '../graphics/lpc_base_assets/castle_lightsources.png',mimeType = 'image/png')]
		static const SpriteSheet06:Class;

		[Embed(source = '../graphics/lpc_base_assets/castle_outside.png',mimeType = 'image/png')]
		static const SpriteSheet07:Class;

		[Embed(source = '../graphics/lpc_base_assets/castlefloors.png',mimeType = 'image/png')]
		static const SpriteSheet08:Class;

		[Embed(source = '../graphics/lpc_base_assets/castlefloors_outside.png',mimeType = 'image/png')]
		static const SpriteSheet09:Class;

		[Embed(source = '../graphics/lpc_base_assets/castlewalls.png',mimeType = 'image/png')]
		static const SpriteSheet10:Class;

		[Embed(source = '../graphics/lpc_base_assets/cement.png',mimeType = 'image/png')]
		static const SpriteSheet11:Class;

		[Embed(source = '../graphics/lpc_base_assets/cementstair.png',mimeType = 'image/png')]
		static const SpriteSheet12:Class;

		[Embed(source = '../graphics/lpc_base_assets/chests.png',mimeType = 'image/png')]
		static const SpriteSheet13:Class;

		[Embed(source = '../graphics/lpc_base_assets/country.png',mimeType = 'image/png')]
		static const SpriteSheet14:Class;

		[Embed(source = '../graphics/lpc_base_assets/cup.png',mimeType = 'image/png')]
		static const SpriteSheet15:Class;

		[Embed(source = '../graphics/lpc_base_assets/dirt.png',mimeType = 'image/png')]
		static const SpriteSheet16:Class;

		[Embed(source = '../graphics/lpc_base_assets/dirt2.png',mimeType = 'image/png')]
		static const SpriteSheet17:Class;

		[Embed(source = '../graphics/lpc_base_assets/dungeon.png',mimeType = 'image/png')]
		static const SpriteSheet18:Class;

		[Embed(source = '../graphics/lpc_base_assets/grass.png',mimeType = 'image/png')]
		static const SpriteSheet19:Class;

		[Embed(source = '../graphics/lpc_base_assets/grassalt.png',mimeType = 'image/png')]
		static const SpriteSheet20:Class;

		[Embed(source = '../graphics/lpc_base_assets/hole.png',mimeType = 'image/png')]
		static const SpriteSheet21:Class;

		[Embed(source = '../graphics/lpc_base_assets/holek.png',mimeType = 'image/png')]
		static const SpriteSheet22:Class;

		[Embed(source = '../graphics/lpc_base_assets/holemid.png',mimeType = 'image/png')]
		static const SpriteSheet23:Class;

		[Embed(source = '../graphics/lpc_base_assets/house.png',mimeType = 'image/png')]
		static const SpriteSheet24:Class;

		[Embed(source = '../graphics/lpc_base_assets/inside.png',mimeType = 'image/png')]
		static const SpriteSheet25:Class;

		[Embed(source = '../graphics/lpc_base_assets/kitchen.png',mimeType = 'image/png')]
		static const SpriteSheet26:Class;

		[Embed(source = '../graphics/lpc_base_assets/lava.png',mimeType = 'image/png')]
		static const SpriteSheet27:Class;

		[Embed(source = '../graphics/lpc_base_assets/lavarock.png',mimeType = 'image/png')]
		static const SpriteSheet28:Class;

		[Embed(source = '../graphics/lpc_base_assets/mountains.png',mimeType = 'image/png')]
		static const SpriteSheet29:Class;

		[Embed(source = '../graphics/lpc_base_assets/rock.png',mimeType = 'image/png')]
		static const SpriteSheet30:Class;

		[Embed(source = '../graphics/lpc_base_assets/shadow.png',mimeType = 'image/png')]
		static const SpriteSheet31:Class;

		[Embed(source = '../graphics/lpc_base_assets/signs.png',mimeType = 'image/png')]
		static const SpriteSheet32:Class;

		[Embed(source = '../graphics/lpc_base_assets/stairs.png',mimeType = 'image/png')]
		static const SpriteSheet33:Class;

		[Embed(source = '../graphics/lpc_base_assets/treetop.png',mimeType = 'image/png')]
		static const SpriteSheet34:Class;

		[Embed(source = '../graphics/lpc_base_assets/trunk.png',mimeType = 'image/png')]
		static const SpriteSheet35:Class;

		[Embed(source = '../graphics/lpc_base_assets/victoria.png',mimeType = 'image/png')]
		static const SpriteSheet36:Class;

		[Embed(source = '../graphics/lpc_base_assets/water.png',mimeType = 'image/png')]
		static const SpriteSheet37:Class;

		[Embed(source = '../graphics/lpc_base_assets/waterfall.png',mimeType = 'image/png')]
		static const SpriteSheet38:Class;

		[Embed(source = '../graphics/lpc_base_assets/watergrass.png',mimeType = 'image/png')]
		static const SpriteSheet39:Class;

		[Embed(source = '../graphics/custom/frame_corner.png',mimeType = 'image/png')]
		static const Custom01:Class;

		// used regularly for drawing bitmap data
		private static var white:uint = 0x00FFFFFF;
		private static var pt:Point= new Point();

		// image data containers
		private var _barrel:BitmapData;
		private var _brackish:BitmapData;
		private var _bridges:BitmapData;
		private var _buckets:BitmapData;
		private var _cabinets:BitmapData;
		private var _castle_lightsources:BitmapData;
		private var _castle_outside:BitmapData;
		private var _castlefloors:BitmapData;
		private var _castlefloors_outside:BitmapData;
		private var _castlewalls:BitmapData;
		private var _cement:BitmapData;
		private var _cementstair:BitmapData;
		private var _chests:BitmapData;
		private var _country:BitmapData;
		private var _cup:BitmapData;
		private var _dirt:BitmapData;
		private var _dirt2:BitmapData;
		private var _dungeon:BitmapData;
		private var _grass:BitmapData;
		private var _grassalt:BitmapData;
		private var _hole:BitmapData;
		private var _holek:BitmapData;
		private var _holemid:BitmapData;
		private var _house:BitmapData;
		private var _inside:BitmapData;
		private var _kitchen:BitmapData;
		private var _lava:BitmapData;
		private var _lavarock:BitmapData;
		private var _mountains:BitmapData;
		private var _rock:BitmapData;
		private var _shadow:BitmapData;
		private var _signs:BitmapData;
		private var _stairs:BitmapData;
		private var _treetop:BitmapData;
		private var _trunk:BitmapData;
		private var _victoria:BitmapData;
		private var _water:BitmapData;
		private var _waterfall:BitmapData;
		private var _watergrass:BitmapData;
		private var _frame_corner:BitmapData;

		// image rectangle locations within the bitmap data
		private var barrel:Vector.<Rectangle > ;
		private var brackish:Vector.<Rectangle > ;
		private var bridges:Vector.<Rectangle > ;
		private var buckets:Vector.<Rectangle > ;
		private var cabinets:Vector.<Rectangle > ;
		private var castle_lightsources:Vector.<Rectangle > ;
		private var castle_outside:Vector.<Rectangle > ;
		private var castlefloors:Vector.<Rectangle > ;
		private var castlefloors_outside:Vector.<Rectangle > ;
		private var castlewalls:Vector.<Rectangle > ;
		private var cement:Vector.<Rectangle > ;
		private var cementstair:Vector.<Rectangle > ;
		private var chests:Vector.<Rectangle > ;
		private var country:Vector.<Rectangle > ;
		private var cup:Rectangle;
		private var dirt:Vector.<Rectangle > ;
		private var dirt2:Vector.<Rectangle > ;
		private var dungeon:Vector.<Rectangle > ;
		private var grass:Vector.<Rectangle > ;
		private var grassalt:Vector.<Rectangle > ;
		private var hole:Vector.<Rectangle > ;
		private var holek:Vector.<Rectangle > ;
		private var holemid:Vector.<Rectangle > ;
		private var house:Vector.<Rectangle > ;
		private var inside:Vector.<Rectangle > ;
		private var kitchen:Vector.<Rectangle > ;
		private var lava:Vector.<Rectangle > ;
		private var lavarock:Vector.<Rectangle > ;
		private var mountains:Vector.<Rectangle > ;
		private var rock:Vector.<Rectangle > ;
		private var shadow:Vector.<Rectangle > ;
		private var signs:Vector.<Rectangle > ;
		private var stairs:Vector.<Rectangle > ;
		private var treetop:Vector.<Rectangle > ;
		private var trunk:Vector.<Rectangle > ;
		private var victoria:Vector.<Rectangle > ;
		private var water:Vector.<Rectangle > ;
		private var waterfall:Rectangle;
		private var watergrass:Vector.<Rectangle > ;
		private var frame_corner:Rectangle;

		public function Background()
		{
			// variables used during constructor call
			var i:uint = 0;

			/*
			 * Define bitmap data for each image
			 */
			//_barrel = new GFX_Barrel();
			generateBitmapData(new SpriteSheet01(), '_barrel');
			generateBitmapData(new SpriteSheet02(), '_brackish');
			generateBitmapData(new SpriteSheet03(), '_bridges');
			generateBitmapData(new SpriteSheet04(), '_buckets');
			generateBitmapData(new SpriteSheet05(), '_cabinets');
			generateBitmapData(new SpriteSheet06(), '_castle_lightsources');
			generateBitmapData(new SpriteSheet07(), '_castle_outside');
			generateBitmapData(new SpriteSheet08(), '_castlefloors');
			generateBitmapData(new SpriteSheet09(), '_castlefloors_outside');
			generateBitmapData(new SpriteSheet10(), '_castlewalls');
			generateBitmapData(new SpriteSheet11(), '_cement');
			generateBitmapData(new SpriteSheet12(), '_cementstair');
			generateBitmapData(new SpriteSheet13(), '_chests');
			generateBitmapData(new SpriteSheet14(), '_country');
			generateBitmapData(new SpriteSheet15(), '_cup');
			generateBitmapData(new SpriteSheet16(), '_dirt');
			generateBitmapData(new SpriteSheet17(), '_dirt2');
			generateBitmapData(new SpriteSheet18(), '_dungeon');
			generateBitmapData(new SpriteSheet19(), '_grass');
			generateBitmapData(new SpriteSheet20(), '_grassalt');
			generateBitmapData(new SpriteSheet21(), '_hole');
			generateBitmapData(new SpriteSheet22(), '_holek');
			generateBitmapData(new SpriteSheet23(), '_holemid');
			generateBitmapData(new SpriteSheet24(), '_house');
			generateBitmapData(new SpriteSheet25(), '_inside');
			generateBitmapData(new SpriteSheet26(), '_kitchen');
			generateBitmapData(new SpriteSheet27(), '_lava');
			generateBitmapData(new SpriteSheet28(), '_lavarock');
			generateBitmapData(new SpriteSheet29(), '_mountains');
			generateBitmapData(new SpriteSheet30(), '_rock');
			generateBitmapData(new SpriteSheet31(), '_shadow');
			generateBitmapData(new SpriteSheet32(), '_signs');
			generateBitmapData(new SpriteSheet33(), '_stairs');
			generateBitmapData(new SpriteSheet34(), '_treetop');
			generateBitmapData(new SpriteSheet35(), '_trunk');
			generateBitmapData(new SpriteSheet36(), '_victoria');
			generateBitmapData(new SpriteSheet37(), '_water');
			generateBitmapData(new SpriteSheet38(), '_waterfall');
			generateBitmapData(new SpriteSheet39(), '_watergrass');
			
			generateBitmapData(new Custom01(), '_frame_corner');

			/*
			 * Define rectangle location for each image within its bitmap data
			 */

			// barrel
			barrel = new Vector.<Rectangle > (2);
			barrel[0] = new Rectangle(2,10,28,38);
			barrel[1] = new Rectangle(64,2,48,61);

			// brackish
			parseGround('brackish');

			// bridges
			bridges = new Vector.<Rectangle > (19);
			// facing left-right, no rails
			bridges[0] = new Rectangle(32*0,32*0,32,45);
			bridges[1] = new Rectangle(32*1,32*0,32,45);
			bridges[2] = new Rectangle(32*2,32*0,32,45);
			// facing left-right, with rails
			bridges[3] = new Rectangle(32*3,16*1,32,60);
			bridges[4] = new Rectangle(32*4,16*1,32,60);
			bridges[5] = new Rectangle(32*5,16*1,32,60);
			// facing left-right slats, no rails
			bridges[6] = new Rectangle(32*3,32*6,32,32);
			// facing left-right slats, only the side rail
			bridges[7] = new Rectangle(32*0,32*5,32,32);
			bridges[8] = new Rectangle(32*1,32*5,32,32);
			bridges[9] = new Rectangle(32*2,32*5,32,32);
			// facing down, no rails
			bridges[10] = new Rectangle(32*0,16*5,32,16);
			bridges[11] = new Rectangle(32*0,16*6,32,32);
			bridges[12] = new Rectangle(32*0,16*8,32,16);
			// facing down, with rails
			bridges[13] = new Rectangle(32*1,16*4,32,32);
			bridges[14] = new Rectangle(32*1,16*6,32,16);
			// facing down slats, no rails
			bridges[15] = new Rectangle(32*3,32*3,32,32);
			// facing down slats, only the side rail, left side
			bridges[16] = new Rectangle(1+32*2,32*2,5,32);
			bridges[17] = new Rectangle(1+32*2,32*3,5,32);
			bridges[18] = new Rectangle(1+32*2,32*4,5,32);

			// buckets
			buckets = new Vector.<Rectangle > (2);
			buckets[0] = new Rectangle(0,0,32,32);
			buckets[1] = new Rectangle(0,32,32,32);

			// cabinets

			// castle_lightsources
			castle_lightsources = new Vector.<Rectangle > (3);
			castle_lightsources[0] = new Rectangle(29,6,6,25);
			castle_lightsources[1] = new Rectangle(72,4,16,56);
			castle_lightsources[2] = new Rectangle(124,15,8,74);

			// castle_outside

			// castlefloors

			// castlefloors_outside

			// castlewalls

			// cement
			parseGround('cement');

			// cementstair
			cementstair = new Vector.<Rectangle>(2);
			cementstair[0] = new Rectangle(32, 31, 64, 66);
			cementstair[1] = new Rectangle(32, 97, 64, 61);

			// chests
			chests = new Vector.<Rectangle>(6);
			chests[0] = new Rectangle(32*0, 32*0, 32, 32);
			chests[1] = new Rectangle(32*0, 32*1, 32, 32);
			chests[2] = new Rectangle(32*0, 32*2, 32, 32);
			chests[3] = new Rectangle(32*1, 32*0, 32, 32);
			chests[4] = new Rectangle(32*1, 32*1, 32, 32);
			chests[5] = new Rectangle(32*1, 32*2, 32, 32);

			// country
			country = new Vector.<Rectangle>(5);
			// bed
			country[0] = new Rectangle(8, 15, 48, 81);
			// chairs, back rest is: up, down, left, right
			country[1] = new Rectangle(67, 0, 26, 32);
			country[2] = new Rectangle(67, 40, 26, 24);
			country[3] = new Rectangle(69, 64, 22, 32);
			country[4] = new Rectangle(69, 96, 22, 32);

			// cup
			cup = new Rectangle(0,10,_cup.width,_cup.height - 10);

			// dirt
			parseGround('dirt');

			// dirt2
			parseGround('dirt2');

			// dungeon

			// grass
			parseGround('grass');

			// grassalt
			parseGround('grassalt');

			// hole
			parseGround('hole');

			// holek
			parseGround('holek');

			// holemid
			parseGround('holemid');

			// house
			house = new Vector.<Rectangle > (44);
			// red brick wall, top
			house[0] = new Rectangle(32*0, 32*0, 32, 32);
			house[1] = new Rectangle(32*1, 32*0, 32, 32);
			house[2] = new Rectangle(32*2, 32*0, 32, 32);
			// red brick wall, middle
			house[3] = new Rectangle(32*0, 32*1, 32, 32);
			house[4] = new Rectangle(32*1, 32*1, 32, 32);
			house[5] = new Rectangle(32*2, 32*1, 32, 32);
			// red brick wall, bottom
			house[6] = new Rectangle(32*0, 32*2, 32, 32);
			house[7] = new Rectangle(32*1, 32*2, 32, 32);
			house[8] = new Rectangle(32*2, 32*2, 32, 32);
			// doors
			house[9] = new Rectangle(32*3, 32*0, 32, 48);
			house[10] = new Rectangle(32*5, 32*0, 32, 48);
			// steps
			house[11] = new Rectangle(32*4, 32*.5, 32, 32);
			// windows
			house[12] = new Rectangle(226,0,28,32);
			house[13] = new Rectangle(256,10,32,44);
			// chimney
			house[14] = new Rectangle(199,11,22,45);
			// window and door framing bits
			house[15] = new Rectangle(32*3, 80, 32, 16);
			house[16] = new Rectangle(32*4, 80, 32, 16);
			// door frame
			house[17] = new Rectangle(232,90,48,54);
			// roofing bits, face
			house[18] = new Rectangle(32*0, 32*5, 32, 32);
			house[19] = new Rectangle(32*1, 32*5, 32, 32);
			house[20] = new Rectangle(32*2, 32*5, 32, 32);
			house[21] = new Rectangle(32*0, 32*6, 32, 32);
			house[22] = new Rectangle(32*2, 32*6, 32, 32);
			// roofing bits, sides
			house[23] = new Rectangle(32*0, 32*3, 32, 32);
			house[24] = new Rectangle(32*1, 32*3, 32, 32);
			house[25] = new Rectangle(32*2, 32*3, 32, 32);
			house[26] = new Rectangle(32*0, 32*4, 32, 32);
			house[27] = new Rectangle(32*1, 32*4, 32, 32);
			house[28] = new Rectangle(32*2, 32*4, 32, 32);
			// roof bits, top (1x high, 3x wide)
			house[29] = new Rectangle(32*3, 32*3, 32, 32);
			house[30] = new Rectangle(32*4, 32*3, 32, 32);
			house[31] = new Rectangle(32*5, 32*3, 32, 32);
			// roof bits, top (2x high, 3x wide, top half)
			house[32] = new Rectangle(32*3, 32*4, 32, 32);
			house[33] = new Rectangle(32*4, 32*4, 32, 32);
			house[34] = new Rectangle(32*5, 32*4, 32, 32);
			// roof bits, top (2x high, 3x wide, bottom half)
			house[35] = new Rectangle(32*3, 32*5, 32, 32);
			house[36] = new Rectangle(32*4, 32*5, 32, 32);
			house[37] = new Rectangle(32*5, 32*5, 32, 32);
			// roof bits, top (repeat high, 3x wide)
			house[38] = new Rectangle(32*3, 32*6, 32, 32);
			house[39] = new Rectangle(32*4, 32*6, 32, 32);
			house[40] = new Rectangle(32*5, 32*6, 32, 32);
			// roof bits, top (2x high, 1x wide, going down)
			house[41] = new Rectangle(32*6, 32*4, 32, 32);
			house[42] = new Rectangle(32*6, 32*5, 32, 32);
			// roof bits, top (repeat high, 1x wide)
			house[43] = new Rectangle(32*6, 32*6, 32, 32);

			// inside
			inside = new Vector.<Rectangle > (7);
			// floor
			inside[0] = new Rectangle(32*0, 32*4, 32, 32);
			// blank wall, 3x wide 3x high, 32 pixel wide chuncks
			inside[1] = new Rectangle(32*0, 32*0, 32, 97);
			inside[2] = new Rectangle(32*1, 32*0, 32, 97);
			inside[3] = new Rectangle(32*2, 32*0, 32, 97);
			// blank wall, 1x wide 3x high
			inside[4] = new Rectangle(32*7, 32*0, 32, 97);
			// wall decoration panels
			inside[5] = new Rectangle(32*0, 178, 32, 62);
			inside[6] = new Rectangle(48,242,32,58);

			// kitchen

			// lava
			parseGround('lava');

			// lava rock
			parseGround('lavarock');

			// mountains

			// rock
			rock = new Vector.<Rectangle > (2);
			rock[0] = new Rectangle(32*0, 32*0, 32, 32);
			rock[1] = new Rectangle(32*1, 32*0, 32, 32);

			// shadow

			// signs
			signs = new Vector.<Rectangle > (3);
			signs[0] = new Rectangle(0,36,24,24);
			signs[1] = new Rectangle(32,36,24,24);
			signs[2] = new Rectangle(63,36,24,24);

			// stairs
			stairs = new Vector.<Rectangle>(10);
			stairs[0] = new Rectangle(32*0, 32*0, 32*2, 32*3);
			stairs[1] = new Rectangle(32*2, 32*0, 32*2, 32*3);
			stairs[2] = new Rectangle(32*0, 32*3, 32*2, 32*3);
			stairs[3] = new Rectangle(32*2, 32*3, 32*2, 32*3);
			stairs[4] = new Rectangle(32*0, 32*6, 32*2, 32*1);
			stairs[5] = new Rectangle(32*2, 32*6, 32*2, 32*1);
			stairs[6] = new Rectangle(32*0, 32*7, 32*2, 32*2);
			stairs[7] = new Rectangle(32*2, 32*7, 32*2, 32*2);
			stairs[8] = new Rectangle(32*0, 32*9, 32*2, 32*2);
			stairs[9] = new Rectangle(32*2, 32*9, 32*2, 32*2);

			// treetops
			treetop = new Vector.<Rectangle > (2);
			treetop[0] = new Rectangle(1,0,94,80);
			treetop[1] = new Rectangle(4,101,85,91);

			// trunks
			trunk = new Vector.<Rectangle > (2);
			trunk[0] = new Rectangle(16,0,64,73);
			trunk[1] = new Rectangle(115,0,59,71);

			// victoria
			victoria = new Vector.<Rectangle>();
			// fill in later

			// water
			parseGround('water');

			// waterfall
			waterfall = new Rectangle(0,0,_waterfall.width,_waterfall.height);

			// watergrass
			parseGround('watergrass');
			
			// custom frame corner
			frame_corner = new Rectangle(0,0,_frame_corner.width,_frame_corner.height);
		}

		// returns a barrel
		public function Barrel(type:uint=0):BitmapData
		{
			return getBitmapData(_barrel, barrel[type]);
		}

		// returns a brackish
		public function Brackish(Description:String='outside top left'):BitmapData
		{
			return getGround(_brackish, 'brackish', Description);
		}

		// returns a bucket
		public function Bucket(type:uint=0):BitmapData
		{
			return getBitmapData(_buckets, buckets[type]);
		}

		// returns a castle light source
		public function CastleLightsource(type:uint=0):BitmapData
		{
			return getBitmapData(_castle_lightsources, castle_lightsources[type]);
		}

		// returns a cement
		public function Cement(Description:String='outside top left'):BitmapData
		{
			return getGround(_cement, 'cement', Description);
		}

		// returns a cementstairs
		public function Cementstair(type:uint=0):BitmapData
		{
			return getBitmapData(_cementstair, cementstair[type]);
		}

		// returns a chests
		public function Chests(type:uint=0):BitmapData
		{
			return getBitmapData(_chests, chests[type]);
		}

		// returns pixel cup
		public function Cup():BitmapData
		{
			return getBitmapData(_cup, cup);
		}

		// returns dirt
		public function Dirt(Description:String='outside top left'):BitmapData
		{
			return getGround(_dirt, 'dirt', Description);
		}

		// returns dirt2
		public function Dirt2(Description:String='outside top left'):BitmapData
		{
			return getGround(_dirt2, 'dirt2', Description);
		}

		// returns grass
		public function Grass(Description:String='outside top left'):BitmapData
		{
			return getGround(_grass, 'grass', Description);
		}

		// returns alternate grass
		public function Grassalt(Description:String='outside top left'):BitmapData
		{
			return getGround(_grassalt, 'grassalt', Description);
		}

		// returns a hole
		public function Hole(Description:String='outside top left'):BitmapData
		{
			return getGround(_hole, 'hole', Description);
		}

		// returns a holek
		public function Holek(Description:String='outside top left'):BitmapData
		{
			return getGround(_holek, 'holek', Description);
		}

		// returns a holemid
		public function Holemid(Description:String='outside top left'):BitmapData
		{
			return getGround(_holemid, 'holemid', Description);
		}

		// returns outside house parts
		public function House(type:uint=0):BitmapData
		{
			return getBitmapData(_house, house[type]);
		}

		// returns inside house
		public function Inside(type:uint=0):BitmapData
		{
			return getBitmapData(_inside, inside[type]);
		}

		// returns lava
		public function Lava(Description:String='outside top left'):BitmapData
		{
			return getGround(_lava, 'lava', Description);
		}

		// returns lavarock
		public function Lavarock(Description:String='outside top left'):BitmapData
		{
			return getGround(_lavarock, 'lavarock', Description);
		}

		// returns rocks
		public function Rock(type:uint=0):BitmapData
		{
			return getBitmapData(_rock, rock[type]);
		}

		// returns a sign
		public function Sign(type:uint=0):BitmapData
		{
			return getBitmapData(_signs, signs[type]);
		}

		// returns a stairs
		public function Stairs(type:uint=0):BitmapData
		{
			return getBitmapData(_stairs, stairs[type]);
		}

		// returns a tree
		public function TreeImg(type:uint=0):BitmapData
		{
			var canvas:BitmapData = makeCanvas(96,128);
			canvas.copyPixels(_trunk, trunk[type], new Point((canvas.width-trunk[type].width)/2, canvas.height-trunk[type].height), null, null, true);
			canvas.copyPixels(_treetop, treetop[type], new Point((canvas.width-treetop[type].width)/2, 0), null, null, true);
			return canvas;
		}

		// returns a water
		public function Water(Description:String='outside top left'):BitmapData
		{
			return getGround(_water, 'water', Description);
		}

		// returns waterfall
		public function Waterfall(type:uint=0):BitmapData
		{
			return getBitmapData(_waterfall, waterfall);
		}

		// returns a watergrass
		public function Watergrass(Description:String='outside top left'):BitmapData
		{
			return getGround(_watergrass, 'watergrass', Description);
		}

		// returns a frame corner
		public function Frame_Corner():BitmapData
		{
			return getBitmapData(_frame_corner, frame_corner);
		}

		/*
		Helper functions, public only
		*/

		// create empty 1x1 canvas for transparent objects
		public function EmptyCanvas():BitmapData
		{
			return makeCanvas(1,1);
		}

		// create transparent BitmapData for drawing objects
		public function makeCanvas(Width:uint, Height:uint, TransparentColor:uint=0x00FFFFFF):BitmapData
		{
			return new BitmapData(Width, Height, true, TransparentColor);
		}

		/*
		Helper functions, private or protected only
		*/

		// simplify retrieving simple bitmapdata calls
		private function getBitmapData(bmd:BitmapData, rect:Rectangle):BitmapData
		{
			var canvas:BitmapData = makeCanvas(rect.width,rect.height);
			canvas.copyPixels(bmd, rect, pt, null, null, true);
			return canvas;
		}

		// used to read in data from a bitmap and store in appropriate variables
		private function generateBitmapData(img:Bitmap, varName:String):void
		{
			this[varName] = new BitmapData(img.width,img.height,true,white);
			this[varName].copyPixels(img.bitmapData, new Rectangle(0, 0, img.width, img.height), pt,null, null, true);
		}

		// retrieve bitmap data from something read in by parseGround()
		private function getGround(srcBmd:BitmapData, vectorName:String, tileDescription:String)
		{
			// retain the rectangle found by the switch statement
			var rect:Rectangle;

			switch (tileDescription)
			{
					// fill tiles
				case 'fill 2' :
					rect = this[vectorName][1];
					break;

				case 'fill 3' :
					rect = this[vectorName][2];
					break;

				case 'fill 4' :
					rect = this[vectorName][3];
					break;

					// single tiles
				case 'single 1' :
					rect = this[vectorName][4];
					break;

				case 'single 2' :
					rect = this[vectorName][5];
					break;

					// inside tiles
				case 'inside top left' :
					rect = this[vectorName][6];
					break;

				case 'inside top middle' :
					// same as outside bottom middle
					rect = this[vectorName][16];
					break;

				case 'inside top right' :
					rect = this[vectorName][7];
					break;

				case 'inside middle left' :
					// same as outside middle right
					rect = this[vectorName][14];
					break;

				case 'inside middle right' :
					// same as outside middle left
					rect = this[vectorName][13];
					break;

				case 'inside bottom left' :
					rect = this[vectorName][8];
					break;

				case 'inside bottom middle' :
					// same as outside top middle
					rect = this[vectorName][11];
					break;

				case 'inside bottom right' :
					rect = this[vectorName][9];
					break;

					// outside tiles
				case 'outside top left' :
					rect = this[vectorName][10];
					break;

				case 'outside top middle' :
					rect = this[vectorName][11];
					break;

				case 'outside top right' :
					rect = this[vectorName][12];
					break;

				case 'outside middle left' :
					rect = this[vectorName][13];
					break;

				case 'outside middle right' :
					rect = this[vectorName][14];
					break;

				case 'outside bottom left' :
					rect = this[vectorName][15];
					break;

				case 'outside bottom middle' :
					rect = this[vectorName][16];
					break;

				case 'outside bottom right' :
					rect = this[vectorName][17];
					break;

					// default is fill 1
				default :
				case 'fill 1' :
					rect = this[vectorName][0];
					break;
			}

			// found correct vector
			return getBitmapData(srcBmd, rect);
		}

		// standard method to import ground style bitmap data, use with getGround()
		private function parseGround(varName:String)
		{
			this[varName] = new Vector.<Rectangle > (18);
			// fill-in tiles, no edges
			this[varName][0] = new Rectangle(32*1, 32*3, 32, 32);
			this[varName][1] = new Rectangle(32*2, 32*5, 32, 32);
			this[varName][2] = new Rectangle(32*1, 32*5, 32, 32);
			this[varName][3] = new Rectangle(32*0, 32*5, 32, 32);
			// single spots
			this[varName][4] = new Rectangle(32*0, 32*0, 32, 32);
			this[varName][5] = new Rectangle(32*0, 32*1, 32, 32);
			// inside corners, tl, tr, bl, br
			this[varName][6] = new Rectangle(32*1, 32*0, 32, 32);
			this[varName][7] = new Rectangle(32*2, 32*0, 32, 32);
			this[varName][8] = new Rectangle(32*1, 32*1, 32, 32);
			this[varName][9] = new Rectangle(32*2, 32*1, 32, 32);
			// outside, top left->right
			this[varName][10] = new Rectangle(32*0, 32*2, 32, 32);
			this[varName][11] = new Rectangle(32*1, 32*2, 32, 32);
			this[varName][12] = new Rectangle(32*2, 32*2, 32, 32);
			// outside, middle left->right
			this[varName][13] = new Rectangle(32*0, 32*3, 32, 32);
			this[varName][14] = new Rectangle(32*2, 32*3, 32, 32);
			// outside, bottom left->right
			this[varName][15] = new Rectangle(32*0, 32*4, 32, 32);
			this[varName][16] = new Rectangle(32*1, 32*4, 32, 32);
			this[varName][17] = new Rectangle(32*2, 32*4, 32, 32);
		}
	}
}