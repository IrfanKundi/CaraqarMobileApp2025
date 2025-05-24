import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';

class ChooseAdTypeScreen extends GetView<VehicleController> {
  const ChooseAdTypeScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: buildAppBar(context,title: "ChooseYourOfferType"),
      body:  Padding(
        padding:kScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
           
            children: [
              InkWell(
                onTap: (){
                  controller.purpose = EnumToString.convertToString(Purpose.Sell);
                  if(Get.arguments==true){
                    Navigator.pop(context);
                  }else
                    if(VehicleType.NumberPlate==controller.vehicleType){
                      Get.toNamed(Routes.enterNumberScreen);
                    }else{
                      Get.toNamed(Routes.chooseBrandScreen);
                    }
                },
                child:      Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Image.asset("assets/images/${controller.vehicleType==VehicleType.Bike?"bikesell.png":"sell.png"}",
                      fit: BoxFit.scaleDown,
                      width: 0.7.sw,
                      height: 0.2.sh,
                    ),
                    PositionedDirectional(
                      end: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.w, horizontal: 8.w),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: kBorderRadius4,
                        ),
                        child: Text(
                          "Sell".tr,
                          style: TextStyle(
                              color: kWhiteColor, fontSize: 17.sp,fontWeight: FontWeight.w600),),
                      ),
                    )
                  ],
                ),
              ),
           (controller.vehicleType==VehicleType.Car)?
              Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  kVerticalSpace16,
                  InkWell(
                    onTap: (){
                      controller.purpose = EnumToString.convertToString(Purpose.Rent);
                      if(Get.arguments==true){
                        Navigator.pop(context);
                      }else
                      if(VehicleType.NumberPlate==controller.vehicleType){
                        Get.toNamed(Routes.enterNumberScreen);
                      }else{
                        Get.toNamed(Routes.chooseBrandScreen);
                      }
                    },
                    child:  Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Image.asset("assets/images/rent.png",
                          fit: BoxFit.scaleDown,
                          width: 0.7.sw,
                          height: 0.2.sh,
                        ),
                        PositionedDirectional(  end: 0,
                          top: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 4.w, horizontal: 8.w),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: kBorderRadius4,
                            ),
                            child: Text(
                              "Rent".tr,
                              style: TextStyle(
                                  color: kWhiteColor, fontSize: 17.sp,fontWeight: FontWeight.w600),),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ):SizedBox(),

              kVerticalSpace16,
              InkWell(
                onTap: (){
                  controller.purpose = EnumToString.convertToString(Purpose.Rent);
                  if(Get.arguments==true){
                    Navigator.pop(context);
                  }else
                  if(VehicleType.NumberPlate==controller.vehicleType){
                    Get.toNamed(Routes.enterNumberScreen);
                  }else{
                    Get.toNamed(Routes.chooseBrandScreen);
                  }
                },
                child:  Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Image.asset("assets/images/${controller.vehicleType==VehicleType.Bike?"bikerequire.png":"wanted.png"}",
                      fit: BoxFit.scaleDown,
                      width: 0.7.sw,
                      height: 0.2.sh,
                    ),
                    PositionedDirectional(  end: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.w, horizontal: 8.w),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: kBorderRadius4,
                        ),
                        child: Text(
                          "Wanted".tr,
                          style: TextStyle(
                              color: kWhiteColor, fontSize: 17.sp,fontWeight: FontWeight.w600),),
                      ),
                    )
                  ],
                ),
              ),
            ],
            ),
      ),
    );
  }
}
