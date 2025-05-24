
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:careqar/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:careqar/constants/colors.dart';
import 'package:careqar/routes.dart';
import 'package:get/get.dart';
import 'package:careqar/user_session.dart';

class IntroScreen extends StatefulWidget{
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {


  @override
  Widget build(BuildContext context) {

    final pageDecoration = PageDecoration(
      titlePadding: EdgeInsets.zero,
      imageFlex: 2,
      titleTextStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
      ),
      imagePadding: kHorizontalScreenPadding,
      bodyTextStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
      bodyPadding:  EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 16.w),
      pageColor: Colors.white,
    );

    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Column(
        children: [
          Expanded(
            child: IntroductionScreen(

              pages: [
                PageViewModel(
                  title: "Intro1Heading".tr,
                  body: "Intro1Description".tr,
                  image: Image.asset(
                    "assets/images/intro-1.png",
                    width: 1.sw,
                    fit: BoxFit.fitWidth,
                  ),
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  title: "Intro2Heading".tr,
                  body: "Intro2Description".tr,
                  image: Image.asset(
                    "assets/images/intro-2.png",
                    width: 1.sw,
                    fit: BoxFit.fitWidth,
                  ),
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  title: "Intro3Heading".tr,
                  body: "Intro3Description".tr,
                  image: Image.asset(
                    "assets/images/intro-3.png",
                    width: 1.sw,
                    fit: BoxFit.fitWidth,
                  ),
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  title: "Intro4Heading".tr,
                  body: "Intro4Description".tr,
                  image: Image.asset(
                    "assets/images/intro-4.png",
                    width: 1.sw,
                    fit: BoxFit.fitWidth,
                  ),
                  decoration: pageDecoration,
                ),
                PageViewModel(
                  title: "Intro5Heading".tr,
                  body: "Intro5Description".tr,
                  image: Image.asset(
                    "assets/images/intro-5.png",
                    width: 1.sw,
                    fit: BoxFit.fitWidth,
                  ),
                  decoration: pageDecoration,
                ),
              ],
              onDone: () {
                UserSession.changeFirstLaunch(false);
                if(UserSession.isLoggedIn!){
                  Get.offNamed(Routes.navigationScreen);
                }else{
                  Get.offNamed(Routes.chooseSignInScreen);
                }
              },
              onSkip: () {
                UserSession.changeFirstLaunch(false);
                if(UserSession.isLoggedIn!){
                  Get.offNamed(Routes.navigationScreen);
                }else{
                  Get.offNamed(Routes.chooseSignInScreen);
                }
              },
              showSkipButton: true,
              globalBackgroundColor: kWhiteColor,
              skip: Text("Skip".tr,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      color: kAccentColor)),
              done: Text("Done".tr,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      color: kAccentColor)),
              next: Text("Next".tr,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp,
                      color: kAccentColor)),
              // done: Text("Start",
              //     style: TextStyle(
              //         fontWeight: FontWeight.w600,
              //         fontSize: 15.sp,
              //         color: kAccentColor)),
              dotsDecorator: DotsDecorator(
                  size: Size.fromRadius(3.r),
                  activeSize: Size.fromRadius(3.r),
                  activeColor: kPrimaryColor,
                  color: kGreyColor.shade300,
                  spacing: EdgeInsets.symmetric(horizontal: 5.w),
                  activeShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r))),
            ),
          ),
          Container(
            margin: kVerticalScreenPadding,
            height: 3.w,
            width: 70.w,

            decoration: BoxDecoration(  color: kPrimaryColor,
                borderRadius: kBorderRadius30
            ),
          )
        ],
      ),
    );
  }
}
