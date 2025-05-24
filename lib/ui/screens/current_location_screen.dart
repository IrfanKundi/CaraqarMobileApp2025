
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/location_controller.dart';
import 'package:flutter/material.dart';
import 'package:careqar/constants/colors.dart';
import 'package:careqar/routes.dart';
import 'package:get/get.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/user_session.dart';

import '../../global_variables.dart';

class CurrentLocationScreen extends StatelessWidget{
  const CurrentLocationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var locationController=Get.put(LocationController());

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: SizedBox(
          height:1.sh,
          width: 1.sw,
          child:  SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Image.asset(
                      gSelectedLocale!.langCode==0? "assets/images/logo-en.png":"assets/images/logo-ar.png",
                      width: 220.w,
                      height: 220.w,
                    ),
                    Image.asset(
                      "assets/images/location-screen.png",
                      width: 200.w,
                      height: 200.w,
                    ),
                  ],
                ),


                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("CurrentLocationScreenHeading".tr,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20.sp),),
                      kVerticalSpace12,
                      Text("CurrentLocationScreenDescription".tr,textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14.sp,color: kGreyColor),),
                      kVerticalSpace24,
                      ButtonWidget(text: "UseCurrentLocation", onPressed: ()async{
                        //gCurrentLocation=LatLng(25.387255,51.523644);
                        await locationController.determinePosition();

                          if (UserSession.firstLaunch) {
                            Get.offNamed(Routes.introScreen);
                          } else {
                            if (UserSession.isLoggedIn!) {
                              Get.offNamed(Routes.navigationScreen);
                            } else {
                              Get.offNamed(Routes.chooseSignInScreen);
                            }
                          }
                      },icon: CupertinoIcons.location,),



                    ],
                  ),
                ),

                Container(  margin: kVerticalScreenPadding,
                  height: 3.w,
                  width: 70.w,

                  decoration: BoxDecoration(  color: kPrimaryColor,
                      borderRadius: kBorderRadius30
                  ),
                )


              ],
            ),
          ),
        ),
      ),
    );
  }

}
