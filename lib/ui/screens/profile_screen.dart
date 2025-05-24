import 'dart:io';

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/auth_controller.dart';
import 'package:careqar/controllers/password_controller.dart';
import 'package:careqar/controllers/profile_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:careqar/ui/widgets/text_button_widget.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:careqar/user_session.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';

import '../widgets/crop.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authController=Get.find<AuthController>();
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        body: Obx(()=> SafeArea(
          child: SingleChildScrollView(
            padding: kScreenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
            GestureDetector(
            onTap: (){
      Get.back();
          },
            child: Icon(
              MaterialCommunityIcons.arrow_left,
            ),
          ),
                    kHorizontalSpace12,
                    Expanded(
                      child: Text(
                        "Profile".tr,
                        style: TextStyle(
                            color: kBlackColor,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                kVerticalSpace16,
              authController.authState.value==AuthState.authorized?

              GetBuilder<ProfileController>(
                id: "profile",
                builder: (controller)=>  Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${controller.user.value.firstName}",
                          style: TextStyle(
                              color: kBlackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text(
                              "${controller.user.value.phoneNumber==null?controller.user.value.email:
                              "${controller.user.value.phoneNumber?.dialCode} ${controller.user.value.phoneNumber?.phoneNumber}"}",
                              style: TextStyle(
                                  color: kAccentColor,
                                  fontSize: 14.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                         Container(
                          alignment: Alignment.center,
                          padding:controller.user.value.profileImage!=null?EdgeInsets.zero: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            borderRadius: kBorderRadius12,
                            color: kAccentColor.withOpacity(0.1),
                          ),
                          child:controller.user.value.profileImage!=null? ClipRRect(
                            borderRadius: kBorderRadius12,
                            child: ImageWidget(
                              controller.user.value.profileImage

                              ,width: 60.w,
                              fit: BoxFit.cover,
                              height: 60.w,
                            ),
                          ):
                          Icon(
                            CupertinoIcons.person,
                            size: 60.sp,
                            color: kAccentColor,
                          ),
                        ),
                          TextButtonWidget(text: "UpdateImage",onPressed: ()async {


                            FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false,
                                allowCompression: true,type: FileType.custom,
                                allowedExtensions: ["jpg","jpeg","png"]
                            );

                            if (result != null) {
                              File image = await FlutterExifRotation.rotateImage(path: result.files.first.path!);


                              // crop image

                              if (image.path != null) {
                                final croppedFile = await ImageCropper().cropImage(
                                  sourcePath: image.path,
                                  compressFormat: ImageCompressFormat.jpg,
                                  compressQuality: 100,
                                  uiSettings: [
                                    AndroidUiSettings(
                                      toolbarTitle: 'Crop Image',
                                      toolbarColor: kAccentColor,
                                      toolbarWidgetColor: Colors.white,
                                      initAspectRatio: CropAspectRatioPreset.square,
                                      lockAspectRatio: false,
                                      aspectRatioPresets: [
                                        CropAspectRatioPreset.original,
                                        CropAspectRatioPreset.square,
                                        CropAspectRatioPreset.ratio4x3,
                                        CropAspectRatioPresetCustom(),
                                      ],
                                    ),
                                    IOSUiSettings(
                                      title: 'Crop Image',
                                      aspectRatioPresets: [
                                        CropAspectRatioPreset.original,
                                        CropAspectRatioPreset.square,
                                        CropAspectRatioPreset.ratio4x3,
                                        CropAspectRatioPresetCustom(),
                                      ],
                                    ),
                                    WebUiSettings(
                                      context: context,
                                      presentStyle: WebPresentStyle.dialog,
                                      size: const CropperSize(
                                        width: 520,
                                        height: 520,
                                      ),
                                    ),
                                  ],
                                );
                                if (croppedFile != null) {
                                  controller.updateImage(File(croppedFile.path));
                                }
                              }



                              // images.value.add(File(image.path));
                              // update();
                            } else {
                              // User canceled the picker
                            }
                          },)
                    ],
                  )
                ],
              ))
                    :
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                    "Login".tr,
                            style: TextStyle(
                                color: kBlackColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp),
                          ),
                          InkWell(
                            child: Text(
                              "LogInToYourAccount".tr,
                              style: TextStyle(
                                  color: kAccentColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp),
                            ),
                            onTap: () {Get.toNamed(Routes.loginScreen);},
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        borderRadius: kBorderRadius12,
                        color: kAccentColor.withOpacity(0.1),
                      ),
                      child: Icon(
                        CupertinoIcons.person,
                        size: 40.sp,
                        color: kAccentColor,
                      ),
                    )
                  ],
                ),
                kVerticalSpace16,
                if(authController.authState.value==AuthState.authorized && (UserSession.loginWith==null || UserSession.loginWith==""))
                    Column(
                      children: [
                        Divider(),
                        // InkWell(
                        //   onTap: () {},
                        //   child: Container(
                        //     height: 40.h,
                        //     child: Row(
                        //       children: [
                        //         Icon(
                        //           Icons.language_outlined,
                        //           color: kGreyColor,
                        //           size: 22.sp,
                        //         ),
                        //         kHorizontalSpace16,
                        //         Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             Text(
                        //               "Language",
                        //               style:
                        //                   TextStyle(color: kGreyColor, fontSize: 12.sp),
                        //             ),
                        //             Text(
                        //               "English",
                        //               style: TextStyle(
                        //                   color: kAccentColor,
                        //                   fontSize: 16.sp,
                        //                   fontWeight: FontWeight.w600),
                        //             )
                        //           ],
                        //         ),
                        //         Spacer(),
                        //         Icon(MaterialCommunityIcons.chevron_right)
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // Divider(),

                        ProfileItem(
                          text: "ChangePassword",
                          icon: MaterialCommunityIcons.lock_outline,
                          onTap: (){
                            showChangePasswordSheet(context);

                          },
                        ),
                      ],
                    ),

               // Divider(),
                // ProfileItem(
                //   text: "ContactUs",
                //   icon: MaterialCommunityIcons.chat_outline,
                // ),
                // Divider(),
                // ProfileItem(
                //   text: "Feedback",
                //   icon: MaterialCommunityIcons.thumb_up_outline,
                // ),
                // Divider(),
                // ProfileItem(
                //   text: "InviteFriendsToCrimson",
                //   icon: MaterialCommunityIcons.email_open_outline,
                // ),
                // Divider(),
                // ProfileItem(
                //   text: "TermsAndPrivacyPolicy",
                //   icon: MaterialCommunityIcons.file_document_box_outline,
                // ),
                // if(authController.authState.value==AuthState.authorized)
                //   Divider(),

                if(authController.authState.value==AuthState.authorized)
                  ProfileItem(text: "LogOut",icon: MaterialCommunityIcons.logout,onTap: (){
                    authController.logout();

                  },),
                if(authController.authState.value==AuthState.authorized)
                  ProfileItem(text: "DeleteAccount",icon: MaterialCommunityIcons.delete_forever_outline,onTap: (){

                    showConfirmationDialog(title: "Warning",message: "AreYouSureToDeleteYourAccountPermanently",onConfirm: (){
                      Get.back();
                      controller.deleteAccount();
                    });


                  },),



                Divider(),
                Container(
                  height: 40.h,
                  child: Row(
                    children: [
                      Icon(
                        MaterialCommunityIcons.information_outline,
                        color: kGreyColor,
                        size: 22.sp,
                      ),
                      kHorizontalSpace16,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "AppVersion".tr,
                            style: TextStyle(color: kGreyColor, fontSize: 12.sp),
                          ),
                          Text(
                            "${controller.packageInfo?.version}",
                            style: TextStyle(
                                color: kAccentColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                kVerticalSpace16,
                authController.authState.value==AuthState.authorized?

                ButtonWidget(
                    width: double.infinity,
                    text: "EditProfile", onPressed: (){
                  Get.toNamed(Routes.editProfileScreen);
                }):
                ButtonWidget(
                    text: "Login",
                    onPressed: () {
                     Get.toNamed(Routes.loginScreen);
                    }),

              ],
            ),
          ),
        ),
      ),
    ));
  }



  void showChangePasswordSheet(BuildContext context) {



    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: kBgColor,
        barrierColor: kBlackColor.withOpacity(0.6),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r))),
        context: context,
        builder: (context) {
          var controller =  Get.put(PasswordController());
       return   SingleChildScrollView
        (
          padding:kScreenPadding.copyWith(bottom:kScreenPadding.bottom + MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 5.w,
                width: 60.w,
                decoration: BoxDecoration(
                    borderRadius: kBorderRadius30,
                    color: kGreyColor
                ),
              ),
              kVerticalSpace12,
              Text(
                "ChangePassword".tr,
                style:
                TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
              ),
              kVerticalSpace16,
              Form(  key: controller.resetFormKey.value,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFieldWidget(
                      labelText: "CurrentPassword",
                      obscureText: true,
                      text: controller.currentPassword,
                      onChanged: (String val){
                        controller.currentPassword=val.trim();
                      },
                      validator: (String? val){

                        if(val!.trim().isEmpty) {
                          return kRequiredMsg.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    kVerticalSpace12,
                    TextFieldWidget( obscureText: true,
                      labelText: "NewPassword",
                      text: controller.newPassword,
                      onChanged: (String val){
                        controller.newPassword=val.trim();
                      },
                      validator: (String? val){

                        if(val!.trim().isEmpty) {
                          return kRequiredMsg.tr;
                        } else if(val.trim().length<8) {
                          return kPasswordLimitMsg.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    kVerticalSpace12,
                    TextFieldWidget( obscureText: true,
                      labelText: "ConfirmPassword",
                      text: controller.confirmPassword,
                      onChanged: (String val){
                        controller.confirmPassword=val.trim();
                      },
                      validator: (String? val){

                        if(val!.trim().isEmpty) {
                          return kRequiredMsg.tr;
                        } else if(val.trim()!=controller.newPassword) {
                          return kPasswordNotMatchMsg.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                    kVerticalSpace16,
                    ButtonWidget(
                      text: "ChangePassword",
                      onPressed: controller.changePassword,
                    ),
                  ],
                ),
              )
            ],
          ));

    });
  }
}

class ProfileItem extends StatelessWidget {
  const ProfileItem({Key? key, this.onTap, this.text, this.icon})
      : super(key: key);

  final String? text;
  final IconData? icon;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40.h,
        child: Row(
          children: [
            Icon(
              icon,
              color: kGreyColor,
              size: 22.sp,
            ),
            kHorizontalSpace16,
            Text(
              text!.tr,
              style: TextStyle(
                  color: kBlackColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600),
            ),
            Spacer(),
            Icon(
                Get.locale?.languageCode=="ar"?MaterialCommunityIcons.chevron_left:
                MaterialCommunityIcons.chevron_right)
          ],
        ),
      ),
    );
  }
}
