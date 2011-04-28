package cn.flashj.multibmp
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2011-1-6
	 */
	public class MBmpEventCatcher
	{
		//
		protected var _stage : MBmpStage;


		public function MBmpEventCatcher(stage : MBmpStage)
		{
			_stage = stage;
		}

		// 记录当前鼠标指针在谁上面 ，记录以触发out事件
		private var _hoverObject : MBmpEventDispatcher;

		/**
		 * 开始事件捕捉
		 * 我要提供对象检索、监听舞台
		 */
		internal function initEvents(s : DisplayObjectContainer) : void
		{
			trace("initEvent");
			s.addEventListener(MouseEvent.MOUSE_UP, onMouseClick);
			s.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}

		/**
		 * 清除事件捕捉，释放舞台的监听
		 */
		internal function clearEvents(s : DisplayObjectContainer) : void
		{
			trace("clearEvent");
			s.removeEventListener(MouseEvent.MOUSE_UP, onMouseClick);
			s.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			// 置空鼠标在的对象
			_hoverObject = null;
		}


		/**
		 * 在舞台的事件触发后捕获MBmpEventDispatcher
		 */
		private function onMouseClick(event : MouseEvent) : void
		{
			var clickedItems : Array = _stage.getObjectsUnderPoint(new Point(event.stageX, event.stageY));
			var len : int = clickedItems.length;
			for (var i : int = len - 1; i >= 0;--i)
			{
				var item : * = clickedItems[i];
				if (item is RefBitmap)
				{
					var bo : IMBmpEventDispatcher = item.mbRef ;
					if (bo.hasListener(MBmpEvent.MOUSE_CLICK))
					{
						var bmdEvent : MBmpEvent = new MBmpEvent(MBmpEvent.MOUSE_CLICK, bo);
						bo.dispatchEvent(bmdEvent);
						return;
					}
				}
			}
		}

		private function onMouseMove(event : MouseEvent) : void
		{// TODO 以后加入 鼠标移入、移出
		}
	}
}
