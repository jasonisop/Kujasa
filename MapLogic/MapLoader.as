package MapLogic
{
	// flash display
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.BitmapData;

	// geometry logic
	import flash.geom.Point;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	// invoke garbage collector, memory management
	import flash.system.System;

	// timer based utilities
	import flash.utils.Timer;
	import Utils.RepeatFunction;
	import Utils.AsyncFunction;

	// dialog screen
	import Utils.Dialog;
	import Utils.DialogMenu;
	import Utils.DialogSplit;

	// shape logic
	import ObjectLogic.EuclideanVector;
	import ObjectLogic.CircleObject;
	import ObjectLogic.RectangleObject;
	import ObjectLogic.EuclidObject;
	import ObjectLogic.TriggerObject;
	import ObjectLogic.BoundryObject;

	// character logic
	import CharacterLogic.Hero;
	import CharacterLogic.NPC;

	// maps
	import MapLogic.Map_Reykjavik;
	import MapLogic.Map_Reykjavik_House;
	import MapLogic.Map_Reykjavik_Basement;

	// graphics stuff
	import Gfx.Background;
	import Gfx.GfxFuncs;

	// special effects that impact the whole screen
	import Effects.ShakeScreen;

	public class MapLoader
	{
		// the map loaded right now
		public var currentMap:Object;

		// end of map creation function variables
		public var mapDoneFunc:Function = null;
		public var mapDoneTrigger:Boolean = false;

		// where to place hero
		public var heroLocation:Point;

		// timers
		public var timers:Vector.<Timer > ;

		// level object
		public var lvl:Level;

		// graphics
		public var bckgnd:Background;

		// screen effects variables
		private var effect:Object;

		public function MapLoader(level:Level)
		{
			// timers for running functions outside frame updater
			timers = new Vector.<Timer>();

			// level object
			lvl = level;

			// graphics
			bckgnd = level.bckgnd;
		}

		// change to new map
		public function changeMap(mapName:String):void
		{
			// stop updating level
			lvl.stopUpdate = true;

			// busy wait until frame updater is done
			if (! lvl.updateClear)
			{
				// make async function call to change map
				asyncEvent(changeMap, 50, mapName);

				// return so it can run again later
				return;
			}

			// reset map making variables
			mapDoneTrigger = false;
			mapDoneFunc = null;

			// reset object arrays
			resetObjects();

			// reset background graphics
			resetLevel();

			// reset hero movement stuff
			resetHero();

			// should be mostly empty, force garbage collection to free memory
			System.gc();

			// transition to new map
			makeMap(mapName);
		}

		// make the level vector
		public function makeMap(mapName:String='Map_Reykjavik'):void
		{
			// draw the level graphic
			drawMap(mapName);

			// make the hero
			lvl.hero = new Hero(lvl);

			// add objects to level child list
			addObjectsToLevel();

			// cache level as bitmap?
			lvl.cacheAsBitmap = true;

			// build list of display children
			lvl.buildChildList();

			// check if we're using null as hero location
			if (heroLocation == null)
			{
				// set default
				heroLocation = new Point(lvl.width / 2,lvl.height / 2);
			}

			// set hero location
			lvl.hero.x = heroLocation.x;
			lvl.hero.y = heroLocation.y;

			// move level and background to match hero location
			lvl.moveStageX -=  heroLocation.x - lvl.stageW / 2;
			lvl.moveStageY -=  heroLocation.y - lvl.stageH / 2;

			// set updater running like normal
			lvl.updateClear = false;
			lvl.stopUpdate = false;

			// update level location so everything syncs
			lvl.updateLevel();

			// check if map has an end of map creation function to run
			if (mapDoneTrigger)
			{
				// run level update once at least before running map done function
				lvl.update();

				// run it!
				mapDoneFunc();
			}

			// troubleshooting function
			//lvl.listChildren();
		}

		// draw the level stuff
		public function drawMap(mapName:String):void
		{
			switch (mapName)
			{
				case 'Map_Reykjavik' :
					currentMap = new Map_Reykjavik(this);
					break;

				case 'Map_Reykjavik_House' :
					currentMap = new Map_Reykjavik_House(this);
					break;

				case 'Map_Reykjavik_Basement' :
					currentMap = new Map_Reykjavik_Basement(this);
					break;
			}

			// make level the same size as levelGfx
			paintBackground(bckgnd.makeCanvas(lvl.levelGfx.width, lvl.levelGfx.height), new Rectangle(0, 0, lvl.levelGfx.width, lvl.levelGfx.height), lvl);
		}

		// add bitmap data to an object with a graphics property
		public function paintBackground(bmd:BitmapData, area:Rectangle, obj:Object=null, XOffset:int=0, YOffset:int=0):void
		{
			// default to level graphics
			if (obj == null)
			{
				obj = lvl.levelGfx;
			}

			// adjust image so it doesn't display screwed up
			var matrix = new Matrix();
			matrix.tx = area.x + XOffset;
			matrix.ty = area.y + YOffset;

			// draw bitmap data on the object
			obj.graphics.beginBitmapFill(bmd, matrix);
			obj.graphics.drawRect(area.x, area.y, area.width, area.height);
			obj.graphics.endFill();
		}

		// execute a function outside the frame handler using a timer
		public function asyncEvent(PassedFunction:Function, Delay:uint=50, ... rest):void
		{
			// add the timer
			timers.push(new AsyncFunction(this, PassedFunction, Delay, rest));
		}

		// execute a function on an interval outside the frame handler
		public function RepeatEvent(PassedFunction:Function, Interval:Number=50, RepeatCount:uint=0, ... rest):void
		{
			// add the timer
			timers.push(new RepeatFunction(this, PassedFunction, Interval, RepeatCount, rest));
		}

		// populate objects on the screen;
		public function addObjectsToLevel():void
		{
			// counting variable
			var i:uint;

			// add hero to the level display list
			lvl.addChild(lvl.hero);

			// add Circle Objs to level
			for (i=0; i!= lvl.CircleObjs.length; i++)
			{
				lvl.addChild(lvl.CircleObjs[i]);
			}

			// add Rectangle Objs to level
			for (i=0; i!= lvl.RectangleObjs.length; i++)
			{
				lvl.addChild(lvl.RectangleObjs[i]);
			}

			// add Euclid objs to level
			for (i=0; i!= lvl.EuclidObjs.length; i++)
			{
				lvl.addChild(lvl.EuclidObjs[i]);
			}

			// add NPC objs to level
			for (i=0; i!= lvl.NPCsList.length; i++)
			{
				lvl.addChild(lvl.NPCsList[i]);
			}
		}

		// draw a sprite and add it to the list of level display objects
		public function drawCircle(bmd:BitmapData, point:Point, Name:String='circle', radius:int=15):int
		{
			// create offset so object appears correctly
			var matrix = new Matrix();
			matrix.tx =  -  bmd.width / 2;
			matrix.ty =  -  bmd.height;

			// paint the object
			var obj = new CircleObject(radius);
			obj.graphics.beginBitmapFill(bmd,matrix);
			obj.graphics.drawRect(matrix.tx, matrix.ty, bmd.width, bmd.height);
			obj.graphics.endFill();

			// position the object at the given point;
			obj.x = point.x;
			obj.y = point.y;

			// name the object
			obj.name = Name.toString();

			// add the object to the list of display objects
			lvl.CircleObjs.push(obj);

			// return index of object added;
			return lvl.CircleObjs.indexOf(obj);
		}

		// draw a sprite and add it to the list of level display objects;
		public function drawRectangle(bmd:BitmapData, point:Point, Name:String='rectangle', rect:Rectangle=null):int
		{
			// create offset so object appears correctly
			var matrix = new Matrix();
			matrix.tx =  -  bmd.width / 2;
			matrix.ty =  -  bmd.height;

			// check if special rectangle passed, otherwise make it match image passed
			if (rect == null)
			{
				rect = new Rectangle(matrix.tx,matrix.ty,bmd.width,bmd.height);
			}

			// paint the object
			var obj = new RectangleObject(rect);
			obj.graphics.beginBitmapFill(bmd,matrix);
			obj.graphics.drawRect(matrix.tx, matrix.ty, bmd.width, bmd.height);
			obj.graphics.endFill();

			// position the object at the given point;
			obj.x = point.x;
			obj.y = point.y;

			// name the object
			obj.name = Name.toString();

			// add the object to the list of display objects
			lvl.RectangleObjs.push(obj);

			// return index of object added;
			return lvl.RectangleObjs.indexOf(obj);
		}

		// draw a sprite and add it to the list of level display objects;
		public function drawEuclid(bmd:BitmapData, point:Point, vectors:Vector.<EuclideanVector>, Name:String='euclidean object'):int
		{
			// create offset so object appears correctly
			var matrix = new Matrix();
			matrix.tx =  -  bmd.width / 2;
			matrix.ty =  -  bmd.height;

			// paint the object
			var obj = new EuclidObject(new Vector.<EuclideanVector>());
			obj.graphics.beginBitmapFill(bmd,matrix);
			obj.graphics.drawRect(matrix.tx, matrix.ty, bmd.width, bmd.height);
			obj.graphics.endFill();

			// position the object at the given point;
			obj.x = point.x;
			obj.y = point.y;

			// name the object
			obj.name = Name.toString();

			// add the object to the list of display objects
			lvl.EuclidObjs.push(obj);

			// return index of object added;
			return lvl.EuclidObjs.indexOf(obj);
		}

		// draw a sprite and add it to the list of level display objects
		public function addTrigger(rectangle:Rectangle, Name:String='trigger', IsSquare:Boolean=true):int
		{
			// paint the object
			var obj = new TriggerObject(this,rectangle,Name,IsSquare);

			// add the object to the list of display objects
			lvl.TriggerObjs.push(obj);

			// return index of object added;
			return lvl.TriggerObjs.indexOf(obj);
		}

		// add non-display object that stops movement through an area
		public function addBoundry(rectangle:Rectangle, Name:String='boundry', IsSquare:Boolean=true):int
		{
			// paint the object
			var obj = new BoundryObject(rectangle,Name,IsSquare);

			// add the object to the list of display objects
			lvl.BoundryObjs.push(obj);

			// return index of object added;
			return lvl.BoundryObjs.indexOf(obj);
		}

		// draw an NPC and add it to the list of level display objects
		public function addNPC(point:Point, SpriteImage:String='princess', Name:String='NPC'):int
		{
			// paint the object
			var obj = new NPC(lvl,SpriteImage,Name);

			// position the object at the given point;
			obj.x = point.x;
			obj.y = point.y;

			// add the object to the list of display objects
			lvl.NPCsList.push(obj);

			// return index of object added;
			return lvl.NPCsList.indexOf(obj);
		}

		// create a menu dialog screen
		public function makeDialogMenu(Text:String):DialogMenu
		{
			return new DialogMenu(this, Text);
		}

		// add dialog to the play list;
		public function addDialog(Text:String, Image:BitmapData=null, ImageRight:Boolean=false, Width:uint=0, Offset:Point=null):void
		{
			var obj:Dialog = new Dialog(this, Text,Image,ImageRight,Width,Offset);
			addDialogObj(obj);
		}

		public function addItemDialog(ItemName:String, GainItem:Boolean=true)
		{
			var obj:DialogSplit;
			if (GainItem)
			{
				obj = new DialogSplit(this, 'You received an item:',ItemName,0x00FF00);
			}
			else
			{
				obj = new DialogSplit(this, 'You lost an item:',ItemName,0xFF0000);
			}
			this.addDialogObj(obj);
		}

		public function addDialogObj(DialogObj:Sprite)
		{
			lvl.dialogList.push(DialogObj);
		}

		// play the loaded dialog list;
		public function playDialog():void
		{
			// check if we have dialog to play
			if (lvl.dialogList.length)
			{
				// reset all the keyboard and mouse indicators
				lvl.resetKeyboardAndMouse();

				// grab next available dialog and add it to the screen
				lvl.addStageChild(lvl.dialogList[0]);

				// check for remaining dialog;
				if (lvl.dialogList.length)
				{
					// continue to ask for player interaction
					lvl.interactObj.pressAnyKey = true;
				}
			}
			else
			{
				// reset dialog variables
				lvl.interactObj.pressAnyKey = false;
				lvl.interactObj.afterDialog = false;
			}
		}

		public function unloadDialog()
		{
			// player pressed a key, remove dialog and keep going
			lvl.interactObj.afterDialog = false;

			// remove the dialog
			lvl.removeStageChild(lvl.dialogList[0]);

			// prepare dialog object for garbage collection
			lvl.dialogList[0]['Trash']();

			// remove displayed dialog from list;
			lvl.dialogList.shift();
		}

		// play some kind of screen effect;
		public function playEffect(effectName:String, duration:uint):void
		{
			lvl.interactObj.wait = true;

			switch (effectName)
			{
				default :
				case 'ShakeScreen' :
					effect = new ShakeScreen(lvl,duration);
					asyncEvent(checkEffect, duration+50);
					break;
			}
		}

		// check if screen effect has completed
		public function checkEffect():void
		{
			// is effect done
			if (! effect.completed)
			{
				// not done yet, cycle again
				asyncEvent(checkEffect);
				return;
			}

			// remove reference to the effect
			effect = null;

			// indicate we're done waiting
			lvl.interactObj.wait = false;
		}

		// remove a trigger from our trigger list
		public function removeTrigger(trig:TriggerObject):void
		{
			lvl.TriggerObjs.splice(lvl.TriggerObjs.indexOf(trig), 1);
		}

		// remove a trigger from our trigger list;
		public function removeBoundry(bound:BoundryObject):void
		{
			lvl.BoundryObjs.splice(lvl.BoundryObjs.indexOf(bound), 1);
		}

		// stop hero movement and reset sprite graphic;
		public function resetHero():void
		{
			lvl.hero.gotoPoint = false;
			lvl.hero.removeStageGfx();
		}

		// clear map related objects from memory
		public function resetObjects():void
		{
			// empty Circle Objects vector
			while (lvl.CircleObjs.length)
			{
				lvl.CircleObjs[0].Trash();
				lvl.CircleObjs.shift();
			}

			// empty Rectangle Objects vector
			while (lvl.RectangleObjs.length)
			{
				lvl.RectangleObjs[0].Trash();
				lvl.RectangleObjs.shift();
			}

			// empty Euclid Objects vector;
			while (lvl.EuclidObjs.length)
			{
				lvl.EuclidObjs[0].Trash();
				lvl.EuclidObjs.shift();
			}

			// empty Trigger Objects vector
			while (lvl.TriggerObjs.length)
			{
				lvl.TriggerObjs[0].Trash();
				lvl.TriggerObjs.shift();
			}

			// empty Boundry Objects vector;
			while (lvl.BoundryObjs.length)
			{
				lvl.BoundryObjs[0].Trash();
				lvl.BoundryObjs.shift();
			}

			// empty dialog list vector;
			while (lvl.dialogList.length)
			{
				lvl.dialogList[0]['Trash']();
				lvl.dialogList.shift();
			}

			// empty NPC list
			while (lvl.NPCsList.length)
			{
				lvl.NPCsList[0]['Trash']();
				lvl.NPCsList.shift();
			}

			// dump display sorting array
			lvl.childList.splice(0, uint.MAX_VALUE);

			// dump lvl display list so we start fresh;
			while (lvl.numChildren != 0)
			{
				lvl.removeChild(lvl.getChildAt(0));
			}
		}

		// set level stuff back to origin
		public function resetLevel():void
		{
			lvl.graphics.clear();
			lvl.x = 0;
			lvl.y = 0;
			lvl.levelGfx.graphics.clear();
			lvl.levelGfx.x = 0;
			lvl.levelGfx.y = 0;
		}
	}
}