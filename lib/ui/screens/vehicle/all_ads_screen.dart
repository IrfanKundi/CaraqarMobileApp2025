import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/vehicle_controller.dart';
import 'package:careqar/models/car_model.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/screens/vehicle/bikes_screen.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart';

import '../../../controllers/bike_controller.dart';
import '../../../controllers/car_controller.dart';
import '../../../controllers/number_plate_controller.dart';
import '../../../global_variables.dart';
import '../../../models/bike_model.dart';
import 'cars_screen.dart';

class AllAdsScreen extends StatefulWidget {

  const AllAdsScreen({super.key});

  @override
  State<AllAdsScreen> createState() => _AllAdsScreenState();
}

class _AllAdsScreenState extends State<AllAdsScreen>
    with TickerProviderStateMixin {


  late TabController tabController;
  late NumberPlateController numberPlateController;
  late CarController carController;
  late BikeController bikeController;

  bool personalAds = false;
  bool companyAds = false;

  @override
  void initState() {
    personalAds = Get.arguments == 0;
    companyAds = Get.arguments == 1;
    var controller = Get.find<VehicleController>();
    carController = controller.carController;
    bikeController = controller.bikeController;
    numberPlateController = Get.put(NumberPlateController());

    tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    carController.resetFilters();
    carController.personalAds = personalAds;
    carController.companyAds = companyAds;
    carController.getFilteredCars();
    tabController.addListener(() {
      if (tabController.index == 0) {
        carController.resetFilters();
        carController.personalAds = personalAds;
        carController.companyAds = companyAds;
        carController.getFilteredCars();
      } else if (tabController.index == 1) {
        bikeController.resetFilters();
        bikeController.personalAds = personalAds;
        bikeController.companyAds = companyAds;
        bikeController.getFilteredBikes();
      } else {
        numberPlateController.resetFilters();
        numberPlateController.personalAds = personalAds;
        numberPlateController.companyAds = companyAds;
        numberPlateController.getFilteredNumberPlates();
      }
    });
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            color: kWhiteColor,
            child: TabBar(
                labelStyle: kTextStyle16,
                controller: tabController,
                tabs: [
                  Tab(text: "Car".tr,),
                  Tab(text: "Bike".tr,),
                  Tab(text: "No.Plate".tr,),
                ], dividerColor: Colors.transparent),
          ),
          Expanded(child: TabBarView(
              controller: tabController,
              children: [
                AllCars(),
                AllBikes(),
                Center(child: Text(
                  "ComingSoon".tr.toUpperCase(), style: kTextStyle16,))

                // Commented the below code due to coming soon option
                // AllNumberPlates()


              ])
          )
        ],
      ),
    );
  }
}

class MyCarItem extends StatelessWidget {
  const MyCarItem({
    super.key,
    required this.item, this.isGridView = true
  });

  final Car item;

  final bool isGridView;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(
            Routes
                .viewMyCarScreen,
            arguments:
            item);
      },
      child: Card(
        margin: isGridView ?
        EdgeInsets.all(5.w) :
        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),

        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child:
        isGridView ?
        Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
            children: [
              Expanded(
                child:
                Stack(
                  children: [
                    ImageWidget(
                      item.images
                          .first,
                      fit: BoxFit
                          .cover,
                    ),
                    item.isSold! ? Container() : PositionedDirectional(
                        top: 4.w,
                        start: 4.w,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          decoration: BoxDecoration(
                            color: item.status == "Approved"
                                ? kSuccessColor
                                : Colors.orangeAccent,
                            borderRadius: kBorderRadius30,
                          ),
                          child: Text(
                            "${item.status}".tr,
                            style: TextStyle(
                                color: kWhiteColor, fontSize: 12.sp),

                          ),
                        )),
                    PositionedDirectional(
                        top: 4.w,
                        end: 4.w,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: kBorderRadius30,
                          ),
                          child: Row(
                            children: [
                              Icon(MaterialCommunityIcons.eye_outline, size: 16
                                  .sp, color: kWhiteColor,),
                              Text(
                                " ${item.clicks}",
                                style: TextStyle(
                                    color: kWhiteColor, fontSize: 12.sp),),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
              Expanded(
                  child:
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Text("${item.brandName} ${item.modelName} ${item
                            .modelYear}",
                          maxLines: 2,
                          style: kTextStyle16.copyWith(color: kAccentColor),),
                        kVerticalSpace4,

                        Row(
                          children: [
                            Icon(MaterialCommunityIcons.map_marker_outline,
                              size: 16.sp,
                              color: kLightBlueColor,),
                            Expanded(
                              child: Text(
                                "${item.cityName}",
                                maxLines:
                                1,
                                style:
                                TextStyle(color: kGreyColor,
                                    height: 1.3,
                                    fontSize: 12.sp),
                              ),
                            ),
                          ],
                        ),
                        kVerticalSpace4,
                        Text(
                          format(item.createdAt!,
                              locale: gSelectedLocale?.locale?.languageCode),
                          textDirection: TextDirection.ltr, maxLines:
                        1,
                          style: TextStyle(
                              color: kGreyColor, height: 1.3, fontSize: 12.sp),
                        ),

                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            getPrice(item.price!),
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                                color: kPrimaryColor,
                                height: 1.3,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ),

                      ],
                    ),
                  ))
            ]) :
        SizedBox(
          height: 120.h,
          child: Row(
              crossAxisAlignment:
              CrossAxisAlignment
                  .stretch,
              children: [
                Expanded(flex: 2,
                  child:
                  Stack(
                    children: [
                      ImageWidget(
                        item.images
                            .first,
                        fit: BoxFit
                            .cover,
                      ),
                      item.isSold! ? Container() : PositionedDirectional(
                          top: 4.h,
                          start: 4.w,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 8),
                            decoration: BoxDecoration(
                              color: item.status == "Approved"
                                  ? kSuccessColor
                                  : Colors.orangeAccent,
                              borderRadius: kBorderRadius30,
                            ),
                            child: Text(
                              "${item.status}".tr,
                              style: TextStyle(
                                  color: kWhiteColor, fontSize: 12.sp),

                            ),
                          )),
                      PositionedDirectional(
                          top: 30.h,
                          start: 4.w,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: kBorderRadius30,
                            ),
                            child: Row(
                              children: [
                                Icon(MaterialCommunityIcons.eye_outline,
                                  size: 16.sp, color: kWhiteColor,),
                                Text(
                                  " ${item.clicks}",
                                  style: TextStyle(
                                      color: kWhiteColor, fontSize: 12.sp),),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
                Expanded(flex: 3,
                    child:
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          Text("${item.brandName} ${item.modelName} ${item
                              .modelYear}",
                            maxLines: 2,
                            style: kTextStyle16.copyWith(color: kAccentColor),),
                          kVerticalSpace4,

                          Row(
                            children: [ Icon(MaterialCommunityIcons
                                .map_marker_outline, size: 16.sp,
                              color: kLightBlueColor,),
                              Expanded(
                                child: Text(
                                  "${item.cityName}",
                                  maxLines:
                                  1,
                                  style:
                                  TextStyle(color: kGreyColor,
                                      height: 1.3,
                                      fontSize: 12.sp),
                                ),
                              ),
                            ],
                          ), kVerticalSpace4,


                          Text(
                            format(item.createdAt!,
                                locale: gSelectedLocale?.locale?.languageCode),
                            textDirection: TextDirection.ltr, maxLines:
                          1,
                            style: TextStyle(color: kGreyColor,
                                height: 1.3,
                                fontSize: 12.sp),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              getPrice(item.price!),
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  height: 1.2,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),

                        ],
                      ),
                    ))
              ]),
        )
        ,
      ),
    );
  }
}

class MyBikeItem extends StatelessWidget {
  const MyBikeItem({
    super.key,
    required this.item, this.isGridView = true
  });

  final Bike item;

  final bool isGridView;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(
            Routes
                .viewMyBikeScreen,
            arguments:
            item);
      },
      child: Card(
        margin: isGridView ?
        EdgeInsets.all(5.w) :
        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),

        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child:
        isGridView ?
        Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
            children: [
              Expanded(
                child:
                Stack(
                  children: [
                    ImageWidget(
                      item.images
                          .first,
                      fit: BoxFit
                          .cover,
                    ),
                    item.isSold! ? Container() : PositionedDirectional(
                        top: 4.w,
                        start: 4.w,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          decoration: BoxDecoration(
                            color: item.status == "Approved"
                                ? kSuccessColor
                                : Colors.orangeAccent,
                            borderRadius: kBorderRadius30,
                          ),
                          child: Text(
                            "${item.status}".tr,
                            style: TextStyle(
                                color: kWhiteColor, fontSize: 12.sp),

                          ),
                        )),
                    PositionedDirectional(
                        top: 4.w,
                        end: 4.w,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.black38,
                            borderRadius: kBorderRadius30,
                          ),
                          child: Row(
                            children: [
                              Icon(MaterialCommunityIcons.eye_outline, size: 16
                                  .sp, color: kWhiteColor,),
                              Text(
                                " ${item.clicks}",
                                style: TextStyle(
                                    color: kWhiteColor, fontSize: 12.sp),),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
              Expanded(
                  child:
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Text("${item.brandName} ${item.modelName} ${item
                            .modelYear}",
                          maxLines: 2,
                          style: kTextStyle16.copyWith(color: kAccentColor),),
                        kVerticalSpace4,

                        Row(
                          children: [
                            Icon(MaterialCommunityIcons.map_marker_outline,
                              size: 16.sp,
                              color: kLightBlueColor,),
                            Expanded(
                              child: Text(
                                "${item.cityName}",
                                maxLines:
                                1,
                                style:
                                TextStyle(color: kGreyColor,
                                    height: 1.3,
                                    fontSize: 12.sp),
                              ),
                            ),
                          ],
                        ),
                        kVerticalSpace4,
                        Text(
                          format(item.createdAt!,
                              locale: gSelectedLocale?.locale?.languageCode),
                          textDirection: TextDirection.ltr, maxLines:
                        1,
                          style: TextStyle(
                              color: kGreyColor, height: 1.3, fontSize: 12.sp),
                        ),

                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            getPrice(item.price!),
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                                color: kPrimaryColor,
                                height: 1.3,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ),

                      ],
                    ),
                  ))
            ]) :
        SizedBox(
          height: 120.h,
          child: Row(
              crossAxisAlignment:
              CrossAxisAlignment
                  .stretch,
              children: [
                Expanded(flex: 2,
                  child:
                  Stack(
                    children: [
                      ImageWidget(
                        item.images
                            .first,
                        fit: BoxFit
                            .cover,
                      ),
                      item.isSold! ? Container() : PositionedDirectional(
                          top: 4.h,
                          start: 4.w,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 8),
                            decoration: BoxDecoration(
                              color: item.status == "Approved"
                                  ? kSuccessColor
                                  : Colors.orangeAccent,
                              borderRadius: kBorderRadius30,
                            ),
                            child: Text(
                              "${item.status}".tr,
                              style: TextStyle(
                                  color: kWhiteColor, fontSize: 12.sp),

                            ),
                          )),
                      PositionedDirectional(
                          top: 30.h,
                          start: 4.w,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: kBorderRadius30,
                            ),
                            child: Row(
                              children: [
                                Icon(MaterialCommunityIcons.eye_outline,
                                  size: 16.sp, color: kWhiteColor,),
                                Text(
                                  " ${item.clicks}",
                                  style: TextStyle(
                                      color: kWhiteColor, fontSize: 12.sp),),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
                Expanded(flex: 3,
                    child:
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          Text("${item.brandName} ${item.modelName} ${item
                              .modelYear}",
                            maxLines: 2,
                            style: kTextStyle16.copyWith(color: kAccentColor),),
                          kVerticalSpace4,

                          Row(
                            children: [ Icon(MaterialCommunityIcons
                                .map_marker_outline, size: 16.sp,
                              color: kLightBlueColor,),
                              Expanded(
                                child: Text(
                                  "${item.cityName}",
                                  maxLines:
                                  1,
                                  style:
                                  TextStyle(color: kGreyColor,
                                      height: 1.3,
                                      fontSize: 12.sp),
                                ),
                              ),
                            ],
                          ), kVerticalSpace4,


                          Text(
                            format(item.createdAt!,
                                locale: gSelectedLocale?.locale?.languageCode),
                            textDirection: TextDirection.ltr, maxLines:
                          1,
                            style: TextStyle(color: kGreyColor,
                                height: 1.3,
                                fontSize: 12.sp),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              getPrice(item.price!),
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  height: 1.2,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),

                        ],
                      ),
                    ))
              ]),
        ),
      ),
    );
  }
}

