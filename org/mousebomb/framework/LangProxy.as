package org.mousebomb.framework 
{

	/**
	 * 语言包
	 * 配合framework的config和xml使用
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-2-22
	 */
	public class LangProxy 
	{
		private static var _instance : LangProxy;

		public static function getInstance() : LangProxy 
		{
			if (_instance == null)
							_instance = new LangProxy();
			return _instance;
		}

		public function LangProxy() 
		{
			if (_instance != null)
						throw new Error('singleton');
		}

		private var _len : uint = 0;
		private var _langMap : Object = {};

		/**
		 * 从config初始化，载入语言包
		 */
		public function loadLang(dconfig : DConfigProxy) : void
		{
			_langMap = {};
			var xlist : XMLList = dconfig.config["lang"]["item"];
			_len = xlist.length();
			for (var i : int = 0;i < _len;i++)
			{
				var xnode : XML = xlist[i];
				var value : String = xnode["@value"];
				var name : String = xnode["@name"];
				_langMap[name] = value;
			}
		}

		/**
		 * 获取一条语句
		 */
		public function lang(name : String) : String
		{
			if(_langMap[name])
				return _langMap[name];
			else
				return "#语言丢失" + name + "#";
		}

		/**
		 * 整个语言包的条数
		 */
		public function get langCount() : uint
		{
			return _len;
		}
	}
}
