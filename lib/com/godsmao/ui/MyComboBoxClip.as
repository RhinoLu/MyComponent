package com.godsmao.ui
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * @author Rhino Lu
	 */
	public class MyComboBoxClip extends MovieClip
	{
		public var value_txt:TextField;
		
		private var _index:uint;
		
		public function MyComboBoxClip() 
		{
			stage?init():addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			buttonMode = true;
			mouseChildren = false;
			addEventListener(MouseEvent.ROLL_OVER, onOver);
			addEventListener(MouseEvent.ROLL_OUT , onOut);
			addEventListener(MouseEvent.CLICK    , onClick);
		}
		
		private function onOver(e:MouseEvent):void 
		{
			gotoAndStop(2);
		}
		
		private function onOut(e:MouseEvent):void 
		{
			gotoAndStop(1);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			dispatchEvent(new Event("CLIP_CLICK", true));
		}
		
		public function dispose():void
		{
			removeEventListener(MouseEvent.ROLL_OVER, onOver);
			removeEventListener(MouseEvent.ROLL_OUT , onOut);
			removeEventListener(MouseEvent.CLICK    , onClick);
		}
		
		public function get index():uint 
		{
			return _index;
		}
		
		public function set index(value:uint):void 
		{
			_index = value;
		}
		
		
	}

}