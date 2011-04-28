package org.mousebomb.srcloader 
{
	import flash.display.DisplayObject;	
	import flash.events.Event;	
	import flash.utils.ByteArray;	
	import flash.display.Loader;	
	
	/**
	 * byte转swf,用于深度复制的swf，加载为ba
	 * 用完就消逝不留引用
	 * @author Mousebomb
	 * @date 2009-6-15
	 */
	public class Bytes2Swf 
	{
		private var _loader : Loader = new Loader();
		private var _callback : Function;
		private var _args : Array;

		public function exec(bytes : ByteArray,callback : Function,args : Array) : void
		{
			_loader.contentLoaderInfo.addEventListener(Event.INIT, onLoadInit);
			_loader.loadBytes(bytes);
			_callback = callback;
			_args = args;
		}
		
		private function onLoadInit(event : Event) : void
		{
			_loader.removeEventListener(Event.INIT, onLoadInit);
			var target : DisplayObject = _loader.content;
			_loader.unload();
			_args.unshift(target);
			_callback.apply(null, _args);
		}
	}
}
