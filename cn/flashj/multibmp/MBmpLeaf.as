package cn.flashj.multibmp
{

	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	/**
	 * 叶级显示对象 即实际有显示内容的对象
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2011-1-10
	 */
	public class MBmpLeaf extends MBmpEventDispatcher
	{

		internal var _bornFromPool : Boolean = false;
		// 我的实际显示对象
		protected var _bmp : RefBitmap;
		protected var _bmd : BitmapData;
		// 当前的bounds
		protected var _bounds : Rectangle;


		public function MBmpLeaf()
		{
			super();
			_bmp = new RefBitmap();
			_bmp.mbRef = this;
		}

		override public function get displayObject() : DisplayObject
		{
			return _bmp;
		}

		/**
		 * 立即按照数据更新显示位置
		 */
		public override function validatePos() : void
		{
			// 修改实际显示坐标
			displayObject.x = _x + _bounds.x;
			displayObject.y = _y + _bounds.y;
		}

		public override function get width() : Number
		{
			return _bounds.width;
		}

		public override function get height() : Number
		{
			return _bounds.height;
		}

	}
}
