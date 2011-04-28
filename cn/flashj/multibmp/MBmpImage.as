package cn.flashj.multibmp
{
	import flash.display.Sprite;

	/**
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2011-1-6
	 */
	public class MBmpImage extends MBmpLeaf
	{
		public function MBmpImage()
		{
			super();
		}

		public function born(data : Object) : void
		{
			// 保存图像
			_bmd = data.bmd;
			_bounds = data.bounds;
			_bmp.bitmapData = this._bmd;
			_bornFromPool = true;
		}

		public function sprite2Image(s : Sprite) : void
		{
			var data : Object = MBmpResourcePool.getInstance().generateSpriteBmd(s);
			_bmd = data["bmd"];
			_bounds = data["bounds"];
			_bmp.bitmapData = _bmd;
		}

		override public function dispose() : void
		{
			if(!_bornFromPool)
			{
				_bmd.dispose();
			}
			super.dispose();
		}

	}
}
