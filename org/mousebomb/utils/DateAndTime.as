package org.mousebomb.utils 
{

	/**
	 * @author Mousebomb
	 * @date 2009-9-13
	 */
	public class DateAndTime extends Object 
	{
		public function DateAndTime()
		{
		}

		private static var millisecondsPerWeek : int = 7 * 24 * 3600 * 1000;		private static var millisecondsPerDay : int = 24 * 3600 * 1000;		private static var millisecondsPerHour : int = 3600 * 1000;
		private static var millisecondsPerMinute : int = 60 * 1000;
		private static var millisecondsPerSecond : int = 1000;

		/**
		 * 把一个UTC时间字符串转化成SNS流行的格式 xx秒前,XX小时前之类
		 */
		public static function parseTimeFromUTC(time : String) : String 
		{
			var date : Date = new Date(time);
			return parseTimeFromDate(date);
		}

		/**
		 * 把一个Date类型转化成SNS流行的格式 xx秒前,XX小时前之类
		 */
		public static function parseTimeFromDate(date : Date) : String 
		{
			var resultTime : String = "";
			var nowDate : Date = new Date();
			var c : int = nowDate.getTime() - date.getTime();
			if (c < millisecondsPerDay) 
			{
				//24小时内
				if (c < millisecondsPerMinute) 
				{
					//1分钟内
					resultTime = Math.round(c / millisecondsPerSecond) + "秒前";
				} else if (c < millisecondsPerHour) 
				{
					//1小时内
					resultTime = Math.round(c / millisecondsPerMinute) + "分钟前";
				} else 
				{
					//1小时以上
					resultTime = "约" + Math.round(c / millisecondsPerHour) + "小时前";
				}
			} else  if(c < millisecondsPerWeek)
			{
				resultTime = "约" + Math.round(c / millisecondsPerDay) + "天前";
			}else
			{
				resultTime = date.fullYear + "年" + (date.month + 1) + "月" + (date.date) + "日 " + date.toTimeString();
			}
			return resultTime;
		}

		/**
		 * @param format 格式
		 * %Y-%m-%d %H:%i:%s 
		 */
		public static function formatDate(format : String,date : Date) : String
		{			format = format.replace(/%y/ig, date.fullYear);			format = format.replace(/%m/ig, date.month + 1);			format = format.replace(/%d/ig, date.date);
			format = format.replace(/%h/ig, date.hours);
			if( date.minutes < 10)				format = format.replace(/%i/ig, "0" + date.minutes);
			else
				format = format.replace(/%i/ig, date.minutes);
			if(date.seconds < 10)
				format = format.replace(/%s/ig, "0" + date.seconds);
			else
				format = format.replace(/%s/ig, date.seconds);
			return format;
		}
	}
}
