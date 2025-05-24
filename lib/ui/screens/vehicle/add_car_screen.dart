import 'dart:io';

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/add_car_controller.dart';
import 'package:careqar/controllers/brand_controller.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/models/city_model.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/cities_bottom_sheet.dart';
import 'package:careqar/ui/widgets/dropdown_widget.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:careqar/ui/widgets/text_button_widget.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../controllers/type_controller.dart';

class AddCarScreen extends GetView<AddCarController> {
  const AddCarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBar(context,title: "AddCar"),
      body: Form(
        key: controller.formKey.value,
        autovalidateMode: AutovalidateMode.always,
        child:
            SingleChildScrollView(
              padding: kScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(MaterialCommunityIcons.information_outline,color: kBlackColor,size: 20.sp,),
                      kHorizontalSpace4,
                      Expanded(child: Text("Details".tr,style: kTextStyle16,)),

                      GetBuilder<AddCarController>(
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

                                    color: gSelectedCountry?.countryId==11? kAccentColor : controller.lang==0?kAccentColor:null,
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
                  )
                  ,kVerticalSpace12,
                  GetBuilder<AddCarController>(
                      id: "lang",

                      builder:(controller)=> Column(
                        children: [
                          gSelectedCountry?.countryId==11 || controller.lang==0 || controller.lang==2?
                          Padding(
                            padding:  EdgeInsets.only(bottom: 12.w),
                            child: TextFieldWidget(hintText: "CarTitleEnglish",
                              text: controller.car.title,
                              onChanged: (String val){
                                controller.car.titleEn=val.trim();
                              },
                              validator: (String? val){
                                if(val!.trim().isEmpty)
                                  return kRequiredMsg.tr;
                                else
                                  return null;
                              },
                            ),
                          ):Container(),
                          gSelectedCountry?.countryId!=11 && (controller.lang==1 || controller.lang==2)?  Padding(
                            padding:  EdgeInsets.only(bottom: 12.w),
                            child: TextFieldWidget(hintText: "CarTitleArabic",
                              text: controller.car.titleAr,
                              onChanged: (String val){
                                controller.car.titleAr=val.trim();
                              },
                              validator: (String? val){
                                if(val!.trim().isEmpty)
                                  return kRequiredMsg.tr;
                                else
                                  return null;
                              },
                            ),
                          ):Container(),

                          gSelectedCountry?.countryId==11 || controller.lang==0 || controller.lang==2?
                          Padding(
                            padding:  EdgeInsets.only(bottom: 12.w),
                            child: TextFieldWidget(hintText: "CarDescriptionEnglish",maxLines: 3, text: controller.car.description,
                              onChanged: (String val){
                                controller.car.descriptionEn=val.trim();
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
                            child: TextFieldWidget(hintText: "CarDescriptionArabic",maxLines: 3, text: controller.car.descriptionAr,
                              onChanged: (String val){
                                controller.car.descriptionAr=val.trim();
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
                  ,kVerticalSpace12,

                  Row(
                    children: [
                      Icon(MaterialCommunityIcons.car,color: kBlackColor,size: 20.sp,),
                      kHorizontalSpace4,
                      Text("CarType".tr,style: kTextStyle16,)
                    ],
                  )
                  ,kVerticalSpace12,

                  GetBuilder<TypeController>(
                      builder:(controller)=> SizedBox(
                          height: 30.h,
                          child:
                          ListView.separated(
                            itemCount: controller.searchedTypes.length,
                            separatorBuilder: (context,index){
                              return kHorizontalSpace12;
                            },
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context,index){
                              var item =  controller.searchedTypes[index];
                              return  GestureDetector(

                                onTap: (){
                                  this.controller.car.typeId=item.typeId;
                                  this.controller.car.typeAr=item.typeAr;
                                  this.controller.car.typeEn=item.typeEn;
                                  this.controller.car.features.clear();
                                  controller.update();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 2.w,horizontal: 8.w),
                                  decoration: BoxDecoration(
                                    borderRadius: kBorderRadius30,
                                    color: this.controller.car.typeId==item.typeId? kAccentColor : Colors.grey.shade300,
                                  ),
                                  child: Text(item.type!,style: TextStyle(color:  this.controller.car.typeId==item.typeId? kWhiteColor: kBlackColor,fontSize: 15.sp),),
                                ),
                              );
                            },
                          )

                      )),
                  kVerticalSpace12,
                  GetBuilder<AddCarController>(builder:(controller)=> TextFieldWidget(labelText: "SelectCity",onTap: ()async{
                    var result =  await showCitiesSheet(context) as City;
                    if(result!=null){
                      controller.car.cityNameAr=result.nameAr;
                      controller.car.cityNameEn=result.nameEn;
                      controller.car.cityId=result.cityId;
                      controller.car.locationAr=null;
                      controller.car.locationEn=null;
                      controller.car.locationId=null;
                      controller.update();
                    }
                  },
                    text: controller.car.cityName,
                  )),
                  kVerticalSpace12,
                  TextFieldWidget(labelText: "Price",  keyboardType: TextInputType.number,
                    text: controller.car.price?.toString(),
                    onChanged: (String val){
                    if(val==""){
                      controller.car.price=null;
                    }else{
                      controller.car.price=double.parse(val);
                    }

                    },
                    validator: (String? val){
                      if(val!.trim().isEmpty)
                        return kRequiredMsg.tr;
                      else
                        return null;
                    },),
                  kVerticalSpace12,
                  TextFieldWidget(labelText: "Engine",
                    text: controller.car.engine,
                    onChanged: (String val){
                     
                        controller.car.engine=val;


                    },
                    validator: (String? val){
                      if(val!.trim().isEmpty)
                        return kRequiredMsg.tr;
                      else
                        return null;
                    },),
                  kVerticalSpace12,
                  Row(
                    children: [
                      Icon(MaterialCommunityIcons.car,color: kBlackColor,size: 20.sp,),
                      kHorizontalSpace4,
                      Text("Condition".tr,style: kTextStyle16,)
                    ],
                  ),    kVerticalSpace12,
        GetBuilder<AddCarController>(
          id: "condition",

          builder:(controller)=>    DropdownWidget(hint: "SelectCondition",value: controller.car.condition,onChanged: (val){
                    controller.car.condition=val;
                    controller.update(["condition"]);
                  },validator: (value) => value == null ? kRequiredMsg.tr: null,
                  items: [DropdownMenuItem(child: Text("New".tr),value: "New",),
                    DropdownMenuItem(child: Text("Used".tr),value: "Used",),
                  ],
                  )),kVerticalSpace12,
                  Row(
                    children: [
                      Icon(MaterialCommunityIcons.car,color: kBlackColor,size: 20.sp,),
                      kHorizontalSpace4,
                      Text("Color".tr,style: kTextStyle16,)
                    ],
                  ),    kVerticalSpace12,
                  GetBuilder<AddCarController>(
                      id: "color",

                      builder:(controller)=>    DropdownWidget(hint: "SelectColor",value: controller.car.color,onChanged: (val){
                        controller.car.color=val;
                        controller.update(["color"]);
                      },validator: (value) => value == null ? kRequiredMsg.tr: null,
                        items: gVehicleColors.map((e) =>   DropdownMenuItem(child: Row(
                          children: [
                            Container(width: 20.w,height: 20.w,color: e.color,),
                            kHorizontalSpace12,
                            Text(e.name.tr),
                          ],
                        ),value: e.name,)).toList(),
                      )),
                  kVerticalSpace12,
                  Row(
                    children: [
                      Icon(MaterialCommunityIcons.car,color: kBlackColor,size: 20.sp,),
                      kHorizontalSpace4,
                      Text("Brand".tr,style: kTextStyle16,)
                    ],
                  ),    kVerticalSpace12,
                  GetBuilder<BrandController>(

                      builder:(controller)=>    DropdownWidget(hint: "SelectBrand",
                        value: this.controller.car.brandId,onChanged: (val){
                        this.controller.car.brandId=val;
                        controller.update();
                      },validator: (value) => value == null ? kRequiredMsg.tr: null,
                        items:controller.searchedBrands.map((element) => DropdownMenuItem(child: Text("${element.brandName}"),
                          value: element.brandId,)).toList(),
                      )),

                  kVerticalSpace12,

                  Row(
                    children: [
                      Icon(MaterialCommunityIcons.car,color: kBlackColor,size: 20.sp,),
                      kHorizontalSpace4,
                      Text("Seats".tr,style: kTextStyle16,)
                    ],
                  ),    kVerticalSpace12,
                  GetBuilder<AddCarController>(
                      id: "seats",

                      builder:(controller)=>    DropdownWidget(hint: "NoOfSeats",value:
                      controller.car.seats,onChanged: (val){
                        controller.car.seats=val;
                        controller.update(["seats"]);
                      },validator: (value) => value == null ? kRequiredMsg.tr: null,
                        items: [DropdownMenuItem(child: Text("2".tr),value: 2,),
                          DropdownMenuItem(child: Text("4".tr),value: 4,),
                          DropdownMenuItem(child: Text("6".tr),value: 6,),
                          DropdownMenuItem(child: Text("8".tr),value: 8,),
                        ],
                      )),

                  kVerticalSpace12,
                  TextFieldWidget(labelText: "Mileage",
                    text: controller.car.mileage,
                    onChanged: (String val){

                        controller.car.mileage=val;


                    },
                    validator: (String? val){
                      if(val!.trim().isEmpty)
                        return kRequiredMsg.tr;
                      else
                        return null;
                    },),
                  kVerticalSpace12,
                  TextFieldWidget(labelText: "CarModel",
                    text: controller.car.modelYear,
                    onChanged: (String val){

                      controller.car.modelYear=val;


                    },
                    validator: (String? val){
                      if(val!.trim().isEmpty)
                        return kRequiredMsg.tr;
                      else
                        return null;
                    },),
                  kVerticalSpace12,
                  Row(
                    children: [
                      Icon(MaterialCommunityIcons.car,color: kBlackColor,size: 20.sp,),
                      kHorizontalSpace4,
                      Text("SelectGearType".tr,style: kTextStyle16,)
                    ],
                  ),    kVerticalSpace12,
                  GetBuilder<AddCarController>(
                      id: "gear",

                      builder:(controller)=>    DropdownWidget(hint: "GearType",value: controller.car.transmission,onChanged: (val){
                        controller.car.transmission=val;
                        controller.update(["gear"]);
                      },   validator: (value) => value == null ? kRequiredMsg.tr: null,
                        items: [DropdownMenuItem(child: Text("Automatic".tr),value: "Automatic",),
                          DropdownMenuItem(child: Text("Manual".tr),value: "Manual",),
                        ],
                      )),
                  kVerticalSpace12,
                  Row(
                    children: [
                      Icon(MaterialCommunityIcons.car,color: kBlackColor,size: 20.sp,),
                      kHorizontalSpace4,
                      Text("FuelType".tr,style: kTextStyle16,)
                    ],
                  ),    kVerticalSpace12,
                  GetBuilder<AddCarController>(
                      id: "fuel",

                      builder:(controller)=>    DropdownWidget(hint: "SelectFuelType",value: controller.car.fuelType,onChanged: (val){
                        controller.car.fuelType=val;
                        controller.update(["fuel"]);
                      },validator: (value) => value == null ? kRequiredMsg.tr: null,
                        items: [DropdownMenuItem(child: Text("Petrol".tr),value: "Petrol",),
                          DropdownMenuItem(child: Text("Diesel".tr),value: "Diesel",),
                          DropdownMenuItem(child: Text("Electrical".tr),value: "Electrical",),
                          DropdownMenuItem(child: Text("Gas".tr),value: "Gas",),
                        ],
                      )),
                  kVerticalSpace12,


                  Row(
                    children: [
                      Icon(MaterialCommunityIcons.view_list,color: kBlackColor,size: 20.sp,),
                      kHorizontalSpace4,
                      Text("CarFeatures".tr,style: kTextStyle14,)
                    ],
                  )

                  ,kVerticalSpace12,
                 GetBuilder<AddCarController>(builder: (controller)=> GestureDetector(
                    onTap: ()async{
                      if(controller.car.typeId==null){
                        showSnackBar(message: "SelectCarType");
                        return;
                      }
                      controller.getFeatures();
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
                        borderRadius: kTextFieldBorderRadius
                      ),
                    padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(controller.car.features.isEmpty?"NoFeaturesAdded".tr:"AddAnotherFeature".tr,style: kHintStyle,),
                          kVerticalSpace8,
                          Wrap(
                            runSpacing: 4.w,
                            spacing: 4.w,
                            children: controller.car.features.map((e) => Container(
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
                                    controller.car.features.remove(e);
                                    controller.update();
                                  },)
                                ],
                              ),
                            )).toList()
                          )
                        ],
                      ),

                    ),
                  )),
                kVerticalSpace12,
                  Row(
                    children: [
                      Icon(MaterialCommunityIcons.image,color: kBlackColor,size: 20.sp,),
                      kHorizontalSpace4,
                      Text("CarImages".tr   ,style: kTextStyle14,),
                      Spacer(),
                      TextButtonWidget(
                          onPressed: controller.uploadImages,
                          text:"AddImages"),
                    ],
                  )
                  ,kVerticalSpace12,



        GetBuilder<AddCarController>(

          builder:(controller)=> Visibility(
            visible: controller.images.value.isNotEmpty,
            child: Container(
              margin: EdgeInsets.only(bottom: 16.w),
                      height: 50.w,
                      child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context,index){
                            if(controller.images.value[index] is File){
                              return Stack(  clipBehavior: Clip.none,
                                children: [
                                  ImageWidget(null,file:controller.images.value[index],width: 100.w,height: 50.w,fit: BoxFit.cover,),
                                  Positioned(
                                    top:-8.w,
                                    right: -4.w,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black38,
                                          shape: BoxShape.circle
                                      ),
                                      child: IconButtonWidget(icon:MaterialCommunityIcons.close,iconSize: 16.sp,width: 23.w,color: kWhiteColor,onPressed: (){
                                        controller.images.value.removeAt(index);
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
                                  ImageWidget(controller.images.value[index],width: 100.w,height: 50.w,fit: BoxFit.cover,),
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
                                        controller.images.value.removeAt(index);
                                        controller.car.images.removeAt(index);
                                        controller.update();
                                      },),
                                    ),
                                  )
                                ],
                              );
                            }

                          }, separatorBuilder: (context,index){
                            return kHorizontalSpace12;
                      }, itemCount: controller.images.value.length),
                    ),
          ),),


        Container(color: kBgColor,
        width: 1.sw,
        padding:kScreenPadding,

        child:     ButtonWidget(onPressed: controller.addCar,text: "UploadNow",

        ),)
                ],
              ),

            ),
      ),
    );
  }



}
