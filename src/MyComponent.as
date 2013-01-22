package
{
	import com.godsmao.ui.MyComboBox;
	import com.godsmao.ui.MyScrollBar;
	import com.godsmao.ui.VideoPlayer;
	import com.godsmao.ui.YoutubePlayer;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * @author Rhino Lu
	 */
	public class MyComponent extends Sprite
	{
		public var myComboBox:MyComboBox;
		public var myVideoPlayer:VideoPlayer;
		public var scroll:MyScrollBar;
		public var cont_sp:Sprite;
		public var mask_sp:Sprite;
		
		private var myYoutubeClip:YoutubePlayer;
		
		public function MyComponent() 
		{
			myComboBox.addEventListener(Event.CHANGE, onComboBoxChange);
			myComboBox.dataProvider = [
				"000000",
				"111111",
				"222222",
				"333333",
				"444444",
				"555555",
				"666666",
				"777777",
				"888888",
				"999999"
			];
			
			myVideoPlayer.loadVideo("wildlife.f4v", 320, 180);
			
			myYoutubeClip = new YoutubePlayer();
			myYoutubeClip.x = 185;
			myYoutubeClip.y = 360;
			myYoutubeClip.addEventListener(YoutubePlayer.PLAYER_READY, onYoutube);
			myYoutubeClip.addEventListener(YoutubePlayer.PLAYER_ENDED, onYoutube);
			myYoutubeClip.loadVideo("N--a2OuPLok", 320, 180);
			addChild(myYoutubeClip);
			
			cont_sp.mask = mask_sp;
			scroll.scrollTarget = cont_sp;
			scroll.scrollTargetMask = mask_sp;
			scroll.startScroll();
		}
		
		private function onComboBoxChange(e:Event):void 
		{
			trace(myComboBox.selectedIndex, myComboBox.selectedLabel);
		}
		
		private function onYoutube(e:Event):void 
		{
			if (e.type == YoutubePlayer.PLAYER_READY) {
				myYoutubeClip.playVideo();
			}
		}
		
	}

}