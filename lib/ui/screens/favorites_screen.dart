import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/favorite_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/ui/screens/vehicle/bikes_screen.dart';
import 'package:careqar/ui/screens/vehicle/number_plates_screen.dart';
import 'package:careqar/ui/screens/vehicle/vehicle_home_screen.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/user_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

class FavoritesScreen extends StatefulWidget {
   const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> with TickerProviderStateMixin {

  late TabController tabController;
  @override
  void initState() {
    if(UserSession.isLoggedIn!){
     var controller =  Get.put(FavoriteController());
      if(gIsVehicle){
        controller.getCars();
        tabController=TabController(initialIndex: 0,length: 3,vsync: this);
        tabController.addListener(() {
          if(tabController.index==0){
            controller.getCars();
          }else if(tabController.index==1) {
            controller.getBikes();
          }else{
            controller.getNumberPlates();
          }

        });

      }else{
        controller.getProperties();
      }

    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context,title: "Favorites",  actions: [
      Padding(
      padding:  EdgeInsetsDirectional.only(end: 16.w),
      child: GetBuilder<FavoriteController>(
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
    )]),
      body:

    gIsVehicle?
    SafeArea(
      child: Column(
        children: [
          Container(
            color: kWhiteColor,
            child: TabBar(
                labelStyle: kTextStyle16,
                controller: tabController,
                tabs: [
                  Tab(text: "Car".tr,),
                  Tab(text: "Bike".tr,),
                  Tab(text: "No.Plate".tr,),
                ],dividerColor: Colors.transparent),
          ),
          Expanded(child: TabBarView(
              controller: tabController,
              children: [
                GetBuilder<FavoriteController>(
                  builder: (controller)=>
                  controller
                      .status.value ==
                      Status.loading
                      ? CircularLoader()
                      : controller.status.value == Status.error
                      ? Center(
                    child: Text("$kCouldNotLoadData".tr,
                        style: kTextStyle16),
                  )
                      : controller.cars.value
                      .isEmpty
                      ?
                  Center(child: Text("YouHaveNoFavorites".tr,style: kTextStyle16,))
                      :    controller.isGridView?  GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount:controller.cars.value.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,
                      childAspectRatio: 0.45, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
                      itemBuilder: (context, index) {

                        var item = controller.cars.value[index];
                        return CarItem(item: item,);


                      }):ListView.builder(
                      padding: EdgeInsets.zero,   physics: PageScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:controller.cars.value.length,
                      itemBuilder: (context, index) {

                        var item = controller.cars.value[index];
                        return CarItem(item: item,isGridView: false,);


                      }),

                ),
                GetBuilder<FavoriteController>(
                  builder: (controller)=>
                  controller
                      .status.value ==
                      Status.loading
                      ? CircularLoader()
                      : controller.status.value == Status.error
                      ? Center(
                    child: Text("$kCouldNotLoadData".tr,
                        style: kTextStyle16),
                  )
                      : controller.bikes.value
                      .isEmpty
                      ?
                  Center(child: Text("YouHaveNoFavorites".tr,style: kTextStyle16,))
                      :    controller.isGridView?  GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount:controller.bikes.value.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,
                      childAspectRatio: 0.45, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
                      itemBuilder: (context, index) {

                        var item = controller.bikes.value[index];
                        return BikeItem(item: item,);


                      }):ListView.builder(
                      padding: EdgeInsets.zero,   physics: PageScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:controller.bikes.value.length,
                      itemBuilder: (context, index) {

                        var item = controller.bikes.value[index];
                        return BikeItem(item: item,isGridView: false,);


                      }),

                ),
                GetBuilder<FavoriteController>(
                  builder: (controller)=>
                  controller
                      .status.value ==
                      Status.loading
                      ? CircularLoader()
                      : controller.status.value == Status.error
                      ? Center(
                    child: Text("$kCouldNotLoadData".tr,
                        style: kTextStyle16),
                  )
                      : controller.numberPlates.value
                      .isEmpty
                      ?
                  Center(child: Text("YouHaveNoFavorites".tr,style: kTextStyle16,))
                      :    controller.isGridView?  GridView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount:controller.numberPlates.value.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,
                      childAspectRatio: 0.45, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
                      itemBuilder: (context, index) {

                        var item = controller.numberPlates.value[index];
                        return NumberPlateItem(item: item,);


                      }):ListView.builder(
                      padding: EdgeInsets.zero,   physics: PageScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:controller.numberPlates.value.length,
                      itemBuilder: (context, index) {

                        var item = controller.numberPlates.value[index];
                        return NumberPlateItem(item: item,isGridView: false,);


                      }),

                )


              ])
          )],
      ),
    )

   :
      GetBuilder<FavoriteController>(
        builder: (controller)=>
        controller
            .status.value ==
            Status.loading
            ? CircularLoader()
            : controller.status.value == Status.error
            ? Center(
              child: Text("$kCouldNotLoadData",
              style: kTextStyle16),
            )
            : controller.properties.value
            .isEmpty
            ?
        Center(child: Text("YouHaveNoFavorites".tr,style: kTextStyle16,))
                :    controller.isGridView?  GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount:controller.properties.value.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,
            childAspectRatio: 0.65, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
            itemBuilder: (context, index) {

              var item = controller.properties.value[index];
              return PropertyItem(item: item,);


            }):ListView.builder(
    padding: EdgeInsets.zero,   physics: PageScrollPhysics(),
    shrinkWrap: true,
    itemCount:controller.properties.value.length,
    itemBuilder: (context, index) {

    var item = controller.properties.value[index];
    return PropertyItem(item: item,isGridView: false,);


    }),

      ),
      );
  }
}
