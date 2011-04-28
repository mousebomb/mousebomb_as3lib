package org.mousebomb.events 
{

	/**
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-6-14
	 */
	public class PathFinderEvent extends MousebombEvent 
	{
		//生成地图完成
		public static const DRAW_MAP_COMPLETE : String = "DRAW_MAP_COMPLETE";

		public function PathFinderEvent(type : String, data : Object = null, bubbles : Boolean = false, cancelable : Boolean = false)
		{
			super(type, data, bubbles, cancelable);
		}
	}
}
