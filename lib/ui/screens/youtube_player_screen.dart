import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
  

class YoutubePlayerScreen extends StatefulWidget {
  final List<String> videoUrls;

  YoutubePlayerScreen({required this.videoUrls});

  @override
  _YoutubePlayerScreenState createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  late YoutubePlayerController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrls[_currentIndex]) ?? '',
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
        showLiveFullscreenButton: false,
        controlsVisibleAtStart: false,


      ),
    );
    _controller.addListener(listener);
  }

  void listener() {
    if (_controller.value.playerState == PlayerState.ended) {
      // Play the next video when the current video ends
      playNextVideo();
    }
  }

  void playNextVideo() {
    if (_currentIndex < widget.videoUrls.length - 1) {
      setState(() {
        _currentIndex++;
        _controller.load(YoutubePlayer.convertUrlToId(widget.videoUrls[_currentIndex]) ?? '');
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
          ),
          builder: (context, player) {
            return player;
          },
        ),
      ],
    );
  }
}
