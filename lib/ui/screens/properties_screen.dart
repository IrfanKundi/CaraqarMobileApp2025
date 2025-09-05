import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/property_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/cities_bottom_sheet.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/small_button.dart';
import 'package:careqar/ui/widgets/text_button_widget.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

class PropertiesScreen extends GetView<PropertyController> {
   PropertiesScreen({Key? key}) : super(key: key){

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //
    //   String title=Get.parameters["title"];
    //   if(controller.properties.value.isEmpty){
    //     controller.resetFilters();
    //     controller.getFilteredProperties();
    //   }
    //
    // });
  }

  @override
  Widget build(BuildContext context) {
    //String? title=Get.parameters["title"];


    return Scaffold(
      appBar: buildAppBar(context,title: "AllProperties"),
      body:  GetBuilder<PropertyController>(
        builder: (controller)=> Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.w),
              child: Column(
                  children: [
                    // Search Bar and Toggle Row
                    Padding(
                      padding: EdgeInsets.only(bottom:8.h),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(22.5.r),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 16.w),
                                    child: Icon(
                                      Icons.search,
                                      color: Colors.grey.shade600,
                                      size: 20.sp,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: "Search for property",
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 14.sp,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                      ),
                                      style: TextStyle(fontSize: 14.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          IconButtonWidget(
                            color: kAccentColor,
                            onPressed: () {
                              controller.isGridView = !controller.isGridView;
                              controller.update();
                            },
                            icon: controller.isGridView
                                ? MaterialCommunityIcons.view_list
                                : MaterialCommunityIcons.view_grid,
                            iconSize: 32.sp,
                          ),
                        ],
                      ),
                    ),

                    // Original Control Row with Sort Button Added
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SmallButtonWidget(
                          height: 30.h,
                          color: kLableColor,
                          text: "Sort",
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.r),
                                ),
                              ),
                              builder: (BuildContext context) {
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical:20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Sort By",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold,
                                          color: kBlackColor,
                                        ),
                                      ),
                                      // Sort options
                                      _buildSortOption("Date Updated (New to Old)"),
                                      _buildSortOption("Date Updated (Old to New)"),
                                      _buildSortOption("Price (High to Low)"),
                                      _buildSortOption("Price (Low to High)"),
                                      SizedBox(height: 20.h),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icons.sort,
                        ),
                        const Spacer(),
                        // Your Original Sell/Rent Toggle (Unchanged)
                        Container(
                          width: 0.28.sw,
                          height: 30.h,
                          decoration: BoxDecoration(
                              borderRadius: kBorderRadius30,
                              color: kWhiteColor,
                              border: Border.all(color: kMehrunColor)
                          ),
                          child: Obx(
                                () => Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (controller.isBuyerMode.value == true) {
                                        controller.isBuyerMode.value = null;
                                      } else {
                                        controller.isBuyerMode.value = true;
                                      }

                                      controller.loadMore.value = true;
                                      controller.page.value = 1;
                                      controller.getFilteredProperties();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: controller.isBuyerMode.value == true
                                            ? kMehrunColor
                                            : Colors.transparent,
                                        borderRadius: BorderRadiusDirectional.horizontal(start: Radius.circular(30.r)),
                                      ),
                                      child: Text(
                                        "Sell".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: controller
                                                .isBuyerMode
                                                .value == true
                                                ? kWhiteColor
                                                : kMehrunColor,
                                            fontSize: 16.sp,
                                            fontWeight:
                                            FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (controller.isBuyerMode.value == false) {
                                          controller.isBuyerMode.value = null;
                                        } else {
                                          controller.isBuyerMode.value = false;
                                        }
                                        controller.loadMore.value = true;
                                        controller.page.value = 1;
                                        controller.getFilteredProperties();
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: controller
                                              .isBuyerMode.value == false
                                              ? kMehrunColor : Colors.transparent,
                                          borderRadius: BorderRadiusDirectional.horizontal(end: Radius.circular(30.r)),
                                        ),
                                        child: Text(
                                          "Rent".tr,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: controller
                                                  .isBuyerMode.value == false
                                                  ? kWhiteColor
                                                  : kMehrunColor,
                                              fontSize: 16.sp,
                                              fontWeight:
                                              FontWeight.w600),
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                        kHorizontalSpace8,
                        // Your Original Filter Button (Unchanged)
                        ButtonWidget(
                          width: 0.34.sw,
                          height: 30.h,
                          color: kAccentColor,
                          text: "Filter",
                    onPressed: (){
                   Get.dialog(
                     Container(
                   height: 1.sh,
                       padding: kHorizontalScreenPadding,
                   width: 1.sw,
                   alignment: Alignment.center,
                   child: GetBuilder<PropertyController>(
                           id: "filters",
                           builder: (controller) {
                             return Obx(
                                   () => Container(
                                     decoration: BoxDecoration(
                                       borderRadius: kBorderRadius8,
                                       color: kBgColor,
                                     ),
                                     padding: EdgeInsets.symmetric(vertical: 16.w,horizontal: 8.w),


                                     child: Column(
                                         mainAxisSize: MainAxisSize.min,
                                         children: [
                                           kVerticalSpace12,
                                 SizedBox(
                                     height: 45.h,
                                     child: Row(
                                       children: [
                                         // ---------------------- City Selection ----------------------
                                         Expanded(
                                           child: InkWell(
                                             onTap: () async {
                                               var result = await showCitiesSheet(context);
                                               if (result != null) {
                                                 controller.selectedCity.value = result;
                                                 controller.selectedLocation.value = null;
                                               }
                                             },
                                             child: Row(
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                 Icon(
                                                   MaterialCommunityIcons.map_marker_outline,
                                                   color: kGreyColor,
                                                   size: 20.sp,
                                                 ),
                                                 kHorizontalSpace16,
                                                 Expanded(
                                                   child: Column(
                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                     mainAxisAlignment: MainAxisAlignment.center,
                                                     children: [
                                                       Text(
                                                         "Province".tr,
                                                         style: TextStyle(
                                                           color: kBlackColor,
                                                           fontSize: 14.sp,
                                                           fontWeight: FontWeight.w600,
                                                         ),
                                                       ),
                                                       SizedBox(height: 4),
                                                       Text(
                                                         controller.selectedCity.value?.name ?? 'SelectProvince'.tr,
                                                         style: TextStyle(
                                                           color: kPrimaryColor,
                                                           fontSize: 14.sp,
                                                         ),
                                                         maxLines: 1,
                                                         overflow: TextOverflow.ellipsis,
                                                         softWrap: false,
                                                       ),
                                                     ],
                                                   ),
                                                 ),
                                               ],
                                             ),
                                           ),
                                         ),

                                         // ---------------------- Location Selection ----------------------
                                         Expanded(
                                           child: InkWell(
                                             onTap: () async {
                                               if (controller.selectedCity.value == null) {
                                                 showSnackBar(message: "SelectCity");
                                               } else {
                                                 var result = await Get.toNamed(
                                                   Routes.searchLocationScreen,
                                                   parameters: {
                                                     "cityId": controller.selectedCity.value!.cityId.toString()
                                                   },
                                                 );
                                                 if (result != null) {
                                                   controller.selectedLocation.value = result;
                                                 }
                                               }
                                             },
                                             child: Row(
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                 Icon(
                                                   MaterialCommunityIcons.map_outline,
                                                   color: kGreyColor,
                                                   size: 20.sp,
                                                 ),
                                                 kHorizontalSpace16,
                                                 Expanded(
                                                   child: Column(
                                                     crossAxisAlignment: CrossAxisAlignment.start,
                                                     mainAxisAlignment: MainAxisAlignment.center,
                                                     children: [
                                                       Text(
                                                         "City".tr,
                                                         style: TextStyle(
                                                           color: kBlackColor,
                                                           fontSize: 14.sp,
                                                           fontWeight: FontWeight.w600,
                                                         ),
                                                       ),
                                                       SizedBox(height: 4),
                                                       Text(
                                                         controller.selectedLocation.value?.title ?? 'SelectCity'.tr,
                                                         style: TextStyle(
                                                           color: kPrimaryColor,
                                                           fontSize: 14.sp,
                                                         ),
                                                         maxLines: 1,
                                                         overflow: TextOverflow.ellipsis,
                                                         softWrap: false,
                                                       ),
                                                     ],
                                                   ),
                                                 ),
                                               ],
                                             ),
                                           ),
                                         ),
                                       ],
                                     ),
                                 ),
                                 const Divider(),
                                           Row(
                                             children: [
                                               Icon(
                                                 MaterialCommunityIcons.tag_text_outline,
                                                 size: 20.sp,
                                                 color: kGreyColor,
                                               ),
                                               kHorizontalSpace12,
                                               Text(
                                                 "PriceRange".tr,
                                                 style: TextStyle(
                                                     color: kBlackColor,
                                                     fontSize: 14.sp,
                                                     fontWeight: FontWeight.w600),
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

                                 const Divider(),
                                          controller.typeId.value!=3?
                                          Column(
                                            children: [
                                              // --- Bedrooms ---
                                              Row(
                                                children: [
                                                  Icon(Icons.king_bed_outlined, size: 20.sp, color: kGreyColor),
                                                  kHorizontalSpace12,
                                                  Text(
                                                    "Bedrooms".tr,
                                                    style: TextStyle(
                                                      color: kBlackColor,
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              kVerticalSpace4,
                                              RangeSlider(
                                                values: controller.rooms,
                                                onChanged: (val) {
                                                  controller.rooms = val;
                                                  controller.update(["filters"]);
                                                },
                                                labels: RangeLabels(
                                                  controller.rooms.start.toStringAsFixed(0),
                                                  controller.rooms.end.toStringAsFixed(0),
                                                ),
                                                divisions: 7,
                                                min: 0,
                                                max: 7,
                                              ),
                                              const Divider(),

                                              // --- Kitchen ---
                                              Row(
                                                children: [
                                                  Icon(Icons.kitchen_outlined, size: 20.sp, color: kGreyColor),
                                                  kHorizontalSpace12,
                                                  Text(
                                                    "Kitchen".tr,
                                                    style: TextStyle(
                                                      color: kBlackColor,
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              kVerticalSpace4,
                                              RangeSlider(
                                                values: controller.kitchens,
                                                onChanged: (val) {
                                                  controller.kitchens = val;
                                                  controller.update(["filters"]);
                                                },
                                                labels: RangeLabels(
                                                  controller.kitchens.start.toStringAsFixed(0),
                                                  controller.kitchens.end.toStringAsFixed(0),
                                                ),
                                                divisions: 7,
                                                min: 0,
                                                max: 7,
                                              ),
                                              const Divider(),

                                              // --- Washroom ---
                                              Row(
                                                children: [
                                                  Icon(Icons.bathtub_outlined, size: 20.sp, color: kGreyColor),
                                                  kHorizontalSpace12,
                                                  Text(
                                                    "Washroom".tr,
                                                    style: TextStyle(
                                                      color: kBlackColor,
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              kVerticalSpace4,
                                              RangeSlider(
                                                values: controller.washrooms,
                                                onChanged: (val) {
                                                  controller.washrooms = val;
                                                  controller.update(["filters"]);
                                                },
                                                labels: RangeLabels(
                                                  controller.washrooms.start.toStringAsFixed(0),
                                                  controller.washrooms.end.toStringAsFixed(0),
                                                ),
                                                divisions: 7,
                                                min: 0,
                                                max: 7,
                                              ),
                                              const Divider(),
                                            ],
                                          )
                                              :Column(children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  MaterialCommunityIcons.map_marker_distance,
                                                  size: 20.sp,
                                                  color: kGreyColor,
                                                ),
                                                kHorizontalSpace12,
                                                Text(
                                                  "AreaRange".tr,
                                                  style: TextStyle(
                                                      color: kBlackColor,
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w600),
                                                ),

                                              ],
                                            ),
                                            kVerticalSpace4,
                                            Row(
                                              children: [
                                                Expanded(child:  TextFieldWidget(hintText: "StartArea",  keyboardType: TextInputType.number,
                                                  text: controller.startSize,
                                                  borderRadius: kBorderRadius8,
                                                  onChanged: (String val){
                                                    controller.startSize=val;

                                                  },
                                                  validator: (String? val){
                                                    if(val!.trim().isEmpty) {
                                                      return kRequiredMsg;
                                                    } else {
                                                      return null;
                                                    }
                                                  },),),
                                                Text(" ${"To".tr} ",style: TextStyle(color: kBlackColor,fontSize: 16.sp,fontWeight: FontWeight.w600),)
                                                ,
                                                Expanded(child:  TextFieldWidget(hintText: "EndArea",  keyboardType: TextInputType.number,
                                                  text: controller.endSize,
                                                  borderRadius: kBorderRadius8,
                                                  onChanged: (String val){
                                                    controller.endSize=val;

                                                  },
                                                  validator: (String? val){
                                                    if(val!.trim().isEmpty) {
                                                      return kRequiredMsg;
                                                    } else {
                                                      return null;
                                                    }
                                                  },),),
                                              ],
                                            ),

                                            const Divider(),
                                          ],),

                                           if( controller.typeId.value!=3)
                                            Column(
                                             children: [
                                               Row(
                                                 children: [
                                                   Icon(
                                                     Icons.brush_outlined,
                                                     size: 20.sp,
                                                     color: kGreyColor,
                                                   ),
                                                   kHorizontalSpace12,
                                                   Text(
                                                     "Furnished".tr,
                                                     style: TextStyle(
                                                         color: kBlackColor,
                                                         fontSize: 14.sp,
                                                         fontWeight: FontWeight.w600),
                                                   ),
                                                 ],
                                               ),
                                               kVerticalSpace4,


                                               SizedBox(   height: 40.h,
                                                 child: Row(
                                                     children: furnished.map((e) =>
                                                         Expanded(
                                                           child: Row(
                                                               mainAxisSize: MainAxisSize.min,
                                                               children:[
                                                                 SizedBox(
                                                                   width: 20.w,
                                                                   height: 20.w,
                                                                   child: Checkbox(
                                                                     value: controller.furnished.value==e,
                                                                     onChanged: (val) {
                                                                       if(e==controller.furnished.value){
                                                                         controller.furnished.value="";
                                                                       }else{
                                                                         controller.furnished.value=e;
                                                                       }

                                                                     },
                                                                   ),
                                                                 ),
                                                                 Text(" ${e.tr}",style: TextStyle(fontSize: 14.sp),

                                                                 )
                                                               ]
                                                           ),
                                                         )
                                                     ).toList()
                                                 ),
                                               ),
                                               const Divider(),
                                             ],
                                           ),

                                 SizedBox(
                                     height: 40.h,

                                     child: Row(
                                         children: controller
                                             .typeController.typeModel.value.types.map((e) =>
                             Expanded(
                             child: Row(
                             mainAxisSize: MainAxisSize.min,
                             children:[
                             SizedBox(
                             width: 20.w,
                             height: 20.w,
                             child: Checkbox(
                             value: controller.typeId.value==e.typeId,
                             onChanged: (val) {
                             if(e.typeId==controller.typeId.value){
                             controller.typeId.value=0;
                             }else{
                             controller.typeId.value=e.typeId!;
                             controller.selectedType=e;
                             }
                             controller.subTypes.clear();
                             controller.update(["filters"]);

                             },
                             ),
                             ),
                             Expanded(
                               child: FittedBox(

                                 alignment: AlignmentDirectional.centerStart,
                                 fit: BoxFit.scaleDown,
                                 child: Text(" ${e.type} ",style: TextStyle(fontSize: 14.sp),

                                 ),
                               ),
                             )
                             ]
                             ),
                             )


                                         ).toList()
                                     ),
                                 ),
                                 const Divider(),

                                          if(controller.selectedType!=null)
                                            Column(
                                              children: [
                                                SizedBox(
                                                       height: 30.h,
                                                       child: ListView.separated(
                                                         itemBuilder: (context, index) {
                                                           return InkWell(
                                                             onTap: () {
                                                               if( controller.subTypes.contains(controller.selectedType
                                                               !.subTypes[index]
                                                                   .subTypeId)){
                                                                 controller.subTypes.remove(controller.selectedType
                                                                 !.subTypes[index]
                                                                     .subTypeId);
                                                               }else{
                                                                 controller.subTypes.add(controller.selectedType
                                                                 !.subTypes[index]
                                                                     .subTypeId!);
                                                               }

                                                               controller.update(["filters"]);
                                                             },
                                                             child: Container(
                                                               alignment:
                                                               Alignment.center,
                                                               padding:
                                                               EdgeInsets.symmetric(
                                                                   vertical: 2.w,
                                                                   horizontal: 8.w),
                                                               decoration: BoxDecoration(
                                                                 borderRadius:
                                                                 kBorderRadius30,
                                                                 color: controller.subTypes.contains(controller.selectedType
                                                                 !.subTypes[index]
                                                                     .subTypeId!)
                                                                     ? kAccentColor
                                                                     : Colors.grey.shade300,),
                                                               child: Text(
                                                                 controller.selectedType!.subTypes[index].subType!,
                                                                 style: TextStyle(
                                                                     color: controller.subTypes.contains(controller.selectedType
                                                                     !.subTypes[index]
                                                                         .subTypeId!)
                                                                         ? kWhiteColor
                                                                         : kBlackColor,
                                                                     fontSize: 15.sp),
                                                               ),
                                                             ),
                                                           );
                                                         },
                                                         separatorBuilder:
                                                             (context, index) {
                                                           return kHorizontalSpace12;
                                                         },
                                                         itemCount: controller.selectedType!.subTypes.length,

                                                         scrollDirection:
                                                         Axis.horizontal,
                                                       ),
                                                     ),
                                                const Divider(),
                                              ],
                                            ),

                                           Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Expanded(child: TextButtonWidget(text: "Reset".tr,onPressed:() {
                                         controller.resetFilters();})),
                                       kHorizontalSpace12,
                                       Expanded(child: ButtonWidget(text: "Apply".tr, onPressed: (){
                                         Get.back();
                                         controller.loadMore.value=true;
                                         controller.page.value=1;
                                         controller.getFilteredProperties();
                                       }))
                                         ],
                                         ),
                                         ]
                                       ),
                                   ),
                             );
                           }
                       ),
                 ),)
                       ;
                    },icon: MaterialCommunityIcons.filter_variant,),

                ],
              ),])
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:16),
              child: Text("${"Showing".tr} ${controller.totalAds} ${"Ads".tr.toLowerCase()}",style: TextStyle(fontSize: 13.sp,color: kBlackColor,),),
            ),

kVerticalSpace8,

        Expanded(
          child:NotificationListener<ScrollEndNotification>(
            onNotification: (notification) {
              if (notification.metrics.atEdge &&
                  notification.metrics.pixels ==
                      notification.metrics.maxScrollExtent &&
                  controller.loadMore.value) {
                controller.page.value+=1;
                controller.getFilteredProperties();
              }
              return true;
            },
            child: Column(
                children: [
                  Expanded(
                    child: controller
                        .status.value ==
                        Status.loading
                        ? CircularLoader():

                    controller.status.value ==
                        Status.error
                        ? Text(kCouldNotLoadData.tr,
                        style: kTextStyle16)
                        :

                    controller.properties.value.isEmpty?
                    Text("NoDataFound".tr,
                        style: kTextStyle16):

          controller.isGridView?
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              itemCount: controller.properties.value.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 260.h, // consistent fixed height
                crossAxisSpacing: 0.w,
                mainAxisSpacing: 0.w,
              ),
              itemBuilder: (context, index) {
                var item = controller.properties.value[index];
                return PropertyItem(item: item, isGridView: true);
              },
            ),
          )
              :
          ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount:controller.properties.value.length,
              itemBuilder: (context, index) {

                var item = controller.properties.value[index];
                return PropertyItem(item: item,isGridView: false,);


              })
                    ,
                  ),   controller.isLoadingMore.value?
                  Padding(
                    padding:  EdgeInsets.symmetric(vertical: 8.w),
                    child: const CircularLoader(),
                  ):Container()
                ],
              ),
          ),
        )],
        ),
      ));
  }
   Widget _buildSortOption(String title) {
     // Map display titles to API sort values
     String getSortValue(String title) {
       switch (title) {
         case "Date Updated (New to Old)":
           return "DateUpdatedDesc";
         case "Date Updated (Old to New)":
           return "DateUpdatedAsc";
         case "Price (High to Low)":
           return "PriceDesc";
         case "Price (Low to High)":
           return "PriceAsc";
         default:
           return "";
       }
     }

     return GestureDetector(
       onTap: () {
         String sortValue = getSortValue(title);
         controller.selectedSortBy.value = sortValue;
         controller.loadMore.value = true;
         controller.page.value = 1;
         controller.getFilteredProperties();
         Get.back(); // Close the bottom sheet
       },
       child: Container(
         width: double.infinity,
         padding: EdgeInsets.all(12.h),
         decoration: BoxDecoration(
           border: Border(
             bottom: BorderSide(
               color: Colors.grey[200]!,
               width: 1,
             ),
           ),
         ),
         child: Text(
           title,
           style: TextStyle(
             fontSize: 14.sp,
             color: kBlackColor,
           ),
         ),
       ),
     );
   }
}
