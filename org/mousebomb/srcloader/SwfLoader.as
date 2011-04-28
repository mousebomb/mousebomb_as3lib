package org.mousebomb.srcloader 
{
	import org.mousebomb.events.SrcloaderEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.Security;		

	/**
	 * @author Mousebomb
	 * @date 2009-5-27
	 */
	public class SwfLoader extends SrcloaderBase implements ISrcloader 
	{

		private var _loader : Loader ;

		public function SwfLoader()
		{
			super(SrcMain.TYPE_SWFLOADER);
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.INIT, onLoadComplete);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOErr);
		}

		/**
		 * 加载swf文件到资源区
		 */
		override public function load(url : String,key : String) : void
		{
			super.load(url, key);
			var lc : LoaderContext = new LoaderContext(true);
			_loader.load(new URLRequest(url),lc);
		}

		override public function unload() : void
		{
			_loader.unload();
		}

		protected function onLoadComplete(event : Event) : void
		{
			_isFree = true;
			var _loadedData : DisplayObject = _loader.content;
			_loader.unload();
			var outEvent : SrcloaderEvent = new SrcloaderEvent(SrcloaderEvent.COMPLETE, {key:_key, type:_type, data:_loadedData});
			this.dispatchEvent(outEvent);
		}

		private function onLoadProgress(event : ProgressEvent) : void
		{
			_loadPercent = (event.bytesLoaded / event.bytesTotal);
			this.dispatchEvent(event);
		}
		
		//io错，终止加载
		private function onIOErr(event : IOErrorEvent) : void
		{
			_isFree = true;
			_loader.unload();
			var outEvent : SrcloaderEvent = new SrcloaderEvent(SrcloaderEvent.IO_ERR, {key:_key, type:_type, errText:event.text});
			this.dispatchEvent(outEvent);
		}
	}
}
