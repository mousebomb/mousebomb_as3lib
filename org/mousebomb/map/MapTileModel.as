package org.mousebomb.map
{

	/**
	 * 地图模型类
	 * 
	 */	
	public class MapTileModel implements IMapTileModel
	{
		private var m_map : Array;

		public function MapTileModel()
		{
		}

		public function get map() : Array
		{
			return this.m_map;
		}

		/**
		 * 赋予map值
		 * map需要是一个描述地图上每个象素是通路1还是障碍0的数组
		 */
		public function set map(p_value : Array) : void
		{
			this.m_map = p_value;
		}

		/**
		 * 是否为障碍
		 * @param p_startX	始点X坐标
		 * @param p_startY	始点Y坐标
		 * @param p_endX	终点X坐标
		 * @param p_endY	终点Y坐标
		 * @return 0为障碍 1为通路
		 */
		public function isBlock(p_startX : int, p_startY : int, p_endX : int, p_endY : int) : int
		{
			var mapWidth : int = this.m_map.length;
			var mapHeight : int = this.m_map[0].length;
			
			if (p_endX < 0 || p_endX == mapWidth || p_endY < 0 || p_endY == mapHeight)
			{
				return 0;
			}
			return this.m_map[p_endX][p_endY];
		}
	}
}