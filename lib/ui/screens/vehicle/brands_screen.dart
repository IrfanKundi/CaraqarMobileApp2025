import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/brand_controller.dart';
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

class BrandsScreen extends GetView<VehicleController> {
   BrandsScreen({Key? key}) : super(key: key){
  Get.put(BrandController()).getBrands(EnumToString.convertToString(controller.vehicleType));
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: buildAppBar(context,child: GetBuilder<BrandController>(
          id: "search",
          builder: (controller)=>
          !controller.searchBoolean.value ? FittedBox(fit: BoxFit.scaleDown, child:  Text(("ChooseBrand").tr,style: kAppBarStyle,)) :
          CupertinoSearchTextField(

            onChanged: (val){
              controller.searchText=val.trim();
              controller.search(val.trim());
            },placeholder: "Search".tr,onSubmitted: (val){
            controller.searchText=val.trim();

            controller.search(val.trim());

          },
            controller: TextEditingController(text: controller.searchText),
            onSuffixTap: (){
              controller.searchText="";
              controller.search(controller.searchText);
              controller.update(["search"]);


            },),),
          actions: [
            GetBuilder<BrandController>(
                id: "search",
                builder: (controller)=>
                    IconButton(onPressed: (){
                      controller.showSearchIcon(controller.searchBoolean.value ?false:true);
                    }, icon: Icon(controller.searchBoolean.value?Icons.close_sharp:Icons.search))
            )
          ]
      ),
      body: GetBuilder<BrandController>(builder: (brandController)=> brandController
          .brandsStatus.value ==
          Status.loading
          ? CircularLoader():

      brandController.brandsStatus.value ==
          Status.error
          ? Center(
            child: Text(kCouldNotLoadData.tr,
            style: kTextStyle16),
          )
          :

      brandController.searchedBrands.isEmpty?
          Center(
            child: Text("NoDataFound".tr,
                style: kTextStyle16),
          ):
      GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 8.w,crossAxisSpacing: 8.w,
          crossAxisCount: 3
        ),
        padding: kScreenPadding,
          itemCount: brandController.searchedBrands.length,
        itemBuilder: (context, index) {
            var item = brandController.searchedBrands[index];
            return InkWell(
              onTap: (){

                if(controller.vehicleType==VehicleType.Car){
                  controller.carController.resetFilters();
                  controller.carController.brandId = item.brandId;
                  controller.carController.brand=item;
                  controller.carController.getFilteredCars();
                  Get.toNamed(Routes.carsScreen);
                }else{
                  controller.bikeController.resetFilters();
                    controller.bikeController.brandId = item.brandId;
                    controller.bikeController.brand=item;
                    controller.bikeController.getFilteredBikes();
                    Get.toNamed(Routes.bikesScreen);
                }

              },
              child:Container(
                decoration: BoxDecoration(
                  border: Border.all(color: kAccentColor),
                  borderRadius: kBorderRadius12,
                ),
                padding: EdgeInsets.all(8.w),
                        child: Column(
                          children: [
                            ImageWidget(item.image,width: 50.w,height: 50.w),
                            kVerticalSpace8,
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                item.brandName!,
                textAlign: TextAlign.center,
                style: TextStyle(color: kBlackColor, fontWeight: FontWeight.w700, fontSize: 15.sp),
              ),
                            ),
                          ],
                        )));

          }
          ),
      ),
    );
  }
}
