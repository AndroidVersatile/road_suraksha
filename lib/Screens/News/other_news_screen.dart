import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:gauvigyaan/constants/api_urls.dart';
import 'package:gauvigyaan/model/home_model.dart';
import 'package:gauvigyaan/providers/home_provider.dart';
import 'package:gauvigyaan/theme/app_theme.dart';
import 'package:provider/provider.dart';

class OtherNewsScreen extends StatefulWidget {
  const OtherNewsScreen({super.key});

  @override
  State<OtherNewsScreen> createState() => _OtherNewsScreenState();
}

class _OtherNewsScreenState extends State<OtherNewsScreen> {
  @override
  void initState() {
    // TODO: implement initState

    // Start the player as soon as the app is displayed.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await player.setSource(AssetSource('ambient_c_motion.mp3'));
      // await player.resume();
      await context.read<HomeProvider>().getOtherNews();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('अन्य जानकारी'),
      ),
      body: Container(
        height: context.screenHeight,
        margin: AppTheme.boxPadding,
        child: ListView.builder(
          itemCount: provider.otherNews.length,
          itemBuilder: (context, index) {
            var news = provider.otherNews[index];
            return Container(
              padding: AppTheme.boxPadding,
              margin: AppTheme.boxPadding,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  spreadRadius: 0.2,
                  blurRadius: 2,
                  color: context.colorScheme.shadow.withOpacity(0.6),
                ),
              ]),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(child: Text('${index + 1}')),
                      AppTheme.horizontalSpacing(),
                      Flexible(child: Text(news.categoryName)),
                    ],
                  ),
                  PlayerWidget(news: news),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class PlayerWidget extends StatefulWidget {
  // final AudioPlayer player;
  final OtherNewsModel news;

  const PlayerWidget({
    // required this.player,
    required this.news,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;
  late AudioPlayer player = AudioPlayer();
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;

  bool get _isPaused => _playerState == PlayerState.paused;

  String get _durationText => _duration?.toString().split('.').first ?? '';

  String get _positionText => _position?.toString().split('.').first ?? '';

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();

    // Set the release mode to keep the source after playback has completed.
    player.setReleaseMode(ReleaseMode.stop);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await player.setSource(AssetSource('ambient_c_motion.mp3'));
      // await player.resume();
      await player.setSourceUrl(ApiUrls.sliderImageUrl + widget.news.audioURl);
      await player.stop();
    });
    // Use initial values from player

    _playerState = player.state;
    player.getDuration().then(
          (value) => setState(() {
            _duration = value;
          }),
        );
    player.getCurrentPosition().then(
          (value) => setState(() {
            _position = value;
          }),
        );
    _initStreams();
  }

  @override
  void setState(VoidCallback fn) {
    // Subscriptions only can be closed asynchronously,
    // therefore events can occur after widget has been disposed.
    if (mounted) {
      super.setState(fn);
    }
  }

  String formatDuration(Duration d) {
    String minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    player.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
     if(_duration != null)   Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              key: const Key('play_button'),
              onPressed: _isPlaying ? null : _play,
              iconSize: 30.0,
              icon: const Icon(Icons.play_arrow),
              color: color,
            ),
            IconButton(
              key: const Key('pause_button'),
              onPressed: _isPlaying ? _pause : null,
              iconSize: 30.0,
              icon: const Icon(Icons.pause),
              color: color,
            ),
            IconButton(
              key: const Key('stop_button'),
              onPressed: _isPlaying || _isPaused ? _stop : null,
              iconSize: 30.0,
              icon: const Icon(Icons.stop),
              color: color,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Slider(
              onChanged: (value) {
                final duration = _duration;
                if (duration == null) {
                  return;
                }
                final position = value * duration.inMilliseconds;
                player.seek(Duration(milliseconds: position.round()));
              },
              value: (_position != null &&
                      _duration != null &&
                      _position!.inMilliseconds > 0 &&
                      _position!.inMilliseconds < _duration!.inMilliseconds)
                  ? _position!.inMilliseconds / _duration!.inMilliseconds
                  : 0.0,
            ),
            Text(
              _position != null
                  ? '${formatDuration(_position!)} / ${formatDuration(_duration!)}'
                  : _duration != null
                      ? _durationText
                      : '',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ],
    );
  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen(
      (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
  }

  Future<void> _play() async {
    await player.resume();
    setState(() => _playerState = PlayerState.playing);
  }

  Future<void> _pause() async {
    await player.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  Future<void> _stop() async {
    await player.stop();
    setState(() {
      _playerState = PlayerState.stopped;
      _position = Duration.zero;
    });
  }
}
