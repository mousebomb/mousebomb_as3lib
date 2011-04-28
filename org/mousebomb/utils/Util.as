package org.mousebomb.utils 
{
	import org.mousebomb.mousebomb;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.utils.ByteArray;

	/**
	 * 工具类
	 * @author Mousebomb
	 * @since 09.2.13
	 */
	public class Util 
	{
		use namespace mousebomb;
		
		public function Util() 
		{
		}

		/**
		 * 递归执行play()
		 * @param	target	显示对象
		 */
		public static function allplay(target : DisplayObject) : void
		{
			//如果是MC就执行
			if (target is MovieClip) (target as MovieClip).play();
			//如果是容器就找子内容
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
			//如果是MC就执行
			if (target is MovieClip) (target as MovieClip).stop();
			//如果是容器就找子内容
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
		public static function setEleColor(ele : DisplayObject,color : uint) : void
		{
			var ct : ColorTransform = ele.transform.colorTransform;
			ct.color = color;
			ele.transform.colorTransform = ct;
		}

		/**
		 * 数组乱序排序
		 * 
		 */
		public static function arrayRandomSort(arrayRef : Array) : void
		{
			arrayRef.sort(randomSort);
		}
		
		/**
		 * 服务于数组乱序排序
		 */
		mousebomb static function randomSort(...args):int
		{
			return Math.random() > .5 ? 1:-1;
		}

		/**
		 * @since 2009 10 30
		 * @author Mousebomb
		 * 深度复制
		 */
		public static function deepCopy(data : *) : *
		{
			var ba : ByteArray = new ByteArray();
			ba.writeObject(data);
			ba.position = 0;
			return ba.readObject();
		}
	}
}