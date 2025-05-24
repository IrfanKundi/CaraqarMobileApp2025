import 'dart:io';

import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/city_controller.dart';
import 'package:careqar/controllers/content_controller.dart';
import 'package:careqar/routes.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import 'package:video_player/video_player.dart';

import '../../constants/colors.dart';
import '../../enums.dart';
import '../widgets/circular_loader.dart';
import '../widgets/image_widget.dart';

class ForeignerScreen extends StatefulWidget {
  const ForeignerScreen({Key? key}) : super(key: key);

  @override
  State<ForeignerScreen> createState() => _ForeignerScreenState();
}

class _ForeignerScreenState extends State<ForeignerScreen> {
  int sliderIndex = 0;
  int requirementSlider = 0;

  var requirementList = [
    "assets/images/req1.png",
    "assets/images/req2.png",
  ];

  late VideoPlayerController? _videoPlayerController;

  late ContentController contentController;

  CityController? cityController;

  @override
  void dispose() {
    super.dispose();
    if (_videoPlayerController != null) {
      _videoPlayerController?.dispose();
    }
  }

  var currentIndexPosition = 0;

  void playVideo() async {
    if (contentController.foreignerContent!.files.isNotEmpty) {
      _videoPlayerController = Platform.isIOS
          ? VideoPlayerController.network(
              contentController.foreignerContent!.videos[currentIndexPosition],
              videoPlayerOptions: VideoPlayerOptions(
                mixWithOthers: true,
              ))
          : VideoPlayerController.file(
              contentController.foreignerContent!.files[currentIndexPosition],
              videoPlayerOptions: VideoPlayerOptions(
                mixWithOthers: true,
              ));
    } else {
      _videoPlayerController = Platform.isIOS
          ? VideoPlayerController.network(
              contentController.foreignerContent!.videos[currentIndexPosition],
              videoPlayerOptions: VideoPlayerOptions(
                mixWithOthers: true,
              ))
          : VideoPlayerController.asset(kRealStateVideo,
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
              contentController.foreignerContent!.files.length - 1) {
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
        //_videoPlayerController.setLooping(true);
        _videoPlayerController!.setVolume(0);
        _videoPlayerController!.play();
        if (mounted) {
          setState(() {});
        }
      });
  }

 @override
  void initState() {
   cityController = Get.find<CityController>();
   contentController = Get.find<ContentController>();

   contentController.getRequirementsByCountry();

   if (contentController.foreignerContent != null) {
     contentController.foreignerContent!.videos.isNotEmpty
         ? playVideo()
         : null;
   }

   super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            contentController.foreignerContent!.videos.isNotEmpty
                ? _videoPlayerController!.value.isInitialized
                    ? SizedBox(
                        height: 220.h,
                        width: 1.sw,
                        child: VideoPlayer(_videoPlayerController!))
                    : Container()
                : contentController.foreignerContent!.gifs.isNotEmpty
                    ? GifView.memory(
                        contentController.foreignerContent!.files.last
                            .readAsBytesSync(),
                        fit: BoxFit.fill,
                        height: 220.h,
                        width: 1.sw,
                        progress: const Center(child: CircularLoader()),

                        frameRate: 1, // default is 15 FPS
                      )
                    : SizedBox(
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
                          items: contentController!.foreignerContent!.files
                              .map((item) {
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
                      ),
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.only(top: 0,left: 16.w,right: 16.w,bottom: 16.w),
                child: Column(
                  children: [
                    GetBuilder<ContentController>(
                        builder: (controller) => controller
                                    .countryRequirementsStatus.value == Status.success ? controller.countryRequirements.isEmpty
                                ? Center(
                                    child: Text("NoDataFound".tr),
                                  )
                                : ListView.separated(
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) => InkWell(
                                          onTap: () {
                                            cityController!.getForeignerCities(true,controller.countryRequirements[index].foreignerCategoryId);
                                            Get.toNamed(Routes.chooseForeignerCityScreen);
                                          },
                                          child: Stack(
                                            alignment:
                                                AlignmentDirectional.bottomEnd,
                                            children: [
                                              ImageWidget(
                                                controller
                                                    .countryRequirements[index]
                                                    .image,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: 0.25.sh,
                                              ),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4.w,
                                                    horizontal: 8.w),
                                                decoration: BoxDecoration(
                                                  color: Colors.black38,
                                                  borderRadius: kBorderRadius4,
                                                ),
                                                child: Text(
                                                  controller
                                                      .countryRequirements[
                                                          index]
                                                      .title!,
                                                  style: TextStyle(
                                                      color: kWhiteColor,
                                                      fontSize: 17.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                    separatorBuilder: (context, index) =>
                                        kVerticalSpace12,
                                    shrinkWrap: true,
                                    itemCount:
                                        controller.countryRequirements.length)
                            : SizedBox(
                                height: 0.25.sh,
                                child: const Center(child: CircularLoader()))),
                    kVerticalSpace16,
                    SizedBox(
                      height: 0.25.sh,
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(Routes.requirementsScreen);
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                height: double.infinity,
                                autoPlayCurve: Curves.linearToEaseOut,
                                autoPlay: true,
                                scrollPhysics: const BouncingScrollPhysics(),
                                enableInfiniteScroll: false,
                                aspectRatio: 16 / 9,
                                viewportFraction: 1,
                                enlargeCenterPage: true,
                                enlargeStrategy:
                                    CenterPageEnlargeStrategy.height,
                                initialPage: requirementSlider,
                                onPageChanged: (index, reason) {
                                  requirementSlider = index;
                                  setState(() {});
                                },
                              ),
                              items: requirementList.map((item) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Image.asset(
                                      item,
                                      fit: BoxFit.fill,
                                      width: double.infinity,
                                      height: double.infinity,
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4.w, horizontal: 8.w),
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: kBorderRadius4,
                              ),
                              child: Text(
                                "Requirements".tr,
                                style: TextStyle(
                                    color: kWhiteColor,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
