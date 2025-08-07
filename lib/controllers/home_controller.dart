

import 'package:careqar/controllers/location_controller.dart';
import 'package:careqar/controllers/profile_controller.dart';
import 'package:careqar/controllers/property_controller.dart';
import 'package:careqar/controllers/request_controller.dart';
import 'package:careqar/controllers/type_controller.dart';
import 'package:careqar/controllers/vehicle_controller.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/services/check_for_update.dart';
import 'package:careqar/ui/screens/home_screen.dart';
import 'package:careqar/ui/screens/news_screen.dart';
import 'package:careqar/ui/screens/requests_screen.dart'; 
import 'package:careqar/ui/screens/vehicle/my_cars_screen.dart';
import 'package:careqar/ui/screens/vehicle/vehicle_home_screen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../routes.dart';
import '../ui/screens/vehicle/coming_soon_screen.dart';
import '../user_session.dart';
import 'content_controller.dart';

class HomeController extends GetxController {
  var status = Status.initial.obs;
  ScrollController scrollController = ScrollController();
  final maxExtent = 1.sh;
  var currentExtent = 0.0.obs;
  late TabController tabController;
  late PropertyController propertyController;
  late TypeController typeController;
  late VehicleController vehicleController;
  late RequestController requestController;
  late LocationController locationController;

  ContentController  contentController = Get.find<ContentController>();
  var index = 0.obs;
  final screens = [
   gIsVehicle? const VehicleHomeScreen(): const HomeScreen(),
    gIsVehicle?MyCarsScreen(): Container(),
    Container(),
   gIsVehicle? Container(): RequestsScreen(),
   //gIsVehicle? FavoritesScreen(): RequestsScreen(),
    gIsVehicle? Container(): const NewsScreen(),
  ];

  updatePageIndex(index,{nearby=false}) {
    if(index!=2){
      if(index==1){
        if(gIsVehicle){
          this.index(index);
        }else{
            if (UserSession.isLoggedIn!) {
              Get.toNamed(Routes.myPropertiesScreen);
            } else {
              Get.toNamed(Routes.loginScreen);
            }
        }

      }
      else if(index==3 && gIsVehicle){
        if(UserSession.isLoggedIn!){
         //this.index(index);
          Get.toNamed(Routes.cartScreen);
        }else{
          Get.toNamed(Routes.loginScreen);
        }
      }
      else if(index==4 && gIsVehicle){
        // Get.toNamed(Routes.eStoreScreen);
        Navigator.of(gNavigatorKey.currentContext!).push(MaterialPageRoute(builder: (context) => ComingSoonScreen(title: "Estore Screen",)),);

      }
      else{
        this.index(index);
      }
    }
    else{
      if(gIsVehicle){
        Get.toNamed(Routes.newAdScreen);
      }else{
        Get.toNamed(Routes.propertiesScreen);
      }
    }
  }

  DateTime? currentBackPressTime;
  Future<bool> onWillPop() {
    if (index.value != 0) {
      index(0);

      return Future.value(false);
    } else {
      // DateTime now = DateTime.now();
      // if (currentBackPressTime == null ||
      //     now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      //   currentBackPressTime = now;
      //   Fluttertoast.showToast(
      //       msg: "Press back again to exit", toastLength: Toast.LENGTH_SHORT);
      //   return Future.value(false);
      // }
      Get.find<ContentController>().reset();
      Get.offAllNamed(Routes.chooseOptionScreenNew);
      return Future.value(true);
    }
  }


  @override
  void onInit() async {
    checkForUpdate(gNavigatorKey.currentContext);
    initDynamicLinks();
    scrollController.addListener(() {
      currentExtent.value = maxExtent - scrollController.offset;
      if (currentExtent < 0) currentExtent.value = 0.0;
      if (currentExtent > maxExtent) currentExtent.value = maxExtent;
    });
    Get.put(ProfileController(),permanent: true);
    if(gIsVehicle){
      vehicleController=Get.put(VehicleController(),permanent: true);
    }else{
      locationController = Get.put(LocationController(),permanent: true);
      typeController =Get.put(TypeController(),permanent: true);
      propertyController =  Get.put(PropertyController(),permanent: true);
      requestController =   Get.put(RequestController(),permanent: true);
    }


    super.onInit();
  }





  void initDynamicLinks() async {
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    dynamicLinks.onLink.listen((PendingDynamicLinkData dynamicLink) async {
      final Uri? deepLink = dynamicLink.link;

      if (deepLink != null) {
        if(deepLink.path.contains("/property")){
          Get.toNamed(Routes.viewPropertyScreen,arguments: deepLink.queryParameters["propertyId"]);

        }else    if(deepLink.path.contains("/car")){
          Get.toNamed(Routes.viewCarScreen,arguments: deepLink.queryParameters["carId"]);

        }
        else    if(deepLink.path.contains("/bike")){
          Get.toNamed(Routes.viewBikeScreen,arguments: deepLink.queryParameters["bikeId"]);

        }
        else    if(deepLink.path.contains("/numberPlate")){
          Get.toNamed(Routes.viewNumberPlateScreen,arguments: deepLink.queryParameters["numberPlateId"]);

        }
      }
    }).onError((error) {
      if (kDebugMode) {
        print(error.message);
      }
    });




    final PendingDynamicLinkData? data =
    await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      if(deepLink.path.contains("/property")){
        Get.toNamed(Routes.viewPropertyScreen,arguments: deepLink.queryParameters["propertyId"]);
      }

    }
  }





}
