package cn.flashj.multibmp
{
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2011-1-5
	 */
	public class MBmpObject
	{
		// 父级内的相对x
		protected var _x : int;
		// 父级内的相对y
		protected var _y : int;
		// 父级内的相对深度(舞台上显示的深度)
		protected var _depth : int = -1 ;

		public var name : String;

		internal var _isDisplay : Boolean = true;


		// 父级
		protected var _parent : MBmpContainer;

		// 回调函数
		public var onYChange : Function;
		public var onXChange : Function;

		public function MBmpObject()
		{
		}


		public function get x() : int
		{
			return _x;
		}

		public function set x(v : int) : void
		{
			if (_x == v) return;
			var xAdd : int = v - _x;
			_x = v;
			if (onXChange != null) onXChange(v);
			validatePos();
		}

		public function get y() : int
		{
			return _y;
		}

		public function set y(v : int) : void
		{
			if (_y == v) return;
			var yAdd : int = v - _y;
			_y = v;
			if (onYChange != null) onYChange(v);
			validatePos();
		}

		public function get width() : Number
		{
			return .0;
		}

		public function get height() : Number
		{
			return .0;
		}

		public function get parent() : MBmpContainer
		{
			return _parent;
		}

		/**
		 * 立即按照数据更新显示位置
		 */
		public function validatePos() : void
		{
			// 修改实际显示坐标
			displayObject.x = _x ;
			displayObject.y = _y ;
		}

		internal function setParent(parent : MBmpContainer) : void
		{
			/*
			 * 设置父级引用，
			 * 同时要计算global坐标
			 */
			_parent = parent;
		}


		/**
		 * 释放资源
		 * 释放所有监听
		 */
		public function dispose() : void
		{
			// 有父级则自动移除.
			if (this.parent)
			{
				parent.removeChild(this);
			}
		}

		public function get displayObject() : DisplayObject
		{
			throw new Error("MBmpObject.displayObject是抽象方法，子类需要重写");
		}

		public function get isDisplay() : Boolean
		{
			// TODO 如果不在画面内 应该为false
			return _isDisplay;
		}

		public function get depth() : int
		{
			return _depth;
		}

		public function set depth(depth : int) : void
		{
			_depth = depth;
		}


	}
}
