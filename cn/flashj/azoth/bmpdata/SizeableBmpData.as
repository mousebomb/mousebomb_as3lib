package cn.flashj.azoth.bmpdata
{
	import flash.display.BitmapData;

	/**
	 * 会随着运行 而变化位图尺寸的版本
	 * 最初不确定是什么内容，首先分配一块内存
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-12-23
	 */
	public class SizeableBmpData extends BmpData
	{
		/**
		 * @param w 最大支持宽度
		 * @param h 最大支持高度
		 */
		public function SizeableBmpData(database_ : BmpDatabase, w : uint, h : uint) : void
		{
			super(database_,new BitmapData(w, h,true,0xff000000));
		}

		/**
		 * 变换大小但不维护图像
		 * 适用于此处图像仅作临时缓冲区，重设大小后会全部重新设置内容的情况
		 */
		public function changeSize(w : uint, h : uint) : void
		{
			_width = w;
			_height = h;
			_rect.width = w;
			_rect.height = h;
		}

		/**
		 * 变化大小且裁剪图像
		 * 适用于图像在裁减后还要立即显示用的情况
		 * (未实现)
		 */
		public function cut(w : uint, h : uint) : void
		{
			// TODO
		}
	}
}
