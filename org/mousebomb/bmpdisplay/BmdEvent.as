package org.mousebomb.bmpdisplay 
{

	/**
	 * 内部事件机制
	 * 与flash的事件无关
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-6-23
	 */
	public class BmdEvent  
	{
		public static const MOUSE_CLICK : String = "MOUSE_CLICK";
		public static const MOUSE_OVER : String = "MOUSE_OVER";		public static const MOUSE_OUT : String = "MOUSE_OUT";

		private var _data : Object;
		private var _type : String;
		private var _target : BmdObject;
		/**
		 * 注意，这里的冒泡只会在注册处理的对象上冒。因为性能需要，所以检索的对象只有注册了事件的。
		 * 如果要改成和flash的冒泡一样，那么就要在捕获阶段对所有interactive的对象检索
		 * 关键问题是，我之前一个方案的绘图效率很低，所以我改成了每个容器只管自己的Bmd，在计算区域的时候不管child的bmd
		 * 现在我是在加监听的时候和内容位置变动的时候维护一个要检查鼠标事件的索引，等stage的鼠标事件发出时去查找对应注册过的对象
		 */
		private var _bubbles : Boolean = false;
		private var _currentTarget : BmdObject;

		public function BmdEvent(type : String,target : *, data : Object = null)
		{
			_type = type;
			_data = data;
			_target = target;
			_currentTarget = target;
		}

		public function get data() : Object
		{
			return _data;
		}

		public function get type() : String
		{
			return _type;
		}

		public function get target() : BmdObject
		{
			return _target;
		}

		public function get bubbles() : Boolean
		{
			return _bubbles;
		}

		public function set bubbles(bubbles : Boolean) : void
		{
			_bubbles = bubbles;
		}

		public function get currentTarget() : BmdObject
		{
			return _currentTarget;
		}

		public function set currentTarget(currentTarget : *) : void
		{
			_currentTarget = currentTarget;
		}
	}
}
