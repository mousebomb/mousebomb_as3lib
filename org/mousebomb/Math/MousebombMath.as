package org.mousebomb.Math
{
	import flash.geom.Point;

	/**
	 * @author Mousebomb
	 * @since 2009-1-1
	 */
	public class MousebombMath
	{
		/**
		 * 获得一个十进制数第pow位的值 (个位的pow=0)
		 */
		public static function getDigit(num : Number, pow : int) : int
		{
			return (Math.floor(num % (Math.pow(10, pow + 1)) / Math.pow(10, pow)));
		}

		/**
		 * 范围随机数
		 * @return 大于或等于min且小于max的数值
		 */
		public static function randomFromRange(min : Number, max : Number) : Number
		{
			return Math.random() * (max - min) + min;
		}

		/**
		 * 弧度转角度
		 */
		public static function degreesFromRadians(radians : Number) : Number
		{
			return radians * 180 / Math.PI;
		}

		/**
		 * 角度转弧度
		 */
		public static function radiansFromDegrees(degrees : Number) : Number
		{
			return degrees * Math.PI / 180;
		}

		/**
		 * 2d空间两点间的距离
		 */
		public static function distanceOf2Point(fromPoint : Point, toPoint : Point) : Number
		{
			var deltaX : Number = toPoint.x - fromPoint.x;
			var deltaY : Number = toPoint.y - fromPoint.y;
			return Math.sqrt(deltaX * deltaX + deltaY * deltaY);
		}

	}
}
