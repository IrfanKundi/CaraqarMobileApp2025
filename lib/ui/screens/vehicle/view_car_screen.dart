import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/view_car_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/services/dynamic_link.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:careqar/ui/widgets/location_map_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../../global_variables.dart';
import '../../../locale/slider_indicator.dart';
import '../../widgets/button_widget.dart';

class ViewCarScreen extends GetView<ViewCarController> {
  ViewCarScreen({super.key}) {
    //print(Get.arguments);

    controller.sliderIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    controller.formKey = GlobalKey<FormState>();
    return Obx(() {
      var car = controller.car.value;
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
                    uri: "/car?CarsId=${car!.carId}",
                    title: "${car.brandName} ${car.modelName} ${car.modelYear}",
                    desc: car.description,
                    image: car.images.first,
                  );
                  String message =
                      "Hey! you might be interested in this.\n$adUrl";
                  Share.share(message);
                },
              ),
            ],
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body:
            controller.status.value == Status.success
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
                                  child: Stack(
                                    children: [
                                      // Your existing CarouselSlider code (unchanged)
                                      CarouselSlider(
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
                                        items: car!.images.map((item) {
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return GestureDetector(
                                                onTap: () {
                                                  Get.toNamed(
                                                    Routes.staggeredGalleryScreen,
                                                    arguments: car.images,
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

                                      // Add the indicator at the top
                                      Positioned(
                                        top: 16,
                                        left: 0,
                                        right: 0,
                                        child: Center(
                                          child: Obx(() => WorkingSlidingIndicator(
                                            itemCount: car!.images.length,
                                            currentIndex: controller.sliderIndex.value,
                                          )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // 🔹 Page indicator
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(24.r),
                                  child: Stack(
                                    children: [
                                      // Carousel
                                      CarouselSlider(
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
                                        items: car!.images.map((item) {
                                          return GestureDetector(
                                            onTap: () {
                                              Get.toNamed(
                                                Routes.staggeredGalleryScreen,
                                                arguments: car.images,
                                              );
                                            },
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
                                                child: const Center(child: CircularProgressIndicator()),
                                              ),
                                              errorWidget: (context, url, error) => Container(
                                                color: Colors.grey[200],
                                                child: const Center(
                                                  child: Icon(Icons.error, size: 50),
                                                ),
                                              ),
                                              memCacheWidth: 800,
                                              memCacheHeight: 600,
                                              maxWidthDiskCache: 1000,
                                              maxHeightDiskCache: 1000,
                                            ),
                                          );
                                        }).toList(),
                                      ),

                                      // FIXED Moving dots indicator
                                      Positioned(
                                        top: 12.h,
                                        left: 0,
                                        right: 0,
                                        child: Center(
                                          child: Obx(() {
                                            const int maxVisibleDots = 4;
                                            final int totalImages = car!.images.length;
                                            final int currentIndex = controller.sliderIndex.value;

                                            // If we have 4 or fewer images, just show them all
                                            if (totalImages <= maxVisibleDots) {
                                              return Container(
                                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.3),
                                                  borderRadius: BorderRadius.circular(20.r),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: List.generate(totalImages, (i) {
                                                    final bool isActive = i == currentIndex;
                                                    return AnimatedContainer(
                                                      duration: const Duration(milliseconds: 250),
                                                      curve: Curves.easeOut,
                                                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                                                      width: isActive ? 10.w : 8.w,
                                                      height: isActive ? 10.w : 8.w,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: isActive ? Colors.white : Colors.white54,
                                                      ),
                                                    );
                                                  }),
                                                ),
                                              );
                                            }

                                            // CORRECT sliding window logic
                                            int startIndex;
                                            if (currentIndex < 2) {
                                              // First 2 positions: [0,1,2,3]
                                              startIndex = 0;
                                            } else if (currentIndex >= totalImages - 2) {
                                              // Last 2 positions: show last 4
                                              startIndex = totalImages - maxVisibleDots;
                                            } else {
                                              // Middle positions: slide the window
                                              // Put current index at position 2 (3rd dot)
                                              startIndex = currentIndex - 2;
                                            }

                                            // Debug print to see what's happening
                                            print("Index: $currentIndex, StartIndex: $startIndex, Window: [${startIndex}, ${startIndex+1}, ${startIndex+2}, ${startIndex+3}]");

                                            // Build the visible dots with sliding animation
                                            return Container(
                                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.3),
                                                borderRadius: BorderRadius.circular(20.r),
                                              ),
                                              child: AnimatedSwitcher(
                                                duration: const Duration(milliseconds: 300),
                                                transitionBuilder: (child, animation) {
                                                  return SlideTransition(
                                                    position: Tween<Offset>(
                                                      begin: const Offset(0.3, 0), // Slide from right
                                                      end: Offset.zero,
                                                    ).animate(CurvedAnimation(
                                                      parent: animation,
                                                      curve: Curves.easeOutCubic,
                                                    )),
                                                    child: FadeTransition(
                                                      opacity: animation,
                                                      child: child,
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  key: ValueKey(startIndex), // Important: key changes trigger animation
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: List.generate(maxVisibleDots, (i) {
                                                    final int dotIndex = startIndex + i;
                                                    final bool isActive = dotIndex == currentIndex;

                                                    return TweenAnimationBuilder<double>(
                                                      duration: Duration(milliseconds: 200 + (i * 50)), // Staggered animation
                                                      tween: Tween(begin: 0.0, end: 1.0),
                                                      builder: (context, value, child) {
                                                        return Transform.scale(
                                                          scale: value,
                                                          child: AnimatedContainer(
                                                            duration: const Duration(milliseconds: 250),
                                                            curve: Curves.easeOut,
                                                            margin: EdgeInsets.symmetric(horizontal: 3.w),
                                                            width: isActive ? 10.w : 8.w,
                                                            height: isActive ? 10.w : 8.w,
                                                            decoration: BoxDecoration(
                                                              shape: BoxShape.circle,
                                                              color: isActive ? Colors.white : Colors.white54,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    );
                                                  }),
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Positioned(
                                  bottom: 16.h,
                                  right: 16.w,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      // Favorite button
                                      GetBuilder<ViewCarController>(
                                        builder:
                                            (controller) => Container(
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
                                                  car.favoriteId! > 0
                                                      ? MaterialCommunityIcons
                                                          .heart
                                                      : MaterialCommunityIcons
                                                          .heart_outline,
                                                  color:
                                                      car.favoriteId! > 0
                                                          ? kRedColor
                                                          : kBlackColor,
                                                ),
                                                onPressed: () async {
                                                  var favController = Get.put(
                                                    FavoriteController(),
                                                  );
                                                  if (car.favoriteId! > 0) {
                                                    if (await favController
                                                        .deleteFavorite(
                                                          car: car,
                                                        )) {
                                                      controller.update();
                                                    }
                                                  } else {
                                                    if (await favController
                                                        .addToFavorites(
                                                          car: car,
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
                                              MaterialCommunityIcons
                                                  .eye_outline,
                                              size: 16.sp,
                                              color: kWhiteColor,
                                            ),
                                            Text(
                                              " ${car.clicks}",
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
                                                car.createdAt!,
                                                locale:
                                                    gSelectedLocale
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
                                                "${car.location}, ${car.cityName}",
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
                                          "${car.brandName} ${car.modelName} ${car.modelYear}",
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
                                                car.price == null ||
                                                        car.price == 0
                                                    ? "Call for Price".tr
                                                    : getPrice(car.price!),
                                                style: kTextStyle18.copyWith(
                                                  color: kPrimaryColor,
                                                  // Green like screenshot
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
                                                      "tel://${car.contactNo!}",
                                                    );
                                                  },
                                                ),

                                                SizedBox(width: 8.w),
                                                _buildCircleIconButton(
                                                  image: 'assets/images/whatsapp.png',
                                                  onTap: () async {
                                                    controller.updateClicks(
                                                      isWhatsapp: true,
                                                    );
                                                    String adUrl = await DynamicLink.createDynamicLink(
                                                      false,
                                                      uri: "/Cars/Detail/${car.carId!}",
                                                      title: "${car.brandName!} ${car.modelName} ${car.modelYear}",
                                                      desc: car.description,
                                                      image: car.images.first,
                                                    );
                                                    String message = Uri.encodeFull(
                                                      "Hello,\n${car.agentName}\nI would like to get more information about this ad you posted on.\n$adUrl",
                                                    );
                                                    String url = Platform.isIOS
                                                        ? "https://wa.me/${car.contactNo}?text=$message"
                                                        : "whatsapp://send?phone=${car.contactNo}&text=$message";
                                                    await launchUrl(
                                                      Uri.parse(url),
                                                    );
                                                  },
                                                ),
                                                // SizedBox(width: 8.w),
                                                // _buildCircleIconButton(
                                                //   icon: FaIcon(
                                                //     FontAwesomeIcons.comment,
                                                //     size: 20.w,
                                                //     color: kIconColor,
                                                //   ),
                                                //   onTap: () {
                                                //     // Add your SMS or chat logic
                                                //   },
                                                // ),
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
                              // Add left and right margin
                              height: 50.h,
                              // Set a fixed height for the container
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(
                                  20.r,
                                ), // rounded ends like screenshot
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildCarInfoItem(
                                      icon: FontAwesomeIcons.calendar,
                                      label: car.modelYear!,
                                    ),
                                  ),
                                  _buildVerticalDivider(),
                                  Expanded(
                                    child: _buildCarInfoItem(
                                      icon: FontAwesomeIcons.gauge,
                                      label: car.mileage!,
                                    ),
                                  ),
                                  _buildVerticalDivider(),
                                  Expanded(
                                    child: _buildCarInfoItem(
                                      icon: FontAwesomeIcons.gear,
                                      label:
                                      car.transmission!
                                          .replaceAll("Automatic", "Auto")
                                          .tr,
                                    ),
                                  ),
                                  _buildVerticalDivider(),
                                  Expanded(
                                    child: _buildCarInfoItem(
                                      icon: FontAwesomeIcons.gasPump,
                                      label: car.fuelType!.tr,
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
                                              color:
                                                  controller
                                                              .selectedTabIndex
                                                              .value ==
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
                                            color:
                                                controller
                                                            .selectedTabIndex
                                                            .value ==
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
                                              color:
                                                  controller
                                                              .selectedTabIndex
                                                              .value ==
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
                                            color:
                                                controller
                                                            .selectedTabIndex
                                                            .value ==
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
                                              color:
                                                  controller
                                                              .selectedTabIndex
                                                              .value ==
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
                                            color:
                                                controller
                                                            .selectedTabIndex
                                                            .value ==
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
                                  return _buildInformationTab(car);
                                case 1:
                                  return _buildFeaturesTab(car);
                                case 2:
                                  return _buildLocationTab(car);
                                default:
                                  return _buildInformationTab(car);
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
                                      minHeight:
                                          100.h, // 🔹 Minimum height so it matches screenshot style
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      // Light gray background
                                      borderRadius: BorderRadius.circular(16.r),
                                      // Rounded corners
                                      border: Border.all(
                                        color:
                                            Colors.black54, // Thin gray border
                                        width: 0.5, // Border width
                                      ),
                                    ),
                                    child: Text(
                                      car.description ?? "",
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
                                    if (car.companyId != null) {
                                      if (Get.previousRoute ==
                                          "${Routes.companyScreen}?type=Car&agentAds=${car.isAgentAd}") {
                                        Get.back();
                                      } else {
                                        Get.offNamed(
                                          Routes.companyScreen,
                                          arguments: car.companyId,
                                          parameters: {
                                            "type": "Car",
                                            "agentAds": "${car.userId}",
                                          },
                                        );
                                      }
                                    } else if (car.agentId != null) {
                                      if (Get.previousRoute ==
                                          "${Routes.agentScreen}?type=Car&agentAds=${car.isAgentAd}") {
                                        Get.back();
                                      } else {
                                        Get.offNamed(
                                          Routes.agentScreen,
                                          arguments: car.agentId,
                                          parameters: {
                                            "type": "Car",
                                            "agentAds": "${car.isAgentAd}",
                                          },
                                        );
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: kHorizontalScreenPadding,
                                    child: InkWell(
                                      onTap: () {
                                        // 🔍 Debug what we're getting
                                        debugPrint('SAHAr 🔍 car.userId: ${car.userId}');
                                        debugPrint('SAHAr 🔍 car.contactNo: ${car.contactNo}');
                                        debugPrint('SAHAr 🔍 car.agentName: ${car.agentName}');
                                        debugPrint('SAHAr 🔍 car.userId == 0: ${car.userId == 0}');
                                        debugPrint('SAHAr 🔍 car.userId == null: ${car.userId == null}');

                                        if (car.userId == null || car.userId == 0) {
                                          debugPrint('SAHAr 🎭 Going to fake profile route');
                                          // Pass additional data for fake profile
                                          Get.toNamed(Routes.sellerProfile, arguments: {
                                            'userId': car.userId ?? 0,
                                            'contactNo': car.contactNo,
                                            'agentName': car.agentName,
                                          });
                                        } else {
                                          debugPrint('SAHAr 🌐 Going to real profile route');
                                          // Normal user profile
                                          Get.toNamed(Routes.sellerProfile, arguments: {
                                            'userId': car.userId,
                                          });
                                        }
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
                                        car.agentImage == "" ||
                                                car.agentImage == null
                                            ? "assets/images/profile2.jpg"
                                            : car.agentImage,
                                        width: 50.r,
                                        // smaller avatar
                                        height: 50.r,
                                        isCircular: true,
                                        isLocalImage:
                                            car.agentImage == "" ||
                                            car.agentImage == null,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              car.agentName!,
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
                                    // replace with your join date logic
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

                                  GetBuilder<ViewCarController>(
                                    id: "comments",
                                    builder:
                                        (controller) => Column(
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
                                                physics:
                                                    const PageScrollPhysics(),
                                                padding: EdgeInsets.zero,
                                                itemBuilder: (context, index) {
                                                  var item =
                                                      controller
                                                          .comments[index];
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // 🔹 Avatar
                                                          ImageWidget(
                                                            item.image ??
                                                                "assets/images/profile2.jpg",
                                                            isLocalImage:
                                                                item.image ==
                                                                null,
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
                                                                        style: TextStyle(
                                                                          fontSize:
                                                                              15.sp,
                                                                          color:
                                                                              Colors.black87,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      format(
                                                                        item.createdAt!,
                                                                        locale:
                                                                            gSelectedLocale?.locale?.languageCode,
                                                                      ),
                                                                      style: TextStyle(
                                                                        color:
                                                                            Colors.grey,
                                                                        // match screenshot
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
                                                                    fontSize:
                                                                        14.sp,
                                                                    color:
                                                                        Colors
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: 8.h,
                                                        ),
                                                    child: Divider(
                                                      color:
                                                          Colors.grey.shade300,
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
                                            // Dark blue color
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
        color:
            isOddRow
                ? Colors.grey.shade100
                : Colors.white, // Alternate background
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, // Light weight
              fontSize: kTextStyle16.fontSize, // Keep your original size
              color: kTableColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w300, // Light weight
              fontSize: kTextStyle16.fontSize, // Keep your original size
              color: kTableColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarInfoItem({required IconData icon, required String label}) {
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
      height: double.infinity, // Full height
      color: Colors.white, // white border between items
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
  Widget _buildInformationTab(car) {
    return //tables
    Padding(
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
            _buildStyledRow("Brand", car.brandName!, 0),
            _buildStyledRow("Model".tr, car.modelName!, 1),
            _buildStyledRow("Model Variant".tr, car.variantName!, 1),
            _buildStyledRow("Model Year".tr, car.modelYear!, 2),
            _buildStyledRow(
              "Registered Year".tr,
              car.registrationYear?.isNotEmpty == true
                  ? car.registrationYear!
                  : "Not Available",
              3,
            ),
            _buildStyledRow(
              "Registered In".tr,
              car.registrationProvince?.isNotEmpty == true ? car.registrationProvince! : "Not Available",
              4,
            ),
            _buildStyledRow(
              "Assembly".tr,
              car.importedLocal?.isNotEmpty == true
                  ? car.importedLocal!
                  : "Not Available",
              5,
            ),
            _buildStyledRow("Type".tr, car.type!, 6),
            _buildStyledRow("Condition".tr, car.condition!, 7),
            _buildStyledRow("Mileage".tr, "${car.mileage} ${"KM".tr}", 8),
            _buildStyledRow("Seats".tr, "${car.seats}", 9),
            _buildStyledRow("Engine".tr, car.engine!, 10),
            _buildStyledRow("Color".tr, car.color!, 12),
            _buildStyledRow("Ad ID".tr, car.carId.toString(), 12),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesTab(car) {
    return Padding(
      padding: kScreenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Create a single table with all features
          ...car.featureHeads.map<Widget>((e) => Container(
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
                        padding: const EdgeInsets.all(10), // added padding of 10
                        child: Text(
                          "${e.features[index].title}",
                              // "${(e.features[index].quantity != null && e.features[index].quantity! > 0)
                              // ? ": ${e.features[index].quantity}"
                              // : (e.features[index].featureOption != null && e.features[index].featureOption.toString().isNotEmpty)
                              // ? ": ${e.features[index].featureOption}"
                              // : ""}",
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

  Widget _buildLocationTab(car) {
    return Padding(
      padding: kHorizontalScreenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add your location content here
          Text('Location content goes here'),
          LocationMapWidget(
            cityName: car.location, // This gets the city from your car object
            height: 250,
          ),
        ],
      ),
    );
  }
}
