package org.mousebomb.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	/**
	 * 提出来独立的stage2d用到的功能 ,全部遍历播放/遍历停止等
	 * @author mousebomb mousebomb@gmail.com
	 * created: 2012-10-24 
	 * last modified: 2012-10-24
	 */
	public class Stage2dUtils
	{
		/**
		 * 递归执行play()
		 * @param	target	显示对象
		 */
		public static function allplay(target : DisplayObject) : void
		{
			// 如果是MC就执行
			if (target is MovieClip) (target as MovieClip).play();
			// 如果是容器就找子内容
			if (target is DisplayObjectContainer)
			{
				for (var i : int = 0;i < (target as DisplayObjectContainer).numChildren;i++ )
				{
					var child : DisplayObject = (target as DisplayObjectContainer).getChildAt(i);
					allplay(child);
				}
			}
		}

		/**
		 * 递归执行stop()
		 * @param	target	显示对象
		 */
		public static function allstop(target : DisplayObject) : void
		{
			// 如果是MC就执行
			if (target is MovieClip) (target as MovieClip).stop();
			// 如果是容器就找子内容
			if (target is DisplayObjectContainer)
			{
				for (var i : int = 0;i < (target as DisplayObjectContainer).numChildren;i++ )
				{
					var child : DisplayObject = (target as DisplayObjectContainer).getChildAt(i);
					allstop(child);
				}
			}
		}

		/**
		 * 设置显示对象颜色
		 * 2009-09-08 18:27 BRETON
		 */
		public static function setEleColor(ele : DisplayObject, color : uint) : void
		{
			var ct : ColorTransform = ele.transform.colorTransform;
			ct.color = color;
			ele.transform.colorTransform = ct;
		}
	}
}
