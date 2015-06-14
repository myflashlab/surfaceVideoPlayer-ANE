# Surface Video Player ANE V2.0 (Android+iOS)
SurfacePlayer extension lets you play video files inside your air mobile projects and you can control the position of the player by setting x, y, width and height parameters. if you need to play your videos in native players out of your app, please check out: http://myappsnippet.com/video-player-native-extension/. you may also use our YouTube link parser found here: https://github.com/myflashlab/AS3-youtube-parser-video-link/ and with that you can easily play YouTube videos too.

checkout here for the commercial version: http://myappsnippet.com/surface-video-player-ane

you may like to see the ANE in action? check this out: https://github.com/myflashlab/surfaceVideoPlayer-ANE/tree/master/FD/dist

YouTube demo Video: https://www.youtube.com/watch?v=HefrQwCSkKE

**NOTICE: the demo ANE works only after you hit the "OK" button in the dialog which opens. in your tests make sure that you are NOT calling other ANE methods prior to hitting the "OK" button.**

![Surface Video Player ANE](http://myappsnippet.com/wp-content/uploads/2015/04/surface-video-player-adobe-air-extension_preview.jpg)

# AS3 API:
```actionscript
import com.doitflash.air.extensions.player.surface.SurfacePlayer;
import com.doitflash.air.extensions.player.surface.SurfacePlayerEvent;

var _ex:SurfacePlayer = new SurfacePlayer(stage);

// // on Android, when the surface player is availble, it will hijack the device back button clicks! with the folloiwng listener you can listen to device's back button clicks
_ex.addEventListener(SurfacePlayerEvent.ON_BACK_CLICKED, onBackClickedWhenSurfacePlayerIsAvailable);

// dispatches when the video has reached end
_ex.addEventListener(SurfacePlayerEvent.ON_COMPLETION_LISTENER, onVideoPlaybackCompleted);

// when you attach a video file _ex.attachVideo(file); this listener will tell you if this file is availble or not. play your video only if it is availble
_ex.addEventListener(SurfacePlayerEvent.ON_FILE_AVAILABILITY, onTargetVideoAvailability);

// this listener will tell you different states that your Media is in. "STARTED", "PAUSED", "STOPPED"
_ex.addEventListener(SurfacePlayerEvent.ON_MEDIA_STATUS_CHANGED, onMediaStatusChanged);

// the first thing you should do is to initialize the extension with its initial parameters
_ex.init(x, y, width, height, true); // the last parameter is the ratio for your video clip if false, the video will be stretched to fit your specified width and height

// after initializing the extension, you need to attach a new video file to it
_ex.attachVideo(File.documentsDirectory.resolvePath("testVideoPlayerSurface.mp4"));

// and finally play it! (it's a good idea to always check for SurfacePlayerEvent.ON_FILE_AVAILABILITY before playing the file)
_ex.play();

// there are many other methods for you to control the video playback like pause, seek, fullscreen, set volume, etc. please study the sample demo project
// coming with this extension to know how you can work with the other methods and when/how to dispose the extension properly.
```
This extension works on Android SDK 11 or higher and iOS 7.1 or higher

This extension does not require any special setup in the air manifest .xml file