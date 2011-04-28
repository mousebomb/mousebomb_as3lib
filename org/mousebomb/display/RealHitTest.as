package org.mousebomb.display 
{
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * Flash自带的HitTestObject有问题，这个类是真正的HitTest
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-3-14
	 */
	public class RealHitTest 
	{
		private static var bmp : Bitmap = new Bitmap();

		/**
		 * 此方法的思路由ryan-liu提出
		 * @return 是否重叠
		 * @param src 要比较的对象
		 * @param target 与之比较的对象
		 * src和target的容器必须是同一对象，或者原点坐标对齐
		 */
		public static function hitTestObj(src : DisplayObject,target : DisplayObject) : Boolean
		{
			//获取要比较的对象的区域以偏移位图
			var srcBound : Rectangle = src.getBounds(src.parent);
			var bmd : BitmapData = new BitmapData(srcBound.width, srcBound.height, false, 0);
			//bmp.bitmapData = bmd;
			var mtx1 : Matrix = new Matrix();
			var mtx2 : Matrix = new Matrix();
			mtx1.rotate(src.rotation * Math.PI / 180);
			mtx1.tx = src.x - srcBound.x;
			mtx1.ty = src.y - srcBound.y;
			mtx2.rotate(target.rotation * Math.PI / 180);
			mtx2.tx = target.x - srcBound.x;
			mtx2.ty = target.y - srcBound.y;
			bmd.fillRect(bmd.rect, 0);
			bmd.draw(src, mtx1, new ColorTransform(1, 1, 1, 1, -255, 255, 255, 255));
			bmd.draw(target, mtx2, new ColorTransform(1, 1, 1, 1, 255, -255, -255, 255), BlendMode.DIFFERENCE);
			var rect : Rectangle = bmd.getColorBoundsRect(0xffffff, 0xffffff);
			//碰撞检测结束
			//Rectangle四个属性为0则没搜索到
			return (rect.x != 0 || rect.y != 0 || rect.width != 0 || rect.height != 0);
		}

		public static function debug(s : DisplayObjectContainer) : void
		{
			s.addChild(bmp);
			bmp.x = 500;			bmp.y = 300;
		}
	}
}
