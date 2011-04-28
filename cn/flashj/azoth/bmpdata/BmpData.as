package cn.flashj.azoth.bmpdata
{
	import com.buraks.utils.fastmem;

	import org.mousebomb.utils.TimerCounter;

	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	/**
	 * 位图数据
	 * 提供内存地址索引，以在位图数据库中获得位图
	 * 提供一些封装的方法，如碰撞检测
	 * 在实际显示中，有一个BmpData将是不断变化的（即视图缓冲区），其他很多不可见的部分是作为库使用
	 * 由于本人能力有限，目前没有做内存管理，所以只打算做位图存取/绘制，不打算做位图数据库的资源释放
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-12-23
	 */
	public class BmpData
	{
		// 尺寸(可能运行时改变)
		protected var _width : uint;
		protected var _height : uint;

		// 位图矩形 必定是(0,0为左上角),尺寸可能运行时改变
		protected var _rect : Rectangle;

		// 起始地址
		protected var _startAddr : uint;
		// 占用内存长度（因为中途可能随需求改变渲染区域大小，所以这个值总是>=面积，取决于初次创建时分配到的大小）
		protected var _len : uint;

		// 所使用的位图数据库
		protected var _database : BmpDatabase;

		public function BmpData(database_ : BmpDatabase,bitmapData_ : BitmapData)
		{
			_database = database_;
			init(bitmapData_);
		}

		// 以bmd初始化
		private function init(bitmapData_ : BitmapData) : void
		{
			_width = bitmapData_.width;
			_height = bitmapData_.height;
			_rect = bitmapData_.rect;
			_startAddr = _database.putBitmapData(bitmapData_);
			_len = (_width * _height ) << 2;
		}


		public function get width() : uint
		{
			return _width;
		}

		public function get height() : uint
		{
			return _height;
		}

		/**
		 * 获得flash版本的位图实例
		 */
		public function getBitmapData() : BitmapData
		{
			return _database.getBitmapData(_startAddr, _rect, _width, _height);
		}

		/**
		 * 拷贝像素到我上面，盖掉我的内容
		 */
		public function copyPixels(sourceBitmapData : BmpData, sourceRect : Rectangle, destPoint : Point) : void
		{
			// 只根据地址做fastBytearray写入
			var mem : ByteArray = _database.bmp_mem::mem;
			var destX : int = destPoint.x;
			var destY : int = destPoint.y;
			var sourceX : int = sourceRect.x;
			var sourceY : int = sourceRect.y;
			var sourceH : int = sourceRect.height;
			var sourceW : int = sourceRect.width;
			fastmem.fastSelectMem(mem);

			var oldBmdAddr : uint;
			var srcBmdAddr : uint;
			// 逐个int处理
			for ( var iy : int = 0 ; iy < sourceH;iy++)
			{
				for ( var ix : int = 0 ;ix < sourceW ;ix++)
				{
					// 老位图的地址
					oldBmdAddr = getAddressByPoint(destX + ix, destY + iy, _width, _startAddr);
					// 要盖住我的地址
					srcBmdAddr = getAddressByPoint(sourceX + ix, sourceY + iy, sourceBitmapData.width, sourceBitmapData.startAddr);
					// 总是等于后者
					fastmem.fastSetI32(fastmem.fastGetI32(srcBmdAddr), oldBmdAddr);
				}
			}
			fastmem.fastDeselectMem();
		}

		/**
		 * 获得一个像素点的内存地址
		 * @param px py 像素坐标
		 * @param bw 所在位图的列大小
		 * @param startAddr_ 像素所在地图的起始内存地址
		 */
		protected function getAddressByPoint(px : uint, py : uint, bw : uint, startAddr_ : uint) : uint
		{
			return startAddr_ + ((px + py * bw) << 2);
		}


		/**
		 * 测试位图与点是否碰撞
		 * @param topLeft 本位图在需要测试的点的坐标系中的左上角坐标
		 * @param testPoint 需要测试的点的坐标（通常是鼠标）
		 */
		public function hitTestPoint(topLeft : Point, testPoint : Point) : Boolean
		{
			trace("TODO: cn.flashj.azoth.bmpdata.BmpData/hitTestPoint() needs more implementation");
			return false;
		}

		/**
		 * 所使用的位图数据库
		 */
		public function get database() : BmpDatabase
		{
			return _database;
		}

		/**
		 * 起始地址
		 */
		public function get startAddr() : uint
		{
			return _startAddr;
		}

		public function get rect() : Rectangle
		{
			return _rect;
		}

		public function get len() : uint
		{
			return _len;
		}
	}
}
