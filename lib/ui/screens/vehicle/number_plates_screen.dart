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

import '../../../controllers/favorite_controller.dart';
import '../../../controllers/number_plate_controller.dart';
import '../../../models/number_plate_model.dart';

class NumberPlatesScreen extends GetView<NumberPlateController> {
   NumberPlatesScreen({Key? key}) : super(key: key){
    // controller.getFilteredNumberPlates();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //
    //   String title=Get.parameters["title"];
    //   if(controller.cars.value.isEmpty){
    //     controller.resetFilters();
    //     controller.getFilteredNumberPlates();
    //   }
    //
    // });
  }

  @override
  Widget build(BuildContext context) {
  String? title=Get.parameters["title"];


    return Scaffold(
    appBar: buildAppBar(context,title: title??"AllNumberPlates"),
      body:
      const AllNumberPlates()

    )

    ;
  }
}

class AllNumberPlates extends StatelessWidget {
  const AllNumberPlates({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NumberPlateController>(
      builder: (controller)=> Column(
        children: [
          Padding(
            padding: kScreenPadding,
            child: Row(
              children: [
                Expanded(child: Text("${"Showing".tr} ${controller.totalAds} ${"Ads".tr.toLowerCase()}",style: TextStyle(fontSize: 13.sp,color: kBlackColor),)),
                kHorizontalSpace8,
                ButtonWidget(height: 30.h,color: kAccentColor,text: "Filters",
                  onPressed: (){
Get.toNamed(Routes.numberPlateFilterScreen);
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
              controller.getFilteredNumberPlates();
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

                  controller.numberPlates.value.isEmpty?
                  Text("NoDataFound".tr,
                      style: kTextStyle16):

        controller.isGridView?
                  GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount:controller.numberPlates.value.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,
                      childAspectRatio: 0.60, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
                      itemBuilder: (context, index) {

                        var item = controller.numberPlates.value[index];
                        return NumberPlateItem(item: item,isGridView: true,);


                      }):
        ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount:controller.numberPlates.value.length,
            itemBuilder: (context, index) {

              var item = controller.numberPlates.value[index];
              return NumberPlateItem(item: item,isGridView: false,);


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



class NumberPlateItem extends StatefulWidget {
  const NumberPlateItem({
    Key? key,
    required this.item,
    this.isGridView=true
  }) : super(key: key);

  final NumberPlate item;
  final bool isGridView;

  @override
  State<NumberPlateItem> createState() => _NumberPlateItemState();
}

class _NumberPlateItemState extends State<NumberPlateItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.viewNumberPlateScreen, arguments: widget.item)?.then((value) {
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
                          .scaleDown,
                    ),
                    PositionedDirectional( top: 4.w,
                      start: 4.w,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(DateTime.now().difference(widget.item.createdAt).inDays<2)
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
                            ),
                              child:IconButtonWidget(
                                icon: widget.item.favoriteId>0?
                                MaterialCommunityIcons.heart:
                                MaterialCommunityIcons
                                    .heart_outline,
                                color:widget.item.favoriteId>0? kRedColor:kWhiteColor,
                                width: 30.w,
                                onPressed: ()async {
                                  var controller =  Get.put(FavoriteController());
                                  if(widget.item.favoriteId>0){
                                    if(await controller.deleteFavorite(numberPlate: widget.item)){
                                      setState(() {
                                      });
                                    }
                                  }else{
                                    if(await controller.addToFavorites(numberPlate:widget.item)){
                                      setState(() {

                                      });
                                    }
                                  }
                                },),
                            ),
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

                        Text("${widget.item.number}",
                          maxLines: 1,
                          style: kTextStyle16.copyWith(color: kAccentColor),),
                        kVerticalSpace4,

                        Row(
                          children: [   Icon(  MaterialCommunityIcons.map_marker_outline,    size: 16.sp,
                            color: kLightBlueColor,),
                            Expanded(
                              child: Text(
                                "${widget.item.cityName}",
                                maxLines:
                                1,
                                style:
                                TextStyle(color: kGreyColor,    height: 1.3.h, fontSize: 12.sp),
                              ),
                            ),
                          ],
                        ),
                        kVerticalSpace4,




                        Text(
                          format(widget.item.createdAt,locale: gSelectedLocale?.locale?.languageCode),textDirection: TextDirection.ltr, maxLines:
                        1,
                          style: TextStyle(color: kGreyColor,     height: 1.3.h,fontSize: 12.sp),
                        )
                        ,
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(getPrice(widget.item.price),
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                                color: kPrimaryColor,
                                height: 1.3.h,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ),

                      ],
                    ),
                  ))
            ]):
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
                        widget.item.images
                            .first,
                        fit: BoxFit
                            .cover,
                      ),
                      PositionedDirectional( top: 4.w,
                        start: 4.w,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            if(DateTime.now().difference(widget.item.createdAt).inDays<2)
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
                              ),
                                child: IconButtonWidget(
                                  icon: widget.item.favoriteId>0?
                                  MaterialCommunityIcons.heart:
                                  MaterialCommunityIcons
                                      .heart_outline,
                                  color:widget.item.favoriteId>0? kRedColor:kWhiteColor,
                                  width: 30.w,
                                  onPressed: ()async {
                                    var controller =  Get.put(FavoriteController());
                                    if(widget.item.favoriteId>0){

                                      if(await controller.deleteFavorite(numberPlate: widget.item)){
                                        setState(() {

                                        });
                                      }
                                    }else{
                                      if(await controller.addToFavorites(numberPlate:widget.item)){
                                        setState(() {

                                        });
                                      }
                                    }


                                  },),
                              ),
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


                          Text("${widget.item.number}",
                            maxLines: 1,
                            style: kTextStyle16.copyWith(color: kAccentColor),),
                          kVerticalSpace4,

                          Row(
                            children: [   Icon(  MaterialCommunityIcons.map_marker_outline,    size: 16.sp,
                              color: kLightBlueColor,),
                              Expanded(
                                child: Text(
                                  "${widget.item.cityName}",
                                  maxLines:
                                  1,
                                  style:
                                  TextStyle(color: kGreyColor,    height: 1.3.h, fontSize: 12.sp),
                                ),
                              ),
                            ],
                          ),
                          kVerticalSpace4,



                          Text(
                            format(widget.item.createdAt,locale: gSelectedLocale?.locale!.languageCode),textDirection: TextDirection.ltr, maxLines:
                          1,
                            style: TextStyle(color: kGreyColor,     height: 1.3.h,fontSize: 12.sp),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(getPrice(widget.item.price), textDirection: TextDirection.ltr,
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  height: 1.3.h,
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

