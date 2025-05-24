import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/remove_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';

class NewAdScreen extends GetView<VehicleController> {
  const NewAdScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: buildAppBar(context,title: "WhatDoYouWantToAdvertise"),
      body:  RemoveSplash(
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: (){
                    controller.reset();
                    controller.vehicleType=VehicleType.Car;
                  Get.toNamed(Routes.chooseAdTypeScreen);

                  },
                  child: Image.asset("assets/images/car.png",
                    fit: BoxFit.scaleDown,
                    width: 1.sw,
                    height: 0.2.sh,
                  ),
                ),
                InkWell(
                  onTap: (){ controller.reset();
                    controller.vehicleType=VehicleType.Bike;
                    Get.toNamed(Routes.chooseAdTypeScreen);
                  },
                  child: Image.asset("assets/images/bike.png",
                    fit: BoxFit.scaleDown,
                    width: 1.sw,
                    height: 0.2.sh,
                  ),
                ),
                InkWell(
                  onTap: (){ controller.reset();
                    controller.vehicleType=VehicleType.NumberPlate;
                    Get.toNamed(Routes.chooseAdTypeScreen);
                  },
                  child: Image.asset("assets/images/numberplate.png",
                    fit: BoxFit.scaleDown,
                    width: 1.sw,
                    height: 0.2.sh,
                  ),
                ),
              ],
              ),
        ),
      ),
    );
  }
}
