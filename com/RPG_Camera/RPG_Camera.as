package com.RPG_Camera
{
	//imports
	import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.Event;	
	
	
	
	//might be extending wrong thing
	public class RPG_Camera extends MovieClip
	{
		public var cameraLocation:Point = new Point(0,0); 				//this is where the camera is centered 
		public var cameraScale:Point = new Point(1,1);					
		public var cameraRotation:Number = 0;

		private var cameraRenderBounds:Rectangle = new Rectangle(); 
		private var cameraEffectCount:int = 0;
		private var cameraEffectTimer:Timer;
		private var cameraShakeStrength:int = 5;
		private var cameraState:String = "normal";
	
		
		
		public function RPG_Camera()
		{
			
		}
		
		//this renders the screen
		public function render()
		{
			//render map
			
			//render gui
			
		}
		
		
		//will rotatate and shrink the camera 
		public function effectMapChange()
		{
			
		}
		
		
		//shakes the screen default is a 5px for 1 second  shakin the gui
		public function effectShake( strength = 5, time = 1, target = "gui" )
		{			
			cameraShakeStrength = strength;
			cameraEffectTimer = new Timer(10, time * 100);
			cameraEffectTimer.addEventListener(TimerEvent.TIMER, doShake);
            cameraEffectTimer.addEventListener(TimerEvent.TIMER_COMPLETE, shakeComplete);
			cameraEffectTimer.start(); 
		}
		
		
		private function doShake(evt:TimerEvent):void
		{
			//get random direction and move every thing over by cameraShakeStrength
			
		}
		
		private function shakeComplete(evt:TimerEvent):void
		{		
			cameraEffectTimer.stop();
			cameraEffectTimer.removeEventListener(TimerEvent.TIMER, doShake);
            cameraEffectTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, shakeComplete);
			cameraEffectTimer = null;
			
		}
		
		
	}
}