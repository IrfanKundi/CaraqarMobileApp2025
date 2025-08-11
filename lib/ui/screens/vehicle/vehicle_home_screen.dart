import 'dart:io';

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/favorite_controller.dart';
import 'package:careqar/controllers/home_controller.dart';
import 'package:careqar/controllers/vehicle_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/models/car_model.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/countries_bottom_sheet.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart';
import 'package:video_player/video_player.dart';

class VehicleHomeScreen extends StatefulWidget {
  const VehicleHomeScreen({Key? key}) : super(key: key,);

  @override
  State<VehicleHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends  State<VehicleHomeScreen>  with TickerProviderStateMixin {

  late VideoPlayerController _videoPlayerController;

  late HomeController homeController;

  int sliderIndex=0;

  var currentIndexPosition = 0;
  List top3Types = [];
  @override
  void initState() {
    homeController = Get.find<HomeController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (homeController.typeController.searchedTypes.length >= 3) {
        top3Types = homeController.typeController.searchedTypes.take(3).toList();
        debugPrint("Types updated in XYZ: $top3Types");
        debugPrint("Types updated in XYZ: Vehicle home");
      }
    });
    if (homeController.contentController.homeContent!=null &&
        homeController.contentController.homeContent!.videos.isNotEmpty)
    {
      playVideo();
    }


    // TODO: implement initState
    super.initState();
  }


  void playVideo() async {

    if(homeController.contentController.homeContent !=null &&
        homeController.contentController.homeContent!.files.isNotEmpty){
      _videoPlayerController = Platform.isIOS
          ? VideoPlayerController.networkUrl(Uri.parse(
        homeController.contentController.homeContent!.videos[currentIndexPosition],))
          : VideoPlayerController.file(
          homeController.contentController.homeContent!.files[currentIndexPosition],
          videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: true,
          ));
    }else{
      _videoPlayerController = Platform.isIOS
          ? VideoPlayerController.networkUrl(Uri.parse(
        homeController.contentController.homeContent!.videos[currentIndexPosition],))
          : VideoPlayerController.asset(
          kVehicleVideo,
          videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: true,
          ));
    }

    _videoPlayerController..addListener(() async {
      bool isPlaying = _videoPlayerController.value.position.inMilliseconds < _videoPlayerController.value.duration.inMilliseconds;

      if (!isPlaying) {
        if (currentIndexPosition < homeController.contentController.homeContent!.files.length - 1) {
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
    // kHorizontalSpace12,


    return  Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            (homeController.contentController.homeContent != null &&
                homeController.contentController.homeContent!.videos.isNotEmpty &&
                _videoPlayerController.value.isInitialized)
                ? SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: VideoPlayer(_videoPlayerController))
                : (homeController.contentController.homeContent != null &&
                homeController.contentController.homeContent!.gifs.isNotEmpty)
                ? GifView.memory(
              homeController.contentController.homeContent!.files.last.readAsBytesSync(),
              fit: BoxFit.fill,
              progress: const Center(child: CircularLoader()),
              height: double.infinity,
              width: double.infinity,
              frameRate: 1, // default is 15 FPS
            )
                : (homeController.contentController.homeContent != null &&
                homeController.contentController.homeContent!.images.isNotEmpty)
                ? CarouselSlider(
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
                initialPage: sliderIndex,
                onPageChanged: (index, reason) {
                  sliderIndex = index;
                  setState(() {});
                },
              ),
              items:homeController.contentController.homeContent!.files.map((item) {
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
            )
                : const SizedBox(
              height: double.infinity,
              width: double.infinity, ),

            Container(
              margin: EdgeInsetsDirectional.only(top: 28.h),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: SizedBox(
                height: 54.h,
                child: Row(
                  children: [
                    // Menu button - fixed width with proper spacing
                    GestureDetector(
                      onTap: () {
                        gScaffoldStateKey!.currentState!.openDrawer();
                      },
                      child: Container(
                        width: 40.r,
                        height: 40.r,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black26
                        ),
                        child: const Icon(
                          MaterialCommunityIcons.menu,
                          color: kWhiteColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w), // Reduced space for equal distribution
                    // Search bar - takes remaining space with proper flex
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.allAdsScreen);
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
                                "SearchForCar".tr,
                                style: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  color: kWhiteColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w), // Reduced space for equal distribution
                    // Flag button - fixed width with proper spacing
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
              )
              ],
                ),
              ),
            ),
            //change for IOS
            Positioned(bottom: Platform.isIOS? 0.15.sh:0.14.sh,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.w),
                width: 1.sw,
                child: Container(     margin: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Column(
                    children: [
                      kVerticalSpace8,
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.allAdsScreen,arguments: 0);

                              },
                              child: Container(  height: 40.h,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                decoration: BoxDecoration(
                                    color:  kPrimaryColor,
                                    borderRadius: kBorderRadius8
                                ),
                                child: Text(
                                  "Buy".tr,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    color: kWhiteColor,
                                    fontWeight: FontWeight.w400, // You can use w400, w600, or FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ),
                          kHorizontalSpace8,
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.showroomsScreen);
                              },
                              child: Container(  height: 40.h,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                decoration: BoxDecoration(
                                    color: kAccentColor,
                                    borderRadius: kBorderRadius8
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    "Showroom".tr,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.sp,
                                      color: kWhiteColor,
                                      fontWeight: FontWeight.w400, // You can use w400, w600, or FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          kHorizontalSpace12,
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.chooseServiceScreen);
                              },
                              child: Container(  height: 40.h,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                decoration: BoxDecoration(
                                    color: kMehrunColor,
                                    borderRadius: kBorderRadius8
                                ),
                                child: Text(
                                  "Services".tr,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    color: kWhiteColor,
                                    fontWeight: FontWeight.w400, // You can use w400, w600, or FontWeight.bold
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
                      kVerticalSpace8,

                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.find<VehicleController>().carController.resetFilters();
                                Get.find<VehicleController>().vehicleType=VehicleType.Car;
                                Get.toNamed(Routes.brandsScreen);

                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                  kBorderRadius8,
                                  gradient:
                                  LinearGradient(
                                      colors: [
                                        Color(0xff91c21b),
                                        Color(0xff24695c),
                                      ]),
                                ),
                                padding:
                                EdgeInsets.all(8.w),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                     Padding(
                                       padding: const EdgeInsets.all(5.0),
                                       child: Center(
                                         child: Text(
                                              "Car".tr,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16.sp,
                                                color: kWhiteColor,
                                                fontWeight: FontWeight.w400, // You can use w400, w600, or FontWeight.bold
                                              ),
                                            ),
                                       ),
                                     ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          kHorizontalSpace8,
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.find<VehicleController>().bikeController.resetFilters();
                                Get.find<VehicleController>().vehicleType=VehicleType.Bike;
                                Get.toNamed(Routes.brandsScreen);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                  kBorderRadius8,
                                  gradient:
                                  LinearGradient(
                                      colors: [
                                        Color(0xff011a42),
                                        Color(0xff24695c),
                                      ]),
                                ),
                                padding:
                                EdgeInsets.all(8.w),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Center(
                                          child: Text(
                                              "Bike".tr,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16.sp,
                                                color: kWhiteColor,
                                                fontWeight: FontWeight.w400, // You can use w400, w600, or FontWeight.bold
                                              ),
                                            ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          kHorizontalSpace8,
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.comingSoonScreen);

                                // Get.toNamed(Routes.numberPlateTypesScreen);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                  kBorderRadius8,
                                  gradient:
                                  LinearGradient(
                                      colors: [
                                        Color(0xFF8B1538),
                                        Color(0xff24695c),
                                      ]),
                                ),
                                padding:
                                EdgeInsets.all(8.w),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                     Padding(
                                       padding: const EdgeInsets.all(5.0),
                                       child: Center(
                                         child: Text(
                                              "No.Plate".tr,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16.sp,
                                                color: kWhiteColor,
                                                fontWeight: FontWeight.w400, // You can use w400, w600, or FontWeight.bold
                                              ),
                                            ),
                                       ),
                                     ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }
}

class CarItem extends StatefulWidget {
  const CarItem({
    super.key,
    required this.item,
    this.isGridView=true
  });

  final Car item;
  final bool isGridView;

  @override
  State<CarItem> createState() => _CarItemState();
}

class _CarItemState extends State<CarItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.viewCarScreen, arguments: widget.item)?.then((value) {
          if (mounted) {
            setState(() {});
          }
        });
      },
      child: Card(
        margin: widget.isGridView
            ? EdgeInsets.all(5.w)
            : EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
        shape: widget.isGridView
            ? RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(
            color: Colors.grey.shade300, // Light grey border
            width: 1,
          ),
        )
            : RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        elevation: 0, // No shadow for both
        child: widget.isGridView
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---------- IMAGE SECTION ----------
            Expanded(
              flex: 7,
              child: Padding(
                padding: EdgeInsets.all(8.w), // Same padding as list view
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.r), // Inner radius like list view
                      child: ImageWidget(
                        widget.item.images.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),

                    // New Badge
                    if (DateTime.now()
                        .difference(widget.item.createdAt!)
                        .inDays <
                        2)
                      Positioned(
                        top: 8.h,
                        left: 8.w,
                        child: Container(
                          padding:
                          EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            border: Border.all(color: Colors.white, width: 1.5),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            "New".tr,
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                    // Image Count
                    Positioned(
                      bottom: 8.h,
                      right: 8.w,
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.photo_library_outlined,
                              color: Colors.white,
                              size: 12.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "${widget.item.images.length}",
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
            ),

            // ---------- DETAILS SECTION ----------
            Expanded(
              flex: 7,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal :8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Car Title + Heart
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${widget.item.brandName} ${widget.item.modelName}",
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E3A5F),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          height: 24.w,
                          width: 24.w,
                          child: IconButtonWidget(
                            icon: widget.item.favoriteId! > 0
                                ? MaterialCommunityIcons.heart
                                : MaterialCommunityIcons.heart_outline,
                            color: widget.item.favoriteId! > 0
                                ? kRedColor
                                : Colors.black54,
                            width: 16.w,
                            onPressed: () async {
                              var controller =
                              Get.put(FavoriteController());
                              if (widget.item.favoriteId! > 0) {
                                if (await controller.deleteFavorite(
                                    car: widget.item)) {
                                  setState(() {});
                                }
                              } else {
                                if (await controller.addToFavorites(
                                    car: widget.item)) {
                                  setState(() {});
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // Row 1: Year + Fuel
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.calendar,
                          size: 12.w,
                          color: kIconColor,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "${widget.item.modelYear}",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.gasPump,
                          size: 12.w,
                          color: kIconColor,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "${widget.item.fuelType}",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    // Row 2: Location + Mileage
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.locationDot,
                          size: 12.w,
                          color: kIconColor,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "${widget.item.location}",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.gauge,
                          size: 12.w,
                          color: kIconColor,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "${widget.item.mileage} KM",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // Posted Time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          format(widget.item.createdAt!, locale: gSelectedLocale?.locale?.languageCode),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 10.sp,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
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
                      ],
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
            : // ---------- LIST VIEW ----------
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Container(
                width: 120.w,
                height: 100.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: Colors.black54, // Light grey like screenshot
                    width: 1, // 1px border
                  ),
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

                      // New Badge
                      if (DateTime.now()
                          .difference(widget.item.createdAt!)
                          .inDays <
                          2)
                        Positioned(
                          top: 8.h,
                          left: 8.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50),
                              border: Border.all(
                                  color: Colors.white, width: 1.5),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              "New".tr,
                              style: GoogleFonts.poppins(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                      // Image Count
                      Positioned(
                        bottom: 8.h,
                        right: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.photo_library_outlined,
                                color: Colors.white,
                                size: 12.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "${widget.item.images.length}",
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

                // Details Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${widget.item.brandName} ${widget.item.modelName}",
                              style: TextStyle(
                                color: const Color(0xFF1E3A5F),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 20.w, // Tight height
                              width: 20.w,  // Tight width
                              child: IconButtonWidget(
                                icon: widget.item.favoriteId! > 0
                                    ? MaterialCommunityIcons.heart
                                    : MaterialCommunityIcons.heart_outline,
                                color: widget.item.favoriteId! > 0 ? kRedColor : Colors.black54,
                                width: 14.w,
                                onPressed: () async {
                                  var controller = Get.put(FavoriteController());
                                  if (widget.item.favoriteId! > 0) {
                                    if (await controller.deleteFavorite(car: widget.item)) {
                                      setState(() {});
                                    }
                                  } else {
                                    if (await controller.addToFavorites(car: widget.item)) {
                                      setState(() {});
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.calendar,
                            size: 12.w,
                            color: kIconColor,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "${widget.item.modelYear}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          FaIcon(
                            FontAwesomeIcons.gasPump,
                            size: 12.w,
                            color: kIconColor,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              "${widget.item.fuelType}",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 5.h),

                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.locationDot,
                            size: 12.w,
                            color: kIconColor,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "${widget.item.location}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          FaIcon(
                            FontAwesomeIcons.gauge,
                            size: 12.w,
                            color: kIconColor,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "${widget.item.mileage} ${"KM".tr}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12.sp,
                            ),
                          ),


                        ],
                      ),

                      // Time + Views
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            format(widget.item.createdAt!,
                                locale: gSelectedLocale
                                    ?.locale
                                    ?.languageCode),
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 11.sp,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
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
                        ],
                      ),
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




