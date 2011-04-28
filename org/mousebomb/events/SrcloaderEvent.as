package org.mousebomb.events 
{
	import org.mousebomb.events.MousebombEvent;
	
	/**
	 * @author Mousebomb
	 * @date 2009-7-22
	 */
	public class SrcloaderEvent extends MousebombEvent 
	{
		public static const COMPLETE:String = "完成";
		
		public static const SWF_LOADED:String = "swf加载完毕";		public static const TEXT_LOADED:String = "文本加载完毕";		public static const BINARY_LOADED:String = "二进制流加载完毕";		public static const CLASS_LOADED:String = "外部CLASS库加载完毕";
				public static const SRCLOAD_PROGRESS:String = "进度";		public static const IO_ERR:String = "加载过程中io错误";
		
		public function SrcloaderEvent(type : String, data : Object, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}
