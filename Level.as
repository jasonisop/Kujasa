package 
{
	// flash graphics
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.DisplayObject;

	// events, keyboard, and mouse stuff
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	//import flash.ui.Keyboard;

	// object movement
	import flash.geom.Point;
	import flash.geom.Rectangle;

	// sprite sheets
	import Gfx.Background;
	import Gfx.CharSheet;

	// object logic
	import ObjectLogic.CircleObject;
	import ObjectLogic.EuclidObject;
	import ObjectLogic.BoundryObject;
	import ObjectLogic.TriggerObject;
	import ObjectLogic.RectangleObject;

	// Euclidean object logic
	import ObjectLogic.EuclideanFunctions;
	import ObjectLogic.EuclideanVector;

	// create level graphics
	import MapLogic.MapLoader;

	// character logic
	import CharacterLogic.Hero;
	import CharacterLogic.NPC;
	
	// save data logic
	import SaveData.MapSaveData;
	
	//console
	import com.junkbyte.console.Cc;

	public class Level extends Sprite
	{
		// stage size and location data
		public var stageX:int;
		public var stageY:int;
		public var stageW:int;
		public var stageH:int;
		public var moveStageX:int;
		public var moveStageY:int;

		// hero movement related
		public var keys:Vector.<uint > ;
		public var moveDir:Vector.<Boolean > ;
		public var ticker:int;
		public var mouseIsDown:Boolean;

		// interaction object
		public var interactObj:Object;

		// stopUpdate state indicator
		public var stopUpdate:Boolean;
		public var updateClear:Boolean;

		// embedded graphics
		public var chars:CharSheet;
		public var bckgnd:Background;

		// background graphics
		public var levelGfx:Shape;
		public var maploader:MapLoader;

		// character logic
		public var hero:Hero;

		// sorted display list
		public var childList:Array;

		// object arrays
		public var RectangleObjs:Vector.<RectangleObject > ;
		public var CircleObjs:Vector.<CircleObject > ;
		public var EuclidObjs:Vector.<EuclidObject > ;
		public var TriggerObjs:Vector.<TriggerObject > ;
		public var BoundryObjs:Vector.<BoundryObject > ;
		public var NPCsList:Vector.<NPC > ;

		// dialog list for conversations
		public var dialogList:Vector.<Sprite > ;

		// level data so game remembers when something happens
		public var lvlData:MapSaveData;
		public var heroInv:Array;

		// constructor code
		public function Level(Keys:Vector.<uint>, MoveDir:Vector.<Boolean>,InteractObj:Object)
		{	
			//console
			Cc.startOnStage(this, "`");
			Cc.config.commandLineAllowed = true;
			Cc.width = 800;
			Cc.height = 100;
			
			// stopUpdate state
			stopUpdate = false;
			updateClear = false;

			// setup variables
			keys = Keys;
			moveStageX = moveStageY = 0;
			mouseIsDown = false;

			// prepare the movement index
			moveDir = MoveDir;

			// prepare interaction object
			interactObj = InteractObj;

			// embedded graphics
			chars = new CharSheet();
			bckgnd = new Background();

			// background graphics
			levelGfx = new Shape();

			// containers for objects
			RectangleObjs = new Vector.<RectangleObject>();
			CircleObjs = new Vector.<CircleObject>();
			EuclidObjs = new Vector.<EuclidObject>();
			TriggerObjs = new Vector.<TriggerObject>();
			BoundryObjs = new Vector.<BoundryObject>();
			NPCsList = new Vector.<NPC>();
			childList = new Array();

			// dialog list
			dialogList = new Vector.<Sprite>();

			// level and hero save data
			lvlData = new MapSaveData();
			heroInv = new Array();

			// listen for when we're added to the stage
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}

		function init(e:Event):void
		{
			// now we're added to the stage, remove the listener
			removeEventListener(Event.ADDED_TO_STAGE, init);

			// find the center of the stage
			stageW = stage.stageWidth;
			stageH = stage.stageHeight;

			// start at origin x,y
			stageX = stageW / 2;
			stageY = stageH / 2;

			// move the stage to match the positions we want to use
			moveStageX = 0;
			moveStageY = 0;

			// add level graphics under level
			stage.addChildAt(levelGfx, stage.getChildIndex(this));

			// map handling logic
			maploader = new MapLoader(this);

			// draw level graphics and add objects
			maploader.makeMap();
		}

		// update frame based events here
		public function update():void
		{
			// check if stopUpdate in progress
			if (stopUpdate)
			{
				// we're on a clean loop, indicate such
				updateClear = true;
				return;
			}

			// check for press any key request
			if (interactObj.pressAnyKey)
			{
				// don't do anything, wanting for key to be pressed
				return;
			}
			else if (interactObj.afterDialog)
			{
				// get rid of current dialog and garbage collect it
				maploader.unloadDialog();

				// is there more dialog?;
				if (dialogList.length)
				{
					// play next dialog
					maploader.playDialog();

					// return so we can see the next dialog
					return;
				}
			}

			// did the player hit space bar?
			if (interactObj.poke)
			{
				// try to poke anything near by
				testPoke();
			}

			// check if mouse button is pressed
			if (mouseIsDown)
			{
				// set a point for hero to travel to
				hero.travelPoint = this.globalToLocal(new Point(stage.mouseX,stage.mouseY));
			}

			// check if hero has moved
			if (hero.moveHero())
			{
				// update level info since hero moved
				updateLevel();
			}

			// sort display list by y value
			sortChildrenByY();
		}

		// redefine level points and move level graphic
		public function updateLevel():void
		{
			// change stage position
			stageX +=  moveStageX;
			stageY +=  moveStageY;

			// move the level graphic around
			levelGfx.x +=  moveStageX;
			levelGfx.y +=  moveStageY;

			this.x +=  moveStageX;
			this.y +=  moveStageY;

			// reset stage movement variables, we're done moving
			moveStageX = moveStageY = 0;
		}

		/*
		Sort functionality inspired by this url:
		http://mattmaxwellas3.blogspot.de/2008/05/sort-display-list-objects-based-on-y.html
		*/

		// create a sortable array of all display list objects
		public function buildChildList():void
		{
			childList = new Array(this.numChildren);
			var i:uint = this.numChildren;
			while (i--)
			{
				childList[i] = this.getChildAt(i);
			}
		}

		// sort the children of level by y index
		function sortChildrenByY():void
		{
			// sort display object list
			childList.sortOn("y", Array.NUMERIC);

			// find number of children
			var i:uint = this.numChildren;

			// cycle through child array
			while (i--)
			{
				// something moved, resort
				if (childList[i] != this.getChildAt(i))
				{
					this.setChildIndex(childList[i], i);
				}
			}
		}

		// add child to stage display list
		public function addStageChild(child:DisplayObject):void
		{
			stage.addChild(child);
		}

		// remove child from stage display list
		public function removeStageChild(child:DisplayObject):void
		{
			stage.removeChild(child);
		}

		// check when player tries to interact with something else;
		public function testPoke():Boolean
		{
			// reset poke indicator so we only react once per key srtike
			interactObj.poke = false;

			var i:int = 0;
			var num:Number;

			// check for object impact
			while (i != childList.length)
			{
				// is suspect the hero?
				if (childList[i] == hero)
				{
					// skip hero, should not be able to respond
					i++;

					// keep going
					continue;
				}

				// check for reaction to being poked
				if (childList[i].pokeRespond)
				{
					// can the hero poke this object?
					if (childList[i].pokeSuccess(hero,hero.moveAngle))
					{
						// call poke funtion
						childList[i].PokeAction();

						// stop trying to find something to poke
						i = childList.length;
						continue;
					}
				}

				// no success, keep going
				i++;
			}

			// nothing was found to interact with
			return false;
		}

		// set key interactions and mouse clicks to not do anything
		public function resetKeyboardAndMouse():void
		{
			var i:uint;

			// stop movement
			for (i=0; i!=moveDir.length; i++)
			{
				moveDir[i] = false;
			}

			// reset mouse indicator
			mouseIsDown = false;

			// reset interaction object
			interactObj.poke = false;

			// stop hero movement
			hero.gotoPoint = false;

			// reset hero graphics
			hero.resetTicks();
			hero.drawSprite();
		}

		public function cacheGfx()
		{
			this.cacheAsBitmap = true;
			levelGfx.cacheAsBitmap = true;
		}

		// troubleshooting function to tell how many children are present
		public function listChildren():void
		{
			var i:uint;
			for (i=0; i!=stage.numChildren; i++)
			{
				trace("Stage child: "+stage.getChildAt(i));
			}
			for (i=0; i!=this.numChildren; i++)
			{
				trace("Level child: "+this.getChildAt(i));
			}
			trace("Stage: "+stage.numChildren+", Level: "+this.numChildren+", NPCs: "+this.NPCsList.length+", Hero: "+hero.numChildren+", Timers: "+maploader.timers.length);
		}
	}
}