package cn.flashj.robotlegs.framework
{
	import cn.flashj.robotlegs.framework.events.RlRSLEvent;

	import org.robotlegs.mvcs.Actor;

	import flash.events.Event;
	import flash.events.ProgressEvent;

	/**
	 * @author mousebomb mousebomb@gmail.com
	 */
	public class RlRSLProxy extends Actor
	{
		public function RlRSLProxy()
		{
			super();
		}

		// rsl键值对
		private var rslMap : Object = {};
		// 加载队列，加载完成后就为[]
		private var loadingQueue : Array = [];
		// 总lib数量
		private var _libCount : uint = 0;
		// 已经完成加载的lib数量
		private var _libLoaded : uint = 0;
		// 破除缓存用的，默认空字符串
		private var _cacheCode : String = "";

		/**
		 * lib总数
		 */
		public function libCount() : uint
		{
			return _libCount;
		}

		/**
		 * 已经加载的lib数量
		 */
		public function libLoaded() : uint
		{
			return _libLoaded;
		}

		/**
		 * 从加载完成的lib中提取类定义
		 */
		public function getClass(lib : String, className : String) : Class
		{
			// trace("getClass", lib, className);
			var end : Class = (rslMap[lib]['loader'] as ClassLoader).getClass(className);
			// trace(end);
			return end;
		}

		/**
		 * 从加载完成的lib中生成一个实例
		 */
		public function getInstance(lib : String, className : String) : *
		{
			var cla : Class = getClass(lib, className);
			return new cla();
		}

		/**
		 * 某个lib加载完成
		 */
		private function onRslLoadComp(event : Event) : void
		{
			_libLoaded++;
			var e : RlRSLEvent = new RlRSLEvent(RlRSLEvent.RSL_ONECOMPLETE);
			dispatch(e);
			loadNext();
		}

		/**
		 * 开始加载RSL
		 * XMLConfig::['rsl']['lib']
		 */
		public function loadLib(dconfig : RlConfigProxy) : void
		{
			// 根据XML配置的 config RSLmap ;  key=libname; loader,status,intro
			var list : XMLList = dconfig.config['rsl']['lib'];
			_libCount = list.length();
			_libLoaded = 0;
			for (var i : int = 0;i < _libCount;i++)
			{
				var xnode : XML = list[i];
				rslMap[xnode.@key] = {name:xnode.@name.toString(), loader:new ClassLoader(), url:xnode.@url.toString()};
			}
			// 创建加载队列，初始化加载
			for each (var rslItem : Object  in rslMap)
			{
				// 加入加载队列
				loadingQueue.push(rslItem);
				// 监听完成事件
				(rslItem['loader'] as ClassLoader).addEventListener(Event.COMPLETE, onRslLoadComp);
			}
			// loadNext
			loadNext();
		}

		private function loadNext() : void
		{
			var rslItem : Object = loadingQueue.shift();
			if (rslItem)
			{
				// trace("加载", rslItem['name'], rslItem['url']);
				// 传出加载的内容
				var e : RlRSLEvent = new RlRSLEvent(RlRSLEvent.RSL_NEXT, rslItem['name']);
				dispatch(e);
				(rslItem['loader'] as ClassLoader).loadFile(rslItem['url'], true, _cacheCode);
				(rslItem['loader'] as ClassLoader).addEventListener(ProgressEvent.PROGRESS, onRslProgress);
			}
			else
			{
				onAllLoadComp();
			}
		}

		// 进度信息
		private function onRslProgress(event : ProgressEvent) : void
		{
			var p : Number = (event.bytesLoaded / event.bytesTotal);
			dispatch(new RlRSLEvent(RlRSLEvent.RSL_PROGRESS, p));
		}

		private function onAllLoadComp() : void
		{
			dispatch(new RlRSLEvent(RlRSLEvent.RSL_LOADCOMPLETE));
		}

		public function get cacheCode() : String
		{
			return _cacheCode;
		}

		/**
		 * 破除缓存用的，默认空字符串表示无需
		 */
		public function set cacheCode(v : String) : void
		{
			_cacheCode = v;
		}
	}
}
