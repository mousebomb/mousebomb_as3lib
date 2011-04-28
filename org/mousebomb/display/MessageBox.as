/**
* 消息提示框
* @author Mousebomb
* @since 08.10.7
* @version 1.8.10.7
*/

package org.mousebomb.display
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.text.TextField;
	import flash.events.*;

	public class MessageBox extends Sprite
	{
		var str:String="";
		var returnFunc:Function;
		
		public var backBoard:SimpleButton;
		public var alertBoard:Sprite;
		public var alertText:TextField;
		public var okBtn:SimpleButton;
		
		public function MessageBox(msg:String=""):void
		{
			this.visible = false;
			this.okBtn.addEventListener(MouseEvent.CLICK,closeH);
			this.okBtn.addEventListener(MouseEvent.CLICK,callBackH);
			this.backBoard.useHandCursor = false;
			this.okBtn.useHandCursor = false;
		}
		private function closeH(e:MouseEvent):void
		{
			this.visible = false;
		}
		private function callBackH(e:MouseEvent):void
		{
			if(this.returnFunc!=null)
			{
				this.returnFunc();
			}
		}
		
		public function show(s:String="提示",f:Function=null):void
		{
			this.scaleByStage();
			this.visible = true;
			this.alertText.text = s;
			this.returnFunc = f;
		}
		public function scaleByStage():void {
			if(stage.align==StageAlign.TOP_LEFT){
				backBoard.width=stage.stageWidth;
				backBoard.height=stage.stageHeight;
				backBoard.x=0;
				backBoard.y=0;
				alertBoard.y=(stage.stageHeight)/2-alertBoard.height;
				alertBoard.x=(stage.stageWidth)/2;
			}else{
				backBoard.width=stage.width;
				backBoard.height=stage.height;
				alertBoard.y=stage.height/2-alertBoard.height;
			}
			alertText.y = alertBoard.y + 10.7;
			alertText.x = alertBoard.x - 108.5;
			okBtn.x = alertBoard.x;
			okBtn.y = alertBoard.y + 83.8;

		}
	}

}