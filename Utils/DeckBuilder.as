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
	import scripts.CardDeck;
	import flash.net.SharedObject;

	//this will need changed to using the database.
	
	public class DeckBuilder {

		public var DeckMin;
		public var DeckMax;

		///shared Objects
		public var soSD:SharedObject;
		public var mso:SharedObject;
		public var soLD:SharedObject;
		public var soLL:SharedObject;
		public var DeckListArray:Array = new Array();

		//loads the deck from the sol file
		public function LoadDeck(DeckName) {
			soLD = SharedObject.getLocal(DeckName);
			return soLD.data.Deck;
		}
		//saves a deck to a sol file
		public function SaveDeck(DeckName,deck) {
			// Create the sol  file

			soSD = SharedObject.getLocal(DeckName);
			soSD.data.Deck = deck;
			soSD.flush();
			
			//append the loadlist sol file if it is not a dup
			soLL = SharedObject.getLocal("DeckList");
			var DeckListArray:Array = soLL.data.Decklist;
			var dup:Boolean = false;
			
			for(var i = 0 ; i<DeckListArray.length; i++)
			{
				if(DeckName == DeckListArray[i])
				{
					dup = true;
				}
								
			}
			if (dup==false)
			{
				SaveList(DeckName)
			}
			
			
		}
		//loads a list of saved decks
		public function LoadList() {

			soLL = SharedObject.getLocal("DeckList");
			return soLL.data.Decklist;

		}
		private function SaveList(DeckName)
		{	
			soLL = SharedObject.getLocal("DeckList");
			var DeckListArray:Array = soLL.data.Decklist;
			DeckListArray.push(DeckName);
			soLL.flush();
		}
		
		public function RemoveList(DeckName)
		{
			RemoveDeck(DeckName);
			soLL = SharedObject.getLocal("DeckList");
			var DeckListArray:Array = soLL.data.Decklist;
			
			for(var i = 0 ; i<= DeckListArray.length; i ++)
			{
				if (DeckListArray[i]== DeckName)
				{
			
					DeckListArray.splice(i,1);
				}
			}
						
			soLL.data.Decklist = DeckListArray;
			soLL.flush();
				
		}
		
		
		public function RemoveAllList()
		{
			
			soLL = SharedObject.getLocal("DeckList");
			var DeckListArray:Array = soLL.data.Decklist;
			for(var i =0 ; i< DeckListArray.length ; i++ )
			{
				RemoveDeck(DeckListArray[i]);
				
				trace("test "+DeckListArray[i]);
			}
			
			DeckListArray = new Array();
			soLL.data.Decklist = DeckListArray;
			soLL.flush();
		}
		
		public function CreateListSOL()
		{
			soLL = SharedObject.getLocal("DeckList");
			soLL.data.Decklist = DeckListArray;
			soLL.flush();
		}
		
		
		public function RemoveDeck(DeckName) {
			mso = SharedObject.getLocal(DeckName);
			//delete mso.data.Decklist;
			mso.clear();
		}
	}
}