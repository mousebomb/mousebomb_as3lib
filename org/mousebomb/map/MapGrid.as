package org.mousebomb.map 
{

	/**
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-10-3
	 */
	public class MapGrid 
	{
		private var _startNode : Node;
		private var _endNode : Node;
		private var _nodes : Array;
		private var _numCols : uint;
		private var _numRows : uint;

		public function MapGrid(cols : uint,rows : uint) 
		{
			_numCols = cols;
			_numRows = rows;
			_nodes = [];
			for(var i : int = 0 ;i < cols;i++)
			{
				_nodes[i] = [];
				for ( var j : int = 0 ;j < rows ;j++)
				{
					_nodes[i][j] = new Node(i, j);
				}
			}
		}

		/**
		 * 获得一个坐标的节点
		 */
		public function getNode(x : int,y : int) : Node
		{
			return _nodes[x][y];
		}

		/**
		 * 设置一个坐标的节点的可走与否
		 */
		public function setWalkable(x : int,y : int,walkable : Boolean) : void
		{
			_nodes[x][y].walkable = walkable;
		}

		/**
		 * 起始节点
		 */
		public function get startNode() : Node
		{
			return _startNode;
		}


		/**
		 * 目标节点
		 */
		public function get endNode() : Node
		{
			return _endNode;
		}


		public function setStartNode(x : int,y : int) : void
		{
			_startNode = _nodes[x][y];
		}

		public function setEndNode(x : int,y : int) : void
		{
			_endNode = _nodes[x][y];
		}

		/**
		 * 列数
		 */
		public function get numCols() : uint
		{
			return _numCols;
		}

		/**
		 * 行数
		 */
		public function get numRows() : uint
		{
			return _numRows;
		}
	}
}
