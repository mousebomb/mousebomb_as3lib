package org.mousebomb.global 
{

	/**
	 * 全局的门面
	 * A的任务完成了，A通过我大叫一声。
	 * B需要了解A的任务是否完成，只要从我这里获取。
	 * @version 1.9.8.17
	 * @author Mousebomb
	 */
	public class GlobalFacade  
	{
		//[name:[handler,...],...]
		private static var listeners : Array = [];

		public function GlobalFacade()
		{
			throw(new Error("Static only"));
		}

		/**
		 * 发送通告
		 * @param data 数据
		 * @param name 通告类型名
		 */
		public static function sendNotify(name : String,sender : *,data : *=  null) : void
		{
			var notify : Notify = new Notify(name, sender, data);
			for each(var handler:Function in listeners[name] as Array)
			{
				handler(notify);
			}
		}

		public static function hasListener(notifyName : String,handler : Function) : Boolean
		{
			if(listeners[notifyName])
			{
				var index : int = (listeners[notifyName] as Array).indexOf(handler);
				if(index != -1)
					return true;
			}
			return false;
		}

		/**
		 * 注册对通告的监听.
		 * 当触发时将回调handler(Notify)
		 */
		public static function regListener(notifyName : String,handler : Function) : void
		{
			//若此name已经有监听，则push，若无则创建再push
			if(!listeners[notifyName])
			{
				listeners[notifyName] = [];
			}
			(listeners[notifyName] as Array).push(handler);
		}

		/**
		 * 移除监听.
		 * 不移除的话就等着内存耗尽吧
		 */
		public static function removeListener(notifyName : String,handler : Function) : void
		{
			//若有此name的监听则移除其中handler一项
			if(listeners[notifyName])
			{
				var index : int = (listeners[notifyName] as Array).indexOf(handler);
				if(index != -1)
				{
					(listeners[notifyName] as Array).splice(index, 1);
				}
			}
		}
	}
}
