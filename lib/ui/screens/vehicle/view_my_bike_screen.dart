import 'package:cached_network_image/cached_network_image.dart';
import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/services/share_link_service.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:careqar/ui/widgets/remove_splash.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';
import '../../../controllers/view_my_bike_controller.dart';
import '../../../global_variables.dart';

class ViewMyBikeScreen extends GetView<ViewMyBikeController> {
   ViewMyBikeScreen({Key? key}) : super(key: key){
    //print(Get.arguments);
    controller.sliderIndex(0);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(backgroundColor: kWhiteColor,
      body: Obx(() {
        var bike = controller.bike.value;
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
                          Expanded(child: Text("Details".tr.toUpperCase(),textAlign: TextAlign.center,maxLines: 1,style: kAppBarStyle,)),

                          kHorizontalSpace12,
                          IconButtonWidget(
                            icon: MaterialCommunityIcons.share_variant,
                            color: kBlackColor,
                            onPressed: () async {
                              final ShareService shareService = Get.find<ShareService>();

                              await shareService.shareItem(
                                type: 'bike',
                                id: bike.bikeId.toString(),
                                title: "${bike.brandName} ${bike.modelName} ${bike.modelYear}",
                                description: bike.description, price: bike.price.toString(),
                              );
                            },
                          )
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
                            scrollPhysics: const BouncingScrollPhysics(),
                            enableInfiniteScroll: false,
                            viewportFraction: 1,
                            enlargeCenterPage: false,
                            initialPage: controller.sliderIndex.value,
                            onPageChanged: (index, reason) {
                              controller.sliderIndex.value = index;
                              controller.update();
                            },
                          ),
                          items: bike.images.map((item) {
                            return Builder(
                              builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.toNamed(
                                      Routes.staggeredGalleryScreen,
                                      arguments: bike.images,
                                    );
                                  },
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: CachedNetworkImage(
                                      imageUrl: item,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      imageBuilder: (context, imageProvider) {
                                        return Image(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        );
                                      },
                                      placeholder: (context, url) => Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: Icon(
                                            Icons.error,
                                            size: 50,
                                          ),
                                        ),
                                      ),
                                      memCacheWidth: 800,
                                      memCacheHeight: 600,
                                      maxWidthDiskCache: 1000,
                                      maxHeightDiskCache: 1000,
                                    ),
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

                                        Text("${bike.brandName} ${bike.modelName} ${bike.modelYear}",
                                            maxLines: 2, textAlign: TextAlign.center,
                                            style: kLightTextStyle18),
                                        kVerticalSpace4,
                                        Row(
                                          children: [ Icon(  MaterialCommunityIcons.map_marker_outline,    size: 16.sp,
                                            color: kWhiteColor,),
                                            Expanded(
                                              child: Text(
                                                  "${bike.cityName}", style: kTextStyle14.copyWith(color: kWhiteColor)),
                                            ),

                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      bike.isSold!?Container():  Container(
                                        margin: kScreenPadding,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color:bike.status=="Approved"? kSuccessColor:Colors.orangeAccent,
                                          borderRadius: kBorderRadius30,
                                        ),
                                        child:   Text(
                                          " ${bike.status}".tr,
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
                                              " ${bike.clicks}",
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
                                    "${bike?.modelYear}",
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
                                    "${bike?.mileage}",
                                    style: TextStyle(
                                        color: kAccentColor,fontWeight: FontWeight.bold,
                                        fontSize: 12.sp),
                                  ),
                                ],
                              ),
                            ),
                            // Expanded(
                            //   child: Column(
                            //     children: [
                            //       Image.asset("assets/images/automatic.png"
                            //         , width: 30.w,
                            //         height: 30.w,
                            //       ), Text(
                            //         "${bike?.transmission}",
                            //         style: TextStyle(
                            //             color: kAccentColor,fontWeight: FontWeight.bold,
                            //             fontSize: 12.sp),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Expanded(
                              child: Column(
                                children: [
                                  Image.asset("assets/images/benzin.png"
                                    , width: 30.w,
                                    height: 30.w,
                                  ), Text(
                                    "${bike?.fuelType}".tr,
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
                  Text("${getPrice(bike!.price!)}", textAlign: TextAlign.center,textDirection: TextDirection.ltr,
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
                                      "${bike.brandName}",
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
                                      "${bike.modelName}",
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
                                      "${bike.modelYear}",
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
                                      "${bike.type}",
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
                                      "${bike.condition}".tr,
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
                                      "${bike.mileage} ${"KM".tr}",
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
                                      "${bike.seats}",
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
                                      "${bike.engine}",
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
                                      "${bike.cityName}",
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
                                      "${bike.color}".tr,
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
                            "${bike.description}",
                            style: kTextStyle14.copyWith(color: kAccentColor),),



                          kVerticalSpace16,

                          if( bike.featureHeads.isNotEmpty)
                            Padding(
                              padding:  EdgeInsets.only(bottom: 28.w),
                              child: Text("Features/Amenities".tr, style: kTextStyle16.copyWith(color: kAccentColor,fontWeight: FontWeight.bold),),
                            ),

                          Column(
                            children:
                            bike.featureHeads.map((e) =>
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
                                                     // child: Text("${e.features[index].title}${e.features[index].quantity!>0?": ${e.features[index].quantity}":e.features[index].featureOption!=null?": ${e.features[index].featureOption}":""}",
                                                      child: Text("${e.features[index].title}",
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
                                      controller.refreshBike(
                                          bike: bike);
                                    }, text: "Refresh",color: kPrimaryColor,)),
                                    kHorizontalSpace4,
                                    Expanded(child: ButtonWidget(onPressed: () async {
                                      Get.find<VehicleController>().edit(data: bike,vehicleType: VehicleType.Bike);

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
                                          controller.deleteBike(
                                              bike: bike);
                                          Get.back();
                                        },
                                            title: "Delete",
                                            message: "AreYouSureToDeleteThisBike",
                                            textConfirm: "Yes",
                                            textCancel: "No");
                                      }, text: "Delete", color: kRedColor,),
                                    ), kHorizontalSpace4,
                                    bike.status == "Approved" && !bike.isSold!
                                        ? Expanded(
                                      child: ButtonWidget(onPressed: () async {
                                        showConfirmationDialog(onConfirm: () {
                                          controller.soldOutBike(
                                              bike: bike);
                                          Get.back();
                                        },
                                            title: "SoldOut",
                                            message: "AreYouSureToSoldThisBike",
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
