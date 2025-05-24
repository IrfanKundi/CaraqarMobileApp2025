import 'dart:io';

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/content_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import 'package:video_player/video_player.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  VideoPlayerController? _videoPlayerController;
  late ContentController contentController;

  @override
  void dispose() {
    super.dispose();
    if (_videoPlayerController != null) {
      _videoPlayerController?.dispose();
    }
  }

  var currentIndexPosition = 0;

  void playVideo() async {

    if(contentController.newsContent!.files.isNotEmpty){
      _videoPlayerController = Platform.isIOS
          ? VideoPlayerController.networkUrl(Uri.parse(
        contentController.newsContent!.videos[currentIndexPosition],

      ))
          : VideoPlayerController.file(
          contentController.newsContent!.files[currentIndexPosition],
          videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: true,
          ));
    }
    else{
      _videoPlayerController = Platform.isIOS
          ? VideoPlayerController.networkUrl(Uri.parse(
        contentController.newsContent!.videos[currentIndexPosition],

      ))
          : VideoPlayerController.asset(
          kRealStateVideo,
          videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: true,
          ));
    }




    _videoPlayerController
      ?..addListener(() async {
        final bool isPlaying =
            _videoPlayerController!.value.position.inMilliseconds <
                _videoPlayerController!.value.duration.inMilliseconds;

        if (!isPlaying) {
          if (currentIndexPosition <
              contentController.newsContent!.files.length - 1) {
            currentIndexPosition++;
          } else {
            currentIndexPosition = 0;
          }
          var videoPlayerController = _videoPlayerController;
          await videoPlayerController!.dispose();
          playVideo();
        }
      })
      ..initialize().then((_) {
        _videoPlayerController!.setLooping(true);
        _videoPlayerController!.setVolume(0);
        _videoPlayerController!.play();
        setState(() {});
      });
  }

  int sliderIndex = 0;

  @override
  void initState() {
    contentController = Get.put(ContentController());
    contentController.getNews();

    if(contentController.newsContent != null){
      contentController.newsContent!.videos.isNotEmpty ?playVideo():null;
    }

    // TODO: implement initState
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 50.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
           // contentController.newsContent.videos.isNotEmpty
            contentController.newsContent != null ? _videoPlayerController!.value.isInitialized
                    ? SizedBox(
                        height: 220.h,
                        width: 1.sw,
                        child: VideoPlayer(_videoPlayerController!))
                    : Container()
               // : contentController.newsContent.gifs?.isNotEmpty
            : contentController.newsContent != null
                    ? GifView.memory(
                        Get.put(ContentController())
                            .newsContent
                        !.files
                            .last
                            .readAsBytesSync(),
                        fit: BoxFit.fill,
                        height: 220.h,
                        width: 1.sw,
                        progress: const Center(child: CircularLoader()),
                        frameRate: 1, // default is 15 FPS
                      )
                    : contentController.newsContent != null? SizedBox(
                        height: 220.h,
                        width: 1.sw,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: double.infinity,
                            autoPlayCurve: Curves.linearToEaseOut,
                            autoPlay: true,
                            scrollPhysics: const BouncingScrollPhysics(),
                            enableInfiniteScroll: false,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            enlargeCenterPage: true,
                            enlargeStrategy: CenterPageEnlargeStrategy.height,
                            initialPage: sliderIndex,
                            onPageChanged: (index, reason) {
                              sliderIndex = index;
                              setState(() {});
                            },
                          ),
                          items:
                              contentController.newsContent!.files.map((item) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Image.memory(
                                  item.readAsBytesSync(),
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  height: double.infinity,
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ): const SizedBox(height: 20,),
            GetBuilder<ContentController>(
                builder: (controller) => controller.newsStatus.value ==
                        Status.success
                    ? controller.news.isEmpty
                        ? SizedBox(
                          height: 0.9.sh,
                          child: Center(
                              child: Text("NoDataFound".tr),
                            ),
                        )
                        : ListView.separated(
                            physics: const PageScrollPhysics(),
                            padding: kScreenPadding,
                            itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    Get.toNamed(Routes.newsDetailScreen,
                                        arguments: controller.news[index]);
                                  },
                                  child: Stack(
                                    alignment: AlignmentDirectional.bottomEnd,
                                    children: [
                                      ImageWidget(
                                        controller.news[index].images.first,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 0.25.sh,
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4.w, horizontal: 8.w),
                                        decoration: BoxDecoration(
                                          color: Colors.black38,
                                          borderRadius: kBorderRadius4,
                                        ),
                                        child: Text(
                                          controller.news[index].title!,
                                          style: TextStyle(
                                              color: kWhiteColor,
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                            separatorBuilder: (context, index) => kVerticalSpace12,
                            shrinkWrap: true,
                            itemCount: controller.news.length)
                            : SizedBox(
    height: 0.9.sh,
    child: const Center(child: CircularLoader()))),
          ],
        ),
      ),
    );
  }
}
