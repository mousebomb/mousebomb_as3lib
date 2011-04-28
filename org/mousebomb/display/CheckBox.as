package org.mousebomb.display
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;

/**
 * 
 * 复选框
 * 使用说明：
 * 显示对象继承自我
 */
	public class CheckBox extends MovieClip 
	{
		public var right:DisplayObject;
		public var btn:SimpleButton;
		
		private var _checked:Boolean=false;

		public function get checked():Boolean
		{
			return _checked;
		}
		public function CheckBox():void {
			init();
		}
		public function init():void {
			this.stop();
			btn.useHandCursor=false;
			right.visible=_checked;
			btn.addEventListener(MouseEvent.CLICK,btnHandler);
			btn.addEventListener(MouseEvent.MOUSE_OVER,btnOverHandler);
			btn.addEventListener(MouseEvent.MOUSE_OUT,btnOutHandler);
		}

		private function btnHandler(e:MouseEvent):void {
			_checked=!_checked;
			right.visible=_checked;
			btnOutHandler(e);
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		public function checkMe(ck:Boolean=true) {
			_checked=ck;
			right.visible=_checked;
		}
		private function btnOverHandler(e:MouseEvent):void {
			this.gotoAndStop(2);
		}
		private function btnOutHandler(e:MouseEvent):void {
			this.gotoAndStop(1);
		}
	}
}