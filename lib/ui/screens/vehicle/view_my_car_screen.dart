import 'package:cached_network_image/cached_network_image.dart';
import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/vehicle_controller.dart';
import 'package:careqar/controllers/view_my_car_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/services/dynamic_link.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
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

import '../../../global_variables.dart';

class ViewMyCarScreen extends GetView<ViewMyCarController> {
  ViewMyCarScreen({Key? key}) : super(key: key) {
   controller.sliderIndex(0);
  }

  @override
  Widget build(BuildContext context) {
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
                  String url = await DynamicLink.createDynamicLink(
                    false,
                    uri: "/car?carId=${car?.carId}",
                    title: "${car?.brandName} ${car?.modelName} ${car?.modelYear}",
                    desc: car?.description,
                    image: car?.images.first,
                  );
                  Share.share(url);
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
                              car.images.length ?? 0,
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
                              // Status badge (only show if not sold)
                              if (!car.isSold!)
                                Container(
                                  margin: EdgeInsets.only(bottom: 10.h),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: car.status == "Approved"
                                        ? kSuccessColor
                                        : Colors.orangeAccent,
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  child: Text(
                                    " ${car.status}".tr,
                                    style: TextStyle(
                                      color: kWhiteColor,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
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
                                        car.createdAt!,
                                        locale: gSelectedLocale?.locale?.languageCode,
                                      ),
                                      textDirection: TextDirection.ltr,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: kIconColor,
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
                                        "${car.location}",
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Price on left
                                    Expanded(
                                      child: Text(
                                        car.price == null || car.price == 0
                                            ? "Call for Price".tr
                                            : getPrice(car.price!),
                                        style: kTextStyle18.copyWith(
                                          color: kPrimaryColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.sp,
                                        ),
                                      ),
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
                              label: car.transmission!.replaceAll("Automatic", "Auto").tr,
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
                            "Description".tr.toUpperCase(),
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
                    // Action buttons section
                    Container(
                      width: 1.sw,
                      padding: kScreenPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Actions".tr.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: kTextStyle16.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Expanded(
                                child: ButtonWidget(
                                  onPressed: () async {
                                    controller.refreshCar(car: car);
                                  },
                                  text: "Refresh",
                                  color: kPrimaryColor,
                                ),
                              ),
                              kHorizontalSpace4,
                              Expanded(
                                child: ButtonWidget(
                                  onPressed: () async {
                                    Get.find<VehicleController>()
                                        .edit(data: car, vehicleType: VehicleType.Car);
                                  },
                                  text: "Edit",
                                  color: kAccentColor,
                                ),
                              ),
                            ],
                          ),
                          kVerticalSpace8,
                          Row(
                            children: [
                              Expanded(
                                child: ButtonWidget(
                                  onPressed: () async {
                                    showConfirmationDialog(
                                      onConfirm: () {
                                        controller.deleteCar(car: car);
                                        Get.back();
                                      },
                                      title: "Delete",
                                      message: "AreYouSureToDeleteThisCar",
                                      textConfirm: "Yes",
                                      textCancel: "No",
                                    );
                                  },
                                  text: "Delete",
                                  color: kRedColor,
                                ),
                              ),
                              kHorizontalSpace4,
                              car.status == "Approved" && !car.isSold!
                                  ? Expanded(
                                child: ButtonWidget(
                                  onPressed: () async {
                                    showConfirmationDialog(
                                      onConfirm: () {
                                        controller.soldOutCar(car: car);
                                        Get.back();
                                      },
                                      title: "SoldOut",
                                      message: "AreYouSureToSoldThisCar",
                                      textConfirm: "Yes",
                                      textCancel: "No",
                                    );
                                  },
                                  text: "SoldOut",
                                  color: kLightBlueColor,
                                ),
                              )
                                  : Container(),
                            ],
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
      height: double.infinity,
      color: Colors.white,
    );
  }

  //tabs
  Widget _buildInformationTab(car) {
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
            _buildStyledRow("Brand", car.brandName!, 0),
            _buildStyledRow("Model".tr, car.modelName!, 1),
            _buildStyledRow("Model Year".tr, car.modelYear!, 2),
            _buildStyledRow(
              "Registered Year".tr,
              car.registrationYear?.isNotEmpty == true ? car.registrationYear! : "Not Available",
              3,
            ),
            _buildStyledRow(
              "Registered In".tr,
              car.registrationCity?.isNotEmpty == true ? car.registrationCity! : "Not Available",
              4,
            ),
            _buildStyledRow(
              "Assembly".tr,
              car.importedLocal?.isNotEmpty == true ? car.importedLocal! : "Not Available",
              5,
            ),
            _buildStyledRow("Type".tr, car.type!, 6),
            _buildStyledRow("Transmission".tr, car.transmission!, 7),
            _buildStyledRow("FuelType".tr, car.fuelType!, 8),
            _buildStyledRow("Condition".tr, car.condition!, 9),
            _buildStyledRow("Mileage".tr, "${car.mileage} ${"KM".tr}", 10),
            _buildStyledRow("Seats".tr, "${car.seats}", 11),
            _buildStyledRow("Engine".tr, car.engine!, 12),
            _buildStyledRow("City".tr, car.location!, 13),
            _buildStyledRow("Color".tr, car.color!, 14),
            _buildStyledRow("Ad ID".tr, car.carId.toString(), 15),
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
                          "${e.features[index].title}",
                             // "${(e.features[index].quantity != null && e.features[index].quantity! > 0) ? ": ${e.features[index].quantity}" : (e.features[index].featureOption != null && e.features[index].featureOption.toString().isNotEmpty) ? ": ${e.features[index].featureOption}" : ""}",
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
          // Add map or location details
        ],
      ),
    );
  }
}


