package org.mousebomb.interactive 
{
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import org.mousebomb.events.KeyDownEvent;
	import org.mousebomb.events.MousebombEvent;
	
	/**
	 * 重新广播键按下的监听器
	 * @author Mousebomb@qoolu
	 */
	public class KeyDownListener extends EventDispatcher
	{
		private var __target:InteractiveObject ;//被我监听的对象
		
		public function get target():InteractiveObject
		{
			return this.__target;
		}
		
		/**
		 * 初始化
		 * @param	_target	要监听按键的对象
		 */
		public function KeyDownListener(_target:InteractiveObject):void
		{
			this.__target = _target;
			this.__target.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDownH);
			this.__target.addEventListener(KeyboardEvent.KEY_UP, onKeyUpH);
		}
		/**
		 * 释放我的资源
		 */
		public function dispose():void
		{
			this.__target.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDownH);
		}
		/**
		 * 键被按下
		 * @param	e	事件对象
		 */
		private function onKeyDownH(e:KeyboardEvent):void
		{
			switch (e.keyCode) 
			{
				case KeyCode.A:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_A));
					break;
				case KeyCode.B:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_B));
					break;
				case KeyCode.C:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_C));
					break;
				case KeyCode.D:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_D));
					break;
				case KeyCode.E:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_E));
					break;
				case KeyCode.F:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_F));
					break;
				case KeyCode.G:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_G));
					break;
				case KeyCode.H:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_H));
					break;
				case KeyCode.I:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_I));
					break;
				case KeyCode.J:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_J));
					break;
				case KeyCode.K:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_K));
					break;
				case KeyCode.L:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_L));
					break;
				case KeyCode.M:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_M));
					break;
				case KeyCode.N:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_N));
					break;
				case KeyCode.O:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_O));
					break;
				case KeyCode.P:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_P));
					break;
				case KeyCode.Q:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_Q));
					break;
				case KeyCode.R:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_R));
					break;
				case KeyCode.S:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_S));
					break;
				case KeyCode.T:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_T));
					break;
				case KeyCode.U:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_U));
					break;
				case KeyCode.V:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_V));
					break;
				case KeyCode.W:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_W));
					break;
				case KeyCode.X:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_X));
					break;
				case KeyCode.Y:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_Y));
					break;
				case KeyCode.Z:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_Z));
					break;
				case KeyCode.SPACE:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_DOWN_SPACE));
					break;
			}
		}
			
			
		/**
		 * 键被弹起
		 * @param	e	事件对象
		 */
		private function onKeyUpH(e:KeyboardEvent):void
		{
			switch (e.keyCode) 
			{
				case KeyCode.A:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_A));
					break;
				case KeyCode.B:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_B));
					break;
				case KeyCode.C:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_C));
					break;
				case KeyCode.D:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_D));
					break;
				case KeyCode.E:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_E));
					break;
				case KeyCode.F:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_F));
					break;
				case KeyCode.G:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_G));
					break;
				case KeyCode.H:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_H));
					break;
				case KeyCode.I:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_I));
					break;
				case KeyCode.J:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_J));
					break;
				case KeyCode.K:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_K));
					break;
				case KeyCode.L:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_L));
					break;
				case KeyCode.M:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_M));
					break;
				case KeyCode.N:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_N));
					break;
				case KeyCode.O:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_O));
					break;
				case KeyCode.P:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_P));
					break;
				case KeyCode.Q:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_Q));
					break;
				case KeyCode.R:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_R));
					break;
				case KeyCode.S:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_S));
					break;
				case KeyCode.T:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_T));
					break;
				case KeyCode.U:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_U));
					break;
				case KeyCode.V:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_V));
					break;
				case KeyCode.W:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_W));
					break;
				case KeyCode.X:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_X));
					break;
				case KeyCode.Y:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_Y));
					break;
				case KeyCode.Z:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_Z));
					break;
				case KeyCode.SPACE:
					this.dispatchEvent(new Event(KeyDownEvent.KEY_UP_SPACE));
					break;	
			}
		}
		
		
	}
	
}