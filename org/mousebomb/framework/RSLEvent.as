package org.mousebomb.framework
{
	import flash.events.Event;

	/**
	 * 配合org.mousebomb.framework.RSLProxy
	 * @author Mousebomb ()
	 * @date 2010-2-22
	 */
	public class RSLEvent extends Event
	{
		// 开始加载 无参数
		public static const RSL_STARTLOAD : String = "RSL_STARTLOAD";
		// 单个加载完成 开始的下一个lib的名字
		public static const RSL_NEXT : String = "RSL_NEXT";
		// 全部加载完成 拟定无参数
		public static const RSL_LOADCOMPLETE : String = "RSL_LOADCOMPLETE";
		// 其中一个包加载完成 
		public static const RSL_ONECOMPLETE : String = "RSL_ONECOMPLETE";
		// 该类型事件 拟定传出进度比值
		public static const RSL_PROGRESS : String = "RSL_PROGRESS";
		// 全部进度 Number
		public static const RSL_TOTAL_PROGRESS : String = "RSL_TOTAL_PROGRESS";
		public var data : Object ;

		public function RSLEvent(type : String, data_ : Object = null, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			data_ = data;
			super(type, bubbles, cancelable);
		}
	}
}
