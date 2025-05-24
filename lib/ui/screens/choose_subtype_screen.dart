import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/property_controller.dart';
import 'package:careqar/controllers/type_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChooseSubtypeScreen extends GetView<PropertyController> {
  const ChooseSubtypeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: buildAppBar(context,title: "ChooseOption"),
      body: GetBuilder<TypeController>(builder: (typeController)=> typeController
          .subTypesStatus.value ==
          Status.loading
          ? CircularLoader():

      typeController.subTypesStatus.value ==
          Status.error
          ? Text("$kCouldNotLoadData".tr,
          style: kTextStyle16)
          :

          typeController.subTypes.isEmpty?
          Center(
            child: Text("NoDataFound".tr,
                style: kTextStyle16),
          ):
      GridView.builder(
        padding: kScreenPadding,
          itemCount: typeController.subTypes.length+1,
                                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                                                                    childAspectRatio: 1.2, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
                                                                itemBuilder: (context, index) {
          if(index==typeController.subTypes.length){
            return InkWell(
              onTap: (){
                controller.resetFilters();
                controller.subTypeId.value=0;
                controller.subTypes.clear();
                controller.selectedType=Get.arguments;
                controller.typeId.value=controller.selectedType!.typeId!;
                controller.getFilteredProperties();
                Get.toNamed(Routes.propertiesScreen);

                },
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Center(
                  child: Text(
                    "${"SeeAll".tr} ${typeController.totalAds} ${"Ads".tr}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kBlackColor, fontWeight: FontWeight.w700, fontSize: 15.sp),
                  ),
                ),
              ),
            );
          }else{
            var item = typeController.subTypes[index];
            return InkWell(
              onTap: (){
                controller.resetFilters();
                controller.subTypeId.value=0;
                controller.subTypes.clear();
                controller.subTypes.add(item.subTypeId!);
                controller.selectedType=Get.arguments;
                controller.typeId.value=controller.selectedType!.typeId!;
                controller.getFilteredProperties();

                Get.toNamed(Routes.propertiesScreen);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: Card(
                      shadowColor: kBlackColor,
                        elevation: 12,
                        child: ImageWidget(item.image,fit: BoxFit.fitWidth,)),
                  ),
                  kVerticalSpace4,
                  Text(
                    "${item.subType}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kBlackColor, fontWeight: FontWeight.w700, fontSize: 15.sp),
                  ),
                ],
              ),
            );

            // return InkWell(
            //   onTap: (){
            //     controller.resetFilters();
            //     controller.subTypeId.value=item.subTypeId;
            //     controller.types.add(Get.arguments);
            //     controller.getFilteredProperties();
            //
            //     Get.toNamed(Routes.propertiesScreen);
            //   },
            //   child: Card(
            //     child: Stack(
            //       children: [
            //         PositionedDirectional(
            //             bottom: 0,
            //             end: 0,
            //             child: ImageWidget(item.image,width: 70.w,height: 70.w,)),
            //         Padding(
            //           padding: EdgeInsets.all(8.w),
            //           child: Text(
            //             "${item.subType}",
            //             textAlign: TextAlign.start,
            //             style: TextStyle(color: kBlackColor, fontWeight: FontWeight.w700, fontSize: 15.sp),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // );
          }

                                                                }),
      ),
    );
  }
}
