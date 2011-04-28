package org.mousebomb.ui.Charts 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-2-28
	 */
	public class ChartHotPoint extends Sprite 
	{
		private var _chart : LineChart;
		private var _intro:String;

		public function ChartHotPoint(chart : LineChart ,color:uint, intro : String)
		{
			_chart = chart;
			_intro=intro;
			graphics.lineStyle(1, 0xffffff, 1);
			graphics.beginFill(color);
			graphics.drawCircle(0, 0, 6);
			graphics.endFill();
			this.addEventListener(MouseEvent.ROLL_OVER, onOver);			this.addEventListener(MouseEvent.ROLL_OUT, onOut);
		}

		private function onOver(event : MouseEvent) : void
		{
			scaleX = 1.3;			scaleY = 1.3;
			_chart.tip.show(_intro);		}

		private function onOut(event : MouseEvent) : void
		{
			scaleX = 1;
			scaleY = 1;
			_chart.tip.hide();
		}
	}
}
