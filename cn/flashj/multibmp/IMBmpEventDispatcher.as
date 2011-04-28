package cn.flashj.multibmp
{
	/**
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2011-1-6
	 */
	public interface IMBmpEventDispatcher
	{
		function addListener(type : String,listener : Function) : void;

		function dispatchEvent(event : MBmpEvent) : void;

		function removeListener(type : String,listener : Function) : void;

		function hasListener(type : String) : Boolean;

		function removeAllListener() : void;

	}
}
