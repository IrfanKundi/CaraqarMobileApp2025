import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/car_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/ui/screens/vehicle/vehicle_home_screen.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/small_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CarsScreen extends GetView<CarController> {
  CarsScreen({Key? key}) : super(key: key) {}

  @override
  Widget build(BuildContext context) {
    String? title = Get.parameters["title"];

    return Scaffold(
      appBar: buildAppBar(context, title: title ?? "AllCars"),
      body: const AllCars(),
    );
  }
}

class AllCars extends StatelessWidget {
  const AllCars({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CarController>(
      builder:
          (controller) => Column(
            children: [
              Padding(
                padding: kScreenPadding,
                child: Column(
                  children: [
                    // Search bar at the top
                    Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search for cars",
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[500],
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[500],
                            size: 20.sp,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                        ),
                      ),
                    ),
                    kVerticalSpace12,
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: SmallButtonWidget(
                            height: 30.h,
                            color: kMehrunColor,
                            text: "Sort",
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.r),
                                  ),
                                ),
                                builder: (BuildContext context) {
                                  return Container(
                                    padding: EdgeInsets.all(20.w),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Handle bar
                                        Container(
                                          width: 40.w,
                                          height: 4.h,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius: BorderRadius.circular(2.r),
                                          ),
                                        ),
                                        SizedBox(height: 20.h),

                                        // Title
                                        Text(
                                          "Sort By",
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold,
                                            color: kBlackColor,
                                          ),
                                        ),
                                        SizedBox(height: 20.h),

                                        // Sort options
                                        _buildSortOption("Date Updated (New to Old)"),
                                        _buildSortOption("Date Updated (Old to New)"),
                                        _buildSortOption("Price (High to Low)"),
                                        _buildSortOption("Price (Low to High)"),
                                        _buildSortOption("Manufactured Year (New to Old)"),
                                        _buildSortOption("Manufactured Year (Old to New)"),
                                        _buildSortOption("Mileage (High to Low)"),
                                        _buildSortOption("Mileage (Low to High)"),
                                        SizedBox(height: 20.h),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            icon: Icons.sort,
                          ),
                        ),

                        SizedBox(width: 8.w), // Reduced spacing

                        Expanded(
                          flex: 5, // Increased from 4 to 5 to maintain proportion
                          child: SmallButtonWidget(
                            height: 30.h,
                            color: kAccentColor,
                            text: "Filter",
                            onPressed: () {
                             // Get.toNamed(Routes.carFilterScreen);
                            },
                            icon: MaterialCommunityIcons.filter_variant,
                          ),
                        ),

                        SizedBox(width: 4.w), // Reduced spacing

                        // Grid/List toggle button
                        IconButtonWidget(
                          color: kAccentColor,
                          width: 20,
                          onPressed: () {
                            controller.isGridView = !controller.isGridView;
                            controller.update();
                            controller.page.value = 1;
                            controller.getFilteredCars();
                          },
                          icon: controller.isGridView
                              ? FontAwesomeIcons.list
                              : FontAwesomeIcons.grip,
                        ),
                      ],
                    ),

                    kVerticalSpace8, // Space before showing text

                    // Showing X Ads text on the next line
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "${"Showing".tr} ${controller.totalAds} ${"Ads".tr.toLowerCase()}",
                        style: TextStyle(fontSize: 13.sp, color: kBlackColor),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: NotificationListener<ScrollEndNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.atEdge &&
                        notification.metrics.pixels ==
                            notification.metrics.maxScrollExtent &&
                        controller.loadMore.value) {
                      controller.page.value += 1;
                      controller.getFilteredCars();
                    }
                    return true;
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child:
                            controller.status.value == Status.loading
                                ? CircularLoader()
                                : controller.status.value == Status.error
                                ? Text(
                                  kCouldNotLoadData.tr,
                                  style: kTextStyle16,
                                )
                                : controller.cars.value.isEmpty
                                ? Text("NoDataFound".tr, style: kTextStyle16)
                                : controller.isGridView
                                ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: GridView.builder(
                                    padding: EdgeInsets.zero,
                                    // Remove shrinkWrap: true
                                    itemCount: controller.cars.value.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisExtent: 310.h,
                                          // Use fixed height instead of aspectRatio
                                          crossAxisSpacing: 0.w,
                                          mainAxisSpacing: 0.w,
                                        ),
                                    itemBuilder: (context, index) {
                                      var item = controller.cars.value[index];
                                      return CarItem(
                                        item: item,
                                        isGridView: true,
                                      );
                                    },
                                  ),
                                )
                                : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  // Remove shrinkWrap: true here too
                                  itemCount: controller.cars.value.length,
                                  itemBuilder: (context, index) {
                                    var item = controller.cars.value[index];
                                    return CarItem(
                                      item: item,
                                      isGridView: false,
                                    );
                                  },
                                ),
                      ),
                      controller.isLoadingMore.value
                          ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.w),
                            child: CircularLoader(),
                          )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
  }
  Widget _buildSortOption(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          color: kBlackColor,
        ),
      ),
    );
  }
}
