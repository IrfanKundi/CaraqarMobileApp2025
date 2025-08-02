import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../routes.dart';
import 'app_bar.dart';

 // adjust to your actual path

class StaggeredGalleryScreen extends StatelessWidget {
  const StaggeredGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the list of images from arguments
    final List<String> images = List<String>.from(Get.arguments);

    return Scaffold(
      appBar: buildAppBar(context, title: "Pictures"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2, // This makes the items slightly wider than tall
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            final imageUrl = images[index];

            return GestureDetector(
              onTap: () {
                // Navigate to ViewImageScreen with selected index
                Get.toNamed(
                  Routes.viewImageScreen,
                  arguments: images,
                  parameters: {
                    "index": index.toString(),
                  },
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey.shade800,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.error,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
