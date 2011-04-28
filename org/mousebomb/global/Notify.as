package org.mousebomb.global 
{

	/**
	 * 配合全局门面
	 * 使用的通知结构
	 * @author Mousebomb
	 */
	public class Notify extends Object 
	{
		//通知名
		public var name : String = "";
		//发送者		public var target : *;
		//携带数据		public var data : *;

		/**
		 * @param name 通知名
		 * @param target 通知发送者
		 * @param data	携带数据
		 */
		public function Notify(name : String,target : *,data : *)
		{
			this.name = name;
			this.target = target;
			this.data = data;
		}
	}
}
