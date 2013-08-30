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

	public class NPC extends Sprite
	{
		// level object
		private var lvl:Level;

		// size of NPC, default 16 (32x32 area)
		private var radius:int;

		// does this object react to being moved into?
		public var bumpRespond:Boolean;
		public var bumpAction:Function;

		// does this object react to being clicked?
		public var clickRespond:Boolean;
		public var ClickAction:Function;

		// does this object react to being poked?
		public var pokeRespond:Boolean;
		public var PokeAction:Function;

		// graphics related variables
		private var footCircle:Shape;
		private var NPCGfx:Shape;
		private var NPCGfxMatrix:Matrix;

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
		private var spriteTick:uint;
		public var spriteImage:String;
		private var spriteFacing:uint;
		private var spritePosition:uint;
		private var spriteRedraw:Boolean;

		public function NPC(level:Level, SpriteImage:String='princess', Name:String='NPC')
		{
			// set the name so everything can identify this object by name
			this.name = Name;

			// level object
			lvl = level;

			// size of NPC
			radius = 16;

			// hit response (move into this object with hero)
			bumpRespond = false;
			bumpAction = null;

			// click response (clicked on by player)
			clickRespond = false;
			ClickAction = null;

			// interaction response (space bar by default)
			pokeRespond = false;
			PokeAction = null;

			// prepare movement related variables
			moveAngle = 0;
			lastMoveAngle = -1;
			speed = 10;
			canMove = true;
			stillMoving = false;
			travelPoint = new Point();
			gotoPoint = false;

			// used to track what stage of sprite animation we're on
			spriteTick = 2;
			spriteImage = SpriteImage;
			spritePosition = 0;
			spriteFacing = lvl.chars.DOWN;
			spriteRedraw = true;

			// make hero graphics a generic sprite so it exists
			footCircle = new Shape();
			NPCGfx = new Shape();
			NPCGfxMatrix = new Matrix();
			NPCGfxMatrix.tx = -32;
			NPCGfxMatrix.ty = -64;

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
			spritePosition = lvl.chars.DOWN;
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
			NPCGfx.graphics.clear();

			// draw the hero from our sprite sheet;
			NPCGfx.graphics.beginBitmapFill(lvl.chars.getCharPos(spriteFacing,spritePosition,spriteImage),NPCGfxMatrix);
			NPCGfx.graphics.drawRect(NPCGfxMatrix.tx,NPCGfxMatrix.ty,64,64);
			NPCGfx.graphics.endFill();

			// flatten graphics so it doesn't require more memory/cpu;
			NPCGfx.cacheAsBitmap = true;
		}

		// add graphics to stage in appropriate order
		public function addStageGfx():void
		{
			addChild(footCircle);
			addChild(NPCGfx);
		}

		// remove graphics to stage in appropriate order
		public function removeStageGfx():void
		{
			removeChild(NPCGfx);
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

		// move the NPC toward a point
		function doMoveAction():Boolean
		{
			// we're still moving, update our data
			var moving = 0;

			// move the NPC the proper amount
			this.x += Math.round(speed * Math.cos(moveAngle));
			this.y += Math.round(speed * Math.sin(moveAngle));

			// if checker or moving are true return true
			return Boolean(moving);
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

		// test if obj is inside radius
		public function checkHit(obj:Object):Boolean
		{
			// distance x between p1 and p2 = p1.x - p2.x
			dx = this.x - obj.x;
			if (Math.abs(dx) > radius)
			{
				// too far away
				return false;
			}

			// distance y between p1 and p2 = p1.y - p2.y
			dy = this.y - obj.y;
			if (Math.abs(dy) > radius)
			{
				// too far away
				return false;
			}

			// distance between p1 and p2 = sqrt(dx^2 + dy^2)
			// if the distance is greater than radius
			if (Math.sqrt((dx*dx)+(dy*dy)) > radius)
			{
				// no hit
				return false;
			}

			// hit!
			return true;
		}

		// try to poke this object
		public function pokeSuccess(obj:Object, objAng:Number):Boolean
		{
			// check if object can be poked
			if (! pokeRespond)
			{
				// not possible to poke this object
				return false;
			}

			// increase radius to test if inside hit area
			radius +=  64;

			var success:Boolean = checkHit(obj);

			// reset radius to size before test
			radius -=  64;

			// check if outside the hit area
			if (! success)
			{
				// outside hit area, return
				return false;
			}

			// find angle between object and this
			var ang:Number = Math.atan2(dy,dx);

			// correct angles less than 2pi
			while (ang < 0)
			{
				ang +=  Math.PI * 2;
			}

			// correct angles more than 2pi
			while (ang > Math.PI*2)
			{
				ang -=  Math.PI * 2;
			}

			// compensate for object angle
			ang = Math.abs(ang - objAng);

			// check if obj is facing this
			if (ang <= Math.PI * (1 / 4) || ang >= Math.PI * (7 / 4))
			{
				// object can be poked
				return true;
			}

			// object is at wrong angle to poke
			return false;
		}

		// turn character toward an other object
		public function faceObj(obj:Object)
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

		// garbage collection function
		public function Trash()
		{
			lvl = null;
			radius = 0;
			bumpRespond = false;
			bumpAction = null;
			clickRespond = false;
			ClickAction = null;
			pokeRespond = false;
			PokeAction = null;
			footCircle = null;
			NPCGfx = null;
			NPCGfxMatrix = null;
			moveAngle = 0;
			lastMoveAngle = 0;
			speed = 0;
			canMove = false;
			stillMoving = false;
			travelPoint = null;
			gotoPoint = false;
			dx = 0;
			dy = 0;
			spriteTick = 0;
			spriteImage = null;
			spriteFacing = 0;
			spritePosition = 0;
			spriteRedraw = false;
		}
	}
}