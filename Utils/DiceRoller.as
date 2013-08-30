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
	
	import rl.dev.SWFConsole;
	import com.junkbyte.console.Cc;
	
	public class DiceRoller{
		

		private var RPG_DefaultDieType:Number; 
		
		public  function DiceRoller(DefaultDieType:Number = 6 )
		{ 	
			//this is used to set a default DieType to use. as most common is a 6 sided it is the default
			RPG_DefaultDieType = DefaultDieType
		}


		public function RollStat( NumOfStats:Number = 6, NumToRoll:Number = 4 , NumToDrop:Number = 1, DiceType:Number = 0):Array 
		{
			// Flash will not take a var to initalize a param so this is a work around
			if(DiceType == 0)
			{
				DiceType = RPG_DefaultDieType
			}
			
			var FinalDiceCount:Array = new Array();
			var WorkingDieCount:Array = new Array();
			
			//loops for the number of stats there are
			for (var i:int = 0 ; i < NumOfStats; i++)
			{
				
				for(var j:int = 0 ; j < NumToRoll ; j++)
				{
					WorkingDieCount[j] = Math.ceil(Math.random() * DiceType);
				}
				
				//sort array from largest to smallest
				WorkingDieCount.sort(2);
				var tempCount:Number = 0;
				var LoopCount:int =  WorkingDieCount.length - NumToDrop;
				
				for(var k:int = 0; k < LoopCount ; k++)
				{
					tempCount += WorkingDieCount[k];
				}
				FinalDiceCount[i] = tempCount;
			}
			return FinalDiceCount;
		}
		

		public  function Roll(NumDice:Number = 1, DiceType:Number = 0):Number 
		{	
			// Flash will not take a var to initalize a param so this is a work around
			if(DiceType == 0)
			{				
				
				DiceType = RPG_DefaultDieType
			}
			
			var DieCount:int = 0;
			
			for (var i:int = 0 ; i <NumDice; i++)
			{
				DieCount += Math.ceil(Math.random() * DiceType);
			}
			
			return DieCount;
		}

		public function ModNumber(StatNumber:Number):Number
		{
			var ModNum:int;
			ModNum = Math.floor(( StatNumber-10)/2 );
			return ModNum;
		}
		

	}
}