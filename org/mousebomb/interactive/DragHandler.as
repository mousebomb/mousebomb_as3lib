package org.mousebomb.interactive
{
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * 拖拽器,由一个句柄拖拽整个物件
	 * 基于MouseDrager
	 * 一定要调用init才生效
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2011-3-3
	 */
	public class DragHandler 
	{
		//拖拽
		private var _dragger : MouseDrager;
		//被拖拽的界面
		private var _panel : DisplayObject;
		//拖拽物句柄
		private var _dragHandler: DisplayObject;
		private var _rect : Rectangle;

		public function DragHandler()
		{}
		
		/**
		 * @param handler 拖拽句柄
		 * @param panel 被拖拽面板
		 * @param rect 可拖范围
		 */
		public function init(handler :DisplayObject,panel : DisplayObject,rect : Rectangle=null):void
		{
			_dragHandler = handler;
			_rect = rect;
			_panel = panel;
			_dragger = new MouseDrager(panel);
			_dragHandler.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			_dragHandler.addEventListener(Event.REMOVED, onRemove);
		}

		private function onRemove(event : Event) : void
		{
			_dragger.stopDrag();
		}

		private function onMouseDown(event : MouseEvent) : void
		{
			_dragger.startDrag(_rect);
			_dragHandler.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

		private function onMouseUp(event : MouseEvent) : void
		{
			_dragger.stopDrag();
			_dragHandler.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}

	}
}
