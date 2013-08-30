package MapLogic
{
	// flash display
	import flash.display.BitmapData;

	// geometry
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	// graphics
	import Gfx.Background;
	import Gfx.GfxFuncs;

	public class Map_Reykjavik_House
	{
		// size variables
		private var wide:int;
		private var high:int;

		// identify what map this is
		public var name:String;

		// object references
		private var lvl:Level;
		private var ml:MapLoader;
		private var lvlData:Object;

		// graphics
		private var bckgnd:Background;
		
		// constructor
		public function Map_Reykjavik_House(mapLoad:MapLoader)
		{
			// map name
			this.name = 'Map_Reykjavik_House';

			// save object references
			ml = mapLoad;
			lvl = mapLoad.lvl;

			// graphics variables
			bckgnd = lvl.bckgnd;
			lvlData = lvl.lvlData;
			
			// determine how big an area to draw
			wide = 768;
			high = 640;
			var h:int;
			var i:int;
			var bmd:BitmapData;
			var bmd2:BitmapData;
			var bmd3:BitmapData;

			i = ml.drawRectangle(bckgnd.EmptyCanvas(), new Point(), 'back wall', new Rectangle(-96, 0, wide+96, 96));

			// wall bitmap data
			bmd = bckgnd.Inside(1);
			bmd2 = bckgnd.Inside(2);
			bmd3 = bckgnd.Inside(3);

			// draw back wall
			for (h=0; h<24; h+=3)
			{
				// draw wall in background, left pannel
				ml.paintBackground(bmd, new Rectangle(32*h, 0, 32, bmd.height), lvl.RectangleObjs[i]);
				// draw wall in background, middle pannel
				ml.paintBackground(bmd2, new Rectangle(32*(h+1), 0, 32, bmd2.height), lvl.RectangleObjs[i]);
				// draw wall in background, right pannel
				ml.paintBackground(bmd3, new Rectangle(32*(h+2), 0, 32, bmd3.height), lvl.RectangleObjs[i]);
			}

			// draw floor
			ml.paintBackground(bckgnd.Inside(), new Rectangle(0, bmd.height, wide, high-bmd.height));

			// done drawing wall, cache it as a bitmap so it doesn't redraw
			lvl.RectangleObjs[i].cacheAsBitmap = true;

			// bounding walls
			ml.addBoundry(new Rectangle(-32, -32, 32, high+32),'boundry wall');
			ml.addBoundry(new Rectangle(wide,-32, 32, high+32), 'boundry wall');
			ml.addBoundry(new Rectangle(0, high, wide+64, 32), 'boundry wall');

			// trigger object to return outside
			i = ml.addTrigger(new Rectangle(64,high - 16,128,16));
			// assign trigger action
			lvl.TriggerObjs[i].TriggerAction = goOutside;
			// double outside stairs size so it looks right
			bmd = GfxFuncs.scaleBitmapData(bckgnd.House(11),2);
			// draw something on that area so it looks like a place to go for player
			ml.paintBackground(bmd, new Rectangle(64, high, 128, 64));

			// barrels next to the stairs
			bmd = bckgnd.Barrel();
			bmd = GfxFuncs.tileBitmapData(bmd,4,1);
			i = ml.drawRectangle(bmd, new Point(wide-bmd.width/2, high-bmd.height-16));
			var rect:Rectangle = lvl.RectangleObjs[i].getRectangle();
			rect.height = rect.height / 2;
			rect.y +=  rect.height;
			rect.x -=  8;
			rect.width +=  16;
			lvl.RectangleObjs[i].setRectangle(rect);

			/*
			Stairs going down to the basement/tunnel
			*/
			bmd = bckgnd.Stairs(5);
			bmd = GfxFuncs.scaleBitmapData(bmd,1.5);
			ml.paintBackground(bmd, new Rectangle(wide-bmd.width, high-bmd.height, bmd.width, bmd.height));

			// add trigger area to change map
			i = ml.addTrigger(new Rectangle(wide-bmd.width, high-bmd.height, 32, bmd.height));
			// assign trigger action
			lvl.TriggerObjs[i].TriggerAction = goDownstairs;

			// check if princess was talked to
			if(!lvlData.Map_Reykjavik.grass_triggered)
			{
			}

			// done drawing, cache everything so it doesn't recalculate
			lvl.cacheGfx();
		}

		public function goOutside()
		{
			// stop updating level
			lvl.stopUpdate = true;

			// hero location
			ml.heroLocation = new Point(320,672);

			// load new map using external loader
			ml.asyncEvent(ml.changeMap, 50, 'Map_Reykjavik');
		}
		
		public function goDownstairs()
		{
			//trace('here');
			
			// stop updating level
			lvl.stopUpdate = true;

			// hero location
			ml.heroLocation = new Point(80,16);

			// load new map using external loader
			ml.asyncEvent(ml.changeMap, 50, 'Map_Reykjavik_Basement');
		}
	}
}