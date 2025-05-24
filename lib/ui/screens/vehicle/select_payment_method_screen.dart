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

class SelectPaymentMethodScreen extends GetView<VehicleController> {
  const SelectPaymentMethodScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: buildAppBar(context,title: "SelectPaymentMethod"),
      body:  ListView.separated(
        separatorBuilder: (context,index)=>kVerticalSpace12,
    itemCount: PaymentMethod.values.length,

    padding: kScreenPadding,
    itemBuilder: (context,index) {
      var e =  EnumToString.convertToString(PaymentMethod.values[index]);
      return InkWell(
        onTap: () {

            controller.paymentMethod =e;
            if(Get.arguments==true){
              Navigator.pop(context,e);
            }else {
              Get.toNamed(Routes.selectCityScreen);
            }
        
        },
        child: Container(
          height: 70.h,
          decoration: BoxDecoration(
            color: controller.paymentMethod==e?kLightBlueColor:null,
            border: Border.all(color: controller.paymentMethod==e?kLightBlueColor:kGreyColor),
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
    })

    );
  }
}
