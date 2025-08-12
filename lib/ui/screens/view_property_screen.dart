import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/favorite_controller.dart';
import 'package:careqar/controllers/view_property_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/services/dynamic_link.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global_variables.dart';

class ViewPropertyScreen extends GetView<ViewPropertyController> {
  ViewPropertyScreen({super.key}) {
    controller.sliderIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    controller.formKey = GlobalKey<FormState>();
    return Obx(() {
      var property = controller.property.value;
      double? pLatitude;
      double? pLongitude;
      if (property?.coordinates != null &&
          property!.coordinates.contains(',')) {
        List<String> coordinates = property.coordinates.split(',');
        pLatitude = double.tryParse(coordinates[0].trim())!;
        pLongitude = double.tryParse(coordinates[1].trim())!;
      }

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
                  String adUrl = await DynamicLink.createDynamicLink(
                    false,
                    uri: "/Properties/Detail/${property!.propertyId}",
                    title: property.title,
                    desc: property.description,
                    image: property.images.first,
                  );
                  //String webUrl = "$kFileBaseUrl/Properties/Detail/${property.propertyId}";
                  var message = "Hey! you might be interested in this.\n$adUrl";
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
                  height: 0.4.sh,
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
                            items: property!.images.map((item) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return GestureDetector(
                                    onTap: () {
                                      Get.toNamed(
                                        Routes.staggeredGalleryScreen,
                                        arguments: property.images,
                                      );
                                    },
                                    child: SizedBox(
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
                              property.images.length,
                                  (index) => Container(
                                margin: EdgeInsets.symmetric(horizontal: 3.w),
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: controller.sliderIndex.value == index
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
                              // For Sale/Rent badge
                              Container(
                                margin: EdgeInsets.only(bottom: 10.h),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: property.purpose == "Sell"
                                      ? kAccentColor
                                      : kLightBlueColor,
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                child: Text(
                                  "For${property.purpose}".tr.toUpperCase(),
                                  style: TextStyle(
                                    color: kWhiteColor,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ),
                              // Favorite button
                              GetBuilder<ViewPropertyController>(
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
                                      property.favoriteId! > 0
                                          ? MaterialCommunityIcons.heart
                                          : MaterialCommunityIcons.heart_outline,
                                      color: property.favoriteId! > 0
                                          ? kRedColor
                                          : kBlackColor,
                                    ),
                                    onPressed: () async {
                                      if (property.favoriteId! > 0) {
                                        if (await Get.put(FavoriteController())
                                            .deleteFavorite(property: property)) {
                                          controller.update();
                                        }
                                      } else {
                                        if (await Get.put(FavoriteController())
                                            .addToFavorites(property: property)) {
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
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      MaterialCommunityIcons.eye_outline,
                                      size: 16.sp,
                                      color: kWhiteColor,
                                    ),
                                    Text(
                                      " ${property.clicks}",
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        property.createdAt!,
                                        locale: gSelectedLocale?.locale?.languageCode,
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
                                        "${property.location}, ${property.cityName}",
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
                                  property.title!.capitalize!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: kHeadingStyle,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Price on left
                                    Expanded(
                                      child: Text(
                                        property.price == null || property.price == 0
                                            ? "Call for Price".tr
                                            : getPrice(property.price!),
                                        style: kTextStyle18.copyWith(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.sp,
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
                                            controller.updateClicks(isCall: true);
                                            await launch("tel://${property.contactNo}");
                                          },
                                        ),
                                        SizedBox(width: 8.w),
                                        _buildCircleIconButton(
                                            image: 'assets/images/whatsapp.png',
                                          onTap: () async {
                                            controller.updateClicks(isWhatsapp: true);

                                            String adUrl = await DynamicLink.createDynamicLink(
                                              false,
                                              uri: "/Properties/Detail/${property.propertyId}",
                                              title: property.title,
                                              desc: property.description,
                                              image: property.images.first,
                                            );

                                            //String webUrl = "$kFileBaseUrl/Properties/Detail/${property.propertyId}";
                                            String url;
                                            var message = Uri.encodeFull(
                                                "Hello,\n${property.agentName}\nI would like to get more information about this ad you posted on.\n$adUrl");
                                            if (Platform.isIOS) {
                                              url = "https://wa.me/${property.contactNo}?text=$message";
                                            } else {
                                              url = "whatsapp://send?phone=${property.contactNo}&text=$message";
                                            }
                                            try {
                                              await launchUrl(Uri.parse(url));
                                            } catch (e) {
                                              showSnackBar(message: "CouldNotLaunchWhatsApp");
                                            }
                                          },
                                        ),
                                        if (property.email != null && property.email != "no email")
                                          SizedBox(width: 8.w),
                                        if (property.email != null && property.email != "no email")
                                          _buildCircleIconButton(
                                            icon: FaIcon(
                                              FontAwesomeIcons.comment,
                                              size: 12.w,
                                              color: kIconColor,
                                            ),
                                            onTap: () async {
                                              controller.updateClicks(isEmail: true);

                                              String adUrl = await DynamicLink.createDynamicLink(
                                                false,
                                                uri: "/Properties/Detail/${property.propertyId}",
                                                title: property.title,
                                                desc: property.description,
                                                image: property.images.first,
                                              );

                                              //String webUrl = "$kFileBaseUrl/Properties/Detail/${property.propertyId}";
                                              String subject = property.title!;

                                              var message = "Hello,\n${property.agentName}\n"
                                                  "I would like to get more information about this ad you posted on.\n"
                                                  "$adUrl";

                                              final Email email = Email(
                                                body: message,
                                                subject: subject,
                                                recipients: [property.email!],
                                                isHTML: false,
                                              );

                                              await FlutterEmailSender.send(email);
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
                    // Property info section
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                        child: Wrap(
                          spacing: 12.w,
                          runSpacing: 12.h,
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            if (property.floors! > 0 && property.floors != null)
                              _buildPropertyInfoItem(
                                icon: FontAwesomeIcons.building,
                                label: "${property.floors} ${"Floors".tr}",
                              ),
                            if (property.bedrooms! > 0 && property.bedrooms != null)
                              _buildPropertyInfoItem(
                                icon: FontAwesomeIcons.bed,
                                label: "${property.bedrooms} ${"Beds".tr}",
                              ),
                            if (property.baths! > 0 && property.baths != null)
                              _buildPropertyInfoItem(
                                icon: FontAwesomeIcons.shower,
                                label: "${property.baths} ${"Baths".tr}",
                              ),
                            if (property.kitchens! > 0 && property.kitchens != null)
                              _buildPropertyInfoItem(
                                icon: FontAwesomeIcons.kitchenSet,
                                label: "${property.kitchens} ${"Kitchens".tr}",
                              ),
                            if (property.furnished != "" && property.furnished != null)
                              _buildPropertyInfoItem(
                                icon: FontAwesomeIcons.couch,
                                label: "${property.furnished!.tr} ${"Furnished".tr}",
                              ),
                          ],
                        ),
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
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: controller.selectedTabIndex.value == 0
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
                                    color: controller.selectedTabIndex.value == 0
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
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: controller.selectedTabIndex.value == 1
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
                                    color: controller.selectedTabIndex.value == 1
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
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: controller.selectedTabIndex.value == 2
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
                                    color: controller.selectedTabIndex.value == 2
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
                          return _buildInformationTab(property);
                        case 1:
                          return _buildFeaturesTab(property);
                        case 2:
                          return _buildLocationTab(property, pLatitude, pLongitude);
                        default:
                          return _buildInformationTab(property);
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
                            constraints: BoxConstraints(minHeight: 100.h),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: Colors.black54,
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              property.description ?? "",
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
                            if (property.companyId != null) {
                              if (Get.previousRoute == "${Routes.companyScreen}?type=Real State&agentAds=${property.isAgentAd}") {
                                Get.back();
                              } else {
                                Get.offNamed(
                                  Routes.companyScreen,
                                  arguments: property.companyId,
                                  parameters: {
                                    "type": "Real State",
                                    "agentAds": "${property.isAgentAd}",
                                  },
                                );
                              }
                            } else if (property.agentId != null) {
                              if (Get.previousRoute == "${Routes.agentScreen}?type=Real State&agentAds=${property.isAgentAd}") {
                                Get.back();
                              } else {
                                Get.offNamed(
                                  Routes.agentScreen,
                                  arguments: property.agentId,
                                  parameters: {
                                    "type": "Real State",
                                    "agentAds": "${property.isAgentAd}",
                                  },
                                );
                              }
                            }
                          },
                          child: Padding(
                            padding: kHorizontalScreenPadding,
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

                        SizedBox(height: 12.h),

                        // 🔹 Seller Row (Profile + Name)
                        Padding(
                          padding: kHorizontalScreenPadding,
                          child: Row(
                            children: [
                              ImageWidget(
                                property.agentImage == "" || property.agentImage == null
                                    ? "assets/images/profile2.jpg"
                                    : property.agentImage,
                                width: 50.r,
                                height: 50.r,
                                isCircular: true,
                                isLocalImage: property.agentImage == "" || property.agentImage == null,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      property.agentName!,
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  if (property.email != null && property.email != "no email")
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

                          GetBuilder<ViewPropertyController>(
                            id: "comments",
                            builder: (controller) => Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                      var item = controller.comments[index];
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // 🔹 Avatar
                                              ImageWidget(
                                                item.image ?? "assets/images/profile2.jpg",
                                                isLocalImage: item.image == null,
                                                width: 40.r,
                                                height: 40.r,
                                                isCircular: true,
                                              ),
                                              SizedBox(width: 12.w),

                                              // 🔹 Name, time, and comment
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            "${item.name}",
                                                            style: TextStyle(
                                                              fontSize: 15.sp,
                                                              color: Colors.black87,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          format(
                                                            item.createdAt!,
                                                            locale: gSelectedLocale?.locale?.languageCode,
                                                          ),
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12.sp,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 6.h),
                                                    // Comment text
                                                    Text(
                                                      "${item.comment}",
                                                      style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.w400,
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
                                    separatorBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8.h),
                                        child: Divider(
                                          color: Colors.grey.shade300,
                                          height: 1,
                                        ),
                                      );
                                    },
                                    shrinkWrap: true,
                                    itemCount: controller.comments.length,
                                  ),
                              ],
                            ),
                          ),
                          kVerticalSpace20,
                          Form(
                            key: controller.formKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(20.r),
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
                                      hintText: "Have something to say? Leave a comment!",
                                      hintStyle: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey[500],
                                      ),
                                      border: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    onChanged: (val) {
                                      controller.comment = val.toString().trim();
                                    },
                                    onSaved: (val) {
                                      controller.comment = val.toString().trim();
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
                                    borderRadius: BorderRadius.circular(20.r),
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

  Widget _buildPropertyInfoItem({required IconData icon, required String label}) {
    return SizedBox(
      child: Column(
        children: [
          FaIcon(
            icon,
            size: 25.w,
            color: kLightBlueColor,
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kAccentColor,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
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
  Widget _buildInformationTab(property) {
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
            _buildStyledRow("Purpose", "For${property.purpose}", 1),
            _buildStyledRow("Type".tr, property.type!, 2),
            _buildStyledRow("Location".tr, "${property.location}, ${property.cityName}", 3),
            _buildStyledRow("Area".tr, "${property.area} ${"Marla".tr}", 4),
            if (property.floors! > 0) _buildStyledRow("Floors".tr, "${property.floors}", 5),
            if (property.bedrooms! > 0) _buildStyledRow("Bedrooms".tr, "${property.bedrooms}", 6),
            if (property.baths! > 0) _buildStyledRow("Bathrooms".tr, "${property.baths}", 7),
            if (property.kitchens! > 0) _buildStyledRow("Kitchens".tr, "${property.kitchens}", 8),
            if (property.furnished != "" && property.furnished != null)
              _buildStyledRow("Furnished".tr, "${property.furnished!}", 9),
            _buildStyledRow("Ad ID".tr, property.propertyId.toString(), 10),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesTab(property) {
    return Padding(
      padding: kScreenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Create a single table with all features
          ...property.featureHeads.map<Widget>((e) => Container(
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
                  Color rowColor = isOddRow ? Colors.grey.shade100 : Colors.white;

                  return TableRow(
                    decoration: BoxDecoration(color: rowColor),
                    children: [
                      // Icon cell
                      Center(
                        child: ImageWidget(
                          e.features[index].image,
                          width: 30.w,
                          height: 30.w,
                        ),
                      ),

                      // Text cell
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "${e.features[index].title}"
                              "${(e.features[index].quantity != null && e.features[index].quantity! > 0) ? ": ${e.features[index].quantity}" : (e.features[index].featureOption != null && e.features[index].featureOption.toString().isNotEmpty) ? ": ${e.features[index].featureOption}" : ""}",
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

  Widget _buildLocationTab(property, double? pLatitude, double? pLongitude) {
    return Padding(
      padding: kScreenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                MaterialCommunityIcons.map_marker_outline,
                color: kLightBlueColor,
                size: 22.sp,
              ),
              kHorizontalSpace8,
              Expanded(
                child: Text(
                  "${property.location}, ${property.cityName}".tr,
                  style: kTextStyle16.copyWith(color: kAccentColor),
                ),
              ),
            ],
          ),
          kVerticalSpace8,
          pLatitude != null && pLongitude != null
              ? InkWell(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 2,
              child: Container(
                width: Get.width,
                height: 180.0,
                padding: EdgeInsets.all(5.0),
                child: GoogleMap(
                  zoomGesturesEnabled: false,
                  zoomControlsEnabled: false,
                  tiltGesturesEnabled: false,
                  scrollGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(pLatitude, pLongitude),
                    zoom: 14,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId("view_pId"),
                      position: LatLng(pLatitude, pLongitude),
                      icon: BitmapDescriptor.defaultMarker,
                    ),
                  },
                ),
              ),
            ),
            onTap: () async {
              var uri = Uri.parse(
                  "https://www.google.com/maps/search/?api=1&query=${property.coordinates}");
              if (await canLaunchUrl(uri)) {
                try {
                  await launchUrl(uri);
                } catch (e) {
                  if (kDebugMode) {
                    print('Failed to launch Google Maps: $e');
                  }
                }
              } else {
                if (kDebugMode) {
                  print('Could not launch ${uri.toString()}');
                }
              }
            },
          )
              : SizedBox(),
        ],
      ),
    );
  }
}
// Widget _buildDivider() {
//   return Container(
//     width: 1,
//     height: 40.h,
//     color: Colors.white,
//     margin: EdgeInsets.symmetric(horizontal: 8.w),
//   );
// }
String encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(
      e.value)}')
      .join('&');
}

