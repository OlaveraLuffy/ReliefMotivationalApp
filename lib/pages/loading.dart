import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:com.relief.motivationalapp/pages/onboard.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:com.relief.motivationalapp/services/user_preferences.dart';
import 'package:com.relief.motivationalapp/pages/home.dart';
import 'package:gif_view/gif_view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:video_player/video_player.dart';

import 'dart:developer' as dev;

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with TickerProviderStateMixin {
  late VideoPlayerController _videoController;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _videoController.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    await _audioPlayer.play(AssetSource('audio/fairy-glitter.wav'));
  }

  Future<void> _playVideo() async {
    _videoController = VideoPlayerController.asset('assets/videos/Background.mp4');
    await _videoController.play();
    dev.log('video play');
  }

  @override
  Widget build(BuildContext context) {
    _playVideo();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 2), (){
        _playAudio();
      });
    });
    return AnimatedSplashScreen.withScreenFunction(
      splash: GifView.asset(
        'assets/videos/relief-loading.gif',
        height: 400,
        width: 400,
        frameRate: 60,
      ),

      backgroundColor: Colors.white,
      splashIconSize: 250,
      duration: 7000,
      animationDuration: const Duration(seconds: 1),
      screenFunction: () async{
        if(UserPrefs.isOnboarded){
          return const Home();
        }
        else {
          return const Onboard();
        }
      },
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade, //doesnt work, just blinks to next page
    );
  }
}
