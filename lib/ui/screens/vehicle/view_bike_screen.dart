import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/services/share_link_service.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:careqar/ui/widgets/location_map_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/strings.dart';
import '../../../controllers/favorite_controller.dart';
import '../../../controllers/view_bike_controller.dart';
import '../../../global_variables.dart';
import '../../widgets/button_widget.dart';

class ViewBikeScreen extends GetView<ViewBikeController> {
  ViewBikeScreen({super.key}) {
    //print(Get.arguments);
    controller.sliderIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    controller.formKey = GlobalKey<FormState>();
    return Obx(() {
      var bike = controller.bike.value;
      return Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          iconTheme: const IconThemeData(color: kBlackColor),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  "Details".tr.toUpperCase(),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: kAppBarStyle,
                ),
              ),
              kHorizontalSpace12,
              IconButtonWidget(
                icon: MaterialCommunityIcons.share_variant,
                color: kBlackColor,
                onPressed: () async {
                  final ShareService shareService = Get.find<ShareService>();

                  String url = shareService.generateShareLink(
                    type: 'bike',
                    id: bike!.bikeId.toString(),
                  );

                  String message = "Hey! you might be interested in this.\n$url";
                  Share.share(message);
                },
              ),
            ],
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: controller.status.value == Status.success
            ? SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              children: [
                // Image carousel section
                SizedBox(
                  height: 0.4.sh, // Adjust height as needed
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // 🔹 Rounded image slider
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24.r),
                          child: CarouselSlider(
                            options: CarouselOptions(
                              height: double.infinity,
                              autoPlayCurve: Curves.linearToEaseOut,
                              autoPlay: true,
                              scrollPhysics: const BouncingScrollPhysics(),
                              enableInfiniteScroll: false,
                              viewportFraction: 1,
                              enlargeCenterPage: false,
                              initialPage: controller.sliderIndex.value,
                              onPageChanged: (index, reason) {
                                controller.sliderIndex.value = index;
                                controller.update();
                              },
                            ),
                            items: bike!.images.map((item) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.toNamed(
                                        Routes.staggeredGalleryScreen,
                                        arguments: bike.images,
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: CachedNetworkImage(
                                        imageUrl: item,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                        imageBuilder: (context, imageProvider) {
                                          return Image(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: double.infinity,
                                          );
                                        },
                                        placeholder: (context, url) => Container(
                                          color: Colors.grey[200],
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) => Container(
                                          color: Colors.grey[200],
                                          child: const Center(
                                            child: Icon(
                                              Icons.error,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                        memCacheWidth: 800,
                                        memCacheHeight: 600,
                                        maxWidthDiskCache: 1000,
                                        maxHeightDiskCache: 1000,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ),

                        // 🔹 Page indicator
                        Positioned(
                          top: 12.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              bike.images.length,
                                  (index) => Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: 3.w,
                                ),
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                  controller.sliderIndex.value ==
                                      index
                                      ? Colors.white
                                      : Colors.white54,
                                ),
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 16.h,
                          right: 16.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Favorite button
                              GetBuilder<ViewBikeController>(
                                builder: (controller) => Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      bike.favoriteId! > 0
                                          ? MaterialCommunityIcons.heart
                                          : MaterialCommunityIcons
                                          .heart_outline,
                                      color: bike.favoriteId! > 0
                                          ? kRedColor
                                          : kBlackColor,
                                    ),
                                    onPressed: () async {
                                      var favController = Get.put(
                                        FavoriteController(),
                                      );
                                      if (bike.favoriteId! > 0) {
                                        if (await favController
                                            .deleteFavorite(
                                          bike: bike,
                                        )) {
                                          controller.update();
                                        }
                                      } else {
                                        if (await favController
                                            .addToFavorites(
                                          bike: bike,
                                        )) {
                                          controller.update();
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              // View count badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(
                                    30.r,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      MaterialCommunityIcons.eye_outline,
                                      size: 16.sp,
                                      color: kWhiteColor,
                                    ),
                                    Text(
                                      " ${bike.clicks}",
                                      style: TextStyle(
                                        color: kWhiteColor,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Content section (expandable)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 8.w,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Left: Location on top + Title below
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                // Location row
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.clock,
                                      size: 12.w,
                                      color: kIconColor,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      format(
                                        bike.createdAt!,
                                        locale: gSelectedLocale
                                            ?.locale
                                            ?.languageCode,
                                      ),
                                      textDirection: TextDirection.ltr,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: kBlackLightColor,
                                        height: 1.3,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    FaIcon(
                                      FontAwesomeIcons.locationDot,
                                      size: 12.w,
                                      color: kIconColor,
                                    ),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Text(
                                        "${bike.location}, ${bike.cityName}",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: kBlackLightColor,
                                          height: 1.3,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                // Title
                                Text(
                                  "${bike.brandName} ${bike.modelName} ${bike.modelYear}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: kHeadingStyle,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    // Price on left
                                    Expanded(
                                      child: Text(
                                        bike.price == null ||
                                            bike.price == 0
                                            ? "Call for Price".tr
                                            : getPrice(bike.price!),
                                        style: kTextStyle18.copyWith(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                    ),

                                    // Icons on right
                                    Row(
                                      children: [
                                        _buildCircleIconButton(
                                          icon: FaIcon(
                                            FontAwesomeIcons.phone,
                                            size: 20.w,
                                            color: kIconColor,
                                          ),
                                          onTap: () async {
                                            controller.updateClicks(
                                              isCall: true,
                                            );
                                            await launch(
                                              "tel://${bike.contactNo!}",
                                            );
                                          },
                                        ),
                                        SizedBox(width: 8.w),
                                        _buildCircleIconButton(
                                          image: 'assets/images/whatsapp.png',
                                          onTap: () async {
                                            controller.updateClicks(isWhatsapp: true);

                                            try {
                                              final ShareService shareService = Get.find<ShareService>();

                                              await shareService.shareToWhatsApp(
                                                type: 'bike',
                                                id: bike.bikeId!.toString(),
                                                phoneNumber: bike.contactNo,
                                                agentName: bike.agentName,
                                                title: "${bike.brandName!} ${bike.modelName} ${bike.modelYear}",
                                                description: bike.description,
                                              );
                                            } catch (e) {
                                              showSnackBar(message: "Could not launch WhatsApp");
                                            }
                                          },
                                        ),
                                        SizedBox(width: 8.w),
                                        _buildCircleIconButton(
                                          icon: FaIcon(
                                            FontAwesomeIcons.comment,
                                            size: 20.w,
                                            color: kIconColor,
                                          ),
                                          onTap: () async {
                                            controller.updateClicks(isEmail: true);
                                            try {
                                              final ShareService shareService = Get.find<ShareService>();
                                              await shareService.shareToEmail(
                                                type: 'bike',
                                                id: bike.bikeId.toString(),
                                                email: bike.email!,
                                                agentName: bike.agentName,
                                                title: bike.title!,
                                                description: bike.description,
                                              );
                                            } catch (e) {
                                              showSnackBar(message: "Could not send email");
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // change 2
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 5.h,
                      ),
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildBikeInfoItem(
                              icon: FontAwesomeIcons.calendar,
                              label: bike.modelYear!,
                            ),
                          ),
                          _buildVerticalDivider(),
                          Expanded(
                            child: _buildBikeInfoItem(
                              icon: FontAwesomeIcons.tachometerAlt,
                              label: bike.mileage!,
                            ),
                          ),
                          _buildVerticalDivider(),
                          Expanded(
                            child: _buildBikeInfoItem(
                              icon: FontAwesomeIcons.gasPump,
                              label: bike.fuelType!.tr,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // TAb here
                    Padding(
                      padding: kHorizontalScreenPadding,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.selectedTabIndex.value = 0;
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: controller
                                          .selectedTabIndex.value ==
                                          0
                                          ? Colors.blue
                                          : Colors.transparent,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'INFORMATION',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: controller
                                        .selectedTabIndex.value ==
                                        0
                                        ? Colors.black87
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.selectedTabIndex.value = 1;
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: controller
                                          .selectedTabIndex.value ==
                                          1
                                          ? Colors.blue
                                          : Colors.transparent,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'FEATURES',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: controller
                                        .selectedTabIndex.value ==
                                        1
                                        ? Colors.black87
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                controller.selectedTabIndex.value = 2;
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 12.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: controller
                                          .selectedTabIndex.value ==
                                          2
                                          ? Colors.blue
                                          : Colors.transparent,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'LOCATION',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: controller
                                        .selectedTabIndex.value ==
                                        2
                                        ? Colors.black87
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      switch (controller.selectedTabIndex.value) {
                        case 0:
                          return _buildInformationTab(bike);
                        case 1:
                          return _buildFeaturesTab(bike);
                        case 2:
                          return _buildLocationTab(bike);
                        default:
                          return _buildInformationTab(bike);
                      }
                    }),
                    //SELLER DESCRIPTION
                    Padding(
                      padding: kScreenPadding,
                      child: Column(
                        children: [
                          // Section Title
                          Text(
                            "SELLER DESCRIPTION".tr.toUpperCase(),
                            style: kTextStyle16.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12.w),
                            constraints: BoxConstraints(
                              minHeight: 100.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: Colors.black54,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              bike.description ?? "",
                              style: kTextStyle14.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "SELLER DETAIL".tr.toUpperCase(),
                            style: kTextStyle16.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(height: 6.h),

                        GestureDetector(
                          onTap: () {
                            if (bike.companyId != null) {
                              if (Get.previousRoute ==
                                  "${Routes.companyScreen}?type=Bike&agentAds=${bike.isAgentAd}") {
                                Get.back();
                              } else {
                                Get.offNamed(
                                  Routes.companyScreen,
                                  arguments: bike.companyId,
                                  parameters: {
                                    "type": "Bike",
                                    "agentAds": "${bike.isAgentAd}",
                                  },
                                );
                              }
                            } else if (bike.agentId != null) {
                              if (Get.previousRoute ==
                                  "${Routes.agentScreen}?type=Bike&agentAds=${bike.isAgentAd}") {
                                Get.back();
                              } else {
                                Get.offNamed(
                                  Routes.agentScreen,
                                  arguments: bike.agentId,
                                  parameters: {
                                    "type": "Bike",
                                    "agentAds": "${bike.isAgentAd}",
                                  },
                                );
                              }
                            }
                          },
                          child: Padding(
                            padding: kHorizontalScreenPadding,
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(Routes.sellerProfile);
                              },
                              child: Text(
                                "View Seller Profile".tr,
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // 🔹 Seller Row (Profile + Name)
                        Padding(
                          padding: kHorizontalScreenPadding,
                          child: Row(
                            children: [
                              ImageWidget(
                                bike.agentImage == "" ||
                                    bike.agentImage == null
                                    ? "assets/images/profile2.jpg"
                                    : bike.agentImage,
                                width: 50.r,
                                height: 50.r,
                                isCircular: true,
                                isLocalImage: bike.agentImage == "" ||
                                    bike.agentImage == null,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      bike.agentName!,
                                      style: kTextStyle16.copyWith(
                                        color: kAccentColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 12.h),
                        Padding(
                          padding: kHorizontalScreenPadding,
                          child: Text(
                            "Member Since April 19, 2025",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // 🔹 Phone & Email Icons + Report
                        Padding(
                          padding: kHorizontalScreenPadding,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              // Phone + Email
                              Row(
                                children: [
                                  Icon(
                                    Icons.phone_iphone,
                                    size: 20.sp,
                                    color: Colors.black87,
                                  ),
                                  SizedBox(width: 8.w),
                                  Icon(
                                    Icons.email_outlined,
                                    size: 20.sp,
                                    color: Colors.black87,
                                  ),
                                ],
                              ),

                              // Report Ad
                              Row(
                                children: [
                                  Icon(
                                    Icons.flag_outlined,
                                    size: 18.sp,
                                    color: Colors.black87,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "Report this Ad".tr,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // 🔹 Divider after section
                        Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                          height: 1,
                        ),
                      ],
                    ),

                    SizedBox(height: 8),
                    Padding(
                      padding: kHorizontalScreenPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          kVerticalSpace16,

                          GetBuilder<ViewBikeController>(
                            id: "comments",
                            builder: (controller) => Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                              children: [
                                // 🔹 Comments Title
                                Center(
                                  child: Text(
                                    "${"COMMENTS".tr.toUpperCase()} (${controller.comments.length})",
                                    style: kTextStyle16.copyWith(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                SizedBox(height: 16.h),

                                if (controller.comments.isEmpty)
                                  Text(
                                    "NoComments".tr,
                                    style: kTextStyle14,
                                    textAlign: TextAlign.center,
                                  )
                                else
                                  ListView.separated(
                                    physics: const PageScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      var item =
                                      controller.comments[index];
                                      return Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              // 🔹 Avatar
                                              ImageWidget(
                                                item.image ??
                                                    "assets/images/profile2.jpg",
                                                isLocalImage:
                                                item.image == null,
                                                width: 40.r,
                                                height: 40.r,
                                                isCircular: true,
                                              ),
                                              SizedBox(width: 12.w),

                                              // 🔹 Name, time, and comment
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "${item.name}",
                                                            style:
                                                            TextStyle(
                                                              fontSize:
                                                              15.sp,
                                                              color: Colors
                                                                  .black87,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w400,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          format(
                                                            item.createdAt!,
                                                            locale: gSelectedLocale
                                                                ?.locale
                                                                ?.languageCode,
                                                          ),
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey,
                                                            fontSize:
                                                            12.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 6.h,
                                                    ),
                                                    // Comment text
                                                    Text(
                                                      "${item.comment}",
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: Colors
                                                            .black87,
                                                        fontWeight:
                                                        FontWeight
                                                            .w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                    separatorBuilder: (
                                        context,
                                        index,
                                        ) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 8.h,
                                        ),
                                        child: Divider(
                                          color: Colors.grey.shade300,
                                          height: 1,
                                        ),
                                      );
                                    },
                                    shrinkWrap: true,
                                    itemCount:
                                    controller.comments.length,
                                  ),
                              ],
                            ),
                          ),
                          kVerticalSpace20,
                          Form(
                            key: controller.formKey,
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(
                                      20.r,
                                    ),
                                    border: Border.all(
                                      color: Colors.black54,
                                      width: 1,
                                    ),
                                  ),
                                  padding: EdgeInsets.all(16.w),
                                  child: TextFormField(
                                    maxLines: 3,
                                    initialValue: controller.comment,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: kBlackColor,
                                    ),
                                    decoration: InputDecoration(
                                      hintText:
                                      "Have something to say? Leave a comment!",
                                      hintStyle: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey[500],
                                      ),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      focusedErrorBorder:
                                      InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onChanged: (val) {
                                      controller.comment =
                                          val.toString().trim();
                                    },
                                    onSaved: (val) {
                                      controller.comment =
                                          val.toString().trim();
                                    },
                                    validator: (val) {
                                      if (val.toString().isEmpty) {
                                        return kRequiredMsg.tr;
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                kVerticalSpace16,
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1B3A5C),
                                    borderRadius: BorderRadius.circular(
                                      20.r,
                                    ),
                                  ),
                                  child: ButtonWidget(
                                    text: "COMMENT",
                                    onPressed: controller.saveComment,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
            : CircularLoader(),
      );
    });
  }

  TableRow _buildStyledRow(String title, String value, int index) {
    bool isOddRow = index.isOdd;
    return TableRow(
      decoration: BoxDecoration(
        color: isOddRow ? Colors.grey.shade100 : Colors.white,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: kTextStyle16.fontSize,
              color: kTableColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w300,
              fontSize: kTextStyle16.fontSize,
              color: kTableColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBikeInfoItem({required IconData icon, required String label}) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            icon,
            size: 20.w,
            color: kIconColor,
          ),
          SizedBox(height: 6.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kTableColor,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  /// White vertical divider that extends full height
  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: double.infinity,
      color: Colors.white,
    );
  }

  /// Reusable white circular icon button
  Widget _buildCircleIconButton({
    Widget? icon,
    String? image,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: image != null
              ? Image.asset(
            image,
            width: 24.w,
            height: 24.w,
          )
              : icon,
        ),
      ),
    );
  }

  //tabs
  Widget _buildInformationTab(bike) {
    return Padding(
      padding: kScreenPadding,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade400, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Table(
          border: TableBorder(
            horizontalInside: BorderSide(color: Colors.grey.shade400, width: 1),
            verticalInside: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
          columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1)},
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            _buildStyledRow("Brand", bike.brandName!, 0),
            _buildStyledRow("Model".tr, bike.modelName!, 1),
            _buildStyledRow("Year".tr, bike.modelYear!, 2),
            _buildStyledRow("Type".tr, bike.type!, 3),
            _buildStyledRow("Condition".tr, bike.condition!, 4),
            _buildStyledRow("Mileage".tr, "${bike.mileage} ${"KM".tr}", 5),
            _buildStyledRow("Seats".tr, "${bike.seats}", 6),
            _buildStyledRow("Engine".tr, bike.engine!, 7),
            _buildStyledRow("City".tr, bike.cityName!, 8),
            _buildStyledRow("Color".tr, bike.color!, 9),
            _buildStyledRow("Ad ID".tr, bike.bikeId.toString(), 10),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesTab(bike) {
    return Padding(
      padding: kScreenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Create a single table with all features
          ...bike.featureHeads.map<Widget>((e) => Container(
            margin: EdgeInsets.only(bottom: 32.h),
            child: Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
                side: BorderSide(
                  color: Colors.grey.shade400,
                  width: 1,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Table(
                border: TableBorder(
                  horizontalInside: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                  verticalInside: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(3),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: List.generate(e.features.length, (index) {
                  bool isOddRow = index % 2 == 1;
                  Color rowColor =
                  isOddRow ? Colors.grey.shade100 : Colors.white;

                  return TableRow(
                    decoration: BoxDecoration(color: rowColor),
                    children: [
                      // Icon cell
                      Container(
                        child: Center(
                          child: ImageWidget(
                            e.features[index].image,
                            width: 30.w,
                            height: 30.w,
                          ),
                        ),
                      ),

                      // Text cell
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "${e.features[index].title}",
                              //"${(e.features[index].quantity != null && e.features[index].quantity! > 0) ? ": ${e.features[index].quantity}" : (e.features[index].featureOption != null && e.features[index].featureOption.toString().isNotEmpty) ? ": ${e.features[index].featureOption}" : ""}",
                          style: kLightTextStyle14.copyWith(
                            color: kTableColor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildLocationTab(bike) {
    return Padding(
      padding: kHorizontalScreenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add your location content here
          Text('Location content goes here'),
          LocationMapWidget(
            cityName: bike.location, // This gets the city from your car object
            height: 250,
          ),
        ],
      ),
    );
  }
}
