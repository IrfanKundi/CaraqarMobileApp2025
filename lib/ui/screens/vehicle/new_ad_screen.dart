import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/remove_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';

class NewAdScreen extends GetView<VehicleController> {
  const NewAdScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: buildAppBar(context, title: "WhatDoYouWantToAdvertise"),
      body: RemoveSplash(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Car Option
              _buildVehicleCard(
                context: context,
                title: "CAR",
                svgPath: "assets/icon/car.svg",
                svgWidth: 90.w,
                svgHeight: 84.w,
                onTap: () {
                  controller.reset();
                  controller.vehicleType = VehicleType.Car;
                  Get.toNamed(Routes.chooseAdTypeScreen);
                },
              ),
              SizedBox(height: 24.h),

              // Bike Option
              _buildVehicleCard(
                context: context,
                title: "BIKE",
                svgPath: "assets/icon/motorcycle.svg",
                svgWidth: 72.w,
                svgHeight: 72.w,
                onTap: () {
                  controller.reset();
                  controller.vehicleType = VehicleType.Bike;
                  Get.toNamed(Routes.chooseAdTypeScreen);
                },
              ),
              SizedBox(height: 24.h),

              // Number Plate Option
              _buildVehicleCard(
                context: context,
                title: "NO.PLATE",
                svgPath: "assets/icon/numberplate.svg",
                svgWidth: 90.w,
                svgHeight: 74.w,
                onTap: () {
                  controller.reset();
                  controller.vehicleType = VehicleType.NumberPlate;
                  Get.toNamed(Routes.chooseAdTypeScreen);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleCard({
    required BuildContext context,
    required String title,
    required String svgPath,
    required VoidCallback onTap,
    double? svgWidth,
    double? svgHeight,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        height: 120.h,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.black87,
                ),
              ),
            ),
            SvgPicture.asset(
              svgPath,
              width: svgWidth ?? 48.w,
              height: svgHeight ?? 48.w,
              colorFilter: const ColorFilter.mode(
                Color(0xFF1E3A5F), // Navy blue color for icons
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
