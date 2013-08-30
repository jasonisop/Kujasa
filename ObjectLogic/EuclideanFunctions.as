package ObjectLogic
{
	import flash.geom.Point;
	import ObjectLogic.EuclideanVector;

	/* taken from the following URL:
	 * http://active.tutsplus.com/tutorials/actionscript/euclidean-vectors-in-flash/
	 *
	 * Daniel Sidhion, 15 November 2011
	 *
	 * Modified and commented by Will Thompson 19 May 2013
	 */

	public class EuclideanFunctions
	{
		/*
		The Crossing Number or Even-Odd Rule Algorithm
		
		This algorithm can be used for any shape. This is what you read: any shape,
		have it holes or not, be it convex or not. It is based on the fact that any
		ray cast from the point you want to check out to infinity will cross an even
		number of edges if the point is outside the shape, or odd number of edges if
		the point is inside the shape. This can be proven by the Jordan curve theorem,
		which implies that you will have to cross a border between some region and
		other region if you want to move from one to other. In our case, our regions
		are "inside the shape" and "outside the shape".
		
		It will return false if the point is not inside the shape, or true if the point
		is inside the shape.
		*/

		public static function isPointInsideShape1(point:EuclideanVector, shapeVertices:Vector.<EuclideanVector>):Boolean
		{
			var numberOfSides:int = shapeVertices.length;
			var i:int = 0;
			var j:int = numberOfSides - 1;
			var oddNodes:Boolean = false;
			while (i < numberOfSides)
			{
				if ((shapeVertices[i].pos.y < point.pos.y && shapeVertices[j].pos.y >= point.pos.y) ||
				            (shapeVertices[j].pos.y < point.pos.y && shapeVertices[i].pos.y >= point.pos.y))
				{
					if (shapeVertices[i].pos.x + (((point.pos.y - shapeVertices[i].pos.y) / (shapeVertices[j].pos.y - shapeVertices[i].pos.y)) *
					                (shapeVertices[j].pos.x - shapeVertices[i].pos.x)) < point.pos.x)
					{
						oddNodes = ! oddNodes;
					}
				}
				j = i;
				i++;
			}
			return oddNodes;
		}

		/*
		The Winding Number Algorithm
		
		The winding number algorithm use the sum of all the angles made between the
		point to check and each pair of points that define the polygon. If the sum is
		close to 2pi, then the point being checked is inside the vector. If it is close
		to 0 then the point is outside.
		
		The code uses the ranged angle between vectors and gives space for imprecisions:
		notice how we are checking the results of the sum of all angles. We do not check
		if the angle is exactly zero or 2pi. Instead, we check if it is less than pi and
		higher than pi, a considerable median value.
		*/

		public static function isPointInsideShape2(point:EuclideanVector, shapeVertices:Vector.<EuclideanVector>):Boolean
		{
			var numberOfSides:int = shapeVertices.length;
			var i:int = 0;
			var angle:Number = 0;
			var rawAngle:Number = 0;
			var firstVector:EuclideanVector;
			var secondVector:EuclideanVector;
			while (i < numberOfSides)
			{
				firstVector = new EuclideanVector(new Point(shapeVertices[i].pos.x - point.pos.x,shapeVertices[i].pos.y - point.pos.y));
				secondVector = new EuclideanVector(new Point(shapeVertices[(i + 1) % numberOfSides].pos.x - point.pos.x,shapeVertices[(i + 1) % numberOfSides].pos.y - point.pos.y));
				angle +=  secondVector.rangedAngleBetween(firstVector);
				i++;
			}
			if (Math.abs(angle) < Math.PI)
			{
				return false;
			}
			else
			{
				return true;
			}
		}

		/*
		The Concave Polygon Algorithm
		
		The concave polygon algorithm relies on the fact that, for a concave polygon, a
		point inside it is always to the left of the edges (if we are looping through
		them in a counter-clockwise sense) or to the right of the edges (if we are
		looping through them in a clockwise sense).
		
		Imagine standing in a room shaped like the image above, and walking around the
		edges of it with your left hand trailing along the wall. At the point along the
		wall where you are closest to the point you are interested in, if it's on your
		right then it must be inside the room; if it's on your left then it must be outside.
		
		The problem lies in determining whether a point is to the left or right of an
		edge (which is basically a vector). This is done through the following formula:
		
		Pos = (Y-Y0)*(X1-X0)-(X-X0)*(Y1-Y0)
		
		That formula returns a number less than 0 for points to the right of the edge,
		and greater than 0 for points to the left of it. If the number is equal to 0,
		the point lies on the edge, and is considered inside the shape. The code is the
		following:
		*/

		public static function isPointInsideShape3(point:EuclideanVector, shapeVertices:Vector.<EuclideanVector>):Boolean
		{
			var numberOfSides:int = shapeVertices.length;
			var i:int = 0;
			var firstEdgePoint:EuclideanVector;
			var secondEdgePoint:EuclideanVector;
			var leftOrRightSide:Boolean;
			while (i < numberOfSides)
			{
				firstEdgePoint = shapeVertices[i];
				secondEdgePoint = shapeVertices[(i + 1) % numberOfSides];
				if (i == 0)
				{
					// Determining if the point is to the left or to the right of first edge
					// true for left, false for right
					leftOrRightSide = ((point.pos.y - firstEdgePoint.pos.y) * (secondEdgePoint.pos.x - firstEdgePoint.pos.x)) - ((point.pos.x - firstEdgePoint.pos.x) * (secondEdgePoint.pos.y - firstEdgePoint.pos.y)) > 0;
				}
				else
				{
					// Now all edges must be on the same side
					if (leftOrRightSide && ((point.pos.y - firstEdgePoint.pos.y) * (secondEdgePoint.pos.x - firstEdgePoint.pos.x)) - ((point.pos.x - firstEdgePoint.pos.x) * (secondEdgePoint.pos.y - firstEdgePoint.pos.y)) < 0)
					{
						// Not all edges are on the same side!
						return false;
					}
					else if (!leftOrRightSide && ((point.pos.y - firstEdgePoint.pos.y) * (secondEdgePoint.pos.x - firstEdgePoint.pos.x)) - ((point.pos.x - firstEdgePoint.pos.x) * (secondEdgePoint.pos.y - firstEdgePoint.pos.y)) > 0)
					{
						// Not all edges are on the same side!
						return false;
					}
				}
				i++;
			}
			// We looped through all vertices and didn't detect different sides
			return true;
		}

		/*
		Ray Casting
		
		Ray casting is a technique often used for collision detection and rendering. It
		consists of a ray that is cast from one point to another (or out to infinity).
		This ray is made of points or vectors, and generally stops when it hits an
		object or the edge of the screen. Similarly to the point-in-shape algorithms,
		there are many ways to cast rays, and we will see two of them in this post:
		
		The Bresenham's line algorithm, which is a very fast way to determine close
		points that would give an approximation of a line between them.
		
		The DDA (Digital Differential Analyzer) method, which is also used to create a line.
		
		In the next two steps we will look into both methods. After that, we will see
		how to make our ray stop when it hits an object. This is very useful when you
		need to detect collision against fast moving objects.
		*/

		/*
		The Bresenham's Line Algorithm
		
		This algorithm is used very often in computer graphics, and depends on the
		convention that the line will always be created pointing to the right and
		downwards. (If a line has to be created to the up and left directions,
		everything is inverted later.) Let's go into the code:
		
		The code will produce an AS3 Vector of Euclidean vectors that will make the
		line. With this Vector, we can later check for collisions.
		*/
		public static function createLineBresenham(startVector:EuclideanVector, endVector:EuclideanVector):Vector.<EuclideanVector > 
		{
			var points:Vector.<EuclideanVector> = new Vector.<EuclideanVector>();
			var steep:Boolean = Math.abs(endVector.pos.y - startVector.pos.y) > Math.abs(endVector.pos.x - startVector.pos.x);
			var swapped:Boolean = false;
			if (steep)
			{
				startVector = new EuclideanVector(new Point(startVector.pos.y,startVector.pos.x));
				endVector = new EuclideanVector(new Point(endVector.pos.y,endVector.pos.x));
			}
			// Making the line go downward
			if (startVector.pos.x > endVector.pos.x)
			{
				var temporary:Number = startVector.pos.x;
				startVector.pos.x = endVector.pos.x;
				endVector.pos.x = temporary;
				temporary = startVector.pos.y;
				startVector.pos.y = endVector.pos.y;
				endVector.pos.y = temporary;
				swapped = true;
			}
			var deltaX:Number = endVector.pos.x - startVector.pos.x;
			var deltaY:Number = Math.abs(endVector.pos.y - startVector.pos.y);
			var error:Number = deltaX / 2;
			var currentY:Number = startVector.pos.y;
			var step:int;
			if (startVector.pos.y < endVector.pos.y)
			{
				step = 1;
			}
			else
			{
				step = -1;
			}
			var iterator:int = startVector.pos.x;
			while (iterator < endVector.pos.x)
			{
				if (steep)
				{
					points.push(new EuclideanVector(new Point(currentY, iterator)));
				}
				else
				{
					points.push(new EuclideanVector(new Point(iterator, currentY)));
				}
				error -=  deltaY;
				if (error < 0)
				{
					currentY +=  step;
					error +=  deltaX;
				}
				iterator++;
			}
			if (swapped)
			{
				points.reverse();
			}
			return points;
		}

		/*
		The DDA Method
		
		An implementation of the Digital Differential Analyzer is used to interpolate
		variables between two points. Unlike the Bresenham's line algorithm, this
		method will only create vectors in integer poss for simplicity. Here's the code:
		
		This code will also return an AS3 Vector of Euclidean vectors.
		*/
		public static function createLineDDA(startPoint:EuclideanVector, endPoint:EuclideanVector):Vector.<EuclideanVector > 
		{
			var points:Vector.<EuclideanVector> = new Vector.<EuclideanVector>();
			var dx:Number;
			var dy:Number;
			var _x:Number = startPoint.pos.x;
			var _y:Number = startPoint.pos.y;
			var m:Number;
			var i:int;
			dx = endPoint.pos.x - startPoint.pos.x;
			dy = endPoint.pos.y - startPoint.pos.y;
			if (Math.abs(dx) >= Math.abs(dy))
			{
				m = Math.abs(dx);
			}
			else
			{
				m = Math.abs(dy);

			}
			points.push(new EuclideanVector(new Point(int(_x), int(_y))));
			i = 1;
			while (i <= m)
			{
				_x +=  dx / m;
				_y +=  dy / m;
				points.push(new EuclideanVector(new Point(int(_x), int(_y))));
				i++;
			}
			return points;
		}

		/*
		Checking for Collisions Using Rays
		
		Checking collision via rays is very simple. Since a ray consists of many
		vectors, we will check for collisions between each vector and a shape, until
		one is detected or the end of the ray is reached. In the following code,
		shapeToCheck will be a shape just like the ones we have been using in Steps
		13-16. Here's the code:
		
		You can use any point-inside-shape function you feel comfortable with, but pay
		attention to the limitations of the last one!
		*/
		public static function checkRayCollision(ray:Vector.<EuclideanVector>, shape:Vector.<EuclideanVector>):Boolean
		{
			var rayLength:int = ray.length;
			var i:int = 0;
			while (i < rayLength)
			{
				if (isPointInsideShape1(ray[i],shape))
				{
					return true;
				}
				i++;
			}
			return false;
		}
	}
}