import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/auth_controller.dart';
import 'package:careqar/controllers/home_controller.dart';
import 'package:careqar/controllers/profile_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/screens/choose_option_screen.dart';
import 'package:careqar/ui/screens/news_screen.dart';
import 'package:careqar/user_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../controllers/type_controller.dart';
import '../screens/vehicle/vehicle_news_screen.dart';
import 'image_widget.dart';
import 'lang_bottom_sheet.dart';

class DrawerWidget extends GetView<ProfileController> {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var homeController = Get.find<HomeController>();
    final typeController = Get.put(TypeController());

// Trigger getTypes AFTER first frame (safe way)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (typeController.typesStatus.value == Status.initial) {
        typeController.getTypes(
          vehicleType: null,
        );
      }
    });
    var authController = Get.find<AuthController>();
    return Container(
      width: 0.8.sw,
      color: kPrimaryColor,
      height: 1.sh,
      child: SafeArea(
        child: Drawer(backgroundColor: kWhiteColor,
          child: SingleChildScrollView(
            child: Container(color: kWhiteColor,
              child: Column(
                children: [
                  Padding(padding: EdgeInsetsDirectional.only(
                      start: 32.w, end: 32.w, top: 32.w, bottom: 16.w), child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(kAppTitle.tr.toUpperCase(),
                            textAlign: TextAlign.start,
                            style: TextStyle(color: kPrimaryColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 20.sp),)),
                      kVerticalSpace24,

                      if (authController.authState.value ==
                          AuthState.authorized) Obx(() =>

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: kBorderRadius12,
                                  color: kAccentColor.withOpacity(0.1),
                                ),
                                child: ClipRRect(borderRadius: kBorderRadius12,
                                  child: ImageWidget(
                                    controller.user.value.profileImage ??
                                        "assets/images/avatar2.png"
                                    , width: 70.w,
                                    fit: BoxFit.cover,
                                    height: 70.w,
                                    isLocalImage: controller.user.value
                                        .profileImage == null,
                                  ),
                                ),
                              ), kHorizontalSpace12,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .stretch,
                                  children: [
                                    FittedBox(
                                        alignment: Alignment.centerLeft,
                                        fit: BoxFit.scaleDown,
                                        child: Directionality(

                                            textDirection: TextDirection.ltr,
                                            child: Text(
                                              controller.user.value.firstName!,
                                              style: kTextStyle18,))),
                                    FittedBox(
                                        alignment: Alignment.centerLeft,
                                        fit: BoxFit.scaleDown,
                                        child: Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: Text(
                                            controller.user.value.phoneNumber ==
                                                null ? controller.user.value
                                                .email ?? ' ' :
                                            "${controller.user.value.phoneNumber
                                                ?.dialCode} ${controller.user
                                                .value.phoneNumber
                                                ?.phoneNumber}",
                                            style: kTextStyle14,),
                                        )),
                                  ],
                                ),
                              ),

                            ],
                          ),)
                      else
                        InkWell(
                          onTap: () {
                            Get.toNamed(Routes.loginScreen);
                          },
                          child:
                          Container(
                            alignment: Alignment.center,
                            height: 45.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: kWhiteColor,
                              border: Border.all(
                                  color: kPrimaryColor, width: 1.w),
                              borderRadius: kBorderRadius8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: FittedBox(
                                      fit: BoxFit.scaleDown,

                                      child: Text("LoginOrCreateAccount".tr,
                                        style: TextStyle(color: kPrimaryColor,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600),)),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w),
                                  child: Icon(
                                    Get.locale?.languageCode == "ar"
                                        ? MaterialCommunityIcons.arrow_left
                                        :
                                    MaterialCommunityIcons.arrow_right,
                                    size: 20.sp, color: kPrimaryColor,),
                                )

                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                  ),

                  const Divider(),

                  kVerticalSpace8,

                  DrawerItem(
                    text: "Home", icon: MaterialCommunityIcons.home, onTap: () {
                    Get.back();
                    homeController.updatePageIndex(0);
                  }, isSelected: homeController.index.value == 0,),
                  DrawerItem(
                    text: gIsVehicle ? "RealEstates" : "Car",
                    icon: gIsVehicle
                        ? MaterialCommunityIcons.office_building
                        : MaterialCommunityIcons.car,
                    onTap: () {
                      Get.back();
                      if (gIsVehicle) {
                        loadRealEstate();
                      } else {
                        loadVehicle();
                      }
                    },
                  ),
                  DrawerItem(text: "Profile",
                      icon: MaterialCommunityIcons.account_outline,
                      onTap: () {
                        Get.back();
                        Get.toNamed(Routes.profileScreen);
                      }),
                  if(!gIsVehicle)
                    DrawerItem(text: "MyAds",
                        icon: MaterialCommunityIcons.office_building,
                        onTap: () {
                          Get.back();
                          if (UserSession.isLoggedIn!) {
                            Get.toNamed(Routes.myPropertiesScreen);
                          } else {
                            Get.toNamed(Routes.loginScreen);
                          }
                        }),
                  if(gIsVehicle)
                    DrawerItem(text: "MyOrders",
                        icon: MaterialCommunityIcons.receipt,
                        onTap: () {
                          Get.back();
                          if (UserSession.isLoggedIn!) {
                            Get.toNamed(Routes.myOrdersScreen);
                          } else {
                            Get.toNamed(Routes.loginScreen);
                          }
                        }),
                  if(gIsVehicle)
                    DrawerItem(text: "News",
                        icon: MaterialCommunityIcons.newspaper,
                        onTap: () {
                          Get.back();
                          Get.to(() => VehicleNewsScreen());
                        }),
                  if(!gIsVehicle)
                    DrawerItem(text: "News",
                        icon: MaterialCommunityIcons.newspaper,
                        onTap: () {
                          Get.back();
                          Get.to(() => const NewsScreen());
                        }),
                  DrawerItem(text: "Favorites",
                      icon: MaterialCommunityIcons.heart_outline,
                      onTap: () {
                        Get.back();
                        if (UserSession.isLoggedIn!) {
                          Get.toNamed(Routes.favoritesScreen);
                        } else {
                          Get.toNamed(Routes.loginScreen);
                        }
                      }),
                  // DrawerItem(text: "SearchProperty",icon: MaterialCommunityIcons.magnify,onTap: (){
                  //   Get.back();
                  //   Get.toNamed(Routes.filtersScreen);
                  //
                  // },),
                  // DrawerItem(text: "Investment",subtitle: "ComingSoon",icon: MaterialCommunityIcons.currency_usd,onTap: (){
                  //
                  //
                  // },),
                  // DrawerItem(text: "NearbyProperties",icon: MaterialCommunityIcons.map_marker_outline,onTap: (){
                  //   Get.back();
                  //   homeController.updatePageIndex(1,nearby: true);
                  //
                  // },isSelected: homeController.index.value==3,),
                  // DrawerItem(text: "Favorites",icon: MaterialCommunityIcons.heart_outline,onTap: (){
                  //   Get.back();
                  //   homeController.updatePageIndex(3);
                  //
                  // },isSelected: homeController.index.value==3,),
                  //DrawerItem(text: "CrimsonBlog",icon: MaterialCommunityIcons.message_outline,onTap: (){},),
                  if(authController.authState.value == AuthState.authorized)
                    DrawerItem(text: "LogOut",
                      icon: MaterialCommunityIcons.logout,
                      onTap: () {
                        Get.back();
                        authController.logout();
                      },),


                  Row(
                    children: [
                      Container(
                        color: Colors.grey.shade300, width: 15.w, height: 1.w,),
                      Text("AppControls".tr.toUpperCase(), style: TextStyle(
                          color: kGreyColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500),),
                      Expanded(child: Container(
                        color: Colors.grey.shade300, height: 1.w,)),

                    ],
                  ),
                  kVerticalSpace12,
                  DrawerItem(text: "Language", icon: Icons.language, onTap: () {
                    showLangBottomSheet(context);
                  },),
                  // DrawerItem(text: "AboutUs",icon: MaterialCommunityIcons.information_outline,onTap: (){},),
                  //  DrawerItem(text: "ContactUs",icon: MaterialCommunityIcons.phone,onTap: (){
                  //   Get.toNamed(Routes.contactUsScreen);
                  //  },),

                  //  DrawerItem(text: "Terms&PrivacyPolicy",icon: MaterialCommunityIcons.file_document_box_outline,onTap: (){},),
                  kVerticalSpace12,

                  Text("${"AppVersion".tr} ${controller.packageInfo?.version}",
                    style: TextStyle(color: kGreyColor, fontSize: 13.sp),),

                  kVerticalSpace24,


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}

class DrawerItem extends StatelessWidget {
  const DrawerItem(
      {Key? key, this.icon, this.subtitle, this.text, this.onTap, this.isSelected = false})
      : super(key: key);

  final String? text;
  final String? subtitle;
  final IconData? icon;
  final Function()? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 43.h,
        alignment: Alignment.center,
        padding: EdgeInsetsDirectional.only(start: 32.w),
        margin: EdgeInsetsDirectional.only(end: 12.w, top: 8.w),
        decoration: BoxDecoration(
            color: isSelected ? kAccentColor.withOpacity(0.1) : kWhiteColor,
            borderRadius: BorderRadiusDirectional.horizontal(
                end: Radius.circular(30.r))
        ),
        child: Row
          (
          children: [
            Icon(icon, color: isSelected ? kAccentColor : kGreyColor,
              size: 24.sp,),
            kHorizontalSpace12,
            Column(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(text!.tr, style: TextStyle(
                    color: isSelected ? kAccentColor : kBlackColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500),),
                if(subtitle != null)
                  Text(subtitle!.tr,
                    style: TextStyle(color: kRedColor, fontSize: 12.sp),),

              ],
            ),
          ],
        ),
      ),
    );
  }
}

