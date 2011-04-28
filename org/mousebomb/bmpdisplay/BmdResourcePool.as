package org.mousebomb.bmpdisplay 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * 考虑到在实际开发中，许多MC要被new出来多次，他们的位图序列如果都一致则应该重用。
	 * 这个资源池负责转化并存储MC的位图序列
	 * 我内部有计数器来维护位图是否要dispose
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-6-21
	 */
	public class BmdResourcePool extends Object 
	{
		private static var _instance : BmdResourcePool;

		public static function getInstance() : BmdResourcePool 
		{
			if (_instance == null)
							_instance = new BmdResourcePool();
			return _instance;
		}

		public function BmdResourcePool() 
		{
			if (_instance != null)
						throw new Error('singleton');
		}

		
		//资源使用计数器
		private var counter : Object = {};
		/**
		 * 资源表
		 * 每一项是
		 * {
		 * 	type:"Image","Animation"
		 * 	bmd:BitmapData
		 * }
		 */
		private var resTable : Object = {};

		public static const IMAGE : String = "Image";		public static const ANIMATION : String = "Animation";
		public static const MOVIESHIM : String = "MovieShim";

		
		//设置多颜色截取时代替颜色的mc名 默认为colorArea
		public var colorArea : String = "colorArea";

		/**
		 * 注册一个资源
		 * @param name 唯一名字
		 * @param src 资源对象（Sprite或者MovieClip或者Bitmap）
		 * @param type 类型 可选的值： IMAGE | ANIMATION | MOVIESHIM
		 * @param color 对颜色区域设置变色 留空则不变色(只用于MovieShim)
		 */
		public function regResource(name : String,src : DisplayObject,type : String, color : int = -1) : void
		{
			//获取此唯一name对应的资源数据
			var curDataStore : Object;
			if(resTable[name] == null)
			{
				curDataStore = resTable[name] = {};
			}
			else
			{
				throw new Error("无法将资源插入，因为重复的name:" + name);
			}
			//把数据存入
			switch(type)
			{
				case ANIMATION:
					if(src is MovieClip)
					{
						curDataStore["type"] = ANIMATION;
						curDataStore["data"] = generateAnimationBmd(src as MovieClip);
					}
					else
					{ 
						throw new Error("目标" + name + "不是一个MovieClip");
					}
					break;
				case MOVIESHIM:
					if(src is MovieClip)
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
					if(src is Sprite)
					{
						curDataStore["type"] = IMAGE;
						curDataStore["data"] = generateSpriteBmd(src);
					}else
					if(src is Bitmap)
					{
						curDataStore["type"] = IMAGE;
						curDataStore["bmd"] = (src as Bitmap).bitmapData;
					}
					else
					{
						throw new Error("不兼容" + (typeof src) + "此类型的资源");
					}
					break;
				default:
					throw new Error("不兼容" + (typeof src) + "此类型的资源");
					break;
			}
		}

		/**
		 * 获取一个资源的bmd形式(新实例)
		 * @param name 注册的名字
		 */
		public function getNewResource(name : String) : BmdObject
		{
			use namespace bmd_pool;
			var rt : BmdObject;
			//获取此唯一name对应的资源数据
			var curDataStore : Object = resTable[name] ;
			if(curDataStore == null)
			{
				//没有注册资源则直接返回
				throw new Error("没有注册资源" + name);
				return null;
			}
			//创建对象
			switch(curDataStore["type"])
			{
				case IMAGE:
					rt = new Image();
					(rt as Image).born(curDataStore["data"]);
					break;
				case ANIMATION:
					rt = new Animation();
					(rt as Animation).born(curDataStore["data"]);
					break;
				case MOVIESHIM:
					rt = new MovieShim();
					(rt as MovieShim).born(curDataStore["data"]);
					break;
			}
			//设置对象的resourceName
			rt.resourceName = name;
			//计数器，记录使用次数的增加
			if(counter[name] == null)
			{
				counter[name] = 1;
			}
			else
			{
				counter[name]++;
			}
			return rt;
		}

		/**
		 * 某资源自身卸载时调用
		 * 计数器减值
		 */
		bmd_pool function clearResource(name : String) : void
		{
			counter[name]--;
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
		 * 显示对象截成Animation需要的数据
		 */
		internal function generateAnimationBmd(src : MovieClip) : Object
		{
			var totalFrames : int = src.totalFrames;
			//对应每一帧的bmd
			var _frame : Array = [];
			//存储每一帧bmd的bounds
			var _boundsArr : Array = [];
			var _labelFrame : Object = {};
			var _existFrameLabel : Object = {};
			var _frameLabel : Object = {};
			for(var i : int = 1;i <= totalFrames;i++)
			{
				src.gotoAndStop(i);
				var bounds : Rectangle = src.getBounds(src);
				var _bmd : BitmapData = new BitmapData(bounds.width, bounds.height, true, 0x00);
				_bmd.draw(src, new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y));
				_frame[i] = _bmd;
				_boundsArr[i] = bounds;
				//记录当前帧号对应的标签
				_labelFrame[i] = src.currentLabel;
				//若此帧有标签,且记录中不存在标签
				if(src.currentLabel && !_existFrameLabel[src.currentLabel])
				{
					//则加入记录
					_frameLabel[src.currentLabel] = i;
					//记录下来保证存的是label的第一个关键帧
					_existFrameLabel[src.currentLabel] = true;
				}
			}
			var rt : Object = {};
			rt["_frame"] = _frame;			rt["_boundsArr"] = _boundsArr;
			rt["_labelFrame"] = _labelFrame;
			rt["_frameLabel"] = _frameLabel;
			return rt;
		}

		/**
		 * 生成MovieShim所需要的数据
		 * @param colorValue -1表示不变色
		 */
		internal function generateMovieShim(src : MovieClip,colorValue : int = -1) : Object
		{
			//每一帧都截成位图，最终返回_frame数组和_boundsArr数组
			var rt : Object = {};
			var _frame : Array = [];
			var _boundsArr : Array = [];
			for(var i : int = 1 ;i <= src.totalFrames;i++)
			{
				//每帧
				src.gotoAndStop(i);
				if(colorValue > -1)
				{
					//尝试对资源进行颜色处理
					var colorAreaMc : DisplayObject = src.getChildByName(colorArea);
					var colorTransform : ColorTransform = new ColorTransform();
					colorTransform.color = colorValue;
					if(colorAreaMc)
					{
						colorAreaMc.transform.colorTransform = colorTransform;
					}
					else
					{
						//trace("cant get colorArea",src,colorValue.toString(16));
					}
				}
				var bounds : Rectangle = src.getBounds(src);
				var _bmd : BitmapData = new BitmapData(bounds.width, bounds.height, true, 0x00);
				_bmd.draw(src, new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y));
				//bmd,bounds
				_frame.push(_bmd);
				_boundsArr.push(bounds);
			}
			rt = {_frame : _frame, _boundsArr: _boundsArr};
			return rt;
		}
	}
}
