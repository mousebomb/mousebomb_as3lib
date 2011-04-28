package cn.flashj.multibmp
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2011-1-6
	 */
	public class RefBitmap extends Bitmap
	{
		public function RefBitmap(bitmapData : BitmapData = null, pixelSnapping : String = "auto", smoothing : Boolean = false)
		{
			super(bitmapData, pixelSnapping, smoothing);
		}
		
		//所属于的bmo
		public var mbRef : MBmpObject;
	}
}
