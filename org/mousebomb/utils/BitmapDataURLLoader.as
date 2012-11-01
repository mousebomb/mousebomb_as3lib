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
		private var dataList : SimpleMap = new SimpleMap();
		/**
		 * 回调
		 *  key=>url
		 *   val=> array [func,...]
		 */
		private var callbackStack : Object = {};
		
		
		
		private static var _instance : BitmapDataURLLoader;

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
			var loadNew : Boolean=false;
			if (!cache)
			{
				// 禁用缓存的话 就要重新加载
				trace("禁用缓存,重新加载");
				loadNew = true;
			}
			else
			{
				// 启用缓存,检查本地
				if (dataList.containsKey(url))
				{
					trace("有缓存,直接回调");
					var bmd : BitmapData = dataList.getValue(url);
					finishCb(url, bmd);
				}
				else
				{
					trace("要缓存,但无缓存");
					loadNew = true;
				}
			}
			if (loadNew)
			{
				// 回调保存
				var arr : Array = callbackStack[url];
				if (arr == null)
				{
					callbackStack[url] = arr = [];
				}
				arr.push(finishCb);
				// 请求
				var urlRequest : URLRequest = new URLRequest(url);
				urlRequest.data = new URLVariables();
				urlRequest.data['cacheCode'] = Math.random();
				var imgLoader : TheLoader = new TheLoader();
				imgLoader.key = url;
				imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
				imgLoader.load(urlRequest);
			}
		}

		private function callback(url : String) : void
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

		private function onComplete(event : Event) : void
		{
			trace("加载完成");
			var loader : TheLoader = (event.target as LoaderInfo).loader as TheLoader;
			// 处理bmp
			var bmd : BitmapData = new BitmapData(loader.content.width, loader.content.height, true, 0);
			bmd.draw(loader.content);
			// 加入
			dataList.put(loader.key, bmd);
			callback(loader.key);
		}
	}
}
import flash.display.Loader;

class TheLoader extends Loader
{
	//
	public var key : String;
}
