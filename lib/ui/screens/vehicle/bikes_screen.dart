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
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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

                  controller.isGridView
                      ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.bikes.value.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 300.h, // fixed height for consistent card size
                        crossAxisSpacing: 0.w,
                        mainAxisSpacing: 0.w,
                      ),
                      itemBuilder: (context, index) {
                        var item = controller.bikes.value[index];
                        return BikeItem(item: item, isGridView: true);
                      },
                    ),
                  ):
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
    this.isGridView = true,
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
        Get.toNamed(Routes.viewBikeScreen, arguments: widget.item)?.then((_) {
          if (mounted) setState(() {});
        });
      },
      child: Card(
        margin: widget.isGridView
            ? EdgeInsets.all(5.w)
            : EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        elevation: 0,
        child: widget.isGridView
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
                        widget.item.images.first,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    // NEW BADGE
                    if (DateTime.now()
                        .difference(widget.item.createdAt!)
                        .inDays <
                        2)
                      Positioned(
                        top: 8.h,
                        left: 8.w,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            border: Border.all(
                                color: Colors.white, width: 1.5),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            "New".tr,
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    // IMAGE COUNT
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
                              Icons.photo_library_outlined,
                              color: Colors.white,
                              size: 12.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "${widget.item.images.length}",
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
                    // TITLE + FAVORITE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "${widget.item.brandName} ${widget.item.modelName}",
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E3A5F),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          height: 24.w,
                          width: 24.w,
                          child: IconButtonWidget(
                            icon: widget.item.favoriteId! > 0
                                ? MaterialCommunityIcons.heart
                                : MaterialCommunityIcons.heart_outline,
                            color: widget.item.favoriteId! > 0
                                ? kRedColor
                                : Colors.black54,
                            width: 16.w,
                            onPressed: () async {
                              var controller =
                              Get.put(FavoriteController());
                              if (widget.item.favoriteId! > 0) {
                                if (await controller.deleteFavorite(
                                    bike: widget.item)) {
                                  setState(() {});
                                }
                              } else {
                                if (await controller.addToFavorites(
                                    bike: widget.item)) {
                                  setState(() {});
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // YEAR + TYPE
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.calendar,
                          size: 12.w,
                          color: kIconColor,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "${widget.item.modelYear}",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11.sp,
                          ),
                        ),
                        SizedBox(width: 10.w),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.gasPump,
                          size: 12.w,
                          color: kIconColor,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "${widget.item.fuelType}",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    // LOCATION
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.locationDot,
                          size: 12.w,
                          color: kIconColor,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "${widget.item.cityName}",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // MILEAGE
                    Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.gauge,
                          size: 12.w,
                          color: kIconColor,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "${widget.item.mileage} KM",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),

                    // TIME + VIEWS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          format(widget.item.createdAt!,
                              locale: gSelectedLocale
                                  ?.locale
                                  ?.languageCode),
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 10.sp,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
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
                                "${widget.item.clicks}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),

                    // PRICE
                    Text(
                      getPrice(widget.item.price!),
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
                        color: Colors.black54, width: 1),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.r),
                        child: ImageWidget(
                          widget.item.images.first,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      // NEW BADGE
                      if (DateTime.now()
                          .difference(widget.item.createdAt!)
                          .inDays <
                          2)
                        Positioned(
                          top: 8.h,
                          left: 8.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50),
                              border: Border.all(
                                  color: Colors.white, width: 1.5),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              "New".tr,
                              style: GoogleFonts.poppins(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      // IMAGE COUNT
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
                                Icons.photo_library_outlined,
                                color: Colors.white,
                                size: 12.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "${widget.item.images.length}",
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
                      // TITLE + FAVORITE
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${widget.item.brandName} ${widget.item.modelName}",
                              style: TextStyle(
                                color: const Color(0xFF1E3A5F),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 20.w,
                            width: 20.w,
                            child: IconButtonWidget(
                              icon: widget.item.favoriteId! > 0
                                  ? MaterialCommunityIcons.heart
                                  : MaterialCommunityIcons.heart_outline,
                              color: widget.item.favoriteId! > 0
                                  ? kRedColor
                                  : Colors.black54,
                              width: 14.w,
                              onPressed: () async {
                                var controller =
                                Get.put(FavoriteController());
                                if (widget.item.favoriteId! > 0) {
                                  if (await controller.deleteFavorite(
                                      bike: widget.item)) {
                                    setState(() {});
                                  }
                                } else {
                                  if (await controller.addToFavorites(
                                      bike: widget.item)) {
                                    setState(() {});
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      // LOCATION + TYPE
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
                              "${widget.item.cityName}",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          FaIcon(
                            FontAwesomeIcons.motorcycle,
                            size: 12.w,
                            color: kIconColor,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              "${widget.item.type}",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5.h),

                      // MILEAGE + YEAR
                      Row(
                        children: [
                          FaIcon(
                            FontAwesomeIcons.gauge,
                            size: 12.w,
                            color: kIconColor,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "${widget.item.mileage} KM",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          FaIcon(
                            FontAwesomeIcons.calendar,
                            size: 12.w,
                            color: kIconColor,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "${widget.item.modelYear}",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),

                      // TIME + VIEWS
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            format(widget.item.createdAt!,
                                locale: gSelectedLocale
                                    ?.locale
                                    ?.languageCode),
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 11.sp,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
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
                                  "${widget.item.clicks}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),

                      // PRICE
                      Text(
                        getPrice(widget.item.price!),
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

