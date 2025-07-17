// Add this enum to your enums file
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../constants/colors.dart';
import '../../../constants/style.dart';
import '../../../controllers/vehicle_controller.dart';
import '../../../routes.dart';
import '../../widgets/app_bar.dart';

enum VehicleOrigin { Imported, Local }

// Screen
class SelectOriginScreen extends GetView<VehicleController> {
  const SelectOriginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: "Vehicle Origin"),
      body: ListView.separated(
        separatorBuilder: (context, index) => kVerticalSpace12,
        itemCount: VehicleOrigin.values.length,
        padding: kScreenPadding,
        itemBuilder: (context, index) {
          var e = EnumToString.convertToString(VehicleOrigin.values[index]);
          return InkWell(
            onTap: () {
              controller.origin = e;
              if (Get.arguments == true) {
                Navigator.pop(context, e);
              } else {
                Get.toNamed(
                  Routes.selectProvinceScreen,
                );
              }
            },
            child: Container(
              height: 70.h,
              decoration: BoxDecoration(
                color: controller.origin == e ? kLightBlueColor : null,
                border: Border.all(
                    color: controller.origin == e ? kLightBlueColor : kGreyColor),
                borderRadius: kBorderRadius12,
              ),
              padding: EdgeInsets.all(8.w),
              child: Center(
                child: Text(
                  "${e}".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: kBlackColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}