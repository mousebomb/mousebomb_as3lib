package org.mousebomb.utils
{
	/**
	 * 与服务器对时
	 * @author mousebomb mousebomb@gmail.com
	 * created: 2012-11-5 
	 * last modified: 2012-11-5
	 * 从kr移植过来
	 */
	public class ServerTimeUtils
	{
		// 偏移量(毫秒) 客户端时间+_offset = 服务器时间
		public static var offset : int = 0;

		public static function getNowDate() : Date
		{
			var ending : Date = new Date();
			ending.time = (new Date()).time + offset;
			return ending;
		}

		/**
		 * 获得当前自1970年以来的毫秒
		 */
		public static function getNowMs() : Number
		{
			return (new Date()).time + offset;
		}

		/**
		 * 获取当前自1970年以来的秒
		 */
		public static function getNowTime() : uint
		{
			return ((new Date()).time + offset ) / 1000;
		}

		/**
		 * 与server对时
		 * @param serverTime 秒数
		 */
		public static function setServerTime(serverTime : Number) : void
		{
			var now : Date = new Date();
			offset = serverTime * 1000 - now.time;
		}
	}
}
