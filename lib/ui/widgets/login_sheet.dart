import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/text_button_widget.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

showLoginSheet(BuildContext context) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) =>
          const FractionallySizedBox(heightFactor: 0.9, child: LoginScreen()));
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        backgroundColor: kWhiteColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: kScreenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButtonWidget(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: MaterialCommunityIcons.close,
                  ),
                ),
                Padding(
                  padding: kScreenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "${"LoginTo".tr} $kAppTitle",
                        style: TextStyle(
                            color: kBlackColor,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w700),
                      ),
                      kVerticalSpace28,
                      const TextFieldWidget(
                        labelText: "EmailAddress",
                      ),
                      kVerticalSpace20,
                      const TextFieldWidget(
                        labelText: "Password",
                        obscureText: true,
                      ),
                      kVerticalSpace4,
                      const Align(
                          alignment: Alignment.centerRight,
                          child: TextButtonWidget(text: "ForgotPassword?")),
                      kVerticalSpace16,
                      ButtonWidget(text: "SignIn", onPressed: () {}),
                      kVerticalSpace16,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 1.w,
                            width: 50.w,
                            color: Colors.grey.shade300,
                          ),
                          Text(
                            "Or".tr,
                            style: TextStyle(
                                color: kGreyColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                            height: 1.w,
                            width: 50.w,
                            color: Colors.grey.shade300,
                          ),
                        ],
                      ),
                      kVerticalSpace16,
                      Container(
                        height: 40.h,
                        alignment: Alignment.center,
                        padding: kHorizontalScreenPadding,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade300, width: 1.w),
                          borderRadius: kBorderRadius4,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              MaterialCommunityIcons.facebook,
                              color: Colors.blue,
                            ),
                            Expanded(
                                child: Text(
                                    "ContinueWithFacebook".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: kBlackColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600),
                            ))
                          ],
                        ),
                      ),
                      kVerticalSpace16,
                      Container(
                        height: 40.h,
                        alignment: Alignment.center,
                        padding: kHorizontalScreenPadding,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.shade300, width: 1.w),
                          borderRadius: kBorderRadius4,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/google.png",
                              width: 20.w,
                              height: 20.w,
                            ),
                            Expanded(
                                child: Text(
                                    "ContinueWithGoogle".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: kBlackColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600),
                            ))
                          ],
                        ),
                      ),
                      kVerticalSpace28,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "NeedAnAccount".tr,
                            style:
                                TextStyle(color: kBlackColor, fontSize: 15.sp),
                          ),
                          TextButtonWidget(
                            text: "SignUp",
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, Routes.signUpScreen);
                            },
                          )
                        ],
                      )
                    ],
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
