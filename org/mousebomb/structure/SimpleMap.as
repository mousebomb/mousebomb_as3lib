package org.mousebomb.structure
{
	/**
	 * @author Mousebomb ()
	 * @date 2010-8-27
	 */
	public class SimpleMap
	{
		private var _data : Object = {};

		public function SimpleMap()
		{
			//
		}

		public function reset() : void
		{
			_data = new Object();
		}

		public function containsKey(key : *) : Boolean
		{
			return _data[key] != null;
		}

		/**
		 * 塞进来
		 * @param id string或int
		 */
		public function put(id : *, value : *) : void
		{
			_data[id] = value;
		}

		/**
		 * 拿过去
		 */
		public function getValue(id : *) : *
		{
			return _data[id];
		}

		/**
		 * 删一个
		 */
		public function remove(id : *) : void
		{
			delete _data[id];
		}

		/**
		 * 获得所有，用来foreach
		 */
		public function getValues() : Object
		{
			return _data;
		}

		public function getValuesAsArray() : Array
		{
			var ending : Array = [];
			for each (var item : * in _data)
			{
				ending.push(item);
			}
			return ending;
		}

		/**
		 * 搜索列表中 字段的值与keyword局部匹配的项目。
		 */
		public function search(keyword:String , searchField :String) : Array
		{
			var ending:Array = [];
			for each(var item : * in _data)
			{
				var val :String = item[searchField];
				if(val.indexOf(keyword) != -1)
					ending.push( item );
			}
			return ending;
		}
		
		/**
		 * 索索列表，筛选出字段的不同值
		 */
		public function fetchDistinctFieldVals(field : String) : Array
		{
			var end : Array = [];
			for each (var li : * in _data)
			{
				var newVal : String = li[field];
				if (end.indexOf(newVal) == -1)
					end.push(newVal);
			}
			return end;
		}
	}
}
