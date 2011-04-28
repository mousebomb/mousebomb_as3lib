package org.mousebomb.utils 
{
	import org.mousebomb.Math.MousebombMath;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-8-25
	 */
	public class Circle extends Object 
	{

		//圆心
		private var _cPoint : Point = new Point();
		//半径
		private var _r : Number; 
		//面积
		private var _area : Number;
		//MBR
		private var _bounds : Rectangle = new Rectangle();

		
		
		/**
		 * 创建一个圆形
		 */
		public function Circle(x : Number = .0,y : Number = .0,r : Number = .0)
		{
			_cPoint.x = x ; 
			_cPoint.y = y ; 
			_r = r;
			validateCircle();
		}
		//
		public function toString() : String {
			return "org.mousebomb.utils.Circle [x=" + x + ",y=" + y +",r=" + r + "]";
		}

		/**
		 * 重新计算圆形
		 */
		private function validateCircle() : void
		{
			//面积
			_area = (Math.PI * _r ) << 1;
			//MBR
			_bounds.x = _cPoint.x - _r;
			_bounds. y = _cPoint.y - r;
			_bounds.width = r << 1;
			_bounds.height = r << 1;
		}

		/**
		 * 是否包括点
		 * @param p 坐标系相同的点
		 * @return 是否包含
		 */
		public function containsPoint(p : Point) : Boolean
		{
			/*
			 * 圆心与p的坐标是否小于半径
			 */
			return MousebombMath.distanceOf2Point(_cPoint, p) < _r;
		}

		/**
		 * 是否包含矩形
		 * 完全包含哦
		 */
		public function containsRect(rect : Rectangle) : Boolean
		{
			throw new Error("Circle.containsRect TODO");
		} 

		/**
		 * 是否相交
		 */
		public function intersects(toIntersect : Rectangle) : Boolean
		{
			throw new Error("Circle.intersects TODO");
		}

		/**
		 * 圆心x
		 */
		public function get x() : Number
		{
			return _cPoint.x;
		}

		public function set x(x : Number) : void
		{
			_cPoint.x = x;
			validateCircle();
		}

		/**
		 * 圆心y
		 */
		public function get y() : Number
		{
			return _cPoint.y;
		}

		public function set y(y : Number) : void
		{
			_cPoint.y = y;
			validateCircle();
		}

		/**
		 * 半径
		 */
		public function get r() : Number
		{
			return _r;
		}

		public function set r(r : Number) : void
		{
			_r = r;
			validateCircle();
		}

		/**
		 * 面积
		 */
		public function get area() : Number
		{
			return _area;
		}

		/**
		 * 最小外包边矩形
		 */
		public function get bounds() : Rectangle
		{
			return _bounds;
		}
	}
}
