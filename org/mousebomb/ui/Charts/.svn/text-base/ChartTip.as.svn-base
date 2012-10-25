package org.mousebomb.ui.Charts 
{
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-2-28
	 */
	public class ChartTip extends Sprite 
	{
		private	var tf : TextField;

		public function ChartTip()
		{
			tf = new TextField();
			tf.mouseEnabled = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.height = 1;
			tf.width = 1;
			tf.x = 0;
			tf.y = 0;
			tf.text = "";
			addChild(tf);
			tf.visible = false;
		}

		public function setSize(_w : Number,_h : Number) : void
		{
			graphics.clear();
			graphics.beginFill(0xf4f4f4);			graphics.lineStyle(1, 0xcccccc);
			graphics.drawRoundRect(0, 0, _w, _h, 8);
			graphics.endFill();
		}

		public function show(intro : String) : void
		{
			x = parent.mouseX;
			y = parent.mouseY-22;
			tf.visible = true;
			tf.text = intro;
			setSize(tf.width, tf.height);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}

		public function hide() : void
		{
			tf.visible = false;
			graphics.clear();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseMove(event : MouseEvent) : void
		{
			x = parent.mouseX;
			y = parent.mouseY-22;
		}
	}
}
