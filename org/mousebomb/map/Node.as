package org.mousebomb.map 
{

	/**
	 * 地图节点
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-10-3
	 */
	public class Node 
	{
		public var x : int;
		public var y : int;
		public var f : Number;		public var g : Number;		public var h : Number;
		public var walkable : Boolean = true;
		public var parent : Node;

		/**
		 * 节点
		 */
		public function Node(x : int,y : int) 
		{
			this.x = x;
			this.y = y;
		}
		public function toString() : String {
			return "Node x=" + x + ",y="+y + ",walkable="+walkable;
		}
	}
}
