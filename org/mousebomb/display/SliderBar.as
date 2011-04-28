package org.mousebomb.display
{
	import flash.events.Event;

	import org.mousebomb.interactive.MouseDrager;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	//值更改
	[Event(name="change", type="flash.events.Event")]
	/**
	 * 滑动条
	 * 别忘了先配置各个属性，
	 * interval
	 * thumbClass
	 * trackClass
	 * toolTip
	 * 使用之前要init
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2011-3-2
	 */
	public class SliderBar extends Sprite
	{
		private var _maxValue : Number = 1.0;
		private var _minValue : Number = .0;
		// 间隔
		public var interval : Number = .1;

		private var _value : Number = .0;


		// **配置的
		// 滑块 应该是中点为注册点的
		public var thumbClass : Class;
		// 轨道
		public var trackClass : Class ;
		// tips
		public var toolTip : IToolTip;

		// 是否纵向 需要配置 暂不支持2011.03.02
		private var _isVertical : Boolean = false;

		private var _track : Sprite;
		private var _thumb : Sprite;

		private var _dragger : MouseDrager;
		private	var _dragRect : Rectangle = new Rectangle();

		/**
		 * 别忘了先配置各个属性，
		 * 使用之前要init
		 */
		public function SliderBar()
		{

		}

		// 初始化，只要做一次
		public function init() : void
		{
			if (_track != null) return;

			_track = new trackClass();
			_thumb = new thumbClass();
			addChild(_track);
			addChild(_thumb);
			_dragger = new MouseDrager(_thumb);
			_thumb.addEventListener(MouseEvent.MOUSE_DOWN, onThumbDown);
			_track.addEventListener(MouseEvent.MOUSE_DOWN, onTrackDown);
		}

		private function onTrackDown(event : MouseEvent) : void
		{
			// 开始拖拽
			_thumb.x = event.localX;
			_dragger.startDrag(_dragRect);
			//
			_thumb.stage.addEventListener(MouseEvent.MOUSE_UP, onThumbUp);
		}

		private function onThumbDown(event : MouseEvent) : void
		{
			// 开始拖拽
			_dragger.startDrag(_dragRect);
			//
			_thumb.stage.addEventListener(MouseEvent.MOUSE_UP, onThumbUp);
		}

		private function onThumbUp(event : MouseEvent) : void
		{
			_dragger.stopDrag();
			var tmpValue : Number = (_thumb.x / width) * (_maxValue - _minValue) + _minValue;
			// 取值为interval的倍数
			var count : int = Math.round(tmpValue / interval);
			value = interval * count;
			//
			_thumb.stage.removeEventListener(MouseEvent.MOUSE_UP, onThumbUp);
		}


		override public function get width() : Number
		{
			return _track.width;
		}

		override public function set width(value : Number) : void
		{
			_track.width = value;
			validateThumb();
			validateRect();
		}

		override public function get height() : Number
		{
			return _track.height;
		}

		override public function set height(value : Number) : void
		{
			_track.height = value;
			validateThumb();
			validateRect();
		}

		/**
		 * 是否纵向
		 */
		public function get isVertical() : Boolean
		{
			return _isVertical;
		}

		public function set isVertical(isVertical : Boolean) : void
		{
			_isVertical = isVertical;
		}

		// 最大值
		public function get maxValue() : Number
		{
			return _maxValue;
		}

		public function set maxValue(maxValue : Number) : void
		{
			_maxValue = maxValue;
			validateThumb();
			validateRect();
		}

		// 根据数据 更新区域
		private function validateRect() : void
		{
			// 起始坐标 x // 最大坐标 width
			// min max
			if (_isVertical)
			{
			}
			else
			{
				_dragRect.left = 0;
				_dragRect.right = width;
			}
		}

		private function validateThumb() : void
		{
			if (_isVertical)
			{

			}
			else
			{
				_thumb.x = (_value - _minValue ) / ( _maxValue - _minValue ) * width;
			}
		}

		// 最小值
		public function get minValue() : Number
		{
			return _minValue;
		}

		public function set minValue(minValue : Number) : void
		{
			_minValue = minValue;
		}

		// 值
		public function get value() : Number
		{
			return _value;
		}

		public function set value(value : Number) : void
		{
			// 导致的UI变动
			_value = value;
			validateThumb();
			var event : Event = new Event(Event.CHANGE);
			dispatchEvent(event);
		}


	}

}
