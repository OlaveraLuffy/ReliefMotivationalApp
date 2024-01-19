import 'dart:async';
import 'package:com.relief.motivationalapp/pages/onboard.dart';
import 'package:flutter/material.dart';
import 'package:com.relief.motivationalapp/services/user_preferences.dart';
import 'package:com.relief.motivationalapp/pages/home.dart';
import 'package:gif_view/gif_view.dart';
import 'package:video_player/video_player.dart';
import 'package:page_transition/page_transition.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with TickerProviderStateMixin {
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  void _initVideoPlayer() {
    _videoController = VideoPlayerController.asset("assets/videos/Background.mp4")
      ..initialize().then((_) {
        _videoController.setLooping(false);
        _videoController.setVolume(1.0);
        _videoController.play();
        setState(() {});
        _navigateAfterDelay();
      });
  }

  void _navigateAfterDelay() {
    Future.delayed(const Duration(seconds: 8), () {
      if (UserPrefs.isOnboarded) {
        Navigator.pushReplacement(
          context,
          PageTransition(type: PageTransitionType.fade, child: const Home()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          PageTransition(type: PageTransitionType.fade, child: const Onboard()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                  width: _videoController.value.size.width,
                  height: _videoController.value.size.height,
                  child: VideoPlayer(_videoController),
              ),
            ),
          ),
          Center(
            child: GifView.asset(
              'assets/videos/relief-loading-transparent.gif',
              height: 400,
              width: 400,
              frameRate: 60,
            ),
          ),
        ],
      ),
    );
  }
}