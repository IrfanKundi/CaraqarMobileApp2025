import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/my_numberplate_controller.dart';
import 'package:careqar/models/car_model.dart';
import 'package:careqar/models/number_plate_model.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:careqar/user_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart';

import '../../../controllers/my_bike_controller.dart';
import '../../../controllers/my_car_controller.dart';
import '../../../enums.dart';
import '../../../global_variables.dart';
import '../../../models/bike_model.dart';

class MyCarsScreen extends StatefulWidget {

  MyCarsScreen({Key? key}) : super(key: key){

  }

  @override
  State<MyCarsScreen> createState() => _MyCarsScreenState();
}

class _MyCarsScreenState extends State<MyCarsScreen> with TickerProviderStateMixin{


  TabController? tabController;

  @override
  void initState() {
    tabController = TabController(initialIndex: 0, length: 3, vsync: this);

    // Load initial data only if logged in
    if(UserSession.isLoggedIn!) {
      Get.find<MyCarController>().getCars();
      Get.find<MyBikeController>().getBikes(); // ✅ Add this line!
    }

    tabController!.addListener(() {
      if(tabController!.index == 0) {
        if(UserSession.isLoggedIn!) { // ✅ Fixed: should be logged IN
          Get.find<MyCarController>().getCars(reset: true);
        }
      }
      else if(tabController!.index == 1) {
        if(UserSession.isLoggedIn!) { // ✅ Fixed: should be logged IN
          Get.find<MyBikeController>().getBikes(reset: true);
        }
      }
      else {
        if(UserSession.isLoggedIn!) { // ✅ Fixed: should be logged IN
          Get.find<MyNumberPlateController>().getNumberPlates(reset: true);
        }
      }
    });

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
            Tab(text: "Car".tr,),
                Tab(text: "Bike".tr,),
                Tab(text: "No.Plate".tr,),
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
                        Text("LookingToSellOrRentOutYourCar".tr,
                            style: kTextStyle16,textAlign: TextAlign.center,),
                        kVerticalSpace12,
                        ButtonWidget(
                            text: "PostAnAd",
                            onPressed: () {
                              if(UserSession.isLoggedIn!){
                                Get.toNamed(Routes.newAdScreen);
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
                        child: GetBuilder<MyCarController>(
                          id: "search",
          builder: (controller)=>
                             CupertinoSearchTextField(

                              onChanged: (val){
                                controller.searchText=val.trim();
                            },placeholder: "Search".tr,onSubmitted: (val){
                              controller.page(1);
                              controller.searchText=val.trim();
                              controller.getCars();
                            },
                              controller: TextEditingController(text: controller.searchText),
                              onSuffixTap: (){
                              controller.page(1);
                              controller.loadMore(true);
                              controller.searchText="";
                              controller.update(["search"]);
                              controller.getCars();
                            },)
                        ),
                      ),
                      kHorizontalSpace8,
                      GetBuilder<MyCarController>(
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
                  child: GetBuilder<MyCarController>(
                    builder: (controller)=>
                        NotificationListener<ScrollEndNotification>(
                          onNotification: (notification) {
                            if (notification.metrics.atEdge &&
                                notification.metrics.pixels ==
                                    notification.metrics.maxScrollExtent &&
                                controller.loadMore.value) {
                              controller.page.value+=1;
                              controller.getCars();
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
                                    ? Text("$kCouldNotLoadData".tr,
                                    style: kTextStyle16)
                                    :

                                controller.searchedCarModel.cars.isEmpty?
                                Text("NoDataFound".tr,
                                    style: kTextStyle16):
                              controller.isGridView?  Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: GridView.builder(
                                  padding: EdgeInsets.only(bottom: 50.h),
                                  itemCount: controller.searchedCarModel.cars.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: 250.h, // fixed card height for consistency
                                    crossAxisSpacing: 0.w,
                                    mainAxisSpacing: 0.w,
                                  ),
                                  itemBuilder: (context, index) {
                                    var item = controller.searchedCarModel.cars[index];
                                    return MyCarItem(item: item, isGridView: true);
                                  },
                                ),
                              ):

                              ListView.builder(
                                  padding: EdgeInsets.only(bottom: 50.h),
                                  shrinkWrap: true,
                                  itemCount: controller.searchedCarModel.cars.length,
                                  itemBuilder: (context, index) {

                                    var item = controller.searchedCarModel.cars[index];
                                    return MyCarItem(item: item,isGridView: false,);


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
                Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                        margin: kScreenPadding,
                        child: Padding(
                          padding: kScreenPadding,
                          child: Column(children: [
                            Text("LookingToSellOrRentOutYourBike".tr,
                              style: kTextStyle16,textAlign: TextAlign.center,),
                            kVerticalSpace12,
                            ButtonWidget(
                                text: "PostAnAd",
                                onPressed: () {
                                  if(UserSession.isLoggedIn!){
                                    Get.toNamed(Routes.newAdScreen);
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
                            child: GetBuilder<MyBikeController>(
                                id: "search",
                                builder: (controller)=>
                                    CupertinoSearchTextField(

                                      onChanged: (val){
                                        controller.searchText=val.trim();
                                      },placeholder: "Search".tr,onSubmitted: (val){
                                      controller.page(1);
                                      controller.searchText=val.trim();
                                      controller.getBikes();
                                    },
                                      controller: TextEditingController(text: controller.searchText),
                                      onSuffixTap: (){
                                        controller.page(1);
                                        controller.loadMore(true);
                                        controller.searchText="";
                                        controller.update(["search"]);
                                        controller.getBikes();
                                      },)
                            ),
                          ),
                          kHorizontalSpace8,
                          GetBuilder<MyBikeController>(
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
                      child: GetBuilder<MyBikeController>(
                        builder: (controller)=>
                            NotificationListener<ScrollEndNotification>(
                              onNotification: (notification) {
                                if (notification.metrics.atEdge &&
                                    notification.metrics.pixels ==
                                        notification.metrics.maxScrollExtent &&
                                    controller.loadMore.value) {
                                  controller.page.value+=1;
                                  controller.getBikes();
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
                                          ? Text("$kCouldNotLoadData".tr,
                                          style: kTextStyle16)
                                          :

                                      controller.searchedBikeModel.bikes.isEmpty?
                                      Text("NoDataFound".tr,
                                          style: kTextStyle16):
                                      controller.isGridView?  Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: GridView.builder(
                                          padding: EdgeInsets.only(bottom: 50.h),
                                          itemCount: controller.searchedBikeModel.bikes.length,
                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisExtent: 250.h, // fixed card height like Car/Bike grids
                                            crossAxisSpacing: 0.w,
                                            mainAxisSpacing: 0.w,
                                          ),
                                          itemBuilder: (context, index) {
                                            var item = controller.searchedBikeModel.bikes[index];
                                            return MyBikeItem(item: item, isGridView: true);
                                          },
                                        ),
                                      ):

                                      ListView.builder(
                                          padding: EdgeInsets.only(bottom: 50.h),
                                          shrinkWrap: true,
                                          itemCount: controller.searchedBikeModel.bikes.length,
                                          itemBuilder: (context, index) {

                                            var item = controller.searchedBikeModel.bikes[index];
                                            return MyBikeItem(item: item,isGridView: false,);


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
                Center(child: Text("ComingSoon".tr.toUpperCase(), style: kTextStyle16,))

                // Commented the below code due to coming soon option
                // Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                //   children: [
                //     Card(
                //         margin: kScreenPadding,
                //         child: Padding(
                //           padding: kScreenPadding,
                //           child: Column(children: [
                //             Text("LookingToSellOutYourNumberPlate".tr,
                //               style: kTextStyle16,textAlign: TextAlign.center,),
                //             kVerticalSpace12,
                //             ButtonWidget(
                //                 text: "PostAnAd",
                //                 onPressed: () {
                //                   if(UserSession.isLoggedIn!){
                //                     Get.toNamed(Routes.newAdScreen);
                //                   }else{
                //                     Get.toNamed(Routes.loginScreen);
                //                   }
                //                 })
                //           ]),
                //         )),
                //     Padding(
                //       padding: kScreenPadding.copyWith(top: 0),
                //       child:Row(
                //         children: [
                //           Expanded(
                //             child: GetBuilder<MyNumberPlateController>(
                //                 id: "search",
                //                 builder: (controller)=>
                //                     CupertinoSearchTextField(
                //
                //                       onChanged: (val){
                //                         controller.searchText=val.trim();
                //                       },placeholder: "Search".tr,onSubmitted: (val){
                //                       controller.page(1);
                //                       controller.searchText=val.trim();
                //                       controller.getNumberPlates();
                //                     },
                //                       controller: TextEditingController(text: controller.searchText),
                //                       onSuffixTap: (){
                //                         controller.page(1);
                //                         controller.loadMore(true);
                //                         controller.searchText="";
                //                         controller.update(["search"]);
                //                         controller.getNumberPlates();
                //                       },)
                //             ),
                //           ),
                //           kHorizontalSpace8,
                //           GetBuilder<MyNumberPlateController>(
                //               builder: (controller)  {
                //                 return IconButtonWidget(color: kAccentColor,
                //                   onPressed: (){
                //                     controller.isGridView=!controller.isGridView;
                //                     controller.update();
                //                   },icon:controller.isGridView?
                //                   MaterialCommunityIcons.view_list: MaterialCommunityIcons.view_grid
                //                   ,);
                //               }
                //           ),
                //         ],
                //       ),
                //     ),
                //
                //     Expanded(
                //       child: GetBuilder<MyNumberPlateController>(
                //         builder: (controller)=>
                //             NotificationListener<ScrollEndNotification>(
                //               onNotification: (notification) {
                //                 if (notification.metrics.atEdge &&
                //                     notification.metrics.pixels ==
                //                         notification.metrics.maxScrollExtent &&
                //                     controller.loadMore.value) {
                //                   controller.page.value+=1;
                //                   controller.getNumberPlates();
                //                 }
                //                 return true;
                //               },
                //               child: Column(
                //                 children: [
                //                   Expanded(
                //                       child: controller
                //                           .status.value ==
                //                           Status.loading
                //                           ? CircularLoader():
                //
                //                       controller.status.value ==
                //                           Status.error
                //                           ? Text("$kCouldNotLoadData".tr,
                //                           style: kTextStyle16)
                //                           :
                //
                //                       controller.searchedNumberPlateModel.numberPlates.isEmpty?
                //                       Text("NoDataFound".tr,
                //                           style: kTextStyle16):
                //                       controller.isGridView?  GridView.builder(
                //                           padding: EdgeInsets.only(bottom: 50.h),
                //                           shrinkWrap: true,
                //                           itemCount: controller.searchedNumberPlateModel.numberPlates.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,
                //                           childAspectRatio: 0.45, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
                //                           itemBuilder: (context, index) {
                //
                //                             var item = controller.searchedNumberPlateModel.numberPlates[index];
                //                             return MyNumberPlateItem(item: item,);
                //
                //
                //                           }):
                //
                //                       ListView.builder(
                //                           padding: EdgeInsets.only(bottom: 50.h),
                //                           shrinkWrap: true,
                //                           itemCount: controller.searchedNumberPlateModel.numberPlates.length,
                //                           itemBuilder: (context, index) {
                //
                //                             var item = controller.searchedNumberPlateModel.numberPlates[index];
                //                             return MyNumberPlateItem(item: item,isGridView: false,);
                //
                //
                //                           })
                //
                //
                //                   ),
                //                   controller.isLoadingMore.value?
                //                   Padding(
                //                     padding:  EdgeInsets.only(bottom: 50.h),
                //                     child: CircularLoader(),
                //                   ):Container()
                //                 ],
                //               ),
                //             ),
                //
                //       ),
                //     )
                //   ],
                // ),


      ])
          )],
      ),
    );
  }
}

class MyCarItem extends StatelessWidget {
  const MyCarItem({
    super.key,
    required this.item,
    this.isGridView = true,
  });

  final Car item;
  final bool isGridView;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.viewMyCarScreen, arguments: item);
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
              flex: 6,
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
                              color: kWhiteColor,
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
              flex: 7,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      "${item.brandName} ${item.modelName} ${item.modelYear}",
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
                          color: const Color(0xFF4A90E2),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            item.cityName ?? item.location ?? '',
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

                    // Type
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.car,
                          size: 12.w,
                          color: const Color(0xFF4A90E2),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            "${item.type}",
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

                    // Mileage
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.gauge,
                          size: 12.w,
                          color: const Color(0xFF4A90E2),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "${item.mileage} KM",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // Posted Time
                    Text(
                      format(
                        item.createdAt!,
                        locale: gSelectedLocale?.locale?.languageCode,
                      ),
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
                        "${item.brandName} ${item.modelName} ${item.modelYear}",
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
                            color: const Color(0xFF4A90E2),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              item.cityName ?? item.location ?? '',
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

                      // Type
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.car,
                            size: 12.w,
                            color: const Color(0xFF4A90E2),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              "${item.type}",
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

                      // Mileage + Year
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.gauge,
                            size: 12.w,
                            color: const Color(0xFF4A90E2),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "${item.mileage} KM",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),

                      // Time
                      Text(
                        format(
                          item.createdAt!,
                          locale: gSelectedLocale?.locale?.languageCode,
                        ),
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


class MyBikeItem extends StatelessWidget {
  const MyBikeItem({
    Key? key,
    required this.item,
    this.isGridView = true,
  }) : super(key: key);

  final Bike item;
  final bool isGridView;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.viewMyBikeScreen, arguments: item);
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
              flex: 6,
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
                              color: kWhiteColor,
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
              flex: 7,
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      "${item.brandName} ${item.modelName} ${item.modelYear}",
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
                          color: const Color(0xFF4A90E2),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            "${item.cityName}",
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

                    // Type
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.motorcycle,
                          size: 12.w,
                          color: const Color(0xFF4A90E2),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            "${item.type}",
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

                    // Mileage
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.gauge,
                          size: 12.w,
                          color: const Color(0xFF4A90E2),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "${item.mileage} KM",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // Posted Time
                    Text(
                      format(
                        item.createdAt!,
                        locale: gSelectedLocale?.locale?.languageCode,
                      ),
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
                        "${item.brandName} ${item.modelName} ${item.modelYear}",
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
                            color: const Color(0xFF4A90E2),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              "${item.cityName}",
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

                      // Type
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.motorcycle,
                            size: 12.w,
                            color: const Color(0xFF4A90E2),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              "${item.type}",
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

                      // Mileage
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.gauge,
                            size: 12.w,
                            color: const Color(0xFF4A90E2),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "${item.mileage} KM",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),

                      // Time
                      Text(
                        format(
                          item.createdAt!,
                          locale: gSelectedLocale?.locale?.languageCode,
                        ),
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


class MyNumberPlateItem extends StatelessWidget {
  const MyNumberPlateItem({
    Key? key,
    required this.item,  this.isGridView=true
  }) : super(key: key);

  final NumberPlate item;

  final bool isGridView;
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: () {
        Get.toNamed(
            Routes
                .viewMyNumberPlateScreen,
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
                          .scaleDown,
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

                        Text("${item.number}",
                          maxLines: 1,
                          style: kTextStyle16.copyWith(color: kAccentColor),),
                        kVerticalSpace4,

                        Row(
                          children: [   Icon(  MaterialCommunityIcons.map_marker_outline,    size: 16.sp,
                            color: kLightBlueColor,),
                            Expanded(
                              child: Text(
                                "${item.cityName}",
                                maxLines:
                                1,
                                style:
                                TextStyle(color: kGreyColor,    height: 1.3, fontSize: 12.sp),
                              ),
                            ),
                          ],
                        ),
                        kVerticalSpace4,




                        Text(
                          "${format(item.createdAt!,locale: gSelectedLocale?.locale?.languageCode)}",textDirection: TextDirection.ltr, maxLines:
                        1,
                          style: TextStyle(color: kGreyColor,     height: 1.3,fontSize: 12.sp),
                        )
                        ,
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(getPrice(item.price),
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
        Container(
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
                Expanded(flex: 3,
                    child:
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [


                          Text("${item.number}",
                            maxLines: 1,
                            style: kTextStyle16.copyWith(color: kAccentColor),),
                          kVerticalSpace4,

                          Row(
                            children: [   Icon(  MaterialCommunityIcons.map_marker_outline,    size: 16.sp,
                              color: kLightBlueColor,),
                              Expanded(
                                child: Text(
                                  "${item.cityName}",
                                  maxLines:
                                  1,
                                  style:
                                  TextStyle(color: kGreyColor,    height: 1.3, fontSize: 12.sp),
                                ),
                              ),
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
                            child: Text(getPrice(item.price), textDirection: TextDirection.ltr,
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
