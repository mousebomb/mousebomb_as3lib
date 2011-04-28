package org.mousebomb.utils 
{
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	/**
	 * 实现位图数据与字节流的转化
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-9-14
	 */
	public class BitmapByteData 
	{
		/**
		 * @param bmd 要输入的位图
		 * @param compress 是否需要压缩
		 */
		public static function bmd2ByteArray(bmd : BitmapData) : ByteArray
		{
			var wid : int = bmd.width;
			var hei : int = bmd.height;
			var tran : Boolean = bmd.transparent;
			//像素数据
			var ending : ByteArray = new ByteArray();
			ending.writeInt(wid);
			ending.writeInt(hei);
			ending.writeBoolean(tran);
			ending.writeBytes(bmd.getPixels(bmd.rect));
			return ending;
		}

		public static function byteArray2Bmd(ba : ByteArray) : BitmapData
		{
			var wid : int = ba.readInt();
			var hei : int = ba.readInt();
			var tran : Boolean = ba.readBoolean();
			var bmd : BitmapData = new BitmapData(wid, hei, tran, 0);
			bmd.setPixels(bmd.rect, ba);
			return bmd;
		}
	}
}
