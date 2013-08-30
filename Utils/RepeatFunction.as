package Utils
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	// map loader object so we can influence the game
	import MapLogic.MapLoader;

	public class RepeatFunction extends Timer
	{
		private var func:Function;
		private var args:Array;
		private var ml:MapLoader;
		public var completed:Boolean;

		public function RepeatFunction(mapLoader:MapLoader, PassedFunction:Function, Interval:Number, RepeatCount:uint, ... rest)
		{
			// make sure Interval is a valid number to use in a timer
			Interval = Math.abs(Interval);

			// call passed function every Interval milliseconds
			super(Interval, RepeatCount);

			// keep track of passed info
			ml = mapLoader;
			func = PassedFunction;
			
			// determine if this timer is done or not
			completed = false;

			// should be a nested array passed because the
			// calling function uses ... rest
			args = rest[0];

			// add event listener
			this.addEventListener(TimerEvent.TIMER, RepeatHandler, false, 0, true);

			// check if there's a limit
			if (RepeatCount)
			{
				this.addEventListener(TimerEvent.TIMER_COMPLETE, CompleteHandler, false, 0, true);
			}

			// start the timer
			this.start();
		}

		/*
		see this URL for explanation of the apply() method
		http://stackoverflow.com/questions/636853/filling-in-rest-parameters-with-an-array
		*/

		// handler for timer functions
		private function RepeatHandler(te:TimerEvent):void
		{
			// call the function with given args in array as individual arguments
			func.apply(null, args);
		}

		// call when RepeatCount is not 0
		private function CompleteHandler(te:TimerEvent):void
		{
			this.removeEventListener(TimerEvent.TIMER_COMPLETE, CompleteHandler);
			Trash();
		}

		// handle garbage collection for this object
		public function Trash():void
		{
			// stop timer
			this.stop();

			// remove event listener
			this.removeEventListener(TimerEvent.TIMER, RepeatHandler);

			// remove self from timer list
			ml.timers.splice(ml.timers.indexOf(this), 1);

			// function has run, reference is gone, time to self-destruct
			func = null;
			args = null;
			ml = null;
			
			// timer is done running
			completed = true;
		}
	}
}