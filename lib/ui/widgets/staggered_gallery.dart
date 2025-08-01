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
      appBar: buildAppBar(context,title: "Thumbnail"),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
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
                borderRadius: BorderRadius.circular(2),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 150,
                    color: Colors.grey.shade800,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
