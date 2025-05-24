import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';

class SelectColorScreen extends GetView<VehicleController> {
   const SelectColorScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: buildAppBar(context,title: "SelectColor"),
      body:  ListView.separated(
          padding: kScreenPadding,
          itemCount: gVehicleColors.length,
          separatorBuilder: (context,index){
            return kVerticalSpace12;
          },
          itemBuilder: (context, index) {
            var item = gVehicleColors[index];
            return InkWell(
                onTap: (){
                  controller.color = item.name;
    if(Get.arguments==true){
      Navigator.pop(context,item);
    }else {

      Get.toNamed(Routes.selectPaymentMethodScreen);
    }

                },
                child:Container(
                    decoration: BoxDecoration(
                      color: controller.color==item.name?kLightBlueColor:null,
                      border: Border.all(color: controller.color==item.name?kLightBlueColor:kGreyColor),
                      borderRadius: kBorderRadius12,
                    ),
                    padding: EdgeInsets.all(8.w),
                    child:Row(
                      children: [
                        Container(width: 20.w,height: 20.w,decoration: BoxDecoration(
                          shape: BoxShape.circle,color: item.color,
                        ),),
                        kHorizontalSpace12,
                        Text(item.name.tr),
                      ],
                    )));

          }
      )
    );
  }
}
