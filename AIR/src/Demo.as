package
{
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemIdleMode;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StageOrientationEvent;
	import flash.events.StatusEvent;
	import flash.display.LoaderInfo;
	import flash.geom.Point;
	import flash.system.LoaderContext;
	import flash.text.AntiAliasType;
	import flash.text.AutoCapitalize;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.events.InvokeEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.media.Sound;
    import flash.media.SoundChannel;
	import flash.net.URLLoader;
	import flash.display.Loader;
	import com.doitflash.text.modules.MySprite;
	import com.doitflash.starling.utils.list.List;
	import com.doitflash.consts.Direction;
	import com.doitflash.consts.Orientation;
	import com.doitflash.consts.Easing;
	import flash.utils.Endian;
	import com.luaye.console.C;
	import com.doitflash.mobileProject.commonCpuSrc.DeviceInfo;
	import flash.utils.setTimeout;
	
	import com.myflashlab.air.extensions.player.surface.SurfacePlayer;
	import com.myflashlab.air.extensions.player.surface.SurfacePlayerEvent;
	import com.myflashlab.air.extensions.player.surface.SurfaceVideoLocation;
	
	/**
	 * ...
	 * @author Hadi Tavakoli - 4/28/2015 8:57 AM
	 */
	public class Demo extends Sprite
	{
		private var _ex:SurfacePlayer;
		private var dragMe:MySprite;
		private var _videoWidth:int;
		private var _videoHeigh:int;
		
		private const BTN_WIDTH:Number = 110;
		private const BTN_HEIGHT:Number = 60;
		private const BTN_SPACE:Number = 2;
		private var _txt:TextField;
		private var _body:Sprite;
		private var _list:List;
		private var _numRows:int = 1;
		
		public function Demo():void
		{
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, handleActivate, false, 0, true);
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, handleDeactivate, false, 0, true);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke, false, 0, true);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys, false, 0, true);
			
			stage.addEventListener(Event.RESIZE, onResize);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			C.startOnStage(this, "`");
			C.commandLine = false;
			C.commandLineAllowed = false;
			C.x = 100;
			C.width = 500;
			C.height = 250;
			C.strongRef = true;
			C.visible = false;
			C.scaleX = C.scaleY = DeviceInfo.dpiScaleMultiplier;
			
			_txt = new TextField();
			_txt.autoSize = TextFieldAutoSize.LEFT;
			_txt.antiAliasType = AntiAliasType.ADVANCED;
			_txt.multiline = true;
			_txt.wordWrap = true;
			_txt.embedFonts = false;
			_txt.htmlText = "<font face='Arimo' color='#333333' size='20'><b>Surface video player V" + SurfacePlayer.VERSION + " for Adobe Air</b></font>";
			_txt.scaleX = _txt.scaleY = DeviceInfo.dpiScaleMultiplier;
			this.addChild(_txt);
			
			_body = new Sprite();
			this.addChild(_body);
			
			_list = new List();
			_list.holder = _body;
			_list.itemsHolder = new Sprite();
			_list.orientation = Orientation.VERTICAL;
			_list.hDirection = Direction.LEFT_TO_RIGHT;
			_list.vDirection = Direction.TOP_TO_BOTTOM;
			_list.space = BTN_SPACE;
			
			C.log("iOS is crazy with understanding stageWidth and stageHeight, you already now that :)");
			C.log("So, we should wait a couple of seconds before initializing the ANE to make sure the stage dimention is stable before passing it through the ANE.");
			setTimeout(init, 2000);
		}
		
		private function onInvoke(e:InvokeEvent):void
		{
			NativeApplication.nativeApplication.removeEventListener(InvokeEvent.INVOKE, onInvoke);
		}
		
		private function handleActivate(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
		}
		
		private function handleDeactivate(e:Event):void
		{
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL;
		}
		
		private function handleKeys(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.BACK)
			{
				e.preventDefault();
				
				// when closing the app, we'll dispose the extension also
				if (_ex) _ex.dispose();
				
				NativeApplication.nativeApplication.exit();
			}
		}
		
		private function onResize(e:*=null):void
		{
			if (_txt)
			{
				_txt.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
				
				C.x = 0;
				C.y = _txt.y + _txt.height + 0;
				C.width = stage.stageWidth * (1 / DeviceInfo.dpiScaleMultiplier);
				C.height = 300 * (1 / DeviceInfo.dpiScaleMultiplier);
			}
			
			if (_list)
			{
				_numRows = Math.floor(stage.stageWidth / (BTN_WIDTH * DeviceInfo.dpiScaleMultiplier + BTN_SPACE));
				_list.row = _numRows;
				_list.itemArrange();
			}
			
			if (_body)
			{
				_body.y = stage.stageHeight - _body.height;
			}
			
			
			if (_ex)
			{
				_videoWidth = stage.stageWidth * 0.5;
				_videoHeigh = _videoWidth * 0.75;
				var x:int = stage.stageWidth * 0.5 - _videoWidth * 0.5;
				var y:int = stage.stageHeight * 0.5 - _videoHeigh * 0.5;
				
				if (dragMe) 
				{
					dragMe.x = x + _videoWidth;
					dragMe.y = y + _videoHeigh;
				}
				
				_ex.setPosition(x, y, _videoWidth, _videoHeigh, true); // ratio can be true or false
			}
		}
		
		private function init():void
		{
			// initialize the extension
			_ex = new SurfacePlayer(this.stage); // make sure the stage is available.
			_ex.addEventListener(SurfacePlayerEvent.ON_BACK_CLICKED, onBackClickedWhenSurfacePlayerIsAvailable);
			_ex.addEventListener(SurfacePlayerEvent.ON_COMPLETION_LISTENER, onVideoPlaybackCompleted);
			_ex.addEventListener(SurfacePlayerEvent.ON_FILE_AVAILABILITY, onTargetVideoAvailability);
			_ex.addEventListener(SurfacePlayerEvent.ON_MEDIA_STATUS_CHANGED, onMediaStatusChanged);
			
			// listeners for touch events over the native window.
			_ex.addEventListener(SurfacePlayerEvent.ON_TOUCH_DOWN, onNativeTouchDown);
			_ex.addEventListener(SurfacePlayerEvent.ON_TOUCH_MOVE, onNativeTouchMove);
			_ex.addEventListener(SurfacePlayerEvent.ON_TOUCH_UP, onNativeTouchUp);
			
			/**
			 * NOTICE: you can't play a video from File.applicationDirectory because AdobeAir is compressing these files on Android 
			 * (we're not sure if this is a bug or Adobe is doing this on purpose. anyway, you can use applicationStorageDirectory instead)
			 * 
			 * So you have to copy it to documentsDirectory OR applicationStorageDirectory
			 */
			var src:File = File.applicationDirectory.resolvePath("testVideoPlayerSurface.mp4");
			
			//var dis:File = File.documentsDirectory.resolvePath(src.name);
			var dis:File = File.applicationStorageDirectory.resolvePath(src.name);
			
			trace("a demo video is copied to applicationStorageDirectory so we can play it back!");
			if (!dis.exists) src.copyTo(dis);
			
			trace("is supported? " + _ex.isSupported);
			
			_videoWidth = stage.stageWidth * 0.5;
			_videoHeigh = _videoWidth * 0.75;
			var x:int = stage.stageWidth * 0.5 - _videoWidth * 0.5;
			var y:int = stage.stageHeight * 0.5 - _videoHeigh * 0.5;
			
			// ratio can be true or false (you can change the position and dimension later using the setPosition command)
			_ex.init(x, y, _videoWidth, _videoHeigh, true); 
			
			/**
			 * 	choose SurfaceVideoLocation.ON_APP if your video is in File.applicationStorageDirectory
			 * 	OR choose SurfaceVideoLocation.ON_SD_CARD if your video is in File.documentsDirectory
			 * 
			 * 	NOTICE 1: When saying SurfaceVideoLocation.ON_SD_CARD we do NOT mean the actual mountable sdCard. we just mean File.documentsDirectory
			 * 	FYI, on iOS, File.applicationStorageDirectory and File.documentsDirectory locations are basically the same!
			 */
			_ex.attachVideo(dis, SurfaceVideoLocation.ON_APP); 
			
			// create the dragMe button!
			dragMe = new MySprite();
			dragMe.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			dragMe.width = 100;
			dragMe.height = 100;
			dragMe.bgColor = 0xFF9900;
			dragMe.bgAlpha = 1;
			dragMe.bgBottomLeftRadius = 10;
			dragMe.bgBottomRightRadius = 10;
			dragMe.bgTopRightRadius = 10;
			dragMe.drawBg();
			dragMe.x = x + _videoWidth;
			dragMe.y = y + _videoHeigh;
			
			var dragtxt:TextField = new TextField();
			dragtxt.selectable = false;
			dragtxt.mouseEnabled = false;
			dragtxt.autoSize = TextFieldAutoSize.LEFT;
			dragtxt.wordWrap = true;
			dragtxt.multiline = true;
			dragtxt.htmlText = "<p align='center'><font size='23'>DRAG ME</font></p>";
			dragtxt.width = dragMe.width;
			dragtxt.y = dragMe.height - dragtxt.height >> 1;
			dragMe.addChild(dragtxt);
			
			this.addChild(dragMe);
			
			
			/*var btn02:MySprite = createBtn("detachVideo!");
			btn02.addEventListener(MouseEvent.CLICK, detachVideo);
			_list.add(btn02);
			
			function detachVideo(e:MouseEvent):void
			{
				_ex.detachVideo();
			}*/
			
			var btn3:MySprite = createBtn("play");
			btn3.addEventListener(MouseEvent.CLICK, play);
			_list.add(btn3);
			
			function play(e:MouseEvent):void
			{
				_ex.play();
			}
			
			var btn5:MySprite = createBtn("pause");
			btn5.addEventListener(MouseEvent.CLICK, pause);
			_list.add(btn5);
			
			function pause(e:MouseEvent):void
			{
				_ex.pause();
				trace("pause at: " + _ex.position);
				trace("total length: " + _ex.duration);
			}
			
			var btn6:MySprite = createBtn("stop");
			btn6.addEventListener(MouseEvent.CLICK, stop);
			_list.add(btn6);
			
			function stop(e:MouseEvent):void
			{
				_ex.stop()
			}
			
			var btn7:MySprite = createBtn("seekTo (18619) miliSeconds");
			btn7.addEventListener(MouseEvent.CLICK, seekTo);
			_list.add(btn7);
			
			function seekTo(e:MouseEvent):void
			{
				_ex.seekTo(18619);
			}
			
			/*var btn10:MySprite = createBtn("is playing?");
			btn10.addEventListener(MouseEvent.CLICK, isPlaying);
			_list.add(btn10);
			
			function isPlaying(e:MouseEvent):void
			{
				trace("is playing? " + _ex.isPlaying);
			}*/
			
			var btn11:MySprite = createBtn("decrease volume");
			btn11.addEventListener(MouseEvent.CLICK, setVolumeLow);
			_list.add(btn11);
			
			function setVolumeLow(e:MouseEvent):void
			{
				_ex.volume = 5; // set volume range = 0, 100
				trace("volume = " + _ex.volume);
			}
			
			var btn12:MySprite = createBtn("increase volume");
			btn12.addEventListener(MouseEvent.CLICK, setVolumeHigh);
			_list.add(btn12);
			
			function setVolumeHigh(e:MouseEvent):void
			{
				_ex.volume = 100; // set volume range = 0, 100
				trace("volume = " + _ex.volume);
			}
			
			onResize();
		}
		
		private function onBackClickedWhenSurfacePlayerIsAvailable(e:SurfacePlayerEvent):void
		{
			_ex.dispose();
			NativeApplication.nativeApplication.exit();
		}
		
		private function onVideoPlaybackCompleted(e:SurfacePlayerEvent):void
		{
			trace("video playback finished");
		}
		
		private function onTargetVideoAvailability(e:SurfacePlayerEvent):void
		{
			// as soon as you attach a video to the extension
			// it will check if the target is available. you can play the
			// video only if the file is availble of course!
			
			if (e.param.isAvailable) trace("video file is availble :)");
			else trace("WRONG video file address!!! you can't play the video! " + e.param.address);
		}
		
		private function onMediaStatusChanged(e:SurfacePlayerEvent):void
		{
			trace(e.param);
		}
		
		private function onDown(e:MouseEvent):void
		{
			dragMe.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			dragMe.startDrag();
		}
			
		private function onMove(e:MouseEvent):void
		{
			_ex.setPosition(dragMe.x - _videoWidth, dragMe.y - _videoHeigh, _videoWidth, _videoHeigh, true);
		}
		
		private function onUp(e:MouseEvent):void
		{
			dragMe.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			dragMe.stopDrag();
		}
		
		private function onNativeTouchDown(e:SurfacePlayerEvent):void
		{
			var globalPosition:Point = e.param.global;
			var localPosition:Point = e.param.local;
			
			trace("----------------");
			trace("onNativeTouchDown");
			trace("global Position = " + globalPosition.x + "," + globalPosition.y);
			trace("local Position = " + localPosition.x + "," + localPosition.y);
			trace("----------------");
		}
		
		private function onNativeTouchMove(e:SurfacePlayerEvent):void
		{
			var globalPosition:Point = e.param.global;
			var localPosition:Point = e.param.local;
			
			trace("----------------");
			trace("onNativeTouchMove");
			trace("global Position = " + globalPosition.x + "," + globalPosition.y);
			trace("local Position = " + localPosition.x + "," + localPosition.y);
			trace("----------------");
		}
		
		private function onNativeTouchUp(e:SurfacePlayerEvent):void
		{
			var globalPosition:Point = e.param.global;
			var localPosition:Point = e.param.local;
			
			trace("----------------");
			trace("onNativeTouchUp");
			trace("global Position = " + globalPosition.x + "," + globalPosition.y);
			trace("local Position = " + localPosition.x + "," + localPosition.y);
			trace("----------------");
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private function createBtn($str:String, $bgColor:uint=0xDFE4FF):MySprite
		{
			var sp:MySprite = new MySprite();
			sp.addEventListener(MouseEvent.MOUSE_OVER,  onOver);
			sp.addEventListener(MouseEvent.MOUSE_OUT,  onOut);
			//sp.addEventListener(MouseEvent.CLICK,  onOut);
			sp.bgAlpha = 1;
			sp.bgColor = $bgColor;
			sp.drawBg();
			sp.width = BTN_WIDTH * DeviceInfo.dpiScaleMultiplier;
			sp.height = BTN_HEIGHT * DeviceInfo.dpiScaleMultiplier;
			
			function onOver(e:MouseEvent):void
			{
				if (!sp.hasEventListener(MouseEvent.CLICK)) return;
				
				sp.bgAlpha = 1;
				sp.bgColor = 0x000000;
				sp.drawBg();
			}
			
			function onOut(e:MouseEvent):void
			{
				if (!sp.hasEventListener(MouseEvent.CLICK)) return;
				
				sp.bgAlpha = 1;
				sp.bgColor = $bgColor;
				sp.drawBg();
			}
			
			var format:TextFormat = new TextFormat("Arimo", 16, 0x888888, null, null, null, null, null, TextFormatAlign.CENTER);
			
			var txt:TextField = new TextField();
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			txt.mouseEnabled = false;
			txt.multiline = true;
			txt.wordWrap = true;
			txt.scaleX = txt.scaleY = DeviceInfo.dpiScaleMultiplier;
			txt.width = sp.width * (1 / DeviceInfo.dpiScaleMultiplier);
			txt.defaultTextFormat = format;
			txt.text = $str;
			
			txt.y = sp.height - txt.height >> 1;
			sp.addChild(txt);
			
			return sp;
		}
	}

}