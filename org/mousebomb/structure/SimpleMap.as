package org.mousebomb.structure
{

	/**
	 * @author Mousebomb ()
	 * @date 2010-8-27
	 */
	public class SimpleMap
	{
		private var _data:Object = {};

		public function SimpleMap()
		{
			//
		}

		public function reset():void
		{
			_data = new Object();
		}

		public function containsKey( key:* ):Boolean
		{
			return _data[key] != null;
		}

		/**
		 * 塞进来
		 * @param id string或int
		 */
		public function put( id:*, value:* ):void
		{
			_data[id] = value;
		}

		/**
		 * 拿过去
		 */
		public function getValue( id:* ):*
		{
			return _data[id];
		}

		/**
		 * 删一个
		 */
		public function remove( id:* ):void
		{
			delete _data[id];
		}

		/**
		 * 获得所有，用来foreach
		 */
		public function getValues():Object
		{
			return _data;
		}
	}
}
