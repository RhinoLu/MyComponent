package com.godsmao.ui
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * @author Rhino Lu
	 */
	public class MyComboBox extends Sprite
	{
		public var btn:MovieClip;
		public var container:Sprite;
		public var _mask:Sprite;
		
		private var clip_array:Array;
		private var _dataProvider:Array;
		private var _selectedIndex:uint;
		private var _selectedLabel:String;
		private var btn_value_txt:TextField;
		private var scroll:MyComboScrollBar;
		
		
		public function MyComboBox() 
		{
			btn_value_txt = btn.getChildByName("value_txt") as TextField;
			stage?init():addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addEventListener("CLIP_CLICK", onClipClick);
			
			btn.buttonMode = true;
			btn.mouseChildren = false;
			btn.addEventListener(MouseEvent.ROLL_OVER, onBtnOver);
			btn.addEventListener(MouseEvent.ROLL_OUT , onBtnOut);
			btn.addEventListener(MouseEvent.CLICK    , onBtnClick);
			
			container.mask = _mask;
			container.visible = false;
		}
		
		private function onBtnOver(e:MouseEvent):void 
		{
			btn.gotoAndStop(2);
		}
		
		private function onBtnOut(e:MouseEvent):void 
		{
			btn.gotoAndStop(1);
		}
		
		private function onBtnClick(e:MouseEvent):void 
		{
			if (container.visible) {
				hideContainer();
			}else {
				if (_dataProvider) {
					showContainer();
				}
			}
		}
		
		private function showContainer():void 
		{
			//trace("addContainer");
			container.visible = true;
			scroll.visible = true;
			scroll.startScroll();
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
		}
		
		private function onStageMouseDown(e:MouseEvent):void 
		{
			//trace(this.contains(e.target as DisplayObject));
			if (e.target is DisplayObject && this.contains(e.target as DisplayObject)) {
				
			}else {
				hideContainer();
			}
		}
		
		private function hideContainer():void 
		{
			container.visible = false;
			scroll.visible = false;
			scroll.stopScroll();
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
		}
		
		private function addClip():void 
		{
			removeClip();
			clip_array = [];
			var len:uint = _dataProvider.length;
			var clip:MyComboBoxClip;
			var i:uint;
			for (i = 0; i < len; i++) {
				clip = new MyComboBoxClip();
				clip.index = i;
				clip.value_txt.text = String(_dataProvider[i]);
				clip.x = 0;
				clip.y = 30 * i;
				container.addChild(clip);
				clip_array.push(clip);
			}
		}
		
		private function removeClip():void 
		{
			if (!clip_array) return;
			var len:uint = clip_array.length;
			var clip:MyComboBoxClip;
			var i:uint;
			for (i = 0; i < len; i++) {
				clip = clip_array[i];
				clip.dispose();
				container.removeChild(clip);
			}
		}
		
		private function onClipClick(e:Event):void 
		{
			//trace("onClipClick");
			var clip:MyComboBoxClip = e.target as MyComboBoxClip;
			btn_value_txt.text = clip.value_txt.text;
			_selectedIndex = clip.index;
			_selectedLabel = clip.value_txt.text;
			hideContainer();
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function addScrollBar():void 
		{
			if (!scroll) {
				scroll = new MyComboScrollBar();
				scroll.scrollTarget = container;
				scroll.scrollTargetMask = _mask;
				scroll.x = 128;
				scroll.y = 31;
				addChild(scroll);
			}
			scroll.startScroll();
		}
		
		public function dispose():void
		{
			removeEventListener("CLIP_CLICK", onClipClick);
			if (stage) stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
			btn.removeEventListener(MouseEvent.ROLL_OVER, onBtnOver);
			btn.removeEventListener(MouseEvent.ROLL_OUT , onBtnOut);
			btn.removeEventListener(MouseEvent.CLICK    , onBtnClick);
			removeClip();
			clip_array = null;
		}
		
		public function set dataProvider(value:Array):void 
		{
			_dataProvider = value;
			btn_value_txt.text = String(_dataProvider[0]);
			addClip();
			addScrollBar();
			hideContainer();
		}
		
		public function get dataProvider():Array 
		{
			return _dataProvider;
		}
		
		public function get selectedIndex():uint 
		{
			return _selectedIndex;
		}
		
		public function set selectedIndex(value:uint):void 
		{
			_selectedIndex = value;
			_selectedLabel = String(_dataProvider[value]);
		}
		
		public function get selectedLabel():String 
		{
			return _selectedLabel;
		}
	}
}