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

// Screen
class SelectRegistrationYearScreen extends GetView<VehicleController> {
  const SelectRegistrationYearScreen({Key? key}) : super(key: key);

  List<String> _generateYears() {
    List<String> years = [];
    for (int year = 2025; year >= 1980; year--) {
      years.add(year.toString());
    }
    return years;
  }

  @override
  Widget build(BuildContext context) {
    final years = _generateYears();

    return Scaffold(
      appBar: buildAppBar(context, title: "Registration Year"),
      body: ListView.separated(
        separatorBuilder: (context, index) => kVerticalSpace12,
        itemCount: years.length,
        padding: kScreenPadding,
        itemBuilder: (context, index) {
          final year = years[index];

          return GetBuilder<VehicleController>(
            builder: (controller) {
              return InkWell(
                onTap: () {
                  controller.registrationYear = year;
                  controller.update();
                  if (Get.arguments == true) {
                    Navigator.pop(context, year);
                  } else {
                    Get.toNamed(
                      Routes.selectConditionScreen,
                    );
                  }
                },
                child: Container(
                  height: 70.h,
                  decoration: BoxDecoration(
                    color: controller.registrationYear == year ? kLightBlueColor : null,
                    border: Border.all(
                        color: controller.registrationYear == year ? kLightBlueColor : kGreyColor),
                    borderRadius: kBorderRadius12,
                  ),
                  padding: EdgeInsets.all(8.w),
                  child: Center(
                    child: Text(
                      year,
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
          );
        },
      ),
    );
  }
}