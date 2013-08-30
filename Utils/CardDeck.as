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
	
	import scripts.PlayingCard;

	public class CardDeck {

		private var Contents:Array;
		private var RandomNum:Number;
		private var CardPicked;
		
		public function CardDeck() {
			 //Contents = new Array();
		}
		
		public function set Cont(_parmConts)
		{
			this.Contents = _parmConts;
		}
		
		public function get Cont()
		{
			return this.Contents;
		}
		
		
		public function AddCard(card):void 
		{
			Contents.push(card);
		}

		////////////////////////
		//start shuffle
		///////////////////////
		public function Shuffle() {

			var tempArray:Array = new Array();
			var myCount = Contents.length;

			for (var i = 0; i < myCount; i++) {
				var rand  = Math.floor(Math.random()*Contents.length );
				var Mytest = Contents[rand];
				Contents.splice(rand, 1);
				tempArray.push(Mytest);
			}
			for (var j = 0; j < myCount; j++) {
				Contents[j] = tempArray[j];
			}
		}
		/////////////////////////////////////////
		//End shuffle
		/////////////////////////////////////////

		
		public function DrawCard() {

			CardPicked = Contents.shift();
			//RemoveTopCard();
			return CardPicked;
		}
		public function RemoveTopCard() {
			Contents.shift();

		}
		public function DeckCount() {

			return Contents.length;
		}
		
		public function ShowTopCard()
		{
			return Contents[0];
		}
			
		public function ShowCards(Num)
		{
			var TempArray:Array = new Array(Num)
			for (var i = 0 ; i< Num;i++){
				TempArray[i] = Contents[i];
			}
			return TempArray;
		}
		
		public function RemoveCard(CardName)
		{
			var myCount = Contents.length;
			var RemovedOne = false;

			for (var i = 0; i < myCount; i++) 
			{
				if(RemovedOne == false)
				{
					var Mytest = Contents[i];
					if(Mytest.CardName == CardName)
					{
						Contents.splice(i,1);
						RemovedOne = true;
					}
				}
			}
		}
	}
}
