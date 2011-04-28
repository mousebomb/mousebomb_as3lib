package org.mousebomb.classLoader 
{

	/**
	 * @author Mousebomb
	 * @date 2009-8-4
	 */
	public interface IClassLoader 
	{
		function loadFile(url:String,shared:Boolean = false,cacheCode : String = ""):void;
		
		function getClass(name:String):Class;
		
		function isFree():Boolean;
	}
}
