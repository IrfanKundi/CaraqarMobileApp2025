import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';

class ChooseAdTypeScreen extends GetView<VehicleController> {
  const ChooseAdTypeScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: buildAppBar(context, title: "ChooseYourOfferType"),
      body: Padding(
        padding: kScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sell Option
            _buildOfferCard(
              context: context,
              title: "FOR SELL",
              svgPath: _getSellSvgPath(),
              svgWidth: 84.w,
              svgHeight: 84.w,
              onTap: () {
                controller.purpose = EnumToString.convertToString(Purpose.Sell);
                if (Get.arguments == true) {
                  Navigator.pop(context);
                } else if (VehicleType.NumberPlate == controller.vehicleType) {
                  Get.toNamed(Routes.enterNumberScreen);
                } else {
                  Get.toNamed(Routes.chooseBrandScreen);
                }
              },
            ),

            // Rent Option (only for cars)
            if (controller.vehicleType == VehicleType.Car) ...[
              SizedBox(height: 16.h),
              _buildOfferCard(
                context: context,
                title: "FOR RENT",
                svgPath: _getSellSvgPath(),
                svgWidth: 84.w,
                svgHeight: 84.w,
                onTap: () {
                  controller.purpose =
                      EnumToString.convertToString(Purpose.Rent);
                  if (Get.arguments == true) {
                    Navigator.pop(context);
                  } else
                  if (VehicleType.NumberPlate == controller.vehicleType) {
                    Get.toNamed(Routes.enterNumberScreen);
                  } else {
                    Get.toNamed(Routes.chooseBrandScreen);
                  }
                },
              ),
            ],

            SizedBox(height: 24.h),

            // Wanted Option
            _buildOfferCard(
              context: context,
              title: "REQUIRE",
              svgPath: _getSellSvgPath(),
              svgWidth: 84.w,
              svgHeight: 84.w,
              onTap: () {
                controller.purpose = EnumToString.convertToString(Purpose.Rent);
                if (Get.arguments == true) {
                  Navigator.pop(context);
                } else if (VehicleType.NumberPlate == controller.vehicleType) {
                  Get.toNamed(Routes.enterNumberScreen);
                } else {
                  Get.toNamed(Routes.chooseBrandScreen);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferCard({
    required BuildContext context,
    required String title,
    required String svgPath,
    required VoidCallback onTap,
    double? width,
    double? height,
    double? svgWidth,
    double? svgHeight,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 120.h,
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
                title.tr,
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

  String _getSellSvgPath() {
    if (controller.vehicleType == VehicleType.Bike) {
      return "assets/icon/motorcycle.svg";
    }else if(controller.vehicleType == VehicleType.Car) {
      return "assets/icon/car.svg";
    }
    return "assets/icon/numberplate.svg";
  }

}