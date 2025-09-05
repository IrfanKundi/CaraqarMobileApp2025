import 'dart:io';

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/auth_controller.dart';
import 'package:careqar/controllers/password_controller.dart';
import 'package:careqar/controllers/profile_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/screens/current_location_screen.dart';
import 'package:careqar/ui/screens/favorites_screen.dart';
import 'package:careqar/ui/screens/home_screen.dart';
import 'package:careqar/ui/screens/news_screen.dart';
import 'package:careqar/ui/screens/vehicle/my_orders_screen.dart';
import 'package:careqar/ui/screens/vehicle/vehicle_home_screen.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
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

import '../../global_variables.dart';
import '../../locale/app_localizations.dart';
import '../widgets/crop.dart';
import '../widgets/language_dropdown_widget.dart';
import 'choose_option_screen.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var authController = Get.find<AuthController>();
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        appBar: buildAppBar(context, title: "Profile".tr),
        backgroundColor: Colors.grey[50],
        body: Obx(() => SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Card
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: authController.authState.value == AuthState.authorized
                      ? GetBuilder<ProfileController>(
                    id: "profile",
                    builder: (controller) => Row(
                      children: [
                        // Profile Image with tap and edit icon
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                // Your existing image picker logic
                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                    allowMultiple: false,
                                    allowCompression: true,
                                    type: FileType.custom,
                                    allowedExtensions: ["jpg", "jpeg", "png"]);

                                if (result != null) {
                                  File image = await FlutterExifRotation.rotateImage(
                                      path: result.files.first.path!);

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
                                }
                              },
                              child: Container(
                                width: 70.w,
                                height: 70.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  color: kAccentColor.withOpacity(0.1),
                                ),
                                child: controller.user.value.profileImage != null
                                    ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: ImageWidget(
                                    controller.user.value.profileImage,
                                    width: 70.w,
                                    height: 70.w,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                    : Icon(
                                  CupertinoIcons.person,
                                  size: 35.sp,
                                  color: kAccentColor,
                                ),
                              ),
                            ),
                            // Edit icon in top right
                            Positioned(
                              top: -2.h,
                              right: -2.w,
                              child: Container(
                                width: 20.w,
                                height: 20.w,
                                decoration: BoxDecoration(
                                  color: kAccentColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  size: 12.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 16.w),
                        // User Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${controller.user.value.firstName}",
                                style: TextStyle(
                                  color: kBlackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "${controller.user.value.phoneNumber == null ? controller.user.value.email : "${controller.user.value.phoneNumber?.dialCode} ${controller.user.value.phoneNumber?.phoneNumber}"}",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                      : Row(
                    children: [
                      Container(
                        width: 70.w,
                        height: 70.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: kAccentColor.withOpacity(0.1),
                        ),
                        child: Icon(
                          CupertinoIcons.person,
                          size: 35.sp,
                          color: kAccentColor,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Login".tr,
                              style: TextStyle(
                                color: kBlackColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            InkWell(
                              child: Text(
                                "LogInToYourAccount".tr,
                                style: TextStyle(
                                  color: kAccentColor,
                                  fontSize: 14.sp,
                                ),
                              ),
                              onTap: () {
                                Get.toNamed(Routes.loginScreen);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),
                // Edit Profile
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ProfileMenuItem(
                    icon: MaterialCommunityIcons.account_edit_outline,
                    text: authController.authState.value == AuthState.authorized ? "Edit Profile" : "Login",
                    onTap: () {
                      if (authController.authState.value == AuthState.authorized) {
                        Get.toNamed(Routes.editProfileScreen);
                      } else {
                        Get.toNamed(Routes.loginScreen);
                      }
                    },
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ProfileMenuItem(
                    icon: MaterialCommunityIcons.car,
                    text: "Motors",
                    onTap: () {
                      loadVehicle();
                    },
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ProfileMenuItem(
                    icon: MaterialCommunityIcons.home,
                    text: "Real Estate",
                    onTap: () {
                      loadRealEstate();
                    },
                  ),
                ),

                if (authController.authState.value == AuthState.authorized) ...[
                  SizedBox(height: 12.h),

                  // My Orders
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ProfileMenuItem(
                      icon: MaterialCommunityIcons.package_variant_closed,
                      text: "My Orders",
                      onTap: () {
                        Get.to(() => MyOrdersScreen());
                      },
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Favorites
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ProfileMenuItem(
                      icon: MaterialCommunityIcons.heart_outline ,
                      text: "Favorites",
                      onTap: () {
                        Get.to(() => const FavoritesScreen());
                      },
                    ),
                  ),
                ],
                SizedBox(height: 12.h),
                // News
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ProfileMenuItem(
                    icon: MaterialCommunityIcons.newspaper_variant_outline,
                    text: "News",
                    onTap: () {
                      Get.to(() => const NewsScreen());
                    },
                  ),
                ),

                SizedBox(height: 12.h),

                // Countries
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ProfileMenuItem(
                    icon: MaterialCommunityIcons.earth,
                    text: "Countries",
                    onTap: () {
                      Get.to(()=> const CurrentLocationScreen());
                    },
                  ),
                ),

                SizedBox(height: 12.h),

                // Language
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: LanguageDropdownWidget(),

                ),

                if (authController.authState.value == AuthState.authorized && (UserSession.loginWith == null || UserSession.loginWith == "")) ...[
                  SizedBox(height: 12.h),

                  // Change Password
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ProfileMenuItem(
                      icon: MaterialCommunityIcons.lock_outline,
                      text: "ChangePassword",
                      onTap: () {
                        showChangePasswordSheet(context);
                      },
                    ),
                  ),
                ],

                if (authController.authState.value == AuthState.authorized) ...[
                  SizedBox(height: 30.h),

                  // Logout Button
                  Container(
                    width: double.infinity,
                    height: 50.h,
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    child: ElevatedButton(
                      onPressed: () {
                        authController.logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kLableColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            MaterialCommunityIcons.logout,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            "Log Out",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  // Delete Account
                  TextButton(
                    onPressed: () {
                      showConfirmationDialog(
                          title: "Warning",
                          message: "AreYouSureToDeleteYourAccountPermanently",
                          onConfirm: () {
                            Get.back();
                            controller.deleteAccount();
                          });
                    },
                    child: Text(
                      "Delete Account",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 20.h),

                // App Version - Simple text at bottom center
                Center(
                  child: Column(
                    children: [
                      Text(
                        "AppVersion".tr,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12.sp,
                        ),
                      ),
                      Text(
                        "${controller.packageInfo?.version}",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        )),
      ),
    );
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
          var controller = Get.put(PasswordController());
          return SingleChildScrollView(
              padding: kScreenPadding.copyWith(
                  bottom: kScreenPadding.bottom + MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 5.w,
                    width: 60.w,
                    decoration: BoxDecoration(borderRadius: kBorderRadius30, color: kGreyColor),
                  ),
                  kVerticalSpace12,
                  Text(
                    "ChangePassword".tr,
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                  ),
                  kVerticalSpace16,
                  Form(
                    key: controller.resetFormKey.value,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFieldWidget(
                          labelText: "CurrentPassword",
                          obscureText: true,
                          text: controller.currentPassword,
                          onChanged: (String val) {
                            controller.currentPassword = val.trim();
                          },
                          validator: (String? val) {
                            if (val!.trim().isEmpty) {
                              return kRequiredMsg.tr;
                            } else {
                              return null;
                            }
                          },
                        ),
                        kVerticalSpace12,
                        TextFieldWidget(
                          obscureText: true,
                          labelText: "NewPassword",
                          text: controller.newPassword,
                          onChanged: (String val) {
                            controller.newPassword = val.trim();
                          },
                          validator: (String? val) {
                            if (val!.trim().isEmpty) {
                              return kRequiredMsg.tr;
                            } else if (val.trim().length < 8) {
                              return kPasswordLimitMsg.tr;
                            } else {
                              return null;
                            }
                          },
                        ),
                        kVerticalSpace12,
                        TextFieldWidget(
                          obscureText: true,
                          labelText: "ConfirmPassword",
                          text: controller.confirmPassword,
                          onChanged: (String val) {
                            controller.confirmPassword = val.trim();
                          },
                          validator: (String? val) {
                            if (val!.trim().isEmpty) {
                              return kRequiredMsg.tr;
                            } else if (val.trim() != controller.newPassword) {
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

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    Key? key,
    required this.icon,
    required this.text,
    this.onTap,
    this.trailing, // ✅ new optional trailing widget
  }) : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.grey[600],
              size: 22.sp,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                text.tr,
                style: TextStyle(
                  color: kBlackColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailing != null) ...[
              trailing!, // ✅ show custom trailing widget
              SizedBox(width: 8.w),
            ],
            Icon(
              Get.locale?.languageCode == "ar"
                  ? MaterialCommunityIcons.chevron_left
                  : MaterialCommunityIcons.chevron_right,
              color: Colors.grey[400],
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}

