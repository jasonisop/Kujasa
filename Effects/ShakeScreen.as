package Effects
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class ShakeScreen
	{
		// reference to Level
		private var lvl:Object;

		// level starting location
		private var lvlX:int;
		private var lvlY:int;
		private var dx:int;
		private var dy:int;

		// timer objects
		private var repeat:Timer;
		private var async:Timer;

		// this effect is done running
		public var completed:Boolean = false;

		public function ShakeScreen(level:Object, time:uint)
		{
			// level object
			lvl = level;

			// original x and y values for level
			lvlX = lvl.x;
			lvlY = lvl.y;
			dx = dy = 10;

			// shift level to starting positions
			lvl.moveStageX -=  dx;
			lvl.moveStageY -=  dy;
			lvl.updateLevel();

			// create repeater
			repeat = new Timer(40,0);
			repeat.start();
			repeat.addEventListener(TimerEvent.TIMER, timerHandler,false,0,true);

			// create timeout
			async = new Timer(time,1);
			async.start();
			async.addEventListener(TimerEvent.TIMER, completeHandler,false,0,true);
		}

		// begin screen shaking
		public function timerHandler(obj:Object=null):void
		{
			switch (repeat.currentCount)
			{
				case 0 :
					// shift the level around
					lvl.moveStageY +=  dy * 2;
					break;

				case 1 :
					// shift the level around
					lvl.moveStageX +=  dx * 2;
					break;

				case 2 :
					// shift the level around
					lvl.moveStageY -=  dy * 2;
					dy++;
					break;

				case 3 :
					// shift the level around
					lvl.moveStageX -=  dx * 2;
					dx++;
					break;

				case 4 :
					// reset repeat counter to zero
					repeat.reset();
					repeat.start();
					timerHandler();
					// do not break, don't need to run updateLevel twice!
					return;
			}
			lvl.updateLevel();
		}

		// stop shaking, return screen to original position
		private function completeHandler(obj:Object=null):void
		{
			// stop timers and remove event handlers
			async.stop();
			repeat.stop();
			repeat.removeEventListener(TimerEvent.TIMER, timerHandler);
			async.removeEventListener(TimerEvent.TIMER, completeHandler);

			// get rid of timers
			async = null;
			repeat = null;

			// calculate difference in x and y
			dy = Math.abs(lvlY - lvl.y);
			dx = Math.abs(lvlX - lvl.x);

			// return stage y to original position
			if (lvlY > lvl.y)
			{
				// shift to the right
				lvl.moveStageY +=  dy;
			}
			else
			{
				// shift to the right
				lvl.moveStageY -=  dy;
			}

			// return stage x to original position
			if (lvlX > lvl.x)
			{
				// shift to the right
				lvl.moveStageX +=  dx;
			}
			else
			{
				// shift to the right
				lvl.moveStageX -=  dx;
			}

			// update level one last time
			lvl.updateLevel();

			// done with level, remove and null out reference
			lvl = null;

			// we're done, indicate the effect has completed
			completed = true;
		}
	}
}