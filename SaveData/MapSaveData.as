package SaveData
{
	public class MapSaveData
	{
		public var Map_Reykjavik:Object = new Object();
		public var Map_Reykjavik_House:Object = new Object();
		public var Map_Reykjavik_Basement:Object = new Object();

		public function MapSaveData()
		{
			Map_Reykjavik['stop_whine'] = false;
			Map_Reykjavik['princess_chat'] = false;
			Map_Reykjavik['grass_triggered'] = false;
		}
	}
}