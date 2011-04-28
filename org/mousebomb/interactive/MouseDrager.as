package org.mousebomb.interactive 
{
	import org.mousebomb.interfaces.IDispose;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * 鼠标拖拽功能
	 * @author Mousebomb@qoolu
	 */
	public class MouseDrager extends EventDispatcher implements IDispose
	{

		private var __dragging : Boolean = false;//是否拖拽
		private var __start : Boolean = false;//是否开始监听拖拽
		private var __oldPos : Array = [];
		private var __oldMousePos : Array = [];
		private var __ele : DisplayObject;

		private var __mode : int = 0;//0为监听鼠标 1为监听每帧

		private var __rect : Rectangle;
		//计算鼠标坐标与显示对象的差
		private	var offsetX : Number; //= targetX - __ele.x;
		private	var offsetY : Number; //= targetY - __ele.y;

		/**
		 * 是否正在拖拽中
		 * 这个拖拽是实际的拖拽已经产生了位移
		 */

		public function get isDragging() : Boolean 
		{
			return this.__dragging;
		}

		/**
		 * 是否使用startDrag()使之开始拖拽
		 * 这个拖拽是startDrag启动后就为true的，它为true的时候isDragging不一定为true
		 */
		public function get isAlreadyStart() : Boolean
		{
			return __start;
		}

		
		/**
		 * 初始化拖拽对象
		 * @param	_ele	被拖拽的对象
		 * @param	_mode	拖拽模式:0为监听鼠标 1为监听每帧
		 */
		public function MouseDrager(_ele : DisplayObject,_mode : int = 0) 
		{
			this.__ele = _ele;
			this.__mode = _mode;
		}

		public function dispose() : void
		{
			if(isDragging)
			{
				stopDrag();
			}
			this.__ele = null;
		}

		/**
		 * 开始拖拽_ele
		 * @param	_ele	被拖拽的对象
		 * @param	_evt	接受一个mouseDown事件
		 */
		public function startDrag(rect : Rectangle = null) : void
		{
			//
			__rect = rect;
			//拖拽
			__oldPos[0] = this.__ele.x;
			__oldPos[1] = this.__ele.y;
			__oldMousePos[0] = this.__ele.parent.mouseX;
			__oldMousePos[1] = this.__ele.parent.mouseY;
			//计算鼠标与物体原点的差距
			offsetX = __ele.parent.mouseX - __ele.x;			offsetY = __ele.parent.mouseY - __ele.y;
			//其他语句...
			if (this.__mode == 0)
			{
				this.__ele.stage.addEventListener(MouseEvent.MOUSE_MOVE, moveByMouse);
			}
			else 
			{
				this.__ele.stage.addEventListener(Event.ENTER_FRAME, moveByMouse);
			}
			__start = true;
		}

		private function moveByMouse(e : *) : void
		{
			//1:灵敏度调整,超过这个值才算拖动;
			if (Math.abs(this.__ele.parent.mouseX - __oldMousePos[0]) > 1 || Math.abs(this.__ele.parent.mouseY - __oldMousePos[1]) > 1) 
			{
				//
				var targetX : Number = this.__ele.parent.mouseX;				var targetY : Number = this.__ele.parent.mouseY;
				var outOfRectX : Boolean = false;				var outOfRectY : Boolean = false;
				this.__ele.x += targetX - __oldMousePos[0];
				this.__ele.y += targetY - __oldMousePos[1];
				//有限定区域,查是否在区域
				if(__rect != null)
				{
					var maxX : Number = __rect.x + __rect.width;					var minX : Number = __rect.x ;
					if(this.__ele.x > maxX)
					{
						this.__ele.x = maxX;
						outOfRectX = true;
					}
					if(this.__ele.x < minX) 
					{
						this.__ele.x = minX;
						outOfRectX = true;
					}
					var maxY : Number = __rect.y + __rect.height;
					var minY : Number = __rect.y;
					if(this.__ele.y > maxY)
					{
						this.__ele.y = maxY;
						outOfRectY = true;
					}
					if(this.__ele.y < minY) 
					{
						this.__ele.y = minY;
						outOfRectY = true;
					}
				}
				//x出范围
				if(outOfRectX) 
				{	
					__oldMousePos[0] = __ele.x + offsetX ;
				}
				else
				{	
					__oldMousePos[0] = targetX;
				}
				//y范围
				if(outOfRectY)
				{	
					__oldMousePos[1] = __ele.y + offsetY;
				}
				else
				{
					__oldMousePos[1] = targetY;
				}
				if (this.__ele.x != __oldPos[0] || this.__ele.y != __oldPos[1]) 
				{
					__dragging = true;
				}
				if (this.__mode == 0)//MouseEvent
				{
					var evt : MouseEvent = e as MouseEvent;
					evt.updateAfterEvent();
				}
			}
		}

		public function stopDrag() : void 
		{
			//释放拖拽
			if (this.__mode == 0)
			{
				this.__ele.stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveByMouse);
			}
			else 
			{
				this.__ele.stage.removeEventListener(Event.ENTER_FRAME, moveByMouse);
			}
			
			this.__dragging = false;
			this.__start = false;
			//其他语句...
		}
		
		/**
		 * 拖拽的目标
		 * @return 显示对象
		 */
		public function get target() : DisplayObject
		{
			return __ele;
		}
	}
}