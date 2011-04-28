package org.mousebomb.utils 
{
	import nl.demonsters.debugger.MonsterDebugger;

	/**
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-3-28
	 */
	public class Debug extends Object 
	{
		public function Debug()
		{
			throw new Error("不可实例化");
		}

		/**
		 * 是否启用,全局控制的
		 * 一次性关闭所有消耗
		 */
		public static var disable : Boolean = false;

		/**
		 * 直接输出
		 * 和flash的输出类似，但多个参数会作为数组显示详细结构,而不采用逗号分割
		 */
		public static function traceDirectly(... args) : void
		{
			if(disable) return;
			if(args.length == 1)
			{
				MonsterDebugger.trace("mousebomb 直接trace", args[0]);
			}
			else
			{
				MonsterDebugger.trace("mousebomb 直接trace", args);
			}
			trace(args);
		}

		/**
		 * 对某一对象的trace
		 * @param target 对象的标识
		 * @param args trace的内容
		 */
		public static function trace4Target(target : String,...args) : void
		{
			if(disable) return;
			if(args.length == 1)
			{
				MonsterDebugger.trace(target, args[0], 0x059905);
			}
			else
			{
				MonsterDebugger.trace(target, args, 0x990505);
			}
			trace(target, args);
		}
	}
}
