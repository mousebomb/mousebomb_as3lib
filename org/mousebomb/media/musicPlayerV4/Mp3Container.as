/** Mousebomb V9 Flash Site Actions **
 * 功能：对Sound对象托管，提供加载、播放、暂停、停止/切换歌曲,进度属性
 * */
package org.mousebomb.media.musicPlayerV4
{
	import org.mousebomb.events.MousebombEvent;

	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class Mp3Container extends EventDispatcher 
	{

		//**字段**
		//pos暂停时记录播放头位置(ms)
		private var pos : Number = 0;
		//soundFactory返回声音对象
		private var soundFactory : Sound;
		//channel返回声道对象
		private var channel : SoundChannel;
		//SoundTransform
		private var sTransform : SoundTransform;
		//有channel在播放的flag
		private var flag : Boolean = false;

		//**属性**
		//列表數組{soundTitle:mp3ListXml[i].@SoundTitle,soundSrc:mp3ListXml[i].@Src}
		public var mp3List : Array;
		//percent音乐加载百分比{100%}
		public var percent : String;
		//nowId当前打开的id号
		public var nowId : int = -1;
		//声音信息对象{time,comment,artist,title,album}
		public var mp3Info : Object;
		public var hasID3 : Boolean;
		//原始xml
		public var mp3Xml : XML;

		public var autoPlay : Boolean = true;
		//自动处理,默认打开,若打开则自动换歌等
		public var seqPlay : Boolean = true;

		//是否顺序播放/false为随机播放

		/*托管属性*/
		//播放头位置
		public function get soundPos() : Number
		{
			return channel.position;
		}

		public function get soundLen() : Number
		{
			return soundFactory.length;
		}		

		//**方法**
		//构造函数
		public function Mp3Container(_url : String = "",_autoPlay : Boolean = true) 
		{
			trace("mp3Player", _autoPlay);
			autoPlay = _autoPlay;
			if(_url)
			{
				readList(_url);
			}
		}

		//readList读取列表
		public function readList(url : String) : void 
		{
			var urlR : URLRequest = new URLRequest(url);
			var urlL : URLLoader = new URLLoader(urlR);
			urlL.addEventListener(IOErrorEvent.IO_ERROR, ioErr);
			urlL.addEventListener(Event.COMPLETE, readListHandler);
		}

		private function readListHandler(e : Event) : void 
		{
			//读取列表ok
			e.target.removeEventListener(Event.COMPLETE, readListHandler);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, ioErr);
			var mp3ListXml : XMLList;
			mp3List = [];
			mp3Xml = XML(e.target.data);
			mp3ListXml = XMLList(mp3Xml.sound.mp3);
			for (var i : int = 0;i < mp3ListXml.length();i++) 
			{
				mp3List[i] = {soundTitle:mp3ListXml[i].@SoundTitle, soundSrc:mp3ListXml[i].@Src};
			}
			onListOK();
		}

		//loadMp3打开列表中第id号音频文件
		private function loadMp3(id : int) : Sound 
		{
			var urlR : URLRequest = new URLRequest(mp3List[id].soundSrc);
			if (flag == true) 
			{
				channel.stop();
			}
			if (soundFactory) 
			{
				//本来这里是soundFactory.url判断是否在加载，若在加载就close；后来发现即使执行了load也不会立即有url属性，所以改成只要有实例就尝试close并且释放资源重新加载。
				try 
				{
					soundFactory.close();//這玩意只針對Stream,如何釋放完成后sound的資源呢.
				} catch (e : *) 
				{
				}
				//清除所有资源
				soundFactory.removeEventListener(Event.ID3, onID3Handler);
				soundFactory.removeEventListener(Event.OPEN, openHandler);
				soundFactory.removeEventListener(IOErrorEvent.IO_ERROR, ioErr);
				soundFactory.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
				soundFactory.removeEventListener(Event.COMPLETE, completeHandler);
			}
			soundFactory = new Sound();
			hasID3 = false;
			soundFactory.load(urlR);
			soundFactory.addEventListener(Event.ID3, onID3Handler);
			soundFactory.addEventListener(Event.OPEN, openHandler);
			soundFactory.addEventListener(IOErrorEvent.IO_ERROR, ioErr);
			soundFactory.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			soundFactory.addEventListener(Event.COMPLETE, completeHandler);
			mp3Info = {};
			mp3Info.time = soundFactory.length;
			pos = 0;
			nowId = id;
			return soundFactory;
		}

		private function openHandler(e : Event) : void 
		{
			soundFactory.removeEventListener(Event.OPEN, openHandler);
			onSoundOpen();
		}

		private function onID3Handler(e : Event) : void 
		{
			//写入mp3Info
			soundFactory.removeEventListener(Event.ID3, onID3Handler);
			//尝试获取id3
			try
			{
				//置空
				mp3Info = {};
				with (mp3Info) 
				{
					time = soundFactory.length;
					comment = soundFactory.id3.comment;
					artist = soundFactory.id3.artist;
					title = soundFactory.id3.songName;
					album = soundFactory.id3.album ;
				}
				hasID3 = true;
				onID3OK();
			}catch(e : *)
			{
			}
		}

		private function progressHandler(e : ProgressEvent) : void 
		{
			//计算下载百分比
			percent = Math.floor(e.bytesLoaded / e.bytesTotal) + "%";
			onSoundLoading();
		}

		private function completeHandler(e : Event) : void 
		{
			soundFactory.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			soundFactory.removeEventListener(Event.COMPLETE, completeHandler);
			onSoundLoadOK();
		}

		//playMp3播放 从头播放
		private function playMp3() : SoundChannel 
		{
			if (flag) 
			{
				channel.stop();
			}
			channel = soundFactory.play();
			sTransform = channel.soundTransform;
			channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			flag = true;
			return channel;
		}

		private function soundCompleteHandler(e : Event) : void 
		{
			channel = null;
			flag = false;
			onPlayOK();
		}

		public function loadAndPlayMp3(id : int) : void
		{
			loadMp3(id);
			playMp3();			
		}

		//pauseMp3暂停播放记录pos位置/从断开位置继续播放
		public function pauseMp3() : void 
		{
			if(flag)
			{
				pos = channel.position;
				channel.stop();
				channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				channel = null;
				flag = false;
			}
			else
			{
				channel = soundFactory.play(pos);
				sTransform = channel.soundTransform;
				channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				flag = true;
			}
		}

		//停止播放pos清零,声道释放
		public function stopMp3() : void 
		{
			if(flag)
			{
				pos = 0;
				channel.stop();
				channel.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
				channel = null;
				//要手动清么?
				flag = false;
			}
		}

		//上首
		public function prevMp3() : int 
		{
			if (nowId > 0) 
			{
				nowId--;
			} 
			else 
			{
				nowId = mp3List.length - 1;
			}
			loadMp3(nowId);
			playMp3();
			return nowId;
		}

		//下首
		public function nextMp3() : int 
		{
			if (nowId < mp3List.length - 1) 
			{
				nowId++;
			} 
			else 
			{
				nowId = 0;
			}
			loadMp3(nowId);
			playMp3();
			return nowId;
		}

		//设置音量([0,100])
		public function setVol(v : int) : void 
		{
			sTransform.volume = v / 100;
		}

		//设置平衡([-100,100])
		public function setPan(p : int) : void 
		{
			sTransform.volume = p / 100;
		}

		//其他内部函数
		private function ioErr(e : Event) : void 
		{
			onIOErr();
			trace("err occurs: ", e);
		}

		//**对外事件**
		//列表获取OK
		private function onListOK() : void 
		{
			dispatchEvent(new Event(MousebombEvent.LIST_COMPLETE));
			var r : int = Math.floor(Math.random() * (mp3List.length));
			if(autoPlay)
			{
				//播放
				loadAndPlayMp3(r);
			}
			else
			{
				//只load
				loadMp3(r);
			}
		}

		//onPlayOK播放完成
		private function onPlayOK() : void 
		{
			dispatchEvent(new Event(Event.SOUND_COMPLETE));
			if(autoPlay)
			{
				if(seqPlay)
				{
					nextMp3();
				}
				else
				{
					var r : int = Math.floor(Math.random() * (mp3List.length));
					while(r == nowId)
					{
						r = Math.floor(Math.random() * (mp3List.length));
					}
					loadAndPlayMp3(r);
				}
				dispatchEvent(new Event(MousebombEvent.SOUND_TRACK_CHANGED));
			}
		}

		//onSoundOpen開始载入
		private function onSoundOpen() : void 
		{
			dispatchEvent(new Event(Event.OPEN));
		}

		//onSoundLoading载入中
		private function onSoundLoading() : void 
		{
			dispatchEvent(new Event(ProgressEvent.PROGRESS));
		}

		//onSoundLoadOK声音载入ok
		private function onSoundLoadOK() : void 
		{
			dispatchEvent(new Event(Event.COMPLETE));
		}

		//onID3id3获取
		private function onID3OK() : void 
		{
			dispatchEvent(new Event(Event.ID3));
		}

		//读取mp3文件錯誤
		private function onIOErr() : void 
		{
			dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
		}

		//是否在播放
		public function get isPlaying() : Boolean
		{
			return flag;
		}

		public function get sound() : Sound
		{
			return soundFactory;
		}
	}
}