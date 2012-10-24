package org.mousebomb.utils
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;

	/**
	 * 给帧标签加回调 <br/>
	 * 仅用于stage2d的MovieClip
	 * @author mousebomb 
	 */
	public class FrameScript
	{
		public function FrameScript()
		{
		}

		private var _mc : MovieClip;
		private var _frameMap : Object;

		public function init(mc : MovieClip) : void
		{
			_mc = mc ;
			_frameMap = {};
			
			var labels : Array = _mc.currentLabels;
			for each(var label : FrameLabel in labels )
			{
				_frameMap[label.name] = label.frame - 1;
			}
		}

		/**
		 * 添加时间轴代码
		 * @param label 帧标签
		 */
		public function addFrameCallback(label : String, func : Function) : void
		{
			_mc.addFrameScript(_frameMap[label], func);
		}
	}
}
