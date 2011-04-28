package org.mousebomb.bmpdisplay 
{
	import org.mousebomb.Math.MousebombMath;
	import flash.geom.Matrix;

	import org.mousebomb.interfaces.IDispose;

	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	/**
	 * 渲染处理
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-6-25
	 */
	public class RenderProcess implements IDispose
	{
		use namespace bmd_render;
		private var _bmp : BmpDisplayObject;
		//统计效率用的
		internal var totalObjCount : int = 0;
		internal var totalTime : int = 0;
		//用来计算当前要绘制的对象的起始位置
		private var _curXOffset : Number;
		private var _curYOffset : Number;
		//当前要绘制的对象的旋转角度
		private var _curRotation : Number;
		//需要重绘的区域
		private var _toRenderRect : Rectangle;

		public function RenderProcess(bmp : BmpDisplayObject) : void
		{
			_bmp = bmp;
		}

		public function dispose() : void
		{
			_bmp = null;
		}

		/**
		 * 渲染全部，调用一次为请求渲染一次
		 */
		public function renderWhole() : void
		{
			totalObjCount = 0;
			var startTime : int = getTimer();
			//获得第一级的象素
			_bmp.bitmapData = _bmp._bmdObject.bitmapData.clone();
			_bmp.bitmapData.lock();
			_curXOffset = 0;
			_curYOffset = 0;
			_curRotation = 0;
			
			//这种模式速度慢
			//bitmapData = _bmdObject.getPixelShot();
			//递归把所有级别的copyPix
			if(_bmp._bmdObject is BmdContainer)
			{
				drawChild(_bmp._bmdObject as BmdContainer);
			}
			//trace('unlock');
			_bmp.bitmapData.unlock();
			//bitmapData.fillRect(new Rectangle(0,0,100,100), 0xffff0000);
			totalTime = getTimer() - startTime;
			//trace("绘制了" + totalObjCount + "个物体", "耗时" + totalTime + "ms");
		}

		/**
		 * 某一轮递归
		 */
		private function drawChild(bmdObj : BmdContainer) : void
		{
			//						trace('进' + bmdObj);
			var maxI : int = bmdObj.numChildren;
			for (var i : int = 0;i < maxI;i++)
			{
				//				trace('maxI: ' + (maxI));
				var child : BmdObject = bmdObj.getChildAt(i);
				/*
				 * display影响是否显示，但此属性不影响子级
				 * visible影响子级
				 */
				if(child.visible)
				{
					//				trace('child[' + i + "]:" + (child));
					_curXOffset += child.x;
					_curYOffset += child.y;
					_curRotation += child.rotation;
					if(child.display)
					{
						var sourceRect : Rectangle = new Rectangle(0, 0, child.width, child.height);
						//								trace('sourceRect: ' + (sourceRect));
						var destPoint : Point = new Point(_curXOffset+child.bounds.x, _curYOffset+child.bounds.y);
						//				trace('destPoint: ' + (destPoint));
						child.setDisplayIndex(++totalObjCount);
						//matrix mode
						if(_curRotation != 0)
						{
							var matrix : Matrix = new Matrix();
							matrix.translate(child.bounds.x, child.bounds.y);
							matrix.rotate(MousebombMath.radiansFromDegrees(_curRotation));
							matrix.tx = destPoint.x;
							matrix.ty = destPoint.y;
							_bmp.bitmapData.draw(child.bitmapData, matrix);
						}
						else
						{
							//normal mode
							_bmp.bitmapData.copyPixels(child.bitmapData, sourceRect, destPoint, null, null, true);
//DEBUG 2010年8月25日 13:20:26							
//if(child.name == "m")
//							{
//								trace(sourceRect, destPoint);
//							}
						}
						child.renderRect = new Rectangle(destPoint.x, destPoint.y, child.width, child.height);
					}
					if(child is BmdContainer)
					{
						drawChild(child as BmdContainer);
					}
					_curXOffset -= child.x;
					_curYOffset -= child.y;
					_curRotation -= child.rotation;
				}
			}
		//			trace('出' + bmdObj);
		}

		/**
		 * 局部渲染
		 */
		public function renderRect(rect : Rectangle) : void
		{
			_toRenderRect = rect;
			totalObjCount = 0;
			//获得第一级的象素
			_bmp.bitmapData.lock();
			//先把顶级区域填充掉
			_bmp.bitmapData.fillRect(_toRenderRect, 0x0);			//			_bmp.bitmapData.fillRect(_toRenderRect,MousebombMath.randomFromRange(0x55000000, 0x55ffffff));
			_bmp.bitmapData.copyPixels(_bmp._bmdObject.bitmapData, _toRenderRect, _toRenderRect.topLeft);
			_curXOffset = 0;
			_curYOffset = 0;
			
			//递归把所有级别的copyPix
			if(_bmp._bmdObject is BmdContainer)
			{
				drawRectChild(_bmp._bmdObject as BmdContainer);
			}
			_bmp.bitmapData.unlock();
		}

		/**
		 * 某一轮递归
		 */
		private function drawRectChild(bmdObj : BmdContainer) : void
		{
			//						trace('进' + bmdObj);
			var maxI : int = bmdObj.numChildren;
			for (var i : int = 0;i < maxI;i++)
			{
				//				trace('maxI: ' + (maxI));
				var child : BmdObject = bmdObj.getChildAt(i);
				/*
				 * display影响是否显示，但此属性不影响子级
				 * visible影响子级
				 */
				if(child.visible)
				{
					//				trace('child[' + i + "]:" + (child));
					_curXOffset += child.x;
					_curYOffset += child.y;
					if(child.display)
					{
						//图片自身的区域，这里要和重绘区域求交集
						var sourceRect : Rectangle = new Rectangle(0, 0, child.width, child.height);
						//目标即将被绘制到的全局区域
						var sourceRenderRect : Rectangle = new Rectangle(_curXOffset, _curYOffset, child.width, child.height);
						
						//求全局交集
						var sourceIntersecRect : Rectangle = sourceRenderRect.intersection(_toRenderRect);
						//求到本地区域
						sourceRect.x = sourceIntersecRect.x - _curXOffset;						sourceRect.y = sourceIntersecRect.y - _curYOffset;
						//								trace('sourceRect: ' + (sourceRect));
						//全局目标坐标
						var destPoint : Point = sourceIntersecRect.topLeft;
						//				trace('destPoint: ' + (destPoint));
						child.setDisplayIndex(++totalObjCount);
						_bmp.bitmapData.copyPixels(child.bitmapData, sourceRect, destPoint, null, null, true);
						child.renderRect = sourceRenderRect;
					}
					if(child is BmdContainer)
					{
						drawRectChild(child as BmdContainer);
					}
					_curXOffset -= child.x;
					_curYOffset -= child.y;
				}
			}
		//			trace('出' + bmdObj);
		}
	}
}
