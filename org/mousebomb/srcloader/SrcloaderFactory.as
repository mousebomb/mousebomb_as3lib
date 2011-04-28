package org.mousebomb.srcloader 
{
	import flash.utils.Dictionary;		

	/**
	 * @author Mousebomb
	 * @date 2009-5-27
	 */
	public class SrcloaderFactory 
	{
		private static var _instance : SrcloaderFactory;

		/**
		 * @return singleton instance of SrcloaderFactory
		 */
		public static function getInstance() : SrcloaderFactory 
		{
			if (_instance == null)
					_instance = new SrcloaderFactory();
			return _instance;
		}

		public function SrcloaderFactory() 
		{
			if (_instance != null)
					throw new Error('singleton');
			classMap[SrcMain.TYPE_SWFLOADER] = SwfLoader;
			classMap[SrcMain.TYPE_TEXTLOADER] = TextLoader;
			classMap[SrcMain.TYPE_BINARYLOADER] = BinaryLoader;
		}

		private var classMap : Dictionary = new Dictionary();

		
		public function create(type : int) : SrcloaderBase
		{
			var className : Class = classMap[type];
			if(!className)
			{
				throw new Error("创建资源loader出错:不存在的类型" + type);
			}
			return new className();
		}
	}
}
