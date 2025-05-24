import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewImageController extends GetxController {
  var index = 0.obs;
  List<String> gallery=[];
 var pageController;

  @override
  void onInit() {
      if(Get.arguments is List){
        gallery=Get.arguments;
      }else{
        gallery=[Get.arguments];
      }

    index.value = int.parse(Get.parameters["index"]!);
    pageController = PageController(initialPage: index.value);
    // TODO: implement onInit
    super.onInit();
  }


  onPageChanged(index){
    this.index(index);
  }

}
