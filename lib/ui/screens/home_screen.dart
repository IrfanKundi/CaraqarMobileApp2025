import 'dart:io';
import 'dart:math';

import 'package:careqar/ui/screens/vehicle/coming_soon_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/favorite_controller.dart';
import 'package:careqar/controllers/home_controller.dart';
import 'package:careqar/controllers/property_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/models/property_model.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/countries_bottom_sheet.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:careqar/ui/widgets/shimmer_widget.dart';
import 'package:careqar/user_session.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;

  late HomeController homeController;

  var currentIndexPosition = 0;

  int sliderIndex = 0;

  @override
  void initState() {
    homeController = Get.find<HomeController>();

    if (homeController.contentController.homeContent != null &&
        homeController.contentController.homeContent!.videos.isNotEmpty) {
      playVideo();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.propertyController.getNearbyProperties();
    });

    homeController.tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );

    homeController.tabController.addListener(() {
      if (homeController.tabController.index == 0) {
        homeController.propertyController.getNearbyProperties();
      } else if (homeController.tabController.index == 1) {
        homeController.propertyController.getProperties();
      } else if (homeController.tabController.index == 2) {
        homeController.propertyController.getFollowedProperties();
      }
    });

    // TODO: implement initState
    super.initState();
  }

  void playVideo() async {
    if (homeController.contentController.homeContent != null &&
        homeController.contentController.homeContent!.files.isNotEmpty) {
      _videoPlayerController =
          Platform.isIOS
              ? VideoPlayerController.networkUrl(
                Uri.parse(
                  homeController
                      .contentController
                      .homeContent!
                      .videos[currentIndexPosition],
                ),
              )
              : VideoPlayerController.file(
                homeController
                    .contentController
                    .homeContent!
                    .files[currentIndexPosition],
                videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
              );
    } else {
      _videoPlayerController =
          Platform.isIOS
              ? VideoPlayerController.networkUrl(
                Uri.parse(
                  homeController
                      .contentController
                      .homeContent!
                      .videos[currentIndexPosition],
                ),
              )
              : VideoPlayerController.asset(
                kRealStateVideo,
                videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
              );
    }

    _videoPlayerController
      ..addListener(() async {
        bool isPlaying =
            _videoPlayerController.value.position.inMilliseconds <
            _videoPlayerController.value.duration.inMilliseconds;

        if (!isPlaying) {
          if (currentIndexPosition <
              homeController.contentController.homeContent!.files.length - 1) {
            currentIndexPosition++;
          } else {
            currentIndexPosition = 0;
          }
          var videoPlayerController = _videoPlayerController;
          await videoPlayerController.dispose();
          playVideo();
        }
      })
      ..initialize().then((_) {
        _videoPlayerController.setVolume(0);
        _videoPlayerController.play();
        if (mounted) {
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: kWhiteColor,
              elevation: 0,
              title: Container(
                margin: EdgeInsetsDirectional.only(end: 16.w),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: GestureDetector(
                        onTap: () {
                          homeController.propertyController.resetFilters();
                          homeController.propertyController
                              .getFilteredProperties();
                          Get.toNamed(Routes.propertiesScreen);
                        },

                        child: Container(
                          padding: EdgeInsets.all(8.w),
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: kBorderRadius30,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                MaterialCommunityIcons.magnify,
                                size: 20.sp,
                                color: kWhiteColor,
                              ),
                              kHorizontalSpace4,
                              Text(
                                "SearchForProperty".tr,
                                style: TextStyle(
                                  color: kWhiteColor,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    kHorizontalSpace12,

                    GestureDetector(
                      onTap: () {
                        showCountriesSheet(context);
                      },
                      child: Container(
                        height: 40.h,
                        width: 40.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black26,
                        ),
                        alignment: Alignment.center,
                        child: ClipOval(
                          child: ImageWidget(
                            gSelectedCountry!.flag,
                            height: 37.w,
                            width: 37.w,
                            fit: BoxFit.cover,
                            isCircular: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //Text
              leading: Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      gScaffoldStateKey!.currentState!.openDrawer();
                    },
                    child: Container(
                      margin: EdgeInsets.all(7.w),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black26,
                      ),
                      child: const Icon(
                        MaterialCommunityIcons.menu,
                        color: kWhiteColor,
                      ),
                    ),
                  );
                },
              ),

              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.only(
              //         bottomLeft: Radius.circular(30.r),
              //         bottomRight: Radius.circular(30.r))),
              snap: false,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              titleSpacing: 0,
              toolbarHeight: 50.h,
              pinned: true,
              stretch: true,
              expandedHeight: homeController.maxExtent,
              floating: false,
              flexibleSpace: SizedBox(
                height: double.infinity,
                child: FlexibleSpaceBar.createSettings(
                  currentExtent: homeController.maxExtent,
                  minExtent: 0,
                  maxExtent: homeController.maxExtent,
                  child: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,

                    background: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        (homeController.contentController.homeContent != null &&
                                homeController
                                    .contentController
                                    .homeContent!
                                    .videos
                                    .isNotEmpty &&
                                _videoPlayerController.value.isInitialized)
                            ? SizedBox(
                              height: double.infinity,
                              width: double.infinity,
                              child: VideoPlayer(_videoPlayerController),
                            )
                            : (homeController.contentController.homeContent !=
                                    null &&
                                homeController
                                    .contentController
                                    .homeContent!
                                    .gifs
                                    .isNotEmpty)
                            ? GifView.memory(
                              homeController
                                  .contentController
                                  .homeContent!
                                  .files
                                  .last
                                  .readAsBytesSync(),
                              fit: BoxFit.fill,
                              progress: const Center(child: CircularLoader()),
                              height: 1.sh,
                              width: 1.sw,
                              frameRate: 1, // default is 15 FPS
                            )
                            : (homeController.contentController.homeContent !=
                                    null &&
                                homeController
                                    .contentController
                                    .homeContent!
                                    .images
                                    .isNotEmpty)
                            ? CarouselSlider(
                              options: CarouselOptions(
                                height: 1.sh,
                                autoPlayCurve: Curves.linearToEaseOut,
                                autoPlay: true,
                                scrollPhysics: const BouncingScrollPhysics(),
                                enableInfiniteScroll: false,
                                aspectRatio: 16 / 9,
                                viewportFraction: 1,
                                enlargeCenterPage: true,
                                enlargeStrategy:
                                    CenterPageEnlargeStrategy.height,
                                initialPage: sliderIndex,
                                onPageChanged: (index, reason) {
                                  sliderIndex = index;
                                  setState(() {});
                                },
                              ),
                              items:
                                  homeController
                                      .contentController
                                      .homeContent!
                                      .files
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
                                      })
                                      .toList(),
                            )
                            : SizedBox(height: 1.sh, width: 1.sw),
                        Positioned(
                          bottom: homeController.maxExtent * 0.18,
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.w),
                            width: 1.sw,
                            child: Column(
                              children: [
                                // country check if pakistan selected then hide foreigner
                                gSelectedCountry?.countryId != 11
                                    ? GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (context) => ComingSoonScreen(
                                                  title: "Foreigner Screen",
                                                ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 40.h,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                        ),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: kBorderRadius8,
                                          color: kMehrunColor,
                                          // gradient: LinearGradient(
                                          // // colors: [
                                          // //   Color(0xFFF88B62),
                                          // // Color(0xFFFC5473)
                                          // //
                                          // // ],
                                          //  //stops:[0,0.5,1]
                                          // )
                                        ),
                                        child: Text(
                                          "Foreigner".tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: kWhiteColor,
                                            fontSize: 16.sp,
                                          ),
                                        ),
                                      ),
                                    )
                                    : SizedBox(),
                                kVerticalSpace8,
                                Positioned(
                                  bottom: Platform.isIOS ? 0.15.sh : 0.14.sh,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              homeController.propertyController
                                                  .resetFilters();
                                              homeController
                                                  .propertyController
                                                  .isBuyerMode
                                                  .value = true;
                                              homeController.propertyController
                                                  .getFilteredProperties();
                                              Get.toNamed(
                                                Routes.propertiesScreen,
                                              );
                                            },
                                            child: Container(
                                              height: 40.h,
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 4.w,
                                              ),
                                              decoration: BoxDecoration(
                                                color: kPrimaryColor,
                                                borderRadius: kBorderRadius8,
                                              ),
                                              child: Text(
                                                "Sell".tr,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: kWhiteColor,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        kHorizontalSpace8,
                                        Expanded(
                                          child: Stack(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (UserSession.isLoggedIn!) {
                                                    Get.toNamed(
                                                      Routes
                                                          .newPropertyAdScreen,
                                                    );
                                                  } else {
                                                    Get.toNamed(
                                                      Routes.loginScreen,
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  height: 40.h,
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 4.w,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: kAccentColor,
                                                    borderRadius:
                                                        kBorderRadius8,
                                                  ),
                                                  child: Text(
                                                    "NewAd".tr,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: kWhiteColor,
                                                      fontSize: 16.sp,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              PositionedDirectional(
                                                top: -8.h,
                                                start: -10.w,
                                                child: ClipRect(
                                                  child: Banner(
                                                    message: "Free".tr,
                                                    location:
                                                        BannerLocation.topStart,
                                                    color: Colors.red,
                                                    child: SizedBox(
                                                      height: 50.h,
                                                      width: 50.w,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        kHorizontalSpace8,
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              homeController.propertyController
                                                  .resetFilters();
                                              homeController
                                                  .propertyController
                                                  .isBuyerMode
                                                  .value = false;
                                              homeController.propertyController
                                                  .getFilteredProperties();
                                              Get.toNamed(
                                                Routes.propertiesScreen,
                                              );
                                            },
                                            child: Container(
                                              height: 40.h,
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 4.w,
                                              ),
                                              decoration: BoxDecoration(
                                                color: kMehrunColor,
                                                borderRadius: kBorderRadius8,
                                              ),
                                              child: Text(
                                                "Rent".tr,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: kWhiteColor,
                                                  fontSize: 16.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                kVerticalSpace8,

                                // error
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                                  child: Obx(
                                    () =>
                                        homeController
                                                    .typeController
                                                    .typesStatus
                                                    .value ==
                                                Status.loading
                                            ? ShimmerWidget(
                                              child: Row(
                                                children:
                                                    List.generate(3, (index) {
                                                      return Expanded(
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.symmetric(
                                                                horizontal: 4.w,
                                                              ),
                                                          decoration:
                                                              BoxDecoration(
                                                                color:
                                                                    kWhiteColor,
                                                                borderRadius:
                                                                    kBorderRadius8,
                                                              ),
                                                          height: 60.h,
                                                        ),
                                                      );
                                                    }).toList(),
                                              ),
                                            )
                                            : homeController
                                                    .typeController
                                                    .typesStatus
                                                    .value ==
                                                Status.error
                                            ? Text(
                                              kCouldNotLoadData.tr,
                                              style: kTextStyle16,
                                            )
                                            : Row(
                                              children:
                                                  homeController.typeController.searchedTypes.map((
                                                    element,
                                                  ) {
                                                    var item = element;

                                                    return Expanded(
                                                      child: Container(
                                                        margin:
                                                            EdgeInsets.symmetric(
                                                              horizontal: 4.w,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              kBorderRadius8,
                                                          gradient: LinearGradient(
                                                            colors: [
                                                              Color(
                                                                int.parse(
                                                                  item.color!
                                                                      .replaceFirst(
                                                                        "#",
                                                                        "0xFF",
                                                                      ),
                                                                ),
                                                              ),
                                                              Color(
                                                                int.parse(
                                                                  item.color2!
                                                                      .replaceFirst(
                                                                        "#",
                                                                        "0xFF",
                                                                      ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        padding: EdgeInsets.all(
                                                          8.w,
                                                        ),
                                                        height: 43.h,
                                                        child: InkWell(
                                                          onTap: () {
                                                            homeController
                                                                .typeController
                                                                .getSubTypes(
                                                                  item,
                                                                );
                                                            Get.toNamed(
                                                              Routes
                                                                  .chooseSubtypeScreen,
                                                              arguments: item,
                                                            );
                                                          },
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Expanded(
                                                                child: Center(
                                                                  child: FittedBox(
                                                                    fit:
                                                                        BoxFit
                                                                            .scaleDown,
                                                                    child: Text(
                                                                      " ${item.type}",
                                                                      style: TextStyle(
                                                                        color:
                                                                            kWhiteColor,
                                                                        fontSize:
                                                                            16.sp,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                            ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ), //Images.network
                  ),
                ),
              ), //FlexibleSpaceBaIconButton
            ),
            SliverPersistentHeader(
              delegate: _SliverAppBarDelegate(
                minHeight: 40.h,
                maxHeight: 40.h,
                child: Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: homeController.tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                    unselectedLabelColor: kBlackColor,
                    indicatorColor: kLightBlueColor,
                    labelColor: kLightBlueColor,
                    labelPadding: EdgeInsets.symmetric(horizontal: 8.w),
                    unselectedLabelStyle: kTextStyle16,
                    labelStyle: kTextStyle16,
                    tabs: [
                      Tab(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("NearMe".tr),
                        ),
                      ),
                      Tab(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("Recommended".tr),
                        ),
                      ),
                      Tab(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("Followed".tr),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              pinned: true,
              floating: false,
            ),
          ];
        },
        body: TabBarView(
          controller: homeController.tabController,
          children: [
            GetBuilder<PropertyController>(
              builder:
                  (controller) =>
                      controller.nearByStatus.value == Status.loading
                          ? ShimmerWidget(
                            child: ListView.separated(
                              padding: kScreenPadding.copyWith(bottom: 50.h),
                              itemBuilder: (context, index) {
                                return Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  child: Container(
                                    width: 1.sw,
                                    height: 0.35.sh,
                                    color: Colors.white,
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return kVerticalSpace12;
                              },
                              itemCount: 6,
                            ),
                          )
                          : controller.nearByStatus.value == Status.error
                          ? Center(
                            child: Padding(
                              padding: kHorizontalScreenPadding,
                              child: Text(
                                kCouldNotLoadData.tr,
                                style: kTextStyle16,
                              ),
                            ),
                          )
                          : controller.nearByProperties.value.isNotEmpty
                          ? ListView.separated(
                            padding: kScreenPadding.copyWith(bottom: 50.h),
                            itemBuilder: (context, index) {
                              var item =
                                  controller.nearByProperties.value[index];
                              return SizedBox(
                                height: 0.35.sh,
                                width: 1.sw,
                                child: PropertyItem(item: item),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return kVerticalSpace12;
                            },
                            itemCount: controller.nearByProperties.value.length,
                          )
                          : Center(
                            child: Padding(
                              padding: kHorizontalScreenPadding,
                              child: Text(
                                "0 ${"PropertiesFoundNearYou".tr}",
                                style: kTextStyle16,
                              ),
                            ),
                          ),
            ),
            GetBuilder<PropertyController>(
              builder:
                  (controller) =>
                      controller.recomStatus.value == Status.loading
                          ? ShimmerWidget(
                            child: ListView.separated(
                              padding: kScreenPadding.copyWith(bottom: 50.h),
                              itemBuilder: (context, index) {
                                return Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  child: Container(
                                    height: 0.35.sh,
                                    width: 1.sw,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return kHorizontalSpace12;
                              },
                              itemCount: 6,
                            ),
                          )
                          : controller.recomStatus.value == Status.error
                          ? Center(
                            child: Text(
                              kCouldNotLoadData.tr,
                              style: kTextStyle16,
                            ),
                          )
                          : controller.recommendedProperties.value.isNotEmpty
                          ? ListView.separated(
                            padding: kScreenPadding.copyWith(bottom: 50.h),
                            itemBuilder: (context, index) {
                              var item =
                                  controller.recommendedProperties.value[index];
                              return SizedBox(
                                height: 0.35.sh,
                                width: 1.sw,
                                child: PropertyItem(item: item),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return kVerticalSpace12;
                            },
                            itemCount:
                                controller.recommendedProperties.value.length,
                          )
                          : Center(
                            child: Padding(
                              padding: kHorizontalScreenPadding,
                              child: Text(
                                "0 ${"PropertiesFound".tr}",
                                style: kTextStyle16,
                              ),
                            ),
                          ),
            ),
            GetBuilder<PropertyController>(
              builder:
                  (controller) =>
                      controller.followedStatus.value == Status.loading
                          ? ShimmerWidget(
                            child: ListView.separated(
                              padding: kScreenPadding.copyWith(bottom: 50.h),
                              itemBuilder: (context, index) {
                                return Card(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  child: Container(
                                    height: 0.35.sh,
                                    width: 1.sw,
                                    color: Colors.white,
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return kHorizontalSpace12;
                              },
                              itemCount: 6,
                            ),
                          )
                          : controller.followedStatus.value == Status.error
                          ? Center(
                            child: Text(
                              kCouldNotLoadData.tr,
                              style: kTextStyle16,
                            ),
                          )
                          : controller.followedProperties.value.isNotEmpty
                          ? ListView.separated(
                            padding: kScreenPadding.copyWith(bottom: 50.h),
                            itemBuilder: (context, index) {
                              var item =
                                  controller.followedProperties.value[index];
                              return SizedBox(
                                height: 0.35.sh,
                                width: 1.sw,
                                child: PropertyItem(item: item),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return kVerticalSpace12;
                            },
                            itemCount:
                                controller.followedProperties.value.length,
                          )
                          : Center(
                            child: Padding(
                              padding: kHorizontalScreenPadding,
                              child: Text(
                                "0 ${"PropertiesFound".tr}",
                                style: kTextStyle16,
                              ),
                            ),
                          ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class PropertyItem extends StatefulWidget {
  const PropertyItem({Key? key, required this.item, this.isGridView = true})
    : super(key: key);

  final Property item;
  final bool isGridView;

  @override
  State<PropertyItem> createState() => _PropertyItemState();
}

class _PropertyItemState extends State<PropertyItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.viewPropertyScreen, arguments: widget.item)?.then((
          value,
        ) {
          if (mounted) setState(() {});
        });
      },
      child: Card(
        margin:
            widget.isGridView
                ? EdgeInsets.all(5.w)
                : EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        elevation: 0,
        child:
            widget.isGridView
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // IMAGE SECTION
                    Expanded(
                      flex: 7,
                      child: Padding(
                        padding: EdgeInsets.all(8.w),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.r),
                              child: ImageWidget(
                                widget.item.images.first,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),

                            // PURPOSE badge (Sell / Rent)
                            Positioned(
                              top: 8.h,
                              left: 8.w,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 2.h,
                                      horizontal: 8.w,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          widget.item.purpose == "Sell"
                                              ? kAccentColor
                                              : kLightBlueColor,
                                      borderRadius: BorderRadius.circular(30.r),
                                    ),
                                    child: Text(
                                      "For${widget.item.purpose}".tr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                  if (DateTime.now()
                                          .difference(widget.item.createdAt!)
                                          .inDays <
                                      2)
                                    Container(
                                      margin: EdgeInsets.only(top: 4.h),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 3.h,
                                        horizontal: 8.w,
                                      ),
                                      decoration: BoxDecoration(
                                        color: kRedColor,
                                        borderRadius: BorderRadius.circular(
                                          30.r,
                                        ),
                                      ),
                                      child: Text(
                                        "New".tr,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // Views counter + Favorite
                            Positioned(
                              top: 8.h,
                              right: 8.w,
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          MaterialCommunityIcons.eye_outline,
                                          color: Colors.white,
                                          size: 12.sp,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          "${widget.item.clicks}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  IconButtonWidget(
                                    icon:
                                        widget.item.favoriteId! > 0
                                            ? MaterialCommunityIcons.heart
                                            : MaterialCommunityIcons
                                                .heart_outline,
                                    color:
                                        widget.item.favoriteId! > 0
                                            ? kRedColor
                                            : Colors.white,
                                    width: 28.w,
                                    onPressed: () async {
                                      var favCtrl = Get.put(
                                        FavoriteController(),
                                      );
                                      if (widget.item.favoriteId! > 0) {
                                        if (await favCtrl.deleteFavorite(
                                          property: widget.item,
                                        )) {
                                          if (mounted) setState(() {});
                                        }
                                      } else {
                                        if (await favCtrl.addToFavorites(
                                          property: widget.item,
                                        )) {
                                          if (mounted) setState(() {});
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // DETAILS SECTION
                    Expanded(
                      flex: 6,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              widget.item.title ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1E3A5F),
                              ),
                            ),
                            SizedBox(height: 4.h),

                            // Location
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.locationDot,
                                  size: 12.w,
                                  color: const Color(0xFF4A90E2),
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    widget.item.location ?? "",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 11.sp,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),

                            // Area
                            Row(
                              children: [
                                Icon(
                                  CupertinoIcons.map_pin_ellipse,
                                  size: 14.sp,
                                  color: const Color(0xFF4A90E2),
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    "${widget.item.area} ${"Marla".tr}",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 11.sp,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),

                            // Time
                            Text(
                              format(
                                widget.item.createdAt!,
                                locale: gSelectedLocale?.locale?.languageCode,
                              ),
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 11.sp,
                              ),
                            ),
                            SizedBox(height: 2.h),

                            // Price
                            Text(
                              getPrice(widget.item.price!),
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: kPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                : // LIST VIEW
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // IMAGE
                        Container(
                          width: 120.w,
                          height: 100.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.r),
                            border: Border.all(color: Colors.black54, width: 1),
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15.r),
                                child: ImageWidget(
                                  widget.item.images.first,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                              // PURPOSE badge
                              Positioned(
                                top: 8.h,
                                left: 8.w,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 2.h,
                                    horizontal: 8.w,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        widget.item.purpose == "Sell"
                                            ? kAccentColor
                                            : kLightBlueColor,
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  child: Text(
                                    "For${widget.item.purpose}".tr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ),
                              // Views counter
                              Positioned(
                                bottom: 8.h,
                                right: 8.w,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        MaterialCommunityIcons.eye_outline,
                                        color: Colors.white,
                                        size: 12.sp,
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        "${widget.item.clicks}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16.w),

                        // DETAILS
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Text(
                                widget.item.title ?? "",
                                style: TextStyle(
                                  color: const Color(0xFF1E3A5F),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),

                              // Location
                              Row(
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.locationDot,
                                    size: 12.w,
                                    color: const Color(0xFF4A90E2),
                                  ),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                    child: Text(
                                      widget.item.location ?? "",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12.sp,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),

                              // Area
                              Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.map_pin_ellipse,
                                    size: 14.sp,
                                    color: const Color(0xFF4A90E2),
                                  ),
                                  SizedBox(width: 4.w),
                                  Expanded(
                                    child: Text(
                                      "${widget.item.area} ${"Marla".tr}",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12.sp,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),

                              // Time
                              Text(
                                format(
                                  widget.item.createdAt!,
                                  locale: gSelectedLocale?.locale?.languageCode,
                                ),
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 11.sp,
                                ),
                              ),
                              SizedBox(height: 2.h),

                              // Price
                              Text(
                                getPrice(widget.item.price!),
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
