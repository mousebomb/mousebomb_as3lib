package org.mousebomb.events 
{

	/**
	 * 配合org.mousebomb.framework.RSLProxy
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-2-22
	 */
	public class RSLEvent extends MousebombEvent 
	{
		//开始加载 无参数
		public static const RSL_STARTLOAD : String = "RSL_STARTLOAD";
		//单个加载完成 开始的下一个lib的名字
		public static const RSL_NEXT : String = "RSL_NEXT";
		//全部加载完成 拟定无参数		public static const RSL_LOADCOMPLETE : String = "RSL_LOADCOMPLETE";
		//其中一个包加载完成 		public static const RSL_ONECOMPLETE : String = "RSL_ONECOMPLETE";
		//该类型事件 拟定传出进度比值		public static const RSL_PROGRESS : String = "RSL_PROGRESS";
		
		public function RSLEvent(type : String, data : Object = null, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}
