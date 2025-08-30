import 'package:careqar/constants/colors.dart';
import 'package:careqar/controllers/vehicle_controller.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class ImportYearScreen extends GetView<VehicleController> {
  const ImportYearScreen({Key? key}) : super(key: key);

  List<String> get yearsList {
    final currentYear = DateTime.now().year;
    return List.generate(
        currentYear - 1940 + 1,
            (index) => (currentYear - index).toString()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: buildAppBar(context, title: "Import Year"),
      body: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(height: 12),
        itemCount: yearsList.length,
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          String year = yearsList[index];
          bool isSelected = controller.importYear == year;

          return InkWell(
            onTap: () {
              controller.importYear = year;
              if (Get.arguments == true) {
                Navigator.pop(context, year);
              } else {
                Get.toNamed(Routes.chooseModelYearScreen);
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
      ),
    );
  }
}