import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/type_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';

class ChooseTypeScreen extends GetView<VehicleController> {
   ChooseTypeScreen({Key? key}) : super(key: key){
  Get.put(TypeController()).getTypes(vehicleType: EnumToString.convertToString(controller.vehicleType));
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: buildAppBar(context,title: "ChooseType"),
      body: GetBuilder<TypeController>(builder: (typeController)=> typeController
          .typesStatus.value ==
          Status.loading
          ? CircularLoader():

      typeController.typesStatus.value ==
          Status.error
          ? Text(kCouldNotLoadData,
          style: kTextStyle16)
          :

      Column(
        children: [
          Padding(
            padding:kHorizontalScreenPadding,
            child: CupertinoSearchTextField(onChanged: (val) => typeController.search(val),
                placeholder: "Search".tr),
          ),
          Expanded(
            child: typeController.searchedTypes.isEmpty?
                Center(
                  child: Text("NoDataFound".tr,
                      style: kTextStyle16),
                ):
            ListView.separated(
              shrinkWrap: true,
              padding: kScreenPadding,
                itemCount: typeController.searchedTypes.length,
              separatorBuilder: (context,index){
                return kVerticalSpace12;
    },
              itemBuilder: (context, index) {
                  var item = typeController.searchedTypes[index];
                  return InkWell(
                    onTap: (){
                      controller.type = item;
if(Get.arguments==true){

  Navigator.pop(context,item);
}else{
  Get.toNamed(Routes.selectConditionScreen);
}



                    },
                    child:Container(
                      decoration: BoxDecoration(
                        color: controller.typeId==item.typeId?kLightBlueColor:null,
                        border: Border.all(color: controller.typeId==item.typeId?kLightBlueColor:kGreyColor),
                        borderRadius: kBorderRadius12,
                      ),
                      padding: EdgeInsets.all(8.w),
                              child: Row(
                                children: [
                                  ImageWidget(item.image,width: 40.w,height: 40.w),
                                  kHorizontalSpace12,
                                  Text(
                      item.type!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kBlackColor, fontWeight: FontWeight.w700, fontSize: 15.sp),
                    ),
                                ],
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
