package org.mousebomb.bmpdisplay 
{
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * 类似DisplayObject
	 * @author Mousebomb
	 * @date 2009-6-17
	 * 目前rotation和interactive合起来用会有一些问题
	 * 
	 * 未来的优化方向：
	 * 
	1.只有监听的对象且在屏幕内才检索事件是否触发
	2.只要位置不在屏幕内则不绘制
	3.重绘次数减少
	4.重绘区域减小
	 */
	public class BmdObject extends Object implements IBmpRenderable,IBmpHighLightable,IBmdEventDispatcher
	{
		//当前使用的bmd
		protected var _bmd : BitmapData ;
		//当前的bounds
		protected var _bounds : Rectangle;

		private var _x : int = 0;		private var _y : int = 0;
		private var _rotation : int = 0;		private var _visible : Boolean = true;
		private var _display : Boolean = false;
		private var _name : String = "";
		//父级引用
		protected var _parent : BmdContainer ;
		/**
		 * 加到Bmp舞台上的对象会有此引用
		 */
		private var _bmpStage : BmpDisplayObject; 
		private var _alpha : Number = 1;
		//记录是否由资源池创建，若是，则清除的时候保留bmd，只通知资源池检查释放
		private var _bornFromPool : Boolean;
		//资源唯一名字，仅对池创建的有意义
		bmd_pool var resourceName : String;

		//是否支持事件交互
		private var _interactive : Boolean = false;

		//显示层级(我在舞台中的深度)
		private var _displayIndex : int = -1;
		//我的全局rect 最近一次渲染时所产生
		private var _renderRect : Rectangle = new Rectangle();
		//我的全局rect 即将渲染到的 ， 用于渲染/重绘时判定是否需要绘制		protected var _globalRect : Rectangle = new Rectangle();
		//全局坐标,内部维护
		internal var _globalX : int = 0;
		//全局坐标,第一次加入舞台的时候设置
		internal var _globalY : int = 0;

		//需要调度的列表
		protected static var enterFrameList : Dictionary = new Dictionary(true);

		/**
		 * 抵达一个处理周期
		 */
		bmd_render static function onEnterFrame() : void 
		{
			for ( var obj : * in enterFrameList)
			{
				//处理需要处理的rect验证
				var bmdObj : BmdObject = obj as BmdObject;
				if(bmdObj.needValidate)
				{
					bmdObj.realValidateRect();
				}
			}
		}

		public function BmdObject()
		{
			//bmdObject几乎每个在每帧都要处理，所以构造函数中直接加入
			enterFrameList[this] = true;
		}

		/**
		 * 由本地坐标点转成全局坐标点
		 * 这个表示的是下一次渲染时“应该在的点”，而不是最近一次完成渲染时候产生的点
		 */
		public function localToGlobal() : Point
		{
			var ending : Point = new Point(x, y);
			var parentContainer : BmdContainer = this._parent;
			while(parentContainer)
			{
				ending.x += parentContainer.x;
				ending.y += parentContainer.y;
				parentContainer = getParent(parentContainer);
			}
			return ending;
		}

		private function getParent(who : BmdObject) : BmdContainer
		{
			return who.parent;
		}

		public function toString() : String
		{
			return "[BmdObject " + name + "]";
		}

		/**
		 * 截取此刻象素快照,须被子类重写
		 */
		public function getPixelShot() : BitmapData
		{
			throw new Error('抽象方法');
			return null;
		}

		/**
		 * 高亮
		 */
		public function highLight() : void
		{
			alpha = .65;
		}

		public function unHighLight() : void
		{
			alpha = 1;
		}

		public function get y() : int
		{
			return _y;
		}

		public function set y(v : int) : void
		{
			if(v == _y){ return;}
			var added : int = v - _y;
			_y = v;
			//重设位置后
			//维护全局位置
			validateRectWhenMove(0, added);
		}

		public function get x() : int
		{
			return _x;
		}

		public function set x(v : int) : void
		{
			if(v == _x){return;}
			var added : int = v - _x;
			_x = v;
			validateRectWhenMove(added, 0);
		}

		/**
		 * 是否可见
		 * 用来让用户指示是否可见
		 * 否决度高于display
		 */
		public function get visible() : Boolean
		{
			return _visible;
		}

		public function set visible(visible : Boolean) : void
		{
			_visible = visible;
			callReRender();
		}

		/**
		 * 外部调用，查看是否显示在视口内
		 */
		public function isDisplay() : Boolean
		{
			return _display;
		}

		/**
		 * 是否显示
		 * 用于表示是不是在视口范围内
		 */
		internal function get display() : Boolean
		{
			return _display;
		}

		internal function set display(v : Boolean) : void
		{
			if(v == _display) return;
			_display = v;
			//若不显示于场景内，则渲染区域为null
			if(_display == false)
				renderRect = new Rectangle();
			validateEvent();
		}

		public function get width() : Number
		{
			return _bounds.width;
		}

		public function get height() : Number
		{
			return _bounds.height;
		}

		public function get alpha() : Number
		{
			return _alpha;
		}

		public function set alpha(alpha : Number) : void
		{
			_alpha = alpha;
			callReRender();
		}

		public function get bitmapData() : BitmapData
		{
			if(alpha == 1)
			{
				return _bmd;
			}
			else
			{
				var ending : BitmapData = _bmd.clone();
				var colorTransform : ColorTransform = new ColorTransform();
				colorTransform.alphaMultiplier = alpha;
				ending.colorTransform(new Rectangle(0, 0, _bmd.width, _bmd.height), colorTransform);
				return ending;
			}
		}

		public function get name() : String
		{
			return _name;
		}

		public function set name(name : String) : void
		{
			_name = name;
		}

		public function get parent() : BmdContainer
		{
			return _parent;
		}

		internal function setParent(parent : BmdContainer) : void
		{
			/*
			 * 设置父级引用，
			 * 同时要计算global坐标
			 */
			_parent = parent;
			//坐标
			var pos : Point = localToGlobal();
			_globalX = pos.x;
			_globalY = pos.y;
		}

		/**
		 * 点碰撞测试
		 * 此方法是根据最近一次渲染的结果来判定
		 */
		public function hitTestPoint(x : Number,y : Number) : Boolean
		{
			//new ver ,使用最近一次渲染时产生的全局坐标
			var ending : Boolean = _bmd.hitTest(renderRect.topLeft, 0x00, new Point(x, y));
			return ending;
		}

		/**
		 * 释放资源
		 * 释放所有监听
		 */
		public function dispose() : void
		{
			//有父级则自动移除.
			if(this.parent)
			{
				//释放监听在removeChild里已经做了，所以不需要额外调用
				parent.removeChild(this);
			}
			else
			{
				//只是释放监听
				removeAllListener();
			}
			//删除需要enterframe处理的列表
			delete enterFrameList[this];
		}

		/**
		 * 记录是否由资源池创建，若是，则清除的时候保留bmd，只通知资源池检查释放
		 * 若不是，则独享bmd，释放自身的时候要释放BMD
		 * 只读
		 */
		public function get bornFromPool() : Boolean
		{
			return _bornFromPool;
		}

		bmd_pool function set bornFromPool(v : Boolean) : void
		{
			_bornFromPool = v;
		}

		public function get bmpStage() : BmpDisplayObject
		{
			return _bmpStage;
		}

		/**
		 * 设置舞台引用
		 * 此时即ADD_TO_STAGE
		 */
		internal function setStage(v : BmpDisplayObject) : void
		{
			_bmpStage = v;
		}

		/**
		 * 尝试调用重绘, 当视口内的内容发生变动时要调用
		 * 调用BmpStage的重绘
		 * bmpStage可能为null，所以不一定成功。
		 */
		protected function callReRender() : void
		{
			if(bmpStage) bmpStage.bmd_render::rerender(this);
		}

		/**
		 * 检查并设置是否显示（是否在视口内）
		 * @return 是否改变了display的值
		 */
		internal function validateDisplay() : Boolean
		{
			//如果没有在舞台上则不需要检测
			if(!bmpStage) return false;
			//
			var rootRect : Rectangle = bmpStage.bitmapData.rect;
			//这里有一处可能未来需要改动：精度不够。现在是不计算子级所带来的大小影响的
			//bounds 有影响
			var inViewPort : Boolean = rootRect.intersects(_globalRect);
			//rootRect.containsPoint(_globalRect.topLeft) || rootRect.containsPoint(_globalRect.bottomRight) || rootRect.contains(_globalRect.left, _globalRect.bottom) || rootRect.contains(_globalRect.right, _globalRect.top);
			//rootRect.containsRect(_globalRect);
			if(display != inViewPort)
			{
				display = inViewPort;
				return true;
			}
			return false;
		}

		//     			 ++++ 事件方面 ++++ 

		//是否支持事件交互
		public function get interactive() : Boolean
		{
			return _interactive;
		}

		//是否支持事件交互,在检索的时候只会检索他们
		public function set interactive(v : Boolean) : void
		{
			_interactive = v;
			if(!_interactive)
			{
				//如果设置为不交互，则清除所有监听
				removeAllListener();
			}
		}

		//存储所有监听
		private var _listeners : Object = {};

		/**
		 * 加监听
		 * @param type 类型，由BmdEvent指定的常量
		 */
		public function addListener(type : String,handler : Function) : void
		{
			if(!_interactive) return;
			//若此name已经有监听，则push，若无则创建再push
			if(!_listeners[type])
			{
				_listeners[type] = [];
			}
			(_listeners[type] as Array).push(handler);
		}

		/**
		 * 触发事件
		 */
		public function dispatchEvent(event : BmdEvent) : void
		{
			event.currentTarget = this;
			for each(var handler:Function in _listeners[event.type] as Array)
			{
				handler(event);
			}
			if(event.bubbles && parent)
			{
				parent.dispatchEvent(event);
			}
		}

		/**
		 * 移除事件监听
		 */
		public function removeListener(type : String,handler : Function) : void
		{
			//若有此name的监听则移除其中handler一项
			if(_listeners[type])
			{
				var index : int = (_listeners[type] as Array).indexOf(handler);
				if(index != -1)
				{
					(_listeners[type] as Array).splice(index, 1);
					//通知捕捉器
					bmpStage.eventCatcher.removeDispatcher(this, type);
				}
			}
		}

		public function removeAllListener() : void
		{
			_listeners = [];
			//通知捕捉器,可能不在舞台，则无bmpStage
			if(bmpStage) bmpStage.eventCatcher.removeDispatcher(this);
		}

		/**
		 * 当display变化后调用，来设置事件是否要捕捉
		 */
		private function validateEvent() : void
		{
			//通知捕捉器
			if(_display)
			{
				//事件捕捉注册
				for (var type : String in _listeners)
				{
					if((_listeners[type] as Array).length)
						bmpStage.eventCatcher.addDispatcher(this, type);
				}
			}
			else
			{
				//解除捕捉
				bmpStage.eventCatcher.removeDispatcher(this);
			}
		}

		/**
		 * 检查是否注册过某事件的监听
		 */
		public function hasListener(type : String) : Boolean
		{
			if(!_interactive) return false;
			if(_listeners[type])
			{
				return Boolean((_listeners[type] as Array).length);
			}
			return false;
		}

		// ++++ 层级 ++++
		/**
		 * 设置层级
		 * 我用于计算总层级
		 */
		internal function setDisplayIndex(v : int) : void
		{
			_displayIndex = v;
		}

		/**
		 * 获得自己在舞台上的层级
		 */
		public function get displayIndex() : int
		{
			return _displayIndex;
		}

		/**
		 * 我的全局渲染区域rect 最近一次渲染时所产生
		 * 容器坐标 叠加 内部bounds
		 */
		public function get renderRect() : Rectangle
		{
			return _renderRect;
		}

		public function set renderRect(v : Rectangle) : void
		{
			_renderRect = v;
		}

		/**
		 * 我的全局渲染区域rect 理论上接下来应该被渲染到的地方
		 * 容器坐标 叠加 内部bounds
		 */
		public function get globalRect() : Rectangle
		{
			return _globalRect;
		}

		//		/**
		//		 * 我在父容器中的rect
		//		 * 容器坐标 叠加 内部bounds
		//		 */
		//		public function get rect() : Rectangle
		//		{
		//			return _bounds;
		//		}

		//维护我的全局rect
		internal function validateRectWhenResize() : void
		{
			needValidate = true;
			//局部绘制(3)
			//2010年9月23日 18:40:51 改到realValidateRect去了
//			//resize 及bounds变化，需要更新_globalRect ，此时变化的是bounds.*
//			_globalRect.x = _globalX + bounds.x;
//			_globalRect.y = _globalY + bounds.y;
//			//
//			_globalRect.width = _bounds.width;//			_globalRect.height = _bounds.height;
//			//如果是否在视口内显示发生变化，要重绘
//			//如果本来就在视口内直接要重绘
//			if(validateDisplay() || display)
//			{			
//				callReRender();
//			}
		}
		
		internal function validateRectWhenMove(xAdd : int,yAdd : int) : void
		{
			//局部绘制(4)
			//对全局坐标进行更新
			_globalX += xAdd;
			_globalY += yAdd;
			needValidate = true;
		}

		//移动之后的总
		public var needValidate : Boolean = false;

		//在周期实际验证
		internal function realValidateRect() : void
		{
			//
			needValidate = false;
			//对局部绘制的范围进行调整
			//resize需要：此时bounds可能变化了 ; move需要：此时的_globalX,_globalY可能变化了
			_globalRect.x = _globalX + bounds.x;
			_globalRect.y = _globalY + bounds.y;
			//resize需要 resize 及bounds变化，需要更新_globalRect ，此时变化的是bounds.*
			_globalRect.width = _bounds.width;
			_globalRect.height = _bounds.height;
			//如果是否在视口内显示发生变化，要重绘
			//如果本来就在视口内直接要重绘
			if(validateDisplay() || display)
			{			
				callReRender();
			}
		}

		public function get rotation() : int
		{
			return _rotation;
		}

		public function set rotation(v : int) : void
		{
			_rotation = v;
		}

		public function get bounds() : Rectangle
		{
			return _bounds;
		}
	}
}
