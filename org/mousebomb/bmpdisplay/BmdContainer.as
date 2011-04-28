package org.mousebomb.bmpdisplay 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * Bmd可承载子Bmd的容器
	 * 类似DisplayObjectContainer
	 * @author Mousebomb
	 * @date 2009-6-17
	 */
	public class BmdContainer extends BmdObject 
	{
		private var _childrenList : Array = [];
		//联合体
		protected var _combined : Boolean = false;

		public function BmdContainer()
		{
		}

		public function get numChildren() : int
		{
			return _childrenList.length;
		}

		/**
		 * 设置父级（或更换父级）\
		 * 此时即ADDED
		 */
		override internal function setParent(parent : BmdContainer) : void 
		{
			/*
			 * 设置父级引用，
			 * 同时要计算global坐标
			 */
			_parent = parent;
			//先把需要做的处理做掉
			if(needValidate)
				realValidateRect();
			//坐标
			var pos : Point = localToGlobal();
			var globalXAdd : Number = pos.x - _globalX;
			var globalYAdd : Number = pos.y - _globalY;
			_globalX = pos.x;
			_globalY = pos.y;
			//让子级坐标全局换算
			foreachLevelChild(function(bo : BmdObject):void
			{
				bo._globalX += globalXAdd;
				bo._globalY += globalYAdd;
			});
		}

		/**
		 * 设置舞台引用
		 * 此时即ADD_TO_STAGE
		 */
		internal override function setStage(v : BmpDisplayObject) : void
		{
			super.setStage(v);
			//这里要加入对自己和子级的维护
			for(var i : int = numChildren - 1;i >= 0;--i)
			{
				var child : BmdObject = getChildAt(i);
				child.setStage(v);
			}
		}

		public function addChild(child : BmdObject) : void
		{
			//若已经存在，则将他位置放到末尾
			if(_childrenList.indexOf(child) > -1)
			{
				setChildIndex(child, numChildren - 1);
			}
			else
			{
				_childrenList.push(child);
			}
			//设置父容器引用
			child.setParent(this);
			//设置Bmp舞台引用
			child.setStage(bmpStage);
			//检测是否显示
			child.validateDisplay();
			//每次被addChild之后层级发生变化，调用渲染
			callReRender();
		}

		public function addChildAt(child : BmdObject,index : int) : void
		{
			//若已经存在，则将他位置切换
			if(_childrenList.indexOf(child) > -1)
			{
				setChildIndex(child, index);
			}
			else
			{
				_childrenList.splice(index, 0, child);
			}
			child.setParent(this);
			child.setStage(bmpStage);
			//检测是否显示
			child.validateDisplay();
			//每次被addChild之后层级发生变化，调用渲染
			callReRender();
		}

		public function getChildAt(index : int) : BmdObject
		{
			return _childrenList[index];
		}

		/**
		 * 移除的时候会自动去除child的所有监听
		 * 所以若有需要，高层需要重新加入监听
		 */
		public function removeChild(child : BmdObject) : void
		{
			//从舞台移除会同时移除监听
			child.removeAllListener();
			var index : int = _childrenList.indexOf(child);
			_childrenList.splice(index, 1);
			//
			child.setParent(null);
			child.setStage(null);
			callReRender();
		}

		public function removeChildAt(index : int) : void
		{
			var child : BmdObject = getChildAt(index);
			//从舞台移除会同时移除监听
			child.removeAllListener();
			child.setParent(null);			child.setStage(null);
			_childrenList.splice(index, 1);
			callReRender();
		}

		public function setChildIndex(child : BmdObject,index : int) : void
		{
			var oldindex : int = _childrenList.indexOf(child);
			_childrenList.splice(oldindex, 1);
			_childrenList.splice(index, 0, child);
		}

		public function getChildIndex(child : BmdObject) : int
		{
			return _childrenList.indexOf(child);
		}

		/**
		 * 设置子显示列表
		 * 通常用于层级排序后的写入操作
		 * 	(如果用setChildIndex的方法，会浪费开销在数组的splice上，所以在外面把层级排好后设置进来)
		 * 注意：此方法直接设置子级列表 @param list 的元素应该是我的现有子级。
		 * @param verify 是否校验list的每一项是否是子级，默认因为效率原因不做校验，这要求调用者必须保证数据完整性
		 * （校验的消耗太大：1560个对象的排序，如果有校验耗时20ms，无校验耗时0ms）
		 */
		public function setChildList(list : Array , verify : Boolean = false) : void
		{
			if(list.length != _childrenList.length)
			{
				throw new Error("设置子级显示列表错误：子级数量不匹配"); 
				return ;
			}
			if(verify)
			{
				//若需要校验，则检查每一项是否都是我现有子级 TODO
				for each(var child : * in list)
				{
					if(_childrenList.indexOf(child) == -1)
					{
						throw new Error("设置子显示列表校验失败:不存在的child");
						return;
					}
				}
			}
			_childrenList = list;
			//层级发生变化，调用渲染
			callReRender();
		}

		/**
		 * 释放资源;
		 * 清除子级;
		 * 若有父级，则自动从父级移除
		 */
		public override function dispose() : void
		{
			//这里要加入对自己和子级的释放
			for(var i : int = numChildren - 1;i >= 0;--i)
			{
				var child : BmdObject = getChildAt(i);
				child.dispose();
			}
			//super
			super.dispose();
		}

		/**
		 * 截取此刻象素快照
		 * 此刻自己的bmd放最下，然后递归复制子级的bmd
		 */
		override public function getPixelShot() : BitmapData
		{
			var shot : BitmapData = _bmd.clone();
			var maxI : int = numChildren;
			for(var i : int = 0;i < maxI;i++)
			{
				var child : BmdObject = getChildAt(i);
				var sourceRect : Rectangle = new Rectangle(0, 0, child.width, child.height);
				var destPoint : Point = new Point(child.x, child.y);
				shot.copyPixels(child.getPixelShot(), sourceRect, destPoint, null, null, true);
			}
			return shot;
		}

		internal override function  validateRectWhenMove(xAdd : int,yAdd : int) : void
		{
			super.validateRectWhenMove(xAdd, yAdd);
			//联合体无需检查子级
			if(_combined) 
			{
				//遍历子级直接设置成我的display
				foreachLevelChild(function(c : BmdObject):void
				{
					c.display = display;
				});
			}
			else
			{
				//对子级调用 遍历检测
				for(var i : int = numChildren - 1;i >= 0;--i)
				{
					var child : BmdObject = getChildAt(i);
					child.validateRectWhenMove(xAdd, yAdd);
				}
			}
		}

		/**
		 * 遍历所有子级执行
		 */
		internal function foreachLevelChild(func : Function) : void
		{
			for(var i : int = numChildren - 1;i >= 0;--i)
			{
				var child : BmdObject = getChildAt(i);
				func(child);
				if(child is BmdContainer)
				{
					(child as BmdContainer).foreachLevelChild(func);
				}
			}
		}

		public function get combined() : Boolean
		{
			return _combined;
		}

		/**
		 * 联合体
		 * 如果为true，则在移动和大小变化时只检查当前级的为准，只要当前级在视口内，就渲染当前级和所有子级。
		 * false,默认值，检查所有子级，分开渲染
		 */
		public function set combined(v : Boolean) : void
		{
			_combined = v;
		}
	}
}
