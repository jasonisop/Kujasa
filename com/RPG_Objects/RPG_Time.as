

package com.RPG_Objects 
{
	import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.Event;	
	
	public class RPG_Time 
	{
		//might change gameDats's to private 		
		public var gameDayNight:String 	= "Day" 	//if this is even needed Dawn, Morning, Day, Evening, Dusk, Night
		public var gameDateTimeSec:int	= 0;		
		public var gameDateTimeMin:int	= 0;		
		public var gameDateTimeHour:int	= 0;		 
		public var gameDateDay:int 		= 0;
		public var gameDateMonth:int 	= 0;
		public var gameDateYear:int 	= 0;		//Will need to change this to the starting year.
		
		public const gameDays:Vector.<String> = new <String>["Monday","Tuesday","Wendsday","Thursday","Friday","Saturday","Sunday"];
		
		private var gameDateTimer:Timer;
		private var gameDateTimeMulti:int = 1; 		//this is how many times faster gameTime is to real time, if there are timed quests we should also use a real time clock as well.
		
		
		public function RPG_Time() 
		{
			//set a timer to run every second this does not need to be that accurate.
			//im not useing the games main enterframe loop to keep that as fast as possible this is not something that needs ran every frame.
			gameDateTimer = new Timer(1000);
			gameDateTimer.addEventListener(TimerEvent.TIMER, calculateTime);
			gameDateTimer.start();
			
		}
		
		private function calculateTime(evt:TimerEvent):void
		{
			gameDateTimeSec += gameDateTimeMulti;
			
			if(gameDateTimeSec >= 60)
			{
				gameDateTimeSec = 0;
				gameDateTimeMin += 1;
			}
			if( gameDateTimeMin >= 60)
			{
				gameDateTimeMin = 0;
				gameDateTimeHour +=1;
			}
			if(gameDateTimeHour >= 24)
			{
				gameDateTimeHour = 0;
				gameDateDay += 1;
			}
			if(gameDateDay >= 28)
			{
				gameDateDay = 0;
				gameDateMonth += 1;
			}
			if(gameDateMonth >= 12)
			{
				gameDateMonth = 0;
				gameDateYear += 1;
			}
		}




	}
}
