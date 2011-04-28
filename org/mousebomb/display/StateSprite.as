package org.mousebomb.display 
{
	import flash.display.Sprite;

	/**
	 * 带有state的Sprite，用来做可切换state的容器
	 * 实现类似Flex里state的功能
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-3-22
	 */
	public class StateSprite extends Sprite 
	{
		//当前的state
		private var _curState : String;
		//state 映射表
		protected var _stateMap : Object = {};

		public function StateSprite()
		{
		}

		/**
		 * 注册state
		 * @param state 唯一名称,若有重复则覆盖
		 * @param childList 所需要的child的数组，每一项是一个DisplayObject,按照顺序来
		 */
		public function regState(state : String,childList : Array) : void
		{
			_stateMap[state] = childList;
		}

		/**
		 * 切换state
		 * @param state 注册过的state
		 */
		public function switchState(state : String) : void
		{
			//检查是否需要切换，不需要切换则跳出
			if(_curState == state)
			{
				return ;
			}
			//检查是否有注册过对应的childList
			var childList : Array = _stateMap[state];
			if(null == childList)
			{
				throw new Error("StateSprite.switchState出错,未注册的state:" + state);
				return;
			}
			//清掉所有内容
			for(var i : int = numChildren - 1;i >= 0 ;--i)
			{
				removeChildAt(i);
			}
			//增加内容
			for each(var arrItem : * in childList)
			{
				addChild(arrItem);
			}
			_curState = state;
		}

		public function get curState() : String
		{
			return _curState;
		}
	}
}
