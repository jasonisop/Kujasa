package ObjectLogic
{
	import flash.geom.Point;
	import flash.display.Sprite;

	/* taken from the following URL:
	 * http://active.tutsplus.com/tutorials/actionscript/euclidean-vectors-in-flash/
	 *
	 * Daniel Sidhion, 15 November 2011
	 *
	 * Modified and commented by Will Thompson 19 May 2013
	 */

	// extending Sprite gives us access to the stage
	public class EuclideanVector extends Sprite
	{
		// class varialbes
		public var pos:Point;

		// constructor
		public function EuclideanVector(position:Point)
		{
			if (position != null)
			{
				pos = position;
			}
			else
			{
				pos = new Point();
			}
		}

		// Inverse of a Vector
		public function inverse():EuclideanVector
		{
			// rotate 180 degrees about the origin (0,0)
			return new EuclideanVector(new Point( -  pos.x, -  pos.y));
		}

		// add another vector's x and y values to this vector
		public function sum(otherVector:EuclideanVector):EuclideanVector
		{
			pos.x +=  otherVector.pos.x;
			pos.y +=  otherVector.pos.y;

			return this;
		}

		// subtract another vector's x and y from this vector
		public function subtract(otherVector:EuclideanVector):EuclideanVector
		{
			pos.x -=  otherVector.pos.x;
			pos.y -=  otherVector.pos.y;

			return this;
		}

		// multiply this vector's x and y by a number, scale it
		public function multiply(number:Number):EuclideanVector
		{
			pos.x *=  number;
			pos.y *=  number;

			return this;
		}

		// returns the distance of the vector from the origin (0,0) top left corner of the screen
		public function magnitude():Number
		{
			return Math.sqrt(pos.x * pos.x + pos.y * pos.y);
		}

		// returns the angle of the vector relative to the origin (0,0) top left corner of the screen
		public function angle():Number
		{
			var angle:Number = Math.atan2(pos.y,pos.x);

			// ensure angle is greater than 0
			while ((angle < 0))
			{
				angle +=  Math.PI * 2;
			}

			// ensure angle is less than 2pi
			while ((angle > Math.PI * 2))
			{
				angle -=  Math.PI * 2;
			}

			return angle;
		}

		// Represents the length of a vector in the direction of the other vector
		public function dot(otherVector:EuclideanVector):Number
		{
			/*
			 * If it’s positive, the angle ranges from 0 to 90 degrees
			 * If it’s negative, the angle ranges from 90 to 180 degrees
			 * If it’s zero, the angle is 90 degrees.
			 */
			return pos.x * otherVector.pos.x + pos.y * otherVector.pos.y;
		}

		// Smallest Angle Between Vectors
		public function angleBetween(otherVector:EuclideanVector):Number
		{
			return Math.acos((dot(otherVector) / (magnitude() * otherVector.magnitude())));
		}

		// Ranged Angle Between Vectors: angle between two vectors in relation to the origin (0,0) top left corner
		public function rangedAngleBetween(otherVector:EuclideanVector):Number
		{
			var firstAngle:Number;
			var secondAngle:Number;

			var angle:Number;

			firstAngle = Math.atan2(otherVector.pos.y,otherVector.pos.x);
			secondAngle = Math.atan2(pos.y,pos.x);

			angle = secondAngle - firstAngle;

			while ((angle > Math.PI))
			{
				angle -=  Math.PI * 2;
			}
			while ((angle <  -  Math.PI))
			{
				angle +=  Math.PI * 2;
			}

			return angle;
		}

		// maks the vector's magnitude equal to 1
		public function normalize():EuclideanVector
		{
			var m:Number = magnitude();
			pos.x /=  m;
			pos.y /=  m;

			return this;
		}

		// rotate about the y axis
		public function normalRight():EuclideanVector
		{
			return new EuclideanVector(new Point( -  pos.y,pos.x));
		}

		// rotate about the x axis
		public function normalLeft():EuclideanVector
		{
			return new EuclideanVector(new Point(pos.y, -  pos.x));
		}

		// rotate our point a number of degrees around the origin (0,0) top left corner
		public function rotate(angleInRadians:Number):EuclideanVector
		{
			var newPosX:Number = pos.x * Math.cos(angleInRadians) - pos.y * Math.sin(angleInRadians);
			var newPosY:Number = pos.x * Math.sin(angleInRadians) + pos.y * Math.cos(angleInRadians);

			pos.x = newPosX;
			pos.y = newPosY;

			return this;
		}
	}
}