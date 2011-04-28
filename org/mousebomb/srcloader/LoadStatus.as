package org.mousebomb.srcloader 
{

	/**
	 * 载入资源状态对象
	 * @author Mousebomb
	 * @date 2009-6-3
	 */
	public class LoadStatus extends Object 
	{
		public var loadingCount : uint;
		public var loadedCount : uint;
		public var queueCount : uint;
		public var loadingProgress : Object;

		public function LoadStatus()
		{
		}

		public function toString() : String
		{
			var outStr : String = "";
			outStr = loadingCount + "个资源加载中(";
			for (var key:String in loadingProgress)
			{
				outStr += (" " + key + ":" + (loadingProgress[key] as Number).toFixed(2));
			}
			outStr += ")," + loadedCount + "个资源已加载";
			outStr += "," + queueCount + "个资源队列中";
			return outStr;
		}
	}
}
