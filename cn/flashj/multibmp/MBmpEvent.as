package cn.flashj.multibmp
{
	/**
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2011-1-6
	 */
	public class MBmpEvent
	{
		public static const MOUSE_CLICK : String = "MOUSE_CLICK";
		public static const MOUSE_OVER : String = "MOUSE_OVER";
		public static const MOUSE_OUT : String = "MOUSE_OUT";
		private var _data : Object;
		private var _type : String;
		private var _target : MBmpObject;

		public function MBmpEvent(type : String, target : *, data : Object = null)
		{
			_type = type;
			_data = data;
			_target = target;
		}

		public function get data() : Object
		{
			return _data;
		}

		public function set data(data : Object) : void
		{
			_data = data;
		}

		public function get type() : String
		{
			return _type;
		}

		public function get target() : MBmpObject
		{
			return _target;
		}
	}
}
