import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/number_plate_controller.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/models/city_model.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/dropdown_widget.dart';
import 'package:careqar/ui/widgets/text_button_widget.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';

class NumberPlateFilterScreen extends GetView<NumberPlateController> {
  const NumberPlateFilterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: (){
        controller.resetFilters();
        return Future.value(true);
      },
      child: Scaffold(
          appBar: buildAppBar(context, title: "Filters"),
          body: GetBuilder<NumberPlateController>(
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
                                        "${controller.selectedCity?.name ?? 'SelectCity'.tr}",
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
                                  "Digits".tr,
                                  style: TextStyle(
                                      color: kBlackColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                kVerticalSpace4,

                               DropdownWidget(
                                 items:numberPlateTypes.map((e) => DropdownMenuItem(child: Text("${e.title}",),value: e.id,)).toList(),
                                 value: controller.digits,
                                  borderRadius: kBorderRadius4,
                                 onChanged: (val){
                                   controller.digits=val;
                                  controller.update(["filter"]);
                                 },
                                 hint: "SelectDigits",
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
                                      " (${gSelectedCountry?.currency})",
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
                                        } else
                                          return null;
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
                                        } else
                                          return null;
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
                            Expanded(child: ButtonWidget(text: "Apply".tr, onPressed: controller.getFilteredNumberPlates))
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
