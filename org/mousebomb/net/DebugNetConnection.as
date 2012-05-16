package org.mousebomb.net
{
	import com.demonsters.debugger.MonsterDebugger;

	import flash.net.NetConnection;
	import flash.net.Responder;

	public class DebugNetConnection extends NetConnection
	{
		public function DebugNetConnection()
		{
			super();
		}

		override public function call( command:String, responder:Responder, ...args ):void
		{
			var argArray:Array = [ command, responder ];
			var traceObj:Object = { command:command };
			for each(var arg :* in args)
			{
				argArray.push( arg );
			}
			traceObj["args"] = args;
			MonsterDebugger.trace( "NetConn.call " + command + ":", traceObj );
			super.call.apply( this, argArray );
		}

	}
}