package com.godsmao.ui
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	/**
	 * @author Rhino Lu
	 */
	public class MyScrollBar extends Sprite
	{
		public var bar_mc:MovieClip;
		public var up_btn:MovieClip;
		public var down_btn:MovieClip;
		public var bg:MovieClip;
		public var top_helper:Sprite;
		public var bottom_helper:Sprite;
		public var wheel_factor:Number = 5; // 滑鼠中鍵滾動速度
		
		private var _scrollTarget:DisplayObject;
		private var _scrollTargetMask:DisplayObject;
		private var _scrollProgress:Number;
		
		// _scrollTarget 高低點位置
		protected var cont_topY:Number;
		
		public function MyScrollBar():void
		{
			
		}
		
		protected function onBtnOver(e:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(e.target);
			mc.gotoAndStop(2);
		}

		protected function onBtnOut(e:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(e.target);
			mc.gotoAndStop(1);
		}

		protected function onBtnClick(e:MouseEvent):void
		{
			var mc:MovieClip = MovieClip(e.target);
			var toY:Number;
			if(mc == up_btn){
				toY = bar_mc.y - 10;
				if(toY < top_helper.y){
					toY = top_helper.y;
				}
				bar_mc.y = toY;
			}else if(mc == down_btn){
				toY = bar_mc.y + 10;
				if(toY > bottom_helper.y - bar_mc.height){
					toY = bottom_helper.y - bar_mc.height;
				}
				bar_mc.y = toY;
			}
		}

		protected function onBarDown(e:MouseEvent):void
		{
			bar_mc.startDrag(false, new Rectangle(bar_mc.x , top_helper.y , 0 , bottom_helper.y - top_helper.y - bar_mc.height));
		}
		
		protected function onBarUp(e:MouseEvent):void
		{
			bar_mc.stopDrag();
		}
		
		protected function mouseWheelHandler(event:MouseEvent):void
		{
			var toY = bar_mc.y - event.delta * wheel_factor;
			if(toY < top_helper.y){
				bar_mc.y = top_helper.y;
			}else if(toY > bottom_helper.y - bar_mc.height){
				bar_mc.y = bottom_helper.y - bar_mc.height;
			}else{
				bar_mc.y = toY;
			}
		}
		
		protected function rolling(e:Event):void
		{
			var toY:Number = _scrollTargetMask.y + (bar_mc.y - top_helper.y) * (cont_topY - _scrollTargetMask.y) / (bottom_helper.y - top_helper.y - bar_mc.height);
			//_scrollTarget.y += (toY - _scrollTarget.y) * 0.1;
			_scrollTarget.y = toY;
		}
		
		public function startScroll():void
		{
			bar_mc.y = top_helper.y;
			if (_scrollTarget.height < _scrollTargetMask.height) {
				removeScrollListener();
				_scrollTarget.y = _scrollTargetMask.y;
				this.visible = false;
			}else {
				addScrollListener();
				cont_topY = _scrollTargetMask.y - (_scrollTarget.height - _scrollTargetMask.height);
				this.visible = true;
			}
		}
		
		public function stopScroll():void
		{
			removeScrollListener();
		}
		
		protected function addScrollListener():void
		{
			bar_mc.buttonMode = true;
			bar_mc.mouseChildren = false;
			bar_mc.addEventListener(MouseEvent.ROLL_OVER , onBtnOver);
			bar_mc.addEventListener(MouseEvent.ROLL_OUT  , onBtnOut);
			bar_mc.addEventListener(MouseEvent.MOUSE_DOWN, onBarDown);
			bar_mc.addEventListener(MouseEvent.MOUSE_UP  , onBarUp);
			
			up_btn.buttonMode = true;
			up_btn.mouseChildren = false;
			up_btn.addEventListener(MouseEvent.ROLL_OVER, onBtnOver);
			up_btn.addEventListener(MouseEvent.ROLL_OUT , onBtnOut);
			up_btn.addEventListener(MouseEvent.CLICK    , onBtnClick);
			
			down_btn.buttonMode = true;
			down_btn.mouseChildren = false;
			down_btn.addEventListener(MouseEvent.ROLL_OVER, onBtnOver);
			down_btn.addEventListener(MouseEvent.ROLL_OUT , onBtnOut);
			down_btn.addEventListener(MouseEvent.CLICK    , onBtnClick);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onBarUp);
			addEventListener(Event.ENTER_FRAME  , rolling);
			
			_scrollTarget.addEventListener(MouseEvent.MOUSE_WHEEL , mouseWheelHandler);
		}
		
		protected function removeScrollListener():void
		{
			bar_mc.removeEventListener(MouseEvent.ROLL_OVER , onBtnOver);
			bar_mc.removeEventListener(MouseEvent.ROLL_OUT  , onBtnOut);
			bar_mc.removeEventListener(MouseEvent.MOUSE_DOWN, onBarDown);
			bar_mc.removeEventListener(MouseEvent.MOUSE_UP  , onBarUp);
			
			up_btn.removeEventListener(MouseEvent.ROLL_OVER, onBtnOver);
			up_btn.removeEventListener(MouseEvent.ROLL_OUT , onBtnOut);
			up_btn.removeEventListener(MouseEvent.CLICK    , onBtnClick);
			
			down_btn.removeEventListener(MouseEvent.ROLL_OVER, onBtnOver);
			down_btn.removeEventListener(MouseEvent.ROLL_OUT , onBtnOut);
			down_btn.removeEventListener(MouseEvent.CLICK    , onBtnClick);
			
			stage.removeEventListener(MouseEvent.MOUSE_UP , onBarUp);
			removeEventListener(Event.ENTER_FRAME , rolling);
			
			_scrollTarget.removeEventListener(MouseEvent.MOUSE_WHEEL , mouseWheelHandler);
		}
		
		public function dispose():void
		{
			removeScrollListener();
			_scrollTarget = null;
			_scrollTargetMask = null;
		}
		
		//**********************************************************************************************************************
		
		
		public function get scrollProgress():Number 
		{
			_scrollProgress = (bar_mc.y - top_helper.y) / (bottom_helper.y - top_helper.y);
			return _scrollProgress;
		}
		
		public function set scrollTarget(value:DisplayObject):void 
		{
			_scrollTarget = value;
		}
		
		public function get scrollTargetMask():DisplayObject 
		{
			return _scrollTargetMask;
		}
		
		public function set scrollTargetMask(value:DisplayObject):void 
		{
			_scrollTargetMask = value;
		}
	}
}