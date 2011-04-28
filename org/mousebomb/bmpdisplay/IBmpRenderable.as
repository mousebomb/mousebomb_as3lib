package org.mousebomb.bmpdisplay 
{
	import flash.display.BitmapData;		

	/**
	 * @author Mousebomb
	 * @date 2009-6-16
	 */
	public interface IBmpRenderable 
	{
		/**
		 * 获取当前快照,包括子层级
		 */
		function getPixelShot() : BitmapData
		
		/**
		 * 获得本层级的内容
		 */
		function get bitmapData() : BitmapData
	}
}
