package org.mousebomb.bmpdisplay 
{

	/**
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-6-23
	 */
	public interface IBmdEventDispatcher 
	{
		function addListener(type : String,listener : Function) : void;
		function dispatchEvent(event : BmdEvent) : void;

		function removeListener(type : String,listener : Function) : void;

		function hasListener(type : String) : Boolean;
		function removeAllListener() : void;

		function set interactive(v : Boolean) : void;

		function get interactive() : Boolean;
	}
}
