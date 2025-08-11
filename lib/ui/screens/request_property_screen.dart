import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/add_request_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/models/city_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/cities_bottom_sheet.dart';
import 'package:careqar/ui/widgets/phone_number_text_field.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../global_variables.dart';
import '../../routes.dart';

class RequestPropertyScreen extends GetView<AddRequestController> {
  const RequestPropertyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 2,
      //   iconTheme: IconThemeData(color: kBlackColor),
      //   backgroundColor: kWhiteColor,
      //   title: Text("RequestForProperty".tr,
      //     style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20.sp,color: kBlackColor),),
      // ),
      body: Form(
        key: controller.formKey.value,
        autovalidateMode: AutovalidateMode.always,
        child: SingleChildScrollView(
          padding: kScreenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(MaterialCommunityIcons.map_marker,color: kBlackColor,size: 20.sp,),
                  kHorizontalSpace4,
                  Text("Locations".tr,style: kTextStyle14,)
                ],
              )
              ,kVerticalSpace4,
              GetBuilder<AddRequestController>(builder:(controller)=> TextFieldWidget(hintText: "SearchCity",onTap: ()async{
                var result =  await showCitiesSheet(context) as City;
                if(result!=null){
                  controller.request.cityNameAr=result.nameAr;
                  controller.request.cityNameEn=result.nameEn;
                  controller.request.cityId=result.cityId;
                  controller.request.locationAr=null;
                  controller.request.locationEn=null;
                  controller.request.locationId=null;
                  controller.update();
                }
              },
                text: controller.request.cityName,
              )),
              kVerticalSpace12,
              GetBuilder<AddRequestController>(builder:(controller)=> TextFieldWidget(hintText: "SearchLocation",onTap: ()async{
                if(controller.request.cityId!=null){
                  Location location = await  Get.toNamed(Routes.searchLocationScreen,
                      parameters: {"cityId":controller.request.cityId.toString()}) as Location;
                  if(location!=null){
                    controller.request.locationEn=location.titleEn;
                    controller.request.locationAr=location.titleAr;
                    controller.request.locationId=location.locationId;
                    controller.update();
                  }
                }else{
                  showSnackBar(message: "SelectCity");
                }

              },
                text: controller.request.location,
              )),

              kVerticalSpace12,

              Row(
                children: [
                  Icon(MaterialCommunityIcons.charity,color: kBlackColor,size: 20.sp,),
                  kHorizontalSpace4,
                  Text("Purpose".tr,style: kTextStyle14,)
                ],
              )
              ,kVerticalSpace12,
              GetBuilder<AddRequestController>(

                builder:(controller)=> Row(
                  children: [
                    Expanded(
                      child:  InkWell(
                        onTap: (){
                          controller.request.purpose=EnumToString.convertToString(Purpose.Sell);
                          controller.update();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 4.w,horizontal: 12.w),
                          decoration: BoxDecoration(

                              color: controller.request.purpose==EnumToString.convertToString(Purpose.Sell)?kPrimaryColor:null,
                              borderRadius: kBorderRadius30
                          ),
                          child: Text("Buy".tr,
                            textAlign: TextAlign.center,style:controller.request.purpose==EnumToString.convertToString(Purpose.Sell)?kLightTextStyle16:
                            kTextStyle16.copyWith(color: kGreyColor),),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          controller.request.purpose=EnumToString.convertToString(Purpose.Rent);
                          controller.update();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 4.w,horizontal: 12.w),
                          decoration: BoxDecoration(
                              color: controller.request.purpose==EnumToString.convertToString(Purpose.Rent)?kPrimaryColor:null,
                              borderRadius: kBorderRadius30
                          ),
                          child: Text(EnumToString.convertToString(Purpose.Rent).tr,textAlign: TextAlign.center,style:

                          controller.request.purpose==EnumToString.convertToString(Purpose.Rent)?kLightTextStyle16:
                          kTextStyle16.copyWith(color: kGreyColor),),
                        ),
                      ),
                    ),

                  ],
                ),),
         kVerticalSpace12,


              Row(
                children: [
                  Icon(CupertinoIcons.map_pin_ellipse,color: kBlackColor,size: 20.sp,),
                  kHorizontalSpace4,
                  Text("Area".tr,style: kTextStyle14,)
                ],
              )
              ,kVerticalSpace12,

              TextFieldWidget(hintText: "Area",
                keyboardType: TextInputType.number,
                text: controller.request.area?.toString(),
                onChanged: (String? val){
                  if(val==""){
                    controller.request.area=null;
                  }else{
                    controller.request.area=double.parse(val!);
                  }
                },
                validator: (String? val){
                  if(val!.trim().isEmpty)
                    return kRequiredMsg;
                  else
                    return null;
                },),
              kVerticalSpace12,

              Row(
                children: [
                  Icon(MaterialCommunityIcons.tag_outline,color: kBlackColor,size: 20.sp,),
                  kHorizontalSpace4,
                  Text("PriceRange".tr,style: kTextStyle14,),
                  Spacer(),
                  Text("${gSelectedCountry!.currency}",style: TextStyle(color: kBlackColor,fontSize: 16.sp,fontWeight: FontWeight.w600),)

                ],
              )
              ,kVerticalSpace12,
              Row(
                children: [
                  Expanded(child:  TextFieldWidget(hintText: "StartPrice",  keyboardType: TextInputType.number,
                    text: controller.request.startPrice?.toString(),
                    onChanged: (String? val){
                      if(val==""){
                        controller.request.startPrice=null;
                      }else{
                        controller.request.startPrice=double.parse(val!);
                      }

                    },
                    validator: (String? val){
                      if(val!.trim().isEmpty)
                        return kRequiredMsg;
                      else
                        return null;
                    },),),
                  Text(" ${"To".tr} ",style: TextStyle(color: kBlackColor,fontSize: 16.sp,fontWeight: FontWeight.w600),)
                  ,
                  Expanded(child:  TextFieldWidget(hintText: "EndPrice",  keyboardType: TextInputType.number,
                    text: controller.request.endPrice?.toString(),
                    onChanged: (String? val){
                      if(val==""){
                        controller.request.endPrice=null;
                      }else{
                        controller.request.endPrice=double.parse(val!);
                      }

                    },
                    validator: (String? val){
                      if(val!.trim().isEmpty)
                        return kRequiredMsg;
                      else
                        return null;
                    },),),
                ],
              ),

              kVerticalSpace12,
              Row(
                children: [
                  Icon(MaterialCommunityIcons.hospital_building,color: kBlackColor,size: 20.sp,),
                  kHorizontalSpace4,
                  Text("PropertyTypes".tr,style: kTextStyle14,)
                ],
              )
              ,kVerticalSpace4,

              Obx(()=>
                  DefaultTabController(length: controller.typeController.typeModel.value.types.length, child: SizedBox(
                    height: 100.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TabBar(
                          isScrollable: true,
                          indicatorColor: kAccentColor,
                          indicatorWeight: 3.w,
                          indicatorSize: TabBarIndicatorSize.label,
                          unselectedLabelColor: kGreyColor,
                          labelColor: kAccentColor,
                          labelPadding: EdgeInsets.only(top: 2.h,right: 12.w,left: 12.w),
                          unselectedLabelStyle: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.w600),
                          labelStyle: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.w600),
                          tabs: controller.typeController.typeModel.value.types.map((e) => Tab(child: Text(e.type!),)).toList(),),

                        Divider(height: 0,),

                        kVerticalSpace16,
                        GetBuilder<AddRequestController>(
                          builder:(controller)=> SizedBox(
                            height: 30.h,
                            child: TabBarView(children: controller.typeController.typeModel.value.types.map((e) =>
                                ListView.separated(
                                  itemCount: e.subTypes.length,
                                  separatorBuilder: (context,index){
                                    return kHorizontalSpace12;
                                  },
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context,index){
                                    return  GestureDetector(

                                      onTap: (){
                                        controller.request.typeId=e.typeId;
                                        controller.request.typeAr=e.typeAr;
                                        controller.request.typeEn=e.typeEn;
                                        controller.request.subTypeId=e.subTypes[index].subTypeId;
                                        controller.request.subTypeAr=e.subTypes[index].subTypeAr;
                                        controller.request.subTypeEn=e.subTypes[index].subTypeEn;
                                        controller.update();
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(vertical: 2.w,horizontal: 8.w),
                                        decoration: BoxDecoration(
                                          borderRadius: kBorderRadius30,
                                          color: controller.request.subTypeId==e.subTypes[index].subTypeId? kAccentColor : Colors.grey.shade300,
                                        ),
                                        child: Text(e.subTypes[index].subType!,style: TextStyle(color:  controller.request.subTypeId==e.subTypes[index].subTypeId? kWhiteColor: kBlackColor,fontSize: 15.sp),),
                                      ),
                                    );
                                  },
                                )).toList()

                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
              )
              ,
              kVerticalSpace12,
              Row(
                children: [
                  Icon(Icons.king_bed_outlined,color: kBlackColor,size: 20.sp,),
                  kHorizontalSpace4,
                  Text("Bedrooms".tr,style: kTextStyle14,)
                ],
              )
              ,kVerticalSpace12,  TextFieldWidget(hintText: "Bedrooms", keyboardType: TextInputType.number,
                text: controller.request.bedrooms?.toString(),  textAlign: TextAlign.center,
                onChanged: (String? val){
                  if(val==""){
                    controller.request.bedrooms=null;
                  }else{
                    controller.request.bedrooms=int.parse(val!);
                  }

                },
                validator: (String? val){
                  if(val!.trim().isEmpty)
                    return kRequiredMsg;
                  else
                    return null;
                },),
              kVerticalSpace12,
              Row(
                children: [
                  Icon(Icons.bathtub_outlined,color: kBlackColor,size: 20.sp,),
                  kHorizontalSpace4,
                  Text("Baths",style: kTextStyle14,)
                ],
              )
              ,kVerticalSpace12,  TextFieldWidget(hintText: "TypeNumberOfBathrooms",keyboardType: TextInputType.number,
                text: controller.request.baths?.toString(),
                textAlign: TextAlign.center,
                onChanged: (String? val){
                  if(val==""){
                    controller.request.baths=null;
                  }else{
                    controller.request.baths=int.parse(val!);
                  }

                },
                validator: (String? val){
                  if(val!.trim().isEmpty)
                    return kRequiredMsg;
                  else
                    return null;
                },),
              kVerticalSpace12,
              Row(
                children: [
                  Icon(Icons.kitchen_outlined,color: kBlackColor,size: 20.sp,),
                  kHorizontalSpace4,
                  Text("Kitchens".tr,style: kTextStyle14,)
                ],
              )
              ,kVerticalSpace12,  TextFieldWidget(hintText: "Kitchens",keyboardType: TextInputType.number,
                text: controller.request.kitchens?.toString(),  textAlign: TextAlign.center,
                onChanged: (String? val){
                  if(val==""){
                    controller.request.kitchens=null;
                  }else{
                    controller.request.kitchens=int.parse(val!);
                  }

                },
                validator: (String? val){
                  if(val!.trim().isEmpty)
                    return kRequiredMsg;
                  else
                    return null;
                },),
              kVerticalSpace12,
              Row(
                children: [
                  Icon(MaterialCommunityIcons.phone,color: kBlackColor,size: 20.sp,),
                  kHorizontalSpace4,
                  Text("PhoneNumber".tr,style: kTextStyle14,)
                ],
              )
              ,kVerticalSpace12,

              PhoneNumberTextField(hintText: "PhoneNumber",

                value: controller.request.phoneNumber,
                onChanged: (val){

                    controller.request.phoneNumber=val;


                },
              ),

              kVerticalSpace16,
        ButtonWidget(onPressed: controller.addRequest,text: "UploadNow",)

            ],
          ),
        ),
      )
    );
  }



}
