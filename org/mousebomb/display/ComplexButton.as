/**
* 复杂一点的按钮,由于SimpleButton不支持Child所以加上的
* @author Mousebomb
* @version 1.8.9.21
*/

package org.mousebomb.display 
{
	import flash.display.MovieClip;
	import flash.events.EventDispatcher;
	import flash.events.*;

	public class ComplexButton extends MovieClip
	{
		
		/**
		 * 由于SimpleButton不支持child 所以我用MovieClip做基类
		 */
		protected var FRAME_NORMAL:uint=1;
		protected var FRAME_NORMAL_E:uint=10;
		protected var FRAME_OVER:uint = 11;
		protected var FRAME_OVER_E:uint = 20;
		protected var FRAME_OUT:uint = 21;
		protected var FRAME_OUT_E:uint = 30;
		protected var FRAME_PRESS:uint = 31;
		protected var FRAME_PRESS_E:uint = 40;
		protected var FRAME_RELEASE:uint = 41;
		protected var FRAME_RELEASE_E:uint = 50;
		
		public function ComplexButton():void
		{
			init();
		}

		protected function init() : void
		{
			this.addEventListener(Event.ADDED_TO_STAGE,add2Stage);
			this.addEventListener(MouseEvent.ROLL_OVER,rollOverH);
			this.addEventListener(MouseEvent.ROLL_OUT,rollOutH);
			this.addEventListener(MouseEvent.MOUSE_DOWN,pressH);
			this.addEventListener(MouseEvent.MOUSE_UP,releaseH);
			this.addFrameScript(
				FRAME_NORMAL_E-1,normalE,
				FRAME_OUT_E-1,rolloutE,
				FRAME_OVER_E-1,rolloverE,
				FRAME_PRESS_E-1,pressE,
				FRAME_RELEASE_E-1,releaseE
			);
		}
		private function add2Stage(e:Event):void
		{
			this.gotoAndPlay(FRAME_NORMAL);
		}
		private function rollOverH(e:MouseEvent):void
		{
			this.rollOver();
		}
		private function rollOutH(e:MouseEvent):void
		{
			this.rollOut();
		}
		private function pressH(e:MouseEvent):void
		{
			this.press();
		}
		private function releaseH(e:MouseEvent):void
		{
			this.release();
		}
		private function normalH(e:MouseEvent):void
		{
			this.normal();
		}
		
		protected function normal():void
		{
			this.gotoAndPlay(FRAME_NORMAL);
		}
		protected function normalE():void
		{
			this.stop();
		}
		protected function release():void
		{
			this.gotoAndPlay(FRAME_RELEASE);
		}
		protected function releaseE():void
		{
			this.gotoAndPlay(FRAME_NORMAL);
		}
		protected function press():void
		{
			this.gotoAndPlay(FRAME_PRESS);
		}
		protected function pressE():void
		{
			this.stop();
		}
		protected function rollOut():void
		{
			this.gotoAndPlay(FRAME_OUT);
		}
		protected function rolloutE():void
		{
			this.gotoAndStop(FRAME_NORMAL);
		}
		protected function rollOver():void
		{
			this.gotoAndPlay(FRAME_OVER);
		}
		protected function rolloverE():void
		{
			this.stop();
		}
	}
	
}
