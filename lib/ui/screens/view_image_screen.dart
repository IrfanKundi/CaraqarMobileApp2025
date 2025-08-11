import 'package:cached_network_image/cached_network_image.dart';
import 'package:careqar/controllers/view_image_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ViewImageScreen extends GetView<ViewImageController> {
  const ViewImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Full black background
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          backgroundDecoration: const BoxDecoration(
            color: Colors.black, // Ensures full black while loading
          ),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: CachedNetworkImageProvider(
                controller.gallery[index],
              ),
              initialScale: PhotoViewComputedScale.contained,
              heroAttributes: PhotoViewHeroAttributes(tag: index),
            );
          },
          itemCount: controller.gallery.length,
          pageController: controller.pageController,
          onPageChanged: controller.onPageChanged,

          // Suppress any loader
          loadingBuilder: (context, event) => const SizedBox.shrink(),
        ),
      ),
    );
  }
}

