import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart';

import '../../../controllers/bike_controller.dart';
import '../../../controllers/favorite_controller.dart';
import '../../../models/bike_model.dart';

class BikesScreen extends GetView<BikeController> {
   BikesScreen({Key? key}) : super(key: key){

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //
    //   String title=Get.parameters["title"];
    //   if(controller.bikes.value.isEmpty){
    //     controller.resetFilters();
    //     controller.getFilteredBikes();
    //   }
    //
    // });
  }

  @override
  Widget build(BuildContext context) {
    String? title=Get.parameters["title"];


    return Scaffold(
    appBar: buildAppBar(context,title: title??"AllBikes"),
      body:  const AllBikes())

    ;
  }
}

class AllBikes extends StatelessWidget {
  const AllBikes({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BikeController>(
      builder: (controller)=> Column(
        children: [
          Padding(
            padding: kScreenPadding,
            child: Row(
              children: [
                Expanded(child: Text("${"Showing".tr} ${controller.totalAds} ${"Ads".tr.toLowerCase()}",style: TextStyle(fontSize: 13.sp,color: kBlackColor),)),
                kHorizontalSpace8,
                ButtonWidget(height: 30.h,color: kAccentColor,text: "Filter",
                  onPressed: (){
                    Get.toNamed(Routes.bikeFilterScreen);
                  },icon: MaterialCommunityIcons.filter_variant,),
                kHorizontalSpace8,
                IconButtonWidget(color: kAccentColor,
                  onPressed: (){
                    controller.isGridView=!controller.isGridView;
                    controller.update();
                  },icon:controller.isGridView?
                  MaterialCommunityIcons.view_list: MaterialCommunityIcons.view_grid
                  ,)
              ],
            ),
          ),



      Expanded(
        child:NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            if (notification.metrics.atEdge &&
                notification.metrics.pixels ==
                    notification.metrics.maxScrollExtent &&
                controller.loadMore.value) {
              controller.page.value+=1;
              controller.getFilteredBikes();
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

                  controller.bikes.value.isEmpty?
                  Text("NoDataFound".tr,
                      style: kTextStyle16):

        controller.isGridView?
                  GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount:controller.bikes.value.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,
                      childAspectRatio: 0.45, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
                      itemBuilder: (context, index) {

                        var item = controller.bikes.value[index];
                        return BikeItem(item: item,isGridView: true,);


                      }):
        ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount:controller.bikes.value.length,
            itemBuilder: (context, index) {

              var item = controller.bikes.value[index];
              return BikeItem(item: item,isGridView: false,);


            })
                  ,
                ),   controller.isLoadingMore.value?
                Padding(
                  padding:  EdgeInsets.symmetric(vertical: 8.w),
                  child: CircularLoader(),
                ):Container()
              ],
            ),
        ),
      )],
      ),
    );
  }
}




class BikeItem extends StatefulWidget {
  const BikeItem({
    Key? key,
    required this.item,
    this.isGridView=true
  }) : super(key: key);

  final Bike item;
  final bool isGridView;

  @override
  State<BikeItem> createState() => _BikeItemState();
}

class _BikeItemState extends State<BikeItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(
            Routes.viewBikeScreen,
            arguments:
            widget.item)?.then((value) {
          if(mounted){
            setState(() {

            });
          }
        });
      },
      child: Card(
        margin:  widget.isGridView?
        EdgeInsets.all(5.w):
        EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.w),


        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child:
        widget.isGridView?

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
                      widget.item.images
                          .first,
                      fit: BoxFit
                          .cover,
                    ),
                    PositionedDirectional( top: 4.w,
                      start: 4.w,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(DateTime.now().difference(widget.item.createdAt!).inDays<2)
                            Container(
                              margin: EdgeInsets.only(top: 4.h),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 8),
                              decoration: BoxDecoration(
                                color: kRedColor,
                                borderRadius: kBorderRadius30,
                              ),
                              child: Text(
                                "New".tr,
                                style: TextStyle(
                                    color:kWhiteColor, fontSize: 10.sp),),
                            ),
                        ],
                      ),
                    ),
                    PositionedDirectional(
                        top: 4.w,
                        end: 4.w,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: kBorderRadius30,
                              ),
                              child: Row(
                                children: [
                                  Icon(MaterialCommunityIcons.eye_outline,size: 16.sp,color: kWhiteColor,),
                                  Text(
                                    " ${widget.item.clicks}",
                                    style: TextStyle(
                                        color: kWhiteColor, fontSize: 12.sp),),
                                ],
                              ),
                            ),
                  kVerticalSpace4,
                  Container(     decoration: const BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle
                  ),  child:   IconButtonWidget(
                              icon: widget.item.favoriteId!>0?
                              MaterialCommunityIcons.heart:
                              MaterialCommunityIcons
                                  .heart_outline,
                              color:widget.item.favoriteId!>0? kRedColor:kWhiteColor,
                              width: 30.w,
                              onPressed: ()async {
                                var controller=Get.put(FavoriteController());
                                if(widget.item.favoriteId!>0){

                                  if(await controller.deleteFavorite(bike: widget.item,removeFav: true)){
                                    setState(() {

                                    });
                                  }
                                }else{
                                  if(await controller.addToFavorites(bike:widget.item)){
                                  setState(() {

                                  });
                                  }
                                }

                              },),)
                          ],
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

                        Text("${widget.item.brandName} ${widget.item.modelName} ${widget.item.modelYear}",
                          maxLines: 2,
                          style: kTextStyle16.copyWith(color: kAccentColor),),
                        kVerticalSpace4,

                        Row(
                          children: [   Icon(  MaterialCommunityIcons.map_marker_outline,    size: 16.sp,
                            color: kLightBlueColor,),
                            Expanded(
                              child: Text(
                                " ${widget.item.cityName}",
                                maxLines:
                                1,
                                style:
                                TextStyle(color: kGreyColor,    height: 1.3, fontSize: 12.sp),
                              ),
                            ),
                          ],
                        ),
                        kVerticalSpace4,

                        Row(
                          children: [   Icon(  MaterialCommunityIcons.bike,    size: 16.sp,
                            color: kLightBlueColor,),
                            Expanded(
                              child: Text(
                                " ${widget.item.type}",
                                maxLines:
                                1,
                                style:
                                TextStyle(color: kGreyColor,    height: 1.3, fontSize: 12.sp),
                              ),
                            ),
                          ],
                        ),    kVerticalSpace4,

                        Row(
                          children: [   Icon(  MaterialCommunityIcons.speedometer,    size: 16.sp,
                            color: kLightBlueColor,),
                            Expanded(
                              child: Text(
                                " ${widget.item.mileage} ${"KM".tr}",
                                maxLines:
                                1,
                                style:
                                TextStyle(color: kGreyColor,    height: 1.3, fontSize: 12.sp),
                              ),
                            ),
                          ],
                        ),    kVerticalSpace4,



                        Text(
                          format(widget.item.createdAt!,locale: gSelectedLocale?.locale?.languageCode),textDirection: TextDirection.ltr, maxLines:
                        1,
                          style: TextStyle(color: kGreyColor,     height: 1.3,fontSize: 12.sp),
                        )
                        ,
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(getPrice(widget.item.price!),
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
            ]):
        SizedBox(
          height: 140.h,
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
                        widget.item.images
                            .first,
                        fit: BoxFit
                            .cover,
                      ),
                      PositionedDirectional( top: 4.w,
                        start: 4.w,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            if(DateTime.now().difference(widget.item.createdAt!).inDays<2)
                              Container(
                                margin: EdgeInsets.only(top: 4.h),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: kRedColor,
                                  borderRadius: kBorderRadius30,
                                ),
                                child: Text(
                                  "New".tr,
                                  style: TextStyle(
                                      color:kWhiteColor, fontSize: 10.sp),),
                              ),
                          ],
                        ),
                      ),
                      PositionedDirectional(
                          top: 4.w,
                          end: 4.w,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: kBorderRadius30,
                                ),
                                child: Row(
                                  children: [
                                    Icon(MaterialCommunityIcons.eye_outline,size: 16.sp,color: kWhiteColor,),
                                    Text(
                                      " ${widget.item.clicks}",
                                      style: TextStyle(
                                          color: kWhiteColor, fontSize: 12.sp),),
                                  ],
                                ),
                              ),  kVerticalSpace4,
                              Container(     decoration: const BoxDecoration(
                                  color: Colors.black38,
                                  shape: BoxShape.circle
                              ),
                             child: IconButtonWidget(
                                icon: widget.item.favoriteId!>0?
                                MaterialCommunityIcons.heart:
                                MaterialCommunityIcons
                                    .heart_outline,
                                color:widget.item.favoriteId!>0? kRedColor:kWhiteColor,
                                width: 30.w,
                                onPressed: ()async {
                                  var controller=Get.put(FavoriteController());
                                  if(widget.item.favoriteId!>0){

                                    if(await controller.deleteFavorite(bike: widget.item,removeFav: true)){
                                      setState(() {

                                      });
                                    }
                                  }else{
                                    if(await controller.addToFavorites(bike:widget.item)){
                                      setState(() {

                                      });
                                    }
                                  }

                                },)),
                            ],
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

                          Text("${widget.item.brandName} ${widget.item.modelName} ${widget.item.modelYear}",
                            maxLines: 1,
                            style: kTextStyle16.copyWith(color: kAccentColor),),
                          kVerticalSpace4,

                          Row(
                            children: [   Icon(  MaterialCommunityIcons.map_marker_outline,    size: 16.sp,
                              color: kLightBlueColor,),
                              Expanded(
                                child: Text(
                                  " ${widget.item.cityName}",
                                  maxLines:
                                  1,
                                  style:
                                  TextStyle(color: kGreyColor,    height: 1.3, fontSize: 12.sp),
                                ),
                              ),
                            ],
                          ),
                          kVerticalSpace4,

                          Row(
                            children: [   Icon(  MaterialCommunityIcons.bike,    size: 16.sp,
                              color: kLightBlueColor,),
                              Expanded(
                                child: Text(
                                  " ${widget.item.type}",
                                  maxLines:
                                  1,
                                  style:
                                  TextStyle(color: kGreyColor,    height: 1.3, fontSize: 12.sp),
                                ),
                              ),
                            ],
                          ),    kVerticalSpace4,

                          Row(
                            children: [   Icon(  MaterialCommunityIcons.speedometer,    size: 16.sp,
                              color: kLightBlueColor,),
                              Expanded(
                                child: Text(
                                  " ${widget.item.mileage} ${"KM".tr}",
                                  maxLines:
                                  1,
                                  style:
                                  TextStyle(color: kGreyColor,    height: 1.3, fontSize: 12.sp),
                                ),
                              ),
                            ],
                          ),    kVerticalSpace4,


                          Text(
                            format(widget.item.createdAt!,locale: gSelectedLocale?.locale?.languageCode),textDirection: TextDirection.ltr, maxLines:
                          1,
                            style: TextStyle(color: kGreyColor,     height: 1.3,fontSize: 12.sp),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(getPrice(widget.item.price!), textDirection: TextDirection.ltr,
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
              ]),
        ),

      ),
    );
  }
}
