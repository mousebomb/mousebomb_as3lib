package org.mousebomb.utils
{
	import flash.display.LoaderInfo;
	import flash.net.URLVariables;

	import org.mousebomb.structure.SimpleMap;

	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.net.URLRequest;

	/**
	 * 加载url资源为位图数据缓存 以便渲染
	 * @author mousebomb mousebomb@gmail.com
	 * created: 2012-11-1 
	 * last modified: 2012-11-1
	 */
	public class BitmapDataURLLoader
	{
		/**
		 * 数据列表. 
		 *  key是url,val是BitmapData
		 */
		protected var dataList : SimpleMap = new SimpleMap();
		/**
		 * 回调
		 *  key=>url
		 *   val=> array [func,...]
		 */
		protected var callbackStack : Object = {};
		private static var _instance : BitmapDataURLLoader;
		// 限制同时加载用
		private var delayLoadQueue : Array = [];
		/**
		 * 同时加载数量
		 */
		public var parallelsNum : int = 3;
		// 当前加载的
		private var nowLoading : Array = [];

		public static function getInstance() : BitmapDataURLLoader
		{
			if (_instance == null)
				_instance = new BitmapDataURLLoader();
			return _instance;
		}

		public function BitmapDataURLLoader()
		{
			if (_instance != null)
				throw new Error('singleton');
		}

		/**
		 * 开始加载
		 * @param cache 是否启用缓存
		 * @param finishCb 回调函数 Function (url:String , bmd :BitmapData);
		 * @param url 地址
		 */
		public function load(url : String, finishCb : Function, cache : Boolean = true) : void
		{
			var needLoadNew : Boolean = false;
			if (!cache)
			{
				// 禁用缓存的话 就要重新加载
				 trace("BitmapDataURLLoader 禁用缓存,重新加载",url);
				needLoadNew = true;
			}
			else
			{
				// 启用缓存,检查本地
				if (dataList.containsKey(url))
				{
					 trace("BitmapDataURLLoader 有缓存,直接回调",url);
					var bmd : BitmapData = dataList.getValue(url);
					finishCb(url, bmd);
				}
				else
				{
					 trace("BitmapDataURLLoader 要缓存,但无缓存",url);
					needLoadNew = true;
				}
			}
			if (needLoadNew)
			{
				if (parallelsNum > nowLoading.length && nowLoading.indexOf(url) < 0)
				{
					trace("BitmapDataURLLoader 开始异步加载");
					// 当前没有加载这个url,且还可以开始新的加载任务
					// 则异步加载
					startAsyncLoad(url, finishCb);
				}
				else
				{
					trace("BitmapDataURLLoader 排队");
					// 排队的
					var cmd : Object = {url: url, finishCb: finishCb, cache: cache};
					delayLoadQueue.push(cmd);
				}
			}
		}

		private function startAsyncLoad(url : String, finishCb : Function) : void
		{
			// 回调保存
			var arr : Array = callbackStack[url];
			if (arr == null)
			{
				callbackStack[url] = arr = [];
			}
			arr.push(finishCb);
			//
			var urlRequest : URLRequest = new URLRequest(url);
			urlRequest.data = new URLVariables();
			urlRequest.data['cacheCode'] = Math.random();
			var imgLoader : TheLoader = new TheLoader();
			imgLoader.key = url;
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			imgLoader.load(urlRequest);
			nowLoading.push(url);
		}

		protected function callback(url : String) : void
		{
			var arr : Array = callbackStack[url];
			if (arr == null)
			{
				return;
			}
			var bmd : BitmapData = dataList.getValue(url);
			while (arr.length)
			{
				var handler : Function = arr.shift();
				handler(url, bmd);
			}
		}

		protected function onComplete(event : Event) : void
		{
			var loader : TheLoader = (event.target as LoaderInfo).loader as TheLoader;
			trace("BitmapDataURLLoader 加载完成", loader.key);
			// 处理bmp
			var bmd : BitmapData = new BitmapData(loader.content.width, loader.content.height, true, 0);
			bmd.draw(loader.content);
			// 加入
			dataList.put(loader.key, bmd);
			// 批量回调
			callback(loader.key);
			// 标记为当前不在加载这个url了
			var index : int = nowLoading.indexOf(loader.key);
			nowLoading.splice(index, 1);
			trace("BitmapDataURLLoader 出队,",index);
			// 检查delay队列
			var cmd : Object = delayLoadQueue.shift();
			if (cmd != null)
				load(cmd.url, cmd.finishCb, cmd.cache);
		}
	}
}


import flash.display.Loader;

class TheLoader extends Loader
{
	//
	public var key : String;
}
