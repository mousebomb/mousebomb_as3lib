package org.mousebomb.utils
{
	import flash.net.LocalConnection;
	/**
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2011-1-6
	 */
	public class GC
	{
		public static function GCNow():void
		{
			var lc1 : LocalConnection;
			var lc2 : LocalConnection;
			try
			{
				lc1 = new LocalConnection();
				lc2 = new LocalConnection();
				lc1.connect("name");
				lc2.connect("name");
			}
			catch (e : Error)
			{
			}
			return;
		}
	}
}
