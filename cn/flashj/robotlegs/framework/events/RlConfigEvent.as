package cn.flashj.robotlegs.framework.events
{
	import flash.events.Event;

	/**
	 * @author mousebomb mousebomb@gmail.com
	 */
	public class RlConfigEvent extends Event
	{
		public function RlConfigEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		// 单个进度
		public static const CONFIG_PROGRESS : String = "CONFIG_PROGRESS";
		// 单个完毕		public static const CONFIG_ONECOMPLETE : String = "CONFIG_ONECOMPLETE";
		// 全部完毕
		public static const CONFIG_LOADCOMPLETE : String = "CONFIG_LOADCOMPLETE";
		
		public var bytesTotal : uint;
		public var bytesLoaded : uint;
	}
}
