package org.mousebomb.events
{
	import flash.events.Event;

	/**
	 * @author mousebomb mousebomb@gmail.com
	 */
	public class DConfigEvent extends Event
	{
		// 全部完成
		public static const CONFIG_LOADCOMPLETE : String = "CONFIG_LOADCOMPLETE";
		// 单个完成
		public static const CONFIG_ONECOMPLETE : String = "CONFIG_ONECOMPLETE";
		// 单个进度
		public static const CONFIG_PROGRESS : String = "CONFIG_PROGRESS";
		//
		public var data : *;

		public function DConfigEvent(type : String,data_ : * = null)
		{
			super(type);
			data = data_;
		}
	}
}
