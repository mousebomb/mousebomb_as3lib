package org.mousebomb.bmpdisplay 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-6-23
	 */
	public class EventCatcher extends Object 
	{
		//bmp
		private var _bmpStage : BmpDisplayObject;
		//bmpOffsetPos是Bmp在flash舞台上的偏移,以我的0,0来转化
		private var _bmpOffsetPos : Point;

		public function EventCatcher(bmp : BmpDisplayObject)
		{
			_bmpStage = bmp;
		}

		/**
		 * 开始事件捕捉
		 * 我要提供对象检索、监听舞台
		 */
		internal function initEvents(s : DisplayObjectContainer) : void
		{
			s.addEventListener(MouseEvent.MOUSE_UP, onMouseClick);
			s.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			//首次计算位图本身的舞台偏移
			calcBmpOffsetPos();
		}

		/**
		 * 清除事件捕捉，释放舞台的监听
		 */
		internal function clearEvents(s : DisplayObjectContainer) : void
		{
			s.removeEventListener(MouseEvent.MOUSE_UP, onMouseClick);			s.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			//置空鼠标在的对象
			_hoverObject = null;
		}

		/**
		 * 每次位图的位置变化，都要重新计算一次。
		 * 用于鼠标事件的坐标转换
		 */
		internal function calcBmpOffsetPos() : void
		{
			//bmpOffsetPos是Bmp在flash舞台上的偏移,以我的0,0来转化
			_bmpOffsetPos = _bmpStage.localToGlobal(new Point(0, 0));
		}

		//存储注册了相关事件的对象表,键名是我的内部事件常量，而不是BmdEvent的常量
		private var _dispatchers : Object = {};

		//表示click事件的对象表
		private const CLICK : String = "Click";
		//表示OVER和out的对象表——因为这两个要并集处理
		private const OVER_OUT : String = "OverOut";

		/**
		 * 增加对一个对象的捕捉
		 * @param target 对象
		 * @param type 事件类型
		 */
		internal function addDispatcher(target : IBmdEventDispatcher,type : String) : void
		{
			var dispType : String = eventType2dispatcherType(type);
			if(_dispatchers[dispType] == null)
			{
				_dispatchers[dispType] = [];
			}
			(_dispatchers[dispType] as Array).push(target);			//排序
			(_dispatchers[dispType] as Array).sortOn("displayIndex", Array.NUMERIC);
		}

		/**
		 * 事件类型转化得到捕捉类型
		 * CLICK -> Click
		 * over || out -> OverOut
		 */
		private function eventType2dispatcherType(type : String) : String
		{
			switch(type)
			{
				case BmdEvent.MOUSE_CLICK:
					return CLICK;
					break;				case BmdEvent.MOUSE_OVER:				case BmdEvent.MOUSE_OUT:
					return OVER_OUT;
					break;
				default : 
					throw new Error("事件类型异常");
			}
			return "";
		}

		/**
		 * 移除对一个对象的捕捉
		 * @param type 如果留空则表示移除所有类型的监听
		 */
		internal function removeDispatcher(target : IBmdEventDispatcher,type : String = "") : void
		{
			if(type)
			{	
				removeTypeDispatcher(target, type);
			}
			else
			{
				for(var dispType : String in _dispatchers)
				{
					//key 是所有注册过的内部事件名
					var list : Array = (_dispatchers[dispType] as Array);
					var index : int = list.indexOf(target);
					if(index != -1)
					{
						list.splice(index, 1);
					}
				}
			}
		}

		/**
		 * 实际的移除某个类型的某个对象监听
		 */
		private function removeTypeDispatcher(target : IBmdEventDispatcher,type : String) : void
		{
			var dispType : String = eventType2dispatcherType(type);
			var list : Array = (_dispatchers[dispType] as Array);
			var index : int = list.indexOf(target);
			if(index != -1)
			{
				list.splice(index, 1);
			}
		} 

		/**
		 * 在舞台的事件触发后捕获BmdObject
		 */
		private function onMouseClick(event : MouseEvent) : void
		{
			//从注册了相关事件且在屏幕内的对象表中捕捉对象
			//计算鼠标坐标对应到Bmp之后的值
			//鼠标的舞台坐标减去这个偏移，得到鼠标在bmp中的坐标			
			var typeDispatcherArr : Array = _dispatchers[CLICK];
			if(typeDispatcherArr == null)return;
			var mousePos : Point = new Point(event.stageX - _bmpOffsetPos.x, event.stageY - _bmpOffsetPos.y);
			for(var i : int = typeDispatcherArr.length - 1;i >= 0;--i)
			{
				var item : BmdObject = typeDispatcherArr[i];
				if(item.display && item.hitTestPoint(mousePos.x, mousePos.y))
				{
					var bmdEvent : BmdEvent = new BmdEvent(BmdEvent.MOUSE_CLICK, item);
					item.dispatchEvent(bmdEvent);
					return;
				}
			}
		}

		//记录当前鼠标指针在谁上面 ，记录以触发out事件		private var _hoverObject : BmdObject;

		private function onMouseMove(event : MouseEvent) : void
		{
			//捕捉
			var mousePos : Point = new Point(event.stageX - _bmpOffsetPos.x, event.stageY - _bmpOffsetPos.y);
			var item : BmdObject;
			var bmdEvent : BmdEvent;
			//先处理移出
			if(_hoverObject != null)
			{
				if(_hoverObject.hitTestPoint(mousePos.x, mousePos.y))
				{
				//若此前鼠标指向的目标还在鼠标下,则无视
				}
				else
				{
					//若目标不在鼠标下，则看作移出
					bmdEvent = new BmdEvent(BmdEvent.MOUSE_OUT, _hoverObject);
					//					trace("out");
					_hoverObject.dispatchEvent(bmdEvent);
					//记录 item被鼠标指出去了
					_hoverObject = null;
				}
			}
			//再处理移入
			for each(item in _dispatchers[OVER_OUT])
			{
				if(item.display && item.hitTestPoint(mousePos.x, mousePos.y))
				{
					if(_hoverObject == item)
					{
					//之前已经移上来了，此刻只是内部移动
					}
					else
					{
						//如果之前有对象被指上，则先触发那个对象的移出
						if(_hoverObject != null)
						{
							bmdEvent = new BmdEvent(BmdEvent.MOUSE_OUT, _hoverObject);
							_hoverObject.dispatchEvent(bmdEvent);
//					trace("goto other");
						}
						//触发移入
						bmdEvent = new BmdEvent(BmdEvent.MOUSE_OVER, item);
						//					trace("over");
						item.dispatchEvent(bmdEvent);
						//记录 item被鼠标指上去了
						_hoverObject = item;
					}
				}
			}
		}
	}
}
