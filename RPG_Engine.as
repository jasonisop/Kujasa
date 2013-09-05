package 
{
	////imports\\\\
	import flash.display.MovieClip;
	import flash.events.Event;

	//import RPG_Objects 
	import com.Event.CustomEvent;
	//Import RPG_Camera


	public class Engine extends MovieClip
	{
		
		//public vars
		public var gameState:String = "init"  
		public var gameDayNight:String = "Day" //if this is even needed Dawn, Morning, Day, Evening, Dusk, Night
		
		
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
			switch (gameState)
			{
				//add all needed eventlistioners and game objets once complete set next state
				case "init":
				break;
				
				//when changing maps
				case "loading":
				break
				
				//normal game mode
				case "running":
				break;
				
				//game is paused no actions take place besides eventlistoner to un-pause
				case "pause":
				break;
		
				//game is on the main menu only things runnning should be RPG_Camera for GUI's
				case "menu":
				break;
			
				//if needed a state to run in game style cutscenes - takes away user input. 
				case "cutscene":
				break;
			
			}
			
		}


	}
}	