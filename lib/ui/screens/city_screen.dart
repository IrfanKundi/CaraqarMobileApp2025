import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/city_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/models/city_model.dart';
import 'package:careqar/ui/screens/home_screen.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class CityScreen extends GetView<CityController> {


   late ForeignerCity city;
  CityScreen({Key? key}) : super(key: key){
    city=Get.arguments;
      //controller.getCompanies();

  }
  @override
  Widget build(BuildContext context) {



    return Scaffold(backgroundColor: kWhiteColor,
      appBar:  buildAppBar(context,
          child: GetBuilder<CityController>(
        builder: (controller)  =>Text("${city.title} ${"Ads".tr} (${city.ads.length})",style: kAppBarStyle,)),
      actions: [
        Padding(
          padding:  EdgeInsetsDirectional.only(end: 16.w),
          child: GetBuilder<CityController>(
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
      body: GetBuilder<CityController>(builder: (controller)=>
          controller
              .adsStatus.value ==
              Status.loading
              ? CircularLoader():

          controller.adsStatus.value ==
              Status.error
              ? Center(
                child: Text("$kCouldNotLoadData",
                style: kTextStyle16),
              )
              :

          city.ads.isEmpty?
          Center(
            child: Text("NoDataFound".tr,
                style: kTextStyle16),
          ):
          controller.isGridView?  GridView.builder(
              padding: EdgeInsets.zero,
              physics: PageScrollPhysics(),
              shrinkWrap: true,
              itemCount:city.ads.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,
              childAspectRatio: 0.60, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
              itemBuilder: (context, index) {

                var item = city.ads[index];
                return PropertyItem(item: item,);


              }):ListView.builder(
              padding: EdgeInsets.zero,   physics: PageScrollPhysics(),
              shrinkWrap: true,
              itemCount:city.ads.length,
              itemBuilder: (context, index) {

                var item = city.ads[index];
                return PropertyItem(item: item,isGridView: false,);


              }),
      )

     );
  }
}
