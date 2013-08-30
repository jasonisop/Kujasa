package MapLogic
{
	// flash display
	import flash.display.BitmapData;
	import flash.display.Sprite;

	// geometry
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	// graphics
	import Gfx.Background;
	import Gfx.GfxFuncs;

	// dialog menu screens
	import Utils.DialogMenu;

	public class Map_Reykjavik
	{
		// size variables
		private var wide:int;
		private var high:int;
		private var base:int;

		// identify what map this is
		public var name:String;

		// object references
		private var lvl:Level;
		private var ml:MapLoader;
		private var lvlData:Object;

		// graphics
		private var bckgnd:Background;

		// dialog icons
		private var hero_icon:BitmapData;
		private var lady_icon:BitmapData;

		// blocks front door
		private var doorBlock:Object;

		// constructor
		public function Map_Reykjavik(mapLoad:MapLoader)
		{
			// map name
			this.name = "Map_Reykjavik";

			// save object references
			ml = mapLoad;
			lvl = ml.lvl;
			lvlData = lvl.lvlData;

			// graphics variables
			bckgnd = lvl.bckgnd;

			// determine how big an area to draw
			wide = 768;
			high = 640;
			base = 192;
			var i:int;
			var bmd:BitmapData;
			var obj:Object;

			// end of map creation function to run
			ml.mapDoneTrigger = true;
			ml.mapDoneFunc = mapDone;

			// define hero and lady icon data for fun
			hero_icon = lvl.chars.getCharPos(1,0,'hero');
			hero_icon = GfxFuncs.cropBitmapData(hero_icon,new Rectangle(hero_icon.width / 4,hero_icon.height / 4,hero_icon.width / 2,hero_icon.height / 2));
			hero_icon = GfxFuncs.scaleBitmapData(hero_icon,3);

			lady_icon = lvl.chars.getCharPos(1,0,'princess');
			lady_icon = GfxFuncs.cropBitmapData(lady_icon,new Rectangle(lady_icon.width / 4,lady_icon.height / 4,lady_icon.width / 2,lady_icon.height / 2));
			lady_icon = GfxFuncs.scaleBitmapData(lady_icon,3);

			// borders for the level!
			ml.addBoundry(new Rectangle(0, 0, wide*2, base), "border");
			ml.addBoundry(new Rectangle(0, 0, base, high*2), "border");
			ml.addBoundry(new Rectangle(0, high*2-base, wide*2, high*2), "border");
			ml.addBoundry(new Rectangle(wide*2-base, 0, base, high*2), "border");

			// grass under the trees
			ml.paintBackground(bckgnd.Grass('fill'), new Rectangle(0, 0, wide*2, high*2));

			// dirt, top
			ml.paintBackground(bckgnd.Dirt('outside top left'), new Rectangle(base, base, 32, 32));
			ml.paintBackground(bckgnd.Dirt('outside top middle'), new Rectangle(base+32, base, wide*2-384-64, 32));
			ml.paintBackground(bckgnd.Dirt('outside top right'), new Rectangle(wide*2-224, base, 32, 32));

			// dirt, middle
			ml.paintBackground(bckgnd.Dirt('outside middle left'), new Rectangle(base, 224, 32, high*2-448));
			ml.paintBackground(bckgnd.Dirt('fill'), new Rectangle(224, 224, wide*2-448, high*2-448));
			ml.paintBackground(bckgnd.Dirt('outside middle right'), new Rectangle(wide*2-224, 224, 32, high*2-448));

			// dirt, bottom;
			ml.paintBackground(bckgnd.Dirt('outside bottom left'), new Rectangle(base, high*2-224, 32, 32));
			ml.paintBackground(bckgnd.Dirt('outside bottom middle'), new Rectangle(base+32, high*2-224, wide*2-384-64, 32));
			ml.paintBackground(bckgnd.Dirt('outside bottom right'), new Rectangle(wide*2-224, high*2-224, 32, 32));

			// draw background with trees on edge;
			bmd = bckgnd.TreeImg(0);

			// trees;
			ml.paintBackground(bmd, new Rectangle(0, 0, wide*2, bmd.height), null, bmd.width/2, -64);
			ml.paintBackground(bmd, new Rectangle(0, 0, wide*2, bmd.height));
			ml.paintBackground(bmd, new Rectangle(0, bmd.height/2, wide*2, bmd.height),null,bmd.width/2);

			// line sides of screen with trees
			for (i=1; i!=9; i++)
			{
				// left side
				ml.paintBackground(bmd, new Rectangle(0, 128*i, bmd.width*2, bmd.height));
				ml.paintBackground(bmd, new Rectangle(0, 128*i+64, bmd.width*1.5, bmd.height),null,bmd.width/2);
				// right side
				ml.paintBackground(bmd, new Rectangle(wide*2-base, 128*i, bmd.width*2, bmd.height));
				ml.paintBackground(bmd, new Rectangle(wide*2-base+bmd.width/2, 128*i+64, bmd.width*1.5, bmd.height));
			}

			// bottom of screen lined with trees;
			ml.paintBackground(bmd, new Rectangle(0, high*2-base, wide*2, bmd.height),null,bmd.width/2);
			ml.paintBackground(bmd, new Rectangle(0, high*2-128, wide*2, 128));
			ml.paintBackground(bmd, new Rectangle(0, high*2-64, wide*2, 64),null,bmd.width/2);

			// add some tree objects
			bmd = bckgnd.TreeImg(1);
			ml.drawCircle(bmd, new Point(wide+96, high-64), "tree");
			ml.drawCircle(bmd, new Point(wide+128, high), "tree");
			ml.drawCircle(bmd, new Point(wide+160, high+64), "tree");
			bmd = GfxFuncs.flipBitmapData(bmd);
			ml.drawCircle(bmd, new Point(wide-96, high-64), "tree");
			ml.drawCircle(bmd, new Point(wide-128, high), "tree");
			ml.drawCircle(bmd, new Point(wide-160, high+64), "tree");

			// add some light posts
			bmd = bckgnd.CastleLightsource(2);
			ml.drawCircle(bmd, new Point(wide-48, high-32), "light post");
			ml.drawCircle(bmd, new Point(wide+48, high-32), "light post");
			ml.drawCircle(bmd, new Point(wide-64, high+32), "light post");
			ml.drawCircle(bmd, new Point(wide+64, high+32), "light post");

			// add a pixel cup from OpenGameArt.org just for fun
			bmd = bckgnd.Cup();
			// change scale X and scale Y of statue
			bmd = GfxFuncs.scaleBitmapData(bmd,2);
			i = ml.drawRectangle(bmd,new Point(wide,high - 224),"statue",new Rectangle(-32,-32,64,32));

			/*
			 * water around dirt patch
			 */
			// top section, first line
			ml.paintBackground(bckgnd.Water('outside top left'), new Rectangle(wide+base, high+128, 32, 32));
			ml.paintBackground(bckgnd.Water('outside top middle'), new Rectangle(wide+base+32, high+128, 96, 32));
			ml.paintBackground(bckgnd.Water('outside top right'), new Rectangle(wide+base+128, high+128, 32, 32));
			// top section, second line;
			ml.paintBackground(bckgnd.Water('outside bottom left'), new Rectangle(wide+base, high+160, 32, 32));
			ml.paintBackground(bckgnd.Water('outside bottom middle'), new Rectangle(wide+base+32, high+160, 64, 32));
			// middle section, left side;
			ml.paintBackground(bckgnd.Water('inside top right'), new Rectangle(wide+base+96, high+160, 32, 32));
			ml.paintBackground(bckgnd.Water('outside middle left'), new Rectangle(wide+base+96, high+192, 32, 96));
			// middle section, right side;
			ml.paintBackground(bckgnd.Water('outside middle right'), new Rectangle(wide+base+128, high+160, 32, 160));
			// bottom section, first line;
			ml.paintBackground(bckgnd.Water('outside top left'), new Rectangle(wide+base, high+base+96, 32, 32));
			ml.paintBackground(bckgnd.Water('outside top middle'), new Rectangle(wide+base+32, high+base+96, 64, 32));
			ml.paintBackground(bckgnd.Water('inside bottom right'), new Rectangle(wide+base+96, high+base+96, 32, 32));
			// bottom section, second line;
			ml.paintBackground(bckgnd.Water('outside bottom left'), new Rectangle(wide+base, high+base+128, 32, 32));
			ml.paintBackground(bckgnd.Water('outside bottom middle'), new Rectangle(wide+base+32, high+base+128, 96, 32));
			ml.paintBackground(bckgnd.Water('outside bottom right'), new Rectangle(wide+base+128, high+base+128, 32, 32));

			// boundry objects associated with the water;
			ml.addBoundry(new Rectangle(wide+base+16, high+128+16, 128, 48), "water boundry");
			ml.addBoundry(new Rectangle(wide+base+16, high+base+96+16, 128, 48), "water boundry");
			ml.addBoundry(new Rectangle(wide+base+96+16, high+160+16, 32, 160), "water boundry");

			/*
			 * dirt patch and trigger object
			 */
			// dirt, top
			ml.paintBackground(bckgnd.Dirt2('outside top left'), new Rectangle(wide+base, high+base, 32, 32));
			ml.paintBackground(bckgnd.Dirt2('outside top middle'), new Rectangle(wide+base+32, high+base, 32, 32));
			ml.paintBackground(bckgnd.Dirt2('outside top right'), new Rectangle(wide+base+64, high+base, 32, 32));

			// dirt, middle
			ml.paintBackground(bckgnd.Dirt2('outside middle left'), new Rectangle(wide+base, high+base+32, 32, 32));
			ml.paintBackground(bckgnd.Dirt2('fill'), new Rectangle(wide+base+32, high+base+32, 32, 32));
			ml.paintBackground(bckgnd.Dirt2('outside middle right'), new Rectangle(wide+base+64, high+base+32, 32, 32));

			// dirt, bottom;
			ml.paintBackground(bckgnd.Dirt2('outside bottom left'), new Rectangle(wide+base, high+base+64, 32, 32));
			ml.paintBackground(bckgnd.Dirt2('outside bottom middle'), new Rectangle(wide+base+32, high+base+64, 32, 32));
			ml.paintBackground(bckgnd.Dirt2('outside bottom right'), new Rectangle(wide+base+64, high+base+64, 32, 32));

			// trigger object;
			i = ml.addTrigger(new Rectangle(wide+base,high + base,128,128));

			// assign locally defined function to trigger
			lvl.TriggerObjs[i].TriggerAction = triggerFunc;

			// check if we should draw grass
			if (lvlData[name].grass_triggered)
			{
				drawGrass();
			}

			// add some barrels by the house
			ml.drawCircle(bckgnd.Barrel(0), new Point(wide-528, high+32), "barrel");

			// barrel with key to the front door
			i = ml.drawRectangle(bckgnd.Barrel(1), new Point(wide-544, high), "barrel");
			obj = lvl.RectangleObjs[i];
			obj.PokeAction = getKey;
			obj.pokeRespond = true;

			ml.drawCircle(bckgnd.Bucket(0), new Point(wide-352, high+16), "bucket");
			ml.drawCircle(bckgnd.Bucket(1), new Point(wide-384, high+32), "bucket");

			/*
			 * house and trigger object to go inside
			 */
			i = ml.drawRectangle(bckgnd.EmptyCanvas(), new Point(wide-512, high), "house", new Rectangle(-8, -128, 208, 128));
			obj = lvl.RectangleObjs[i];

			// brick front of house, top
			ml.paintBackground(bckgnd.House(0), new Rectangle(0, -128, 32, 32), obj);
			ml.paintBackground(bckgnd.House(1), new Rectangle(32, -128, 128, 32), obj);
			ml.paintBackground(bckgnd.House(2), new Rectangle(160, -128, 32, 32), obj);
			// brick front of house, middle
			ml.paintBackground(bckgnd.House(3), new Rectangle(0, -96, 32, 64), obj);
			ml.paintBackground(bckgnd.House(4), new Rectangle(32, -96, 128, 64), obj);
			ml.paintBackground(bckgnd.House(5), new Rectangle(160, -96, 32, 64), obj);
			// brick front of house, bottom
			ml.paintBackground(bckgnd.House(6), new Rectangle(0, -32, 32, 32), obj);
			ml.paintBackground(bckgnd.House(7), new Rectangle(32, -32, 128, 32), obj);
			ml.paintBackground(bckgnd.House(8), new Rectangle(160, -32, 32, 32), obj);
			// double doors
			ml.paintBackground(bckgnd.House(9), new Rectangle(32, -64, 32, 48), obj);
			bmd = GfxFuncs.flipBitmapData(bckgnd.House(10));
			ml.paintBackground(bmd, new Rectangle(64, -64, 32, 48), obj);
			// thing above doors
			ml.paintBackground(bckgnd.House(15), new Rectangle(32, -80, 64, 16), obj);
			// steps below double doors
			ml.paintBackground(bckgnd.House(11), new Rectangle(32, -16, 64, 32), obj);
			// window
			ml.paintBackground(bckgnd.House(13), new Rectangle(128, -64, 32, 44), obj);
			// roof bits
			ml.paintBackground(bckgnd.House(18), new Rectangle(0, -160, 32, 32), obj);
			ml.paintBackground(bckgnd.House(19), new Rectangle(32, -160, 128, 32), obj);
			ml.paintBackground(bckgnd.House(20), new Rectangle(160, -160, 32, 32), obj);
			ml.paintBackground(bckgnd.House(26), new Rectangle(0, -base, 32, 32), obj);
			ml.paintBackground(bckgnd.House(28), new Rectangle(160, -base, 32, 32), obj);
			ml.paintBackground(bckgnd.House(23), new Rectangle(0, -224, 32, 32), obj);
			ml.paintBackground(bckgnd.House(25), new Rectangle(160, -224, 32, 32), obj);
			// middle of the roof, bottom half
			ml.paintBackground(bckgnd.House(35), new Rectangle(32, -base, 32, 32), obj);
			ml.paintBackground(bckgnd.House(36), new Rectangle(64, -base, 96, 32), obj);
			ml.paintBackground(bckgnd.House(37), new Rectangle(128, -base, 32, 32), obj);
			// middle of the roof, top half
			ml.paintBackground(bckgnd.House(32), new Rectangle(32, -224, 32, 32), obj);
			ml.paintBackground(bckgnd.House(33), new Rectangle(64, -224, 96, 32), obj);
			ml.paintBackground(bckgnd.House(34), new Rectangle(128, -224, 32, 32), obj);

			// cache house as bitmap
			obj.cacheAsBitmap = true;

			// add boundry to front door
			i = ml.addBoundry(new Rectangle(wide-480, high, 64, 16), 'front door');
			doorBlock = lvl.BoundryObjs[i];
			doorBlock.bumpAction = frontDoor;
			doorBlock.bumpRespond = true;

			// add NPC (princess)
			i = ml.addNPC(new Point(wide-128, high+128));

			// add some hit response action
			lvl.NPCsList[i].bumpAction = Princess_Hit;
			lvl.NPCsList[i].bumpRespond = true;

			lvl.NPCsList[i].PokeAction = Princess_Poke;
			lvl.NPCsList[i].pokeRespond = true;

			// done drawing, cache everything so they doesn't recalculate
			lvl.cacheGfx();
		}

		public function mapDone():void
		{
			if(lvlData[name].stop_whine)
			return;
			
			var obj:DialogMenu = ml.makeDialogMenu('What would you like to do today? Please choose from one of the following options. Thank you for your cooperation.');
			obj.addChoice('Turn off Princess whining when you run into her',NoWhine);
			obj.addChoice('Win at life',WinLife);
			obj.addChoice('Do nothing',Nothing);
			ml.addDialogObj(obj);
			ml.playDialog();
		}

		// stub, not supposed to do anything
		public function Nothing():void
		{
		}

		public function NoWhine():void
		{
			lvl.NPCsList[0].bumpRespond = false;
			lvlData[name].stop_whine = true;
		}

		public function WinLife():void
		{
			ml.addDialog("You are a sad, sad individual if you think this game will help you win at life. Good luck.");
		}

		public function Princess_Hit():void
		{
			if(lvlData[name].stop_whine)
			return;
			
			ml.addDialog("Watch where you're going pal!", lady_icon);
			ml.addDialog("If I didn't know better I'd say you were aiming for me.", lady_icon);
			ml.addDialog("Pardon me miss, but you're in the way.", hero_icon, true);
			ml.addDialog("Well I never!", lady_icon);
			ml.playDialog();

			lvl.NPCsList[0].faceObj(lvl.hero);
		}

		public function Princess_Poke():void
		{
			// check if grass was triggered yet
			if (lvlData[name].grass_triggered && lvlData[name].princess_chat)
			{
				ml.addDialog("Check the house, I'm sure something shifted inside.", lady_icon);

				// check if hero has the door key
				if (lvl.hero.InventoryFindByName('Reykjavik Front Door Key') == null)
				{
					ml.addDialog("I put the key under the barrels next to the house.", lady_icon);
				}
				else
				{
					ml.addDialog("You've got the key, what are you waiting for?", lady_icon);
				}
			}
			else if (lvlData[name].grass_triggered)
			{
				ml.addDialog("Holy Monkeys! You broke the dirt patch!", lady_icon);
				ml.addDialog("That's what I do best. I break stuff.", hero_icon, true);
				ml.addDialog("How original...", lady_icon);
				ml.addDialog("...", lady_icon);
				ml.addDialog("I felt the earth move under my feat. I felt the sky tumbling down.", lady_icon);
				ml.addDialog("Phew! I'm glad that wasn't just me.", hero_icon, true);

				// grass was triggered, princess spoken to, indicate it
				lvlData[name].princess_chat = true;

				// run function again to get more dialog
				Princess_Poke();

				// stop this function run from continuing
				return;
			}
			else
			{
				ml.addDialog("My name is Princess. What is that dirt patch over there...", lady_icon);
				ml.addDialog("Looks like dirt.", hero_icon, true);
				ml.addDialog("Figure that out all by yourself?", lady_icon);
			}

			ml.playDialog();
			lvl.NPCsList[0].faceObj(lvl.hero);
		}

		public function triggerFunc():void
		{
			// check if this has already played before playing again!
			if(lvlData[name].grass_triggered)
			{
				return;
			}
			
			// stop trigger from going off
			lvl.TriggerObjs[0].Active = false;

			// stop updating level
			lvl.stopUpdate = true;

			// earthquake!
			ml.playEffect('ShakeScreen', 2000);

			// setup some dialog to play in 2.05 seconds
			ml.addDialog('A wild and grassy knoll appeared!');
			ml.asyncEvent(ml.playDialog, 2050);

			// change grass to reflect change in 2.05 seconds
			lvlData[name].grass_triggered = true;
			ml.asyncEvent(drawGrass, 2050);
		}

		private function drawGrass():void
		{
			// being updating level again
			lvl.stopUpdate = false;

			// grass, top
			ml.paintBackground(bckgnd.Grass('outside top left'), new Rectangle(wide+base, high+base, 32, 32));
			ml.paintBackground(bckgnd.Grass('outside top middle'), new Rectangle(wide+base+32, high+base, 32, 32));
			ml.paintBackground(bckgnd.Grass('outside top right'), new Rectangle(wide+base+64, high+base, 32, 32));

			// grass, middle
			ml.paintBackground(bckgnd.Grass('outside middle left'), new Rectangle(wide+base, high+base+32, 32, 32));
			ml.paintBackground(bckgnd.Grass('fill 1'), new Rectangle(wide+base+32, high+base+32, 32, 32));
			ml.paintBackground(bckgnd.Grass('outside middle right'), new Rectangle(wide+base+64, high+base+32, 32, 32));

			// grass, bottom;
			ml.paintBackground(bckgnd.Grass('outside bottom left'), new Rectangle(wide+base, high+base+64, 32, 32));
			ml.paintBackground(bckgnd.Grass('outside bottom middle'), new Rectangle(wide+base+32, high+base+64, 32, 32));
			ml.paintBackground(bckgnd.Grass('outside bottom right'), new Rectangle(wide+base+64, high+base+64, 32, 32));

			// done drawing, cache everything so they doesn't recalculate;
			lvl.cacheGfx();
		}

		public function frontDoor():void
		{
			// check if hero has the door key
			if (lvl.hero.InventoryFindByName('Reykjavik Front Door Key') != null)
			{
				// stop updating level
				lvl.stopUpdate = true;

				// hero location
				ml.heroLocation = new Point(128,high - 32);

				// load new map using external loader
				ml.asyncEvent(ml.changeMap, 50, "Map_Reykjavik_House");
				return;
			}

			ml.addDialog("The door is locked.");
			ml.playDialog();
		}

		public function getKey():void
		{
			if (lvl.hero.InventoryFindByName('Reykjavik Front Door Key') == null)
			{
				var obj:Object = new Object();
				obj['name'] = 'Reykjavik Front Door Key';
				lvl.hero.InventoryAdd(obj);

				ml.addItemDialog(obj.name);
				ml.playDialog();
			}
		}
	}
}