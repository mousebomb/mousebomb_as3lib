package cn.flashj.multibmp
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2011-1-5
	 */
	public class MBmpResourcePool
	{

		private static var _instance : MBmpResourcePool;

		public static function getInstance() : MBmpResourcePool
		{
			if (_instance == null)
				_instance = new MBmpResourcePool();
			return _instance;
		}

		public function MBmpResourcePool()
		{
			if (_instance != null)
				throw new Error('singleton');
		}

		/**
		 * 资源表
		 * 每一项是
		 * {
		 * 	type:"Image","Animation"
		 * 	bmd:BitmapData
		 * }
		 */
		private var resTable : Object = {};

		public static const IMAGE : String = "Image";
		public static const MOVIESHIM : String = "MovieShim";

		// 设置多颜色截取时代替颜色的mc名 默认为colorArea
		public var colorArea : String = "colorArea";

		public function regResource(name : String, src : DisplayObject, type : String, color : int = -1) : void
		{

			// 获取此唯一name对应的资源数据
			var curDataStore : Object;
			if (resTable[name] == null)
			{
				curDataStore = resTable[name] = {};
			}
			else
			{
				throw new Error("无法将资源插入，因为重复的name:" + name);
			}
			// 把数据存入
			switch(type)
			{
				case MOVIESHIM:
					if (src is MovieClip)
					{
						curDataStore["type"] = MOVIESHIM;
						curDataStore["data"] = generateMovieShim(src as MovieClip, color);
					}
					else
					{
						throw new Error("目标" + name + "不是一个MovieClip");
					}
					break;
				case IMAGE:
					curDataStore["type"] = IMAGE;
					curDataStore["data"] = generateSpriteBmd(src);
					break;
				default:
					throw new Error("不兼容" + (typeof src) + "此类型的资源");
					break;
			}
		}

		/**
		 * 显示对象截成单帧BMD
		 */
		internal function generateSpriteBmd(src : DisplayObject) : Object
		{
			var bounds : Rectangle = src.getBounds(src);
			var rt : Object = {};
			var bmd : BitmapData = new BitmapData(bounds.width, bounds.height, true, 0x00);
			bmd.draw(src, new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y));
			rt["bmd"] = bmd;
			rt["bounds"] = bounds;
			return rt;
		}

		/**
		 * 生成MovieShim所需要的数据
		 * @param colorValue -1表示不变色
		 */
		internal function generateMovieShim(src : MovieClip, colorValue : int = -1) : Object
		{
			// 每一帧都截成位图，最终返回_frame数组和_boundsArr数组
			var rt : Object = {};
			var _frame : Array = [];
			var _boundsArr : Array = [];
			for (var i : int = 1 ;i <= src.totalFrames;i++)
			{
				// 每帧
				src.gotoAndStop(i);
				if (colorValue > -1)
				{
					// 尝试对资源进行颜色处理
					var colorAreaMc : DisplayObject = src.getChildByName(colorArea);
					var colorTransform : ColorTransform = new ColorTransform();
					colorTransform.color = colorValue;
					if (colorAreaMc)
					{
						colorAreaMc.transform.colorTransform = colorTransform;
					}
					else
					{
						// trace("cant get colorArea",src,colorValue.toString(16));
					}
				}
				var bounds : Rectangle = src.getBounds(src);
				var _bmd : BitmapData = new BitmapData(bounds.width, bounds.height, true, 0x00);
				_bmd.draw(src, new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y));
				// bmd,bounds
				_frame.push(_bmd);
				_boundsArr.push(bounds);
			}
			rt = {_frame:_frame, _boundsArr:_boundsArr};
			return rt;
		}

		public function getNewResource(name : String) : MBmpObject
		{
			var rt : MBmpObject;
			// 获取此唯一name对应的资源数据
			var curDataStore : Object = resTable[name] ;
			if (curDataStore == null)
			{
				// 没有注册资源则直接返回
				throw new Error("没有注册资源" + name);
				return null;
			}
			// 创建对象
			switch(curDataStore["type"])
			{
				case IMAGE:
					 rt = new MBmpImage();
					 (rt as MBmpImage).born(curDataStore["data"]);
					break;
				case MOVIESHIM:
					rt = new MBmpMovieShim();
					(rt as MBmpMovieShim).born(curDataStore["data"]);
					break;
			}
			return rt;
		}


	}

}
