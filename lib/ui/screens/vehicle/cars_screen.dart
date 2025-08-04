import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/car_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/screens/vehicle/vehicle_home_screen.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';


class CarsScreen extends GetView<CarController> {
   CarsScreen({Key? key}) : super(key: key){

  }

  @override
  Widget build(BuildContext context) {
    String? title=Get.parameters["title"];


    return Scaffold(
      appBar: buildAppBar(context,title: title??"AllCars"),
      body:  const AllCars())

    ;
  }
}

class AllCars extends StatelessWidget {
  const AllCars({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CarController>(
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
                 Get.toNamed(Routes.carFilterScreen);
                  },icon: MaterialCommunityIcons.filter_variant,),
                kHorizontalSpace8,
                IconButtonWidget(color: kAccentColor,
                  onPressed: (){
                    controller.isGridView=!controller.isGridView;
                    controller.update();
                    controller.page.value = 1;
                    controller.getFilteredCars();
                  },icon:controller.isGridView?
                  MaterialCommunityIcons.view_list: MaterialCommunityIcons.view_grid
                  ,)
              ],
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollEndNotification>(
              onNotification: (notification) {
                if (notification.metrics.atEdge &&
                    notification.metrics.pixels ==
                        notification.metrics.maxScrollExtent &&
                    controller.loadMore.value) {
                  controller.page.value += 1;
                  controller.getFilteredCars();
                }
                return true;
              },
              child: Column(
                children: [
                  Expanded(
                    child: controller.status.value == Status.loading
                        ? CircularLoader()
                        : controller.status.value == Status.error
                        ? Text(kCouldNotLoadData.tr, style: kTextStyle16)
                        : controller.cars.value.isEmpty
                        ? Text("NoDataFound".tr, style: kTextStyle16)
                        : controller.isGridView
                        ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: GridView.builder(
                                                padding: EdgeInsets.zero,
                                                // Remove shrinkWrap: true
                                                itemCount: controller.cars.value.length,
                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 300.h, // Use fixed height instead of aspectRatio
                          crossAxisSpacing: 0.w,
                          mainAxisSpacing: 0.w,
                                                ),
                                                itemBuilder: (context, index) {
                          var item = controller.cars.value[index];
                          return CarItem(item: item, isGridView: true);
                                                },
                                              ),
                        )
                        : ListView.builder(
                      padding: EdgeInsets.zero,
                      // Remove shrinkWrap: true here too
                      itemCount: controller.cars.value.length,
                      itemBuilder: (context, index) {
                        var item = controller.cars.value[index];
                        return CarItem(item: item, isGridView: false);
                      },
                    ),
                  ),
                  controller.isLoadingMore.value
                      ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.w),
                    child: CircularLoader(),
                  )
                      : Container()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
