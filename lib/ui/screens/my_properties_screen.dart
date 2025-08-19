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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart';

import '../../enums.dart';
import '../../global_variables.dart';

class MyPropertiesScreen extends StatefulWidget {

  MyPropertiesScreen({super.key}){

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
          ],dividerColor: Colors.transparent),
          Expanded(child: TabBarView(
              controller: tabController,
              children: [
         Column(crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Card(
                //     margin: kScreenPadding,
                //     child: Padding(
                //       padding: kScreenPadding,
                //       child: Column(children: [
                //         Text("LookingToSellOrRentOutYourProperty".tr,
                //             style: kTextStyle16,textAlign: TextAlign.center,),
                //         kVerticalSpace12,
                //         ButtonWidget(
                //             text: "PostAnAd",
                //             onPressed: () {
                //               if(UserSession.isLoggedIn!){
                //                 Get.toNamed(Routes.newPropertyAdScreen);
                //               }else{
                //                 Get.toNamed(Routes.loginScreen);
                //               }
                //             })
                //       ]),
                //     )),
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
                              controller.isGridView?  Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: GridView.builder(
                                  padding: EdgeInsets.only(bottom: 50.h),
                                  itemCount: controller.searchedPropertyModel.properties.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: 250.h, // fixed card height like cars/bikes
                                    crossAxisSpacing: 0.w,
                                    mainAxisSpacing: 0.w,
                                  ),
                                  itemBuilder: (context, index) {
                                    var item = controller.searchedPropertyModel.properties[index];
                                    return MyPropertyItem(item: item, isGridView: true);
                                  },
                                ),
                              )
                                  :

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
                          controller.isGridView?  Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: GridView.builder(
                              padding: EdgeInsets.only(bottom: 50.h),
                              itemCount: controller.requestModel.value.requests.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisExtent: 220.h, // fixed card height for consistency
                                crossAxisSpacing: 0.w,
                                mainAxisSpacing: 0.w,
                              ),
                              itemBuilder: (context, index) {
                                var item = controller.requestModel.value.requests[index];
                                return MyRequestItem(item: item, isGridView: true);
                              },
                            ),
                          )
                              :

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
    required this.item,
    this.isGridView = true,
  }) : super(key: key);

  final Property item;
  final bool isGridView;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.viewMyPropertyScreen, arguments: item);
      },
      child: Card(
        margin: isGridView
            ? EdgeInsets.all(5.w)
            : EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        elevation: 0,
        child: isGridView
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // IMAGE SECTION
            Expanded(
              flex: 7,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: ImageWidget(
                        item.images.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),

                    // SOLD overlay
                    if (item.isSold!)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "SOLD",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    // STATUS badge
                    if (!item.isSold!)
                      Positioned(
                        top: 8.h,
                        left: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 8.w),
                          decoration: BoxDecoration(
                            color: item.status == "Approved"
                                ? kSuccessColor
                                : Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Text(
                            "${item.status}".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),

                    // Click counter
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              MaterialCommunityIcons.eye_outline,
                              color: Colors.white,
                              size: 12.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "${item.clicks}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // DETAILS SECTION
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      item.title!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E3A5F),
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Location
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.locationDot,
                          size: 12.w,
                          color: kIconColor,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            item.location!,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 11.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // Area
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.map_pin_ellipse,
                          size: 14.sp,
                          color: kIconColor,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            "${item.area} ${"Marla".tr}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 11.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // Time
                    Text(
                      format(item.createdAt!,
                          locale:
                          gSelectedLocale?.locale?.languageCode),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Price
                    Text(
                      getPrice(item.price!),
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
            : // LIST VIEW
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IMAGE
                Container(
                  width: 120.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: Colors.black54,
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.r),
                        child: ImageWidget(
                          item.images.first,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      if (item.isSold!)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "SOLD",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      if (!item.isSold!)
                        Positioned(
                          top: 8.h,
                          left: 8.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 2.h, horizontal: 8.w),
                            decoration: BoxDecoration(
                              color: item.status == "Approved"
                                  ? kSuccessColor
                                  : Colors.orangeAccent,
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Text(
                              "${item.status}".tr,
                              style: TextStyle(
                                color: kWhiteColor,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 8.h,
                        right: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                MaterialCommunityIcons.eye_outline,
                                color: Colors.white,
                                size: 12.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "${item.clicks}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),

                // DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        item.title!,
                        style: TextStyle(
                          color: const Color(0xFF1E3A5F),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),

                      // Location
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.locationDot,
                            size: 12.w,
                            color: kIconColor,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              item.location!,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),

                      // Area
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.map_pin_ellipse,
                            size: 14.sp,
                            color: kIconColor,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              "${item.area} ${"Marla".tr}",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),

                      // Time
                      Text(
                        format(item.createdAt!,
                            locale:
                            gSelectedLocale?.locale?.languageCode),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),

                      // Price
                      Text(
                        getPrice(item.price!),
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyRequestItem extends StatelessWidget {
  const MyRequestItem({
    Key? key,
    required this.item,
    this.isGridView = true,
  }) : super(key: key);

  final Request item;
  final bool isGridView;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.viewMyRequestScreen, arguments: item);
      },
      child: Card(
        margin: isGridView
            ? EdgeInsets.all(5.w)
            : EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        elevation: 0,
        child: isGridView
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // IMAGE SECTION
            Expanded(
              flex: 7,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: Image.asset(
                        gSelectedLocale?.langCode == 0
                            ? "assets/images/logo-en.png"
                            : "assets/images/logo-ar.png",
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),

                    // STATUS badge
                    Positioned(
                      top: 8.h,
                      left: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 2.h, horizontal: 8.w),
                        decoration: BoxDecoration(
                          color: item.status == "Approved"
                              ? kSuccessColor
                              : Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        child: Text(
                          "${item.status}".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // DETAILS SECTION
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.locationDot,
                          size: 12.w,
                          color: kIconColor,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            "${item.location}, ${item.cityName}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 11.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // Area
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.map_pin_ellipse,
                          size: 14.sp,
                          color: kIconColor,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            "${item.area} ${"Marla".tr}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 11.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // Price Range
                    Text(
                      "${getPrice(item.startPrice!)} - ${getPrice(item.endPrice!)}",
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: kPrimaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
            : // LIST VIEW
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // IMAGE
                Container(
                  width: 100.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: Colors.black54,
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.r),
                        child: Image.asset(
                          gSelectedLocale?.langCode == 0
                              ? "assets/images/logo-en.png"
                              : "assets/images/logo-ar.png",
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      // STATUS badge
                      Positioned(
                        top: 8.h,
                        left: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 8.w),
                          decoration: BoxDecoration(
                            color: item.status == "Approved"
                                ? kSuccessColor
                                : Colors.orangeAccent,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          child: Text(
                            "${item.status}".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),

                // DETAILS
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.locationDot,
                            size: 12.w,
                            color: kIconColor,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              "${item.location}, ${item.cityName}",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),

                      // Area
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.map_pin_ellipse,
                            size: 14.sp,
                            color: kIconColor,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              "${item.area} ${"Marla".tr}",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12.sp,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),

                      // Price Range
                      Text(
                        "${getPrice(item.startPrice!)} - ${getPrice(item.endPrice!)}",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

