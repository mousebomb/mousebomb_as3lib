package org.mousebomb.media.musicPlayerV4
{
	import flash.events.Event;

	/**
	 * @author mousebomb mousebomb@gmail.com
	 * created: 20121024 
	 * last modified: 20121024
	 */
	public class MusicEvent extends Event
	{
		public function MusicEvent(type : String, data_ : Object = null, bubbles : Boolean = false, cancelable : Boolean = false) : void
		{
			super(type, bubbles, cancelable);
			data = data_;
		}

		public static const LIST_COMPLETE : String = "列表加载完毕";
		public static const REGIST_SUCCESS : String = "注册成功";
		public static const REGIST_FAIL : String = "注册失败";
		public static const LOGIN_SUCCESS : String = "登陆成功";
		public static const LOGIN_FAIL : String = "登陆失败";
		public static const SOUND_START : String = "音乐开始播放";
		public static const SOUND_STOP : String = "音乐播放停止";
		public static const SOUND_TRACK_CHANGED : String = "音乐更换d";
		public static const MOUSE_DCLICK : String = "鼠标双击";
		public static const SEND_COMPLETE : String = "发送完成";
		public static const GET_COMPLETE : String = "接收完成";
		public static const TIMEOUT_FAIL : String = "由于超时而失败";
		public static const DUPLICATED_REQUEST : String = "重复调用请求";
		public var data : Object;
	}
}
