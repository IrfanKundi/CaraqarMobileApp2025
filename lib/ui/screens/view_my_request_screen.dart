import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/add_request_controller.dart';
import 'package:careqar/controllers/view_my_request_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/services/dynamic_link.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/remove_splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global_variables.dart';
import '../widgets/image_widget.dart';

class ViewMyRequestScreen extends GetView<ViewMyRequestController> {
  ViewMyRequestScreen({super.key}) {
    //print(Get.arguments);
  }

  @override
  Widget build(BuildContext context) {
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
                var request = controller.request.value;
                String url = await DynamicLink.createDynamicLink(
                  false,
                  uri: "/request?requestId=${request!.requestId}",
                  metaTag: false,
                );
                Share.share(url);
              },
            ),
          ],
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Obx(() {
        var request = controller.request.value;
        return controller.status.value == Status.success
            ? SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              children: [
                // Logo section
                SizedBox(
                  height: 0.4.sh,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Rounded logo container
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24.r),
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            color: Colors.grey[50],
                            child: Image.asset(
                              gSelectedLocale?.langCode == 0
                                  ? "assets/images/logo-en.png"
                                  : "assets/images/logo-ar.png",
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Content section
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
                          // Left: Location and details
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Location row
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      MaterialCommunityIcons.map_marker_outline,
                                      size: 12.sp,
                                      color: kBlackLightColor,
                                    ),
                                    SizedBox(width: 4.w),
                                    Expanded(
                                      child: Text(
                                        "${request!.location}, ${request.cityName}",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: kBlackLightColor,
                                          height: 1.3,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Icon(
                                      MaterialCommunityIcons.phone,
                                      size: 12.sp,
                                      color: kBlackLightColor,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      request.phoneNumber?.phoneNumber ?? '',
                                      style: TextStyle(
                                        color: kBlackLightColor,
                                        height: 1.3,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4.h),
                                // Title - Request Details
                                Text(
                                  "Property Request",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: kHeadingStyle,
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Purpose and Price Range on left
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 6),
                                            decoration: BoxDecoration(
                                              color: request.purpose == "Sell"
                                                  ? kAccentColor
                                                  : kLightBlueColor,
                                              borderRadius: kBorderRadius30,
                                            ),
                                            child: Text(
                                              "For${request.purpose}".tr.toUpperCase(),
                                              style: TextStyle(
                                                  color: kWhiteColor, fontSize: 9.sp),
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            "${getPrice(request.startPrice!)} - ${getPrice(request.endPrice!)}",
                                            textDirection: TextDirection.ltr,
                                            style: kTextStyle18.copyWith(
                                              color: kPrimaryColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.sp,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Area info on right
                                    Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.map_pin_ellipse,
                                          size: 16.sp,
                                          color: kBlackLightColor,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          "${request.area} ${"Marla".tr}",
                                          style: kTextStyle14.copyWith(
                                              color: kBlackLightColor),
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

                    // Request info container
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
                          if (request.floors! > 0 && request.floors != null)
                            Expanded(
                              child: _buildRequestInfoItem(
                                icon: "assets/images/floor.png",
                                label: "${request.floors} ${"Floors".tr}",
                              ),
                            ),
                          if (request.floors! > 0 && request.bedrooms! > 0)
                            _buildVerticalDivider(),
                          if (request.bedrooms! > 0 && request.bedrooms != null)
                            Expanded(
                              child: _buildRequestInfoItem(
                                icon: "assets/images/bedroom.png",
                                label: "${request.bedrooms} ${"Beds".tr}",
                              ),
                            ),
                          if (request.bedrooms! > 0 && request.baths! > 0)
                            _buildVerticalDivider(),
                          if (request.baths! > 0 && request.baths != null)
                            Expanded(
                              child: _buildRequestInfoItem(
                                icon: "assets/images/shower.png",
                                label: "${request.baths} ${"Baths".tr}",
                              ),
                            ),
                          if (request.baths! > 0 && request.kitchens! > 0)
                            _buildVerticalDivider(),
                          if (request.kitchens! > 0 && request.kitchens != null)
                            Expanded(
                              child: _buildRequestInfoItem(
                                icon: "assets/images/kitchen.png",
                                label: "${request.kitchens} ${"Kitchens".tr}",
                              ),
                            ),
                          if (request.kitchens! > 0 &&
                              request.furnished != "" &&
                              request.furnished != null)
                            _buildVerticalDivider(),
                          if (request.furnished != "" && request.furnished != null)
                            Expanded(
                              child: _buildRequestInfoItem(
                                icon: "assets/images/furnished.png",
                                label: "${request.furnished!.tr} ${"Furnished".tr}",
                              ),
                            ),
                        ],
                      ),
                    ),

                    // Tab section
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
                                  'LOCATION',
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
                        ],
                      ),
                    ),

                    Obx(() {
                      switch (controller.selectedTabIndex.value) {
                        case 0:
                          return _buildInformationTab(request);
                        case 1:
                          return _buildLocationTab(request);
                        default:
                          return _buildInformationTab(request);
                      }
                    }),

                    // Description section (if needed)
                    SizedBox(height: 20.h),

                    // Action buttons section
                    Container(
                      width: 1.sw,
                      padding: kScreenPadding,
                      child: Row(
                        children: [
                          Expanded(
                            child: ButtonWidget(
                              onPressed: () async {
                                showConfirmationDialog(
                                  onConfirm: () {
                                    var addRequestController =
                                    Get.put(AddRequestController());
                                    addRequestController.deleteRequest(request: request);
                                    Get.back();
                                  },
                                  title: "Delete",
                                  message: "AreYouSureToDeleteThisRequest",
                                  textConfirm: "Yes",
                                  textCancel: "No",
                                );
                              },
                              text: "Delete",
                              color: kRedColor,
                            ),
                          ),
                          kHorizontalSpace4,
                          Expanded(
                            child: ButtonWidget(
                              onPressed: () async {
                                var addRequestController =
                                Get.put(AddRequestController());
                                addRequestController.request = request;
                                addRequestController.selectedType =
                                    addRequestController.typeController.typeModel
                                        .value.types
                                        .firstWhere((element) =>
                                    element.typeId == request.typeId);
                                addRequestController.selectedSubtype =
                                    addRequestController.selectedType!.subTypes
                                        .firstWhere((element) =>
                                    element.subTypeId == request.subTypeId);
                                await Get.toNamed(Routes.requestPropertyScreen);
                                Get.back();
                              },
                              text: "Edit",
                              color: kAccentColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        )
            : CircularLoader();
      }),
    );
  }

  Widget _buildRequestInfoItem({required String icon, required String label}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          icon,
          width: 20.w,
          height: 20.w,
          color: kTableColor,
        ),
        SizedBox(height: 6.h),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kTableColor,
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: double.infinity,
      color: Colors.white,
    );
  }

  Widget _buildInformationTab(request) {
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
            _buildStyledRow("Purpose", request.purpose!, 0),
            _buildStyledRow("Location", "${request.location}, ${request.cityName}", 1),
            _buildStyledRow("Area", "${request.area} ${"Marla".tr}", 2),
            //_buildStyledRow("Phone", request.phoneNumber!, 3),
            _buildStyledRow("Price Range",
                "${getPrice(request.startPrice!)} - ${getPrice(request.endPrice!)}", 4),
            if (request.floors! > 0)
              _buildStyledRow("Floors", "${request.floors}", 5),
            if (request.bedrooms! > 0)
              _buildStyledRow("Bedrooms", "${request.bedrooms}", 6),
            if (request.baths! > 0)
              _buildStyledRow("Bathrooms", "${request.baths}", 7),
            if (request.kitchens! > 0)
              _buildStyledRow("Kitchens", "${request.kitchens}", 8),
            if (request.furnished != "" && request.furnished != null)
              _buildStyledRow("Furnished", request.furnished!, 9),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationTab(request) {
    return Padding(
      padding: kHorizontalScreenPadding,
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
                  "${request.location}, ${request.cityName}".tr,
                  style: kTextStyle16.copyWith(color: kAccentColor),
                ),
              ),
              kHorizontalSpace12,
              GestureDetector(
                onTap: () async {
                  var uri = Uri.parse(
                      "https://www.google.com/maps/search/?api=1&query=${request.coordinates}");
                  if (await canLaunch(uri.toString())) {
                    await launch(uri.toString());
                  } else {
                    print('Could not launch ${uri.toString()}');
                  }
                },
                child: ImageWidget(
                  gSelectedCountry!.mapImage,
                  width: 80.w,
                  height: 130.h,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
}
