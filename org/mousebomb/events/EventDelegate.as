package org.mousebomb.events 
{

	/**
	 * @author Mousebomb
	 * @usage	addEventListener(事件类型, EventDelegate.create(侦听器函数, 参数))
	 */
	public class EventDelegate 
	{
		public function EventDelegate() 
		{
		}

		public static function create(f : Function,... arg) : Function 
		{
			var isSame : Boolean = false;
			var _f : Function = function(e : *,..._arg):void
			{
				_arg = arg;
				if(!isSame) 
				{
					isSame = true;
					_arg.unshift(e);
				}
				f.apply(null, _arg);
			};
			return _f;
		}

		public static function toString() : String 
		{
			return "Event Delegate";
		}
	}
}