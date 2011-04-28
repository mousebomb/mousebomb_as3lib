package org.mousebomb.ui.Charts 
{
	import flash.text.TextFieldAutoSize;
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.text.TextField;

	/**
	 * 折线图
	 * @author Mousebomb (mousebomb@gmail.com)
	 * @date 2010-2-28
	 */
	public class LineChart extends Sprite 
	{
		public function LineChart()
		{
			addChild(labelLayer = new Sprite());			addChild(pointLayer = new Sprite());
			addChild(tip = new ChartTip());
		}

		internal var tip : ChartTip;
		//标签层
		private var labelLayer : Sprite;
		//点		private var pointLayer : Sprite;

		//
		private var _animation : Boolean;
		private var _w : Number = 550;
		private var _h : Number = 400;
		private var _yData : Array ; 
		private var _xData : Array;

		public function setDrawSize(w : Number,h : Number) : void
		{
			_w = w;
			_h = h;
		}

		/**
		 * @param xArr ["星期1","星期2",...]
		 * @param yArr [-1003,1650,...]
		 * @param yInterval [min:Number,max:Number] 指定y轴显示区间,若不填则自动计算
		 */
		public function setData(xArr : Array , yArr : Array,yInterval : Array = null) : void
		{
			_xData = xArr;
			_yData = yArr;
			//x间隔稍微有点余量
			xJiange = _w / (xArr.length);
			xStart = xJiange * .5;
			if(yInterval == null)
			{
				//求出y数值范围
				maxY = Number.MIN_VALUE;
				minY = Number.MAX_VALUE;
				for each(var dataItem:Number in _yData)
				{
					if(dataItem > maxY)
					{
						maxY = dataItem;
					}
					if(dataItem < minY)
					{
						minY = dataItem;
					}
				}	
				//使范围更大一点		
				maxY = Math.ceil(maxY * 1.1);
				if(minY > 0)
				{
					minY *= 0.9;
				}
				else
				{
					minY *= 1.1;
				}
				minY = Math.floor(minY);
			}
			else
			{
				minY = yInterval[0];
				maxY = yInterval[1];
			}
			//求出y方向数值与坐标值的比例
			yScaleA = (maxY - minY) / _h;
			yScaleK = minY;
			//求出加标签的间隔
			yJiange = _h / (maxY - minY);
			yJiange = 30 > yJiange ? 30 : yJiange;
		}

		//显示长度间距  显示位置 / xJiange = 显示数据
		private var xJiange : Number;
		//x起始坐标		private var xStart : Number;
		private var yJiange : Number;
		//y方向的缩放比例 y坐标*a + K = 数值
		private var yScaleA : Number;
		private var yScaleK : Number;

		//
		private var maxX : Number ;
		private var maxY : Number ;		private var minY : Number ;

		public function draw() : void
		{
			var tx : Number;			var ty : Number;
			//绘制x轴
			graphics.lineStyle(1);
			graphics.moveTo(0, _h);
			graphics.lineTo(_w, _h);
			//绘制x轴上的数值标签，平均分布
			var i : int = 0;
			for each(var item : String in _xData)
			{
				tx = xStart + xJiange * i++;
				addLabel(tx, _h, item,1);
			}
			//绘制y轴
			graphics.moveTo(0, _h);
			graphics.lineTo(0, 0);
			//绘制y轴上的数值标签，平均分布
			for (var yPos : Number = 0 ;yPos <= _h ;yPos += yJiange)
			{
				ty = _h - yPos;
				addLabel(0, ty, (Math.round(100 * (yPos * yScaleA + yScaleK)) / 100).toString(),0);
			}
			//绘制平行辅助线
			for (yPos = yJiange ;yPos <= _h ;yPos += yJiange)
			{
				ty = _h - yPos;
				graphics.lineStyle(1, 0xcccccc);
				graphics.moveTo(0, ty);
				graphics.lineTo(_w, ty);
			}
			//绘制数据
			graphics.lineStyle(2, 0x1111ff);
			tx = xStart;
			ty = _h - ((_yData[0] - yScaleK) / yScaleA);
			graphics.moveTo(tx, ty);
			i = 0;
			for each(var dataItem : Number in _yData)
			{
				var color : uint = (dataItem > 0) ? 0x1111ff : 0xff1111;
				//线
				tx = xStart + i * xJiange;
				ty = _h - ((dataItem - yScaleK) / yScaleA);
				var intro : String = _xData[i++] + "," + dataItem;
				graphics.lineStyle(2, color);
				graphics.lineTo(tx, ty);
				//点
				addPoint(tx, ty, color, intro);
			}
		}

		
		public function clear() : void
		{
			graphics.clear();
			clearLabels();
			for ( var i : int = pointLayer.numChildren - 1 ;i >= 0 ;i--)
			{
				pointLayer.removeChildAt(i);
			}
		}

		//清除所有标签
		private function clearLabels() : void
		{
			for ( var i : int = labelLayer.numChildren - 1 ;i >= 0 ;i--)
			{
				labelLayer.removeChildAt(i);
			}
		}

		/**
		 * 添加一个标签
		 * @param dir 方向 1x 0y
		 */
		private function addLabel(tx : Number,ty : Number,intro : String,dir : int) : void
		{
			//trace("addlabel",tx,ty,intro);
			var tf : TextField = new TextField();
			labelLayer.addChild(tf);
			tf.x = tx;
			tf.y = ty;
			tf.mouseEnabled = false;
			tf.height = 18;
			tf.width = 1;
			if(dir == 1)
			{
				//x
				tf.autoSize = TextFieldAutoSize.CENTER;
			}
			else
			{
				//y
				tf.autoSize = TextFieldAutoSize.RIGHT;
				tf.y = ty - 9;
			}
			tf.text = intro;
		}

		public function get animation() : Boolean
		{
			return _animation;
		}

		public function set animation(animation : Boolean) : void
		{
			_animation = animation;
		}

		private function addPoint(tx : Number,ty : Number,color : uint,intro : String) : void
		{
			var p : ChartHotPoint = new ChartHotPoint(this, color, intro);
			p.x = tx;
			p.y = ty;
			pointLayer.addChild(p);
		}
	}
}
