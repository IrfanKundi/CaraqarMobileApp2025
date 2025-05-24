import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/location_controller.dart';
import 'package:careqar/models/city_model.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SearchLocationScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    var controller=Get.find<LocationController>();

    int id =  int.parse(Get.parameters["cityId"]!);
    City city= controller.cityModel.value.cities.firstWhere((element) => element.cityId==id);
    return Scaffold(
      appBar: buildAppBar(context,title: "SearchLocation".tr),
      body:
          ListView.separated(
            padding: kScreenPadding,
              shrinkWrap: true,
              separatorBuilder: (context,index){
                return Divider();
              },
              itemCount: city.locations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    "${city.locations[index].title}",
                    style: kTextStyle14,
                  ),
                  onTap: () {

                    Get.back(result:city.locations[index]);

                  },
                );
              }),


          // Padding(
          //   padding: kScreenPadding,
          //   child: Column(
          //     children: [
          //       SearchLocationField(
          //       ),
          //       kHorizontalSpace16,
          //       Expanded(
          //         child: controller.status.value == Status.loading?
          //             CircularLoader():
          //
          //         controller.status.value == Status.error?
          //
          //         Text("Couldn't search places",style: kTextStyle16,):
          //
          //        controller.searchPlaceModel.value.places.isEmpty?
          //
          //        Text("No places found",style: kTextStyle16,):
          //        ListView.separated(
          //             shrinkWrap: true,
          //             separatorBuilder: (context,index){
          //               return Divider();
          //             },
          //             itemCount: controller.searchPlaceModel.value.places.length,
          //             itemBuilder: (context, index) {
          //               return ListTile(
          //                 contentPadding: EdgeInsets.zero,
          //                 title: Text(
          //                   "${controller.searchPlaceModel.value.places[index].description}",
          //                   style: kTextStyle14,
          //                 ),
          //                 onTap: () {
          //
          //                   Get.back(result: controller.searchPlaceModel.value.places[index].description);
          //
          //                     },
          //               );
          //             }),
          //       )
          //     ],
          //   ),
          // ),
    );
  }
}
