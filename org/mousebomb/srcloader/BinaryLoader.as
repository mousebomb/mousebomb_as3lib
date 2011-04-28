package org.mousebomb.srcloader 
{
	import org.mousebomb.events.SrcloaderEvent;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;		

	/**
	 * @author Mousebomb
	 * @date 2009-5-28
	 */
	public class BinaryLoader extends SrcloaderBase implements ISrcloader 
	{

		private var _loader : URLLoader ;

		public function BinaryLoader()
		{
			super(SrcMain.TYPE_BINARYLOADER);
			_loader = new URLLoader();
			_loader.addEventListener(ProgressEvent.PROGRESS,onLoadProgress);
			_loader.addEventListener(Event.COMPLETE, onLoadComplete);
		}

		/**
		 * 加载swf文件到资源区
		 */
		override public function load(url : String,key:String) : void
		{
			super.load(url,  key);
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_loader.load(new URLRequest(url));
		}

		override public function unload() : void
		{
			//貌似如果没有addChild到显示列表，unload不会成功
			_loader = null;
		}

		protected function onLoadComplete(event : Event) : void
		{
			_isFree = true;
			var outEvent : SrcloaderEvent = new SrcloaderEvent(SrcloaderEvent.COMPLETE, {key:_key, type:_type, data:_loader.data});
			this.dispatchEvent(outEvent);
		}
		private function onLoadProgress(event : ProgressEvent) : void
		{
			_loadPercent = (event.bytesLoaded / event.bytesTotal);
			this.dispatchEvent(event);
		}
	}
}
