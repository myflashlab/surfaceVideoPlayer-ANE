Surface Video Player Adobe Air Native Extension

*Aug 4, 2019 - V3.4.41*
* Added Android 64-bit support
* Supports iOS 10+

*Nov 18, 2018 - V3.4.4*
* Works with OverrideAir ANE V5.6.1 or higher
* Works with ANELAB V1.1.26 or higher

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