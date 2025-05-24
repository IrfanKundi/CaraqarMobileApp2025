
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:careqar/constants/colors.dart';
import 'package:careqar/controllers/home_controller.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/drawer_widget.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late HomeController controller;

  @override
  void initState() {
    controller = Get.put(HomeController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    gScaffoldStateKey = GlobalKey<ScaffoldState>();
    return WillPopScope(
      onWillPop: controller.onWillPop,
      child: Obx(
        () => Scaffold(
          resizeToAvoidBottomInset: false,
          key: gScaffoldStateKey,
          drawer: const DrawerWidget(),
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: controller.index.value < controller.screens.length
                    ? controller.screens[controller.index.value]
                    : Container(),
              ),
              Stack(alignment: Alignment.topCenter, children: [
                BottomNavigationBar(
                  backgroundColor:
                      // controller.index.value == 0 ? Colors.transparent :
                      Colors.black38,
                  elevation: 0,
                  currentIndex: controller.index.value,
                  unselectedLabelStyle:
                      TextStyle(color: kWhiteColor, fontSize: 11.sp),
                  selectedLabelStyle:
                      TextStyle(color: kAccentColor, fontSize: 11.sp),
                  unselectedItemColor: kWhiteColor,
                  type: BottomNavigationBarType.fixed,
                  iconSize: 25.sp,
                  onTap: (index) {
                    controller.updatePageIndex(index);
                  },
                  selectedItemColor: kAccentColor,
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Foundation.home),
                      label: "Home".tr,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(MaterialCommunityIcons.office_building),
                      label: gIsVehicle ? "MyAds".tr : "Companies".tr,
                    ),
                    BottomNavigationBarItem(
                        icon: controller.index.value == 0
                            ? Container()
                            : const Icon(
                                MaterialCommunityIcons.magnify,
                              ),
                        label: controller.index.value == 0 ? "" : "Search".tr),
                    BottomNavigationBarItem(
                        icon: Icon(
                          gIsVehicle
                              ? MaterialCommunityIcons.cart_outline
                              : MaterialCommunityIcons.text,
                        ),
                        label: gIsVehicle ? "Cart".tr : "Requests".tr
                        //label: gIsVehicle?"Favorites".tr:"Requests".tr
                        ),
                    (!gIsVehicle)?BottomNavigationBarItem(
                        icon: const Icon(MaterialCommunityIcons.newspaper),
                        label: "News".tr):BottomNavigationBarItem(
                        icon: const Icon(MaterialCommunityIcons.store),
                        label: "EStore".tr),
                  ],
                ),
                controller.index.value == 0
                    ? GestureDetector(
                        onTap: () {
                          if (gIsVehicle) {
                            Get.toNamed(Routes.allAdsScreen);
                          } else {
                            controller.propertyController.resetFilters();
                            controller.propertyController
                                .getFilteredProperties();
                            Get.toNamed(Routes.propertiesScreen);
                          }
                        },
                        child: Container(
                          width: 51.r,
                          height: 51.r,
                          decoration: BoxDecoration(
                              color: const Color(0xFF8B1538),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0xFF8B1538)
                                        .withOpacity(0.5),
                                    blurRadius: 12.r)
                              ]),
                          child: Icon(
                            MaterialCommunityIcons.magnify,
                            size: 28.sp,
                            color: kWhiteColor,
                          ),
                        ),
                      )
                    : SizedBox(
                        width: 51.r,
                        height: 51.r,
                      )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = Paint()
      ..color = kWhiteColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.9950000);
    path_0.lineTo(0, 0);
    path_0.lineTo(size.width * 0.4000000, 0);
    path_0.quadraticBezierTo(size.width * 0.4376250, size.height * 0.3525000,
        size.width * 0.5005000, size.height * 0.3560000);
    path_0.quadraticBezierTo(size.width * 0.5631875, size.height * 0.3512500,
        size.width * 0.6002500, 0);
    path_0.lineTo(size.width, 0);
    path_0.lineTo(size.width, size.height);
    path_0.lineTo(0, size.height * 0.9950000);
    path_0.close();

    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
