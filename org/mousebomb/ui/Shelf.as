package org.mousebomb.ui
{
	import flash.display.Sprite;
import flash.geom.Rectangle;

/**
	 * 二维架子容器
	 *  更加纯粹，提供回调整合数据，不再以继承做主要扩展方式
	 * @author Mousebomb mousebomb@gmail.com
	 * @date 2011-11-24 / 2011-12-13 
	 * 
	 * 
	 * 必须配置的：
	 * 	marginX
	 * 	marginY
	 * 	pageCount
	 * 	cols
	 * 	liClass
	 * 	addLiCallback
	 * 	
	 * rn:
	 * 2011-12-13 加入数据更新后页码恢复
	 */
	public class Shelf extends Sprite
	{
		// 数据 arrayOrVector
		private var _voArray:*;

		public var marginX:Number = 20.0;
		public var marginY:Number = 20.0;
		// 每页显示多少条
		public var pageCount:int = 9;
		// 多少列
		public var cols:int = 3;
		public var liClass:Class;
		// 是否记住当前页码，在数据刷新后依然尝试显示最接近的页
		public var rememberPage:Boolean = true;

		/**
		 * 用来设置数据绑定和监听的，通常给Mediator用
		 * 接受2个参数: li:列表显示对象,vo:对应的数据
		 */
		public var addLiCallback:Function;

		public function Shelf()
		{
		}

		/**
		 * 配置全部数据
		 * 如果不需要全部配置，可以手动设置变量
		 * @param addLiCallback_ 接受2个参数: li:列表显示对象,vo:对应的数据
		 */
		public function config( marX:Number, marY:Number, pageCount_:int, cols_:int, liClass_:Class, addLiCallback_:Function,rememberPage_:Boolean=true ):void
		{
			marginX = marX;
			marginY = marY;
			pageCount = pageCount_;
			cols = cols_;
			liClass = liClass_;
			addLiCallback = addLiCallback_;
			rememberPage=rememberPage_;
		}

        /**
         * 自动配置数据
         * 很长时间以来，手动配置那些参数总要计算区域，这里直接输入区域大小等信息，自动计算
         * @param shelfRect 此shelf在其容器中的距形区域
         */
        public function autoConfig(shelfW:Number,shelfH:Number,liW:Number,liH:Number,cols_:int,rows_:int, liClass_:Class, addLiCallback_:Function,rememberPage_:Boolean=true ):void
        {
            marginX = shelfW/cols_;
            marginY = shelfH/rows_;
            pageCount = cols_*rows_;
            cols = cols_;
            liClass = liClass_;
            addLiCallback = addLiCallback_;
            rememberPage = rememberPage_;
        }


		/**
		 * 设置内容
		 *  设置完成后尝试设置页码
		 *  
		 */
		public function setList( arrayOrVector:* ):void
		{
			_voArray = arrayOrVector;
			_totalPage = Math.ceil( _voArray.length / pageCount );
			if(rememberPage && _curPage > 0)
			{
				// 要记住页码，且已经设置过页码
				// 尝试设置最近一次设置过的页码
				if(totalPage > 0)
				{
					if(_curPage <= totalPage)
						showPage( curPage );
					else
						showPage( totalPage );
				}else{
					_curPage=1;
					cls();
				}
			}
			else
				showPage( 1 );
		}

		/**
		 * @param callback 用来设置数据绑定和监听的，通常给Mediator用
		 */
		public function addLi( vo:*, callback:Function ):*
		{
			var li:* = new liClass();
			li.x = (numChildren % cols) * marginX;
			li.y = int( numChildren / cols ) * marginY;
			if(addLiCallback != null)
				callback( li, vo );
			addChild( li );
			return li;
		}

		public function cls():void
		{
			for(var i:int = numChildren - 1;i >= 0;--i)
			{
				removeChildAt( i );
			}
		}

		private var _curPage:int = 0;
		private var _totalPage:int = 0;

		/**
		 * 显示页码内的内容
		 *  信任输入参数
		 */
		public function showPage( p:int ):void
		{
			cls();
			var start:int = (p - 1) * pageCount;
			var limit:int = p * pageCount;
			limit = limit < _voArray.length ? limit : _voArray.length;
			for(var i:int = start ; i < limit ; i++)
			{
				addLi( _voArray[i], addLiCallback );
			}
			_curPage = p;
		}

		public function nextPage():void
		{
			if(_curPage < _totalPage) showPage( _curPage + 1 );
		}

		public function prevPage():void
		{
			if(_curPage > 1) showPage( _curPage - 1 );
		}

		public function get totalPage():int
		{
			return _totalPage;
		}

		public function get curPage():int
		{
			return _curPage;
		}
	}
}
