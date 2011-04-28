package cn.flashj.robotlegs.framework
{
	import cn.flashj.robotlegs.framework.events.RlConfigEvent;

	import org.robotlegs.mvcs.Actor;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	// 单个XML加载渐进
	[Event(name="CONFIG_PROGRESS", type="cn.flashj.robotlegs.framework.events.RlConfigEvent")]
	// 所有XML加载完成
	[Event(name="CONFIG_LOADCOMPLETE", type="cn.flashj.robotlegs.framework.events.RlConfigEvent")]
	/**
	 * @author mousebomb mousebomb@gmail.com
	 */
	public class RlConfigProxy extends Actor
	{
		private var _loader : URLLoader;
		// 要加载的内容的文件
		private var _files : Array ;
		// 是否多个config
		private var _totalFiles : uint;
		// 当前加载的生xml
		private var _rawXML : XML;
		// 合并后的xml
		private var _mergedXML : XML;
		// 破除缓存用的
		private var _cacheCode : String;

		/**
		 * 初始化
		 * @param configFile 若赋值，则立即加载配置；留空则直到手动调用getDConfig(_configFile:String)才加载
		 */
		public function RlConfigProxy(configFiles : * = null)
		{
			_loader = new URLLoader();
			_loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
			_loader.addEventListener(Event.COMPLETE, onComp);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIoErr);
			if (configFiles)
			{
				getDConfig(configFiles);
			}
		}

		/**
		 * 合并为一个config的xml
		 */
		protected function merge(subXML : XML) : void
		{
			if (_mergedXML == null)
			{
				// 如果xml无值，则采用要加入的做原始值
				_mergedXML = subXML.copy();
			}
			else
			{
				// 去掉subXML的root标记
				_mergedXML.appendChild(subXML[0].*);
			}
		}

		/**
		 * 解析配置，产生一些变量,方便访问.
		 * 会在加载完成后被调用
		 */
		protected function parseConfig() : void
		{
			// config.sth...
		}

		private function onIoErr(event : IOErrorEvent) : void
		{
			dispatch(event);
		}

		// 这里放出的是单个config的加载任务，不是所有
		private function onProgress(event : ProgressEvent) : void
		{
			var rlEvent : RlConfigEvent = new RlConfigEvent(RlConfigEvent.CONFIG_PROGRESS);
			rlEvent.bytesLoaded = event.bytesLoaded;
			rlEvent.bytesTotal = event.bytesTotal;
			dispatch(rlEvent);
		}

		// 一次加载完成
		private function onComp(event : Event) : void
		{
			// 完成本次，记录xml
			_rawXML = XML(_loader.data);
			// 合并
			merge(_rawXML);
			if (_files.length)
			{
				// 若还有任务则继续
				loadNext();
			}
			else
			{
				// 若全部加载完成
				parseConfig();
				dispatch(new RlConfigEvent(RlConfigEvent.CONFIG_LOADCOMPLETE));
			}
		}

		/**
		 * 开始加载config文件们
		 * @param configFiles 字符串，或者数组； 字符串则单个文件，数组则多个文件
		 */
		public function getDConfig(configFiles : *) : void
		{
			if (configFiles is Array)
			{
				_files = configFiles;
				_totalFiles = _files.length;
			}
			else
			{
				_totalFiles = 1;
				_files = [configFiles];
			}
			loadNext();
		}

		// 加载一个文件
		private function loadNext() : void
		{
			var curFile : String = _files.shift();
			if (curFile)
			{
				// 加载
				var urlRequest : URLRequest = new URLRequest(curFile);
				if (_cacheCode)
				{
					urlRequest.data = new URLVariables("cache=" + _cacheCode);
				}
				_loader.load(urlRequest);
			}
		}

		/**
		 * 返回合并过的xml
		 */
		public function get config() : XML
		{
			return _mergedXML;
		}

		public function get cacheCode() : String
		{
			return _cacheCode;
		}

		// 破除缓存用的
		public function set cacheCode(v : String) : void
		{
			_cacheCode = v;
		}

		public function get totalFiles() : uint
		{
			return _totalFiles;
		}
	}
}
