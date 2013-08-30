package ObjectLogic
{
	// geometry logic
	import flash.geom.Rectangle;

	/*
	Useful for non-display boundry areas such as level edges, water, holes, edge of a
	cliff, or other flat areas on a map that shouldn't use display logic to stop hero
	from wandering around. Can be a rectangle or circle. Can be toggled on and off
	with the Active public variable.
	*/

	public class BoundryObject
	{
		// reference to map loader
		public var ml:Object;

		// rectangle info
		public var name:String;
		public var Active:Boolean;
		private var rect:Rectangle;
		private var isRectangle:Boolean;

		// does this object react to being moved into?
		public var bumpRespond:Boolean;
		public var bumpAction:Function;

		// holds calculations so they don't get created every time
		private var dx:int;
		private var dy:int;

		public function BoundryObject(rectangle:Rectangle, Name:String="boundry", IsRectangle:Boolean=true)
		{
			// the rectangle to be used by the object
			rect = rectangle;

			// hit response (move into this object with hero)
			bumpRespond = false;
			bumpAction = null;
			Active = true;

			// determine if circle or rectangle
			isRectangle = IsRectangle;
		}

		// test if something has impacted this object
		public function checkHit(obj:Object):Boolean
		{
			// check if active
			if (! Active)
			{
				return false;
			}

			// find difference between this and obj
			dx = obj.x - rect.x;
			dy = obj.y - rect.y;

			// is this a square?
			if (isRectangle)
			{
				// check if we fall outside x bounds
				if (dx<0 || dx>rect.width)
				{
					// no hit
					return false;
				}

				// check if we fall outside y bounds
				if (dy<0 || dy>rect.height)
				{
					// no hit
					return false;
				}
			}
			else
			{
				// check if change in x is greater than radius
				if (Math.abs(dx) > rect.width)
				{
					// too far away
					return false;
				}

				// check if change in y is greater than radius
				if (Math.abs(dy) > rect.width)
				{
					// too far away
					return false;
				}

				// distance between p1 and p2 = sqrt(dx^2 + dy^2)
				// if the distance is greater than radius
				if (Math.sqrt((dx*dx)+(dy*dy)) > rect.width)
				{
					// no hit
					return false;
				}
			}

			// we are inside
			return true;
		}

		function getRectangle()
		{
			return rect.clone();
		}

		function setRectangle(rectangle:Rectangle):void
		{
			rect = rectangle;
		}

		// garbage collection function
		public function Trash()
		{
			bumpRespond = false;
			bumpAction = null;
			Active = false;
			rect = null;
			isRectangle = false;
			dx = dy = 0;
			ml = null;
		}
	}
}