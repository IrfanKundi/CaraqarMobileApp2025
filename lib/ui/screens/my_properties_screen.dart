import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/my_property_controller.dart';
import 'package:careqar/controllers/my_request_controller.dart';
import 'package:careqar/models/property_model.dart';
import 'package:careqar/models/request_model.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:careqar/user_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart';

import '../../enums.dart';
import '../../global_variables.dart';

class MyPropertiesScreen extends StatefulWidget {

  MyPropertiesScreen({Key? key}) : super(key: key){

    if(UserSession.isLoggedIn!){
      Get.put(MyPropertyController());
      Get.put(MyRequestController());
    }
  }

  @override
  State<MyPropertiesScreen> createState() => _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen> with TickerProviderStateMixin{


  late TabController tabController;

  @override
  void initState() {
    tabController=TabController(initialIndex: 0,length: 2,vsync: this);
    if(UserSession.isLoggedIn!){
      Get.find<MyPropertyController>().getProperties();
    }
    tabController.addListener(() {
      if(tabController.index==0){
        if(UserSession.isLoggedIn!){
          Get.find<MyPropertyController>().getProperties();
        }
      }else {
        if(UserSession.isLoggedIn!){
          Get.find<MyRequestController>().getRequests();
        }
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
          TabBar(
              controller: tabController,
              tabs: [
            Tab(text: "MyAds".tr,),
            Tab(text: "MyRequests".tr,),
          ]),
          Expanded(child: TabBarView(
              controller: tabController,
              children: [
         Column(crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                    margin: kScreenPadding,
                    child: Padding(
                      padding: kScreenPadding,
                      child: Column(children: [
                        Text("LookingToSellOrRentOutYourProperty".tr,
                            style: kTextStyle16,textAlign: TextAlign.center,),
                        kVerticalSpace12,
                        ButtonWidget(
                            text: "PostAnAd",
                            onPressed: () {
                              if(UserSession.isLoggedIn!){
                                Get.toNamed(Routes.newPropertyAdScreen);
                              }else{
                                Get.toNamed(Routes.loginScreen);
                              }
                            })
                      ]),
                    )),
                Padding(
                  padding: kScreenPadding.copyWith(top: 0),
                  child:Row(
                    children: [
                      Expanded(
                        child: GetBuilder<MyPropertyController>(
                          id: "search",
          builder: (controller)=>
                             CupertinoSearchTextField(

                              onChanged: (val){
                                controller.searchText=val.trim();
                            },placeholder: "Search".tr,onSubmitted: (val){
                              controller.page(1);
                              controller.searchText=val.trim();
                              controller.getProperties();
                            },
                              controller: TextEditingController(text: controller.searchText),
                              onSuffixTap: (){
                              controller.page(1);
                              controller.loadMore(true);
                              controller.searchText="";
                              controller.update(["search"]);
                              controller.getProperties();
                            },)
                        ),
                      ),
                      kHorizontalSpace8,
                      GetBuilder<MyPropertyController>(
                          builder: (controller)  {
                            return IconButtonWidget(color: kAccentColor,
                              onPressed: (){
                                controller.isGridView=!controller.isGridView;
                                controller.update();
                              },icon:controller.isGridView?
                              MaterialCommunityIcons.view_list: MaterialCommunityIcons.view_grid
                              ,);
                          }
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: GetBuilder<MyPropertyController>(
                    builder: (controller)=>
                        NotificationListener<ScrollEndNotification>(
                          onNotification: (notification) {
                            if (notification.metrics.atEdge &&
                                notification.metrics.pixels ==
                                    notification.metrics.maxScrollExtent &&
                                controller.loadMore.value) {
                              controller.page.value+=1;
                              controller.getProperties();
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
                                    ? Text("$kCouldNotLoadData",
                                    style: kTextStyle16)
                                    :

                                controller.searchedPropertyModel.properties.isEmpty?
                                Text("NoDataFound".tr,
                                    style: kTextStyle16):
                              controller.isGridView?  GridView.builder(
                                    padding: EdgeInsets.only(bottom: 50.h),
                                    shrinkWrap: true,
                                    itemCount: controller.searchedPropertyModel.properties.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,
                                    childAspectRatio: 0.60, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
                                    itemBuilder: (context, index) {

                                      var item = controller.searchedPropertyModel.properties[index];
                                      return MyPropertyItem(item: item,);


                                    }):

                              ListView.builder(
                                  padding: EdgeInsets.only(bottom: 50.h),
                                  shrinkWrap: true,
                                  itemCount: controller.searchedPropertyModel.properties.length,
                                  itemBuilder: (context, index) {

                                    var item = controller.searchedPropertyModel.properties[index];
                                    return MyPropertyItem(item: item,isGridView: false,);


                                  })


                              ),
                              controller.isLoadingMore.value?
                              Padding(
                                padding:  EdgeInsets.only(bottom: 50.h),
                                child: CircularLoader(),
                              ):Container()
                            ],
                          ),
                        ),

                  ),
                )
              ],
            ),


                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                          margin: kScreenPadding,
                          child: Padding(
                            padding: kScreenPadding,
                            child: Column(children: [
                              Text("LookingForProperty".tr,
                                  style: kTextStyle16),
                              kVerticalSpace12,
                              Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ButtonWidget(
                                      text: "PostARequest",
                                      onPressed: () {
                                        if(UserSession.isLoggedIn!){
                                          Get.toNamed(Routes.newPropertyAdScreen);
                                        }else{
                                          Get.toNamed(Routes.loginScreen);
                                        }
                                      }),
                                  kHorizontalSpace8,

                                  GetBuilder<MyRequestController>(
                                      builder: (controller)  {
                                        return IconButtonWidget(color: kAccentColor,
                                          onPressed: (){
                                            controller.isGridView=!controller.isGridView;
                                            controller.update();
                                          },icon:controller.isGridView?
                                          MaterialCommunityIcons.view_list: MaterialCommunityIcons.view_grid
                                          ,);
                                      }
                                  ),
                                ],
                              )
                            ]),
                          )),
                      // Padding(
                      //   padding: kScreenPadding,
                      //   child: Text(
                      //     "MyRequests".tr,
                      //     style: kTextStyle18,
                      //   ),
                      // ),
                      Expanded(
                        child: GetBuilder<MyRequestController>(
                            builder: (controller) =>

                            controller
                                .status.value ==
                                Status.loading
                                ? CircularLoader():

                            controller.status.value ==
                                Status.error
                                ? Text("$kCouldNotLoadData",
                                style: kTextStyle16)
                                :

                            controller.requestModel.value.requests.isEmpty?
                            Center(
                              child: Text("YouHaveNoRequests".tr,
                                  style: kTextStyle16),
                            ):
                          controller.isGridView?  GridView.builder(
                                padding: EdgeInsets.only(bottom: 50.h),
                                shrinkWrap: true,
                                itemCount: controller.requestModel.value.requests.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,
                                childAspectRatio: 0.7, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
                                itemBuilder: (context, index) {

                                  var item = controller.requestModel.value.requests[index];
                                  return MyRequestItem(item: item,);


                                }):

                          ListView.builder(
                              padding: EdgeInsets.only(bottom: 50.h),
                              shrinkWrap: true,
                              itemCount: controller.requestModel.value.requests.length,
                              itemBuilder: (context, index) {

                                var item = controller.requestModel.value.requests[index];
                                return MyRequestItem(item: item,isGridView: false,);


                              })
                          ,
),
                      )
                    ])

      ])
          )],
      ),
    );
  }
}

class MyPropertyItem extends StatelessWidget {
  const MyPropertyItem({
    Key? key,
    required this.item,  this.isGridView=true
  }) : super(key: key);

  final Property item;

  final bool isGridView;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(
            Routes
                .viewMyPropertyScreen,
            arguments:
            item);
      },
      child: Card(
        margin:  isGridView?
        EdgeInsets.all(5.w):
        EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.w),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child:
        isGridView?
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
                item.isSold!?Container():  PositionedDirectional(
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
                    PositionedDirectional(
                        top: 4.w,
                        end: 4.w,
                        child: Container(
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

                        Text("${item.title}",
                          maxLines: 1,
                          style: kTextStyle16.copyWith(color: kAccentColor),),
                        kVerticalSpace4,

                        Row(
                          children: [   Icon(  MaterialCommunityIcons.map_marker_outline,    size: 16.sp,
                            color: kLightBlueColor,),
                            Expanded(
                              child: Text(
                                "${item.location}",
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
                          "${format(item.createdAt!,locale: gSelectedLocale?.locale?.languageCode)}",textDirection: TextDirection.ltr, maxLines:
                        1,
                          style: TextStyle(color: kGreyColor,     height: 1.3,fontSize: 12.sp),
                        ),

                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            "${getPrice(item.price!)}", textDirection: TextDirection.ltr,
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
        Container(
          height:   120.h,
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
                      item.isSold!?Container():  PositionedDirectional(
                          top: 4.h,
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
                      PositionedDirectional(
                          top: 30.h,
                          start: 4.w,
                          child: Container(
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

                          Text("${item.title}",
                            maxLines: 1,
                            style: kTextStyle16.copyWith(color: kAccentColor),),
                          kVerticalSpace4,

                          Row(
                            children: [   Icon(  MaterialCommunityIcons.map_marker_outline,    size: 16.sp,
                              color: kLightBlueColor,),
                              Expanded(
                                child: Text(
                                  "${item.location}",
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
                            "${format(item.createdAt!,locale: gSelectedLocale?.locale?.languageCode)}",textDirection: TextDirection.ltr, maxLines:
                          1,
                            style: TextStyle(color: kGreyColor,     height: 1.3,fontSize: 12.sp),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              "${getPrice(item.price!)}",textDirection: TextDirection.ltr,
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

class MyRequestItem extends StatelessWidget {
  const MyRequestItem({
    Key? key,
    required this.item,this.isGridView=true
  }) : super(key: key);

  final Request item;
  final bool isGridView;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(

    onTap: (){
      Get.toNamed(Routes.viewMyRequestScreen,arguments: item);
    },
      child: Card(
        margin:  isGridView?
        EdgeInsets.all(5.w):
        EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child:   isGridView?Column(
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
                          "${getPrice(item.startPrice!)} -\n${getPrice(item.endPrice!)}", textDirection: TextDirection.ltr,
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
        Container(height: 100.h,
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
                            "${getPrice(item.startPrice!)} -\n${getPrice(item.endPrice!)}", textDirection: TextDirection.ltr,
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
}
