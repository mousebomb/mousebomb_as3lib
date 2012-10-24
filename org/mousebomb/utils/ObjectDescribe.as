package org.mousebomb.utils
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;

	/**
	 * 对象描述器 用于trace
	 * @author mousebomb mousebomb@gmail.com
	 * created: 2012-10-23 
	 * last modified: 2012-10-23
	 */
	public class ObjectDescribe
	{
		/**
		 * 返回定义过类型的实例的数据<br/>
		 *  方便输出一个Object的内容
		 */
		public static function dumpClassedObj(obj : *, level : int = 0, output : String = "") : String
		{
			var tabs : String = "";
			for ( var i : int = 0 ; i < level ; i++)
				tabs += "\t";
			// 类型描述
			var classInfo : XML = describeType(obj);
			// 变量键
			var vKey : String;
			// 变量类型
			var vType : String;
			// 找到属性、可用的getter
			for each ( var v : XML in classInfo..*.( 
			name() == "variable" || ( 
			name() == "accessor" // 确定可写入数据
			&& attribute("access") != "writeonly" ) 
			) )
			{
				// 记录类型和键
				vType = v.@type;
				vKey = v.@name;
				// 根据类型，不同处理
				switch(vType)
				{
					// 基本类型
					case "int":
					case "Number":
					case "Boolean":
					case "uint":
					case "String":
					case "Date":
					case "Object":
					case "Array":
						output += tabs + "[" + vKey + "] => " + obj[vKey];
						output += "\n";
						break;
					// 复杂类型
					default:
						var childOutput : String = dumpClassedObj(obj[vKey], level + 1);
						if (childOutput != "") output += " {\n" + childOutput + tabs + "}";
						output += "\n";
						break;
				}
			}
			//
			if (level > 20) return "";
			return output;
		}

		/**
		 * 返回一个Object的数据<br/>
		 *  方便输出一个Object的内容
		 */
		public static function dumpDynamicObj(obj : *, level : int = 0, output : String = "") : String
		{
			var tabs : String = "";
			for ( var i : int = 0 ; i < level ; i++)
				tabs += "\t";

			for (var child:* in obj)
			{
				output += tabs + "[" + child + "] => " + obj[child];

				var childOutput : String = dumpDynamicObj(obj[child], level + 1);
				if (childOutput != "") output += " {\n" + childOutput + tabs + "}";

				output += "\n";
			}

			if (level > 20) return "";
			return output;
		}
	}
}
