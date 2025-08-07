import 'package:cached_network_image/cached_network_image.dart';
import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/add_property_controller.dart';
import 'package:careqar/controllers/view_my_property_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/services/dynamic_link.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../global_variables.dart';

class ViewMyPropertyScreen extends GetView<ViewMyPropertyController> {
  ViewMyPropertyScreen({super.key}) {
    //print(Get.arguments);
  }

  @override
  Widget build(BuildContext context) {
    String? mapImage = gSelectedCountry?.mapImage;
    String cleanedMapImage = mapImage!.replaceAll('\r\n', '');
    return Obx(() {
      var property = controller.property.value;
      List<String> coords = property!.coordinates.split(',');
      double pLatitude = double.parse(coords[0].trim());
      double pLongitude = double.parse(coords[1].trim());

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
                    uri: "/property?propertyId=${property.propertyId}",
                    title: property.title,
                    desc: property.description,
                    image: property.images.first,
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
                        // Rounded image slider
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
                            items: property.images.map((item) {
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

                        // Page indicator
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
                          // Left: Location on top + Title below
                          Expanded(
                            flex: 6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Location and status row
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
                                        "${property.location}, ${property.cityName}",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: kBlackLightColor,
                                          height: 1.3,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    if (!property.isSold!)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: property.status == "Approved"
                                              ? kSuccessColor
                                              : Colors.orangeAccent,
                                          borderRadius: kBorderRadius30,
                                        ),
                                        child: Text(
                                          " ${property.status}".tr,
                                          style: TextStyle(
                                              color: kWhiteColor, fontSize: 10.sp),
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
                                SizedBox(height: 4.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Purpose and Price on left
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 6),
                                            decoration: BoxDecoration(
                                              color: property.purpose == "Sell"
                                                  ? kAccentColor
                                                  : kLightBlueColor,
                                              borderRadius: kBorderRadius30,
                                            ),
                                            child: Text(
                                              "For${property.purpose}".tr.toUpperCase(),
                                              style: TextStyle(
                                                  color: kWhiteColor, fontSize: 9.sp),
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            getPrice(property.price!),
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
                                          "${property.area} ${"Marla".tr}",
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

                    // Property info container
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
                          if (property.floors! > 0 && property.floors != null)
                            Expanded(
                              child: _buildPropertyInfoItem(
                                icon: "assets/images/floor.png",
                                label: "${property.floors} ${"Floors".tr}",
                              ),
                            ),
                          if (property.floors! > 0 && property.bedrooms! > 0)
                            _buildVerticalDivider(),
                          if (property.bedrooms! > 0 && property.bedrooms != null)
                            Expanded(
                              child: _buildPropertyInfoItem(
                                icon: "assets/images/bedroom.png",
                                label: "${property.bedrooms} ${"Beds".tr}",
                              ),
                            ),
                          if (property.bedrooms! > 0 && property.baths! > 0)
                            _buildVerticalDivider(),
                          if (property.baths! > 0 && property.baths != null)
                            Expanded(
                              child: _buildPropertyInfoItem(
                                icon: "assets/images/shower.png",
                                label: "${property.baths} ${"Baths".tr}",
                              ),
                            ),
                          if (property.baths! > 0 && property.kitchens! > 0)
                            _buildVerticalDivider(),
                          if (property.kitchens! > 0 && property.kitchens != null)
                            Expanded(
                              child: _buildPropertyInfoItem(
                                icon: "assets/images/kitchen.png",
                                label: "${property.kitchens} ${"Kitchens".tr}",
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

                    // Description section
                    Padding(
                      padding: kScreenPadding,
                      child: Column(
                        children: [
                          Text(
                            "DESCRIPTION".tr.toUpperCase(),
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

                    // Comments section
                    Padding(
                      padding: kHorizontalScreenPadding,
                      child: GetBuilder<ViewMyPropertyController>(
                        id: "comments",
                        builder: (controller) => Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
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
                                          ImageWidget(
                                            item.image ?? "assets/images/profile2.jpg",
                                            isLocalImage: item.image == null,
                                            width: 40.r,
                                            height: 40.r,
                                            isCircular: true,
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                        locale: gSelectedLocale
                                                            ?.locale?.languageCode,
                                                      ),
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12.sp,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 6.h),
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
                    ),

                    // Action buttons section
                    Container(
                      width: 1.sw,
                      padding: kScreenPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ButtonWidget(
                                  onPressed: () async {
                                    var addPropertyController =
                                    Get.put(AddPropertyController());
                                    addPropertyController.refreshProperty(
                                        property: property);
                                  },
                                  text: "Refresh",
                                  color: kPrimaryColor,
                                ),
                              ),
                              kHorizontalSpace4,
                              Expanded(
                                child: ButtonWidget(
                                  onPressed: () async {
                                    var addPropertyController =
                                    Get.put(AddPropertyController());
                                    addPropertyController.property = property;
                                    addPropertyController.selectedType =
                                        addPropertyController.typeController
                                            .typeModel.value.types
                                            .firstWhere((element) =>
                                        element.typeId == property.typeId);
                                    addPropertyController.selectedSubtype =
                                        addPropertyController.selectedType!
                                            .subTypes
                                            .firstWhere((element) =>
                                        element.subTypeId ==
                                            property.subTypeId);
                                    addPropertyController.images.value
                                        .addAll(property.images);
                                    await Get.toNamed(Routes.addPropertyScreen);
                                    Get.back();
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
                                        var addPropertyController =
                                        Get.put(AddPropertyController());
                                        addPropertyController.deleteProperty(
                                            property: property);
                                        Get.back();
                                      },
                                      title: "Delete",
                                      message: "AreYouSureToDeleteThisProperty",
                                      textConfirm: "Yes",
                                      textCancel: "No",
                                    );
                                  },
                                  text: "Delete",
                                  color: kRedColor,
                                ),
                              ),
                              kHorizontalSpace4,
                              property.status == "Approved" && !property.isSold!
                                  ? Expanded(
                                child: ButtonWidget(
                                  onPressed: () async {
                                    showConfirmationDialog(
                                      onConfirm: () {
                                        var addPropertyController =
                                        Get.put(AddPropertyController());
                                        addPropertyController.soldOutProperty(
                                            property: property);
                                        Get.back();
                                      },
                                      title: "SoldOut",
                                      message: "AreYouSureToSoldThisProperty",
                                      textConfirm: "Yes",
                                      textCancel: "No",
                                    );
                                  },
                                  text: "SoldOut",
                                  color: kLightBlueColor,
                                ),
                              )
                                  : Container()
                            ],
                          )
                        ],
                      ),
                    )
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

  Widget _buildPropertyInfoItem({required String icon, required String label}) {
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
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: double.infinity,
      color: Colors.white,
    );
  }

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
            //_buildStyledRow("Title", property.title!, 0),
            _buildStyledRow("Location", "${property.location}, ${property.cityName}", 1),
            _buildStyledRow("Area", "${property.area} ${"Marla".tr}", 2),
            _buildStyledRow("Purpose", property.purpose!, 3),
            _buildStyledRow("Price", getPrice(property.price!), 4),
            if (property.floors! > 0)
              _buildStyledRow("Floors", "${property.floors}", 5),
            if (property.bedrooms! > 0)
              _buildStyledRow("Bedrooms", "${property.bedrooms}", 6),
            if (property.baths! > 0)
              _buildStyledRow("Bathrooms", "${property.baths}", 7),
            if (property.kitchens! > 0)
              _buildStyledRow("Kitchens", "${property.kitchens}", 8),
            if (property.furnished != "" && property.furnished != null)
              _buildStyledRow("Furnished", property.furnished!, 9),
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
                      Container(
                        child: Center(
                          child: ImageWidget(
                            e.features[index].image,
                            width: 30.w,
                            height: 30.w,
                          ),
                        ),
                      ),
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

  Widget _buildLocationTab(property, double pLatitude, double pLongitude) {
    return Padding(
      padding: kHorizontalScreenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(MaterialCommunityIcons.map_marker_outline,
                  color: kLightBlueColor, size: 22.sp),
              kHorizontalSpace8,
              Expanded(
                child: Text("${property.location}, ${property.cityName}".tr,
                    style: kTextStyle16.copyWith(color: kAccentColor)),
              ),
            ],
          ),
          kVerticalSpace16,
          GestureDetector(
            onTap: () async {
              var uri = Uri.parse("https://www.google.com/maps/search/?api=1&query=${property.coordinates}");
              if (await canLaunchUrl(uri)) {
                try {
                  await launchUrl(uri);
                } catch (e) {
                  print('Failed to launch Google Maps: $e');
                }
              } else {
                print('Could not launch ${uri.toString()}');
              }
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 2,
              child: Container(
                width: Get.width,
                height: 180.0,
                padding: const EdgeInsets.all(5.0),
                child: GoogleMap(
                  zoomGesturesEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                      target: LatLng(pLatitude, pLongitude),
                      zoom: 14
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


