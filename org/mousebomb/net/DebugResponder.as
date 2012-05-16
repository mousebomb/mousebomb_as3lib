package org.mousebomb.net
{
	import com.demonsters.debugger.MonsterDebugger;

	import flash.net.Responder;

	/**
	 * @author Mousebomb ()
	 * @date 2010-4-30
	 */
	public class DebugResponder extends Responder
	{
		public function DebugResponder( result:Function, status:Function = null, caller:String = "" )
		{
			var tresult:Function;
			if(result != null)
			{
				tresult = function( arg:* ):void
				{
					MonsterDebugger.trace( caller + " 返回结果", arg );
					result.apply( null, [ arg ] );
				};
			}
			else
			{
				tresult = function( arg:* ):void
				{
					MonsterDebugger.trace( caller + " 返回结果", arg );
				};
			}
			super( tresult, status );
		}
	}
}
