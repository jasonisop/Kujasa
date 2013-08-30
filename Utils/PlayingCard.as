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
package scripts{
	

	public class PlayingCard {

		//basic vars
		public var _CardType:String;
		public var _CardValue:Number;
		public var _CardName:String;
		public var _CardCost:String;
		public var _Rarity:String;
		public var _Set:String;
		
		//Play vars
		public var _InDeck:Boolean;
		public var _InHand:Boolean;
		public var _InPlay:Boolean;
		public var _CardTapped:Boolean;
		public var _CardAbilities:Array;
		public var _CardFlavorText:String;
		public var _useFlavorText:Boolean;
		public var _CardText:String;
	
		public function PlayingCard(param_CardType:String , param_CardValue:Number , param_CardName:String ) {
			// Assign passed values to properties when new PlayingCard object is created 
			_CardType = param_CardType;
			_CardValue = param_CardValue;
			_CardName = param_CardName;
			
		}
		
		public function SetCardText(TheText)
		{
			
			
		}
		
		
		/////////Get And Set/////////////
		public function get CardType():String {
			return _CardType;
		}
		public function get CardValue():Number {
			return _CardValue;
		}
		public function get CardName():String {
			return _CardName;
		}
		
		public function set CardType(param_CardType:String) {
			_CardType = param_CardType;
		}
		public function set CardValue(param_CardValue:Number) {
			_CardValue = param_CardValue;
		}
		public function set CardName(param_CardName:String) {
			_CardName = param_CardName;
		}


	}
}