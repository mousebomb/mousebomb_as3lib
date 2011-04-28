package cn.flashj.multibmp
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2011-1-5
	 */
	public class MBmpStage extends Sprite
	{

		// 交互的监听承载者
		private var _interactiveContainer : DisplayObjectContainer;

		internal var _eventCatcher : MBmpEventCatcher;

		private var _bmdObject : MBmpContainer;

		public function MBmpStage(bmdObject : MBmpContainer)
		{
			_bmdObject = bmdObject;
			addChild(_bmdObject.displayObject);
			_interactiveContainer = this;
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
			this.addEventListener(Event.REMOVED, onLostStage);
			_eventCatcher = new MBmpEventCatcher(this);
		}


		// 从舞台移除的时候解除捕捉
		private function onLostStage(event : Event) : void
		{
			// 以_interactiveContainer为对象
			if (event.target == this)
				_eventCatcher.clearEvents(_interactiveContainer);
		}

		// 加入舞台开始捕捉
		private function onStage(event : Event) : void
		{
			// 以_interactiveContainer为对象
			if (event.target == this)
				_eventCatcher.initEvents(_interactiveContainer);
		}

		/**
		 * 释放资源
		 * 这里会释放渲染和最后渲染的位图，解除对bmdObject的引用。
		 * 但不会调用BmdObject.dispose，以便其他地方使用，若有需要，需要手动释放BmdObject。
		 */
		public function dispose() : void
		{
			_bmdObject.dispose();
			_bmdObject = null;
		}

		public function get eventCatcher() : MBmpEventCatcher
		{
			return _eventCatcher;
		}

		public function get interactiveContainer() : DisplayObjectContainer
		{
			return _interactiveContainer;
		}

		public function set interactiveContainer(v : DisplayObjectContainer) : void
		{
			_interactiveContainer = v;
		}

	}
}
