import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/city_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:flutter/cupertino.dart';

import '../../../controllers/vehicle_controller.dart';
import '../../../routes.dart';

class SelectProvinceScreen extends GetView<VehicleController> {
  SelectProvinceScreen({super.key}) {
    Get.lazyPut(() => CityController(), fenix: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: "Registration Province"),
      body: GetBuilder<CityController>(
        builder:
            (cityController) =>
        cityController.status.value == Status.loading
            ? CircularLoader()
            : cityController.status.value == Status.error
            ? Text(kCouldNotLoadData, style: kTextStyle16)
            : Column(
          children: [
            Padding(
              padding: kHorizontalScreenPadding,
              child: CupertinoSearchTextField(
                onChanged: (val) => cityController.search(val),
                placeholder: "Search".tr,
              ),
            ),
            Expanded(
              child: cityController.searchedCities.isEmpty
                  ? Center(
                child: Text(
                  "NoDataFound".tr,
                  style: kTextStyle16,
                ),
              )
                  : ListView.separated(
                padding: kScreenPadding,
                itemCount: cityController.searchedCities.length,
                separatorBuilder: (context, index) => kVerticalSpace12,
                itemBuilder: (context, index) {
                  var item = cityController.searchedCities[index];
                  return InkWell(
                    onTap: () async {
                      //controller.city = item;
                      //controller.registrationCityId = item.cityId;
                      // Navigate to location screen
                      final selectedLocation = await Get.toNamed(
                        Routes.selectAdLocationScreen,
                        parameters: {"cityId": item.cityId.toString()},
                      );
                      if (selectedLocation == null) return; // user cancelled
                      if (Get.arguments == true) {
                        Get.back(result: {
                          'registrationCityId': selectedLocation.locationId,
                        });
                      } else {
                        // Continue to next screen
                        controller.province= selectedLocation.title;
                        controller.registrationCityId = selectedLocation.locationId;
                        Get.toNamed(
                          Routes.selectRegistrationYearScreen,
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller.cityId == item.cityId
                            ? kLightBlueColor
                            : null,
                        border: Border.all(
                          color: controller.cityId == item.cityId
                              ? kLightBlueColor
                              : kGreyColor,
                        ),
                        borderRadius: kBorderRadius12,
                      ),
                      padding: EdgeInsets.all(8.w),
                      child: Text(
                        item.name!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kBlackColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

