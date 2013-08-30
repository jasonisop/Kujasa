package 
{
	import flash.display.MovieClip;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.text.TextField;
	
	/*
	Taken from the following URL:
	http://sierakowski.eu/list-of-tips/45--two-ways-of-preloading-in-actionscript-3.html
	*/

	public class InternalPreloader extends MovieClip
	{
		//create a text field to show the progress
		var progress_txt:TextField = new TextField();
		function InternalPreloader():void
		{
			//stop the timeline, will play when fully loaded
			stop();
			//position text field on the centre of the stage
			progress_txt.x = stage.stageWidth / 2;
			progress_txt.y = stage.stageHeight / 2;
			addChild(progress_txt);

			//add all the necessary listeners
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			loaderInfo.addEventListener(Event.COMPLETE, onComplete);
		}

		function onProgress(e:ProgressEvent):void
		{
			//update text field with the current progress
			progress_txt.text = String(Math.floor((e.bytesLoaded/e.bytesTotal)*100));
		}

		function onComplete(e:Event):void
		{
			//trace("Fully loaded, starting the movie.");
			//removing unnecessary listeners
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			loaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			//go to the second frame. 
			//You can also add nextFrame or just play() 
			//if you have more than one frame to show (full animation)
			gotoAndStop(2);
		}
	}
}