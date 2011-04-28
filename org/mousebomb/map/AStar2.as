package org.mousebomb.map 
{
	import flash.utils.Endian;
	import org.mousebomb.utils.TimerCounter;

	/**
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-10-3
	 */
	public class AStar2 
	{
		//
		private var _open : Array ;
		private var _closed : Array;
		private var _grid : MapGrid;
		private var _endNode : Node;
		private var _startNode : Node;
		private var _path : Array;
		//启发函数 @arg=当前节点
		private var _heuristic : Function = edt;
		//直线代价
		public static const COST_STRAIGHT : Number = 1.0;
		//斜角代价
		public static const COST_DIAG : Number = Math.SQRT2;

		public function AStar2() 
		{
		}

		/**
		 * 尝试寻路
		 * 若成功，则可以通过AStar.path 获得路径
		 * @return 是否寻路成功
		 * @param grid 地图网格模型，其中指定了起始节点和目标节点
		 */		
		public function findPath(grid : MapGrid) : Boolean
		{
			_grid = grid;
			_open = [];
			_closed = [];
			
			_startNode = _grid.startNode;
			_endNode = _grid.endNode;
			
			_startNode.g = 0;
			_startNode.h = _heuristic(_startNode);
			_startNode.f = _startNode.g + _startNode.h;
			
			return search();
		}

		private function search() : Boolean 
		{
			TimerCounter.startTask("Astar findPath");
			var node : Node = _startNode;
			while(node != _endNode)
			{
				//忽略地图边缘
				//取得需要对比的九宫格
				var startX : int = Math.max(0, node.x - 1);
				var endX : int = Math.min(_grid.numCols - 1, node.x + 1);
				
				var startY : int = Math.max(0, node.y - 1);
				var endY : int = Math.min(_grid.numRows - 1, node.y + 1);
				
				for(var i : int = startX;i <= endX;i++)
				{
					for(var j : int = startY;j <= endY;j++)
					{
						//获得当前比较的节点
						var test : Node = _grid.getNode(i, j);
						//无视当前节点自身，无视不可走的节点
						if(test == node || !test.walkable) continue;
						//计算代价g的因子
						var cost : Number = COST_STRAIGHT;
						if(!(test.x == node.x || test.y == node.y ))
						{
							cost = COST_DIAG;
						}
						//计算代价
						var g : Number = node.g + cost;
						var h : Number = _heuristic(test);
						var f : Number = g + h;
						//
						if(isOpen(test) || isClosed(test))
						{
							//若此节点在待查列表或已查列表中
							if(test.f > f)
							{
								//且此节点的代价比此次算下来的代价大（必定在待查列表中），则更新代价
								test.f = f;
								test.g = g;
								test.h = h;
								test.parent = node;
							}
						}
						else
						{
							//若不在待查列表或已查列表中，则分配代价 并加入待查列表
							test.f = f;
							test.g = g;
							test.h = h;
							test.parent = node;
							_open.push(test);
						}
					}
				}
				//完成了一个节点周围的九宫检查
				_closed.push(node);
				//
				if(_open.length == 0)
				{
					//若无待查列表内容，说明路不通
					trace("no path");
					return false;
				}
				//找出待查列表中最有价值的跟进
				_open.sortOn("f", Array.NUMERIC);
				node = _open.shift();
			}
			buildPath();
			TimerCounter.endTask("Astar findPath");
			return true;
		}

		private function buildPath() : void
		{
			_path = [];
			var node : Node = _endNode;
			_path.push(node);
			//回溯
			while(node != _startNode)
			{
				node = node.parent;
				_path.unshift(node);
			}
		}

		public function get path() : Array
		{
			return _path;
		}

		/**
		 * 是否在待查列表中
		 */
		private function isOpen(node : Node ) : Boolean
		{
			return (_open.indexOf(node) != -1);
		}

		/**
		 * 是否在已查列表中
		 */
		private function isClosed(node : Node) : Boolean
		{
			return (_closed.indexOf(node) != -1);
		}

		public function get visited() : Array
		{
			return _closed.concat(_open);
		}

		/*
		 * Functions
		 */
		/**
		 * 曼哈顿启发函数
		 */
		public function manhattan(node : Node) : Number
		{
			return Math.abs(node.x - _endNode.x) * COST_STRAIGHT + Math.abs(node.y + _endNode.y) * COST_STRAIGHT;
		}

		/**
		 * 欧几里德几何启发函数
		 */
		public function euclidian(node : Node) : Number
		{
			var dx : Number = node.x - _endNode.x;
			var dy : Number = node.y - _endNode.y;
			return Math.sqrt(dx * dx + dy * dy) * COST_STRAIGHT;
		}

		/**
		 * 对角启发函数
		 * 效率高，访问的不必要节点最少，但路径并不是非常自然
		 */
		public function diagonal(node : Node) : Number
		{
			var dx : Number = Math.abs(node.x - _endNode.x);
			var dy : Number = Math.abs(node.y - _endNode.y);
			var diag : Number = Math.min(dx, dy);
			var straight : Number = dx + dy;
			return COST_DIAG * diag + COST_STRAIGHT * (straight - 2 * diag);
		}
		
		public function edt(node:Node):Number
		{
			return (Math.abs(_endNode.x - node.x) + Math.abs(_endNode.y - node.y)) * COST_STRAIGHT;
		}

		/**
		 * 设置启发函数
		 */
		public function set heuristic(v : Function) : void
		{
			_heuristic = v;
		}
	}
}
