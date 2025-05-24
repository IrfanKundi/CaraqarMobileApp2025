import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/city_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/location_controller.dart';
import '../../../controllers/vehicle_controller.dart';
import '../../../models/city_model.dart';

class SelectLocationScreen extends GetView<VehicleController> {
   SelectLocationScreen({Key? key}) : super(key: key){

  var locationController=Get.find<LocationController>();

  int id =  int.parse(Get.parameters["cityId"]!);
  City city= locationController.cityModel.value.cities.firstWhere((element) => element.cityId==id);
  }

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


               },
             );
           }),

     );
   }
}
