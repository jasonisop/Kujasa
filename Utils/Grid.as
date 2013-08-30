package scripts
{
	import flash.geom.Point;
	
	public final class Grid extends Object
	{
		private var _nodes:Object;
		
		public function Grid():void
		{
			super();
			_nodes = new Object();
		}
		
		/*
		* Parses an XML structure into the grid object.
		*/
		public function parseXML($xml:XML):void
		{
			// loop through all <node> XML items
			for each (var $nodeXML in $xml.children())
			{
				// create a new Node object for each XML item
				var $node:Node = new Node($nodeXML.@id, $nodeXML.@x, $nodeXML.@y);
				$node.parseNeighbors($nodeXML.@join);
				
				// register node by Id within the grid
				_nodes[$node.id] = $node;
			}
		}
		
		/*
		* Gets a node object by ID name
		*/
		public function getNodeById($id:String):Node
		{
			if (_nodes[$id] != undefined) return _nodes[$id] as Node;
			return null;
		}
		
		/*
		* Finds the shortest path between two nodes.
		*/
		public function findPath($startId:String, $goalId:String):Path
		{
			// queue of paths to search
			var $stack:Array = new Array(new Path(0, 0, [$startId]));
			// best path to goal
			var $best:Path = new Path();
			// shortest distance to each node reached thus far
			var $reachedNodes:Object = new Object();
			// cycle counter (for debug and optimization)
			var $cyc:int = 0;
			
			// UNTIL ALL SEARCH PATHS HAVE BEEN ELIMINATED
		
			while ($stack.length > 0  )
			{
				// pull the first path out from the search stack
				var $searchPath:Path = $stack.shift() as Path;
				
				// pull the last node element from the path
				var $searchNode:Node = getNodeById($searchPath.lastElement);
				
				// EXTEND PATH ONE STEP TO ALL NEIGHBORS
				// creating X new paths
				for (var j:int=0; j < $searchNode.numNeighbors; j++)
				{
					// Branch: duplicate current search path as a new branch
					var $branch:Path = $searchPath.clone();
					
					// Pull and expand upon each of searchNode's neighbor Id's.
					var $expandNode:String = $searchNode.getNeighbor(j);
					
					// REJECT PATHS WITH LOOPS
					// if branch does NOT already contain next search node
					if (!$branch.containsNode($expandNode))
					{
						// get coordinates of previous, current, and goal nodes
						var $prevCoord:Node = getNodeById($branch.lastElement);
						var $currentCoord:Node = getNodeById($expandNode);
						var $goalCoord:Node = getNodeById($goalId);
						
						// extend branch after having referenced last end-point.
						$branch.addNode($expandNode);
						
						// UPDATE BRANCH LENGTH AND UNDERESTIMATE
						$branch.length += Point.distance($prevCoord, $currentCoord);
						$branch.bestCase = $branch.length + Point.distance($currentCoord, $goalCoord);
						
						// TRACK SHORTEST DISTANCE TO EACH NODE REACHED
						// attempt to pull a distance-to-node from the register of reached nodes.
						// if node has not yet been reached, register it with the current branch length.
						var $shortest:Number = $reachedNodes[$expandNode];
						if (isNaN($shortest)) $shortest = $branch.length;
						
						// TEST IF PATH IS WORTH KEEPING (keep if:)
						// - if branch is as short or shorter than the best distance to the current expansion node
						// - and if a best-path has not been found yet, OR if this branch's best case scenario is still shorter than the best path.
						if ($branch.length <= $shortest && (!$best.hasLength || $branch.bestCase < $best.length))
						{
							// log as best path to current search node
							$reachedNodes[$expandNode] = $branch.length;
							
							// If the expansion node is the goal, save branch as the parth to beat.
							// Otherwise, add the branch back into the search stack.
							if ($expandNode == $goalId) $best = $branch;
							else $stack.push($branch);
						}
					}
				}
				
				// PRIORITIZE SEARCH PATHS
				// sort paths by best-case scenario so that most likely paths are searched first.
				var $priority:Function = function($a:Path, $b:Path):int
				{
					if ($a.bestCase < $b.bestCase) return -1;
					else if ($a.bestCase > $b.bestCase) return 1;
					else return 0;
				}
				$stack.sort($priority);
				$cyc++;
			}
			
			return $best;
		}
	}
}