import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/city_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChooseForeignerCityScreen extends StatelessWidget {
  const ChooseForeignerCityScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: buildAppBar(context,title: "SelectCity"),
      body:  SafeArea(
        child:
        GetBuilder<CityController>(builder:(controller)=>
        controller.status.value == Status.loading
            ? CircularLoader():

        controller.status.value ==
            Status.error
            ? Center(
          child: Text(kCouldNotLoadData.tr,
              style: kTextStyle16),
        )
            :

        controller.foreignerCities.isEmpty?
        Center(
          child: Text("NoDataFound".tr,
              style: kTextStyle16),
        ):
        GridView.builder(
            physics: const PageScrollPhysics(),
            shrinkWrap: true,
            padding: kScreenPadding.copyWith(top: 0),
            itemCount: controller.foreignerCities.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
            childAspectRatio: 1.5, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
            itemBuilder: (context, index) {

              var item = controller.foreignerCities[index];
              return InkWell(
                onTap: (){

                  controller.getAds(item);
                  Get.toNamed(Routes.cityScreen,arguments: item);
                },
                child: Card(
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  child: Padding(
                    padding:  EdgeInsets.all(8.w),
                    child: Center(
                      child: Text(
                        "${item.title}".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: kTextStyle14,
                      ),
                    ),
                  ),
                ),
              );


            }),
        ),
      ),
    );
  }
}
