package scripts
{
	public final class Path
	{
		// public
		public var length:int = -1;
		public var bestCase:int = -1;
		public var nodes:Array;
		
		// private
		private var _path:Array;
		
		public function Path($length:Number=-1, $bestCase:Number=-1, $path:Array=null):void
		{
			length = $length;
			bestCase = $bestCase;
			_path = ($path != null) ? $path : new Array();
		}
		
		public function destroy():void
		{
			_path = null;
			nodes = null;
		}
		
		/*
		* Returns all current data as a new Path object.
		*/
		public function clone():Path
		{
			return new Path(length, bestCase, _path.slice());
		}
		
		/*
		* Tests if path has been initialized with actual pathing data.
		*/
		public function get hasLength():Boolean
		{
			return length + bestCase >= 0;
		}
		
		/*
		* Returns the last node id contained within the path.
		*/
		public function get lastElement():String
		{
			return _path.slice(-1)[0];
		}
		
		/*
		* Tests if this path contains a node Id.
		*/
		public function containsNode($id:String):Boolean
		{
			return _path.indexOf($id) > -1;
		}
		
		/*
		* Adds a node to the path if not already present.
		*/
		public function addNode($id:String):void
		{
			if (!containsNode($id)) _path.push($id);
		}
		
		/*
		* Trace object to string.
		was :String
		*/
		public function toString():String
		{
			// original
			// return "[Path] length:"+ length +", nodes:("+ _path +")";
			return String( _path) ;
		}
	}
}