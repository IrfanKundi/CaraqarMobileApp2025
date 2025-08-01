import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/services/dynamic_link.dart';
import 'package:careqar/ui/screens/view_property_screen.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:careqar/ui/widgets/remove_splash.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/strings.dart';
import '../../../controllers/favorite_controller.dart';
import '../../../controllers/view_bike_controller.dart';
import '../../../global_variables.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/text_field_widget.dart';

class ViewBikeScreen extends GetView<ViewBikeController> {
  ViewBikeScreen({Key? key}) : super(key: key) {
    //print(Get.arguments);
    controller.sliderIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    controller.formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Obx(() {
        var bike = controller.bike.value;
        return controller.status.value == Status.success
            ? NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                        backgroundColor: kWhiteColor,
                        iconTheme: IconThemeData(color: kBlackColor),
                        expandedHeight: 0.6.sh,
                        pinned: true,
                        title: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  "Details".tr.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: kAppBarStyle,
                                )),
                                kHorizontalSpace12,
                                IconButtonWidget(
                                  icon: MaterialCommunityIcons.share_variant,
                                  color: kBlackColor,
                                  onPressed: () async {
                                    String adUrl =
                                        await DynamicLink.createDynamicLink(
                                            false,
                                            uri: "/bike?bikeId=${bike?.bikeId}",
                                            title:
                                                "${bike?.brandName} ${bike?.modelName} ${bike?.modelYear}",
                                            desc: bike?.description,
                                            image: bike?.images.first);
                                    String webUrl =
                                        "https://www.caraqar.co/Bikes/Detail/${bike?.bikeId}";
                                    var message =
                                        "Hey! you might be interested in this.\n$adUrl\nor Check this ad on Car aqar\n$webUrl";
                                    print("share = $message");
                                    Share.share(message);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          background: Stack(
                            alignment: Alignment.center,
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
                                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                                  initialPage: controller.sliderIndex.value,
                                  onPageChanged: (index, reason) {
                                    controller.sliderIndex.value = index;
                                    controller.update();
                                  },
                                ),
                                items: bike.images.map((item) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return GestureDetector(
                                        onTap: () {
                                          // Images are already preloaded, navigation will be instant
                                          Get.toNamed(
                                            Routes.staggeredGalleryScreen,
                                            arguments: bike.images,
                                          );
                                        },
                                        child: CachedNetworkImage(
                                          imageUrl: item,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(
                                            color: Colors.grey[200],
                                            child: Center(
                                              child: CircularProgressIndicator(),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => Container(
                                            color: Colors.grey[200],
                                            child: Center(
                                              child: Icon(Icons.error, size: 50),
                                            ),
                                          ),
                                          memCacheWidth: 800,
                                          memCacheHeight: 600,
                                          maxWidthDiskCache: 1000,
                                          maxHeightDiskCache: 1000,
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  height: 20.h,
                                  width: 1.sw,
                                  decoration: BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      color: Colors.white,
                                      spreadRadius: 15,
                                      blurRadius: 15,
                                      offset: Offset(0, 15),
                                    )
                                  ]),
                                ),
                              ),
                              Positioned(
                                  bottom: 40.h,
                                  child: Container(
                                    width: 1.sw,
                                    padding: kScreenPadding.copyWith(
                                        top: 8.w, bottom: 8.w),
                                    decoration: BoxDecoration(
                                      color: Colors.black12,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "${bike?.brandName} ${bike?.modelName} ${bike?.modelYear}",
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  style: kLightTextStyle18),
                                              kVerticalSpace4,
                                              Row(
                                                children: [
                                                  Icon(
                                                    MaterialCommunityIcons
                                                        .map_marker_outline,
                                                    size: 16.sp,
                                                    color: kWhiteColor,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                        "${bike?.cityName}",
                                                        style: kTextStyle14
                                                            .copyWith(
                                                                color:
                                                                    kWhiteColor)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            GetBuilder<ViewBikeController>(
                                              builder: (controller) =>
                                                  IconButtonWidget(
                                                icon: bike!.favoriteId! > 0
                                                    ? MaterialCommunityIcons
                                                        .heart
                                                    : MaterialCommunityIcons
                                                        .heart_outline,
                                                color: bike.favoriteId! > 0
                                                    ? kRedColor
                                                    : kWhiteColor,
                                                width: 30.w,
                                                onPressed: () async {
                                                  var favController = Get.put(
                                                      FavoriteController());
                                                  if (bike.favoriteId! > 0) {
                                                    if (await favController
                                                        .deleteFavorite(
                                                            bike: bike)) {
                                                      controller.update();
                                                    }
                                                  } else {
                                                    if (await favController
                                                        .addToFavorites(
                                                            bike: bike)) {
                                                      controller.update();
                                                    }
                                                  }
                                                },
                                              ),
                                            ),
                                            kVerticalSpace8,
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2, horizontal: 8),
                                              decoration: BoxDecoration(
                                                color: Colors.black38,
                                                borderRadius: kBorderRadius30,
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    MaterialCommunityIcons
                                                        .eye_outline,
                                                    size: 16.sp,
                                                    color: kWhiteColor,
                                                  ),
                                                  Text(
                                                    " ${bike?.clicks}",
                                                    style: TextStyle(
                                                        color: kWhiteColor,
                                                        fontSize: 12.sp),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ), systemOverlayStyle: SystemUiOverlayStyle.dark),
                  ];
                },
                body: RemoveSplash(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 8.w),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (bike?.companyId != null) {
                                    if (Get.previousRoute ==
                                        Routes.companyScreen +
                                            "?type=Bike&agentAds=${bike?.isAgentAd}") {
                                      Get.back();
                                    } else {
                                      Get.offNamed(Routes.companyScreen,
                                          arguments: bike?.companyId,
                                          parameters: {
                                            "type": "Bike",
                                            "agentAds": "${bike?.isAgentAd}"
                                          });
                                    }
                                  } else if (bike?.agentId != null) {
                                    if (Get.previousRoute ==
                                        Routes.agentScreen +
                                            "?type=Bike&agentAds=${bike?.isAgentAd}") {
                                      Get.back();
                                    } else {
                                      Get.offNamed(Routes.agentScreen,
                                          arguments: bike?.agentId,
                                          parameters: {
                                            "type": "Bike",
                                            "agentAds": "${bike?.isAgentAd}"
                                          });
                                    }
                                  }
                                },
                                child: ImageWidget(
                                  bike?.agentImage == "" ||
                                          bike?.agentImage == null
                                      ? "assets/images/profile2.jpg"
                                      : bike?.agentImage,
                                  width: 70.r,
                                  height: 70.r,
                                  isCircular: true,
                                  isLocalImage: bike?.agentImage == "" ||
                                      bike?.agentImage == null,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              kHorizontalSpace12,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${bike?.agentName}",
                                      style: kTextStyle16.copyWith(
                                          color: kAccentColor),
                                    ),
                                    kVerticalSpace4,
                                    Text(
                                      "Owner".tr,
                                      style: kTextStyle14.copyWith(
                                          color: kGreyColor),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 40.w,
                                child: OutlinedButton(
                                  onPressed: () async {
                                    controller.updateClicks(isCall: true);
                                    await launch("tel://${bike?.contactNo}");
                                  },
                                  style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      side: BorderSide(
                                          color: Colors.transparent)),
                                  child: Icon(MaterialCommunityIcons.phone,
                                      color: kAccentColor, size: 25.w),
                                ),
                              ),
                              SizedBox(
                                width: 40.w,
                                child: OutlinedButton(
                                  onPressed: () async {
                                    controller.updateClicks(isWhatsapp: true);
                                    String adUrl =
                                        await DynamicLink.createDynamicLink(
                                            false,
                                            uri: "/Bikes/Detail/${bike?.bikeId}",
                                            title:
                                                "${bike?.brandName} ${bike?.modelName} ${bike?.modelYear}",
                                            desc: bike?.description,
                                            image: bike?.images.first);
                                    String webUrl =
                                        "https://www.caraqar.co/Bikes/Detail/${bike?.bikeId}";
                                    String url;
                                    var message = Uri.encodeFull(
                                        "Hello,\n${bike?.agentName}\nI would like to get more information about this ad you posted on.\n$adUrl \n or Check this ad on Car aqar \n $webUrl");
                                    if (Platform.isIOS) {
                                      url =
                                          "https://wa.me/${bike?.contactNo}?text=$message";
                                    } else {
                                      url =
                                          "whatsapp://send?phone=${bike?.contactNo}&text=$message";
                                    }
                                    try {
                                      await launchUrl(
                                        Uri.parse(url),
                                      );
                                    } catch (e) {
                                      showSnackBar(
                                          message: "CouldNotLaunchWhatsApp");
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      side: BorderSide(
                                          color: Colors.transparent)),
                                  child: Image.asset(
                                    "assets/images/whatsapp.png",
                                    width: 22.w,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 40.w,
                                child: OutlinedButton(
                                  onPressed: () async {
                                    controller.updateClicks(isEmail: true);

                                    String adUrl = await DynamicLink.createDynamicLink(
                                          false,
                                      uri: "/Bikes/Detail/${bike?.bikeId}",
                                      title: bike?.title,
                                      desc: bike?.description,
                                      image: bike?.images.first,
                                    );

                                    String webUrl = "https://www.caraqar.co/Bikes/Detail/${bike?.bikeId}";
                                    String? subject = bike?.title;

                                    // Properly encode the message to handle spaces and special characters
                                    var message =
                                        "Hello,\n${bike?.agentName}\nI would like to get more information about this ad you posted on.\n$adUrl\nOr check this ad on Car aqar\n$webUrl";
                                    final Email email = Email(
                                      body: message,
                                      subject: subject!,
                                      recipients: [bike!.email!],
                                      isHTML: false,
                                    );

                                    await FlutterEmailSender.send(email);
                                  },
                                  style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      side: const BorderSide(
                                          color: Colors.transparent)),
                                  child: Icon(
                                    MaterialCommunityIcons.email,
                                    color: kAccentColor,
                                    size: 25.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Divider(
                              thickness: 1.h,
                              color: Colors.grey.shade400,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/calender.png",
                                          width: 30.w,
                                          height: 30.w,
                                        ),
                                        Text(
                                          "${bike?.modelYear}",
                                          style: TextStyle(
                                              color: kAccentColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/speedcounter.png",
                                          width: 30.w,
                                          height: 30.w,
                                        ),
                                        Text(
                                          "${bike?.mileage}",
                                          style: TextStyle(
                                              color: kAccentColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Expanded(
                                  //   child: Column(
                                  //     children: [
                                  //       Image.asset("assets/images/automatic.png"
                                  //         , width: 30.w,
                                  //         height: 30.w,
                                  //       ), Text(
                                  //         "${bike?.transmission}",
                                  //         style: TextStyle(
                                  //             color: kAccentColor,fontWeight: FontWeight.bold,
                                  //             fontSize: 12.sp),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/benzin.png",
                                          width: 30.w,
                                          height: 30.w,
                                        ),
                                        Text(
                                          "${bike?.fuelType}".tr,
                                          style: TextStyle(
                                              color: kAccentColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 1.h,
                              color: Colors.grey.shade400,
                            ),
                            kVerticalSpace12,
                          ],
                        ),
                        Text(
                          "CurrentPrice".tr,
                          textAlign: TextAlign.center,
                          style: kTextStyle14.copyWith(color: kAccentColor),
                        ),
                        kVerticalSpace8,
                        Text(
                          "${getPrice(bike!.price!)}",
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          style: kTextStyle18.copyWith(color: kPrimaryColor),
                        ),
                        Padding(
                            padding: kScreenPadding,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Brand".tr,
                                            style: kTextStyle16.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          kVerticalSpace8,
                                          Text(
                                            "${bike.brandName}",
                                            style: kTextStyle16.copyWith(
                                                color: kAccentColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40.h,
                                      child: VerticalDivider(),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Model".tr,
                                            style: kTextStyle16.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          kVerticalSpace8,
                                          Text(
                                            "${bike.modelName}",
                                            style: kTextStyle16.copyWith(
                                                color: kAccentColor),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Year".tr,
                                            style: kTextStyle16.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          kVerticalSpace8,
                                          Text(
                                            "${bike.modelYear}",
                                            style: kTextStyle16.copyWith(
                                                color: kAccentColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40.h,
                                      child: VerticalDivider(),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Type".tr,
                                            style: kTextStyle16.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          kVerticalSpace8,
                                          Text(
                                            "${bike.type}",
                                            style: kTextStyle16.copyWith(
                                                color: kAccentColor),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Condition".tr,
                                            style: kTextStyle16.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          kVerticalSpace8,
                                          Text(
                                            "${bike.condition}".tr,
                                            style: kTextStyle16.copyWith(
                                                color: kAccentColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40.h,
                                      child: VerticalDivider(),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Mileage".tr,
                                            style: kTextStyle16.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          kVerticalSpace8,
                                          Text(
                                            "${bike.mileage} ${"KM".tr}",
                                            style: kTextStyle16.copyWith(
                                                color: kAccentColor),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Seats".tr,
                                            style: kTextStyle16.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          kVerticalSpace8,
                                          Text(
                                            "${bike.seats}",
                                            style: kTextStyle16.copyWith(
                                                color: kAccentColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40.h,
                                      child: VerticalDivider(),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Engine".tr,
                                            style: kTextStyle16.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          kVerticalSpace8,
                                          Text(
                                            "${bike.engine}",
                                            style: kTextStyle16.copyWith(
                                                color: kAccentColor),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Divider(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "City".tr,
                                            style: kTextStyle16.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          kVerticalSpace8,
                                          Text(
                                            "${bike.cityName}",
                                            style: kTextStyle16.copyWith(
                                                color: kAccentColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40.h,
                                      child: VerticalDivider(),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "Color".tr,
                                            style: kTextStyle16.copyWith(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          kVerticalSpace8,
                                          Text(
                                            "${bike.color}".tr,
                                            style: kTextStyle16.copyWith(
                                                color: kAccentColor),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                          padding: kScreenPadding,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                kVerticalSpace12,
                                Text(
                                  "Description".tr,
                                  style: kTextStyle16.copyWith(
                                      color: kAccentColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                kVerticalSpace4,
                                Text(
                                  "${bike.description}",
                                  style: kTextStyle14.copyWith(
                                      color: kAccentColor),
                                ),
                                kVerticalSpace16,
                                if (bike.featureHeads.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 28.w),
                                    child: Text(
                                      "Features/Amenities".tr,
                                      style: kTextStyle16.copyWith(
                                          color: kAccentColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                Column(
                                  children: bike.featureHeads
                                      .map((e) => Container(
                                            margin:
                                                EdgeInsets.only(bottom: 32.h),
                                            child: Stack(
                                              clipBehavior: Clip.none,
                                              alignment: Alignment.topCenter,
                                              children: [
                                                Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 32.w,
                                                            horizontal: 16.w),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          kBorderRadius4,
                                                      border: Border.all(
                                                          color: kBorderColor,
                                                          width: 1.w),
                                                    ),
                                                    child: GridView.builder(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        physics:
                                                            PageScrollPhysics(),
                                                        shrinkWrap: true,
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                          childAspectRatio: 1,
                                                          crossAxisSpacing: 8.w,
                                                          mainAxisSpacing: 8.w,
                                                          crossAxisCount: 4,
                                                        ),
                                                        itemCount:
                                                            e.features.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ImageWidget(
                                                                e
                                                                    .features[
                                                                        index]
                                                                    .image,
                                                                width: 30.w,
                                                                height: 30.w,
                                                              ),
                                                              kVerticalSpace4,
                                                              FittedBox(
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                                child: Text(
                                                                  "${e.features[index].title}${e.features[index].quantity! > 0 ? ": ${e.features[index].quantity}" : e.features[index].featureOption != null ? ": ${e.features[index].featureOption}" : ""}",
                                                                  style: kTextStyle12
                                                                      .copyWith(
                                                                          color:
                                                                              kAccentColor),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        })),
                                                Positioned(
                                                  top: -16.w,
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 6.w,
                                                            horizontal: 12.w),
                                                    decoration: BoxDecoration(
                                                        color: kBgColor,
                                                        borderRadius:
                                                            kBorderRadius4,
                                                        border: Border.all(
                                                            color: kBorderColor,
                                                            width: 1.w)),
                                                    child: Text(
                                                      "${e.title}",
                                                      style:
                                                          kTextStyle16.copyWith(
                                                              color:
                                                                  kAccentColor),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ),
                                GetBuilder<ViewBikeController>(
                                    id: "comments",
                                    builder: (controller) =>

                                        Column(crossAxisAlignment: CrossAxisAlignment
                                            .stretch,
                                          children: [
                                            Text(
                                              "${"Comments".tr} (${controller.comments
                                                  .length})",
                                              style: kTextStyle16.copyWith(
                                                  color: kAccentColor),
                                            ),

                                            kVerticalSpace16,

                                            if (controller.comments.isEmpty) Text(
                                              "NoComments".tr, style: kTextStyle14,
                                              textAlign: TextAlign.center,) else
                                              ListView.separated(

                                                physics: const PageScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                itemBuilder: (context, index) {
                                                  var item = controller
                                                      .comments[index];
                                                  return Row(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      ImageWidget(item.image ??
                                                          "assets/images/profile2.jpg",
                                                        isLocalImage: item.image ==
                                                            null,
                                                        width: 50.r,
                                                        height: 50.r,
                                                        isCircular: true,
                                                      ),
                                                      kHorizontalSpace12,
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .stretch,
                                                          children: [
                                                            Text("${item.name}",
                                                              style: TextStyle(
                                                                  fontSize: 15.sp,
                                                                  color: kAccentColor,
                                                                  fontWeight: FontWeight
                                                                      .w600
                                                              ),),
                                                            Text("${format(
                                                              item.createdAt!,
                                                              locale: gSelectedLocale
                                                                  ?.locale
                                                                  ?.languageCode,
                                                            )}", style: TextStyle(

                                                                color: kGreyColor,
                                                                fontSize: 12.sp
                                                            ),),
                                                            kVerticalSpace8,
                                                            Text("${item.comment}",
                                                              style: TextStyle(
                                                                  fontSize: 14.sp,
                                                                  color: kAccentColor
                                                              ),),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                },
                                                separatorBuilder: (context, index) {
                                                  return const Divider();
                                                },
                                                shrinkWrap: true,
                                                itemCount: controller.comments
                                                    .length,)


                                          ],
                                        )
                                ),
                                kVerticalSpace20,
                                Form(
                                  key: controller.formKey,
                                  autovalidateMode: AutovalidateMode
                                      .onUserInteraction,
                                  child: TextFieldWidget(maxLines: 3,
                                    borderRadius: kBorderRadius4,
                                    hintText: "TypeComment",
                                    text: controller.comment,
                                    onChanged: (val) {
                                      controller.comment = val.toString().trim();
                                    },
                                    onSaved: (val) {
                                      controller.comment = val.toString().trim();
                                    },
                                    validator: (val) {
                                      if (val
                                          .toString()
                                          .isEmpty) {
                                        return kRequiredMsg.tr;
                                      } else {
                                        return null;
                                      }
                                    },

                                  ),
                                ),
                                kVerticalSpace16,
                                ButtonWidget(text: "Comment",
                                    onPressed: controller.saveComment)
                              ]),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : CircularLoader();
      }),
    );
  }
}
