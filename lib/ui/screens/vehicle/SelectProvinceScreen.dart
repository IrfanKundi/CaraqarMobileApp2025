import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
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
      backgroundColor: Colors.grey[50],
      appBar: buildAppBar(context, title: "Registered In"),
      body: GetBuilder<CityController>(
        builder:
            (cityController) =>
        cityController.status.value == Status.loading
            ? CircularLoader()
            : cityController.status.value == Status.error
            ? Text(kCouldNotLoadData, style: kTextStyle16)
            : Column(
          children: [
            // Search Field
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (val) => cityController.search(val),
                        decoration: InputDecoration(
                          hintText: "Search".tr,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ),

            // Cities List
            Expanded(
              child: cityController.searchedCities.isEmpty
                  ? Center(
                child: Text(
                  "NoDataFound".tr,
                  style: kTextStyle16,
                ),
              )
                  : ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: cityController.searchedCities.length,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  var item = cityController.searchedCities[index];
                  bool isSelected = controller.cityId == item.cityId;

                  return InkWell(
                    onTap: () async {
                      //controller.city = item;
                      //controller.registrationCityId = item.cityId;
                      // Navigate to location screen
                      final selectedLocation = await Get.toNamed(
                        Routes.selectAdLocationScreen,
                        parameters: {
                          "cityId": item.cityId.toString(),
                          "title": "Registration City",
                        },
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
                          Routes.selectCityScreen,
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: isSelected ? kLightBlueColor : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                              ? kLightBlueColor
                              : Colors.grey.shade200,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(height: 40),
                          Expanded(
                            child: Text(
                              item.name!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(
                            Get.locale?.languageCode == "ar"
                                ? MaterialCommunityIcons.chevron_left
                                : MaterialCommunityIcons.chevron_right,
                            color: isSelected
                                ? Colors.white.withOpacity(0.7)
                                : Colors.grey.shade400,
                            size: 20,
                          ),
                        ],
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

