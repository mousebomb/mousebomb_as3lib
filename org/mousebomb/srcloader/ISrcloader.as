package org.mousebomb.srcloader 
{

	/**
	 * @author Mousebomb
	 * @date 2009-5-27
	 */
	public interface ISrcloader 
	{
		function load(url : String,key : String) : void;

		function isFree() : Boolean;

		function unload() : void;
	}
}
