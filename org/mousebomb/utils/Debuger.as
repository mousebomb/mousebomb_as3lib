package org.mousebomb.utils
{
	import nl.demonsters.debugger.MonsterDebugger;

	//2010.3.28起不再使用

	public class Debuger
	{

		//2010.3.28起不再使用
		public function Debuger()
		{
			throw new Error("不可实例化");
		}

		public static function trace(... args) : void
		{
			if(args.length == 1)
			{
				MonsterDebugger.trace("mousebomb", args[0]);
			}
			else
			{
				MonsterDebugger.trace("mousebomb", args);
			}
		}

		public static function ttrace(target : String,...args) : void
		{
			if(args.length == 1)
			{
				MonsterDebugger.trace(target, args[0], 0x059905);
			}
			else
			{
				MonsterDebugger.trace(target, args, 0x990505);
			}
		}
	}
}