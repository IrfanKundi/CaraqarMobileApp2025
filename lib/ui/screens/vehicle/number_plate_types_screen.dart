import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/number_plate_controller.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';

class NumberPlateTypesScreen extends GetView<NumberPlateController> {
   const NumberPlateTypesScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: buildAppBar(context,title: "ChooseType"),
      body:
      GridView.builder(
          padding: kScreenPadding,
          itemCount: numberPlateTypes.length+1,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
              childAspectRatio: 1.2, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
          itemBuilder: (context, index) {
            if(index==numberPlateTypes.length){
              return InkWell(
                onTap: (){
                  controller.resetFilters();
                  controller.digits=null;
                  controller.getFilteredNumberPlates();
                  Get.toNamed(Routes.numberPlatesScreen);

                },
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Center(
                    child: Text(
                      "${"SeeAll".tr} ${"Ads".tr}",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kBlackColor, fontWeight: FontWeight.w700, fontSize: 15.sp),
                    ),
                  ),
                ),
              );
            }else{
              var item = numberPlateTypes[index];
              return InkWell(
                onTap: (){
                  controller.resetFilters();
                  controller.digits=item.id;
                  controller.getFilteredNumberPlates();
                  Get.toNamed(Routes.numberPlatesScreen);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Image.asset(item.image,fit: BoxFit.scaleDown,),
                    ),
                    kVerticalSpace4,
                    Text(
                      "${item.title}".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kBlackColor, fontWeight: FontWeight.w700, fontSize: 15.sp),
                    ),
                  ],
                ),
              );

            }

          }),

    );
  }
}
