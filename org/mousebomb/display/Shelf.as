package org.mousebomb.display
{
	import flash.display.Sprite;

	/**
	 * 二维架子容器
	 * @author mousebomb mousebomb@gmail.com
	 * 
	 * 必须配置的：
	 * 	marginX
	 * 	marginY
	 * 	pageCount
	 * 	cols
	 * 	liClass
	 * 	onLiClick
	 * 
	 */
	public class Shelf extends Sprite
	{
		// 数据 arrayOrVector
		private var _voArray : *;

		public var marginX : Number = 20.0;
		public var marginY : Number = 20.0;
		// 每页显示多少条
		public var pageCount : int = 9;
		// 多少列
		public var cols : int = 3;
		public var liClass : Class;

		public var onLiClick : Function;

		public function Shelf()
		{
		}

		public function init() : void
		{
		}

		// 设置内容
		public function setList(arrayOrVector : *) : void
		{
			_voArray = arrayOrVector;
			_totalPage = Math.ceil(_voArray.length / pageCount);
			showPage(1);
		}


		public function addLi(vo : *) : *
		{
			var li : * = new liClass();
			li.liData = vo;
			li.onClick = onLiClick;
			li.x = (numChildren % cols) * marginX;
			li.y = int(numChildren / cols) * marginY;
			addChild(li);
			return li;
		}

		public function cls() : void
		{
			for (var i : int = numChildren - 1;i >= 0;--i)
			{
				removeChildAt(i);
			}
		}

		private var _curPage : int = 0;
		private var _totalPage : int = 0;

		public function showPage(p : int) : void
		{
			cls();
			var start : int = (p - 1) * pageCount;
			var limit : int = p * pageCount;
			limit = limit < _voArray.length ? limit : _voArray.length;
			for (var i : int = start ; i < limit ; i++)
			{
				addLi(_voArray[i]);
			}
			_curPage = p;
		}

		public function get totalPage() : int
		{
			return _totalPage;
		}

		public function get curPage() : int
		{
			return _curPage;
		}

	}
}
