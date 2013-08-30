package ObjectLogic
{
	import flash.display.Shape;
	import flash.geom.Point;
	import ObjectLogic.EuclideanVector;
	import ObjectLogic.EuclideanFunctions;

	/*
	Useful for display objects of odd shape that cannot be represented by a circle or
	rectangle. Expensive on CPU cycles so use sparingly, avoid entirely if possible.
	Provided for the odd situations where you cannot make anything else or there are
	odd angles that need to be represented.
	*/

	public class EuclidObject extends Shape
	{
		// determine if shape can move and which method used to test
		private var moveable:Boolean;
		private var complex:Boolean;

		// extreme x/y coordinates
		private var minX:int;
		private var minY:int;
		private var maxX:int;
		private var maxY:int;

		// shape points and test object
		public var vec:Vector.<EuclideanVector > ;
		public var testObj:EuclideanVector;

		// does this object react to being moved into?
		public var bumpRespond:Boolean;
		public var bumpAction:Function;

		// does this object react to being clicked?
		public var clickRespond:Boolean;
		public var ClickAction:Function;

		// does this object react to being poked?
		public var pokeRespond:Boolean;
		public var PokeAction:Function;

		public function EuclidObject(EuclideanPoints:Vector.<EuclideanVector>, complexObject:Boolean=false)
		{
			// validate vector passed and find outside bounds
			handleVecs(EuclideanPoints);

			// assign default values
			vec = EuclideanPoints.slice();
			moveable = false;
			testObj = new EuclideanVector(new Point());
			complex = complexObject;

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

		private function handleVecs(EuclideanPoints:Vector.<EuclideanVector>)
		{
			// check if we have enough points
			if (EuclideanPoints.length < 3)
			{
				throw new Error("Not enough points in Euclidean Vector");
			}

			// default to first point in vector
			minX = vec[0].x;
			maxX = vec[0].x;
			minY = vec[0].y;
			maxY = vec[0].y;

			// determine min/max for x/y values
			for (var i:int=1; i!=vec.length; i++)
			{
				// check for lower than minX
				if (vec[i].x < minX)
				{
					minX = vec[i].x;
				}

				// check for high than minX
				if (vec[i].x > maxX)
				{
					maxX = vec[i].x;
				}

				// check for lower than minY
				if (vec[i].y < minY)
				{
					minY = vec[i].y;
				}

				// check for high than minY
				if (vec[i].y > maxY)
				{
					maxY = vec[i].y;
				}
			}
		}

		// test if something has impacted this object
		public function checkHit(obj:Object):Boolean
		{
			// orient testObj in relation to this object
			testObj.pos.x = this.x - obj.x;
			testObj.pos.y = this.y - obj.y;

			// check outside x bounds like a rect
			if (testObj.pos.x > maxX || testObj.pos.x < minX)
			{
				return false;
			}

			// check outside y bounds like a rect
			if (testObj.pos.y > maxY || testObj.pos.y < minY)
			{
				return false;
			}

			// check if complicated object or not
			if (complex)
			{
				// did it hit?
				if (EuclideanFunctions.isPointInsideShape3(testObj,vec))
				{
					// we hit!
					return true;
				}
			}
			else if (EuclideanFunctions.isPointInsideShape1(testObj,vec))
			{
				// we hit!
				return true;
			}

			// not a hit
			return false;
		}

		public function isMoveable():Boolean
		{
			return moveable;
		}

		public function setMoveable(Value:Boolean):void
		{
			moveable = Value;
		}

		public function getVectors()
		{
			return vec.slice();
		}

		public function setVectors(EuclideanPoints:Vector.<EuclideanVector>):void
		{
			handleVecs(EuclideanPoints);
			vec = EuclideanPoints.slice();
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

			// object is at wrong angle to poke this circle
			return false;
		}

		// garbage collection function
		public function Trash()
		{
			moveable = false;
			complex = false;
			minX = 0;
			minY = 0;
			maxX = 0;
			maxY = 0;
			bumpRespond = false;
			bumpAction = null;
			clickRespond = false;
			ClickAction = null;
			pokeRespond = false;
			PokeAction = null;

			while (vec.length)
			{
				vec[0].pos = null;
				vec.shift();
			}

			testObj.pos = null;
			testObj = null;
		}
	}
}