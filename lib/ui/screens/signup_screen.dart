import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/signup_controller.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/phone_number_text_field.dart';
import 'package:careqar/ui/widgets/text_button_widget.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../global_variables.dart';
import '../widgets/app_bar.dart';

class SignUpScreen extends GetView<SignUpController> {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context,title: "Profile & Setting"),

      body: Obx(()=>
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              child: Form(
                key: controller.formKey.value,
                autovalidateMode: AutovalidateMode.disabled,
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo section - removed since not in screenshot
                        SizedBox(height: 60.h),

                        // Create New Account Button
                        Container(
                          width: double.infinity,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: kLableColor, // Green color from screenshot
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15.w), // optional padding
                                  child: FaIcon(
                                    FontAwesomeIcons.arrowRight,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                                 Text(
                                  "Create New Account",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        kVerticalSpace24,

                        // Email Field with Icon
                        Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50.r),
                            border: Border.all(color: Colors.grey.shade300, width: 1),
                          ),
                          child: TextFormField(
                            initialValue: controller.email,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined, color: Colors.black),
                              hintText: "Enter email",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                            ),
                            onChanged: (String? val){
                              controller.email=val!.trim();
                            },
                            validator: (String? val){
                              val=val!.trim();
                              if(val.isEmpty) {
                                return null;
                              } else if(!RegExp(kEmailRegExp).hasMatch(val))
                              {
                                return kInvalidEmailMsg.tr;
                              }
                              else
                              {
                                return null;
                              }
                            },
                          ),
                        ),

                        kVerticalSpace12,

                        // Phone Number Field with Icon
                        Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50.r),
                            border: Border.all(color: Colors.grey.shade300, width: 1),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 16.w),
                                child: Icon(Icons.phone_outlined, color: Colors.black),
                              ),
                              Expanded(
                                child: PhoneNumberTextField(
                                  value: controller.phoneNumber,
                                  labelText: null,
                                  hintText: "Phone number",
                                  onChanged: (PhoneNumber val){
                                    controller.phoneNumber=val;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        kVerticalSpace12,

                        // Username Field with Icon (New field as shown in screenshot)
                        Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50.r),
                            border: Border.all(color: Colors.grey.shade300, width: 1),
                          ),
                          child: TextFormField(
                            // Empty field as requested
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person_outline, color: Colors.black),
                              hintText: "Enter username",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                            ),
                            onChanged: (String? val){
                              // Empty logic as requested - you can add controller logic here later
                            },
                            validator: (String? val){
                              // Empty validation as requested
                              return null;
                            },
                          ),
                        ),

                        kVerticalSpace12,

                        // Password Field with Icon (Note: There's no Full Name field visible in the screenshot)
                        Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50.r),
                            border: Border.all(color: Colors.grey.shade300, width: 1),
                          ),
                          child: TextFormField(
                            initialValue: controller.password,
                            obscureText: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline, color: Colors.black),
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 14.sp),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                            ),
                            onChanged: (String? val){
                              controller.password=val!.trim();
                            },
                            validator: (String? val){
                              val=val!.trim();
                              if(val.isEmpty) {
                                return kRequiredMsg.tr;
                              } else if(val.trim().length<8)
                              {
                                return kPasswordLimitMsg.tr;
                              }
                              else
                              {
                                return null;
                              }
                            },
                          ),
                        ),

                        kVerticalSpace16,

                        // Sign Up Button
                        Container(
                          width: double.infinity,
                          height: 50.h,
                          child: ElevatedButton(
                            onPressed: controller.register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.r),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 1.w,
                                width: 50.w,
                                color: Colors.grey.shade300,
                              ),
                              Text(
                                " Or login with ",
                                style: TextStyle(
                                    color: kGreyColor,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                              Container(
                                height: 1.w,
                                width: 50.w,
                                color: Colors.grey.shade300,
                              ),
                            ],
                          ),
                        ),

                        // Sign in with Google Button
                        Container(
                          width: double.infinity,
                          height: 50.h,
                          margin: EdgeInsets.only(bottom: 12.h),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Add Google sign in logic here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.r),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            icon: Container(
                              width: 20.w,
                              height: 20.w,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  "G",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            label: Text(
                              "Sign in with Google",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        // Sign in with Facebook Button
                        Container(
                          width: double.infinity,
                          height: 50.h,
                          margin: EdgeInsets.only(bottom: 12.h),
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Add Facebook sign in logic here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.r),
                                side: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            icon: Container(
                              width: 20.w,
                              height: 20.w,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade700,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  "f",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            label: Text(
                              "Sign in with Facebook",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),

                        // Original Sign In Button (hidden/removed as not in screenshot)
                        // ButtonWidget(text: "SignIn", onPressed: () {
                        //   Get.offNamed(Routes.loginScreen);
                        // },color: kPrimaryColor,),

                        SizedBox(height: 20.h),
                      ],
                    ),
                    TextButtonWidget(text: "SkipNow",color: kGreyColor,onPressed: (){
                      if(Get.previousRoute==Routes.navigationScreen){
                        Get.back();
                      }else{
                        Get.offNamed(Routes.navigationScreen);
                      }

                    },)
                  ],
                ),
              ),
            ),
          ),
      ),
    );
  }
}
