package org.mousebomb.srcloader 
{
	import flash.events.EventDispatcher;	
	
	import org.mousebomb.events.SrcloaderEvent;
	import org.mousebomb.utils.Debuger;
	import org.mousebomb.utils.HashMap;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;	

	/**
	 * @author Mousebomb
	 * @date 2009-5-27
	 */
	public class SrcMain extends EventDispatcher
	{
		private static var _instance : SrcMain;

		/**
		 * @return singleton instance of SrcMain
		 */
		public static function getInstance() : SrcMain 
		{
			if (_instance == null)
					_instance = new SrcMain();
			return _instance;
		}

		public function SrcMain() 
		{
			if (_instance != null)
					throw new Error('singleton');
			// 任务池
			_loadPools[TYPE_SWFLOADER] = new SrcloaderPool(TYPE_SWFLOADER,5);
			_loadPools[TYPE_TEXTLOADER] = new SrcloaderPool(TYPE_TEXTLOADER,5);
			_loadPools[TYPE_BINARYLOADER] = new SrcloaderPool(TYPE_BINARYLOADER,5);			//_loadPools[TYPE_CLASSLOADER] = new SrcloaderPool(TYPE_CLASSLOADER);
			
			//TODO 任务类型对应的加载完毕回调函数
			_loadOkNotification[TYPE_SWFLOADER] = SrcloaderEvent.SWF_LOADED;
			_loadOkNotification[TYPE_TEXTLOADER] = SrcloaderEvent.TEXT_LOADED;
			_loadOkNotification[TYPE_BINARYLOADER] = SrcloaderEvent.BINARY_LOADED;			//_loadOkNotification[TYPE_CLASSLOADER] = SrcloaderEvent.CLASS_LOADED;
		}

		public static const TYPE_SWFLOADER : int = 0x01;
		public static const TYPE_TEXTLOADER : int = 0x02;
		public static const TYPE_BINARYLOADER : int = 0x03;		//public static const TYPE_CLASSLOADER : int = 0x03;
		
		public static const STATUS_AVAILABLE:String = "尚未启用";
		public static const STATUS_LOADING:String = "载入中";
		public static const STATUS_LOADED:String = "已加载";
		public static const STATUS_QUEUE:String = "列队中";

		/**
		 * 保存资源哈希表 key => *
		 */
		private var _hashMap : HashMap = new HashMap();

		/**
		 * 加载器多任务池
		 */
		private var _loadPools : Object = {};

		/**
		 * 加载器回调后发的通告
		 */
		private var _loadOkNotification:Object = {};
		
		/**
		 * 加载中的资源哈希表 key => SrcLoader
		 */
		private var _taskLoaderMap : HashMap = new HashMap();
		/**
		 * 排队等待加载的任务队列 {key:key, type:type, url:url},...
		 */
		private var _taskQueue : Array = [];
		
		/**
		 * 加载位于url的资源 加载OK后可以通过唯一标识key获取引用
		 * 加载完毕发notification,参数是key
		 */
		public function load(key : String,type : int,url : String) : void
		{
			Debuger.trace("请求加载资源 key=" + key + " ,url=" + url);
			//先要判断是否已经在加载队伍中了
			if(getStatus(key) != STATUS_AVAILABLE)
			{
				Debuger.trace("重复的资源加载请求，key" +key+"已存在，忽略");
				return ;
			}
			var curLoader : SrcloaderBase = (_loadPools[type] as SrcloaderPool).get();
			//如果curLoader为null则记到queue 一会重新调度
			if(curLoader)
			{
				//将任务对应的loader放进表以查询加载进度等信息
				_taskLoaderMap.put(key, curLoader);
				curLoader.load(url, key);
				curLoader.addEventListener(ProgressEvent.PROGRESS, onProgress);
				curLoader.addEventListener(SrcloaderEvent.COMPLETE, onLoadComplete);
				curLoader.addEventListener(SrcloaderEvent.IO_ERR, onIOErr);
			}else
			{
				_taskQueue.push({key:key, type:type, url:url});
				Debuger.trace("现在忙，先将任务记下 key=" + key + " ,url="+url);
				Debuger.trace(_taskQueue);
			}
		}
		
		public function bytes2swf(bytes:ByteArray , byte2swfCallback:Function,...args):void
		{
			var bytes2swf : Bytes2Swf = new Bytes2Swf();
			bytes2swf.exec(bytes, byte2swfCallback,args);
		}

		/**
		 * 查询一个key标识的资源状态
		 */
		public function getStatus(key:String):String
		{
			//若有此资源则返回
			if(has(key))
				return STATUS_LOADED;
			//若加载任务表中有则返回
			if(_taskLoaderMap.containsKey(key))
				return STATUS_LOADING;
			//若在排队
			for each(var item:Object in _taskQueue)
			{
				if(key == item['key'])
				{
					return STATUS_QUEUE;
				}
			}
			//若尚未启用
			return STATUS_AVAILABLE;
		}

		/**
		 * 监听加载进度
		 * 别忘释放资源
		 */
		private function onProgress(event : ProgressEvent) : void
		{
			var curLoader : SrcloaderBase = event.target as SrcloaderBase;
			//trace(target.key + "进度:" + target.loadPercent);
			//TODO 耦合点:发出通知
			dispatchEvent(new SrcloaderEvent(SrcloaderEvent.SRCLOAD_PROGRESS,{key:curLoader.key,percent:curLoader.loadPercent}));
		}

		/**
		 * 加载完成的回调
		 * data保存到资源hashMap
		 * 发出通告
		 */
		private function onLoadComplete(event:SrcloaderEvent) : void
		{
			//先释放资源
			var curLoader : SrcloaderBase = event.target as SrcloaderBase;
			curLoader.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			curLoader.removeEventListener(SrcloaderEvent.COMPLETE, onLoadComplete);
			curLoader.removeEventListener(SrcloaderEvent.IO_ERR, onIOErr);
			//获取数据
			var key:String = event.data['key'];
			var data:*  = event.data['data'];
			var type :int = event.data['type'];
			_hashMap.put(key, data);
			_taskLoaderMap.remove(key);
			Debuger.trace("数据加载完毕 key=" + key);
			//TODO 耦合点
			dispatchEvent(new SrcloaderEvent(_loadOkNotification[type], key));
			//该重新调度的就重调度
			var nextTask : Object = _taskQueue.shift();
			if(nextTask)
			{
				Debuger.trace("请求重新调度 key="+nextTask['key'] + " ,url=" + nextTask['url']);
				load(nextTask['key'], nextTask['type'], nextTask['url']);
			}
		}
		
		/**
		 * io错误
		 */
		private function onIOErr(event : SrcloaderEvent) : void
		{
			//TODO 耦合点
			//event.data = {key:_key, type:_type, errText:event.text};
			Debuger.trace("加载IO错误, key=" + event.data['key']);
			_taskLoaderMap.remove(event.data['key']);
			dispatchEvent(new SrcloaderEvent(SrcloaderEvent.IO_ERR,event.data));
		}

		/**
		 * 获取某资源
		 */
		public function get(key : String) : *
		{
			return _hashMap.getValue(key);
		}
		
		/**
		 * 查看是否有某资源
		 * @param key 资源唯一键
		 */
		public function has(key : String) : Boolean
		{
			return _hashMap.containsKey(key);
		}

		/**
		 * 释放某资源
		 */
		public function unload(key : String) : void
		{
			_hashMap.remove(key);
		}
		
		/**
		 * 获取当前加载进度信息
		 * @return LoadStatus
		 */
		public function getLoadStatus():LoadStatus
		{
			var ending : LoadStatus = new LoadStatus();
			var loadingProgress:Object = {};
			var keys:Array = _taskLoaderMap.getKeys();
			var curLoader : SrcloaderBase;
			for each( var key:String in keys)
			{
				curLoader = _taskLoaderMap.getValue(key) as SrcloaderBase;
				loadingProgress[key] = curLoader.loadPercent;
			}
			ending.loadingCount  = _taskLoaderMap.getKeys().length;
			ending.loadingProgress = loadingProgress;
			ending.queueCount = _taskQueue.length;
			ending.loadedCount = _hashMap.getKeys().length;
			return ending;
		}
		
	}
}
