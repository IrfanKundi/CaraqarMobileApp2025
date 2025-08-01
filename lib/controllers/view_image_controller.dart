import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewImageController extends GetxController {
  var index = 0.obs;
  List<String> gallery = [];
  late final PageController pageController;

  @override
  void onInit() {
    super.onInit();

    // Initialize gallery from Get.arguments
    if (Get.arguments is List) {
      gallery = List<String>.from(Get.arguments);
    } else {
      gallery = [Get.arguments];
    }

    // Get initial index from route parameters
    index.value = int.parse(Get.parameters["index"] ?? "0");
    pageController = PageController(initialPage: index.value);


    Future.delayed(Duration.zero, () {
      final context = Get.context;
      if (context != null) {
        for (final url in gallery) {
          precacheImage(CachedNetworkImageProvider(url), context);
        }
      }
    });
  }

  void onPageChanged(int index) {
    this.index(index);
  }
}

