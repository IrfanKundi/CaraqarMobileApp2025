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
      backgroundColor: Colors.grey[50],
      appBar: buildAppBar(context, title: "Registration Year"),
      body: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemCount: years.length,
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final year = years[index];

          return GetBuilder<VehicleController>(
            builder: (controller) {
              bool isSelected = controller.registrationYear == year;

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
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.calendar_today_outlined,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade600,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          year,
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
          );
        },
      ),
    );
  }
}