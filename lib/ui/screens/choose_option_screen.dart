import 'dart:async';
import 'dart:io';

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/auth_controller.dart';
import 'package:careqar/locale/app_localizations.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';
import 'package:hive/hive.dart';

import '../../controllers/content_controller.dart';
import '../../controllers/country_controller.dart';
import '../../controllers/type_controller.dart';
import '../../global_variables.dart';
import '../../models/content_model.dart';
import '../widgets/switching_screen.dart';

class ChooseOptionScreen extends StatefulWidget {
  const ChooseOptionScreen({Key? key}) : super(key: key);

  @override
  State<ChooseOptionScreen> createState() => _ChooseOptionScreenState();
}

class _ChooseOptionScreenState extends State<ChooseOptionScreen> {


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool res = false;
        await showConfirmationDialog(
            message: "AreYouSureToCloseTheApp",
            title: "Warning",
            onConfirm: () {
              Get.back();
              res = true;
            },
            textCancel: "No",
            textConfirm: "Yes");

        return res;
      },
      child: Scaffold(
        backgroundColor: kWhiteColor,
        body: SafeArea(
          child: Container(
            height: 1.sh,
            width: 1.sw,
            padding: EdgeInsets.only(bottom: 16.w),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    kVerticalSpace28,
                    Image.asset(
                      gSelectedLocale?.langCode == 0
                          ? "assets/images/logo-en.png"
                          : "assets/images/logo-ar.png",
                      height: 200.w,
                      width: Get.width,
                    ),
                    kVerticalSpace28,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0),
                      child: Text(
                        "Discoverwhatyoulike".tr.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                    kVerticalSpace12,
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          loadRealEstate();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 50.w),
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              side: BorderSide(
                                  width: 1.w,
                                  color: Colors
                                      .black12), // Add a black solid border
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: GifView.asset(
                                    "assets/images/home-2.gif",
                                    frameRate: 1,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12.h),
                                  child: Text(
                                    "RealEstates".tr.toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    kVerticalSpace12,
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          loadVehicle();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 50.w),
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              side: BorderSide(
                                  width: 1.w,
                                  color: Colors
                                      .black12), // Add a black solid border
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    "assets/images/car-new.gif",
                                  ),
                                ),
                                Padding(
                                  padding:  EdgeInsets.symmetric(
                                      vertical: 12.h),
                                  child: Text(
                                    "Car".tr.toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    kVerticalSpace16,
                  ],
                ),
                PositionedDirectional(
                  end: 16.w,
                  top: 16.w,
                  child: GestureDetector(
                    onTap: () {
                      AppLocalizations.setLocale(
                          gSelectedLocale?.locale?.languageCode == "ar"
                              ? supportedLocales[0]
                              : supportedLocales[1]);
                    },
                    child: Row(
                      children: [
                        Text(
                          gSelectedLocale?.locale?.languageCode == "ar"
                              ? "Arabic".tr
                              : "English".tr,
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w600),
                        ),
                        kHorizontalSpace4,
                        Image.asset(
                          gSelectedLocale?.locale?.languageCode == "ar"
                              ? "assets/images/qatar.png"
                              : "assets/images/united-states.png",
                          height: 30.w,
                          width: 30.w,
                        ),
                      ],
                    ),
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

loadRealEstate() async {
  Get.dialog(
    const SwitchingScreen(
      label: 'Switching to Real Estate',
      icon: Icons.swap_horiz, // or use your custom icon
    ),
    barrierDismissible: false,
  );
  gIsVehicle = false;
  TypeController typeController = Get.put(TypeController());
  typeController.allTypes.clear();
  typeController.subTypes.clear();
  await typeController.getTypes();
  await typeController.getTypesWithSubTypes();
  await getAppContent();
  Get.back(); // dismiss loading screen
  Get.offAllNamed(Routes.navigationScreen);
}


loadVehicle() async {
  Get.dialog(
    const SwitchingScreen(
      label: 'Switching to Motors',
      icon: Icons.swap_horiz, // same icon or use a vehicle icon
    ),
    barrierDismissible: false,
  );
  gIsVehicle = true;
  await getAppContent();
  Future.delayed(const Duration(milliseconds: 50), () {
    Get.back(); // dismiss loading screen
    Get.offAllNamed(Routes.navigationScreen);
  });
}


Future<void> getAppContent() async {
  try {
    CountryController countryController = Get.find<CountryController>();
    await countryController.getCountries(); // Get All Countries

    var box = await Hive.openBox<AppContent>('app-content');  // Open Box For App Content

    AuthController authController = Get.find<AuthController>();
    await authController.init();

    ContentController contentController = Get.put(ContentController());
    await contentController.getContent();

    if(contentController.homeContent!=null){
      loadFiles(box, "homeContent", contentController.homeContent!);
    }
    if(contentController.splashContent!=null){
      loadFiles(box, "splashContent", contentController.splashContent!);
    }
    if(contentController.newsContent!=null){
      loadFiles(box, "newsContent", contentController.newsContent! );
    }
    if(contentController.foreignerContent!=null){
      loadFiles(box, "foreignerContent", contentController.foreignerContent! );
    }


  } catch (e) {
    // EasyLoading.showError(e.toString());
  }
}

Future<void> loadFiles(Box box, String key, Content content) async {
  try {
    key = "$key-${gSelectedCountry?.countryId}-${gIsVehicle ? 1 : 0}";

    AppContent? appContent = box.get(key);

    if (content.gifs.isNotEmpty ||
        content.images.isNotEmpty ||
        content.videos.isNotEmpty) {
      if (appContent == null) {
        appContent = AppContent();
        appContent.screen = content.screen;
        appContent.id = content.id;
        box.put(key, appContent);
      }
      if (appContent.createAt == null || content.createAt!.isAfter(appContent.createAt!)) {
        if (content.gifs.isNotEmpty) {
          FileInfo fileInfo = await DefaultCacheManager().downloadFile(content.gifs.last);
          content.files.add(fileInfo.file);
        }
        else if (content.images.isNotEmpty) {
          content.files.addAll((await Future.wait(content.images
              .map((e) => DefaultCacheManager().downloadFile(e))
              .toList()))
              .map((e) => e.file)
              .toList());
        }
        else {
          content.files.addAll((await Future.wait(content.videos
              .map((e) => DefaultCacheManager().downloadFile(e))
              .toList()))
              .map((e) => e.file)
              .toList());
        }
      }
      else {
        if (content.gifs.isNotEmpty) {
          File fileInfo = await DefaultCacheManager().getSingleFile(content.gifs.last);
          content.files.add(fileInfo);
        }
        else if (content.images.isNotEmpty) {
          content.files.addAll((await Future.wait(content.images
              .map((e) => DefaultCacheManager().getSingleFile(e))
              .toList()))
              .map((e) => e)
              .toList());
        }
        else {
          content.files.addAll((await Future.wait(content.videos
              .map((e) => DefaultCacheManager().getSingleFile(e))
              .toList()))
              .map((e) => e)
              .toList());
        }
      }

      appContent.createAt = content.createAt;
      appContent.save();
      if(content.files.isNotEmpty){
        ContentController().update();
      }

    }
    else {
      if (appContent != null) {
        appContent.delete();
      }
    }



  } catch (e) {
    // EasyLoading.showError(e.toString());
  }
}
