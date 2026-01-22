import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:video_player/video_player.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/material.dart';

import '../constants/assets.dart';
// import 'package:flutter_youtube_view/flutter_youtube_view.dart';
// import 'package:flutter_youtube_view/flutter_youtube_view_controller.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(Assets.splash);
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
    _controller.play();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFFA6E36),
      body: Center(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            );
          },
        ),
      ),
    );
  }
}

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context).colorScheme.background.withOpacity(.7),
      child: Center(
        child: Image.asset(
          Assets.appLogo,
          cacheHeight: 100,
          cacheWidth: 100,
          // fit: BoxFit.cover,
        )
            .animate(
              autoPlay: true,
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .scale(begin: const Offset(0.7, 0.7), end: const Offset(1, 1))
            .then(duration: const Duration(milliseconds: 100))
            .shimmer(color: Colors.white60)
            .then(duration: const Duration(milliseconds: 200))
            .flipH(
              begin: 0,
              end: pi,
              delay: const Duration(milliseconds: 300),
              alignment: Alignment.center,
            ),
      ),
    );
  }
}

