package cn.flashj.multibmp
{


	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2011-1-5
	 */
	public class MBmpMovieShim extends MBmpLeaf
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
		 * 当前播放头的帧号
		 */
		private var _curFrame : int = -1;
		/**
		 * 在当前播放单元之中的帧号
		 */
		private var _curUnitFrame : int = 0;
		/**
		 * 在当前播放单元之中的总帧数
		 */
		private var _curUnitTotalFrame : int = 0;
		// 当前所在的播放某单元
		private var _unitName : String;
		/**
		 * 当前播放暂停与否
		 */
		private var _paused : Boolean = true;
		/**
		 * 单元定义
		 */
		private var _unitDefine : Object = {};

		/**
		 * fps推动的时间周期
		 */
		private var _timer : Timer;

		// 播放模式 通过此值决定是否开启单元循环播放
		private var _playMode : int = PLAYMODE_UNKNOWN;
		// 全影片循环
		public static const PLAYMODE_UNKNOWN : int = 0;
		public static const PLAYMODE_UNITLOOP : int = 1;
		public static const PLAYMODE_UNIT : int = 2;
		// 播放帧频
		private var _fps : int;
		private static const DEFAULT_FPS : int = 25;
		/**
		 * 播放完毕的回调函数
		 * 在playUnit,playUnitOnce内都会触发
		 */
		public var onComp : Function;

		public function MBmpMovieShim(fps_ : int = 0) : void
		{
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			if (fps_ <= 0) fps = DEFAULT_FPS;
			else fps = fps_;
			_timer.start();
		}

		/**
		 * 声明一个动画单元
		 * addUnit("jump",[1,2,5])
		 */
		public function addUnit(name : String, frames : Array) : void
		{
			_unitDefine[name] = frames;
		}

		internal function born(data : Object) : void
		{
			for (var key : * in data)
			{
				this[key] = data[key];
			}
			// 默认先采用第1帧，但不设置帧号，以便外部第一次调用playUnit的时候不会被(_curFrame == frame)忽视
			_bmd = _frame[0];
			_bounds = _boundsArr[0];
			_bmp.bitmapData = _bmd;
			_bornFromPool = true;
		}

		// 从1开始
		private function showFrame(frame : int) : void
		{
			// 相同则忽视
			if (_curFrame == frame) return;
			_curFrame = frame;
			_bmd = _frame[frame - 1];
			_bounds = _boundsArr[frame - 1];
			if (_bmd == null)
			{
				trace("frame's Bmd is Null : frame" + frame);
			}
			else
			{
				_bmp.bitmapData = _bmd;
			}
			onShowFrame(frame);
		}

		/**
		 * 显示某帧，即播放到某帧
		 */
		private function onShowFrame(frame : int) : void
		{
			// 更新位置
			validatePos();
			// 待以后特殊需要
		}

		private function onTimer(event : TimerEvent) : void
		{
			// fps周期倒了
			// 若暂停播放状态则返回
			if (_paused) return;
			var targetFrame : int;
			switch(_playMode)
			{
				case PLAYMODE_UNITLOOP:
					// 循环某单元播放 某标签～该标签最后一帧
					if (_curUnitTotalFrame > ++_curUnitFrame)
					{
						// 若还有的播放
						targetFrame = _unitDefine[_unitName][_curUnitFrame];
						showFrame(targetFrame);
						if (_curUnitFrame == _curUnitTotalFrame - 1 && onComp != null)
						{
							onComp(this);
						}
					}
					else
					{
						// 循环到最前
						_curUnitFrame = 0;
						targetFrame = _unitDefine[_unitName][_curUnitFrame];
						showFrame(targetFrame);
					}
					break;
				case PLAYMODE_UNIT:
					// 循环某单元播放 某标签～该标签最后一帧
					if (_curUnitTotalFrame > ++_curUnitFrame)
					{
						// 若还有的播放
						targetFrame = _unitDefine[_unitName][_curUnitFrame];
						showFrame(targetFrame);
					}
					else
					{
						// 终止播放
						stop();
						// 回调
						if (onComp != null) onComp(this);
					}
					break;
				default :
					return;
					break;
			}
		}

		/**
		 * 继续播放
		 */
		public function play(fps_ : int = 0) : void
		{
			if (fps_) this.fps = fps_;
			_paused = false;
		}

		/**
		 * 停止播放
		 */
		public function stop() : void
		{
			_paused = true;
		}

		/**
		 * 直接显示某帧，并停止播放
		 */
		public function gotoAndStop(frame : int) : void
		{
			showFrame(frame);
			_paused = true;
		}

		public function get curFrame() : int
		{
			return _curFrame;
		}

		public function get totalFrames() : int
		{
			// // 2010年9月17日 16:51:38 貌似后来改过后0不为空
			//			//  因为_frame[0]是空的
			// return _frame.length - 1;
			return _frame.length;
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
			// 仅在大于0时有效
			if (v > 0)
			{
				_fps = v;
			}
			_timer.delay = 1000 / _fps;
		}

		/**
		 * 循环播放某一标签帧所指定的动画单元
		 */
		public function playUnit(name_ : String, fps_ : int = 0) : void
		{
			if (_unitDefine[name_] == null)
			{
				trace("playUnit failed : unregisted unit:", name_);
				return;
			}
			// 记录当前播放的单元
			_unitName = name_;
			_playMode = PLAYMODE_UNITLOOP;
			if (fps_) this.fps = fps_;
			_paused = false;
			// 记录当前播放单元的帧数
			_curUnitTotalFrame = (_unitDefine[name_] as Array).length;
			_curUnitFrame = 0;
			showFrame(_unitDefine[name_][_curUnitFrame]);
		}

		/**
		 * 播放某一标签帧所指示的单元，到结尾后停止
		 */
		public function playUnitOnce(name_ : String, fps_ : int = 0) : void
		{
			if (_unitDefine[name_] == null)
			{
				trace("playUnit failed : unregisted unit:", name_);
				return;
			}
			// 记录当前播放的单元
			_unitName = name_;
			_playMode = PLAYMODE_UNIT;
			if (fps_) this.fps = fps_;
			_paused = false;
			// 记录当前播放单元的帧数
			_curUnitTotalFrame = (_unitDefine[name_] as Array).length;
			_curUnitFrame = 0;
			showFrame(_unitDefine[name_][_curUnitFrame]);
		}

		override public function dispose() : void
		{
			//MovieShim目前只允许从pool创建，所以析构中不释放位图
			//停止播放
			stop();
			//清除回调和监听
			onComp = null;
			//定时
			_timer.reset();
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer = null;
			//清除位图资源
			_bmd = null;
			//重置数据
			_frame = [];
			//
			super.dispose();
		}


	}
}
