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

class SelectPlateDigitsScreen extends GetView<VehicleController> {
  const SelectPlateDigitsScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: buildAppBar(context,title: "SelectPlateDigits"),
      body:  ListView.separated(
         separatorBuilder: (context,index)=>kVerticalSpace12,
          itemCount: numberPlateTypes.length,

          padding: kScreenPadding,
        itemBuilder: (context,index){
         var e =  numberPlateTypes[index];
           return InkWell(
             onTap: (){
               controller.digits = e.id;
               if(Get.arguments==true){
                 Navigator.pop(context,e.id);
               }else {
                 Get.offNamed(Routes.selectPlateTypeScreen);
               }
             },
             child: Container(
               height: 70.h,
               decoration: BoxDecoration(
                 color: controller.digits==e.id?kLightBlueColor:null,
                 border: Border.all(color: controller.digits==e.id?kLightBlueColor:kGreyColor),
                 borderRadius: kBorderRadius12,
               ),
               padding: EdgeInsets.all(8.w),
               child: Center(
                 child: Text(
                   "${e.title}".tr,
                   textAlign: TextAlign.center,
                   style: TextStyle(color: kBlackColor, fontWeight: FontWeight.w700, fontSize: 18.sp),
                 ),
               ),
             ),
           );
        },
          ),
    );
  }
}
