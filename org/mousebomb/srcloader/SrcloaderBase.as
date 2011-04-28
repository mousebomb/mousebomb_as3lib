package org.mousebomb.srcloader 
{
	import org.mousebomb.srcloader.ISrcloader;
	
	import flash.events.EventDispatcher;	

	/**
	 * 资源加载器
	 * 抽象类
	 * @author Mousebomb
	 * @date 2009-5-27
	 */
	public class SrcloaderBase extends EventDispatcher implements ISrcloader 
	{
		protected var _isFree : Boolean = true;
		protected var _key : String;
		protected var _type : int;
		protected var _loadPercent:Number;

		public function SrcloaderBase(type : int)
		{
			super();
			_type = type;
		}

		/**
		 * 加载url的资源
		 * 抽象方法
		 */
		public function load(url : String,key : String) : void
		{
			if(!_isFree) return;
			_isFree = false;
			_key = key;
			_loadPercent = 0;
		}

		/**
		 * 是否空闲
		 */
		public function isFree() : Boolean
		{
			return _isFree;
		}

		/**
		 * 清除内存
		 */
		public function unload() : void
		{
		}
		
		/**
		 * 获取当前的加载进度
		 * @return Number
		 */
		public function get loadPercent() : Number
		{
			return _loadPercent;
		}
		
		/**
		 * 获取当前加载的内容唯一键
		 */
		public function get key() : String
		{
			return _key;
		}
	}
}
