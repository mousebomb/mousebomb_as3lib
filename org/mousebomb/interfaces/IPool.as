package org.mousebomb.interfaces
{
	/**
	 * @author Mousebomb ()
	 * @date 2011-1-9
	 */
	public interface IPool
	{
		function getOne() : *;

		function recycle(ins : *) : void;
	}
}
