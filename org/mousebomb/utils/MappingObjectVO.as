package org.mousebomb.utils 
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;

	/**
	 * 映射Object与VO
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-6-9
	 */
	public class MappingObjectVO extends Object 
	{

		private static var _instance : MappingObjectVO;

		public static function getInstance() : MappingObjectVO 
		{
			if (_instance == null)
							_instance = new MappingObjectVO();
			return _instance;
		}

		public function MappingObjectVO() 
		{
			if (_instance != null)
						throw new Error('singleton');
		}

		/**
		 * 转化一个Object为一个有类声明的值对象
		 * 不过不支持数组中的特殊类型，因为那个没有类定义
		 * @param className 目标类
		 * @param dataSrc 数据源
		 */
		public function doRequest(className : Class , dataSrc : Object) : *
		{
			//返回对象
			var rtObject : * = new className();
			//类型描述
			var classInfo : XML = describeType(className);
			//变量键
			var vKey : String;
			//变量类型
			var vType : String;
			//找到属性、可用的setter
			for each ( var v : XML in classInfo..*.( 
					name() == "variable" || ( 
						name() == "accessor" // 确定可写入数据
						&& attribute("access") != "readonly" ) 
					) )
			{
				//记录类型和键
				vType = v.@type;
				vKey = v.@name;
				//根据类型，不同处理
				switch(vType)
				{
					//基本类型
					case "int":
					case "Number":
					case "Boolean":
					case "uint":
					case "String":					case "Date":
					case "Object":
					case "Array":
						//每一项，尝试从dataSrc中寻找对应的数据
						rtObject[vKey] = (dataSrc[vKey]);
						break;
					//复杂类型
					default: 
						try
						{
							rtObject[vKey] = doRequest(getDefinitionByName(vType) as Class, dataSrc[vKey]);
						}catch(e:*)
						{
							trace("类型:" + vType + "在运行时不存在");
						}
						break;
				}
			}
			//
			return rtObject;
		}
		
		/**
		 * 转化一个Object为一个有类声明的值对象
		 * 不支持嵌套
		 * @param className 目标类
		 * @param dataSrc 数据源
		 */
		public function simpleObject(className : Class , dataSrc : Object):*
		{
			//返回对象
			var rtObject : * = new className();
			for (var key : String in dataSrc)
			{
				rtObject[key] = dataSrc[key];
			}
			return rtObject;
		}
	}
}
