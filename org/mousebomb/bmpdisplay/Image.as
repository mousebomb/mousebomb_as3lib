package org.mousebomb.bmpdisplay 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 静态图片
	 * @author Mousebomb
	 * @date 2009-6-16
	 */
	public class Image extends BmdContainer implements IBmpRenderable 
	{

		/**
		 * 如果在顶级、且单纯做容器则必须设置宽高,否则内容区域显示不了
		 * @param width 初始宽度
		 * @param height 初始高度
		 */
		public function Image(width : int = 1,height : int = 1) : void
		{
			_bmd = new BitmapData(width, height, true, 0x000000ff);
			_bounds = _bmd.rect;
		}

		/**
		 * 由资源池初始化
		 * 2010.06.21
		 */
		bmd_pool function born(data : Object) : void
		{
			//保存图像
			this._bmd = data.bmd;
			_bounds = data.bounds;
			validateRectWhenResize();
			//记下是从池创建的
			bmd_pool::bornFromPool = true;
		}

		public function sprite2Image(src : Sprite) : void
		{
			var data : Object = BmdResourcePool.getInstance().generateSpriteBmd(src);
			_bmd = data["bmd"];
			_bounds = data["bounds"];
			validateRectWhenResize();
		}

		public function bmp2Image(src : Bitmap) : void
		{
			_bmd = src.bitmapData;
			validateRectWhenResize();
		}
		
//		override public function get rect() : Rectangle
//		{
//			return _bmd.rect;
//		}

//		override public function get bitmapData() : BitmapData
//		{
//			if(alpha == 1)
//			{
//				return _bmd;
//			}
//			else
//			{
//				var ending : BitmapData = _bmd.clone();
//				var colorTransform : ColorTransform = new ColorTransform();
//				colorTransform.alphaMultiplier = alpha;
//				ending.colorTransform(new Rectangle(0, 0, _bmd.width, _bmd.height), colorTransform);
//				return ending;
//			}
//		}

		override public function dispose() : void
		{
			use namespace bmd_pool;
			if(bornFromPool)
			{
				//通知池子我完结了，让池子负责资源清除或者不清除
				BmdResourcePool.getInstance().clearResource(resourceName);
			}
			else
			{
				//位图独享，自己清除
				_bmd.dispose();
			}
			//
			super.dispose();
		}

		/**
		 * 点碰撞测试
		 * 以顶级显示对象坐标系为参照
		 * 此方法是根据最近一次渲染的结果来判定
		 */
		override public function hitTestPoint(x : Number,y : Number) : Boolean
		{
			//old ver,调用localToGlobal从这一级递归查找到顶级，求到全局坐标
			//var ending : Boolean = _bmd.hitTest(localToGlobal(), 0x00, new Point(x, y));
			//new ver ,使用最近一次渲染时产生的全局坐标			var ending : Boolean = _bmd.hitTest(renderRect.topLeft, 0x00, new Point(x, y));
			return ending;
		}
	}
}
