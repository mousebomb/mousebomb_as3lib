package org.mousebomb.utils
{
	import org.mousebomb.interactive.KeyCode;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	/**
	 * @author Mousebomb
	 * @date 2009-8-28
	 */
	public class SystemStatus extends Sprite
	{
		private var timer : Timer ;
		// 最近一次统计的时刻(1秒前)
		private var statTime : uint;
		// 最近一次统计的帧(0~fps)
		private var statFrame : uint = 0;
		// 累计时间的开始
		private var totalStartTime : uint;
		// 累计帧数
		private var totalFrame : uint = 0 ;
		private var tf : TextField;
		private static var _instance : SystemStatus;

		public static function getInstance() : SystemStatus
		{
			if (_instance == null)
				_instance = new SystemStatus();
			return _instance;
		}

		public function SystemStatus()
		{
			if (_instance != null)
				throw new Error('singleton');
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.ADDED_TO_STAGE, onStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoveStage);
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.start();
			statTime = getTimer();
			tf = new TextField();
			tf.border = true;
			tf.backgroundColor = 0xffffff;
			tf.background = true;
			addChild(tf);
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.mouseEnabled = false;
			this.alpha = .5;
			totalStartTime = getTimer();
		}

		private function onRemoveStage(event : Event) : void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownH);
		}

		private function onKeyDownH(event : KeyboardEvent) : void
		{
			if (event.keyCode == KeyCode.F9)
			{
				visible = !visible;
				// if(visible)
				// {
				// visible = false;
				// timer.stop(); 
				// }
				// else
				// {
				// visible = true;
				// timer.start();
				// }
			}
		}

		override public function set visible(v : Boolean) : void
		{
			super.visible = v;
			if (v)
			{
				timer.start();
			}
			else
			{
				timer.stop();
			}
		}

		private function onStage(event : Event) : void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownH);
		}

		private function onTimer(event : TimerEvent) : void
		{
			if (stage)
			{
				var now : uint = getTimer();
				var delta : uint = now - statTime;
				var fps : uint = statFrame / delta * 1000;
				var totalDelta : uint = now - totalStartTime;
				var totalFps : uint = totalFrame / totalDelta * 1000;
				statTime = now;
				statFrame = 0;
				tf.text = "fps:" + fps + " avg:" + totalFps + "\n";
				tf.appendText("vmVersion:" + System.vmVersion + "\n");
				tf.appendText("player:" + Capabilities.version + " " + Capabilities.playerType);
				if (Capabilities.isDebugger) tf.appendText(" debug");
				tf.appendText("\nmem:" + ((System.totalMemory >> 10) / 1024).toFixed(2) + "MB\n");
				tf.appendText("os:" + Capabilities.os + " " + Capabilities.language + "\n");
				tf.appendText("pageCode:" + System.useCodePage + "\n");
				var stageIntro : String = " @" + stage.stageWidth + "x" + stage.stageHeight ;
				tf.appendText("screenResolution:" + Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY + stageIntro + "\n");
			}
		}

		private function onEnterFrame(event : Event) : void
		{
			++statFrame;
			++totalFrame;
		}
	}
}
