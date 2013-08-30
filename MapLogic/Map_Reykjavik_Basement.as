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

	public class Map_Reykjavik_Basement
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
		public function Map_Reykjavik_Basement(mapLoad:MapLoader)
		{
			// map name
			this.name = 'Map_Reykjavik_Basement';

			// save object references
			ml = mapLoad;
			lvl = mapLoad.lvl;
			lvlData = lvl.lvlData;

			// graphics variables
			bckgnd = lvl.bckgnd;

			// determine how big an area to draw
			wide = 400;
			high = 300;
			var i:int;
			var bmd:BitmapData;

			// bounding walls
			ml.addBoundry(new Rectangle(-32, -32, wide+64, 32),'boundry wall');
			ml.addBoundry(new Rectangle(-32, -32, 32, high+64), 'boundry wall');
			ml.addBoundry(new Rectangle(-32, high, wide+64, 32), 'boundry wall');
			ml.addBoundry(new Rectangle(wide, -32, 32, high+64), 'boundry wall');

			// draw cement floor
			ml.paintBackground(bckgnd.Cement('fill 1'), new Rectangle(0,0,wide,high));

			// draw some brackish water over a crack in the floor
			ml.paintBackground(bckgnd.Cement('fill 3'), new Rectangle(wide/2,high/2,32,32));
			ml.paintBackground(bckgnd.Brackish('single 2'), new Rectangle(wide/2, high/2, 32, 32));
			
			// lavarock, top row
			ml.paintBackground(bckgnd.Lavarock('outside top left'), new Rectangle(wide-128, high-128, 32, 32));
			ml.paintBackground(bckgnd.Lavarock('outside top middle'), new Rectangle(wide-96, high-128, 96, 32));

			// lavarock, top row
			ml.paintBackground(bckgnd.Lavarock('outside middle left'), new Rectangle(wide-128, high-96, 32, 96));
			ml.paintBackground(bckgnd.Lavarock('fill 1'), new Rectangle(wide-96, high-96, 96, 96));
			
			// check if princess was talked to
			if(lvlData.Map_Reykjavik.princess_chat)
			{
				drawHole();
			}

			/*
			Stairs going up to the house
			*/
			bmd = bckgnd.Cementstair(0);
			bmd = GfxFuncs.flipBitmapData(bmd);
			ml.paintBackground(bmd, new Rectangle(0, -32, bmd.width, bmd.height));

			// add trigger area to change map
			i = ml.addTrigger(new Rectangle(bmd.width - 16,0,16,bmd.height - 32));
			// assign trigger action
			lvl.TriggerObjs[i].TriggerAction = goUpstairs;

			// boundry so can't walk through the stairs
			ml.addBoundry(new Rectangle(0, 16, 48, 16),'boundry wall');
			
			// done drawing, cache everything so it doesn't recalculate
			lvl.cacheGfx();
		}

		public function goUpstairs()
		{
			// stop updating level
			lvl.stopUpdate = true;

			// hero location
			ml.heroLocation = new Point(656,624);

			// load new map using external loader
			ml.asyncEvent(ml.changeMap, 50, 'Map_Reykjavik_House');
		}
		
		public function drawHole()
		{
			// hole, top row
			ml.paintBackground(bckgnd.Holek('outside top left'), new Rectangle(wide-96, high-96, 32, 32));
			ml.paintBackground(bckgnd.Holek('outside top middle'), new Rectangle(wide-64, high-96, 32, 32));
			ml.paintBackground(bckgnd.Holek('outside top right'), new Rectangle(wide-32, high-96, 32, 32));

			// hole, middle row
			ml.paintBackground(bckgnd.Holek('outside middle left'), new Rectangle(wide-96, high-64, 32, 32));
			ml.paintBackground(bckgnd.Holek('fill 1'), new Rectangle(wide-64, high-64, 32, 32));
			ml.paintBackground(bckgnd.Holek('outside middle right'), new Rectangle(wide-32, high-64, 32, 32));

			// hole, bottom row
			ml.paintBackground(bckgnd.Holek('outside bottom left'), new Rectangle(wide-96, high-32, 32, 32));
			ml.paintBackground(bckgnd.Holek('outside bottom middle'), new Rectangle(wide-64, high-32, 32, 32));
			ml.paintBackground(bckgnd.Holek('outside bottom right'), new Rectangle(wide-32, high-32, 32, 32));
			
			// done drawing, cache everything so it doesn't recalculate
			lvl.cacheGfx();
		}
	}
}