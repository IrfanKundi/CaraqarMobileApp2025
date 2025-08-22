import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';

class SelectColorScreen extends GetView<VehicleController> {
  const SelectColorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: buildAppBar(context,title: "SelectColor"),
        body: ListView.separated(
            padding: EdgeInsets.all(16),
            itemCount: gVehicleColors.length,
            separatorBuilder: (context,index){
              return SizedBox(height: 12);
            },
            itemBuilder: (context, index) {
              var item = gVehicleColors[index];
              bool isSelected = controller.color==item.name;

              return InkWell(
                  onTap: (){
                    controller.color = item.name;
                    if(Get.arguments==true){
                      Navigator.pop(context,item);
                    }else {
                      Get.toNamed(Routes.selectPaymentMethodScreen);
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
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: item.color,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.name.tr,
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
            }
        )
    );
  }
}
