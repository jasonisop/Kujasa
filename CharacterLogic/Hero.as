package CharacterLogic
{
	// sprite package
	import flash.display.Shape;
	import flash.display.Sprite;

	// location stuff
	import flash.geom.Point;
	import flash.geom.Matrix;

	// figure out when added to stage
	import flash.events.Event;

	public class Hero extends Sprite
	{
		// graphics related variables
		public var footCircle:Shape;
		public var heroGfx:Shape;
		public var heroGfxMatrix:Matrix;

		// movement key array
		public var moveArray:Vector.<Boolean > ;

		// movement related variables
		public var moveAngle:Number;
		public var lastMoveAngle:Number;
		public var speed:int;
		public var canMove:Boolean;
		public var stillMoving:Boolean;
		public var travelPoint:Point;
		public var gotoPoint:Boolean;
		private var dx:int;
		private var dy:int;

		// sprite drawing variables
		public var spriteTick:uint;
		public var spriteImage:String;
		public var spriteFacing:uint;
		public var spritePosition:uint;
		public var spriteRedraw:Boolean;

		// level object
		public var lvl:Level;

		// inventory array
		private var heroInv:Array;

		public function Hero(levelObj:Level)
		{
			// set the name so everything can identify this object by name
			this.name = "hero";

			// level object
			lvl = levelObj;

			// create empty inventory array
			heroInv = lvl.heroInv;

			// prepare movement related variables
			moveArray = levelObj.moveDir;
			moveAngle = Math.PI / 2;
			lastMoveAngle = -1;
			speed = 6;
			canMove = true;
			stillMoving = false;
			gotoPoint = false;

			// used to track what stage of sprite animation we're on
			spriteTick = 2;
			spriteImage = 'hero';
			spritePosition = 0;
			spriteFacing = lvl.chars.DOWN;
			spriteRedraw = true;

			// make hero graphics a generic sprite so it exists
			footCircle = new Shape();
			heroGfx = new Shape();
			heroGfxMatrix = new Matrix();
			heroGfxMatrix.tx = -32;
			heroGfxMatrix.ty = -64;

			// listen out for when we're added to the stage
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}

		// we've been added to the stage, initialize
		function init(e:Event):void
		{
			// remove event listener
			removeEventListener(Event.ADDED_TO_STAGE, init);
			drawGfx();
			addStageGfx();
		}

		// every frame this should tick
		public function Tick():void
		{
			// keep track of current position
			var tmpPos:uint = spritePosition;

			// tick our position counter
			spriteTick++;

			// see what position our walk is on
			if (spriteTick == 27)
			{
				// reset tick counter
				spriteTick = 4;

				// upright
				spritePosition = 1;
			}

			spritePosition = spriteTick / 3;

			// if we changed our walking position
			if (tmpPos != spritePosition)
			{
				// redraw hero
				spriteRedraw = true;
			}
		}

		public function resetTicks():void
		{
			spriteTick = 2;
			spritePosition = 0;
			spriteRedraw = true;
		}

		// draw the graphic
		public function drawGfx():void
		{
			// draw circle
			footCircle.graphics.clear();
			footCircle.graphics.beginFill(0x000000, .3);
			footCircle.graphics.drawCircle(0,0,15);
			footCircle.graphics.endFill();

			// cache shadow as bitmap so it doesn't recalculate;
			footCircle.cacheAsBitmap = true;

			// draw hero graphic
			spriteFacing = lvl.chars.DOWN;
			drawSprite();
		}

		// draw hero sprite
		public function drawSprite():void
		{
			// check if need to redraw sprite
			if (! spriteRedraw)
			{
				// don't redraw, return
				return;
			}

			// reset need to redraw
			spriteRedraw = false;

			// clear hero graphics and prepare to draw new ones
			heroGfx.graphics.clear();

			// draw the hero from our sprite sheet;
			heroGfx.graphics.beginBitmapFill(lvl.chars.getCharPos(spriteFacing,spritePosition,spriteImage),heroGfxMatrix);
			heroGfx.graphics.drawRect(heroGfxMatrix.tx,heroGfxMatrix.ty,64,64);
			heroGfx.graphics.endFill();

			// flatten graphics so it doesn't require more memory/cpu;
			heroGfx.cacheAsBitmap = true;
		}

		// add graphics to stage in appropriate order
		public function addStageGfx():void
		{
			addChild(footCircle);
			addChild(heroGfx);
		}

		// remove graphics to stage in appropriate order
		public function removeStageGfx():void
		{
			removeChild(heroGfx);
			removeChild(footCircle);
		}

		public function moveTowardPoint():Boolean
		{
			// calculate movement angle
			dx = travelPoint.x - this.x;
			dy = travelPoint.y - this.y;

			// are we reasonably close to our point?
			if (Math.abs(dx) < speed && Math.abs(dy) < speed)
			{
				// stop traveling to our point
				gotoPoint = false;

				// reset sprite animation
				resetTicks();

				// redraw the sprite
				drawSprite();

				// no more movement
				return false;
			}

			// set new movement angle
			moveAngle = Math.atan2(dy,dx);

			// tick our graphics counter to keep our sprite animation going
			Tick();

			// check if we need a new graphic
			checkMoveAngle();

			// do move action
			return doMoveAction();
		}

		public function moveHero():Boolean
		{
			if (! canMove)
			{
				return false;
			}

			// setup variables
			var checker = false;
			var i = 0;

			// if up and down are both held down
			if (moveArray[0] && moveArray[1])
			{
				// set both to false
				moveArray[0] = false;
				moveArray[1] = false;
			}

			// if left and right are both held down
			if (moveArray[2] && moveArray[3])
			{
				// set both to false
				moveArray[2] = false;
				moveArray[3] = false;
			}

			// cycle through move array to see if we're actually moving
			for (i = moveArray.length - 1; i != -1; i--)
			{
				if (moveArray[i])
				{
					checker = true;
				}
			}

			// if we're not moving return
			if (! checker)
			{
				// see if we're moving toward a point via mouse click
				if (gotoPoint)
				{
					return moveTowardPoint();
				}

				// we were moving last frame but we stopped, stop animation!
				if (stillMoving)
				{
					// stop moving
					stillMoving = false;

					// reset our ticks so animation resets
					resetTicks();

					// draw the hero standing still
					drawSprite();
				}
				return false;
			}

			stillMoving = true;
			gotoPoint = false;

			// tick animation counter so we have the correct hero image
			Tick();

			/*
			Up = moveArray[0]
			Down = moveArray[1]
			Left = moveArray[2]
			Right = moveArray[3]
			*/

			// find out what direction we are moving
			if (moveArray[0])
			{
				// we're going right, 270 degrees = 3pi/2
				moveAngle = (3 * Math.PI) / 2;
			}
			else if (moveArray[1])
			{
				// we're going left, 90 degrees = pi / 2
				moveAngle = Math.PI / 2;
			}

			// check if going up & right OR down & left
			if (moveArray[0] && moveArray[3] || moveArray[1] && moveArray[2])
			{
				// also going up, 45 degrees = pi/4
				moveAngle +=  Math.PI / 4;
			}

			// check if going up & left OR down & right
			if (moveArray[0] && moveArray[2] || moveArray[1] && moveArray[3])
			{
				// also going down
				moveAngle -=  Math.PI / 4;
			}

			// if we're not going up or down
			if (! moveArray[0] && ! moveArray[1])
			{
				// find out what direction are we moving
				if (moveArray[2])
				{
					// we're going right
					moveAngle = Math.PI;
				}
				else if (moveArray[3])
				{
					// we're going left
					moveAngle = 0;
				}
			}

			// check if we need a new graphic
			checkMoveAngle();

			return doMoveAction();
		}

		public function checkMoveAngle():void
		{
			// correct if angle is greater than 2pi
			while (moveAngle > (2*Math.PI))
			{
				moveAngle -=  2 * Math.PI;
			}

			// correct if angle is greater than 2pi
			while (moveAngle < 0)
			{
				moveAngle +=  2 * Math.PI;
			}

			// check if we need new movement graphic
			if (moveAngle != lastMoveAngle)
			{
				var tmpFacing:uint;
				var mums:Number = Math.PI / 4;

				if (moveAngle > mums*7)
				{
					// moving right
					tmpFacing = lvl.chars.RIGHT;
				}
				else if (moveAngle > mums*5)
				{
					// moving down
					tmpFacing = lvl.chars.UP;
				}
				else if (moveAngle > mums*3)
				{
					// moving left
					tmpFacing = lvl.chars.LEFT;
				}
				else if (moveAngle > mums)
				{
					// moving up
					tmpFacing = lvl.chars.DOWN;
				}
				else
				{
					// moving right
					tmpFacing = lvl.chars.RIGHT;
				}

				// check if facing the same direction still
				if (spriteFacing != tmpFacing)
				{
					// we changed direction, draw hero
					spriteFacing = tmpFacing;

					// tell draw function it should redraw
					spriteRedraw = true;
				}
			}

			// record last move angle
			lastMoveAngle = moveAngle;

			// redraw the sprite
			drawSprite();
		}

		function doMoveAction():Boolean
		{
			// we're still moving, update our data
			var moving = 0;

			// calculate how much to move x and y
			var addX:int = Math.round(speed * Math.cos(moveAngle));
			var addY:int = Math.round(speed * Math.sin(moveAngle));

			this.x +=  addX;
			if (! impactObjs())
			{
				// hero is inside the level and no object impacts
				// move the level x units
				lvl.moveStageX -=  addX;

				// indicate we've moved
				moving++;
			}
			else
			{
				// hit something, go back
				this.x -=  addX;
			}

			this.y +=  addY;
			if (! impactObjs())
			{
				// hero is inside the level and no object impacts
				// move the level y units
				lvl.moveStageY -=  addY;

				// indicate we've moved
				moving++;
			}
			else
			{
				// hit something, go back
				this.y -=  addY;
			}

			// check if we hit a trigger
			impactTriggers();

			// if checker or moving are true return true
			return Boolean(moving);
		}

		public function impactTriggers():Boolean
		{
			for (var i=0; i < lvl.TriggerObjs.length; i++)
			{
				if (lvl.TriggerObjs[i].checkHit(this))
				{
					lvl.TriggerObjs[i].TriggerAction();
					return true;
				}
			}
			return false;
		}

		function impactBoundry():Boolean
		{
			for (var i=0; i < lvl.BoundryObjs.length; i++)
			{
				if (lvl.BoundryObjs[i].checkHit(this))
				{
					if (lvl.BoundryObjs[i].bumpRespond)
					{
						lvl.BoundryObjs[i].bumpAction();
					}
					return true;
				}
			}
			return false;
		}

		function impactObjs():Boolean
		{
			if (impactBoundry())
			{
				return true;
			}

			if (impactCircles())
			{
				return true;
			}

			if (impactRectangles())
			{
				return true;
			}

			if (impactEuclids())
			{
				return true;
			}

			if (impactNPCs())
			{
				return true;
			}

			return false;
		}

		function impactCircles():Boolean
		{
			var i:int = lvl.CircleObjs.length - 1;

			// check for object impact
			while (i != -1)
			{
				if (lvl.CircleObjs[i].checkHit(this))
				{
					if (lvl.CircleObjs[i].bumpRespond)
					{
						lvl.CircleObjs[i].bumpAction();
					}
					// we hit something, don't move!;
					return true;
				}
				i--;
			}
			// no impacts
			return false;
		}

		function impactRectangles():Boolean
		{
			var i:int = lvl.RectangleObjs.length - 1;

			// check for object impact
			while (i != -1)
			{
				if (lvl.RectangleObjs[i].checkHit(this))
				{
					if (lvl.RectangleObjs[i].bumpRespond)
					{
						lvl.RectangleObjs[i].bumpAction();
					}
					// we hit something, don't move!;
					return true;
				}
				i--;
			}
			// no impacts
			return false;
		}

		function impactEuclids():Boolean
		{
			var i:int = lvl.EuclidObjs.length - 1;

			// check for object impact
			while (i != -1)
			{
				if (lvl.EuclidObjs[i].checkHit(this))
				{
					if (lvl.EuclidObjs[i].bumpRespond)
					{
						lvl.EuclidObjs[i].bumpAction();
					}
					// we hit something, don't move!;
					return true;
				}
				i--;
			}
			// no impacts
			return false;
		}

		function impactNPCs():Boolean
		{
			var i:int = lvl.NPCsList.length - 1;

			// check for object impact
			while (i != -1)
			{
				if (lvl.NPCsList[i].checkHit(this))
				{
					// check for reaction to being hit
					if (lvl.NPCsList[i].bumpRespond)
					{
						lvl.NPCsList[i].bumpAction();
					}

					// we hit something, don't move!
					return true;
				}
				i--;
			}
			// no impacts
			return false;
		}

		// turn character toward an other object
		public function faceObj(obj:Object):void
		{
			// holder for last move angle
			var lastAng:Number = lastMoveAngle;

			// calculate movement angle
			dx = obj.x - this.x;
			dy = obj.y - this.y;

			// set new movement angle
			moveAngle = Math.atan2(dy,dx);

			// check if we need a new graphic
			checkMoveAngle();

			// reset last move angle
			lastMoveAngle = lastAng;
		}

		// add an item to the inventory list
		public function InventoryAdd(obj:Object):void
		{
			// add an object
			heroInv.push(obj);

			// sort the inventory after adding something
			heroInv.sortOn('name');
		}

		// check if inventory item is present
		public function InventoryFindObj(obj:Object):Boolean
		{
			// check if item is in inventory
			if (heroInv.indexOf(obj) == -1)
			{
				// not present, return false
				return false;
			}

			// something matched, return true
			return true;
		}

		// check if inventory item is present
		public function InventoryFindByName(Name:String):Object
		{
			// figure out if inventory item is present
			for (var i=0; i!= heroInv.length; i++)
			{
				// if this item matches
				if (heroInv[i].name == Name)
				{
					// return it
					return heroInv[i];
				}
			}

			// no match, return null
			return null;
		}

		// drop an inventory item
		public function InventoryDrop(obj:Object):void
		{
			// check if item is in inventory
			if (heroInv.indexOf(obj) == -1)
			{
				// not present, just return
				return;
			}

			// object is present, remove it
			heroInv.splice(heroInv.indexOf(obj), 1);
		}
	}
}