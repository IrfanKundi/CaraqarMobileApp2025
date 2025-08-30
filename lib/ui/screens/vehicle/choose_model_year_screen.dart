import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';

class ChooseModelYearScreen extends GetView<VehicleController> {
  ChooseModelYearScreen({super.key}){
    getYears();
  }

  List<String> searchedYears = [];

  List<String> years = [];
  search(String text){
    searchedYears.clear();
    searchedYears.addAll(
        years.where((b) =>b.contains(text.trim())).toList()
    );
    controller.update(["modelYears"]);
  }
  getYears(){
    int startYear=DateTime.now().year;
    int endYear=1960;

    while(startYear>=endYear){
      years.add("$startYear");
      startYear--;
    }
    searchedYears.addAll(years);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: buildAppBar(context,title: "Choose Model Year"),
      body: Column(
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
                      onChanged: (val) => search(val),
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

          // Years List
          Expanded(
            child: GetBuilder<VehicleController>(
                id: "modelYears",
                builder: (controller) {
                  return ListView.separated(
                    separatorBuilder: (context,index){
                      return SizedBox(height: 12);
                    },
                    itemCount: searchedYears.length,
                    padding: EdgeInsets.all(16),
                    itemBuilder: (context,index){
                      var e = searchedYears[index];
                      bool isSelected = controller.modelYear==e;

                      return InkWell(
                          onTap: (){
                            if(Get.arguments==true){
                              controller.modelYear = e;
                              Navigator.pop(context,e);
                            }else {
                              controller.modelYear = e;
                              Get.toNamed(Routes.selectRegistrationYearScreen);
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
                                    e,
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
                          )
                      );
                    },
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}
