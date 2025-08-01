
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:careqar/constants/colors.dart';
import 'package:careqar/controllers/home_controller.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/drawer_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../user_session.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late HomeController controller;

  @override
  void initState() {
    controller = Get.put(HomeController());

    // Check for initial tab argument
    if (Get.arguments != null && Get.arguments['initialTab'] != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.updatePageIndex(Get.arguments['initialTab']);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    gScaffoldStateKey = GlobalKey<ScaffoldState>();
    return WillPopScope(
      onWillPop: controller.onWillPop,
      child: Obx(
            () => Scaffold(
          key: gScaffoldStateKey,
          resizeToAvoidBottomInset: false,
          extendBody: true,
          drawer: DrawerWidget(),

          // Use BottomAppBar for better FAB integration
          bottomNavigationBar: BottomAppBar(
            height: 80,
            color: Colors.black.withValues(alpha: 0.3),
            shape: null,
            notchMargin: 0,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  svgPath:  'assets/icon/home.svg',
                  label: "Home".tr,
                  index: 0,
                  isSelected: controller.index.value == 0,
                  onTap: () => controller.updatePageIndex(0),
                ),
                _buildNavItem(
                  svgPath: 'assets/icon/my_ads.svg',
                  label: gIsVehicle ? "MyAds".tr : "Companies".tr,
                  index: 1,
                  isSelected: controller.index.value == 1,
                  onTap: () => controller.updatePageIndex(1),
                ),

                // Center space for FAB or search item
                controller.index.value == 0
                    ? const SizedBox(width: 40) // Space for FAB
                    : _buildNavItem(
                  svgPath: 'assets/icon/plus.svg',
                  label: "Post Ads".tr,
                  index: 2,
                  isSelected: controller.index.value == 2,
                  onTap: () => controller.updatePageIndex(2),
                ),

                _buildNavItem(
                  svgPath: gIsVehicle
                      ? 'assets/icon/cart.svg'
                      : 'assets/icon/cart.svg',
                  label: gIsVehicle ? "Cart".tr : "Requests".tr,
                  index: 3,
                  isSelected: controller.index.value == 3,
                  onTap: () => controller.updatePageIndex(3),
                ),
                _buildNavItem(
                  svgPath: (!gIsVehicle)
                      ? 'assets/icon/shop.svg'
                      : 'assets/icon/shop.svg',
                  label: (!gIsVehicle) ? "News".tr : "EStore".tr,
                  index: 4,
                  isSelected: controller.index.value == 4,
                  onTap: () => controller.updatePageIndex(4),
                ),
              ],
            ),
          ),

          floatingActionButton: SizedBox(
            width: 64,
            height: 64,
            child: FloatingActionButton(
              onPressed: () {
                if (gIsVehicle) {
                  if(UserSession.isLoggedIn!){
                    Get.toNamed(Routes.newAdScreen);
                  }else{
                    Get.toNamed(Routes.loginScreen);
                  }
                } else {
                  if(UserSession.isLoggedIn!){
                    Get.toNamed(Routes.newAdScreen);
                  }else{
                    Get.toNamed(Routes.loginScreen);
                  }
                }
              },
              shape: const CircleBorder(),
              backgroundColor: const Color(0xFF8B1538),
              child: SvgPicture.asset(
                'assets/icon/post_ad.svg', // Replace with your SVG path
                width: 44,
                height: 44,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: controller.index.value < controller.screens.length
                ? controller.screens[controller.index.value]
                : Container(),
          ),
        ),
      ),
    );
  }
}
//
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
Widget _buildNavItem({
  required String svgPath,
  required String label,
  required int index,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          svgPath,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            isSelected ? kAccentColor : Colors.white,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w300,
            color: isSelected ? kAccentColor : Colors.white,
          ),
        ),
      ],
    ),
  );
}
