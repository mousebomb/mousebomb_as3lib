package org.mousebomb.net
{
	import flash.net.NetConnection;
	import flash.net.Responder;

	import org.mousebomb.utils.Debug;

	public class DebugNetConnection extends NetConnection
	{
		public function DebugNetConnection()
		{
			super();
		}

		private var _debugMode : Boolean = true;

		/**
		 * 调用服务器
		 * 取决于是否debug
		 */
		public function callServer(command : String, callBack : Function, ...args : *) : void
		{
			if(_debugMode)
			{
				var responder : Responder = new DebugResponder(callBack, null, command);
				var argArray : Array = [command,responder];
				var traceObj : Object = {command:command};
				for each(var arg :* in args)
				{
					argArray.push(arg);
				}
				traceObj["args"] = args;
				Debug.trace4Target("NetConn.call "+command+":", traceObj);
				super.call.apply(this, argArray);
			}
			else
			{
				super.call(command, new Responder(callBack));
			}
		}

		/**
		 * 调试模式
		 */
		public function get debugMode() : Boolean
		{
			return _debugMode;
		}

		public function set debugMode(debugMode : Boolean) : void
		{
			_debugMode = debugMode;
		}
	}
}