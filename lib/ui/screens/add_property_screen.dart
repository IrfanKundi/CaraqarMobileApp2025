import 'dart:io';

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/add_property_controller.dart';
import 'package:careqar/controllers/property_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/models/city_model.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/cities_bottom_sheet.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:careqar/ui/widgets/text_button_widget.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../locale/convertor.dart';
import '../widgets/phone_number_text_field.dart';

class AddPropertyScreen extends GetView<AddPropertyController> {
  const AddPropertyScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final List<String> plotSizes = ["Marla", "Kanal", "Acre"];
    return Scaffold(
      //appBar: buildAppBar(context,title: "AddProperty")
      //,
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
                      Icon(MaterialCommunityIcons.map_marker,color: kBlackColor,size: 20.sp,),
                      kHorizontalSpace4,
                      Text("Location".tr,style: kTextStyle16,)
                    ],
                  )
                  ,kVerticalSpace12,
                  GetBuilder<AddPropertyController>(builder:(controller)=> TextFieldWidget(hintText: "Select Region",onTap: ()async{
                    var result =  await showCitiesSheet(context) as City;
                    if(result!=null){
                      controller.property.cityNameAr=result.nameAr;
                      controller.property.cityNameEn=result.nameEn;
                      controller.property.cityId=result.cityId;
                      controller.property.locationAr=null;
                      controller.property.locationEn=null;
                      controller.property.locationId=null;
                      controller.update();
                    }
                  },
                    text: controller.property.cityName,
                  )),
                  kVerticalSpace12,
                  GetBuilder<AddPropertyController>(builder:(controller)=> TextFieldWidget(hintText: "Select City",onTap: ()async{
                    if(controller.property.cityId!=null){
                      Location location = await  Get.toNamed(Routes.searchLocationScreen,
                          parameters: {"cityId":controller.property.cityId.toString()}) as Location;
                      if(location!=null){
                        controller.property.locationEn=location.titleEn;
                        controller.property.locationAr=location.titleAr;
                        controller.property.locationId=location.locationId;
                        controller.update();
                      }
                    }else{
                      showSnackBar(message: "SelectCity");
                    }

                  },
                    text: controller.property.location,
                  )),

                  kVerticalSpace12,


                  Row(
                    children: [
                      Icon(MaterialCommunityIcons.charity,color: kBlackColor,size: 20.sp,),
                      kHorizontalSpace4,
                      Text("Purpose".tr,style: kTextStyle16,)
                    ],
                  )
                  ,kVerticalSpace12,
        GetBuilder<AddPropertyController>(

          builder:(controller)=> Row(
                    children: [
                     Expanded(
                          child:  InkWell(
                            onTap: (){
                              controller.property.purpose=EnumToString.convertToString(Purpose.Sell);
                              controller.update();
                            },
                            child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4.w,horizontal: 12.w),
                            decoration: BoxDecoration(

                                color: controller.property.purpose==EnumToString.convertToString(Purpose.Sell)?kPrimaryColor:null,
                              borderRadius: kBorderRadius30
                            ),
                            child: Text(EnumToString.convertToString(Purpose.Sell).tr,
                              textAlign: TextAlign.center,style:controller.property.purpose==EnumToString.convertToString(Purpose.Sell)?kLightTextStyle16:
                              kTextStyle16.copyWith(color: kGreyColor),),
                          ),
                        ),
                      ),
                      Expanded(
                          child: InkWell(
                            onTap: (){
                              controller.property.purpose=EnumToString.convertToString(Purpose.Rent);
                              controller.update();
                            },
                            child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4.w,horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: controller.property.purpose==EnumToString.convertToString(Purpose.Rent)?kPrimaryColor:null,
                                borderRadius: kBorderRadius30
                            ),
                            child: Text(EnumToString.convertToString(Purpose.Rent).tr,textAlign: TextAlign.center,style:

                            controller.property.purpose==EnumToString.convertToString(Purpose.Rent)?kLightTextStyle16:
                            kTextStyle16.copyWith(color: kGreyColor),),
                          ),
                        ),
                      ),

                    ],
                  ),),
                  kVerticalSpace12,
                  Row(
                    children: [
                      Icon(MaterialCommunityIcons.office_building,color: kBlackColor,size: 20.sp,),
                      kHorizontalSpace4,
                      Expanded(child: Text("Details".tr,style: kTextStyle16,)),

                      GetBuilder<AddPropertyController>(
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
                                    color:gSelectedCountry?.countryId==11? kAccentColor : controller.lang==0? kAccentColor:null,
                                    borderRadius: kBorderRadius30
                                ),
                                child: Text("English".tr,
                                    textAlign: TextAlign.center,
                                    style:gSelectedCountry?.countryId==11? kLightTextStyle12 : controller.lang==0? kLightTextStyle12:
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
        GetBuilder<AddPropertyController>(
          id: "lang",

          builder:(controller)=> Column(
            children: [
              gSelectedCountry?.countryId==11 || controller.lang==0 || controller.lang==2?
              Padding(
                padding:  EdgeInsets.only(bottom: 12.w),
                child: TextFieldWidget(hintText: "PropertyTitleEnglish",
                  text: controller.property.title,
                  onChanged: (String val){
                    controller.property.titleEn=val.trim();
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
                child: TextFieldWidget(hintText: "PropertyTitleArabic",
                  text: controller.property.titleAr,
                  onChanged: (String val){
                    controller.property.titleAr=val.trim();
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
                child: TextFieldWidget(hintText: "PropertyDescriptionEnglish",maxLines: 3, text: controller.property.description,
                  onChanged: (String val){
                    controller.property.descriptionEn=val.trim();
                  },
                  textInputAction: TextInputAction.newline,
                  validator: (String? val){
                    if(val!.trim().isEmpty)
                      return kRequiredMsg.tr;
                    else
                      return null;
                  },),
              ):Container(),

              gSelectedCountry?.countryId!=11 && (controller.lang==1 || controller.lang==2)?     Padding(
                padding:  EdgeInsets.only(bottom: 12.w),
                child: TextFieldWidget(hintText: "PropertyDescriptionArabic",maxLines: 3, text: controller.property.descriptionAr,
                  onChanged: (String val){
                    controller.property.descriptionAr=val.trim();
                  },  textInputAction: TextInputAction.newline,
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
                      Icon(CupertinoIcons.map_pin_ellipse,color: kBlackColor,size: 20.sp,),
                      kHorizontalSpace4,
                      Text("Area".tr,style: kTextStyle14,)
                    ],
                  )
                  ,kVerticalSpace12,

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldWidget(
                        hintText: "Area",
                        keyboardType: TextInputType.number,
                        text: controller.property.area?.toString(),
                        onChanged: (String val) {
                          if (val == "") {
                            controller.property.area = null;
                          } else {
                            controller.property.area = double.tryParse(val);
                          }
                          controller.update(); // Update UI conditionally
                        },
                        validator: (String? val) {
                          if (val!.trim().isEmpty)
                            return kRequiredMsg.tr;
                          return null;
                        },
                      ),
                      // 👇 Conditionally render the ListView if area is not null
                      GetBuilder<AddPropertyController>(
                        builder: (controller) {
                          if (controller.property.area == null) return SizedBox.shrink();

                          final List<String> plotSizes = ["Marla", "Kanal", "Acre"];
                          return Padding(
                            padding: EdgeInsets.only(top: 12.w),
                            child: SizedBox(
                              height: 30.h,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: plotSizes.length,
                                separatorBuilder: (context, index) => SizedBox(width: 12.w),
                                itemBuilder: (context, index) {
                                  final item = plotSizes[index];
                                  final isSelected = controller.selectedPlotSize.value == item;

                                  return GestureDetector(
                                    onTap: () {
                                      controller.selectedPlotSize.value = item;
                                      controller.update();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(vertical: 2.w, horizontal: 8.w),
                                      decoration: BoxDecoration(
                                        borderRadius: kBorderRadius12,
                                        color: isSelected ? kAccentColor : Colors.grey.shade300,
                                      ),
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          color: isSelected ? kWhiteColor : kBlackColor,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  kVerticalSpace12,
                  //sahar work

                  Row(
                    children: [
                      Icon(MaterialCommunityIcons.tag_outline,color: kBlackColor,size: 20.sp,),
                      kHorizontalSpace4,
                      Text("Price".tr,style: kTextStyle14,)
                    ],
                  )
                  ,kVerticalSpace12,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldWidget(
                        hintText: "Price",
                        keyboardType: TextInputType.number,
                        text: controller.property.price?.toString(),
                        onChanged: (String val) {
                          if (val == "") {
                            controller.property.price = null;
                            controller.priceInWords.value = '';
                          } else {
                            try {
                              controller.property.price = double.parse(val);
                              final formatted = formatIndianNumber(controller.property.price!.toInt());
                              controller.priceInWords.value = '${formatted.capitalize!.trim() ?? ''}';
                            } catch (_) {
                              controller.priceInWords.value = '';
                            }
                          }
                        },
                        validator: (String? val) {
                          if (val!.trim().isEmpty) return kRequiredMsg.tr;
                          return null;
                        },
                      ),

                      // 👇 Place this right below the TextFieldWidget
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
                  kVerticalSpace12,
                  Row(
                    children: [
                      Icon(MaterialCommunityIcons.hospital_building,color: kBlackColor,size: 20.sp,),
                      kHorizontalSpace4,
                      Text("PropertyType".tr,style: kTextStyle16,)
                    ],
                  )
                  ,kVerticalSpace4,

                  Obx(()=>
                      DefaultTabController(length: controller.typeController.typeModel.value.types.length,

                          initialIndex:controller.selectedType==null?0: controller.typeController.typeModel.value.types.indexOf(controller.selectedType!)
                          , child: Container(
                        height: 100.h,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TabBar(
                              indicatorColor: kAccentColor,
                              indicatorWeight: 3.w,
                              isScrollable: true,
                              indicatorSize: TabBarIndicatorSize.label,
                              unselectedLabelColor: kGreyColor,
                              labelColor: kAccentColor,
                              labelPadding: EdgeInsets.only(top: 2.h,right: 12.w,left: 12.w),
                              unselectedLabelStyle: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.w600),
                              labelStyle: TextStyle(fontSize: 13.sp,fontWeight: FontWeight.w600),
                              tabs: controller.typeController.typeModel.value.types.map((e) => Tab(child: Text(e.type!),)).toList(),),

                            Divider(height: 0,),

                            kVerticalSpace16,
                            GetBuilder<AddPropertyController>(
                              builder:(controller)=> Container(
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
                                            controller.property.typeId=e.typeId;
                                            controller.property.typeAr=e.typeAr;
                                            controller.property.typeEn=e.typeEn;
                                            controller.property.subTypeId=e.subTypes[index].subTypeId;
                                            controller.property.subTypeAr=e.subTypes[index].subTypeAr;
                                            controller.property.subTypeEn=e.subTypes[index].subTypeEn;
                                            controller.property.features.clear();
                                            controller.selectedSubtype=e.subTypes[index];
                                            controller.update();
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(vertical: 2.w,horizontal: 8.w),
                                            decoration: BoxDecoration(
                                              borderRadius: kBorderRadius12,
                                              color: controller.property.subTypeId==e.subTypes[index].subTypeId? kAccentColor : Colors.grey.shade300,
                                            ),
                                            child: Text(e.subTypes[index].subType!,style: TextStyle(color:  controller.property.subTypeId==e.subTypes[index].subTypeId? kWhiteColor: kBlackColor,fontSize: 15.sp),),
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
                  GetBuilder<AddPropertyController>(
                    builder: (controller)=>

                    Visibility(
                      visible: controller.property.subTypeId!=null,
                      child:

                  controller.property.typeId==3?
                  Container():
                  controller.property.typeId==1?
                  Column(
                    children: [
                      if(controller.selectedSubtype?.floors ?? false)
                        GetBuilder<AddPropertyController>(
                          id: "floors",
                          builder: (controller) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.w),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.business, color: kBlackColor, size: 20.sp),
                                      kHorizontalSpace4,
                                      Text("${"Floors".tr} (${controller.property.floors})", style: kTextStyle14),
                                    ],
                                  ),
                                  kVerticalSpace12,
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove, color: Theme.of(context).colorScheme.primary),
                                        onPressed: () {
                                          if (controller.property.floors! > 0) {
                                            controller.property.floors = controller.property.floors! - 1;
                                            controller.update(["floors"]);
                                          }
                                        },
                                      ),
                                      Expanded(
                                        child: Slider(
                                          value: controller.property.floors!.toDouble(),
                                          onChanged: (val) {
                                            controller.property.floors = val.toInt();
                                            controller.update(["floors"]);
                                          },
                                          label: controller.property.floors!.toStringAsFixed(0),
                                          divisions: 50,
                                          min: 0,
                                          max: 50,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
                                        onPressed: () {
                                          if (controller.property.floors! < 50) {
                                            controller.property.floors = controller.property.floors! + 1;
                                            controller.update(["floors"]);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      if(controller.selectedSubtype?.rooms??false)
                        GetBuilder<AddPropertyController>(
                          id: "bedrooms",
                          builder: (controller) {
                            final primaryColor = Theme.of(context).colorScheme.primary;

                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.w),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.king_bed_outlined, color: kBlackColor, size: 20.sp),
                                      kHorizontalSpace4,
                                      Text(
                                        "${"Bedrooms".tr} (${controller.property.bedrooms})",
                                        style: kTextStyle14,
                                      ),
                                    ],
                                  ),
                                  kVerticalSpace12,
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove, color: primaryColor),
                                        onPressed: () {
                                          if (controller.property.bedrooms! > 0) {
                                            controller.property.bedrooms = controller.property.bedrooms! - 1;
                                            controller.update(["bedrooms"]);
                                          }
                                        },
                                      ),
                                      Expanded(
                                        child: Slider(
                                          value: controller.property.bedrooms!.toDouble(),
                                          onChanged: (val) {
                                            controller.property.bedrooms = val.toInt();
                                            controller.update(["bedrooms"]);
                                          },
                                          label: controller.property.bedrooms!.toStringAsFixed(0),
                                          divisions: 10,
                                          min: 0,
                                          max: 10,
                                          activeColor: primaryColor,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add, color: primaryColor),
                                        onPressed: () {
                                          if (controller.property.bedrooms! < 10) {
                                            controller.property.bedrooms = controller.property.bedrooms! + 1;
                                            controller.update(["bedrooms"]);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                      if(controller.selectedSubtype?.bathrooms??false)
                        GetBuilder<AddPropertyController>(
                          id: "baths",
                          builder: (controller) {
                            final primaryColor = Theme.of(context).colorScheme.primary;

                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.w),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.bathtub_outlined, color: kBlackColor, size: 20.sp),
                                      kHorizontalSpace4,
                                      Text(
                                        "${"Baths".tr} (${controller.property.baths})",
                                        style: kTextStyle14,
                                      ),
                                    ],
                                  ),
                                  kVerticalSpace12,
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove, color: primaryColor),
                                        onPressed: () {
                                          if (controller.property.baths! > 0) {
                                            controller.property.baths = controller.property.baths! - 1;
                                            controller.update(["baths"]);
                                          }
                                        },
                                      ),
                                      Expanded(
                                        child: Slider(
                                          value: controller.property.baths!.toDouble(),
                                          onChanged: (val) {
                                            controller.property.baths = val.toInt();
                                            controller.update(["baths"]);
                                          },
                                          label: controller.property.baths!.toStringAsFixed(0),
                                          divisions: 10,
                                          min: 0,
                                          max: 10,
                                          activeColor: primaryColor,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add, color: primaryColor),
                                        onPressed: () {
                                          if (controller.property.baths! < 10) {
                                            controller.property.baths = controller.property.baths! + 1;
                                            controller.update(["baths"]);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      if(controller.selectedSubtype?.kitchens??false)
                        GetBuilder<AddPropertyController>(
                          id: "kitchens",
                          builder: (controller) {
                            final primaryColor = Theme.of(context).colorScheme.primary;

                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.w),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.kitchen_outlined, color: kBlackColor, size: 20.sp),
                                      kHorizontalSpace4,
                                      Text(
                                        "${"Kitchens".tr} (${controller.property.kitchens})",
                                        style: kTextStyle14,
                                      ),
                                    ],
                                  ),
                                  kVerticalSpace12,
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove, color: primaryColor),
                                        onPressed: () {
                                          if (controller.property.kitchens! > 0) {
                                            controller.property.kitchens = controller.property.kitchens! - 1;
                                            controller.update(["kitchens"]);
                                          }
                                        },
                                      ),
                                      Expanded(
                                        child: Slider(
                                          value: controller.property.kitchens!.toDouble(),
                                          onChanged: (val) {
                                            controller.property.kitchens = val.toInt();
                                            controller.update(["kitchens"]);
                                          },
                                          label: controller.property.kitchens!.toStringAsFixed(0),
                                          divisions: 5,
                                          min: 0,
                                          max: 5,
                                          activeColor: primaryColor,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add, color: primaryColor),
                                        onPressed: () {
                                          if (controller.property.kitchens! < 5) {
                                            controller.property.kitchens = controller.property.kitchens! + 1;
                                            controller.update(["kitchens"]);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      if(controller.selectedSubtype?.furnish??false)
                        GetBuilder<AddPropertyController>(
                          id: "furnished",
                          builder: (controller) => Padding(
                            padding: EdgeInsets.only(bottom: 12.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.brush_outlined, color: kBlackColor, size: 20.sp),
                                    kHorizontalSpace4,
                                    Text("Furnished".tr, style: kTextStyle14),
                                  ],
                                ),
                                kVerticalSpace12,
                                Wrap(
                                  spacing: 10.w,
                                  runSpacing: 8.w,
                                  children: furnished.map((e) {
                                    final isSelected = controller.property.furnished == e;
                                    return SizedBox(
                                      width: 140.w,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 20.w,
                                            height: 20.w,
                                            child: Checkbox(
                                              value: isSelected,
                                              onChanged: (val) {
                                                controller.property.furnished = isSelected ? "" : e;
                                                controller.update(["furnished"]);
                                              },
                                            ),
                                          ),
                                          SizedBox(width: 6.w),
                                          Expanded(
                                            child: Text(
                                              e.tr,
                                              style: TextStyle(fontSize: 14.sp),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  )
                      :
                  Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if(controller.selectedSubtype?.floors??false)
                        Padding(
                        padding:  EdgeInsets.only(bottom: 12.w),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.business,color: kBlackColor,size: 20.sp,),
                                kHorizontalSpace4,
                                Text("Floors".tr,style: kTextStyle14,)
                              ],
                            )
                            ,kVerticalSpace12,
                            TextFieldWidget(hintText: "Floors", keyboardType: TextInputType.number,
                              text: controller.property.floors?.toString(),
                              textAlign: TextAlign.center,
                              onChanged: (String val){
                                if(val==""){
                                  controller.property.floors=null;
                                }else{
                                  controller.property.floors=int.parse(val);
                                }

                              },
                              validator: (String? val){
                                if(val!.trim().isEmpty)
                                  return kRequiredMsg.tr;
                                else
                                  return null;
                              },),
                          ],
                        ),
                      )
                      ,
                      if(controller.selectedSubtype?.rooms??false)
                        Padding(
                        padding:  EdgeInsets.only(bottom: 12.w),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.king_bed_outlined,color: kBlackColor,size: 20.sp,),
                                kHorizontalSpace4,
                                Text("Rooms".tr,style: kTextStyle14,)
                              ],
                            )
                          ,kVerticalSpace12,
                    TextFieldWidget(hintText: "Rooms", keyboardType: TextInputType.number,
                    text: controller.property.bedrooms?.toString(),     textAlign: TextAlign.center,
                    onChanged: (String val){
                        if(val==""){
                          controller.property.bedrooms=null;
                        }else{
                          controller.property.bedrooms=int.parse(val);
                        }

                    },
                    validator: (String? val){
                        if(val!.trim().isEmpty)
                          return kRequiredMsg.tr;
                        else
                          return null;
                    },),
                          ],
                        ),
                      )
                    ,
                      if(controller.selectedSubtype?.bathrooms??false)
                        Padding(
                        padding:  EdgeInsets.only(bottom: 12.w),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.bathtub_outlined,color: kBlackColor,size: 20.sp,),
                                kHorizontalSpace4,
                                Text("Baths".tr,style: kTextStyle14,)
                              ],
                            )
                            ,kVerticalSpace12,
                            TextFieldWidget(hintText: "TypeNumberOfBathrooms",keyboardType: TextInputType.number,
                              text: controller.property.baths?.toString(),     textAlign: TextAlign.center,
                              onChanged: (String val){
                                if(val==""){
                                  controller.property.baths=null;
                                }else{
                                  controller.property.baths=int.parse(val);
                                }

                              },
                              validator: (String? val){
                                if(val!.trim().isEmpty)
                                  return kRequiredMsg.tr;
                                else
                                  return null;
                              },),
                          ],
                        ),
                      ),
                      if(controller.selectedSubtype?.kitchens??false)
                        Padding(
                        padding:  EdgeInsets.only(bottom: 12.w),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.kitchen_outlined,color: kBlackColor,size: 20.sp,),
                                kHorizontalSpace4,
                                Text("Kitchens".tr,style: kTextStyle14,)
                              ],
                            ),
                            kVerticalSpace12,
                            TextFieldWidget(hintText: "Kitchens",keyboardType: TextInputType.number,
                              text: controller.property.kitchens?.toString(),     textAlign: TextAlign.center,
                              onChanged: (String val){
                                if(val==""){
                                  controller.property.kitchens=null;
                                }else{
                                  controller.property.kitchens=int.parse(val);
                                }

                              },
                              validator: (String? val){
                                if(val!.trim().isEmpty)
                                  return kRequiredMsg.tr;
                                else
                                  return null;
                              },),
                          ],
                        ),
                      )
                     ,
                      if(controller.selectedSubtype?.furnish??false)
                        Padding(
                        padding:  EdgeInsets.only(bottom: 12.w),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.brush_outlined,color: kBlackColor,size: 20.sp,),
                                kHorizontalSpace2,
                                Text("Furnished".tr,style: kTextStyle14,)
                              ],
                            ),
                            kVerticalSpace12,
                            GetBuilder<AddPropertyController>(
                              builder: (controller)=>
                                  Row(
                                      children: furnished.map((e) =>
                                          Expanded(
                                            child: Row(
                                                children:[
                                                  SizedBox(
                                                    width: 20.w,
                                                    height: 20.w,
                                                    child: Checkbox(
                                                      value: controller.property.furnished==e,
                                                      onChanged: (val) {
                                                        if(e==controller.property.furnished){
                                                          controller.property.furnished="";
                                                        }else{
                                                          controller.property.furnished=e;
                                                        }
                                                        controller.update();
                                                      },
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Text(" ${e.tr}",style: TextStyle(fontSize: 14.sp),

                                                    ),
                                                  )
                                                ]
                                            ),
                                          )
                                      ).toList()
                                  ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                  )),
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

                    value: controller.property.phoneNumber,
                    onChanged: (val){
                      controller.property.phoneNumber=val;
                    },
                  ),

                  kVerticalSpace12,

                  Row(
                    children: [
                      Icon(MaterialCommunityIcons.view_list,color: kBlackColor,size: 20.sp,),
                      kHorizontalSpace4,
                      Text("PropertyFeatures".
                      tr,style: kTextStyle14,)
                    ],
                  )
                  ,kVerticalSpace12,
                 GetBuilder<AddPropertyController>(builder: (controller)=> GestureDetector(
                    onTap: ()async{
                      if(controller.property.subTypeId==null){
                        showSnackBar(message: "SelectPropertyType");
                        return;
                      }
                      controller.getFeatures();
                    await  Get.toNamed(Routes.addFeaturesScreen);
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
                          Text(controller.property.features.isEmpty?"NoFeaturesAdded".tr:"AddAnotherFeature".tr,style: kHintStyle,),
                          kVerticalSpace8,
                          Wrap(
                            runSpacing: 4.w,
                            spacing: 4.w,
                            children: controller.property.features.map((e) => Container(
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
                                    controller.property.features.remove(e);
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
                      Text("PropertyImages".tr   ,style: kTextStyle14,),
                      Spacer(),
                      TextButtonWidget(
                          onPressed: controller.uploadImages,
                          text:"AddImages"),
                    ],
                  )
                  ,kVerticalSpace12,



        GetBuilder<AddPropertyController>(

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
                                        controller.property.images.removeAt(index);
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

        child:     ButtonWidget(onPressed: controller.addProperty,text: "UploadNow",

        ),)
                ],
              ),

            ),
      ),
    );
  }



}
