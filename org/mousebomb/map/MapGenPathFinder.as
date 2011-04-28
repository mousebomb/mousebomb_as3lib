package org.mousebomb.map 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	//绘制进度
	[Event(name="progress", type="flash.events.ProgressEvent")]

	//完成绘制
	[Event(name="complete", type="flash.events.Event")]

	/**
	 * 带有地图生成功能的寻路
	 * 根据图先缩放，然后直接getpixel
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-6-16
	 * @date 2010-07-21 重写
	 * 
	 */
	public class MapGenPathFinder extends PathFinder
	{

		
		public function MapGenPathFinder()
		{
			super();
		}	

		//测试结果
		private var hitTestResult : Boolean;
		//最终产生的地图通断数据
		private var mapModel : Array = [];
		//列数,在自动生成地图时候用
		private var _cols : int = 0;
		//行数
		private var _rows : int = 0;
		//总格子数量
		private var _totalTileCount : int = 0;
		//
		private var src : DisplayObject;
		//当前计算到的格子位置 x,y从0,0到_cols,_rows
		private var curX : int ;
		private var curY : int;

		//
		private var bmp : Bitmap = new Bitmap();

		//用来记录需要测试的通断对象位图
		private var srcBmd : BitmapData;

		//放置递归死
		private var runTime : int = 0 ;

		
		/**
		 * 根据图像产生通断数据
		 * 注册点必须在左上角0,0，不考虑偏移
		 * @param src 用于产生数据的图像，此图像有填充区域表示断，其他透明区域表示通
		 * 生成后src将从舞台移除
		 */
		public function drawMapModel(src : DisplayObject) : void
		{
			/*
			 * 缩放src
			 * 把src绘制到位图
			 */
			this.src = src;
			//缩放比例
			src.scaleX = src.scaleY = 1 / tileSize;
			srcBmd = new BitmapData(src.width, src.height,true,0x0);
			var matrix : Matrix = new Matrix();
			matrix.scale(src.scaleX, src.scaleY);
			srcBmd.draw(src,matrix);
			bmp.bitmapData = srcBmd;
			if(src.parent)
			{ 
				//src.parent.addChild(bmp);
				src.parent.removeChild(src);
			}
			
			//求出矩阵尺寸
			_cols = Math.ceil(src.width)-1;
			_rows = Math.ceil(src.height)-1;
			_totalTileCount = _cols * _rows;
			/*
			 * 遍历所有格子，每个格子碰撞判断
			 */
			curX = 0;
			curY = 0;
			//开始执行分段任务
			onceTaskStartTime = getTimer();
			doOnce();
		}

		//执行一次任务的开始时间
		private var onceTaskStartTime : int;
		/**
		 * 开始执行分段任务
		 */
		private function doOnce() : void
		{
			if(++runTime > 255)
			{
				//延期下一段
				//
				var evt : ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
				evt.bytesLoaded = curX * _rows + curY;
				evt.bytesTotal = _totalTileCount;
				dispatchEvent(evt);
				//定时
				setTimeout(doOnce, 1);
				runTime = 0;
				return;
			}
			//			trace(curX,curY);
			if(curX < _cols)
			{
				if(curY < _rows)
				{
					hitTestBlock(curX, curY++);
				}
				else
				{
					//下一列
					curY = 0;
					curX++;
				}
				doOnce();
				return;
			}
			else
			{
				//保存结果
				setMapModel(mapModel);
				//结束
				var event : Event = new Event(Event.COMPLETE);
				dispatchEvent(event);
			}
		}

		/**
		 * 测试一个格子通断并写入数据
		 */
		private function hitTestBlock(x : int,y : int) : void
		{
			if(mapModel[x] == null)
			{
				mapModel[x] = [];
			}
			//碰撞检测结束
			//有色不通
			hitTestResult = ((srcBmd.getPixel32(x, y) >> 24 & 0xff) != 0x0);
			mapModel[x][y] = (hitTestResult ? 0 : 1);
		}

		/**
		 * 寻路的单位格子大小
		 * 影响到
		 * 1.根据图像产生通断数据的精度
		 * 2.计算tile与px单位换算
		 */
		override public function set tileSize(v : Number) : void
		{
			super.tileSize = v;
		}
	}
}


