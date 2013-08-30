package ObjectLogic
{
	import flash.geom.Rectangle;

	/*
	Useful for non-display areas that should trigger some function to fire when the
	player enters them such as a trap, lead-in to a cut-scene, or other point of
	interest that should fire a function. Can be toggled on and off with the Active
	public variable.
	*/

	public class TriggerObject
	{
		// reference to map loader
		private var ml:Object;

		// rectangle info
		public var name:String;
		private var rect:Rectangle;
		private var isRectangle:Boolean;

		// trigger info
		public var Active:Boolean;
		public var TriggerAction:Function;

		// holds calculations so they don't get created every time
		private var dx:int;
		private var dy:int;

		public function TriggerObject(mapLoader:Object, rectangle:Rectangle, Name:String="trigger", IsRectangle:Boolean=true)
		{
			rect = rectangle;
			name = Name;
			isRectangle = IsRectangle;
			ml = mapLoader;
			Active = true;
		}

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

		// garbage collection function
		public function Trash()
		{
			ml = null;
			name = null;
			rect = null;
			isRectangle = false;
			Active = false;
			TriggerAction = null;
			dx = 0;
			dy = 0;
		}
	}
}