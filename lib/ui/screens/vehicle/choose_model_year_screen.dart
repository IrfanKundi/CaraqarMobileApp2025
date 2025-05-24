import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';

class ChooseModelYearScreen extends GetView<VehicleController> {
    ChooseModelYearScreen({Key? key}) : super(key: key){
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
      appBar: buildAppBar(context,title: "ChooseModelYear"),
      body:   Column(
        children: [
          Padding(
            padding:kHorizontalScreenPadding,
            child: CupertinoSearchTextField(onChanged: (val) =>search(val),
                placeholder: "Search".tr
            ),
          ),
          Expanded(
            child: GetBuilder<VehicleController>(
              id: "modelYears",
              builder: (controller) {
                return ListView.separated(
                  separatorBuilder: (context,index){
                    return kVerticalSpace12;
                  },
                  itemCount: searchedYears.length,
                    padding: kScreenPadding,
                  itemBuilder: (context,index){
                    var e = searchedYears[index];
                   return InkWell(
                        onTap: (){

    if(Get.arguments==true){
    controller.modelYear = e;
    Navigator.pop(context,e);
    }else {
      controller.modelYear = e;
      Get.toNamed(Routes.chooseTypeScreen);
    }

                        },
                        child:Container(
                            decoration: BoxDecoration(
                              color: controller.modelYear==e?kLightBlueColor:null,
                              border: Border.all(color: controller.modelYear==e?kLightBlueColor:kGreyColor),
                              borderRadius: kBorderRadius12,
                            ),
                            padding: EdgeInsets.all(8.w),
                            child: Text(
                              e,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: kBlackColor, fontWeight: FontWeight.w700, fontSize: 15.sp),
                            )));
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
