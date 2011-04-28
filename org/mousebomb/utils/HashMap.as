package org.mousebomb.utils
{
	import flash.utils.Dictionary;		

	public class HashMap
	{
		private var map : Dictionary;

		public function HashMap()
		{
			map = new Dictionary(true);
		}

		public function put(key : *, value : *) : void
		{
			map[key] = value;
		}

		public function remove(key : *) : void
		{
			delete map[key];
		}

		public function containsKey(key : *) : Boolean
		{
			return map[key] != null;
		}

		public function getValue(key : *) : *
		{
			return map[key];
		}

		public function getValues() : Array
		{
			var values : Array = [];

			for (var key:*in map)
			{
				values.push(map[key]);
			}

			return values;
		}

		public function getKeys() : Array
		{
			var keys : Array = [];

			for (var key:*in map)
			{
				keys.push(key);
			}

			return keys;
		}
	}
}