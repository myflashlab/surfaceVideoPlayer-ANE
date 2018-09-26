# Surface Video Player ANE V3.4.3 (Android+iOS)
SurfacePlayer extension lets you play video files inside your air mobile projects and you can control the position of the player by setting x, y, width and height parameters. if you need to play your videos in native players out of your app, please check out: https://github.com/myflashlab/videoPlayer-ANE. you may also use our YouTube link parser found here: https://github.com/myflashlab/AS3-youtube-parser-video-link/ and with that you can easily play YouTube videos too. but **please notice that this surface player can play local videos only**, so even if you wish to play a youtube video, you need to download it first and then play it back. If you want to stream an online video though, like a YouTube video, you can again use our other fullscreen player ANE mentioned above.

# asdoc
[find the latest asdoc for this ANE here.](http://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/player/surface/package-detail.html)

[Download demo ANE](https://github.com/myflashlab/surfaceVideoPlayer-ANE/tree/master/AIR/lib)

# Demo Videos
[YouTube demo of how the extension works](https://www.youtube.com/watch?v=HefrQwCSkKE) 

# AIR Usage
For the complete AS3 code usage, see the [demo project here](https://github.com/myflashlab/surfaceVideoPlayer-ANE/blob/master/AIR/src/Demo.as).

```actionscript
import com.myflashlab.air.extensions.player.surface.*;

var _ex:SurfacePlayer = new SurfacePlayer(stage);

// on Android, when the surface player is availble, it will hijack the device back button clicks! with the folloiwng listener you can listen to device's back button clicks
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
_ex.attachVideo(File.applicationStorageDirectory.resolvePath("testVideoPlayerSurface.mp4"), SurfaceVideoLocation.ON_APP);

// and finally play it! (it is important to play the video after the SurfacePlayerEvent.ON_FILE_AVAILABILITY event is dispatched)
//_ex.play();

// there are many other methods for you to control the video playback like pause, seek, fullscreen, set volume, etc. please study the sample demo project
// coming with this extension to know how you can work with the other methods and when/how to dispose the extension properly.
```

# Air .xml manifest
```xml
<!--
Embedding the ANE:
-->
  <extensions>
  
	<extensionID>com.myflashlab.air.extensions.videoPlayerSurface</extensionID>
	
	<!-- dependency ANEs https://github.com/myflashlab/common-dependencies-ANE -->
	<extensionID>com.myflashlab.air.extensions.dependency.overrideAir</extensionID>
	
  </extensions>
-->
```

# Requirements
* Android SDK 15+
* iOS 8.0+
* AIR SDK 30+

# Permissions
Below are the list of Permissions this ANE might require. Check out the demo project available at this repository to see how we have used the [PermissionCheck ANE](http://www.myflashlabs.com/product/native-access-permission-check-settings-menu-air-native-extension/) to ask for the permissions.

Necessary | Optional
--------------------------- | ---------------------------
- | [SOURCE_STORAGE](https://myflashlab.github.io/asdoc/com/myflashlab/air/extensions/nativePermissions/PermissionCheck.html#SOURCE_STORAGE)

# Commercial Version
http://www.myflashlabs.com/product/surface-embedded-video-player-ane/

![Surface Video Player ANE](https://www.myflashlabs.com/wp-content/uploads/2015/11/product_adobe-air-ane-extension-surface-video-player-680x844.jpg)

# Tutorials
[How to embed ANEs into **FlashBuilder**, **FlashCC** and **FlashDevelop**](https://www.youtube.com/watch?v=Oubsb_3F3ec&list=PL_mmSjScdnxnSDTMYb1iDX4LemhIJrt1O)  

# Changelog
*Sep 24, 2018 - V3.4.3*
* Removed androidSupport dependency

*Dec 15, 2017 - V3.4.2*
* Optimized for [ANE-LAB software](https://github.com/myflashlab/ANE-LAB).

*Mar 30, 2017 - V3.4.1*
* Updated the ANE with the latest overrideAir and you will need this dependency for iOS builds also.
* Min iOS version to support this ANE is 8.0 from now on.
* Fixed Android 7 bug which was freezing the video playback when returning to the app from home screen.

*Nov 08, 2016 - V3.4.0*
* Optimized for Android manual permissions if you are targeting AIR SDK 24+
* From now on, this ANE will depend on androidSupport.ane and overrideAir.ane on the Android side

*Oct 22, 2016 - V3.3.0*
* Added Touch events over the native player.

*Jun 22, 2016 - V3.2.0*
* Fixed video location when app auto rotate is on
* Fixed the 'video not showing' problem happening on some older iOS devices

*Jan 20, 2016 - V3.1.0*
* bypassing xCode 7.2 bug causing iOS conflict when compiling with AirSDK 20 without waiting on Adobe or Apple to fix the problem. This is a must have upgrade for your app to make sure you can compile multiple ANEs in your project with AirSDK 20 or greater. https://forums.adobe.com/thread/2055508 https://forums.adobe.com/message/8294948

*Jan 01, 2016 - V3.0.0*
* in this version you can now also play videos from File.applicationStorageDirectory and you are no longer limited to File.applicationDirectory
* when attaching a video, you need to specify its location like this: _ex.attachVideo(File.applicationStorageDirectory.resolvePath("video.mp4"), SurfaceVideoLocation.ON_APP);

*Dec 20, 2015 - V2.9.1*
* minor bug fixes

*Nov 03, 2015 - V2.9.0*
* doitflash devs merged into MyFLashLab Team

*Jun 14, 2015 - V2.0.0*
* added support for iOS
* removed fullscreen option as it was adding confusion because of Android and iOS differences. for fullscreen, you can easily use http://myappsnippet.com/video-player-native-extension/

*Apr 28, 2015 - V1.0.0*
* beginning of the journey!