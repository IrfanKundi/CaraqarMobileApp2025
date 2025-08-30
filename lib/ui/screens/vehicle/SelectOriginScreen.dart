import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
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
      backgroundColor: Colors.grey[50],
      appBar: buildAppBar(context, title: "Vehicle Assembly"),
      body: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemCount: VehicleOrigin.values.length,
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          var e = EnumToString.convertToString(VehicleOrigin.values[index]);
          bool isSelected = controller.origin == e;

          return InkWell(
            onTap: () {
              controller.origin = e;
              if (Get.arguments == true) {
                Navigator.pop(context, e);
              } else {
                if (e.toLowerCase() == "imported") {
                  Get.toNamed(Routes.importYearScreen);
                } else {
                  Get.toNamed(Routes.chooseModelYearScreen);
                }
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
                      e.tr,
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
    );
  }
}