import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/brand_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';

class ChooseModelScreen extends GetView<VehicleController> {
   const ChooseModelScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: buildAppBar(context,title: "ChooseModel"),
      body: GetBuilder<BrandController>(builder: (brandController)=> brandController
          .modelsStatus.value ==
          Status.loading
          ? CircularLoader():

      brandController.modelsStatus.value ==
          Status.error
          ? Text(kCouldNotLoadData.tr,
          style: kTextStyle16)
          :

      Column(
        children: [
          Padding(
            padding:kHorizontalScreenPadding,
            child: CupertinoSearchTextField(onChanged: (val) => brandController.searchModel(val), placeholder: "Search".tr),
          ),
          Expanded(
            child: brandController.searchedModels.isEmpty?
                Center(
                  child: Text("NoDataFound".tr,
                      style: kTextStyle16),
                ):
            ListView.separated(
              padding: kScreenPadding,
                itemCount: brandController.searchedModels.length,
              separatorBuilder: (context,index){
                return kVerticalSpace12;
    },
              itemBuilder: (context, index) {
                  var item = brandController.searchedModels[index];
                  return InkWell(
                    onTap: (){
                      controller.model = item;
                      if(Get.arguments==true){
                        Navigator.pop(context,item);
                      }else{
                        Get.toNamed(Routes.chooseModelVariants);
                      }
                    },
                    child:Container(
                      decoration: BoxDecoration(
                        color: controller.modelId==item.modelId?kLightBlueColor:null,
                        border: Border.all(color: controller.modelId==item.modelId?kLightBlueColor:kGreyColor),
                        borderRadius: kBorderRadius12,
                      ),
                      padding: EdgeInsets.all(8.w),
                              child: Text(
                      item.modelName!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kBlackColor, fontWeight: FontWeight.w700, fontSize: 15.sp),
                    )));

                }
                ),
          ),
        ],
      ),
      ),
    );
  }
}
