import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:timeago/timeago.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/strings.dart';
import '../../../controllers/city_controller.dart' show CityController;
import '../../../controllers/favorite_controller.dart';
import '../../../controllers/location_controller.dart';
import '../../../global_variables.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/text_field_widget.dart';

class ViewCarScreen extends GetView<ViewCarController> {
  ViewCarScreen({Key? key}) : super(key: key) {
    //print(Get.arguments);

    controller.sliderIndex(0);
  }

  @override
  Widget build(BuildContext context) {
    controller.formKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Obx(() {
        var car = controller.car.value;
        return controller.status.value == Status.success
            ? NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
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
                          title: "${car?.brandName} ${car?.modelName} ${car?.modelYear}",
                          desc: car?.description,
                          image: car?.images.first,
                        );
                        String webUrl = "https://www.caraqar.co/Cars/Detail/${car?.carId}";
                        var message = "Hey! you might be interested in this.\n$adUrl";
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
                      // Enhanced Carousel with modern design
                      CarouselSlider(
                        options: CarouselOptions(
                          height: double.infinity,
                          autoPlayCurve: Curves.easeInOutCubic,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 4),
                          autoPlayAnimationDuration: Duration(milliseconds: 1000),
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
                        items: car.images.map((item) {
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
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(0),
                                    child: CachedNetworkImage(
                                      imageUrl: item,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: Colors.grey[200],
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        color: Colors.grey[200],
                                        child: Center(
                                          child: Icon(Icons.error, size: 50, color: kPrimaryColor),
                                        ),
                                      ),
                                      memCacheWidth: 800,
                                      memCacheHeight: 600,
                                      maxWidthDiskCache: 1000,
                                      maxHeightDiskCache: 1000,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),

                      // Modern gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.7),
                            ],
                            stops: [0.0, 0.5, 0.8, 1.0],
                          ),
                        ),
                      ),

                      // Enhanced dots indicator
                      Positioned(
                        bottom: 120.h,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // blur effect
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: car.images.asMap().entries.map((entry) {
                                return Container(
                                  width: controller.sliderIndex.value == entry.key ? 24.w : 8.w,
                                  height: 8.h,
                                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: controller.sliderIndex.value == entry.key
                                        ? kWhiteColor
                                        : kWhiteColor.withOpacity(0.4),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),

                      // Enhanced car info overlay
                      Positioned(
                        bottom: 40.h,
                        child: Container(
                          width: 1.sw,
                          padding: kScreenPadding.copyWith(top: 16.w, bottom: 16.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${car?.brandName} ${car?.modelName} ${car?.modelYear}",
                                      maxLines: 2,
                                      style: kLightTextStyle18.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.sp,
                                      ),
                                    ),
                                    kVerticalSpace8,
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                          decoration: BoxDecoration(
                                            color: kPrimaryColor.withOpacity(0.9),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                MaterialCommunityIcons.map_marker,
                                                size: 14.sp,
                                                color: kWhiteColor,
                                              ),
                                              SizedBox(width: 4.w),
                                              Text(
                                                "${car.location}, ${car.cityName}",
                                                style: kTextStyle12.copyWith(
                                                  color: kWhiteColor,
                                                  fontWeight: FontWeight.w600,
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
                              Column(
                                children: [
                                  GetBuilder<ViewCarController>(
                                    builder: (controller) => Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: IconButtonWidget(
                                        icon: car.favoriteId! > 0
                                            ? MaterialCommunityIcons.heart
                                            : MaterialCommunityIcons.heart_outline,
                                        color: car.favoriteId! > 0 ? kRedColor : kWhiteColor,
                                        width: 40.w,
                                        onPressed: () async {
                                          var favController = Get.put(FavoriteController());
                                          if (car.favoriteId! > 0) {
                                            if (await favController.deleteFavorite(car: car)) {
                                              controller.update();
                                            }
                                          } else {
                                            if (await favController.addToFavorites(car: car)) {
                                              controller.update();
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  kVerticalSpace12,
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          MaterialCommunityIcons.eye_outline,
                                          size: 16.sp,
                                          color: kWhiteColor,
                                        ),
                                        SizedBox(width: 6.w),
                                        Text(
                                          "${car.clicks}",
                                          style: TextStyle(
                                            color: kWhiteColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
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
            child: Column(
              children: [
                // Enhanced Agent Section
                Container(
                  margin: EdgeInsets.all(16.w),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (car?.companyId != null) {
                            if (Get.previousRoute == "${Routes.companyScreen}?type=Car&agentAds=${car?.isAgentAd}") {
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
                            if (Get.previousRoute == "${Routes.agentScreen}?type=Car&agentAds=${car?.isAgentAd}") {
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
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: kPrimaryColor.withOpacity(0.3), width: 3),
                          ),
                          child: ImageWidget(
                            car?.agentImage == "" || car?.agentImage == null
                                ? "assets/images/profile2.jpg"
                                : car?.agentImage,
                            width: 60.r,
                            height: 60.r,
                            isCircular: true,
                            isLocalImage: car?.agentImage == "" || car?.agentImage == null,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      kHorizontalSpace16,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              car!.agentName!,
                              style: kTextStyle16.copyWith(
                                color: kAccentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            kVerticalSpace4,
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: kPrimaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Owner".tr,
                                style: kTextStyle12.copyWith(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 8.w),
                            decoration: BoxDecoration(
                              color: kPrimaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                controller.updateClicks(isCall: true);
                                await launch("tel://${car.contactNo}");
                              },
                              icon: Icon(
                                MaterialCommunityIcons.phone,
                                color: kPrimaryColor,
                                size: 20.sp,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 8.w),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: IconButton(
                              onPressed: () async {
                                controller.updateClicks(isWhatsapp: true);
                                String adUrl = await DynamicLink.createDynamicLink(
                                  false,
                                  uri: "/Cars/Detail/${car.carId}",
                                  title: "${car.brandName} ${car.modelName} ${car.modelYear}",
                                  desc: car.description,
                                  image: car.images.first,
                                );
                                var message = Uri.encodeFull(
                                  "Hello,\n${car.agentName}\nI would like to get more information about this ad you posted on.\n$adUrl",
                                );
                                String url;
                                if (Platform.isIOS) {
                                  url = "https://wa.me/${car.contactNo}?text=$message";
                                } else {
                                  url = "whatsapp://send?phone=${car.contactNo}&text=$message";
                                }
                                try {
                                  await launchUrl(Uri.parse(url));
                                } catch (e) {
                                  showSnackBar(message: "CouldNotLaunchWhatsApp");
                                }
                              },
                              icon: Image.asset(
                                "assets/images/whatsapp.png",
                                width: 20.w,
                              ),
                            ),
                          ),
                          if (car.email != null && car.email!.isNotEmpty && car.email != "no email")
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  controller.updateClicks(isEmail: true);
                                  String adUrl = await DynamicLink.createDynamicLink(
                                    false,
                                    uri: "/Cars/Detail/${car.carId}",
                                    title: car.title,
                                    desc: car.description,
                                    image: car.images.first,
                                  );
                                  String webUrl = "https://www.caraqar.co/Cars/Detail/${car.carId}";
                                  String? subject = car.title;
                                  var message = "Hello,\n${car.agentName}\n"
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
                                icon: Icon(
                                  MaterialCommunityIcons.email,
                                  color: Colors.blue,
                                  size: 20.sp,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Quick Stats Row
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kPrimaryColor.withOpacity(0.1), kPrimaryColor.withOpacity(0.05)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildQuickStat(
                          "assets/images/calender.png",
                          car.modelYear!,
                          "Year",
                        ),
                      ),
                      Expanded(
                        child: _buildQuickStat(
                          "assets/images/speedcounter.png",
                          car.mileage!,
                          "Mileage",
                        ),
                      ),
                      Expanded(
                        child: _buildQuickStat(
                          "assets/images/automatic.png",
                          car.transmission!.replaceAll("Automatic", "Auto").tr,
                          "Transmission",
                        ),
                      ),
                      Expanded(
                        child: _buildQuickStat(
                          "assets/images/benzin.png",
                          car.fuelType!.tr,
                          "Fuel",
                        ),
                      ),
                    ],
                  ),
                ),

                // Ad ID and Price Section
                Container(
                  margin: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: kPrimaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.directions_car, color: kPrimaryColor, size: 16.sp),
                                SizedBox(width: 8.w),
                                Text(
                                  "Ad ID: Pk ${car.carId ?? 'N/A'}",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      kVerticalSpace16,
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.8)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryColor.withOpacity(0.3),
                              blurRadius: 15,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              "CurrentPrice".tr,
                              style: kTextStyle14.copyWith(
                                color: kWhiteColor.withOpacity(0.9),
                              ),
                            ),
                            kVerticalSpace8,
                            Text(
                              car.price == null || car.price == 0
                                  ? "Call for Price".tr
                                  : getPrice(car.price!),
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                color: kWhiteColor,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Modern Tab Section
                Expanded(
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TabBar(
                            indicator: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            labelColor: kWhiteColor,
                            unselectedLabelColor: kAccentColor,
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                            unselectedLabelStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                            tabs: [
                              Tab(text: "Information".tr),
                              Tab(text: "Features".tr),
                              Tab(text: "Location".tr),
                            ],
                          ),
                        ),
                        kVerticalSpace16,
                        Expanded(
                          child: TabBarView(
                            children: [
                              // Information Tab
                              _buildInformationTab(car),
                              // Features Tab
                              _buildFeaturesTab(car),
                              // Location Tab
                              _buildLocationTab(car),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
            : CircularLoader();
      }),
    );
  }

  Widget _buildQuickStat(String iconPath, String value, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Image.asset(
            iconPath,
            width: 24.w,
            height: 24.w,
          ),
        ),
        kVerticalSpace8,
        Text(
          value,
          style: TextStyle(
            color: kAccentColor,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          label.tr,
          style: TextStyle(
            color: kGreyColor,
            fontSize: 10.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildInformationTab(car) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildInfoRow("Brand".tr, car.brandName!),
                _buildInfoDivider(),
                _buildInfoRow("Model".tr, car.modelName!),
                _buildInfoDivider(),
                _buildInfoRow("Year".tr, car.modelYear!),
                _buildInfoDivider(),
                _buildInfoRow("Type".tr, car.type!),
                _buildInfoDivider(),
                _buildInfoRow("Transmission".tr, car.transmission!),
                _buildInfoDivider(),
                _buildInfoRow("FuelType".tr, car.fuelType!),
                _buildInfoDivider(),
                _buildInfoRow("Condition".tr, car.condition!),
                _buildInfoDivider(),
                _buildInfoRow("Mileage".tr, "${car.mileage} ${"KM".tr}"),
                _buildInfoDivider(),
                _buildInfoRow("Registration province".tr, car.registrationProvince ?? "NotAvailable".tr),
                _buildInfoDivider(),
                _buildInfoRow("Registration Year".tr, car.registrationYear?.isNotEmpty == true ? car.registrationYear! : "Not Available"),
                _buildInfoDivider(),
                _buildInfoRow("origin".tr, car.importedLocal?.isNotEmpty == true ? car.importedLocal! : "Not Available"),
                _buildInfoDivider(),
                _buildInfoRow("Seats".tr, "${car.seats}"),
                _buildInfoDivider(),
                _buildInfoRow("Engine".tr, car.engine!),
                _buildInfoDivider(),
                _buildInfoRow("City".tr, car.cityName!),
                _buildInfoDivider(),
                _buildInfoRow("Color".tr, car.color!),
              ],
            ),
          ),
          kVerticalSpace20,
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        MaterialCommunityIcons.text_box_outline,
                        color: kPrimaryColor,
                        size: 20.sp,
                      ),
                    ),
                    kHorizontalSpace12,
                    Text(
                      "Description".tr,
                      style: kTextStyle18.copyWith(
                        color: kAccentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                kVerticalSpace12,
                Text(
                  car.description!,
                  style: kTextStyle14.copyWith(
                    color: kAccentColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          kVerticalSpace20,
          _buildCommentsSection(),
        ],
      ),
    );
  }

  Widget _buildFeaturesTab(car) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: car.featureHeads.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              MaterialCommunityIcons.car_cog,
              size: 80.sp,
              color: kGreyColor.withOpacity(0.5),
            ),
            kVerticalSpace16,
            Text(
              "No Features Available".tr,
              style: kTextStyle16.copyWith(
                color: kGreyColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      )
          : Column(
        children: car.featureHeads
            .map<Widget>(
              (e) => Container(
            margin: EdgeInsets.only(bottom: 20.h),
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kPrimaryColor.withOpacity(0.1), kPrimaryColor.withOpacity(0.05)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          MaterialCommunityIcons.star_outline,
                          color: kPrimaryColor,
                          size: 20.sp,
                        ),
                      ),
                      kHorizontalSpace12,
                      Text(
                        e.title!,
                        style: kTextStyle16.copyWith(
                          color: kAccentColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.w,
                      crossAxisCount: 3,
                    ),
                    itemCount: e.features.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: kPrimaryColor.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: kWhiteColor,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 5,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ImageWidget(
                                e.features[index].image,
                                width: 24.w,
                                height: 24.w,
                              ),
                            ),
                            kVerticalSpace8,
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "${e.features[index].title}${e.features[index].quantity! > 0 ? ": ${e.features[index].quantity}" : e.features[index].featureOption != null ? ": ${e.features[index].featureOption}" : ""}",
                                  // style: kTextStyle10.copyWith(
                                  //   color: kAccentColor,
                                  //   fontWeight: FontWeight.w600,
                                  // ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        )
            .toList(),
      ),
    );
  }

  Widget _buildLocationTab(car) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        MaterialCommunityIcons.map_marker,
                        color: kPrimaryColor,
                        size: 20.sp,
                      ),
                    ),
                    kHorizontalSpace12,
                    Text(
                      "Location Details".tr,
                      style: kTextStyle18.copyWith(
                        color: kAccentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                kVerticalSpace16,
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [kPrimaryColor.withOpacity(0.1), kPrimaryColor.withOpacity(0.05)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        MaterialCommunityIcons.map_marker_outline,
                        color: kPrimaryColor,
                        size: 24.sp,
                      ),
                      kHorizontalSpace12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${car.location}",
                              style: kTextStyle16.copyWith(
                                color: kAccentColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${car.cityName}",
                              style: kTextStyle14.copyWith(
                                color: kGreyColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                kVerticalSpace16,
                // You can add a map widget here if available
                Container(
                  height: 200.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MaterialCommunityIcons.map,
                          size: 60.sp,
                          color: kGreyColor,
                        ),
                        kVerticalSpace8,
                        Text(
                          "Map View".tr,
                          style: kTextStyle14.copyWith(
                            color: kGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: kTextStyle14.copyWith(
                color: kGreyColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          kHorizontalSpace8,
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: kTextStyle14.copyWith(
                color: kAccentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoDivider() {
    return Divider(
      color: Colors.grey.shade200,
      thickness: 1,
      height: 1,
    );
  }

  Widget _buildCommentsSection() {
    return GetBuilder<ViewCarController>(
      id: "comments",
      builder: (controller) => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    MaterialCommunityIcons.comment_multiple_outline,
                    color: kPrimaryColor,
                    size: 20.sp,
                  ),
                ),
                kHorizontalSpace12,
                Text(
                  "${"Comments".tr} (${controller.comments.length})",
                  style: kTextStyle18.copyWith(
                    color: kAccentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            kVerticalSpace16,
            if (controller.comments.isEmpty)
              Container(
                padding: EdgeInsets.all(40.w),
                child: Column(
                  children: [
                    Icon(
                      MaterialCommunityIcons.comment_outline,
                      size: 60.sp,
                      color: kGreyColor.withOpacity(0.5),
                    ),
                    kVerticalSpace16,
                    Text(
                      "NoComments".tr,
                      style: kTextStyle14.copyWith(
                        color: kGreyColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  var item = controller.comments[index];
                  return Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade200,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: kPrimaryColor.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: ImageWidget(
                            item.image ?? "assets/images/profile2.jpg",
                            isLocalImage: item.image == null,
                            width: 40.r,
                            height: 40.r,
                            isCircular: true,
                          ),
                        ),
                        kHorizontalSpace12,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${item.name}",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: kAccentColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${format(
                                      item.createdAt!,
                                      locale: gSelectedLocale?.locale?.languageCode,
                                    )}",
                                    style: TextStyle(
                                      color: kGreyColor,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ],
                              ),
                              kVerticalSpace8,
                              Text(
                                "${item.comment}",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: kAccentColor,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return kVerticalSpace12;
                },
                shrinkWrap: true,
                itemCount: controller.comments.length,
              ),
            kVerticalSpace20,
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kPrimaryColor.withOpacity(0.05), kPrimaryColor.withOpacity(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Form(
                    key: controller.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFieldWidget(
                      maxLines: 3,
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
                      gradient: LinearGradient(
                        colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.8)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ButtonWidget(
                      text: "Comment",
                      onPressed: controller.saveComment,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
