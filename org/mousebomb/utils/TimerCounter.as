package org.mousebomb.utils 
{
	import flash.utils.getTimer;

	/**
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-7-8
	 */
	public class TimerCounter extends Object 
	{

		//任务单次开始执行的时间
		private static var _tasks : Object = {};

		/**
		 * 开始任务计时
		 */
		public static function startTask(name : String) : void
		{
			_tasks[name] = getTimer();
		}

		/**
		 * 结束任务计时，返回执行时间
		 */
		public static function endTask(name : String) : void
		{
			//一次执行耗时
			var onceTime : int = getTimer() - _tasks[name] ;
			trace("Task " + name + " used :" + onceTime + " ms");
		}
	}
}
