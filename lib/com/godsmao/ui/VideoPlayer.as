package com.godsmao.ui
{
	import com.godsmao.utils.QuickBtn;
	import com.greensock.events.LoaderEvent;
	import com.greensock.layout.ScaleMode;
	import com.greensock.loading.data.VideoLoaderVars;
	import com.greensock.loading.VideoLoader;
	import com.robertpataki.heartcode.ProgressIndicator;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.Security;
	/**
	 * @author Rhino Lu
	 */
	public class VideoPlayer extends Sprite
	{
		public var container:Sprite;
		public var btn_play:MovieClip;
		public var btn_mute:MovieClip;
		public var progress_sp:Sprite;
		
		private var drag_mc:MovieClip;
		private var play_progress:Sprite;
		private var load_progress:Sprite;
		private var bg_progress:Sprite;
		
		private var video_width:Number  = 640;
		private var video_height:Number = 360;
		private var preloader_sp:ProgressIndicator;
		private var _ifAutoPlay:Boolean = true;
		
		private var video_loader:VideoLoader;
		private var isDragging:Boolean;
		
		public function VideoPlayer()
		{
			stage?init():addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			drag_mc       = progress_sp.getChildByName("drag_mc")       as MovieClip;
			play_progress = progress_sp.getChildByName("play_progress") as Sprite;
			load_progress = progress_sp.getChildByName("load_progress") as Sprite;
			bg_progress   = progress_sp.getChildByName("bg_progress")   as Sprite;
			drag_mc.x = drag_mc.width * 0.5;
			play_progress.scaleX = load_progress.scaleX = 0;
			
			QuickBtn.setBtn(drag_mc, QuickBtn.onOver, QuickBtn.onOut);
			drag_mc.addEventListener(MouseEvent.MOUSE_DOWN, onDragDown);
			QuickBtn.setBtn(load_progress, null, null, onBarClick);
			play_progress.mouseChildren = play_progress.mouseEnabled = false;
		}
		
		public function dispose():void
		{
			removeProgress();
			QuickBtn.removeBtn(drag_mc, QuickBtn.onOver, QuickBtn.onOut);
			QuickBtn.removeBtn(load_progress, null, null, onBarClick);
			QuickBtn.removeBtn(btn_play, null, null, onClick);
			QuickBtn.removeBtn(btn_mute, null, null, onClick);
			if (video_loader) {
				if (video_loader.content) {
					QuickBtn.removeBtn(video_loader.content, null, null, onVideoClick);
				}
				video_loader.dispose(true);
			}
		}
		
		public function loadVideo(file:String, _width:Number, _height:Number):void
		{
			video_width  = _width;
			video_height = _height;
			addProgress();
			video_loader = new VideoLoader(file, new VideoLoaderVars().autoPlay(_ifAutoPlay).container(container).crop(true).width(_width).height(_height).scaleMode(ScaleMode.PROPORTIONAL_INSIDE).onProgress(onLoadVideoProgress).onInit(onLoadVideoInit).onComplete(onLoadVideoComplete).vars);
			video_loader.addEventListener(VideoLoader.VIDEO_COMPLETE , onMovieComplete);
			video_loader.addEventListener(VideoLoader.VIDEO_PLAY     , onMoviePlay);
			video_loader.addEventListener(VideoLoader.PLAY_PROGRESS  , onMoviePlayProgress);
			//video_loader.addEventListener(VideoLoader.VIDEO_CUE_POINT, onCuePoint);
			video_loader.load();
			
			QuickBtn.setBtn(btn_play, null, null, onClick);
			QuickBtn.setBtn(btn_mute, null, null, onClick);
			
			if (_ifAutoPlay) {
				btn_play.gotoAndStop(1);
			}else {
				btn_play.gotoAndStop(2);
			}
		}
		
		public function playMovie():void
		{
			if (video_loader) {
				video_loader.playProgress = 0;
				video_loader.playVideo();
				btn_play.gotoAndStop(1);
			}
		}
		
		public function stopMovie():void
		{
			if (video_loader) {
				video_loader.pauseVideo();
				btn_play.gotoAndStop(2);
			}
		}
		
		protected function onLoadVideoProgress(e:LoaderEvent):void 
		{
			//trace(video_loader.progress);
			load_progress.scaleX = video_loader.progress;
		}
		
		protected function onLoadVideoInit(e:LoaderEvent):void 
		{
			QuickBtn.setBtn(video_loader.content, null, null, onVideoClick);
		}
		
		protected function onLoadVideoComplete(e:LoaderEvent):void 
		{
			removeProgress();
			//signal.dispatch(LoaderEvent.COMPLETE, this);
		}
		
		protected function onMovieComplete(e:Event):void 
		{
			dispatchEvent(new Event(VideoLoader.VIDEO_COMPLETE));
			btn_play.gotoAndStop(2);
		}
		
		protected function onMoviePlay(e:Event):void 
		{
			removeProgress();
		}
		
		private function onMoviePlayProgress(e:Event):void 
		{
			play_progress.scaleX = video_loader.playProgress;
			if (!isDragging) {
				drag_mc.x = (drag_mc.width * 0.5) + (bg_progress.width - drag_mc.width) * video_loader.playProgress;
			}
		}
		
		protected function onClick(e:MouseEvent):void 
		{
			var btn:MovieClip = e.target as MovieClip;
			if (btn == btn_play) {
				toggleVideo();
			}else if (btn == btn_mute) {
				btn_mute.gotoAndStop(3 - btn_mute.currentFrame);
				video_loader.volume = 1 - video_loader.volume;
			}
		}
		
		private function onDragDown(e:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onDragUp);
			drag_mc.startDrag(false, new Rectangle(drag_mc.width * 0.5, drag_mc.y, bg_progress.width - drag_mc.width, 0));
			isDragging = true;
			video_loader.pauseVideo();
		}
		
		private function onDragUp(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDragUp);
			drag_mc.stopDrag();
			isDragging = false;
			video_loader.playProgress = (drag_mc.x - (drag_mc.width * 0.5)) / (bg_progress.width - drag_mc.width);
			if (btn_play.currentFrame == 1) {
				video_loader.playVideo();
			}else {
				
			}
		}
		
		private function onBarClick(e:MouseEvent):void 
		{
			//trace( "VideoClip.onBarClick > e : " + e );
			video_loader.playProgress = e.localX / bg_progress.width;
		}
		
		protected function onVideoClick(e:MouseEvent):void 
		{
			toggleVideo();
		}
		
		protected function toggleVideo():void
		{
			if (btn_play.currentFrame == 1) {
				video_loader.pauseVideo();
				//signal.dispatch(VideoLoader.VIDEO_PAUSE, this);
			}else {
				if (video_loader.playProgress == 1) {
					video_loader.playProgress = 0;
					//signal.dispatch("REPLAY", this);
				}
				video_loader.playVideo();
				//signal.dispatch(VideoLoader.VIDEO_PLAY, this);
			}
			btn_play.gotoAndStop(3 - btn_play.currentFrame);
		}
		
		protected function addProgress():void
		{
			removeProgress();
			preloader_sp = new ProgressIndicator(ProgressIndicator.DEFAULT_SHAPE, ProgressIndicator.DEFAULT_DENSITY, ProgressIndicator.DEFAULT_RANGE, ProgressIndicator.DEFAULT_COLOR, 8);
			addChild(preloader_sp);
			preloader_sp.x = video_width * 0.5;
			preloader_sp.y = video_height * 0.5;
		}
		
		protected function removeProgress():void
		{
			if (preloader_sp) {
				preloader_sp.kill();
				removeChild(preloader_sp);
				preloader_sp = null;
			}
		}
		
		public function set ifAutoPlay(value:Boolean):void 
		{
			_ifAutoPlay = value;
		}
	}
}