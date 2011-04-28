package org.mousebomb.srcloader 
{
	import org.mousebomb.events.SrcloaderEvent;
	
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;		

	/**
	 * @author Mousebomb
	 * @date 2009-5-27
	 */
	public class TextLoader extends SrcloaderBase implements ISrcloader 
	{

		private var _loader : URLLoader;

		public function TextLoader()
		{
			super(SrcMain.TYPE_TEXTLOADER);
			_loader = new URLLoader();
			_loader.addEventListener(ProgressEvent.PROGRESS,onLoadProgress);
			_loader.addEventListener(Event.COMPLETE, onLoadComplete);
		}

		/**
		 * 加载文本到资源区
		 */
		override public function load(url : String,key : String) : void
		{
			super.load(url, key);
			_loader.load(new URLRequest(url));
		}

		override public function unload() : void
		{
			_loader.data=null;
		}

		protected function onLoadComplete(event : Event) : void
		{
			_isFree = true;
			var textData : String = (event.target as URLLoader).data;
			var outEvent : SrcloaderEvent = new SrcloaderEvent(SrcloaderEvent.COMPLETE, {key:_key, type:_type, data:textData});
			this.dispatchEvent(outEvent);
		}
		private function onLoadProgress(event : ProgressEvent) : void
		{
			_loadPercent = (event.bytesLoaded / event.bytesTotal);
			this.dispatchEvent(event);
		}
	}
}
