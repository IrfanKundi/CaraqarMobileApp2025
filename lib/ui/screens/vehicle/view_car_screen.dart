import 'dart:io';

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/view_car_controller.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/city_controller.dart' show CityController;
import '../../../controllers/favorite_controller.dart';
import '../../../controllers/location_controller.dart';
import '../../../global_variables.dart';

class ViewCarScreen extends GetView<ViewCarController> {
  ViewCarScreen({Key? key}) : super(key: key) {
    //print(Get.arguments);

    controller.sliderIndex(0);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Obx(() {
        var car = controller.car.value;
        return controller.status.value == Status.success
            ? NestedScrollView(
              headerSliverBuilder: (
                BuildContext context,
                bool innerBoxIsScrolled,
              ) {
                return <Widget>[
                  SliverAppBar(
                    backgroundColor: kWhiteColor,
                    iconTheme: const IconThemeData(color: kBlackColor),
                    expandedHeight: 0.6.sh,
                    pinned: true,
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
                              uri: "/car?CarsId=${car?.carId}",
                              title:
                                  "${car?.brandName} ${car?.modelName} ${car?.modelYear}",
                              desc: car?.description,
                              image: car?.images.first,
                            );
                            String webUrl =
                                "https://www.caraqar.co/Cars/Detail/${car?.carId}";
                            // var message =
                            //     "Hey! you might be interested in this.\n$adUrl\nor Check this ad on Car aqar\n$webUrl";
                            var message =
                                "Hey! you might be interested in this.\n$adUrl";

                            Share.share(message);
                          },
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
                            items:
                                car?.images.map((item) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.toNamed(
                                            Routes.viewImageScreen,
                                            arguments: car.images,
                                            parameters: {
                                              "index":
                                                  car.images
                                                      .indexOf(item)
                                                      .toString(),
                                            },
                                          );
                                        },
                                        child: ImageWidget(
                                          item,
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                          ),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Container(
                          //         color: Colors.black38,
                          //         child: IconButtonWidget(
                          //           icon: MaterialCommunityIcons.chevron_left,
                          //           onPressed: () {},
                          //           color: kWhiteColor,)),
                          //     Container(
                          //         color: Colors.black38,
                          //         child: IconButtonWidget(
                          //           icon: MaterialCommunityIcons.chevron_right,
                          //           onPressed: () {},
                          //           color: kWhiteColor,)),
                          //   ],
                          // ),

                          //                        GetBuilder<ViewCarController>(builder: (controller)=> Positioned(
                          //                               bottom: 10.w,
                          //                               right: 16.w,
                          //                               child: Container(
                          //                                 padding: EdgeInsets.symmetric(
                          //                                     vertical: 2, horizontal: 8),
                          //                                 decoration: BoxDecoration(
                          //                                   color: Colors.black38,
                          //                                   borderRadius: kBorderRadius30,
                          //                                 ),
                          //                                 child: Text(
                          //                                   "${controller.sliderIndex.value + 1}/${car.images.length}",
                          //                                   style: TextStyle(
                          //                                       color: kWhiteColor, fontSize: 12.sp),),
                          //                               )))
                          // ,

                          // GestureDetector(
                          //   onTap: (){
                          //     Get.toNamed(Routes.viewImageScreen,
                          //         arguments: car.images,parameters: {"index":0.toString()});
                          //   },
                          //   child: ImageWidget(
                          //     car.images.first,
                          //     width: double.infinity,
                          //     height: double.infinity,
                          //     fit: BoxFit.cover,
                          //
                          //   ),
                          // ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              height: 20.h,
                              width: 1.sw,
                              decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                    spreadRadius: 15,
                                    blurRadius: 15,
                                    offset: Offset(0, 15),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 40.h,
                            child: Container(
                              width: 1.sw,
                              padding: kScreenPadding.copyWith(
                                top: 8.w,
                                bottom: 8.w,
                              ),
                              decoration: const BoxDecoration(
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
                                          "${car?.brandName} ${car?.modelName} ${car?.modelYear}",
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                          style: kLightTextStyle18,
                                        ),
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
                                              child: Builder(
                                                builder: (context) {
                                                  final cityName = Get.find<LocationController>().getLocationTitleFromId(car.locationId);
                                                  debugPrint("🧭 car.cityId: ${car.locationId}, cityName: $cityName");

                                                  return Text(
                                                    "$cityName, ${car.cityName}",
                                                    style: kTextStyle14.copyWith(color: kWhiteColor),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      GetBuilder<ViewCarController>(
                                        builder:
                                            (controller) => IconButtonWidget(
                                              icon:
                                                  car.favoriteId! > 0
                                                      ? MaterialCommunityIcons
                                                          .heart
                                                      : MaterialCommunityIcons
                                                          .heart_outline,
                                              color:
                                                  car.favoriteId! > 0
                                                      ? kRedColor
                                                      : kWhiteColor,
                                              width: 30.w,
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
                                      kVerticalSpace8,
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 8,
                                        ),
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
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    systemOverlayStyle: SystemUiOverlayStyle.dark,
                  ),
                ];
              },
              body: RemoveSplash(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.w,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (car?.companyId != null) {
                                  if (Get.previousRoute ==
                                      "${Routes.companyScreen}?type=Car&agentAds=${car?.isAgentAd}") {
                                    Get.back();
                                  } else {
                                    Get.offNamed(
                                      Routes.companyScreen,
                                      arguments: car?.companyId,
                                      parameters: {
                                        "type": "Car",
                                        "agentAds": "${car?.isAgentAd}",
                                      },
                                    );
                                  }
                                } else if (car?.agentId != null) {
                                  if (Get.previousRoute ==
                                      "${Routes.agentScreen}?type=Car&agentAds=${car?.isAgentAd}") {
                                    Get.back();
                                  } else {
                                    Get.offNamed(
                                      Routes.agentScreen,
                                      arguments: car?.agentId,
                                      parameters: {
                                        "type": "Car",
                                        "agentAds": "${car?.isAgentAd}",
                                      },
                                    );
                                  }
                                }
                              },
                              child: ImageWidget(
                                car?.agentImage == "" || car?.agentImage == null
                                    ? "assets/images/profile2.jpg"
                                    : car?.agentImage,
                                width: 70.r,
                                height: 70.r,
                                isCircular: true,
                                isLocalImage:
                                    car?.agentImage == "" ||
                                    car?.agentImage == null,
                                fit: BoxFit.cover,
                              ),
                            ),
                            kHorizontalSpace12,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    car!.agentName!,
                                    style: kTextStyle16.copyWith(
                                      color: kAccentColor,
                                    ),
                                  ),
                                  kVerticalSpace4,
                                  Text(
                                    "Owner".tr,
                                    style: kTextStyle14.copyWith(
                                      color: kGreyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 40.w,
                              child: OutlinedButton(
                                onPressed: () async {
                                  controller.updateClicks(isCall: true);
                                  await launch("tel://${car.contactNo}");
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  side: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                child: Icon(
                                  MaterialCommunityIcons.phone,
                                  color: kAccentColor,
                                  size: 25.w,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 40.w,
                              child: OutlinedButton(
                                onPressed: () async {
                                  controller.updateClicks(isWhatsapp: true);

                                  String
                                  adUrl = await DynamicLink.createDynamicLink(
                                    false,
                                    uri: "/Cars/Detail/${car.carId}",
                                    title:
                                        "${car.brandName} ${car.modelName} ${car.modelYear}",
                                    desc: car.description,
                                    image: car.images.first,
                                  );

                                  String url;
                                  // var message = Uri.encodeFull(
                                  //   "Hello,\n${car.agentName}\nI would like to get more information about this ad you posted on.\n$adUrl \n or Check this ad on Car aqar \n https://www.caraqar.co/Cars/Detail/${car.carId}",
                                  // );
                                  var message = Uri.encodeFull(
                                    "Hello,\n${car.agentName}\nI would like to get more information about this ad you posted on.\n$adUrl",
                                  );
                                  if (Platform.isIOS) {
                                    url =
                                        "https://wa.me/${car.contactNo}?text=$message";
                                  } else {
                                    url =
                                        "whatsapp://send?phone=${car.contactNo}&text=$message";
                                  }
                                  try {
                                    await launchUrl(Uri.parse(url));
                                  } catch (e) {
                                    showSnackBar(
                                      message: "CouldNotLaunchWhatsApp",
                                    );
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  side: const BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                child: Image.asset(
                                  "assets/images/whatsapp.png",
                                  width: 22.w,
                                ),
                              ),
                            ),
                            (car.email != null &&
                                    car.email!.isNotEmpty &&
                                    car.email != "no email")
                                ? SizedBox(
                                  width: 40.w,
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      controller.updateClicks(isEmail: true);

                                      String adUrl =
                                          await DynamicLink.createDynamicLink(
                                            false,
                                            uri: "/Cars/Detail/${car.carId}",
                                            title: car.title,
                                            desc: car.description,
                                            image: car.images.first,
                                          );

                                      String webUrl =
                                          "https://www.caraqar.co/Cars/Detail/${car.carId}";
                                      String? subject = car.title;

                                      // var message =
                                      //     "Hello,\n${car.agentName}\n"
                                      //     "I would like to get more information about this ad you posted on.\n"
                                      //     "$adUrl\nOr check this ad on Car aqar\n$webUrl";
                                      var message =
                                          "Hello,\n${car.agentName}\n"
                                          "I would like to get more information about this ad you posted on.\n"
                                          "$adUrl\nOr check this ad on Car aqar\n$webUrl";

                                      final Email email = Email(
                                        body: message,
                                        subject: subject!,
                                        recipients: [car.email!],
                                        isHTML: false,
                                      );

                                      await FlutterEmailSender.send(email);
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      side: const BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    child: Icon(
                                      MaterialCommunityIcons.email,
                                      color: kAccentColor,
                                      size: 25.w,
                                    ),
                                  ),
                                )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Divider(thickness: 1.h, color: Colors.grey.shade400),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                        car.modelYear!,
                                        style: TextStyle(
                                          color: kAccentColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                        ),
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
                                        car.mileage!,
                                        style: TextStyle(
                                          color: kAccentColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/automatic.png",
                                        width: 30.w,
                                        height: 30.w,
                                      ),
                                      Text(
                                        car.transmission!
                                            .replaceAll("Automatic", "Auto")
                                            .tr,
                                        style: TextStyle(
                                          color: kAccentColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        "assets/images/benzin.png",
                                        width: 30.w,
                                        height: 30.w,
                                      ),
                                      Text(
                                        car.fuelType!.tr,
                                        style: TextStyle(
                                          color: kAccentColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(thickness: 1.h, color: Colors.grey.shade400),
                        ],
                      ),
                      Transform.translate(
                        offset: const Offset(0, -8
                        ), //
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(0),
                                  bottomLeft: Radius.circular(0),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.directions_car, color: kAccentColor),
                                  const SizedBox(width: 12),
                                  Text(
                                    "Ad ID: ${car.carId ?? 'N/A'}",
                                    style: const TextStyle(fontSize: 12, color: kAccentColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "CurrentPrice".tr,
                        textAlign: TextAlign.center,
                        style: kTextStyle14.copyWith(color: kAccentColor),
                      ),
                      kVerticalSpace8,
                      Text(
                        car.price == null || car.price == 0
                            ? "Call for Price".tr
                            : getPrice(car.price!),
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
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      kVerticalSpace8,
                                      Text(
                                        car.brandName!,
                                        style: kTextStyle16.copyWith(
                                          color: kAccentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 40.h,
                                  child: const VerticalDivider(),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Model".tr,
                                        style: kTextStyle16.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      kVerticalSpace8,
                                      Text(
                                        car.modelName!,
                                        style: kTextStyle16.copyWith(
                                          color: kAccentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Year".tr,
                                        style: kTextStyle16.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      kVerticalSpace8,
                                      Text(
                                        car.modelYear!,
                                        style: kTextStyle16.copyWith(
                                          color: kAccentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 40.h,
                                  child: const VerticalDivider(),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Type".tr,
                                        style: kTextStyle16.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      kVerticalSpace8,
                                      Text(
                                        car.type!,
                                        style: kTextStyle16.copyWith(
                                          color: kAccentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Transmission".tr,
                                        style: kTextStyle16.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      kVerticalSpace8,
                                      Text(
                                        car.transmission!.tr,
                                        style: kTextStyle16.copyWith(
                                          color: kAccentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 40.h,
                                  child: const VerticalDivider(),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        "FuelType".tr,
                                        style: kTextStyle16.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      kVerticalSpace8,
                                      Text(
                                        car.fuelType!.tr,
                                        style: kTextStyle16.copyWith(
                                          color: kAccentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Condition".tr,
                                        style: kTextStyle16.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      kVerticalSpace8,
                                      Text(
                                        car.condition!.tr,
                                        style: kTextStyle16.copyWith(
                                          color: kAccentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 40.h,
                                  child: const VerticalDivider(),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Mileage".tr,
                                        style: kTextStyle16.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      kVerticalSpace8,
                                      Text(
                                        "${car.mileage} ${"KM".tr}",
                                        style: kTextStyle16.copyWith(
                                          color: kAccentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text("Registration province".tr, style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
                                      kVerticalSpace8,
                                      Obx(() {
                                        final locationController = Get.find<LocationController>();
                                        if (locationController.allCitiesForName.isEmpty) {
                                          return const SizedBox(); // or CircularProgressIndicator if preferred
                                        }

                                        final regCity = car.registrationCity?.trim();
                                        final locationId = int.tryParse(regCity ?? '');

                                        final displayName = locationId != null
                                            ? locationController.getLocationTitleFromId(locationId)
                                            : "Not Available";

                                        return Text(
                                          displayName,
                                          style: kTextStyle16.copyWith(color: kAccentColor),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),    Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text("Registration Year".tr, style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
                                      kVerticalSpace8,
                                      Text(
                                        car.registrationYear?.isNotEmpty == true
                                            ? car.registrationYear!
                                            : "Not Available",
                                        style: kTextStyle16.copyWith(color: kAccentColor),
                                      ),
                                    ],
                                  ),
                                ), SizedBox(
                                  height: 40.h,
                                  child: VerticalDivider(),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text("origin".tr, style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
                                      kVerticalSpace8,
                                      Text(
                                        car.importedLocal?.isNotEmpty == true ? car.importedLocal! : "Not Available",
                                        style: kTextStyle16.copyWith(color: kAccentColor),
                                      ),
                                    ],
                                  ),)
                              ],
                            ),    Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Seats".tr,
                                        style: kTextStyle16.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      kVerticalSpace8,
                                      Text(
                                        "${car.seats}",
                                        style: kTextStyle16.copyWith(
                                          color: kAccentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 40.h,
                                  child: const VerticalDivider(),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Engine".tr,
                                        style: kTextStyle16.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      kVerticalSpace8,
                                      Text(
                                        car.engine!,
                                        style: kTextStyle16.copyWith(
                                          color: kAccentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        "City".tr,
                                        style: kTextStyle16.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      kVerticalSpace8,
                                      Text(
                                        car.cityName!,
                                        style: kTextStyle16.copyWith(
                                          color: kAccentColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 40.h,
                                  child: const VerticalDivider(),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Color".tr,
                                        style: kTextStyle16.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      kVerticalSpace8,
                                      Text(
                                        car.color!.tr,
                                        style: kTextStyle16.copyWith(
                                          color: kAccentColor,
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
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            kVerticalSpace4,
                            Text(
                              car.description!,
                              style: kTextStyle14.copyWith(color: kAccentColor),
                            ),
                            kVerticalSpace16,
                            if (car.featureHeads.isNotEmpty)
                              Padding(
                                padding: EdgeInsets.only(bottom: 28.w),
                                child: Text(
                                  "Features/Amenities".tr,
                                  style: kTextStyle16.copyWith(
                                    color: kAccentColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            Column(
                              children:
                                  car.featureHeads
                                      .map(
                                        (e) => Container(
                                          margin: EdgeInsets.only(bottom: 32.h),
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            alignment: Alignment.topCenter,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 32.w,
                                                  horizontal: 16.w,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius: kBorderRadius4,
                                                  border: Border.all(
                                                    color: kBorderColor,
                                                    width: 1.w,
                                                  ),
                                                ),
                                                child: GridView.builder(
                                                  padding: EdgeInsets.zero,
                                                  physics:
                                                      const PageScrollPhysics(),
                                                  shrinkWrap: true,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                        childAspectRatio: 1,
                                                        crossAxisSpacing: 8.w,
                                                        mainAxisSpacing: 8.w,
                                                        crossAxisCount: 4,
                                                      ),
                                                  itemCount: e.features.length,
                                                  itemBuilder: (
                                                    context,
                                                    index,
                                                  ) {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        ImageWidget(
                                                          e
                                                              .features[index]
                                                              .image,
                                                          width: 30.w,
                                                          height: 30.w,
                                                        ),
                                                        kVerticalSpace4,
                                                        FittedBox(
                                                          fit: BoxFit.scaleDown,
                                                          child: Text(
                                                            "${e.features[index].title}${e.features[index].quantity! > 0
                                                                ? ": ${e.features[index].quantity}"
                                                                : e.features[index].featureOption != null
                                                                ? ": ${e.features[index].featureOption}"
                                                                : ""}",
                                                            style: kTextStyle12
                                                                .copyWith(
                                                                  color:
                                                                      kAccentColor,
                                                                ),
                                                            textAlign:
                                                                TextAlign
                                                                    .center,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                              Positioned(
                                                top: -16.w,
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 6.w,
                                                    horizontal: 12.w,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: kBgColor,
                                                    borderRadius:
                                                        kBorderRadius4,
                                                    border: Border.all(
                                                      color: kBorderColor,
                                                      width: 1.w,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    e.title!,
                                                    style: kTextStyle16
                                                        .copyWith(
                                                          color: kAccentColor,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                            ),
                          ],
                        ),
                      ),
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
