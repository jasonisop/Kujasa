package Utils
{
	// timer and timer event
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	// map loader object so we can influence the game
	import MapLogic.MapLoader;

	public class AsyncFunction extends Timer
	{
		private var func:Function;
		private var args:Array;
		private var ml:MapLoader;
		public var completed:Boolean = false;

		public function AsyncFunction(mapLoader:MapLoader, PassedFunction:Function, Delay:uint, ... rest)
		{
			// delay (default 50 miliseconds) to get us out of the current update loop
			super(Delay,0);

			// keep track of passed info
			ml = mapLoader;
			func = PassedFunction;

			// should be a nested array passed because the
			// calling function uses ... rest
			args = rest[0];

			// add event listener
			this.addEventListener(TimerEvent.TIMER, RepeatHandler, false, 0, true);

			// start the timer
			this.start();
		}

		// handler for timer functions
		public function RepeatHandler(te:TimerEvent):void
		{
			// stop timer
			this.stop();

			// remove event listener
			this.removeEventListener(TimerEvent.TIMER, RepeatHandler);

			// call the function with given args in array as individual arguments
			func.apply(null, args);

			// call cleanup function
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