import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gif_view/gif_view.dart';
import 'package:video_player/video_player.dart';

import '../controllers/home_controller.dart';

class BackgroundContent extends StatefulWidget {
  final HomeController homeController;
  const BackgroundContent({Key? key, required this.homeController}) : super(key: key);

  @override
  State<BackgroundContent> createState() => _BackgroundContentState();
}

class _BackgroundContentState extends State<BackgroundContent> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    if (widget.homeController.contentController.homeContent?.videos.isNotEmpty ?? false) {
      final file = widget.homeController.contentController.homeContent!.files.last;
      _videoController = VideoPlayerController.file(file);
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      _videoController!.play();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeContent = widget.homeController.contentController.homeContent;

    if (homeContent == null) {
      return SizedBox(height: 1.sh, width: 1.sw);
    }

    if (homeContent.videos.isNotEmpty && _videoController?.value.isInitialized == true) {
      return SizedBox.expand(child: VideoPlayer(_videoController!));
    }

    if (homeContent.gifs.isNotEmpty) {
      return GifView.memory(
        homeContent.files.last.readAsBytesSync(),
        fit: BoxFit.fill,
        height: 1.sh,
        width: 1.sw,
        frameRate: 1,
      );
    }

    if (homeContent.images.isNotEmpty) {
      return CarouselSlider(
        options: CarouselOptions(
          height: 1.sh,
          autoPlay: true,
          viewportFraction: 1,
        ),
        items: homeContent.files.map((item) {
          return Image.memory(
            item.readAsBytesSync(),
            fit: BoxFit.fill,
            width: double.infinity,
            height: double.infinity,
          );
        }).toList(),
      );
    }

    return SizedBox(height: 1.sh, width: 1.sw);
  }
}

