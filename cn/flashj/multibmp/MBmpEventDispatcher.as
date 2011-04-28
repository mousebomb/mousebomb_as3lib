package cn.flashj.multibmp
{

	/**
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2011-1-5
	 */
	public class MBmpEventDispatcher extends MBmpObject implements IMBmpEventDispatcher
	{
		public function MBmpEventDispatcher()
		{
			super();
		}

		// 存储所有监听
		private var _listeners : Object = {};

		/**
		 * 加监听
		 * @param type 类型，由MBmpEvent指定的常量
		 */
		public function addListener(type : String, listener : Function) : void
		{
			// 若此name已经有监听，则push，若无则创建再push
			if (!_listeners[type])
			{
				_listeners[type] = [];
			}
			(_listeners[type] as Array).push(listener);
			//
		}

		public function dispatchEvent(event : MBmpEvent) : void
		{
			for each (var handler:Function in _listeners[event.type] as Array)
			{
				handler(event);
			}
		}

		public function removeListener(type : String, listener : Function) : void
		{
			// 若有此name的监听则移除其中handler一项
			if (_listeners[type])
			{
				var index : int = (_listeners[type] as Array).indexOf(listener);
				if (index != -1)
				{
					(_listeners[type] as Array).splice(index, 1);
				}
			}
		}

		public function hasListener(type : String) : Boolean
		{
			if (_listeners[type])
			{
				return Boolean((_listeners[type] as Array).length);
			}
			return false;
		}

		public function removeAllListener() : void
		{
			_listeners = [];
		}



		override public function dispose() : void
		{
			// 只是释放监听
			removeAllListener();
			super.dispose();

		}


	}
}
