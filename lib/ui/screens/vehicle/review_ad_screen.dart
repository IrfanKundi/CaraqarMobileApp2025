import 'dart:io';

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/brand_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:careqar/ui/widgets/text_button_widget.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';
import '../../../locale/convertor.dart';
import '../../widgets/phone_number_text_field.dart';

class ReviewAdScreen extends GetView<VehicleController> {
    ReviewAdScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBar(context,title: "ReviewAd")
      ,
      body: SingleChildScrollView(
        padding: kVerticalScreenPadding,
        child: Form(
          key:controller.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: GetBuilder<VehicleController>(
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              ReviewAdItem(title:"OfferType".tr,onPressed: ()async{
       await Get.toNamed(Routes.chooseAdTypeScreen,arguments: true);
        controller.update();
        },  value: "${EnumToString.convertToString(controller.vehicleType).tr} ${"For".tr} ${controller.purpose?.tr}",),
                  VehicleType.NumberPlate!=controller.vehicleType?
                    Column(
                      children: [
                        ReviewAdItem(title:"Type".tr,  value: "${controller.type?.type}",onPressed: ()async{
                         await Get.toNamed(Routes.chooseTypeScreen,arguments: true);
                          controller.update();
                        },),
                        ReviewAdItem(title:"Brand".tr,  value: "${controller.brand?.brandName}",onPressed: ()async{
                          await Get.toNamed(Routes.chooseBrandScreen,arguments: true);
                          controller.update();
                        },),
                        ReviewAdItem(title:"Model".tr,  value: "${controller.model?.modelName}",onPressed: ()async{
                          Get.put(BrandController()).getModels(controller.brand!.brandId!);
                          await Get.toNamed(Routes.chooseModelScreen,arguments: true);
                          controller.update();
                        },),
                        ReviewAdItem(title:"Year".tr,  value: "${controller.modelYear}",onPressed: ()async{
                          await Get.toNamed(Routes.chooseModelYearScreen,arguments: true);
                          controller.update();
                        },),
                        if(VehicleType.Car==controller.vehicleType)
                          ReviewAdItem(title:"FuelType".tr,  value: "${controller.fuelType}".tr,onPressed: ()async{
                            await Get.toNamed(Routes.selectFuelTypeScreen,arguments: true);
                            controller.update();
                          },),
                        ReviewAdItem(title:"Vehicle Origin".tr,  value: "${controller.origin}".tr,onPressed: ()async{
                          await Get.toNamed(Routes.selectOriginScreen,arguments: true);
                          controller.update();
                        },),
                        ReviewAdItem(title:"Registration".tr,  value: "${controller.province}".tr,onPressed: ()async{
                          await Get.toNamed(Routes.selectProvinceScreen,arguments: true);
                          controller.update();
                        },),
                        ReviewAdItem(title:"Vehicle Condition".tr,  value: "${controller.condition}".tr,onPressed: ()async{
                          await Get.toNamed(Routes.selectConditionScreen,arguments: true);
                          controller.update();
                        },),
                        ReviewAdItem(title:"Registration Year".tr,  value: "${controller.registrationYear}".tr,onPressed: ()async{
                          await Get.toNamed(Routes.selectRegistrationYearScreen,arguments: true);
                          controller.update();
                        },),
                        if(VehicleType.Car==controller.vehicleType)
                          ReviewAdItem(title:"Transmission".tr,  value: "${controller.transmission}".tr,onPressed: ()async{
                            await Get.toNamed(Routes.chooseTransmissionScreen,arguments: true);
                            controller.update();
                          },),
                        ReviewAdItem(title:"Color".tr,  value: "${controller.color}".tr,onPressed: ()async{
                          await Get.toNamed(Routes.selectColorScreen,arguments: true);
                          controller.update();
                        },),
                        ReviewAdItem(title:"Mileage".tr,  value: "${controller.mileage}",onPressed: ()async{
                          await Get.toNamed(Routes.enterMileageScreen,arguments: true);
                          controller.update();
                        },),
                        ReviewAdItem(title:"Engine".tr,  value: "${controller.engine}",onPressed: ()async{
                          await Get.toNamed(Routes.enterEngineScreen,arguments: true);
                          controller.update();
                        },),
                        if(VehicleType.Car==controller.vehicleType)
                          ReviewAdItem(title:"Seats".tr,  value: "${controller.seats}",onPressed: ()async{
                            await Get.toNamed(Routes.enterSeatsScreen,arguments: true);
                            controller.update();
                          },),
                        ReviewAdItem(title:"City".tr,  value: "${controller.city?.name}",onPressed: ()async{
                          await Get.toNamed(Routes.selectCityScreen,arguments: true);
                          controller.update();
                        },),
                        ReviewAdItem(title:"PaymentMethod".tr,  value: "${controller.paymentMethod}".tr,onPressed: ()async{
                          await Get.toNamed(Routes.selectPaymentMethodScreen,arguments: true);
                          controller.update();
                        },),
                      ],
                    ):
                  Column(
                    children: [
                      ReviewAdItem(title:"Number".tr,  value: "${controller.number}",onPressed: ()async{
                        await Get.toNamed(Routes.enterNumberScreen,arguments: true);
                        controller.update();
                      },),
                      ReviewAdItem(title:"Digits".tr,  value: "${controller.digits}",onPressed: ()async{
                        await Get.toNamed(Routes.selectPlateDigitsScreen,arguments: true);
                        controller.update();
                      },),
                      ReviewAdItem(title:"PlateType".tr,  value: "${controller.plateType}",onPressed: ()async{
                        await Get.toNamed(Routes.selectPlateTypeScreen,arguments: true);
                        controller.update();
                      },),
                      ReviewAdItem(title:"Privilege".tr,  value: "${controller.privilege}",onPressed: ()async{
                        await Get.toNamed(Routes.selectPrivilegeScreen,arguments: true);
                        controller.update();
                      },),
                      ReviewAdItem(title:"City".tr,  value: "${controller.city?.name}",onPressed: ()async{
                        await Get.toNamed(Routes.selectCityScreen,arguments: true);
                        controller.update();
                      },),
                    ],
                  ),


                  kVerticalSpace12,
                  Container(  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: kGreyColor))
                  ),
                    padding: EdgeInsets.symmetric(vertical: 8.w,horizontal: 16.w),
                    child: Column(
                      children: [
                        Row(
                          children: [

                            Expanded(child: Text("Description".tr,style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),)),

                            GetBuilder<VehicleController>(
                              id: "lang",

                              builder:(controller)=> Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      controller.lang=0;
                                      controller.update(["lang"]);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 4.w,horizontal: 12.w),
                                      decoration: BoxDecoration(

                                          color: gSelectedCountry?.countryId==11? kAccentColor :controller.lang==0?kAccentColor:null,
                                          borderRadius: kBorderRadius30
                                      ),
                                      child: Text("English".tr,
                                          textAlign: TextAlign.center,
                                          style: gSelectedCountry?.countryId==11? kLightTextStyle12 : controller.lang==0? kLightTextStyle12:
                                          kTextStyle12),
                                    ),
                                  ),
                                  gSelectedCountry?.countryId==11?SizedBox(): InkWell(
                                    onTap: (){
                                      controller.lang=1;
                                      controller.update(["lang"]);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 4.w,horizontal: 12.w),
                                      decoration: BoxDecoration(

                                          color: controller.lang==1?kAccentColor:null,
                                          borderRadius: kBorderRadius30
                                      ),
                                      child: Text("Arabic".tr,
                                          textAlign: TextAlign.center,
                                          style: controller.lang==1? kLightTextStyle12:
                                          kTextStyle12),
                                    ),
                                  ),
                                  gSelectedCountry?.countryId==11?SizedBox(): InkWell(
                                    onTap: (){
                                      controller.lang=2;
                                      controller.update(["lang"]);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 4.w,horizontal: 12.w),
                                      decoration: BoxDecoration(

                                          color: controller.lang==2?kAccentColor:null,
                                          borderRadius: kBorderRadius30
                                      ),
                                      child: Text("Both".tr,
                                          textAlign: TextAlign.center,
                                          style: controller.lang==2? kLightTextStyle12:
                                          kTextStyle12),
                                    ),
                                  ),

                                ],
                              ),),

                          ],
                        ),
                        kVerticalSpace12,
                        GetBuilder<VehicleController>(
                            id: "lang",

                            builder:(controller)=> Column(
                              children: [
                                gSelectedCountry?.countryId==11 || controller.lang==0 || controller.lang==2?
                                Padding(
                                  padding:  EdgeInsets.only(bottom: 12.w),
                                  child: TextFieldWidget(hintText: "DescriptionEnglish",maxLines: 3, text: controller.descriptionEn,
                                    borderRadius: kBorderRadius4,
                                    textInputAction: TextInputAction.newline,
                                    onChanged: (String val){
                                      controller.descriptionEn=val.trim();
                                    },
                                    validator: (String? val){
                                      if(val!.trim().isEmpty)
                                        return kRequiredMsg.tr;
                                      else
                                        return null;
                                    },),
                                ):Container(),
                                gSelectedCountry?.countryId!=11 && (controller.lang==1 || controller.lang==2)?     Padding(
                                  padding:  EdgeInsets.only(bottom: 12.w),
                                  child: TextFieldWidget(hintText: "DescriptionArabic",maxLines: 3, text: controller.descriptionAr,
                                    borderRadius: kBorderRadius4,
                                    textInputAction: TextInputAction.newline,
                                    onChanged: (String val){
                                      controller.descriptionAr=val.trim();
                                    },
                                    validator: (String? val){
                                      if(val!.trim().isEmpty)
                                        return kRequiredMsg.tr;
                                      else
                                        return null;
                                    },),
                                ):Container(),

                              ],
                            )


                        )
                      ],
                    ),
                  )
                  ,
                  Container(
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: kGreyColor))
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8.w,horizontal: 16.w),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("${"Price".tr} (${gSelectedCountry?.currency})",style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),

                        kVerticalSpace12,
                        TextFieldWidget(
                          hintText: "Price (Optional)",
                          keyboardType: TextInputType.number,
                          borderRadius: kBorderRadius4,
                          text: controller.price?.toString(),
                          onChanged: (String val){
                            if(val==""){
                              controller.price = 0.0; // Set to 0 when empty
                              controller.priceInWords.value = '';
                            }else{
                              try {
                                controller.price=double.parse(val);
                                final formatted = formatIndianNumber(controller.price!.toInt());
                                controller.priceInWords.value = formatted.capitalize!.trim() ?? '';
                              } catch (_) {
                                controller.priceInWords.value = '';
                              }
                            }
                          },
                          // Remove validator entirely or make it always return null
                          validator: (String? val){
                            return null; // No validation - field is optional
                          },
                        ),
                        kVerticalSpace8,
                        Text("Skip the price to display 'Call for Price'", style: TextStyle(fontSize: 12.sp, color: kGreyColor)),
                        Obx(() {
                          if (controller.priceInWords.isEmpty) return SizedBox.shrink();
                          return Padding(
                            padding: EdgeInsets.only(top: 6.w),
                            child: Text(
                              controller.priceInWords.value,
                              style: TextStyle(fontSize: 13.sp, color: Theme.of(context).colorScheme.primary),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  if(VehicleType.NumberPlate!=controller.vehicleType)
                      Container(  decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: kGreyColor))
                      ),
                        padding: EdgeInsets.symmetric(vertical: 8.w,horizontal: 16.w),
                        child:  Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Features".tr,style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
                            kVerticalSpace12,
                        GetBuilder<VehicleController>(builder: (controller)=> GestureDetector(
                          onTap: ()async{
                            if(Get.focusScope!=null){
                              Get.focusScope?.unfocus();
                            }
              await  Get.toNamed(Routes.addVehicleFeaturesScreen);
              controller.update();
              },
                  child: Container(
                    decoration: BoxDecoration(
                        color: kWhiteColor,
                        border: Border.all(
                            width: 1.w,
                            color: kGreyColor.shade300
                        ),
                        borderRadius: kBorderRadius4
                    ),
                    padding: EdgeInsets.all(8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(controller.vehicleFeatures.isEmpty?"AddFeatures".tr:"AddAnotherFeature".tr,style: kHintStyle,),
                        kVerticalSpace8,
                        Wrap(
                            runSpacing: 4.w,
                            spacing: 4.w,
                            children: controller.vehicleFeatures.map((e) => Container(
                              padding: EdgeInsets.symmetric(vertical: 2.w,horizontal: 8.w).copyWith(right: 4.w),
                              decoration: BoxDecoration(
                                borderRadius: kBorderRadius30,
                                color: kGreyColor.shade300,

                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(e.feature!,style: kTextStyle12,),
                                  kHorizontalSpace4,
                                  GestureDetector(child:Icon(MaterialCommunityIcons.close,size: 15.w,),onTap: (){
                                    controller.vehicleFeatures.remove(e);
                                    controller.update();
                                  },)
                                ],
                              ),
                            )).toList()
                        )
                      ],
                    ),

                  ),
              ))
                          ],
                        ),
                      ),
                    Container(  decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: kGreyColor))
                    ),
                      padding: EdgeInsets.symmetric(vertical: 8.w,horizontal: 16.w),
                      child:  Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("PhoneNumber".tr,style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
                          kVerticalSpace12,
                          PhoneNumberTextField(hintText: "PhoneNumber",

                            value: controller.phoneNumber,
                            borderRadius: kBorderRadius4,
                            onChanged: (val){

                              controller.phoneNumber=val;


                            },
                          ),
                        ],
                      ),
                    ),
                  Container(  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: kGreyColor))
                  ),
                    padding: EdgeInsets.symmetric(vertical: 8.w,horizontal: 16.w),
                    child:  Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Images".tr,style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),), kHorizontalSpace12,

                            TextButtonWidget(
                                onPressed: controller.uploadImages,
                                text:"AddImages"),
                          ],
                        ),
                        GetBuilder<VehicleController>(

                          builder:(controller)=> Visibility(
                            visible: controller.newImages.value.isNotEmpty,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 16.w),
                              height: 50.w,
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context,index){
                                    if(controller.newImages.value[index] is File){
                                      return Stack(  clipBehavior: Clip.none,
                                        children: [
                                          ImageWidget(null,file:controller.newImages.value[index],width: 100.w,height: 50.w,fit: BoxFit.cover,),
                                          Positioned(
                                            top:-8.w,
                                            right: -4.w,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black38,
                                                  shape: BoxShape.circle
                                              ),
                                              child: IconButtonWidget(icon:MaterialCommunityIcons.close,iconSize: 16.sp,width: 23.w,color: kWhiteColor,onPressed: (){
                                                controller.newImages.value.removeAt(index);
                                                controller.update();
                                              },),
                                            ),
                                          )
                                        ],
                                      );
                                    }else{
                                      return Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          ImageWidget(controller.newImages.value[index],width: 100.w,height: 50.w,fit: BoxFit.cover,),
                                          Positioned(
                                            top:-8.w,
                                            right: -4.w,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.black38,
                                                  shape: BoxShape.circle
                                              ),
                                              child: IconButtonWidget(icon:MaterialCommunityIcons.close,iconSize: 16.sp,
                                                width: 23.w,color: kWhiteColor,onPressed: (){
                                                  controller.newImages.value.removeAt(index);
                                                  controller.images.removeAt(index);
                                                  controller.update();
                                                },),
                                            ),
                                          )
                                        ],
                                      );
                                    }

                                  }, separatorBuilder: (context,index){
                                return kHorizontalSpace12;
                              }, itemCount: controller.newImages.value.length),
                            ),
                          ),),
                      ],
                    ),
                  ),

                  Container(color: kBgColor,
                    width: 1.sw,
                    padding:kScreenPadding,

                    child:     ButtonWidget(onPressed: controller.uploadNow,text: "UploadNow",
                    ),)
                ],
              );
            }
          ),
        ),

      ),
    );
  }



}

class ReviewAdItem extends GetView<VehicleController> {
  const ReviewAdItem({
    Key? key,
    required this.title,
    required this.value,
    this.onPressed,
  }) : super(key: key);

  final  title;
  final  value;
  final  onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.w,horizontal: 16.w),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: kGreyColor))
        ),
        child: Row(
          children: [
            Text(title,style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
            kHorizontalSpace12,
            Expanded(child: Text(value,
            style: kTextStyle16.copyWith(color: kAccentColor),
              textAlign: TextAlign.end,
            )), kHorizontalSpace12,
            IconButtonWidget(onPressed: onPressed,icon: Icons.arrow_forward,color: kLightBlueColor,)
          ],
        ),
      ),
    );
  }
}
