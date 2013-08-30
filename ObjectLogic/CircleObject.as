package ObjectLogic
{
	import flash.display.Shape;
	import flash.geom.Point;

	/*
	Useful for display objects that are round such as trees, rocks, barrels, buckets,
	or anything else that is naturally expected to have a round boundry. Works good in
	conjunction with Boundry objects for oddly shaped objects with round edges.
	*/

	public class CircleObject extends Shape
	{
		// size of circle and name
		private var radius:int;

		// can this object be moved when hit?
		public var moveable:Boolean;

		// does this object react to being moved into?
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

		public function CircleObject(Radius:int=16, Name:String="circle", Moveable:Boolean=false)
		{
			// set size and position
			radius = Radius;

			// circle object name
			name = Name;

			// determine if moveable and clickable
			moveable = Moveable;

			// hit response (move into this object with hero)
			bumpRespond = false;

			// click response (clicked on by player)
			clickRespond = false;

			// interaction response (space bar by default)
			pokeRespond = false;
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

		// garbage collection function
		public function Trash()
		{
			radius = 0;
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