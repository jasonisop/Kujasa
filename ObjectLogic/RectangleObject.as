package ObjectLogic
{
	// display logic
	import flash.display.Shape;

	// geometry logic
	import flash.geom.Rectangle;

	/*
	Useful for display objects with square corners such as boxes, crates, houses,
	or anything else that is naturally square or rectangular. Works good in conjunction
	with Boundry objects for oddly shaped objects with sharp corners.
	*/

	public class RectangleObject extends Shape
	{
		// area covered and moveable
		private var rect:Rectangle;
		private var moveable:Boolean;

		// does this object react to being bumped?
		public var bumpRespond:Boolean;
		public var bumpAction:Function;

		// does this object react to being clicked?
		public var clickRespond:Boolean;
		public var ClickAction:Function;

		// does this object react to being poked?
		public var pokeRespond:Boolean;
		public var PokeAction:Function;

		// holds calculations so they don't get created every time
		private var dx:int;
		private var dy:int;
		private var ang:Number;

		public function RectangleObject(theRectangle:Rectangle, Moveable:Boolean=false)
		{
			// object can be pushed by hero
			moveable = Moveable;
			rect = theRectangle;

			// hit response (move into this object with hero)
			bumpRespond = false;
			bumpAction = null;

			// click response (clicked on by player)
			clickRespond = false;
			ClickAction = null;

			// interaction response (space bar by default)
			pokeRespond = false;
			PokeAction = null;
		}

		// test if something has impacted this object
		public function checkHit(obj:Object):Boolean
		{
			// calculate difference in x
			dx = obj.x - this.x - rect.x;

			// if outside 0 and rect width
			if (dx<0 || dx>rect.width)
			{
				// no hit
				return false;
			}

			// calculate difference in y
			dy = obj.y - this.y - rect.y;

			// if outside 0 and rect height
			if (dy<0 || dy>rect.height)
			{
				// no hit
				return false;
			}

			// we hit!
			return true;
		}

		public function isMoveable():Boolean
		{
			return moveable;
		}

		public function setMoveable(Value:Boolean):void
		{
			moveable = Value;
		}

		public function getRectangle()
		{
			return rect.clone();
		}

		public function setRectangle(rectangle:Rectangle):void
		{
			rect = rectangle;
		}

		// try to poke this object
		public function pokeSuccess(obj:Object, objAng:Number):Boolean
		{
			// check if object can be poked
			if (! pokeRespond)
			{
				// not possible to poke this circle object
				return false;
			}

			// make rect bigger to test if obj is inside area
			rect.x -=  64;
			rect.y -=  64;
			rect.width +=  128;
			rect.height +=  128;

			// check if inside hit area
			var success:Boolean = this.checkHit(obj);

			// reset rect to size before test
			rect.x +=  64;
			rect.y +=  64;
			rect.width -=  128;
			rect.height -=  128;

			// see if we're outside the hit area
			if (! success)
			{
				// outside hit area, return false
				return false;
			}

			// calculate dx and dy based on correct rect information
			dx = obj.x - this.x - rect.x;
			dy = obj.y - this.y - rect.y;

			// adjust dx
			if (dx > rect.width)
			{
				dx -=  rect.width;
			}
			else if (dx > 0)
			{
				dx = 0;
			}

			// adjust dy
			if (dy > rect.height)
			{
				dy -=  rect.height;
			}
			else if (dy > 0)
			{
				dy = 0;
			}

			// find angle between object and the determined point
			ang = Math.atan2(dy,dx);

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

			var dist:int;
			dist = Math.sqrt((dx*dx)+(dy*dy));

			// compensate for object angle;
			ang = Math.abs(ang - objAng);

			// check if obj is facing this circle
			if (ang >= Math.PI * (3 / 4) && ang <= Math.PI * (5 / 4))
			{
				// object can be poked
				return true;
			}

			// object is at wrong angle to poke
			return false;
		}

		// garbage collection function
		public function Trash()
		{
			rect = null;
			moveable = false;
			bumpRespond = false;
			bumpAction = null;
			clickRespond = false;
			ClickAction = null;
			pokeRespond = false;
			PokeAction = null;
			dx = 0;
			dy = 0;
			ang = 0;
		}
	}
}