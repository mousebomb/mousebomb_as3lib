package org.mousebomb.display {
	import flash.events.*;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.LineScaleMode;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.filters.BitmapFilter;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.DropShadowFilter;
	import flash.utils.Timer;
	
	public class Tooltip extends Sprite implements IToolTip {
		
		internal var tipString:TextField;
		internal var board:Shape;
		internal var boardShadow:Shape;
		internal var timer:Timer;
		internal var filter:BitmapFilter;
		
		public function Tooltip():void{
			init();
			this.addEventListener(Event.ADDED_TO_STAGE,onLoad);
		}
		/**构建一个文本框,一个白色底板*/
		private function init():void
		{
			this.visible=false;
			timer=new Timer(3000);
			timer.delay=3000;
			timer.addEventListener(TimerEvent.TIMER,timerHandler);
			
			tipString=new TextField();
			tipString.x=2;
			tipString.multiline=false;
			tipString.selectable=false;
			tipString.autoSize=flash.text.TextFieldAutoSize.LEFT;
			
			board=new Shape();
			with(board.graphics)
			{
				lineStyle(1,0xe7e7e7,1,false,LineScaleMode.NONE);
				beginFill(0xf7f7f7);
				drawRect(0,0,10,10);
				endFill();
			}
			boardShadow=new Shape();
			with(boardShadow.graphics)
			{
				//lineStyle(0,0x333333,1,false,LineScaleMode.NONE);
				beginFill(0x333333,0.5);
				drawRect(0,0,10,10);
				endFill();
			}
			
			this.addChild(boardShadow);
			this.addChild(board);
			this.addChild(tipString);
		}
		private function onLoad(e:Event):void
		{
			/*虑镜*/
			/*var myFilter:DropShadowFilter=new DropShadowFilter(3,45,0x000000,0.75,3,3,0.60,BitmapFilterQuality.MEDIUM,false,false);
			var filtersArr:Array=new Array(myFilter);
			this.filters=filtersArr;			*/
		}
		private function updatePos(e:Event):void
		{
			this.x=parent.mouseX;
			this.y=parent.mouseY-20;
			if(this.width + this.x >stage.stageWidth)
			{
				this.x-=(width + x -stage.stageWidth);
			}
			if(this.y<0)
			{
				this.y=parent.mouseY+18;
			}
		}
		
		public function showTip(str:String):void
		{
			this.visible=true;
			tipString.htmlText=str;
			board.scaleX=((tipString.width+4)/10);
			board.height=tipString.height+2;
			boardShadow.scaleX=((tipString.width+4)/10);
			boardShadow.height=tipString.height+2;
			boardShadow.x=3;
			boardShadow.y=3;
			
			timer.reset();
			timer.start();
			
			this.addEventListener(Event.ENTER_FRAME,updatePos);
		}
		public function hideTip():void
		{
			this.visible=false;
			this.removeEventListener(Event.ENTER_FRAME,updatePos);
		}
		
		private function timerHandler(e:TimerEvent):void
		{
			hideTip();
			timer.reset();
		}
		
	}
}