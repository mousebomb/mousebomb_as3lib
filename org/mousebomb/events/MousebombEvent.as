//****************************************************************************
// Mousebomb.org ActionScript Library
// Event 
//****************************************************************************
package org.mousebomb.events
{
	import flash.events.Event;	

	public class MousebombEvent extends Event
	{
		public static const LIST_COMPLETE:String	=	"列表加载完毕";
		public static const REGIST_SUCCESS:String	=	"注册成功";
		public static const REGIST_FAIL:String		=	"注册失败";
		public static const LOGIN_SUCCESS:String	=	"登陆成功";
		public static const LOGIN_FAIL:String		=	"登陆失败";
		public static const SOUND_START:String		=	"音乐开始播放";
		public static const SOUND_STOP:String		=	"音乐播放停止";
		
		public static const SOUND_TRACK_CHANGED:String		=	"音乐更换d";
		
		public static const MOUSE_DCLICK:String		=	"鼠标双击";
		
		public static const SEND_COMPLETE:String	=	"发送完成";
		public static const GET_COMPLETE:String		=	"接收完成";
		public static const TIMEOUT_FAIL:String		=	"由于超时而失败";
		
		public static const DUPLICATED_REQUEST:String	=	"重复调用请求";
		
		private var _data:Object;
		public function MousebombEvent(type : String,data:Object=null, bubbles : Boolean = false, cancelable : Boolean = false):void
		{
			super(type,bubbles, cancelable);
			this._data = data;
		}
		
		public function get data() : Object
		{
			return _data;
		}
		
		public function set data(data : Object) : void
		{
			_data = data;
		}
	}
}