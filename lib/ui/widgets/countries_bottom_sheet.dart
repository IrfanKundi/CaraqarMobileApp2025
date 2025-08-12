

import 'package:careqar/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/country_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:careqar/user_session.dart';

showCountriesSheet(BuildContext context) async{

  return Get.bottomSheet(GetBuilder<CountryController>(
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
                "ChangeCountry".tr,
                style:
                TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),

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
                    var item = controller.countries[index];
                    return InkWell(
                        onTap: ()async{
                          gSelectedCountry=item;
                          if (!deepLinkHandled) {
                            await   UserSession.changeCountry(item.countryId!);
                            Get.offNamedUntil(Routes.chooseOptionScreenNew, (route) => false);
                          }
                        },
                        child: SizedBox(
                            height: 30.h,
                            child: Row(
                              children: [
                                ImageWidget(item.flag,width: 30.h,),
                                kHorizontalSpace12,
                                Text(item.name!,style: kTextStyle16,),
                              ],
                            )));
                  }, separatorBuilder: (context,index){
                return const Divider();
              }, itemCount: controller.countries.length)
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