package 
{
	////imports\\\\
	import flash.display.MovieClip;
	import flash.events.Event;

	//import RPG_Objects
	//import RPG_Events
	//Import RPG_Camera


	public class Engine extends MovieClip
	{
		
		//public vars
		public var gameState:String = "load"  
				
		//private vars
		private var gameLoop:MovieClip = new MovieClip;
		
		public function Engine()
		{
			//add global eventlistioners
			
			//add the game loop
			addChild(gameLoop);
			gameLoop.addEventListener(Event.ENTER_FRAME, gameTick);

		}
		
		
		//this function runs all the others this is the brain of the game
		private function gameTick(evt:Event):void
		{
			
		}


	}
}	