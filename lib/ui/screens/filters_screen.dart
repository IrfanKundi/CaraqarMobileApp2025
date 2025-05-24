import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/property_controller.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/cities_bottom_sheet.dart';
import 'package:careqar/ui/widgets/text_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class FiltersScreen extends GetView<PropertyController> {
  const FiltersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: (){
        controller.resetFilters();
        return Future.value(true);
      },
      child: Scaffold(
          backgroundColor: kWhiteColor,
          appBar: buildAppBar(context, title: "Filters"),
          body: GetBuilder<PropertyController>(
            id: "filters",
            builder: (controller) {
              return Obx(
                () => Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                          padding: kScreenPadding,
                          child: Column(children: [
                            Container(
                              height: 50.h,
                              child: Row(
                                children: [
                                  Icon(
                                    MaterialCommunityIcons.check_circle_outline,
                                    color: kGreyColor,
                                    size: 22.sp,
                                  ),
                                  kHorizontalSpace16,
                                  Text(
                                    "IWantTo".tr,
                                    style: TextStyle(
                                        color: kBlackColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Spacer(),
                                  Container(
                                    height: 33.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                        borderRadius: kBorderRadius30,
                                        color: Colors.grey.shade300),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              controller.isBuyerMode(true);
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              height: 35.w,
                                              decoration: BoxDecoration(
                                                color: controller.isBuyerMode.value!
                                                    ? kAccentColor
                                                    : Colors.transparent,
                                                borderRadius: kBorderRadius30,
                                              ),
                                              child: Text(
                                                "Buy".tr,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color:
                                                        controller.isBuyerMode.value!
                                                            ? kWhiteColor
                                                            : kBlackColor,
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            child: GestureDetector(
                                          onTap: () {
                                            controller.isBuyerMode(false);
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 35.w,
                                            decoration: BoxDecoration(
                                              color: controller.isBuyerMode.value!
                                                  ? Colors.transparent
                                                  : kAccentColor,
                                              borderRadius: kBorderRadius30,
                                            ),
                                            child: Text(
                                              "Rent".tr,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: controller.isBuyerMode.value!
                                                      ? kBlackColor
                                                      : kWhiteColor,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(),
                            InkWell(
                              onTap: () async {
                                var result = await showCitiesSheet(context);
                                if (result != null) {
                                  controller.selectedCity.value = result;
                                  controller.selectedLocation.value = null;
                                }
                              },
                              child: Container(
                                height: 50.h,
                                child: Row(
                                  children: [
                                    Icon(
                                      MaterialCommunityIcons.map_marker_outline,
                                      color: kGreyColor,
                                      size: 22.sp,
                                    ),
                                    kHorizontalSpace16,
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "City".tr,
                                          style: TextStyle(
                                              color: kBlackColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          controller.selectedCity.value?.name ?? 'SelectCity'.tr,
                                          style: TextStyle(
                                              color: kAccentColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    Spacer(),
                                    Icon(
                                        Get.locale?.languageCode=="ar"?MaterialCommunityIcons.chevron_left:
                                        MaterialCommunityIcons.chevron_right)
                                  ],
                                ),
                              ),
                            ),
                            Divider(),

                            InkWell(
                              onTap: () async {
                                if (controller.selectedCity.value == null) {
                                  showSnackBar(message: "SelectCity");
                                } else {
                                  var result = await Get.toNamed(
                                      Routes.searchLocationScreen,
                                      parameters: {
                                        "cityId": controller.selectedCity.value!.cityId
                                            .toString()
                                      });
                                  if (result != null) {
                                    controller.selectedLocation.value = result;
                                  }
                                }
                              },
                              child: Container(
                                height: 50.h,
                                child: Row(
                                  children: [
                                    Icon(
                                      MaterialCommunityIcons.map_outline,
                                      color: kGreyColor,
                                      size: 22.sp,
                                    ),
                                    kHorizontalSpace16,
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Location".tr,
                                          style: TextStyle(
                                              color: kBlackColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          controller.selectedLocation.value?.title ?? 'SelectLocation'.tr,
                                          style: TextStyle(
                                              color: kAccentColor,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    Spacer(),
                                    Icon(
                                        Get.locale?.languageCode=="ar"?MaterialCommunityIcons.chevron_left:
                                        MaterialCommunityIcons.chevron_right)
                                  ],
                                ),
                              ),
                            ),
                            Divider(),
                            Container(
                                child: Column(children: [
                              Row(
                                children: [
                                  Icon(
                                    MaterialCommunityIcons.office_building,
                                    color: kGreyColor,
                                    size: 22.sp,
                                  ),
                                  kHorizontalSpace16,
                                  Text(
                                    "PropertyTypes".tr,
                                    style: TextStyle(
                                        color: kBlackColor,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              kVerticalSpace12,
                              DefaultTabController(
                                length: controller
                                    .typeController.typeModel.value.types.length,
                                child: Container(
                                  height: 100.h,
                                  child: Column(
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
                                          unselectedLabelStyle: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w600),
                                          labelStyle: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w600),
                                          tabs: controller
                                              .typeController.typeModel.value.types
                                              .map((e) => Tab(
                                                    child: Text(" ${e.type}"),
                                                  ))
                                              .toList()),
                                      Divider(
                                        height: 0,
                                      ),
                                      kVerticalSpace16,
                                      GetBuilder<PropertyController>(
                                          builder: (controller) {
                                        return Container(
                                          height: 30.h,
                                          child: TabBarView(
                                              children: controller.typeController.typeModel.value.types
                                                  .map(
                                                    (e) => ListView.separated(
                                                      itemBuilder: (context, index) {
                                                        return InkWell(
                                                          onTap: () {
                                                            controller.subTypeId(e
                                                                .subTypes[index]
                                                                .subTypeId);
                                                            controller
                                                                .typeId(e.typeId);

                                                            controller.update();
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
                                                                color: e
                                                                            .subTypes[
                                                                                index]
                                                                            .subTypeId ==
                                                                        controller
                                                                            .subTypeId
                                                                            .value
                                                                    ? kAccentColor
                                                                    : Colors.grey.shade300,),
                                                            child: Text(
                                                              "${e.subTypes[index].subType}",
                                                              style: TextStyle(
                                                                  color: e
                                                                              .subTypes[
                                                                                  index]
                                                                              .subTypeId ==
                                                                          controller
                                                                              .subTypeId
                                                                              .value
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
                                                      itemCount: e.subTypes.length,
                                                      padding:
                                                          kHorizontalScreenPadding,
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                    ),
                                                  )
                                                  .toList()),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              )
                            ])),
                            Divider(),
                            kVerticalSpace12,
                            Row(
                              children: [
                                Icon(
                                  MaterialCommunityIcons.tag_text_outline,
                                  size: 18.sp,
                                  color: kGreyColor,
                                ),
                                kHorizontalSpace12,
                                Text(
                                  "PriceRange".tr,
                                  style: TextStyle(
                                      color: kBlackColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                Spacer(),
                                Text(
                                  "${gSelectedCountry!.currency}",
                                  style: TextStyle(
                                      color: kBlackColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            kVerticalSpace16,
                            // Row(
                            //   children: [
                            //     Expanded(
                            //         child: TextFieldWidget(
                            //           hintText: "0",
                            //       text: controller.startPrice.toString(),
                            //       keyboardType: TextInputType.number,
                            //       onChanged: (String val) {
                            //         if (val.isEmpty) {
                            //           controller.startPrice = 0;
                            //         } else {
                            //           controller.startPrice = double.parse(val);
                            //         }
                            //       },
                            //     )),
                            //     Text(
                            //       " ${"To".tr} ",
                            //       style: TextStyle(
                            //           color: kBlackColor,
                            //           fontSize: 16.sp,
                            //           fontWeight: FontWeight.w600),
                            //     ),
                            //     Expanded(
                            //         child: TextFieldWidget(
                            //           hintText: "Any",
                            //       text:  controller.endPrice.toString(),
                            //       onChanged: (String val) {
                            //         if (val.isEmpty) {
                            //           controller.endPrice = 0;
                            //         } else {
                            //           controller.endPrice = double.parse(val);
                            //         }
                            //       },
                            //       keyboardType: TextInputType.number,
                            //     )),
                            //   ],
                            // ),
                            kVerticalSpace16,

                            Divider(),
                            kVerticalSpace12,
                            Row(
                              children: [
                                Icon(
                                  MaterialCommunityIcons.map_marker_distance,
                                  size: 18.sp,
                                  color: kGreyColor,
                                ),
                                kHorizontalSpace12,
                                Text(
                                  "AreaRange".tr,
                                  style: TextStyle(
                                      color: kBlackColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                Spacer(),
                                Text(
                                  "Marla".tr,
                                  style: TextStyle(
                                      color: kBlackColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            kVerticalSpace16,
                            // Row(
                            //   children: [
                            //     Expanded(
                            //         child: TextFieldWidget(
                            //           hintText: "0",
                            //           text: controller.startSize.toString(),
                            //           keyboardType: TextInputType.number,
                            //           onChanged: (String val) {
                            //             if (val.isEmpty) {
                            //               controller.startSize = 0;
                            //             } else {
                            //               controller.startSize = double.parse(val);
                            //             }
                            //           },
                            //     )),
                            //     Text(
                            //       " ${"To".tr} ",
                            //       style: TextStyle(
                            //           color: kBlackColor,
                            //           fontSize: 16.sp,
                            //           fontWeight: FontWeight.w600),
                            //     ),
                            //     Expanded(
                            //         child: TextFieldWidget(
                            //           text: controller.endSize.toString(),
                            //           hintText: "Any",
                            //           onChanged: (String val) {
                            //             if (val.isEmpty) {
                            //               controller.endSize = 0;
                            //             } else {
                            //               controller.endSize = double.parse(val);
                            //             }
                            //           },
                            //           keyboardType: TextInputType.number,
                            //     )),
                            //   ],
                            // ),
                            kVerticalSpace16,
                            // Slider(
                            //   value: 100,
                            //   onChanged: (val) {},
                            //   min: 0,
                            //   max: 100,
                            // ),
                            // // Container(
                            //   height: 30.h,
                            //   child: ListView(
                            //     scrollDirection: Axis.horizontal,
                            //     children: [
                            //       Container(
                            //         alignment: Alignment.center,
                            //         padding: EdgeInsets.symmetric(
                            //             vertical: 2.w, horizontal: 8.w),
                            //         decoration: BoxDecoration(
                            //           borderRadius: kBorderRadius30,
                            //           color: Colors.grey.shade300,
                            //         ),
                            //         child: Text(
                            //           "5 Marla",
                            //           style: TextStyle(
                            //               color: kBlackColor, fontSize: 15.sp),
                            //         ),
                            //       ),
                            //       kHorizontalSpace12,
                            //       Container(
                            //         alignment: Alignment.center,
                            //         padding: EdgeInsets.symmetric(
                            //             vertical: 2.w, horizontal: 8.w),
                            //         decoration: BoxDecoration(
                            //           borderRadius: kBorderRadius30,
                            //           color: Colors.grey.shade300,
                            //         ),
                            //         child: Text(
                            //           "3 Marla",
                            //           style: TextStyle(
                            //               color: kBlackColor, fontSize: 15.sp),
                            //         ),
                            //       ),
                            //       kHorizontalSpace12,
                            //       Container(
                            //           alignment: Alignment.center,
                            //           padding: EdgeInsets.symmetric(
                            //               vertical: 2.w, horizontal: 8.w),
                            //           decoration: BoxDecoration(
                            //             borderRadius: kBorderRadius30,
                            //             color: Colors.grey.shade300,
                            //           ),
                            //           child: Text(
                            //             "7 Marla",
                            //             style: TextStyle(
                            //                 color: kBlackColor, fontSize: 15.sp),
                            //           )),
                            //       kHorizontalSpace12,
                            //       Container(
                            //         alignment: Alignment.center,
                            //         padding: EdgeInsets.symmetric(
                            //             vertical: 2.w, horizontal: 8.w),
                            //         decoration: BoxDecoration(
                            //           borderRadius: kBorderRadius30,
                            //           color: Colors.grey.shade300,
                            //         ),
                            //         child: Text(
                            //           "8 Marla",
                            //           style: TextStyle(
                            //               color: kBlackColor, fontSize: 15.sp),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // Divider(
                            //   height: 30.h,
                            // ),
                            // kVerticalSpace8,
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Expanded(
                            //       child: Column(
                            //         children: [
                            //           Row(
                            //             children: [
                            //               Icon(
                            //                 MaterialCommunityIcons.check_box_outline,
                            //                 color: Colors.blue,
                            //                 size: 20.sp,
                            //               ),
                            //               kHorizontalSpace12,
                            //               Text(
                            //                 "Show Verified Ads Only",
                            //                 style: TextStyle(
                            //                     color: kBlackColor,
                            //                     fontSize: 16.sp,
                            //                     fontWeight: FontWeight.w600),
                            //               ),
                            //             ],
                            //           ),
                            //           kVerticalSpace12,
                            //           Text(
                            //             "$kAppTitle verifies the location, size and advertiser information of these listings. T&Cs apply.",
                            //             style: TextStyle(
                            //                 color: kGreyColor, fontSize: 14.sp),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //     Switch(value: false, onChanged: (val) {})
                            //   ],
                            // ),
                            Divider(),
                            kVerticalSpace12,
                            Row(
                              children: [
                                Icon(
                                  MaterialCommunityIcons.bed_empty,
                                  color: kGreyColor,
                                  size: 20.sp,
                                ),
                                kHorizontalSpace12,
                                Text(
                                  "Bedrooms".tr,
                                  style: TextStyle(
                                      color: kBlackColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            kVerticalSpace16,
                            Container(
                              width: 1.sw,
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                runSpacing: 8.w,
                                spacing: 8.w,
                                runAlignment: WrapAlignment.start,
                                children: List.generate(
                                  7,
                                  (index) => GestureDetector(
                                    onTap: () {
                                      controller.bedrooms.value =
                                          "${index == 6 ? '${index + 4}+' : index + 1}";
                                    },
                                    child: Container(
                                      height: 40.w,
                                      width: 40.w,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: kBorderRadius50,
                                        color:
                                            '${index == 6 ? '${index + 4}+' : index + 1}' ==
                                                    controller.bedrooms.value
                                                ? kAccentColor
                                                : Colors.grey.shade300,
                                      ),
                                      child: Text(
                                        "${index == 6 ? '${index + 4}+' : index + 1}",
                                        style: TextStyle(
                                            color:
                                                '${index == 6 ? '${index + 4}+' : index + 1}' ==
                                                        controller.bedrooms.value
                                                    ? kWhiteColor
                                                    : kBlackColor,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Divider(),
                            kVerticalSpace12,
                            Row(
                              children: [
                                Icon(
                                  MaterialCommunityIcons.scale_bathroom,
                                  color: kGreyColor,
                                  size: 20.sp,
                                ),
                                kHorizontalSpace12,
                                Text(
                                  "Bathrooms".tr,
                                  style: TextStyle(
                                      color: kBlackColor,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                            kVerticalSpace16,
                            Container(
                              width: 1.sw,
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                runSpacing: 8.w,
                                spacing: 8.w,
                                runAlignment: WrapAlignment.start,
                                children: List.generate(
                                  5,
                                  (index) => GestureDetector(
                                    onTap: () {
                                      controller.baths.value = '${index + 1}';
                                    },
                                    child: Container(
                                      height: 40.w,
                                      width: 40.w,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: kBorderRadius50,
                                        color:
                                            '${index + 1}' == controller.baths.value
                                                ? kAccentColor
                                                : Colors.grey.shade300,
                                      ),
                                      child: Text(
                                        "${index + 1}",
                                        style: TextStyle(
                                            color: '${index + 1}' ==
                                                    controller.baths.value
                                                ? kWhiteColor
                                                : kBlackColor,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Divider(),

                          ])),
                    ),
                    Card(
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: kScreenPadding,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButtonWidget(text: "Reset".tr,onPressed: controller.resetFilters,),
                            kHorizontalSpace12,
                            ButtonWidget(text: "Apply".tr, onPressed: controller.getFilteredProperties)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          )),
    );
  }
}
