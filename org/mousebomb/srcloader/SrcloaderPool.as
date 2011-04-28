package org.mousebomb.srcloader 
{
	import org.mousebomb.utils.Debuger;
	
	import flash.events.EventDispatcher;	

	/**
	 * 资源加载器池.
	 * 每种加载器都用我来控制线程任务分配
	 * @author Mousebomb
	 * @date 2009-5-27
	 */
	public class SrcloaderPool extends EventDispatcher 
	{
		private var _pool : Array = [];
		private var _factory : SrcloaderFactory = SrcloaderFactory.getInstance();
		private var _type : int ; 
		private var _max : int; 

		/**
		 * @param type 资源加载器类型
		 * @param max 最多允许多少加载器实例存在
		 */
		public function SrcloaderPool(type : int,max : int = 1) : void
		{
			super();
			_type = type;
			_max = max;
		}

		/**
		 * 尝试获取一个加载器.
		 * 你要资源我就给，我给不起了就给null，你得记住我欠着你一次，一会再来拿
		 * 寻找空闲的加载器，找到就返回
		 * 找不到则尝试在不超过max的情况下创建一个并返回
		 * 否则返回null
		 */
		public function get() : SrcloaderBase
		{
			//Debuger.trace(_pool);
			for each(var i:SrcloaderBase in _pool)
			{
				if(i.isFree())
				{
					return i;
				}
			}
			if(_pool.length < _max)
			{
				var loader : SrcloaderBase = _factory.create(_type);
				_pool.push(loader);
				return loader;
			}
			return null;
		}
	}
}
