/*
Copyright (c) 2012 Jason Morse

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the 
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to 
permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the 
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

package scripts
{
	import flash.events.Event;
	
	public class CustomEvent extends Event{
		
		//player events
		public static const PLAYER_ATTACKED:String = "cEvent_PlayerAttacked";
		public static const PLAYER_DYING:String = "cEvent_PlayerDying";
		
/*		
		public static const DEATH:String = "cEvent_Death";
		public static const DEAD:String = "cEvent_Dead";
		public static const CONVO:String = "cEvent_Convo";
		public static const SplashLoaded:String = "cSplashLoaded";
		public static const MAPSLISTLOADED:String = "cEvent_MapListLoaded";
		public static const GAMELISTLOADED:String = "cEvent_GameListLoaded";
		public static const GameModeChanged:String = "cEvent_GameModeChanged";
		public static const PLAYERLISTLOADED:String = "cEvent_PlayerListLoaded";
		public static const RACELOADED:String = "cEvent_RaceLoaded";
		public static const ITEM_REUSE:String = "cEvent_Item_Reuse";
		public static const PLAYER_LOADED:String = "cEvent_Player_Loaded";
		public static const JSON_LOADED:String = "cEvent_JSON_Loaded";
		
		
		//events for drag and drop
		public static const DD_DROP:String = "cEvent_DD_Drop";*/
		
		public var data:*
		
		public function CustomEvent(customEventString:String,data = null){
			this.data = data;
			super(customEventString, true, false);
			
		}
	}
}