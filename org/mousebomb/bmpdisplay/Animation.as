package org.mousebomb.bmpdisplay 
{
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	/**
	 * 动画
	 * 在创建实例时产生所用的BMP
	 * @author Mousebomb
	 * @date 2009-6-16
	 */
	public class Animation extends BmdContainer implements IBmpRenderable
	{
		/**
		 * 帧号对应bmd表
		 */
		private var _frame : Array = [];
		/**
		 * 帧号对应的bounds表
		 */
		private var _boundsArr : Array = [];
		/**
		 * Frame的label兑换帧号
		 */
		private var _frameLabel : Object = {};
		private var _labelFrame : Object = {};		/**
		 * 当前帧号
		 */
		private var _curFrame : int = 0;
		/**
		 * 当前播放暂停与否
		 */
		private var _paused : Boolean = true;

		/**
		 * fps推动的时间周期
		 */
		private var _timer : Timer;

		//		/**
		//		 * 已经记录过的帧标签
		//		 */
		//		private var _existFrameLabel : Object = {};

		//开启循环播放某单元
		private var _loopStart : int;
		private var _loopEnd : int;
		//播放模式 通过此值决定是否开启单元循环播放
		private var _playMode : int = PLAYMODE_LOOP;
		//播放帧频
		private var _fps : int;
		private static const DEFAULT_FPS : int = 25;

		//全影片循环
		public static const PLAYMODE_LOOP : int = 0;		public static const PLAYMODE_UNITLOOP : int = 1;
		public static const PLAYMODE_UNIT : int = 2;

		/**
		 * fps:帧频
		 */
		public function Animation(fps_ : int = 0) : void
		{
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			if(fps_ <= 0) fps = DEFAULT_FPS;
			else  fps = fps_;
			_timer.start();
		}

		private function onTimer(event : TimerEvent) : void
		{
			//fps周期倒了
			//若暂停播放状态则返回
			if(_paused) return;
			switch(_playMode)
			{
				case PLAYMODE_LOOP:
					//常规循环播放 1~最末帧
					if(totalFrames > curFrame)
					{
						//若还有的播放
						showFrame(curFrame + 1);
					}
					else
					{
						//循环到最前
						showFrame(1);
					}
					break;
				case PLAYMODE_UNITLOOP:
					//循环某单元播放 某标签～该标签最后一帧
					if(_loopEnd > curFrame)
					{
						//若还有的播放
						showFrame(curFrame + 1);
					}
					else
					{
						//循环到最前
						showFrame(_loopStart);
					}
					break;
				case PLAYMODE_UNIT:
					//循环某单元播放 某标签～该标签最后一帧
					if(_loopEnd > curFrame)
					{
						//若还有的播放
						showFrame(curFrame + 1);
					}
					else
					{
						//终止播放
						stop();
					}
					break;
			}
		}

		/**
		 * 影片剪辑转换为位图化序列
		 */
		public function mc2Animation(src : MovieClip) : void
		{
			/*
			 * //old version
			//			var totalFrames : int = src.totalFrames;
			//			for(var i : int = 1;i <= totalFrames;i++)
			//			{
			//				src.gotoAndStop(i);
			//				var bounds : Rectangle = src.getBounds(src);
			//				_bmd = new BitmapData(bounds.width, bounds.height, true, 0x00);
			//				_bmd.draw(src, new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y));
			//				_frame[i] = _bmd;
			//				//记录当前帧号对应的标签
			//				_labelFrame[i] = src.currentLabel;
			//				//若此帧有标签,且记录中不存在标签
			//				if(src.currentLabel && !_existFrameLabel[src.currentLabel])
			//				{
			//					//则加入记录
			//					_frameLabel[src.currentLabel] = i;
			//					//记录下来保证存的是label的第一个关键帧
			//					_existFrameLabel[src.currentLabel] = true;
			//				}
			//			}
			//创建mc的数据*/
			var data : Object = BmdResourcePool.getInstance().generateAnimationBmd(src);
			for(var key : * in data)
			{
				this[key] = data[key];
			}
			showFrame(1);
		}

		/**
		 * 由资源池初始化
		 * @param data 所有需要的信息
		 */
		bmd_pool function born(data : Object) : void
		{
			for(var key : * in data)
			{
				this[key] = data[key];
			}
			showFrame(1);
			//记下是从池创建的
			bmd_pool::bornFromPool = true;
		}

//		override public function get bitmapData() : BitmapData
//		{
//			if(alpha == 1)
//			{
//				return _bmd;
//			}
//			else
//			{
//				var ending : BitmapData = _bmd.clone();
//				var colorTransform : ColorTransform = new ColorTransform();
//				colorTransform.alphaMultiplier = alpha;
//				ending.colorTransform(new Rectangle(0, 0, _bmd.width, _bmd.height), colorTransform);
//				return ending;
//			}
//		}

		public function play(fps_ : int = 0) : void
		{
			if(fps_) this.fps = fps_;
			_paused = false;
		}

		public function stop() : void
		{
			_paused = true;
		}

		public function gotoAndPlay(frame : Object,fps_ : int = 0) : void
		{
			if(frame is int)
			{
				showFrame(frame as int);
				return ;
			}
			if(frame is String)
			{
				showFrame(_frameLabel[frame]);
				return ;
			}
			_playMode = PLAYMODE_LOOP;
			if(fps_) this.fps = fps_;
			_paused = false;
		}

		public function gotoAndStop(frame : Object) : void
		{
			if(frame is int)
			{
				showFrame(frame as int);
				return ;
			}
			if(frame is String)
			{
				showFrame(_frameLabel[frame]);
				return ;
			}
			_playMode = PLAYMODE_LOOP;
			_paused = true;
		}

		/**
		 * 循环播放某一标签帧所指定的动画单元
		 */
		public function playUnitLoop(label : String, fps_ : int = 0) : void
		{
			_loopStart = _frameLabel[label];
			//求出结束帧
			var i : int = _loopStart;
			while(_labelFrame[i] == label)
			{
				_loopEnd = _labelFrame[i++];
			}
			_playMode = PLAYMODE_UNITLOOP;
			if(fps_) this.fps = fps_;			
			_paused = false;
			showFrame(_loopStart);
		}

		/**
		 * 播放某一标签帧所指示的单元
		 */
		public function playUnit(label : String, fps_ : int = 0) : void
		{
			_loopStart = _frameLabel[label];
			//求出结束帧
			var i : int = _loopStart;
			while(_labelFrame[i] == label)
			{
				_loopEnd = _labelFrame[i++];
			}
			_playMode = PLAYMODE_UNIT;
			if(fps_) this.fps = fps_;			
			_paused = false;
			showFrame(_loopStart);
		}

		public function nextFrame() : void
		{
			if(curFrame < totalFrames)
			showFrame(curFrame + 1);
		}

		public function prevFrame() : void
		{
			if(curFrame > 1)
			showFrame(curFrame - 1);
		}

		private function showFrame(frame : int ) : void
		{
			_curFrame = frame;
			_bmd = _frame[frame-1];
			_bounds = _boundsArr[frame - 1];
			onShowFrame(frame);
		}

		/**
		 * 显示某帧，即播放到某帧
		 */
		private function onShowFrame(frame : int) : void
		{
			//切换帧后重新计算大小
			validateRectWhenResize();
			//重算位置是否在视口中
			validateDisplay();
			//请求重绘
			callReRender();
			//待以后特殊需要
		}

		public function get curFrame() : int
		{
			return _curFrame;
		}

		public function get totalFrames() : int
		{
			//因为_frame[0]是空的
			return _frame.length - 1;
		}

		/**
		 * 点碰撞测试
		 * 以顶级显示对象坐标系为参照
		 * 此方法是根据最近一次渲染的结果来判定
		 */
		override public function hitTestPoint(x : Number,y : Number) : Boolean
		{
			//var ending : Boolean = _bmd.hitTest(localToGlobal(), 0x00, new Point(x, y));
			var ending : Boolean = _bmd.hitTest(renderRect.topLeft, 0x00, new Point(x, y));
			return ending;
		}

		/**
		 * 清除资源
		 */
		override public function dispose() : void
		{
			use namespace bmd_pool;
			//停止播放
			stop();
			//清除内存
			_bmd = null;
			if(bornFromPool)
			{
				//通知池子我完结了，让池子负责资源清除
				BmdResourcePool.getInstance().clearResource(resourceName);
			}
			else
			{
				//位图独享，自己清除
				for each(var bmd:BitmapData in _frame)
				{
					bmd.dispose();
				}
			}
			//重置数据
			_frame = [];
			_frameLabel = {};
			_labelFrame = {};
			//
			super.dispose();
		}

		public function get fps() : int
		{
			return _fps;
		}

		/**
		 * 设置帧频
		 * 内部设置定时器的周期
		 */
		public function set fps(v : int) : void
		{
			//仅在大于0时有效
			if(v > 0)
			{
				_fps = v;
			}
			_timer.delay = 1000 / _fps;
		}
		
//		override public function get rect() : Rectangle
//		{
//			return _bmd.rect;
//		}

	}
}
