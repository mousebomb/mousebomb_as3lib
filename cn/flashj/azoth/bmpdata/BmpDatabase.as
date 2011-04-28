package cn.flashj.azoth.bmpdata
{
	import com.buraks.utils.fastmem;

	import org.mousebomb.utils.TimerCounter;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;

	/**
	 * 位图数据库
	 * 用azoth的高速存取来放位图
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-12-23
	 */
	public class BmpDatabase
	{
		private var _mem : ByteArray;

		public function BmpDatabase()
		{
			_mem = new ByteArray();
			_mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
			// _mem.endian = Endian.LITTLE_ENDIAN;
		}

		/**
		 * 根据内存地址和大小得到一个位图
		 */
		public function getBitmapData(addr : uint, rect : Rectangle, w : uint, h : uint) : BitmapData
		{
			var rt : BitmapData = new BitmapData(w, h);
			_mem.position = addr;
			rt.setPixels(rect, _mem);
			return rt;
		}

		/**
		 * 放入一个位图到内存(线性内存分配)，返回内存起始地址
		 */
		public function putBitmapData(bmd : BitmapData) : uint
		{
			var pixels : ByteArray = bmd.getPixels(bmd.rect);
			trace(pixels.length);
			var startAddr : uint = _mem.position = _nextAddr;
			_mem.writeBytes(pixels);
			_nextAddr = _mem.position;
			return startAddr;
		}

		// 地址线性存储 ,下一个可用地址
		private var _nextAddr : uint = 0;

		/**
		 * 获得下一个可用地址
		 */
		public function getNextAddr() : uint
		{
			return _nextAddr;
		}

		/**
		 * 获得内存
		 */
		bmp_mem function get mem() : ByteArray
		{
			return _mem;
		}

	}
}
