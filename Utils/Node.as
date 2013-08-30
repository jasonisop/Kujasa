package scripts
{
	import flash.geom.Point;
	
	public final class Node extends Point
	{
		// public
		public var id:String = "";
		
		// private
		private var _neighbors:Array;
		
		public function Node(key:String="", x:int=0, y:int=0):void
		{
			super(x, y);
			id = key;
			_neighbors = new Array();
		}
		
		/*
		* Returns all current data as a new Node object.
		*/
		public function cloneNode():Node
		{
			var node:Node = new Node(id, x, y);
			node.parseNeighbors(_neighbors.join(","));
			return node;
		}
		
		/*
		* Parses a list of comma-seperated node id's into the array of neighbors.
		*/
		public function parseNeighbors(csv:String):void
		{
			for each (var j:String in csv.split(",")) addNeighbor(j);
		}
		
		/*
		* Adds a new neighbor Id.
		*/
		public function addNeighbor(id:String):void
		{
			if (!containsNeighbor(id) && id != "") _neighbors.push(id);
		}
		
		/*
		* Gets a neightbor Id by numeric index.
		*/
		public function getNeighbor(index:int):String
		{
			if (index >= 0 && index < _neighbors.length) return _neighbors[index];
			return null;
		}
		
		/*
		* Gets the number of neighbors assigned to this node.
		*/
		public function get numNeighbors():int
		{
			return _neighbors.length;
		}
		
		/*
		* Tests if the specified node id is among this node's neighbors.
		*/
		public function containsNeighbor(id:String):Boolean
		{
			return _neighbors.indexOf(id) > -1;
		}
		
		/*
		* Appends an additional namespace key onto all Node references. Avoids conflicts during Grid unions.
		*/
		public function expandNamespace(key:String):void
		{
			id += key;
			for each (var j:String in _neighbors) j += key;
		}
		
		/*
		* Trace object to string.
		*/
		public override function toString():String
		{
			return "[Node] id:"+ id +", x:" + x + ", y:" + y + ", neighbors:(" + _neighbors + ")";
		}
	}
}