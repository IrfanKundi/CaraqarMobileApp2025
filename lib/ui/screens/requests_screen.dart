import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/home_controller.dart';
import 'package:careqar/controllers/request_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/models/request_model.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../routes.dart';

/*class RequestsScreen extends StatefulWidget {
   const RequestsScreen({Key? key}) : super(key: key);

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {



  @override
  void initState() {

    Get.find<HomeController>().requestController.getRequests();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context,title: "Requests",),
      body:
      GetBuilder<RequestController>(
        builder: (controller) =>

        controller
            .status.value ==
            Status.loading
            ? Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      Container(
                        width: 120.w,height: 30.h,
                        decoration: BoxDecoration(

                            borderRadius: kBorderRadius30,
                            color:kWhiteColor,
                            border: Border.all(color: kPrimaryColor)

                        ),
                        child: Obx(
                              () => Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if(controller.isBuyerMode.value==true){
                                      controller.isBuyerMode.value=null;
                                    }else{
                                      controller.isBuyerMode.value=true;
                                    }

                                    controller.loadMore.value=true;
                                    controller.page.value=1;
                                    controller.getRequests();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 35.w,
                                    decoration: BoxDecoration(
                                      color: controller.isBuyerMode.value==true
                                          ? kPrimaryColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadiusDirectional.horizontal(start: Radius.circular(30.r)),
                                    ),
                                    child: Text(
                                      "Sell".tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: controller
                                              .isBuyerMode
                                              .value==true
                                              ? kWhiteColor
                                              : kPrimaryColor,
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
                                      if(controller.isBuyerMode.value==false){
                                        controller.isBuyerMode.value=null;
                                      }else{
                                        controller.isBuyerMode.value=false;
                                      }
                                      controller.loadMore.value=true;
                                      controller.page.value=1;
                                      controller.getRequests();

                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 35.w,
                                      decoration: BoxDecoration(
                                        color: controller
                                            .isBuyerMode.value==false
                                            ? kPrimaryColor:Colors.transparent
                                        ,
                                        borderRadius: BorderRadiusDirectional.horizontal(end: Radius.circular(30.r)),
                                      ),
                                      child: Text(
                                        "Rent".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: controller
                                                .isBuyerMode.value==false
                                                ? kWhiteColor
                                                : kPrimaryColor,
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
                      kHorizontalSpace16,
                      IconButtonWidget(color: kAccentColor,
                        onPressed: (){
                          controller.isGridView=!controller.isGridView;
                          controller.update();
                        },icon:controller.isGridView?
                        MaterialCommunityIcons.view_list: MaterialCommunityIcons.view_grid
                        ,
                        iconSize: 32.sp,
                      ),

                    ],
                  ),
                ),
                CircularLoader(),
                SizedBox(height: 50.h,)
              ],
            ):

        controller.status.value ==
            Status.error
            ? Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      Container(
                        width: 120.w,height: 30.h,
                        decoration: BoxDecoration(

                            borderRadius: kBorderRadius30,
                            color:kWhiteColor,
                            border: Border.all(color: kPrimaryColor)

                        ),
                        child: Obx(
                              () => Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    if(controller.isBuyerMode.value==true){
                                      controller.isBuyerMode.value=null;
                                    }else{
                                      controller.isBuyerMode.value=true;
                                    }

                                    controller.loadMore.value=true;
                                    controller.page.value=1;
                                    controller.getRequests();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 35.w,
                                    decoration: BoxDecoration(
                                      color: controller.isBuyerMode.value==true
                                          ? kPrimaryColor
                                          : Colors.transparent,
                                      borderRadius: BorderRadiusDirectional.horizontal(start: Radius.circular(30.r)),
                                    ),
                                    child: Text(
                                      "Sell".tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: controller
                                              .isBuyerMode
                                              .value==true
                                              ? kWhiteColor
                                              : kPrimaryColor,
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
                                      if(controller.isBuyerMode.value==false){
                                        controller.isBuyerMode.value=null;
                                      }else{
                                        controller.isBuyerMode.value=false;
                                      }
                                      controller.loadMore.value=true;
                                      controller.page.value=1;
                                      controller.getRequests();

                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 35.w,
                                      decoration: BoxDecoration(
                                        color: controller
                                            .isBuyerMode.value==false
                                            ? kPrimaryColor:Colors.transparent
                                        ,
                                        borderRadius: BorderRadiusDirectional.horizontal(end: Radius.circular(30.r)),
                                      ),
                                      child: Text(
                                        "Rent".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: controller
                                                .isBuyerMode.value==false
                                                ? kWhiteColor
                                                : kPrimaryColor,
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
                      kHorizontalSpace16,
                      IconButtonWidget(color: kAccentColor,
                        onPressed: (){
                          controller.isGridView=!controller.isGridView;
                          controller.update();
                        },icon:controller.isGridView?
                        MaterialCommunityIcons.view_list: MaterialCommunityIcons.view_grid
                        ,
                        iconSize: 32.sp,
                      ),

                    ],
                  ),
                ),
                Center(
                  child: Text("$kCouldNotLoadData".tr,
                  style: kTextStyle16),
                ),
                SizedBox(height: 50.h,)
              ],
            )
            :

        controller.requestModel.value.requests.isEmpty?
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  Container(
                    width: 120.w,height: 30.h,
                    decoration: BoxDecoration(

                        borderRadius: kBorderRadius30,
                        color:kWhiteColor,
                        border: Border.all(color: kPrimaryColor)

                    ),
                    child: Obx(
                          () => Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if(controller.isBuyerMode.value==true){
                                  controller.isBuyerMode.value=null;
                                }else{
                                  controller.isBuyerMode.value=true;
                                }

                                controller.loadMore.value=true;
                                controller.page.value=1;
                                controller.getRequests();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 35.w,
                                decoration: BoxDecoration(
                                  color: controller.isBuyerMode.value==true
                                      ? kPrimaryColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadiusDirectional.horizontal(start: Radius.circular(30.r)),
                                ),
                                child: Text(
                                  "Sell".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: controller
                                          .isBuyerMode
                                          .value==true
                                          ? kWhiteColor
                                          : kPrimaryColor,
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
                                  if(controller.isBuyerMode.value==false){
                                    controller.isBuyerMode.value=null;
                                  }else{
                                    controller.isBuyerMode.value=false;
                                  }
                                  controller.loadMore.value=true;
                                  controller.page.value=1;
                                  controller.getRequests();

                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 35.w,
                                  decoration: BoxDecoration(
                                    color: controller
                                        .isBuyerMode.value==false
                                        ? kPrimaryColor:Colors.transparent
                                    ,
                                    borderRadius: BorderRadiusDirectional.horizontal(end: Radius.circular(30.r)),
                                  ),
                                  child: Text(
                                    "Rent".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: controller
                                            .isBuyerMode.value==false
                                            ? kWhiteColor
                                            : kPrimaryColor,
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
                  kHorizontalSpace16,
                  IconButtonWidget(color: kAccentColor,
                    onPressed: (){
                      controller.isGridView=!controller.isGridView;
                      controller.update();
                    },icon:controller.isGridView?
                    MaterialCommunityIcons.view_list: MaterialCommunityIcons.view_grid
                    ,
                    iconSize: 32.sp,
                  ),

                ],
              ),
            ),
            Center(
              child: Text("NoRequestsFound".tr,
                  style: kTextStyle16),
            ),
            SizedBox(height: 50.h,)
          ],
        ):
        Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  Container(
                    width: 120.w,height: 30.h,
                    decoration: BoxDecoration(

                        borderRadius: kBorderRadius30,
                        color:kWhiteColor,
                        border: Border.all(color: kPrimaryColor)

                    ),
                    child: Obx(
                          () => Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if(controller.isBuyerMode.value==true){
                                  controller.isBuyerMode.value=null;
                                }else{
                                  controller.isBuyerMode.value=true;
                                }

                                controller.loadMore.value=true;
                                controller.page.value=1;
                                controller.getRequests();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 35.w,
                                decoration: BoxDecoration(
                                  color: controller.isBuyerMode.value==true
                                      ? kPrimaryColor
                                      : Colors.transparent,
                                  borderRadius: BorderRadiusDirectional.horizontal(start: Radius.circular(30.r)),
                                ),
                                child: Text(
                                  "Sell".tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: controller
                                          .isBuyerMode
                                          .value==true
                                          ? kWhiteColor
                                          : kPrimaryColor,
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
                                  if(controller.isBuyerMode.value==false){
                                    controller.isBuyerMode.value=null;
                                  }else{
                                    controller.isBuyerMode.value=false;
                                  }
                                  controller.loadMore.value=true;
                                  controller.page.value=1;
                                  controller.getRequests();

                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 35.w,
                                  decoration: BoxDecoration(
                                    color: controller
                                        .isBuyerMode.value==false
                                        ? kPrimaryColor:Colors.transparent
                                    ,
                                    borderRadius: BorderRadiusDirectional.horizontal(end: Radius.circular(30.r)),
                                  ),
                                  child: Text(
                                    "Rent".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: controller
                                            .isBuyerMode.value==false
                                            ? kWhiteColor
                                            : kPrimaryColor,
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
                  kHorizontalSpace16,
                  IconButtonWidget(color: kAccentColor,
                    onPressed: (){
                      controller.isGridView=!controller.isGridView;
                      controller.update();
                    },icon:controller.isGridView?
                    MaterialCommunityIcons.view_list: MaterialCommunityIcons.view_grid
                    ,
                    iconSize: 32.sp,
                  ),

                ],
              ),
            ),
            controller.isGridView? Expanded(
              child: GridView.builder(
                  padding: EdgeInsets.only(bottom: 50.h),
                  shrinkWrap: true,
                  itemCount: controller.requestModel.value.requests.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,
                  childAspectRatio: 0.7, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
                  itemBuilder: (context, index) {
              
                    var item = controller.requestModel.value.requests[index];
                    return RequestItem(item: item,);
              
              
                  }),
            ):
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 50.h),
                  shrinkWrap: true,
                  itemCount: controller.requestModel.value.requests.length,

                  itemBuilder: (context, index) {

                    var item = controller.requestModel.value.requests[index];
                    return RequestItem(item: item,isGridView: false,);


                  }),
            ),
          ],
        )
        ,
      )
      );
  }
}


class RequestItem extends StatelessWidget {
  const RequestItem({
    Key? key,
    required this.item,this.isGridView=true
  }) : super(key: key);

  final Request item;
  final bool isGridView;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.toNamed(Routes.viewRequestScreen,arguments: item);
      },
      child: Card(    margin:  isGridView?
      EdgeInsets.all(5.w):
      EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.w),shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child:  isGridView?Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
            children: [
              Expanded(
                child:
                Stack(
                  children: [
                    Image.asset(
                      gSelectedLocale?.langCode==0? "assets/images/logo-en.png":"assets/images/logo-ar.png",
                      width: double.infinity,

                      fit: BoxFit
                          .scaleDown
                      ,
                    ),
                    PositionedDirectional(
                        top: 4.w,
                        start: 4.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          decoration: BoxDecoration(
                            color:item.status=="Approved"? kSuccessColor:Colors.orangeAccent,
                            borderRadius: kBorderRadius30,
                          ),
                          child:   Text(
                            "${item.status}".tr,
                            style: TextStyle(
                                color: kWhiteColor, fontSize: 12.sp),

                          ),
                        )),
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


                        Row(
                          children: [   Icon(  MaterialCommunityIcons.map_marker_outline,    size: 16.sp,
                            color: kLightBlueColor,),
                            Expanded(
                              child: Text(
                                "${item.location}, ${item.cityName}",
                                maxLines:
                                1,
                                style:
                                TextStyle(color: kGreyColor,    height: 1.3, fontSize: 12.sp),
                              ),
                            ),
                          ],
                        ),    kVerticalSpace4,

                        Row(
                          children: [  Icon(
                            CupertinoIcons.map_pin_ellipse,
                            size: 16.sp,
                            color: kLightBlueColor,
                          ),

                            Expanded(
                                child: Text(
                                  " ${item.area} ${"Marla".tr}",
                                  style: TextStyle(color: kGreyColor,     height: 1.3,fontSize: 12.sp),
                                )),
                          ],
                        ),
                        kVerticalSpace4,
                        Text(
                          "${getPrice(item.startPrice!)} -\n${getPrice(item.endPrice!)}",textDirection: TextDirection.ltr,
                          style: TextStyle(
                              color: kPrimaryColor,
                              height: 1.3,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ))
            ]):
        Container(
          height: 100.h,
          child: Row(
              crossAxisAlignment:
              CrossAxisAlignment
                  .stretch,
              children: [
                Expanded(
                  child:
                  Stack(
                    children: [
                      Image.asset(
                        gSelectedLocale?.langCode==0? "assets/images/logo-en.png":"assets/images/logo-ar.png",
                        width: double.infinity,

                        fit: BoxFit
                            .scaleDown
                        ,
                      ),
                      PositionedDirectional(
                          top: 4.w,
                          start: 4.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 8),
                            decoration: BoxDecoration(
                              color:item.status=="Approved"? kSuccessColor:Colors.orangeAccent,
                              borderRadius: kBorderRadius30,
                            ),
                            child:   Text(
                              "${item.status}".tr,
                              style: TextStyle(
                                  color: kWhiteColor, fontSize: 12.sp),

                            ),
                          )),
                    ],
                  ),
                ),
                Expanded(flex: 2,
                    child:
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [


                          Row(
                            children: [   Icon(  MaterialCommunityIcons.map_marker_outline,    size: 16.sp,
                              color: kLightBlueColor,),
                              Expanded(
                                child: Text(
                                  "${item.location}, ${item.cityName}",
                                  maxLines:
                                  1,
                                  style:
                                  TextStyle(color: kGreyColor,    height: 1.3, fontSize: 12.sp),
                                ),
                              ),
                            ],
                          ),    kVerticalSpace4,

                          Row(
                            children: [  Icon(
                              CupertinoIcons.map_pin_ellipse,
                              size: 16.sp,
                              color: kLightBlueColor,
                            ),

                              Expanded(
                                  child: Text(
                                    " ${item.area} ${"Marla".tr}",
                                    style: TextStyle(color: kGreyColor,     height: 1.3,fontSize: 12.sp),
                                  )),
                            ],
                          ),
                          kVerticalSpace4,
                          Text(
                            "${getPrice(item.startPrice!)} -\n${getPrice(item.endPrice!)}",textDirection: TextDirection.ltr,
                            style: TextStyle(
                                color: kPrimaryColor,
                                height: 1.3,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600),
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
}*/
class RequestsScreen extends StatelessWidget {
  const RequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: "Requests".tr),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/not_found.png',
              width: 100.w,
              height: 100.h,
              color: Colors.grey[400],
            ),
            Text(
              "Coming Soon".tr,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
