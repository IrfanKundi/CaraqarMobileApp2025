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
import 'package:careqar/user_session.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
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

            SafeArea(
              child: Container(
                  margin: EdgeInsetsDirectional.only(end: 16.w),


                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: (){

                          gScaffoldStateKey!.currentState!.openDrawer();

                        },
                        child: Container(
                          width: 40.r,
                          height: 40.r,
                          margin: EdgeInsets.all(7.w),

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
                      Expanded(
                        flex: 3,
                        child: GestureDetector(
                          onTap: () {

                            Get.toNamed(Routes.allAdsScreen);
                          },
                          child: Container(  padding: EdgeInsets.all(8.w),
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
                        onTap: (){
                          showCountriesSheet(context);
                        },
                        child: ImageWidget(
                          gSelectedCountry!.flag
                          ,height: 30.w,width: 30.w,),
                      )

                    ],
                  )),
            ),
            Positioned(bottom: Platform.isIOS? 0.095.sh:0.075.sh,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.w),
                width: 1.sw,
                child: Container(     margin: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Column(
                    children: [
                      Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if(UserSession.isLoggedIn!){
                                  Get.toNamed(Routes.newAdScreen);
                                }else{
                                  Get.toNamed(Routes.loginScreen);
                                }
                              },
                              child: Container(
                                height: 40.h,
                                // margin: EdgeInsets.symmetric(horizontal: 8.w),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: kBorderRadius8,
                                    color: const Color(0xFF8B1538)
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
                                  "PostNewAd".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:  kWhiteColor,

                                    fontSize: 16.sp,),
                                ),
                              ),
                            ),
                            PositionedDirectional(
                              top: -8.h,
                              start: -10.w,

                              child: ClipRect(
                                child: Banner(
                                  message: "Free".tr,
                                  location: BannerLocation.topStart,
                                  color: Colors.red,
                                  child: Container(
                                    height: 50.h,
                                    width: 50.w,
                                  ),
                                ),
                              ),
                            ),
                          ]),

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
                                  "Personal".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:  kWhiteColor,

                                    fontSize: 16.sp,),
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
                                    style: TextStyle(
                                      color: kWhiteColor,
                                      fontSize: 16.sp,),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          kHorizontalSpace8,
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.chooseServiceScreen);
                              },
                              child: Container(  height: 40.h,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                decoration: BoxDecoration(
                                    color: kLightBlueColor,
                                    borderRadius: kBorderRadius8
                                ),
                                child: Text(
                                  "Services".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: kWhiteColor,
                                    fontSize: 16.sp,),
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
                                height: 60.h,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    Expanded(
                                      child:
                                      ImageWidget(
                                        "assets/icon/car.png",
                                        width: 22.w,
                                        height: 22.w,
                                        isLocalImage: true,
                                      ),
                                    ),
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit
                                            .scaleDown,
                                        child: Text(
                                          "Car".tr,
                                          style: TextStyle(
                                              color:
                                              kWhiteColor,
                                              fontSize:
                                              16.sp),
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
                                height: 60.h,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    Expanded(
                                      child:
                                      ImageWidget(
                                        "assets/icon/bike.png",
                                        width: 22.w,
                                        height: 22.w,
                                        isLocalImage: true,
                                      ),
                                    ),
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit
                                            .scaleDown,
                                        child: Text(
                                          "Bike".tr,
                                          style: TextStyle(
                                              color:
                                              kWhiteColor,
                                              fontSize:
                                              16.sp),
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
                                        Color(0xff9bcbff),
                                        Color(0xff24695c),
                                      ]),
                                ),
                                padding:
                                EdgeInsets.all(8.w),
                                height: 60.h,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    Expanded(
                                      child:
                                      ImageWidget(
                                        "assets/icon/noPlate.png",
                                        width: 22.w,
                                        height: 22.w,
                                        isLocalImage: true,
                                      ),
                                    ),
                                    Expanded(
                                      child: FittedBox(
                                        fit: BoxFit
                                            .scaleDown,
                                        child: Text(
                                          "No.Plate".tr,
                                          style: TextStyle(
                                              color:
                                              kWhiteColor,
                                              fontSize:
                                              16.sp),
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
    Key? key,
    required this.item,
    this.isGridView=true
  }) : super(key: key);

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
        Get.toNamed(
            Routes.viewCarScreen,
            arguments: widget.item)?.then((value) {
          if(mounted){
            setState(() {

            });
          }
        });
      },
      child: Card(
        margin:  widget.isGridView?
        EdgeInsets.all(5.w):
        EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.w),


        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child:
        widget.isGridView?

        Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
            children: [
              Expanded(flex: 6,
                child:
                Stack(
                  children: [
                    ImageWidget(
                      widget.item.images
                          .first,
                      fit: BoxFit
                          .cover,
                    ),
                    PositionedDirectional( top: 4.w,
                      start: 4.w,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(DateTime.now().difference(widget.item.createdAt!).inDays<2)
                            Container(
                              margin: EdgeInsets.only(top: 4.h),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 8),
                              decoration: BoxDecoration(
                                color: kRedColor,
                                borderRadius: kBorderRadius30,
                              ),
                              child: Text(
                                "New".tr,
                                style: TextStyle(
                                    color:kWhiteColor, fontSize: 10.sp),),
                            ),
                        ],
                      ),
                    ),
                    PositionedDirectional(
                        top: 4.w,
                        end: 4.w,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: kBorderRadius30,
                              ),
                              child: Row(
                                children: [
                                  Icon(MaterialCommunityIcons.eye_outline,size: 16.sp,color: kWhiteColor,),
                                  Text(
                                    " ${widget.item.clicks}",
                                    style: TextStyle(
                                        color: kWhiteColor, fontSize: 12.sp),),
                                ],
                              ),
                            ),
                            kVerticalSpace4,
                            Container(     decoration: const BoxDecoration(
                                color: Colors.black38,
                                shape: BoxShape.circle
                            ),
                              child:    IconButtonWidget(
                                icon: widget.item.favoriteId!>0?
                                MaterialCommunityIcons.heart:
                                MaterialCommunityIcons
                                    .heart_outline,
                                color:widget.item.favoriteId!>0? kRedColor:kWhiteColor,
                                width: 30.w,
                                onPressed: ()async {
                                  var controller =  Get.put(FavoriteController());
                                  if(widget.item.favoriteId!>0){

                                    if(await controller.deleteFavorite(car: widget.item)){
                                      setState(() {

                                      });
                                    }
                                  }else{
                                    if(await controller.addToFavorites(car:widget.item)){
                                      setState(() {

                                      });
                                    }
                                  }

                                },),)
                          ],
                        ))
                  ],
                ),
              ),
              Expanded(flex: 7,
                  child:
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Text("${widget.item.brandName} ${widget.item.modelName} ${widget.item.modelYear}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: kTextStyle16.copyWith(color: kAccentColor),),
                        kVerticalSpace4,

                        Row(
                          children: [   Icon(  MaterialCommunityIcons.map_marker_outline,    size: 16.sp,
                            color: kLightBlueColor,),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  " ${widget.item.cityName}",
                                  maxLines:
                                  1,
                                  style:
                                  TextStyle(color: kGreyColor,    height: 1.3, fontSize: 12.sp),
                                ),
                              ),
                            ),
                          ],
                        ),
                        kVerticalSpace4,

                        Row(
                          children: [   Icon(  MaterialCommunityIcons.car,    size: 16.sp,
                            color: kLightBlueColor,),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  " ${widget.item.type}",
                                  maxLines:
                                  1,
                                  style:
                                  TextStyle(color: kGreyColor,    height: 1.3, fontSize: 12.sp),
                                ),
                              ),
                            ),
                          ],
                        ),    kVerticalSpace4,

                        Row(
                          children: [   Icon(  MaterialCommunityIcons.speedometer,    size: 16.sp,
                            color: kLightBlueColor,),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  " ${widget.item.mileage} ${"KM".tr}",
                                  maxLines:
                                  1,
                                  style:
                                  TextStyle(color: kGreyColor,    height: 1.3, fontSize: 12.sp),
                                ),
                              ),
                            ),
                          ],
                        ),    kVerticalSpace4,
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${format(widget.item.createdAt!,locale: gSelectedLocale?.locale?.languageCode)}",textDirection: TextDirection.ltr, maxLines:
                          1,
                            style: TextStyle(color: kGreyColor,     height: 1.3,fontSize: 12.sp),
                          ),
                        )
                        ,
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(getPrice(widget.item.price!),
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                                color: kPrimaryColor,
                                height: 1.3,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ),

                      ],
                    ),
                  ))
            ]):
        Container(
          height: 140.h,
          child: Row(
              crossAxisAlignment:
              CrossAxisAlignment
                  .stretch,
              children: [
                Expanded(flex: 2,
                  child:
                  Stack(
                    children: [
                      ImageWidget(
                        widget.item.images
                            .first,
                        fit: BoxFit
                            .cover,
                      ),
                      PositionedDirectional( top: 4.w,
                        start: 4.w,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            if(DateTime.now().difference(widget.item.createdAt!).inDays<2)
                              Container(
                                margin: EdgeInsets.only(top: 4.h),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: kRedColor,
                                  borderRadius: kBorderRadius30,
                                ),
                                child: Text(
                                  "New".tr,
                                  style: TextStyle(
                                      color:kWhiteColor, fontSize: 10.sp),),
                              ),
                          ],
                        ),
                      ),
                      PositionedDirectional(
                          top: 4.w,
                          end: 4.w,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: kBorderRadius30,
                                ),
                                child: Row(
                                  children: [
                                    Icon(MaterialCommunityIcons.eye_outline,size: 16.sp,color: kWhiteColor,),
                                    Text(
                                      " ${widget.item.clicks}",
                                      style: TextStyle(
                                          color: kWhiteColor, fontSize: 12.sp),),
                                  ],
                                ),
                              ), kVerticalSpace4,
                              Container(     decoration: const BoxDecoration(
                                  color: Colors.black38,
                                  shape: BoxShape.circle
                              ),
                                child:
                                IconButtonWidget(
                                  icon: widget.item.favoriteId!>0?
                                  MaterialCommunityIcons.heart:
                                  MaterialCommunityIcons
                                      .heart_outline,
                                  color:widget.item.favoriteId!>0? kRedColor:kWhiteColor,
                                  width: 30.w,
                                  onPressed: ()async {
                                    var controller =  Get.put(FavoriteController());
                                    if(widget.item.favoriteId!>0){

                                      if(await controller.deleteFavorite(car: widget.item)){
                                        setState(() {

                                        });
                                      }
                                    }else{
                                      if(await controller.addToFavorites(car:widget.item)){
                                        setState(() {

                                        });
                                      }
                                    }


                                  },),)
                            ],
                          ))
                    ],
                  ),
                ),
                Expanded(flex: 3,
                    child:
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [


                          Text("${widget.item.brandName} ${widget.item.modelName} ${widget.item.modelYear}",
                            maxLines: 1,
                            style: kTextStyle16.copyWith(color: kAccentColor),),
                          kVerticalSpace4,

                          Row(
                            children: [   Icon(  MaterialCommunityIcons.map_marker_outline,    size: 16.sp,
                              color: kLightBlueColor,),
                              Expanded(
                                child: Text(
                                  " ${widget.item.cityName}",
                                  maxLines:
                                  1,
                                  style:
                                  TextStyle(color: kGreyColor,    height: 1.3, fontSize: 12.sp),
                                ),
                              ),
                            ],
                          ),
                          kVerticalSpace4,

                          Row(
                            children: [   Icon(  MaterialCommunityIcons.car,    size: 16.sp,
                              color: kLightBlueColor,),
                              Expanded(
                                child: Text(
                                  " ${widget.item.type}",
                                  maxLines:
                                  1,
                                  style:
                                  TextStyle(color: kGreyColor,    height: 1.3, fontSize: 12.sp),
                                ),
                              ),
                            ],
                          ),    kVerticalSpace4,

                          Row(
                            children: [   Icon(  MaterialCommunityIcons.speedometer,    size: 16.sp,
                              color: kLightBlueColor,),
                              Expanded(
                                child: Text(
                                  " ${widget.item.mileage} ${"KM".tr}",
                                  maxLines:
                                  1,
                                  style:
                                  TextStyle(color: kGreyColor,    height: 1.3, fontSize: 12.sp),
                                ),
                              ),
                            ],
                          ),    kVerticalSpace4,


                          Text(
                            "${format(widget.item.createdAt!,locale: gSelectedLocale?.locale?.languageCode)}",textDirection: TextDirection.ltr, maxLines:
                          1,
                            style: TextStyle(color: kGreyColor,     height: 1.3,fontSize: 12.sp),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(getPrice(widget.item.price!), textDirection: TextDirection.ltr,
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  height: 1.3,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),

                        ],
                      ),
                    ))
              ]),
        ),

      ),
    );
  }
}




