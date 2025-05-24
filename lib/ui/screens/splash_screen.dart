import 'package:careqar/constants/colors.dart';
import 'package:careqar/controllers/content_controller.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../user_session.dart';

class SplashScreen extends StatelessWidget{
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () async {
      if(gIsVehicle){
        if (UserSession.firstLaunch) {
          Get.offNamed(Routes.introScreen);
        }
        else {
          if (UserSession.isLoggedIn!) {
            Get.offNamed(Routes.navigationScreen);
          } else {
            Get.offNamed(Routes.chooseSignInScreen);
          }
        }
      }else{
        Get.offNamed(Routes.currentLocationScreen);
      }

    });

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Image.file(
        Get.put(ContentController()).splashContent!.files.last,
        width: 1.sw,
        height: 1.sh,
      ),
    );
  }


}
