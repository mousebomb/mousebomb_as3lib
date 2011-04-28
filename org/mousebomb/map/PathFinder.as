package org.mousebomb.map 
{
	import org.mousebomb.utils.TimerCounter;

	import flash.events.EventDispatcher;
	import flash.geom.Point;

	/**
	 * 通用寻路功能
	 * 给我一个通断数据、或者让我生成通断数据
	 * 在有通断数据之后，给我两点，返回路径
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-6-12
	 */
	public class PathFinder extends EventDispatcher 
	{
		private var _astar : AStar;
		//通断数据二维数组
		protected var _model : MapTileModel ;
		//寻路的单位格子大小
		private var _tileSize : Number = 10;

		public function PathFinder()
		{
			_model = new MapTileModel();
			_astar = new AStar(_model);
		}

		/**
		 * arr[x][y]=1|0
		 * 是一个描述地图上每个象素是通路1还是障碍0的数组
		 */
		public function setBlock(x : int,y : int,v : Boolean) : void
		{
			_model.map[x][y] = v?1:0;
		}

		/**
		 * 设置通断数据
		 * 二维数组
		 * arr[x][y]=1|0
		 * 是一个描述地图上每个象素是通路1还是障碍0的数组
		 */
		public function setMapModel(mapModel : Array) : void
		{
			_model.map = mapModel;
		}

		/**
		 * 寻路
		 * @param start 起点
		 * @param end 终点
		 * @return 路径表达式,经过的点及路程
		 * [point0,point2,...]
		 */
		public function getPath(start : Point,end : Point) : Array
		{
			//找到原始路径二维数组
			TimerCounter.startTask("getPath");
			var track : Array = _astar.find(start.x, start.y, end.x, end.y);
			TimerCounter.endTask("getPath");
			if(!track)
			{
				return null;
			}
			//优化后的结果点
			var rtArr : Array = [];
			var lineDir : int = 0;//直线方向 2:纵向移动  1：横向移动 3:/  4:\			var newLineDir : int = 0;//直线方向 2:纵向移动  1：横向移动 3:/  4:\
			var next : Array ;
			if(track.length > 1)
			{
				//遍历路点，把直线方向的过滤
				//第一点单独列出增加代码以减少循环中的时间复杂度
				//第一次循环则作为初始值
				lineDir = newLineDir = getMoveDirection(track[0][0], track[0][1], track[1][0], track[1][1]);
				//如果只有1个长度
				//后面的路径
				for(var i : int = 0 ;i < track.length - 1;i++)
				{
					//求出当前移动的方向 横竖撇捺
					newLineDir = getMoveDirection(track[i][0], track[i][1], track[i + 1][0], track[i + 1][1]);
					//若和之前的趋势不同，则判定为拐点
					//反之，直线运动，不管哪个方向,都继续计算
					if(lineDir == newLineDir)
					{
					//直线
					}
					else
					{
						//拐弯了，记下当前坐标作为节点
						next = track[i];
						lineDir = newLineDir;
						//从track里面删除刚刚经过的点 并把拐点存到rtArr里
						rtArr.push(new Point(next[0], next[1]));
					}
					//补上终点
					if(i == track.length - 2)
					{
						//补上终点
						next = track[i + 1];
						rtArr.push(new Point(next[0], next[1]));
					}
				}
			}
			else
			{
				rtArr = [end];
			}
			return rtArr;
		}

		/**
		 * 获取移动方向
		 * 1：横向移动  2:纵向移动  3:/  4:\
		 */
		private function getMoveDirection(oldX : int,oldY : int,newX : int,newY : int) : int
		{
			if(oldX == newX)
			{
				//x不变，为纵向移动
				return 2;
			}else  if(oldY == newY)
			{
				//y不变，为横向移动
				return 1;
			}else if((oldX < newX || oldY < newY) || (oldX > newX || oldY > newY))
			{
				//y增大，x增大 \ y减小x减小
				return 4;
			}else if((oldX < newX || oldY > newY) || (oldX > newX || oldY < newY) )
			{
				//x减小 y增大 后 x增大y减小 /
				return 3;
			}
			return 0;
		}

		/**
		 * 格子坐标转成像素坐标
		 * 自动根据tileSize转换
		 */
		public function tileToPx(tile : Point,mapOffsetX : Number = 0,mapOffsetY : Number = 0) : Point
		{
			var rtPoint : Point = new Point();
			rtPoint.x = (tile.x * _tileSize) + mapOffsetX;
			rtPoint.y = (tile.y * _tileSize) + mapOffsetY;
			return rtPoint;
		}

		/**
		 * 像素坐标转成格子坐标
		 * 自动根据tileSize转换
		 */
		public function pxToTile(px : Point,mapOffsetX : Number = 0,mapOffsetY : Number = 0) : Point
		{
			var rtPoint : Point = new Point();
			rtPoint.x = Math.floor((px.x - mapOffsetX) / _tileSize);			rtPoint.y = Math.floor((px.y - mapOffsetY) / _tileSize);
			return rtPoint;
		}

		/**
		 * 寻路的单位格子大小
		 * 影响到
		 * 1.根据图像产生通断数据的精度
		 * 2.计算tile与px单位换算
		 */
		public function get tileSize() : Number
		{
			return _tileSize;
		}

		/**
		 * 寻路的单位格子大小
		 * 影响到
		 * 1.根据图像产生通断数据的精度
		 * 2.计算tile与px单位换算
		 */
		public function set tileSize(v : Number) : void
		{
			_tileSize = v;
		}

		/**
		 * 路点通断模型对象
		 */
		public function get model() : MapTileModel
		{
			return _model;
		}
	}
}

