package 
{
	// graphics
	import flash.display.Sprite;
	import flash.display.DisplayObject;

	// events
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;

	public class Listener extends Sprite
	{
		protected var level:Level;
		public var keys:Vector.<uint > ;
		public var moveDir:Vector.<Boolean > ;
		public var interactObj:Object;

		// constructor
		public function Listener()
		{
			// check for when we're added to the stage
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}

		// the game has loaded, load the game content
		protected function init(e:Event):void
		{
			// remove event listener
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// remove preloader from the display list
			stage.removeChildAt(0);
			
			// Listener is now the only child of stage, index is 0.
			//trace(stage.getChildAt(0));
			
			// setup keys pressed vector
			keys = new Vector.<uint>();

			// setup movement keys array
			moveDir = new Vector.<Boolean > (4);
			for (var i=0; i!= 4; i++)
			{
				moveDir[i] = false;
			}

			// object used to pass interactions back and forth
			interactObj = new Object();
			interactObj['menu'] = 0;
			interactObj['poke'] = false;
			interactObj['wait'] = false;
			interactObj['action'] = 'dialog';
			interactObj['pressAnyKey'] = false;
			interactObj['afterDialog'] = false;

			// since this is a display object let's cache it
			this.cacheAsBitmap = true;

			// assign normal event listeners, must come before level is created
			addListeners();

			// new level
			level = new Level(keys,moveDir,interactObj);

			// add level to stage
			stage.addChild(level);

			// handle updates every frame
			stage.addEventListener(Event.ENTER_FRAME,EveryFrame, false, 0, true);
		}

		// key-down listener function
		public function KeyDown(k:KeyboardEvent):void
		{
			// is it already in the keys array
			var index = keys.indexOf(k.keyCode);

			// if it's not in the keys array
			if (index == -1)
			{
				// are we looking for a key press?
				if (interactObj.pressAnyKey)
				{
					// key pressed, indicate it
					interactObj.pressAnyKey = false;

					// check to see what action was performed
					switch (interactObj.action)
					{
						default :
						case 'dialog' :
							// indicate it's after a dialog
							interactObj.afterDialog = true;
							break;
					}

					// don't do anything else
					return;
				}
				else if (interactObj.wait)
				{
					// do nothing except wait
					return;
				}

				// add it
				keys.push(k.keyCode);

				// update movement key array
				MoveKeys(k.keyCode, true);

				// update poke key info
				PokeKey(k.keyCode, true);
			}
		}

		// key-up listener function
		public function KeyUp(k:KeyboardEvent):void
		{
			// is it already in the keys array
			var index = keys.indexOf(k.keyCode);

			// if it's already in the keys array
			if ((index != -1))
			{
				// remove it
				keys.splice(index,1);

				// update movement array
				MoveKeys(k.keyCode,false);

				// cycle through active keys, sanity check
				for (var i = keys.length-1; i != -1; i--)
				{
					// check if movement keys are pressed
					MoveKeys(keys[i], true);
				}
			}
		}

		// mouse down handler
		function MouseDownEvent(me:MouseEvent):void
		{
			// make sure we didn't click something else with an event handler first
			//if (me.localX != me.stageX || me.localY != me.stageY)
			//{
			//var arr = stage.getObjectsUnderPoint(new Point(me.stageX,me.stageY));
			// cycle through the objects and see if they have a click event?
			//trace(arr);
			//}

			// are we looking for a key press?
			if (interactObj.pressAnyKey)
			{
				// key pressed, indicate it
				interactObj.pressAnyKey = false;

				// check to see what action was performed
				switch (interactObj.action)
				{
					default :
					case 'dialog' :
						// dialog has played
						interactObj.afterDialog = true;
						break;
				}


				// don't do anything else
				return;
			}
			else if (interactObj.wait)
			{
				// do nothing except wait
				return;
			}

			// tell level the mouse is down
			level.mouseIsDown = true;

			// mouse is down, follow that mouse!
			level.hero.gotoPoint = true;
		}

		// mouse is up, stop following it!
		function MouseUpEvent(me:MouseEvent):void
		{
			// tell level the mouse is up
			level.mouseIsDown = false;
		}

		// determine if movement keys are pressed
		public function MoveKeys(key:int,action:Boolean):void
		{
			/*
			Up = keys.indexOf(87)
			Down = keys.indexOf(83)
			Left = keys.indexOf(65)
			Right = keys.indexOf(68)
			
			W = keys.indexOf(38)
			A = keys.indexOf(40)
			S = keys.indexOf(37)
			D = keys.indexOf(39)
			*/

			switch (key)
			{
				case 87 :
				case 38 :
					moveDir[0] = action;
					break;

				case 83 :
				case 40 :
					moveDir[1] = action;
					break;

				case 65 :
				case 37 :
					moveDir[2] = action;
					break;

				case 68 :
				case 39 :
					moveDir[3] = action;
					break;
					//default :
					//trace(key);
					//break;
			}
		}

		public function PokeKey(key:int,action:Boolean):void
		{
			/*
			Space key = keys.indexOf(32)
			*/

			switch (key)
			{
				case 32 :
					interactObj.poke = action;
					break;
			}
		}

		// handle updates every frame
		public function EveryFrame(e:Event):void
		{
			// update the level
			level.update();
		}

		public function removeListeners()
		{
			// event listener for when user clicks the background graphic
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, MouseDownEvent);

			// event listener for when user clicks the background graphic
			stage.removeEventListener(MouseEvent.MOUSE_UP, MouseUpEvent);

			// keyboard listener, key down
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, KeyDown);

			// keyboard listener, key up
			stage.removeEventListener(KeyboardEvent.KEY_UP, KeyUp);
		}

		public function addListeners()
		{
			// event listener for when user clicks the background graphic;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, MouseDownEvent, false, 0, true);

			// event listener for when user clicks the background graphic;
			stage.addEventListener(MouseEvent.MOUSE_UP, MouseUpEvent, false, 0, true);

			// keyboard listener, key down
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDown, false, 0, true);

			// keyboard listener, key up
			stage.addEventListener(KeyboardEvent.KEY_UP, KeyUp, false, 0, true);
		}
	}
}