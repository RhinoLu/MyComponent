package com.godsmao.ui
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.Security;
	/**
	 * @author Rhino Lu
	 */
	public class YoutubePlayer extends Sprite
	{
		public static const PLAYER_READY:String = "player_ready";
		public static const PLAYER_ENDED:String = "player_ended";
		
		private var player:Object;
		private var loader:Loader;
		private var _ifReady:Boolean;
		private var _width:Number;
		private var _height:Number;
		private var _mask:Sprite;
		
		public function YoutubePlayer()
		{
			Security.allowDomain("www.youtube.com");
			Security.allowDomain("s.ytimg.com");
		}
		
		public function loadVideo(videoID:String, videoWidth:Number = 760, videoHeight:Number = 500):void
		{
			_width = videoWidth;
			_height = videoHeight;
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			//loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
			loader.load(new URLRequest("http://www.youtube.com/v/" + videoID + "?version=3&rel=0"));
		}
		
		public function playVideo():void
		{
			player.playVideo();
		}
		
		public function stopVideo():void
		{
			player.stopVideo();
		}
		
		public function destroy():void
		{
			if (player) {
				player.destroy();
			}
		}
		
		public function mute():void
		{
			player.mute();
		}
		
		private function onLoaderInit(event:Event):void
		{
			addChild(loader);
			loader.content.addEventListener("onReady", onPlayerReady);
			loader.content.addEventListener("onError", onPlayerError);
			loader.content.addEventListener("onStateChange", onPlayerStateChange);
			loader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
		}
		
		private function onPlayerReady(event:Event):void
		{
			// Event.data contains the event parameter, which is the Player API ID 
			//trace("player ready:", Object(event).data);
			
			// Once this event has been dispatched by the player, we can use
			// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
			// to load a particular YouTube video.
			player = loader.content;
			// Set appropriate player dimensions for your application
			player.setSize(_width, _height);
			player.setPlaybackQuality("highres");
			
			_ifReady = true;
			dispatchEvent(new Event(YoutubePlayer.PLAYER_READY));
			
			_mask = new Sprite();
			_mask.graphics.beginFill(0xFFFFFF);
			_mask.graphics.drawRect(0, 0, _width, _height);
			_mask.graphics.endFill();
			addChild(_mask);
			
			player.mask = _mask;
		}
		
		private function onPlayerError(event:Event):void
		{
			// Event.data contains the event parameter, which is the error code
			//trace("player error:", Object(event).data);
		}
		
		private function onPlayerStateChange(event:Event):void
		{
			// Event.data contains the event parameter, which is the new player state
			//-1 (unstarted)
			//0 (ended)
			//1 (playing)
			//2 (paused)
			//3 (buffering)
			//5 (video cued)
			//trace("player state:", Object(event).data);
			if (Object(event).data == 0) {
				dispatchEvent(new Event(YoutubePlayer.PLAYER_ENDED));
			}
		}
		
		private function onVideoPlaybackQualityChange(event:Event):void
		{
			// Event.data contains the event parameter, which is the new video quality
			//trace("video quality:", Object(event).data);
		}
		
		public function get ifReady():Boolean 
		{
			return _ifReady;
		}
	}

}