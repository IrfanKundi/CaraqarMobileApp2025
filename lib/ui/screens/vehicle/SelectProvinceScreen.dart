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

enum VehicleProvince {
  Balochistan,
  KhyberPakhtunkhwa,
  Punjab,
  Sindh,
  IslamabadCapitalTerritory
}

// Screen
class SelectProvinceScreen extends GetView<VehicleController> {
  const SelectProvinceScreen({Key? key}) : super(key: key);

  String _getProvinceDisplayName(VehicleProvince province) {
    switch (province) {
      case VehicleProvince.Balochistan:
        return "Balochistan";
      case VehicleProvince.KhyberPakhtunkhwa:
        return "Khyber Pakhtunkhwa";
      case VehicleProvince.Punjab:
        return "Punjab";
      case VehicleProvince.Sindh:
        return "Sindh";
      case VehicleProvince.IslamabadCapitalTerritory:
        return "Islamabad Capital";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: "Registration Province"),
      body: ListView.separated(
        separatorBuilder: (context, index) => kVerticalSpace12,
        itemCount: VehicleProvince.values.length,
        padding: kScreenPadding,
        itemBuilder: (context, index) {
          var province = VehicleProvince.values[index];
          var provinceString = EnumToString.convertToString(province);
          var displayName = _getProvinceDisplayName(province);

          return InkWell(
            onTap: () {
              controller.province = provinceString;
              if (Get.arguments == true) {
                Navigator.pop(context, provinceString);
              } else {
                Get.toNamed(
                  Routes.selectRegistrationYearScreen,
                );
              }

            },
            child: Container(
              height: 70.h,
              decoration: BoxDecoration(
                color: controller.province == provinceString ? kLightBlueColor : null,
                border: Border.all(
                    color: controller.province == provinceString ? kLightBlueColor : kGreyColor),
                borderRadius: kBorderRadius12,
              ),
              padding: EdgeInsets.all(8.w),
              child: Center(
                child: Text(
                  displayName.tr,
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