import 'dart:io';

import 'package:careqar/controllers/add_car_controller.dart';
import 'package:careqar/controllers/favorite_controller.dart';
import 'package:careqar/controllers/car_controller.dart';
import 'package:careqar/controllers/vehicle_controller.dart';
import 'package:careqar/controllers/view_car_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/locale/app_localizations.dart';
import 'package:careqar/models/car_model.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/services/dynamic_link.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:get/get.dart';
import 'package:careqar/controllers/view_my_car_controller.dart';
import 'package:careqar/ui/widgets/remove_splash.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../global_variables.dart';

class ViewMyCarScreen extends GetView<ViewMyCarController> {
   ViewMyCarScreen({Key? key}) : super(key: key){
    //print(Get.arguments);

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(backgroundColor: kWhiteColor,
      body: Obx(() {
        var car = controller.car.value;
        return controller.status.value==Status.success? NestedScrollView(
          headerSliverBuilder: (BuildContext context,
              bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                  backgroundColor: kWhiteColor,
                  iconTheme: IconThemeData(color: kBlackColor),
                  expandedHeight: 0.6.sh,
                  pinned: true,
                  title: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text("Details".tr.toUpperCase(),textAlign: TextAlign.center,maxLines: 1,style: kAppBarStyle,))
                          ,

                          kHorizontalSpace12,
                          IconButtonWidget(icon: MaterialCommunityIcons
                              .share_variant,
                            color: kBlackColor,
                            onPressed: () async {
                              String url = await DynamicLink
                                  .createDynamicLink(false,
                                  uri: "/car?carId=${car?.carId}",title:"${car?.brandName} ${car?.modelName} ${car?.modelYear}",desc: car?.description,image: car?.images.first);
                              Share.share(url);
                            },),
                        ],
                      ),
                    ],
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background: Stack(
                      alignment: Alignment.center,
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: double.infinity,
                            autoPlayCurve: Curves.linearToEaseOut,
                            autoPlay: true,
                            scrollPhysics: BouncingScrollPhysics(),
                            enableInfiniteScroll: false,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            enlargeCenterPage: true,
                            enlargeStrategy:
                            CenterPageEnlargeStrategy.height,
                            initialPage: controller.sliderIndex.value,
                            onPageChanged: (index, reason) {
                              controller.sliderIndex.value=index;
                              controller.update();
                            },
                          ),
                          items:  car?.images.map((item) {
                            return Builder(
                              builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: (){
                                    Get.toNamed(Routes.viewImageScreen,
                                        arguments: car.images,parameters: {"index":car.images.indexOf(item).toString()});
                                  },
                                  child: ImageWidget(
                                    item,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,

                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),


                        Positioned(
                          bottom: 0,
                          child: Container(
                            height:20.h,width: 1.sw,
                            decoration: BoxDecoration(
                                boxShadow:[ BoxShadow(
                                  color: Colors.white,
                                  spreadRadius: 15,
                                  blurRadius: 15,
                                  offset: Offset(0, 15),

                                )]
                            ),
                          ),),
                        Positioned(
                            bottom: 40.h,
                            child: Container(width: 1.sw,
                              padding: kScreenPadding.copyWith(top: 8.w,bottom: 8.w),
                              decoration: BoxDecoration(
                                color: Colors.black12,

                              ),

                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Text("${car?.brandName} ${car?.modelName} ${car?.modelYear}",
                                            maxLines: 2, textAlign: TextAlign.center,
                                            style: kLightTextStyle18),
                                        kVerticalSpace4,
                                        Row(
                                          children: [ Icon(  MaterialCommunityIcons.map_marker_outline,    size: 16.sp,
                                            color: kWhiteColor,),
                                            Expanded(
                                              child: Text(
                                                  "${car?.cityName}", style: kTextStyle14.copyWith(color: kWhiteColor)),
                                            ),

                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      car!.isSold!?Container():  Container(
                                        margin: kScreenPadding,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color:car.status=="Approved"? kSuccessColor:Colors.orangeAccent,
                                          borderRadius: kBorderRadius30,
                                        ),
                                        child:   Text(
                                          " ${car.status}".tr,
                                          style: TextStyle(
                                              color: kWhiteColor, fontSize: 12.sp),

                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.black38,
                                          borderRadius: kBorderRadius30,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(MaterialCommunityIcons.eye_outline,size: 16.sp,color: kWhiteColor,),
                                            Text(
                                              " ${car.clicks}",
                                              style: TextStyle(
                                                  color: kWhiteColor, fontSize: 12.sp),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )),


                      ],
                    ),
                  ), systemOverlayStyle: SystemUiOverlayStyle.dark),
            ];
          },
          body: RemoveSplash(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      Divider(thickness: 1.h, color: Colors.grey.shade400,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Image.asset("assets/images/calender.png"
                                    , width: 30.w,
                                    height: 30.w,
                                  ), Text(
                                    "${car?.modelYear}",
                                    style: TextStyle(
                                        color: kAccentColor,fontWeight: FontWeight.bold,
                                        fontSize: 12.sp),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Image.asset("assets/images/speedcounter.png"
                                    , width: 30.w,
                                    height: 30.w,
                                  ),Text(
                                    "${car?.mileage}",
                                    style: TextStyle(
                                        color: kAccentColor,fontWeight: FontWeight.bold,
                                        fontSize: 12.sp),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Image.asset("assets/images/automatic.png"
                                    , width: 30.w,
                                    height: 30.w,
                                  ), FittedBox(
                                    child: Text(
                                      "${car?.transmission}".tr,
                                      style: TextStyle(
                                          color: kAccentColor,fontWeight: FontWeight.bold,
                                          fontSize: 12.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Image.asset("assets/images/benzin.png"
                                    , width: 30.w,
                                    height: 30.w,
                                  ), Text(
                                    "${car?.fuelType}".tr,
                                    style: TextStyle(
                                        color: kAccentColor,fontWeight: FontWeight.bold,
                                        fontSize: 12.sp),
                                  ),
                                ],
                              ),
                            ),



                          ],
                        ),
                      ),
                      Divider(thickness: 1.h, color: Colors.grey.shade400,),
                      kVerticalSpace12,
                    ],
                  ),

                  Text("CurrentPrice".tr,
                    textAlign: TextAlign.center, style: kTextStyle14.copyWith(color: kAccentColor),),
                  kVerticalSpace8,
                  Text("${getPrice(car!.price!)}", textAlign: TextAlign.center,textDirection: TextDirection.ltr,
                    style: kTextStyle18.copyWith(color: kPrimaryColor),),


            Padding(  padding: kScreenPadding,
              child:  Column(
            children: [

              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("Brand".tr, style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
                        kVerticalSpace8,
                        Text(
                          "${car.brandName}",
                          style: kTextStyle16.copyWith(color: kAccentColor),),
                      ],
                    ),
                  ), SizedBox(
                    height: 40.h,
                    child: VerticalDivider(),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text("Model".tr, style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
                        kVerticalSpace8,
                        Text(
                          "${car.modelName}",
                          style: kTextStyle16.copyWith(color: kAccentColor),),
                      ],
                    ),)
                ],
              ),
              Divider(),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("Year".tr, style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
                        kVerticalSpace8,
                        Text(
                          "${car.modelYear}",
                          style: kTextStyle16.copyWith(color: kAccentColor),),
                      ],
                    ),
                  ), SizedBox(
                    height: 40.h,
                    child: VerticalDivider(),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text("Type".tr, style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
                        kVerticalSpace8,
                        Text(
                          "${car.type}",
                          style: kTextStyle16.copyWith(color: kAccentColor),),
                      ],
                    ),)
                ],
              ),    Divider(),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("Transmission".tr, style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
                        kVerticalSpace8,
                        Text(
                          "${car.transmission}".tr,
                          style: kTextStyle16.copyWith(color: kAccentColor),),
                      ],
                    ),
                  ), SizedBox(
                    height: 40.h,
                    child: VerticalDivider(),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text("FuelType".tr, style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
                        kVerticalSpace8,
                        Text(
                          "${car.fuelType}".tr,
                          style: kTextStyle16.copyWith(color: kAccentColor),),
                      ],
                    ),)
                ],
              ),    Divider(),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("Condition".tr, style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
                        kVerticalSpace8,
                        Text(
                          "${car.condition}".tr,
                          style: kTextStyle16.copyWith(color: kAccentColor),),
                      ],
                    ),
                  ), SizedBox(
                    height: 40.h,
                    child: VerticalDivider(),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text("Mileage".tr, style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
                        kVerticalSpace8,
                        Text(
                          "${car.mileage} ${"KM".tr}",
                          style: kTextStyle16.copyWith(color: kAccentColor),),
                      ],
                    ),)
                ],
              ),    Divider(),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("Seats".tr, style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
                        kVerticalSpace8,
                        Text(
                          "${car.seats}",
                          style: kTextStyle16.copyWith(color: kAccentColor),),
                      ],
                    ),
                  ), SizedBox(
                    height: 40.h,
                    child: VerticalDivider(),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text("Engine".tr, style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
                        kVerticalSpace8,
                        Text(
                          "${car.engine}",
                          style: kTextStyle16.copyWith(color: kAccentColor),),
                      ],
                    ),)
                ],
              ),    Divider(),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text("City".tr, style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
                        kVerticalSpace8,
                        Text(
                          "${car.cityName}",
                          style: kTextStyle16.copyWith(color: kAccentColor),),
                      ],
                    ),
                  ), SizedBox(
                    height: 40.h,
                    child: VerticalDivider(),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text("Color".tr, style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
                        kVerticalSpace8,
                        Text(
                          "${car.color}".tr,
                          style: kTextStyle16.copyWith(color: kAccentColor),),
                      ],
                    ),)
                ],
              ),



            ],



            )),

                  Padding(
                    padding: kScreenPadding,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [

                          kVerticalSpace12,

                          Text("Description".tr, style: kTextStyle16.copyWith(color: kAccentColor,fontWeight: FontWeight.bold),),
                          kVerticalSpace4,
                          Text(
                            "${car.description}",
                            style: kTextStyle14.copyWith(color: kAccentColor),),



                          kVerticalSpace16,

                          if( car.featureHeads.isNotEmpty)
                            Padding(
                              padding:  EdgeInsets.only(bottom: 28.w),
                              child: Text("Features/Amenities".tr, style: kTextStyle16.copyWith(color: kAccentColor,fontWeight: FontWeight.bold),),
                            ),

                          Column(
                            children:
                            car.featureHeads.map((e) =>
                                Container(
                                  margin: EdgeInsets.only(bottom: 32.h),
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.topCenter,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 32.w, horizontal: 16.w),
                                          decoration: BoxDecoration(
                                            borderRadius: kBorderRadius4,

                                            border: Border.all(
                                                color: kBorderColor, width: 1.w),

                                          ),
                                          child:

                                          GridView.builder(
                                              padding: EdgeInsets.zero,
                                              physics: PageScrollPhysics(),
                                              shrinkWrap: true,
                                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                childAspectRatio: 1,
                                                crossAxisSpacing: 8.w,
                                                mainAxisSpacing: 8.w,
                                                crossAxisCount: 4,
                                              ),
                                              itemCount: e.features.length,


                                              itemBuilder: (context,index){
                                                return Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .center,
                                                  children: [
                                                    ImageWidget(e.features[index].image,width: 30.w,height: 30.w,),

                                                    kVerticalSpace4,
                                                    FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Text("${e.features[index].title}${e.features[index].quantity!>0?": ${e.features[index].quantity}":e.features[index].featureOption!=null?": ${e.features[index].featureOption}":""}",
                                                        style: kTextStyle12.copyWith(color: kAccentColor),
                                                        textAlign: TextAlign.center,),
                                                    )
                                                  ],
                                                );
                                              })


                                      ),

                                      Positioned(
                                        top: -16.w,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 6.w, horizontal: 12.w),
                                          decoration: BoxDecoration(
                                              color: kBgColor,
                                              borderRadius: kBorderRadius4,
                                              border: Border.all(
                                                  color: kBorderColor, width: 1.w)
                                          ),
                                          child: Text(
                                            "${e.title}", style: kTextStyle16.copyWith(color: kAccentColor),),
                                        ),
                                      )
                                    ],
                                  ),
                                )).toList(),
                          ),


                          Container(
                            width: 1.sw,
                            padding: kScreenPadding,

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: ButtonWidget(onPressed: () async {
                                     controller.refreshCar(
                                          car: car);
                                    }, text: "Refresh",color: kPrimaryColor,)),
                                    kHorizontalSpace4,
                                    Expanded(child: ButtonWidget(onPressed: () async {
                                      Get.find<VehicleController>().edit(data: car,vehicleType:  VehicleType.Car);

                                    }, text: "Edit", color: kAccentColor,)

                                    ),
                                  ],
                                ),
                                kVerticalSpace8,
                                Row(
                                  children: [
                                    Expanded(
                                      child: ButtonWidget(onPressed: () async {
                                        showConfirmationDialog(onConfirm: () {
                                          controller.deleteCar(
                                              car: car);
                                          Get.back();
                                        },
                                            title: "Delete",
                                            message: "AreYouSureToDeleteThisCar",
                                            textConfirm: "Yes",
                                            textCancel: "No");
                                      }, text: "Delete", color: kRedColor,),
                                    ), kHorizontalSpace4,
                                    car.status == "Approved" && !car.isSold!
                                        ? Expanded(
                                      child: ButtonWidget(onPressed: () async {
                                        showConfirmationDialog(onConfirm: () {
                                          controller.soldOutCar(
                                              car: car);
                                          Get.back();
                                        },
                                            title: "SoldOut",
                                            message: "AreYouSureToSoldThisCar",
                                            textConfirm: "Yes",
                                            textCancel: "No");
                                      }, text: "SoldOut",color: kLightBlueColor,),
                                    )
                                        :
                                    Container()

                                  ],
                                )
                              ],
                            ),
                          )

                        ]
                    ),
                  )


                ],
              ),
            ),
          ),
        ):CircularLoader();
      }
      ),
    );
  }
}


