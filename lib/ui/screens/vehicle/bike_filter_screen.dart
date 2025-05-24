import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/models/city_model.dart';
import 'package:careqar/models/type_model.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/dropdown_widget.dart';
import 'package:careqar/ui/widgets/text_button_widget.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../controllers/bike_controller.dart';
import '../../../controllers/brand_controller.dart';
import '../../../controllers/vehicle_controller.dart';
import '../../../models/brand_model.dart';

class BikeFilterScreen extends GetView<VehicleController> {
  const BikeFilterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: (){
        controller.bikeController.resetFilters();
        return Future.value(true);
      },
      child: Scaffold(
          appBar: buildAppBar(context, title: "Filters"),
          body: GetBuilder<BikeController>(
            id: "filter",
            builder: (controller) {
              return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                          padding: kScreenPadding,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                            Text(
                              "City".tr,
                              style: TextStyle(
                                  color: kBlackColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            kVerticalSpace4,
                            
                            InkWell(
                              onTap: () async {
                                var result = await Get.toNamed(Routes.selectCityScreen,arguments: true) as City;
                                if (result != null) {
                                  controller.selectedCity = result;
                                  controller.update(["filter"]);
                                }
                              },
                              child: Container(
                                padding: kHorizontalScreenPadding,
                                height: 40.h,
                                decoration: BoxDecoration(
                                  borderRadius: kBorderRadius4,color: kWhiteColor,
                                  border: Border.all(color:  Colors.grey.shade300)
                                ),
                                child: Row(
                                  children: [

                                    Expanded(
                                      child: Text(
                                        controller.selectedCity?.name ?? 'SelectCity'.tr,
                                        style: TextStyle(
                                            color: kAccentColor,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Icon(
                                        Get.locale?.languageCode=="ar"?MaterialCommunityIcons.chevron_left:
                                        MaterialCommunityIcons.chevron_right)
                                  ],
                                ),
                              ),
                            ),

                                kVerticalSpace12,
                                Text(
                                  "ChooseBrand".tr,
                                  style: TextStyle(
                                      color: kBlackColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                kVerticalSpace4,

                                InkWell(
                                  onTap: () async {
                                    var result = await Get.toNamed(Routes.chooseBrandScreen,arguments: false) as Brand;
                                    if (result != null) {
                                      controller.brand = result;
                                      controller.update(["filter"]);
                                    }
                                  },
                                  child: Container(
                                    padding: kHorizontalScreenPadding,
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                        borderRadius: kBorderRadius4,color: kWhiteColor,
                                        border: Border.all(color:  Colors.grey.shade300)
                                    ),
                                    child: Row(
                                      children: [

                                        Expanded(
                                          child: Text(
                                            controller.brand?.brandName ?? 'ChooseBrand'.tr,
                                            style: TextStyle(
                                                color: kAccentColor,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Icon(
                                            Get.locale?.languageCode=="ar"?MaterialCommunityIcons.chevron_left:
                                            MaterialCommunityIcons.chevron_right)
                                      ],
                                    ),
                                  ),
                                ),
                                kVerticalSpace12,
                                Text(
                                  "ChooseModel".tr,
                                  style: TextStyle(
                                      color: kBlackColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                kVerticalSpace4,

                                InkWell(
                                  onTap: () async {
    if(controller.brand!=null) {
      Get.put(BrandController()).getModels(controller.brand!.brandId!);
      var result = await Get.toNamed(
          Routes.chooseModelScreen, arguments: true) as Model;
      if (result != null) {
        controller.model = result;
        controller.modelId=controller.model?.modelId;
        controller.update(["filter"]);
      }
    }else{
      showSnackBar(message: "SelectBrand");
    }
                                  },
                                  child: Container(
                                    padding: kHorizontalScreenPadding,
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                        borderRadius: kBorderRadius4,color: kWhiteColor,
                                        border: Border.all(color:  Colors.grey.shade300)
                                    ),
                                    child: Row(
                                      children: [

                                        Expanded(
                                          child: Text(
                                            controller.model?.modelName ?? 'ChooseModel'.tr,
                                            style: TextStyle(
                                                color: kAccentColor,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Icon(
                                            Get.locale?.languageCode=="ar"?MaterialCommunityIcons.chevron_left:
                                            MaterialCommunityIcons.chevron_right)
                                      ],
                                    ),
                                  ),
                                ),
                                kVerticalSpace12,
                                Text(
                                  "ModelYear".tr,
                                  style: TextStyle(
                                      color: kBlackColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                kVerticalSpace4,
                                Row(
                                  children: [
                                    Expanded(child:  TextFieldWidget(hintText: "ModelYear",  keyboardType: TextInputType.number,
                                      text: controller.startYear, borderRadius: kBorderRadius8,
                                      onChanged: (String val){
                                        controller.startYear=val;

                                      },
                                      validator: (String? val){
                                        if(val!.trim().isEmpty) {
                                          return kRequiredMsg.tr;
                                        } else {
                                          return null;
                                        }
                                      },),),
                                    Text(" ${"To".tr} ",style: TextStyle(color: kBlackColor,fontSize: 16.sp,fontWeight: FontWeight.w600),)
                                    ,
                                    Expanded(child:  TextFieldWidget(hintText: "ModelYear",  keyboardType: TextInputType.number,
                                      text: controller.endYear, borderRadius: kBorderRadius8,
                                      onChanged: (String val){
                                        controller.endYear=val;

                                      },
                                      validator: (String? val){
                                        if(val!.trim().isEmpty) {
                                          return kRequiredMsg.tr;
                                        } else {
                                          return null;
                                        }
                                      },),),
                                  ],
                                ),
                                kVerticalSpace12,
                                Text(
                                  "ChooseType".tr,
                                  style: TextStyle(
                                      color: kBlackColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                kVerticalSpace4,

                                InkWell(
                                  onTap: () async {
                                    var result = await Get.toNamed(Routes.chooseTypeScreen,arguments: true) as Type;
                                    if (result != null) {
                                      controller.type = result;
                                      controller.update(["filter"]);
                                    }
                                  },
                                  child: Container(
                                    padding: kHorizontalScreenPadding,
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                        borderRadius: kBorderRadius4,color: kWhiteColor,
                                        border: Border.all(color:  Colors.grey.shade300)
                                    ),
                                    child: Row(
                                      children: [

                                        Expanded(
                                          child: Text(
                                            controller.type?.type ?? 'ChooseType'.tr,
                                            style: TextStyle(
                                                color: kAccentColor,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Icon(
                                            Get.locale!.languageCode=="ar"?MaterialCommunityIcons.chevron_left:
                                            MaterialCommunityIcons.chevron_right)
                                      ],
                                    ),
                                  ),
                                ),

                                kVerticalSpace12,
                                Text(
                                  "SelectColor".tr,
                                  style: TextStyle(
                                      color: kBlackColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                kVerticalSpace4,

                                InkWell(
                                  onTap: () async {
                                    var result = await Get.toNamed(Routes.selectColorScreen,arguments: true) as VehicleColor;
                                    if (result != null) {
                                      controller.color = result;
                                      controller.update(["filter"]);
                                    }
                                  },
                                  child: Container(
                                    padding: kHorizontalScreenPadding,
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                        borderRadius: kBorderRadius4,color: kWhiteColor,
                                        border: Border.all(color:  Colors.grey.shade300)
                                    ),
                                    child: Row(
                                      children: [

                                        Expanded(
                                          child: Text(
                                            controller.color?.name ?? 'SelectColor'.tr,
                                            style: TextStyle(
                                                color: kAccentColor,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Icon(
                                            Get.locale!.languageCode=="ar"?MaterialCommunityIcons.chevron_left:
                                            MaterialCommunityIcons.chevron_right)
                                      ],
                                    ),
                                  ),
                                ),

                                kVerticalSpace12,
                                Text(
                                  "Condition".tr,
                                  style: TextStyle(
                                      color: kBlackColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                kVerticalSpace4,

                               DropdownWidget(
                                 items: VehicleCondition.values.map((e) => DropdownMenuItem(child: Text(EnumToString.convertToString(e),),value: e,)).toList(),
                                 value: controller.condition,
                                  borderRadius: kBorderRadius4,
                                 onChanged: (val){
                                   controller.condition=val;
                                  controller.update(["filter"]);
                                 },
                                 hint: "SelectCondition",
                               ),
                                kVerticalSpace12,

                                Row(
                                  children: [
                                    Text(
                                      "PriceRange".tr,
                                      style: TextStyle(
                                          color: kBlackColor,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      " (${gSelectedCountry!.currency})",
                                      style: TextStyle(
                                          color: kBlackColor,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                                kVerticalSpace4,
                                Row(
                                  children: [
                                    Expanded(child:  TextFieldWidget(hintText: "StartPrice",  keyboardType: TextInputType.number,
                                      text: controller.startPrice, borderRadius: kBorderRadius8,
                                      onChanged: (String val){
                                        controller.startPrice=val;

                                      },
                                      validator: (String? val){
                                        if(val!.trim().isEmpty) {
                                          return kRequiredMsg.tr;
                                        } else {
                                          return null;
                                        }
                                      },),),
                                    Text(" ${"To".tr} ",style: TextStyle(color: kBlackColor,fontSize: 16.sp,fontWeight: FontWeight.w600),)
                                    ,
                                    Expanded(child:  TextFieldWidget(hintText: "EndPrice",  keyboardType: TextInputType.number,
                                      text: controller.endPrice, borderRadius: kBorderRadius8,
                                      onChanged: (String val){
                                        controller.endPrice=val;

                                      },
                                      validator: (String? val){
                                        if(val!.trim().isEmpty) {
                                          return kRequiredMsg.tr;
                                        } else {
                                          return null;
                                        }
                                      },),),
                                  ],
                                ),


                          ])),
                    ),
                    Container(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: kScreenPadding,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: TextButtonWidget(text: "Reset".tr,onPressed: controller.resetFilters,)),
                            kHorizontalSpace12,
                            Expanded(child: ButtonWidget(text: "Apply".tr, onPressed: controller.getFilteredBikes))
                          ],
                        ),
                      ),
                    )
                  ],
              );
            }
          )),
    );
  }
}
