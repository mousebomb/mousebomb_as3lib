package org.mousebomb.utils
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	/**
	 * 写日志的工具
	 * @author mousebomb mousebomb@gmail.com
	 * created: 2012-10-17 
	 * last modified: 2012-10-17
	 */
	public class LogWriter
	{
		/** 
		 * 本地trace + 服务器端文本日志
		 *  服务器端日志的查看地址为 <a href="http://172.16.12.18:81/ClientLog/" >http://172.16.12.18:81/ClientLog/</a>
		 */
		public static const SERVER_FILE : int = 2;
		/** 本地trace */
		public static const LOCAL_TRACE : int = 1;
		/** 禁用日志 */
		public static const DISABLE : int = 0;
		/**
		 * 日志模式
		 */
		public static var mode : int = LOCAL_TRACE;
		/**
		 * 代理写日志的服务器接口
		 */
		public static var LOG_API : String = "http://124.78.178.164/ClientLog/log.php";

		/**
		 * 记录追踪日志
		 */
		public static function log(...args) : void
		{
			if (mode == LogWriter.DISABLE)
				return;
			//
			var d : Date = new Date();
			var now : String = (d.month + 1) + "-" + (d.date) + " " + d.hours + ":" + d.minutes + ":" + d.seconds;
			trace.apply(null, [now].concat(args));
			if (mode == SERVER_FILE)
			{
				// 提交到server
				var urlR : URLRequest = new URLRequest(LogWriter.LOG_API);
				var data : URLVariables = new URLVariables();
				data.l = args.join(" ");
				urlR.method= URLRequestMethod.POST;
				urlR.data = data;
				var urlL : URLLoader = new URLLoader(urlR);
			}
		}
	}
}
