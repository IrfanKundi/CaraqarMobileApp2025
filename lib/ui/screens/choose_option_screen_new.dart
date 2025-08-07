import 'dart:async';
import 'dart:io';

import 'package:careqar/controllers/auth_controller.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

import '../../controllers/content_controller.dart';
import '../../controllers/country_controller.dart';
import '../../controllers/type_controller.dart';
import '../../global_variables.dart';
import '../../models/content_model.dart';
import '../../user_session.dart';

class ChooseOptionScreenNew extends StatefulWidget {
  const ChooseOptionScreenNew({Key? key}) : super(key: key);

  @override
  State<ChooseOptionScreenNew> createState() => _ChooseOptionScreenState();
}

class _ChooseOptionScreenState extends State<ChooseOptionScreenNew> {
  int currentIndex = 0;
  late Timer _timer;
  bool? _isLoggedIn;

  final List<SlideData> slides = [
    SlideData(
      image: 'assets/images/bg_home1.jpg',
      title: 'Discover\nDream House\nFrom\nSmart Phone',
      subtitle: '',
    ),
    SlideData(
      image: 'assets/images/bg_home2.jpg',
      title: 'Discover\nDream House\nFrom\nSmart Phone',
      subtitle: '',
    ),
    SlideData(
      image: 'assets/images/bg_car1.jpeg',
      title: 'Discover\nDream Car\nFrom\nSmart Phone',
      subtitle: '',
    ),
    SlideData(
      image: 'assets/images/bg_car2.jpeg',
      title: 'Discover\nDream Car\nFrom\nSmart Phone',
      subtitle: '',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkSession();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      setState(() {
        currentIndex = (currentIndex + 1) % slides.length;
      });
    });
  }
  Future<void> _checkSession() async {
    bool? result = await UserSession.exist();
    setState(() {
      _isLoggedIn = result;
    });
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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
          textConfirm: "Yes",
        );
        return res;
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Fade background slides
            Stack(
              children: List.generate(slides.length, (index) {
                final isVisible = index == currentIndex;

                return AnimatedOpacity(
                  opacity: isVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeInOut,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(slides[index].image),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(flex: 1),
                          Text(
                            slides[index].title,

                            style: GoogleFonts.poppins(
                              fontSize: 42,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                              height: 1.3,    // Hex color
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            slides[index].subtitle,
                            style:  GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,    // Hex color
                            ),
                          ),
                          const Spacer(flex: 3),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),

            // Bottom Buttons and Login Link
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 24),

                      // Real Estate Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(0, 4),
                                blurRadius: 8,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                loadRealEstate();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8BC34A),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Real Estate',
                                style:  GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,     // Hex color
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Motors Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                offset: const Offset(0, 4),
                                blurRadius: 8,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                loadVehicle();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8B1538),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                'Motors',
                                style:  GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,      // Hex color
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Login Link
                  _isLoggedIn!
                      ? Text(
                    "Welcome to CarAqaar",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400, // Light weight
                      color: Colors.white,
                    ),
                  )
                      : RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: 'Log In',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed(Routes.loginScreen);
                            },
                        ),
                      ],
                    ),
                  ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Model class for slides
class SlideData {
  final String image;
  final String title;
  final String subtitle;

  SlideData({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}


loadRealEstate() async {
  EasyLoading.show();
  gIsVehicle = false;
  TypeController typeController = Get.put(TypeController());
  typeController.allTypes.clear();
  typeController.subTypes.clear();

  await typeController.getTypes();
  await typeController.getTypesWithSubTypes();
  await getAppContent();
  Future.delayed(Duration(seconds:2),() {
    EasyLoading.dismiss();
    Get.offAllNamed(Routes.navigationScreen);
  },);
}

loadVehicle() async {

  // EasyLoading.show();
  gIsVehicle = true;
  getAppContent();
  Future.delayed(Duration(seconds: 2),() {
    // EasyLoading.dismiss();
    Get.offAllNamed(Routes.navigationScreen);
  },);
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
