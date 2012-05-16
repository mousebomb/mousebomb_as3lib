package org.mousebomb.display
{
	import flash.events.MouseEvent;
	import flash.display.MovieClip;

	/**
	 * 可按下（激活）的按钮 选项卡用
	 * 代理器
	 * @author Mousebomb mousebomb@gmail.com
	 * @date 2012-3-12
	 */
	public class TabOptionButton
	{

		// 要代理的
		private var _mc:MovieClip;

		// 是否已经按下（激活）
		private var _toogled:Boolean;
		// 我所属的组id
		private var _belongsToGroup:String;

		// 组对象存储
		private static var groups:Object = {};
		// 当前选中的组对象
		private static var curToogled:Object = {};

		/**
		 * 当前按下（激活）的选项卡
		 */
		public static function getCurToogled( groupId:String ):TabOptionButton
		{
			return curToogled[groupId];
		}

		public var HOVER:int = 2;
		public var TOOGLED:int = 3;
		public var NORMAL:int = 1;

		/**
		 * @param mc 提供被代理的显示对象
		 * @param radioGroup 如果是单选，则提供一个唯一组id
		 */
		public function TabOptionButton( mc:MovieClip, radioGroup:String = "" )
		{
			_mc = mc;
			_mc.stop();
			_mc.addEventListener( MouseEvent.CLICK, onClick );
			_mc.buttonMode = true;
			_mc.addEventListener( MouseEvent.ROLL_OVER, onOver );
			_mc.addEventListener( MouseEvent.ROLL_OUT, onOut );
			addToGroup( radioGroup );
		}

		private function onOver( event:MouseEvent ):void
		{
			_mc.gotoAndStop( HOVER );
		}

		private function onOut( event:MouseEvent ):void
		{
			_mc.gotoAndStop( _toogled ? TOOGLED : NORMAL );
		}

		public function addToGroup( groupId:String ):void
		{
			if(groupId)
			{
				if(groups[groupId] == null)
					groups[groupId] = [];
				var curGroup:Array = groups[groupId];
				curGroup.push( this );
				_belongsToGroup = groupId;
			}
		}

		private function onClick( event:MouseEvent ):void
		{
			toogled = true;
		}

		public function get toogled():Boolean
		{
			return _toogled;
		}

		public function set toogled( toogled:Boolean ):void
		{
			// 检测 如果有在组里，则一组取消其他选择
			validateGroupToogled();
			// 设置自身的
			_toogled = toogled;
			_mc.gotoAndStop( _toogled ? TOOGLED : NORMAL );
		}

		/**
		 * 验证其他item的反激活
		 */
		internal function disableOtherToogled():void
		{
			_toogled = false;
			_mc.gotoAndStop( NORMAL );
		}

		/**
		 * validate others at the same group when This is been modified.
		 */
		private function validateGroupToogled():void
		{
			var curGroup:Array = groups[_belongsToGroup];
			// 如果在组里
			if(curGroup)
			{
				for each(var item : TabOptionButton in curGroup)
				{
					item.disableOtherToogled();
				}
				//记录自己
				curToogled[_belongsToGroup] = this;
			}

		}



	}
}
