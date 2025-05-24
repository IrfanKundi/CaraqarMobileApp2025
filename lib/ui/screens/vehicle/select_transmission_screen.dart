import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';

class SelectTransmissionScreen extends GetView<VehicleController> {
  const SelectTransmissionScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: buildAppBar(context,title: "SelectGearType"),
      body: ListView.separated(
        separatorBuilder: (context,index)=>kVerticalSpace12,
    itemCount: Transmission.values.length,

    padding: kScreenPadding,
    itemBuilder: (context,index) {
      var e = EnumToString.convertToString(Transmission.values[index]);
      return InkWell(
        onTap: () {
          if (controller.vehicleType == VehicleType.Car) {
            controller.transmission = e;
            if(Get.arguments==true){
              Navigator.pop(context,e);
            }else{
              Get.toNamed(Routes.selectFuelTypeScreen);
            }

          }
        },
        child: Container(
          height: 70.h,
          decoration: BoxDecoration(
            color: controller.transmission==e?kLightBlueColor:null,
            border: Border.all(color: controller.transmission==e?kLightBlueColor:kGreyColor),
            borderRadius: kBorderRadius12,
          ),
          padding: EdgeInsets.all(8.w),
          child: Center(
            child: Text(
              "${e}".tr,
              textAlign: TextAlign.center,
              style: TextStyle(color: kBlackColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 18.sp),
            ),
          ),
        ),
      );
    }
    ),
    );
  }
}
