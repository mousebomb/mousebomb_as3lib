package org.mousebomb.ui
{
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	/**
	 * 可用于UIScrollBar内容的容器
	 * @author Mousebomb mousebomb@gmail.com
	 */
	public class ScrollContainer extends Sprite implements IScrollContainer
	{
		//未实现
		private var _scrollWidth : Number;
		private var _scrollHeight : Number;
		private var _scrollV : Number;
		private var _maxScrollV : Number;
		private var _bg : BitmapData;
		private var _content : DisplayObject;

		public function ScrollContainer()
		{
		}

		public function get maxScrollV() : Number
		{
			return _maxScrollV;
		}

		public function get scrollV() : Number
		{
			return _scrollV;
		}

		/**
		 * @param v [1,_maxScrollV]
		 */
		public function set scrollV(v : Number) : void
		{
			_scrollV = v;
			scrollRect = new Rectangle(0, v - 1, _scrollWidth, _scrollHeight);
			trace('set scrollV ,scrollRect: ' + (scrollRect));
		}
		
		/**
		 * 设置显示大小
		 */
		public function setSize(w : Number, h : Number):void
		{
			_scrollWidth = w;
			_scrollHeight = h;
			scrollRect = new Rectangle(0, 0, _scrollWidth, _scrollHeight);
			_scrollV = 0.0;
			validateMaxScroll();
		}

		// 高度
		override public function get height() : Number
		{
			/*
			 * 覆盖为实际显示的高度
			 */
			return _scrollHeight;
		}

		/**
		 * 拖拽区域高度
		 */
		override public function set height(value : Number) : void
		{
			_scrollHeight = value;
			scrollRect = new Rectangle(0, 0, _scrollWidth, _scrollHeight);
//			trace('set height,scrollRect: ' + (scrollRect));
			_scrollV = 0.0;
			validateMaxScroll();
		}

		// 宽度
		override public function get width() : Number
		{
			return _scrollWidth;
		}

		override public function set width(value : Number) : void
		{
			_scrollWidth = value;
			scrollRect = new Rectangle(0, 0, _scrollWidth, _scrollHeight);
//			trace('set width,scrollRect: ' + (scrollRect));
			_scrollV = 0.0;
			validateMaxScroll();
		}

		// 背景
		public function set bg(bg : BitmapData) : void
		{
			_bg = bg;
			validateBg();
		}

		/**
		 * 大小更新
		 */
		public function validateMaxScroll() : void
		{
			if (_content)
			{
				_maxScrollV = 1 + _content.height - _scrollHeight;
			}
			else
			{
				_maxScrollV = 1;
			}
		}

		/**
		 * 重绘背景
		 */
		public function validateBg() : void
		{
			graphics.clear();
			if (_content && _bg)
			{
				graphics.beginBitmapFill(_bg);
				graphics.drawRect(0, 0, _scrollWidth, _content.height);
				graphics.endFill();
			}
		}

		public function validate() : void
		{
			validateMaxScroll();
			validateBg();
		}

		/**
		 * 实际显示内容
		 */
		public function get content() : DisplayObject
		{
			return _content;
		}

		public function set content(content : DisplayObject) : void
		{
			_content = content;
			for (var i : int = numChildren - 1 ; i >= 0 ;--i)
			{
				removeChildAt(i);
			}
			addChild(_content);
		}
	}
}
