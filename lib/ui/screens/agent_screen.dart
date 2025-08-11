import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/agent_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/ui/screens/home_screen.dart';
import 'package:careqar/ui/screens/vehicle/bikes_screen.dart';
import 'package:careqar/ui/screens/vehicle/number_plates_screen.dart';
import 'package:careqar/ui/screens/vehicle/vehicle_home_screen.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class AgentScreen extends GetView<AgentController> {

  late AgentController controller;
  AgentScreen({Key? key}) : super(key: key){
    initData();
    //controller.getCompanies();
  }

  void initData() {
    controller =Get.put<AgentController>(AgentController());

    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {
      int agentId;
      agentId=Get.arguments;
      if(Get.parameters["type"]=="Real State"){
        controller.getAds(agentId,Get.parameters["agentAds"]=="1");
      }else if(Get.parameters["type"]=="Car"){
        controller.getCars(agentId,Get.parameters["agentAds"]=="1");
      }else if(Get.parameters["type"]=="Bike"){
        controller.getBikes(agentId,Get.parameters["agentAds"]=="1");
      }else{
        controller.getNumberPlates(agentId,Get.parameters["agentAds"]=="1");
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return    Get.parameters["type"]=="Real State"?
        GetBuilder<AgentController>(builder: (controller)=>
            Scaffold(backgroundColor: kWhiteColor,
              appBar:  buildAppBar(context,
                  child: GetBuilder<AgentController>(
                      builder: (controller)  =>Text("${"Ads".tr} (${controller.ads.length})",style: kAppBarStyle,)),
                  actions: [
                    Padding(
                      padding:  EdgeInsetsDirectional.only(end: 16.w),
                      child: GetBuilder<AgentController>(
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
                    )]
              ),
              body:
              controller
                  .adsStatus.value ==
                  Status.loading
                  ? CircularLoader():

              controller.adsStatus.value ==
                  Status.error
                  ? Center(
                child: Text("$kCouldNotLoadData".tr,
                    style: kTextStyle16),
              )
                  :

              controller.ads.isEmpty?
              Center(
                child: Text("NoDataFound".tr,
                    style: kTextStyle16),
              ):
              controller.isGridView?  GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: PageScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:controller.ads.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,
                  childAspectRatio: 0.45, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
                  itemBuilder: (context, index) {

                    var item = controller.ads[index];
                    return PropertyItem(item: item,);


                  }):    ListView.builder(
                  padding: EdgeInsets.zero,   physics: PageScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:controller.ads.length,
                  itemBuilder: (context, index) {

                    var item = controller.ads[index];
                    return PropertyItem(item: item,isGridView: false,);


                  }),
        )):
        Get.parameters["type"]=="Car"?
        GetBuilder<AgentController>(builder: (controller)=>
            Scaffold(backgroundColor: kWhiteColor,
              appBar:  buildAppBar(context,
                  child: GetBuilder<AgentController>(
                      builder: (controller)  =>Text("${"Ads".tr} (${controller.ads.length})",style: kAppBarStyle,)),
                  actions: [
                    Padding(
                      padding:  EdgeInsetsDirectional.only(end: 16.w),
                      child: GetBuilder<AgentController>(
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
                    )]
              ),
              body:  controller
                  .adsStatus.value ==
                  Status.loading
                  ? CircularLoader():

              controller.adsStatus.value ==
                  Status.error
                  ? Center(
                child: Text("$kCouldNotLoadData".tr,
                    style: kTextStyle16),
              )
                  :

              controller.cars.isEmpty?
              Center(
                child: Text("NoDataFound".tr,
                    style: kTextStyle16),
              ):
              controller.isGridView?  GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: PageScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:controller.cars.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,
                  childAspectRatio: 0.45, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
                  itemBuilder: (context, index) {

                    var item = controller.cars[index];
                    return CarItem(item: item,);


                  }):    ListView.builder(
                  padding: EdgeInsets.zero,   physics: PageScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:controller.cars.length,
                  itemBuilder: (context, index) {

                    var item = controller.cars[index];
                    return CarItem(item: item,isGridView: false,);


                  }),
        )):
        Get.parameters["type"]=="Bike"?
        GetBuilder<AgentController>(builder: (controller)=>
            Scaffold(backgroundColor: kWhiteColor,
              appBar:  buildAppBar(context,
                  child: GetBuilder<AgentController>(
                      builder: (controller)  =>Text("${"Ads".tr} (${controller.ads.length})",style: kAppBarStyle,)),
                  actions: [
                    Padding(
                      padding:  EdgeInsetsDirectional.only(end: 16.w),
                      child: GetBuilder<AgentController>(
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
                    )]
              ),
              body:    controller
                  .adsStatus.value ==
                  Status.loading
                  ? CircularLoader():

              controller.adsStatus.value ==
                  Status.error
                  ? Center(
                child: Text("$kCouldNotLoadData".tr,
                    style: kTextStyle16),
              )
                  :

              controller.bikes.isEmpty?
              Center(
                child: Text("NoDataFound".tr,
                    style: kTextStyle16),
              ):
              controller.isGridView?  GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: PageScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:controller.bikes.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,
                  childAspectRatio: 0.45, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
                  itemBuilder: (context, index) {

                    var item = controller.bikes[index];
                    return BikeItem(item: item,);


                  }):    ListView.builder(
                  padding: EdgeInsets.zero,   physics: PageScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:controller.bikes.length,
                  itemBuilder: (context, index) {

                    var item = controller.bikes[index];
                    return BikeItem(item: item,isGridView: false,);


                  }),
        )):
        GetBuilder<AgentController>(builder: (controller)=>
            Scaffold(backgroundColor: kWhiteColor,
              appBar:  buildAppBar(context,
                  child: GetBuilder<AgentController>(
                      builder: (controller)  =>Text("${"Ads".tr} (${controller.ads.length})",style: kAppBarStyle,)),
                  actions: [
                    Padding(
                      padding:  EdgeInsetsDirectional.only(end: 16.w),
                      child: GetBuilder<AgentController>(
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
                    )]
              ),
              body:   controller
                  .adsStatus.value ==
                  Status.loading
                  ? CircularLoader():

              controller.adsStatus.value ==
                  Status.error
                  ? Center(
                child: Text("$kCouldNotLoadData".tr,
                    style: kTextStyle16),
              )
                  :

              controller.numberPlates.isEmpty?
              Center(
                child: Text("NoDataFound".tr,
                    style: kTextStyle16),
              ):
              controller.isGridView?  GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: PageScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:controller.numberPlates.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,
                  childAspectRatio: 0.45, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
                  itemBuilder: (context, index) {

                    var item = controller.numberPlates[index];
                    return NumberPlateItem(item: item,);


                  }):    ListView.builder(
                  padding: EdgeInsets.zero,   physics: PageScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:controller.numberPlates.length,
                  itemBuilder: (context, index) {

                    var item = controller.numberPlates[index];
                    return NumberPlateItem(item: item,isGridView: false,);


                  }),
        ),

    );
  }
}
