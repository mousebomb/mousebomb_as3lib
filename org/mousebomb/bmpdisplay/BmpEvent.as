
package org.mousebomb.bmpdisplay
{

	import flash.events.Event;


	/**
	 * 传递到flash的事件
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-11-11
	 */
	public class BmpEvent extends Event
	{

		// 渲染
		public static const RENDER : String = "RENDER";

		public function BmpEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
