/**
* 网站全局信息存储
* @author Mousebomb
* @version 1.8.8.20
*/

package org.mousebomb.global{

	public class GlobalInfo 
	{
		/**
		 * 存储任何用户定义字段
		 * 当作as2时代的global对象，灵活性很高很强大
		 */
		public static var customStore:Object = {};
		
		/**
		 * 要加载使用的swf镜像 [{name,...},...] 不想定死Object的格式，但是规则:name是必不可少的，推荐使用name,src
		 */
		public static var subSwfList:Array = [];
		
		/**
		 * 全局待执行函数栈
		 */
		private  static var functionStack:Array = [];
		
		/**
		 * 获取子SWF文件信息,如src
		 * @param	name	name
		 */
		public static function subSwfItem(name:String):Object
		{
			for (var item:* in subSwfList)
			{
				if(subSwfList[item]['name'] == name)
				{
					return subSwfList[item];
				}
			}
			return null;
		}
		/**
		 * 将一个待执行函数压栈,返回压入后待执行函数的个数
		 * (全局待执行函数压栈)
		 */
		public static function pushFunction(func:Function):uint
		{//加上记参数的方法
			return functionStack.push(func);
		}
		/**
		 * (全局待执行函数出栈)
		 */
		public static function get popFunction():Function
		{
			return functionStack.pop();
		}
		/**
		 * 全局待执行函数栈长度
		 */
		public static function get functionStackLen():uint
		{
			return functionStack.length;
		}
	}
	
}