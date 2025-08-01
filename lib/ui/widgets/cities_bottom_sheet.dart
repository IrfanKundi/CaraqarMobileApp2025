

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/location_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

 showCitiesSheet(BuildContext context) async{

   EasyLoading.show();
 await  Get.put(LocationController()).getCities();
EasyLoading.dismiss();
 return Get.bottomSheet(GetBuilder<LocationController>(
    id: "city",
    builder: (controller)=>
        SingleChildScrollView(
          padding:kScreenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 5.w,
                  width: 60.w,
                  decoration: BoxDecoration(
                      borderRadius: kBorderRadius30,
                      color: kGreyColor
                  ),
                ),
              ),
              kVerticalSpace12,
              Text(
                "Select Province".tr,
                style:
                TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              // GetBuilder<AddRequestController>(
              //   builder:(controller)=> Text(
              //     "${"Current".tr}: ${controller.request.cityName??"NotSelected".tr}",
              //     style:
              //     kTextStyle12.copyWith(color: kAccentColor),
              //   ),
              // ),
              kVerticalSpace16,
              controller.status.value==Status.loading?const CircularLoader():
                  controller.status.value==Status.error?
                  Text(kCouldNotLoadData,
                      style: kTextStyle16)

                          :

              ListView.separated(
                  physics: const PageScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context,index){
                    var item = controller.cityModel.value.cities[index];
                    return InkWell(
                        onTap: (){
                          Get.back(result: item);
                        },
                        child: SizedBox(
                            height: 30.h,
                            child: Text(item.name!,style: kTextStyle16,)));
                  }, separatorBuilder: (context,index){
                return const Divider();
              }, itemCount: controller.cityModel.value.cities.length)
            ],
          ),
        ),
  ),
      isScrollControlled: true,
      backgroundColor: kBgColor,
      barrierColor: kBlackColor.withOpacity(0.6),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r))));
}