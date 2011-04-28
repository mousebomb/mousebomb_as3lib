package cn.flashj.multibmp
{

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * 树枝级显示容器
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2011-1-5
	 */
	public class MBmpContainer extends MBmpObject
	{
		public function MBmpContainer()
		{
			super();
			_sprite = new Sprite();
			_sprite.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(event : Event) : void
		{
			validateDepth();
		}

		// 真容器
		private var _sprite : Sprite;

		private var _childrenList : Array = [];


		override public function get displayObject() : DisplayObject
		{
			return _sprite;
		}

		public function get numChildren() : int
		{
			return _childrenList.length;
		}

		/**
		 * 遍历所有子级执行
		 */
		internal function foreachLevelChild(func : Function) : void
		{
			for (var i : int = numChildren - 1;i >= 0;--i)
			{
				var child : MBmpObject = getChildAt(i);
				func(child);
				if (child is MBmpContainer)
				{
					(child as MBmpContainer).foreachLevelChild(func);
				}
			}
		}

		public function setChildIndex(child : MBmpObject, index : int) : void
		{
			var oldindex : int = _childrenList.indexOf(child);
			_childrenList.splice(oldindex, 1);
			_childrenList.splice(index, 0, child);
			//
			commitDepthChange();
		}

		public function getChildIndex(child : MBmpObject) : int
		{
			return _childrenList.indexOf(child);
		}

		public function getChildAt(index : int) : MBmpObject
		{
			return _childrenList[index];
		}

		/**
		 * 设置子显示列表
		 * 通常用于层级排序后的写入操作
		 * 	(如果用setChildIndex的方法，会浪费开销在数组的splice上，所以在外面把层级排好后设置进来)
		 * 注意：此方法直接设置子级列表 @param list 的元素应该是我的现有子级。
		 * @param verify 是否校验list的每一项是否是子级，默认因为效率原因不做校验，这要求调用者必须保证数据完整性
		 * （校验的消耗太大：1560个对象的排序，如果有校验耗时20ms，无校验耗时0ms）
		 */
		public function setChildList(list : Array, verify : Boolean = false) : void
		{
			if (list.length != _childrenList.length)
			{
				throw new Error("设置子级显示列表错误：子级数量不匹配");
				return ;
			}
			if (verify)
			{
				// 若需要校验，则检查每一项是否都是我现有子级
				for each (var child : * in list)
				{
					if (_childrenList.indexOf(child) == -1)
					{
						throw new Error("设置子显示列表校验失败:不存在的child");
						return;
					}
				}
			}
			_childrenList = list;
			commitDepthChange();
		}

		// 深度变化计数器
		private var _depthChange : uint;

		/**
		 * 提交改动，将会在下一帧设置
		 */
		internal function commitDepthChange() : void
		{
			_depthChange++;
		}

		public function validateDepth() : void
		{
			if (_depthChange)
			{
				_depthChange = 0;
				// 开始处理
				var maxI : int = this.numChildren;
				// 要处理成 顺序等于arr里的样子
				for (var i : int = 0;i < maxI;i++)
				{
					// 目标显示对象
					var child : MBmpObject = this.getChildAt(i);
					if (child.depth != i)
					{
						// 实际操作
						child.depth = i;
						_sprite.setChildIndex(child.displayObject, i);
					}
				}
				// trace(totalObjCount + "个对象");
			}
		}


		/**
		 * 加子级
		 */
		public function addChild(child : MBmpObject) : void
		{
			// 若已经存在，则忽略
			if (_childrenList.indexOf(child) > -1)
			{
				return ;
			}
			_childrenList.push(child) ;
			// 设置父容器引用
			child.setParent(this);
			_sprite.addChild(child.displayObject);
			child.validatePos();
		}

		/**
		 * 移除的时候会自动去除child的所有监听
		 * 所以若有需要，高层需要重新加入监听
		 */
		public function removeChild(child : MBmpObject) : void
		{
			var index : int = _childrenList.indexOf(child);
			if (index == -1)
			{
				trace("not my child");
				return;
			}
			_childrenList.splice(index, 1);
			//
			child.setParent(null);
			//
			_sprite.removeChild(child.displayObject);
		}

		/**
		 * 释放资源;
		 * 清除子级;
		 * 若有父级，则自动从父级移除
		 */
		public override function dispose() : void
		{
			// 这里要加入对自己和子级的释放
			for (var i : int = numChildren - 1;i >= 0;--i)
			{
				var child : MBmpObject = getChildAt(i);
				child.dispose();
			}
			//
			_sprite.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			// super
			super.dispose();
		}


	}
}
