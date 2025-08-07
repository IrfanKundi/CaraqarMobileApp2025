import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../routes.dart';
import 'app_bar.dart';


class StaggeredGalleryScreen extends StatelessWidget {
  const StaggeredGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> images = List<String>.from(Get.arguments);

    return Scaffold(
      appBar: buildAppBar(context, title: "Pictures"),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: _calculateRowCount(images.length),
          itemBuilder: (context, rowIndex) {
            final isOddRow = (rowIndex + 1) % 2 == 1; // 1st, 3rd, 5th rows are odd

            if (isOddRow) {
              // Odd row: Single full-width image
              final imageIndex = _getImageIndexForOddRow(rowIndex, images.length);
              if (imageIndex < images.length) {
                return Column(
                  children: [
                    _buildFullWidthImage(images[imageIndex], imageIndex),
                    SizedBox(height: 12),
                  ],
                );
              }
              return SizedBox.shrink();
            } else {
              // Even row: Two horizontal images
              final firstImageIndex = _getFirstImageIndexForEvenRow(rowIndex);
              final secondImageIndex = firstImageIndex + 1;

              if (firstImageIndex < images.length) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildHorizontalImage(images[firstImageIndex], firstImageIndex)),
                        SizedBox(width: 12),
                        if (secondImageIndex < images.length)
                          Expanded(child: _buildHorizontalImage(images[secondImageIndex], secondImageIndex))
                        else
                          Expanded(child: Container()), // Empty space if no second image
                      ],
                    ),
                    SizedBox(height: 12),
                  ],
                );
              }
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  int _calculateRowCount(int imageCount) {
    if (imageCount == 0) return 0;

    // Pattern: odd rows have 1 image, even rows have 2 images
    // So every 2 rows we use 3 images (1 + 2)
    int completeGroups = imageCount ~/ 3;
    int remainingImages = imageCount % 3;

    int rowCount = completeGroups * 2;
    if (remainingImages > 0) {
      rowCount++; // Add one more row for remaining images
      if (remainingImages > 1) {
        rowCount++; // Add second row if we have more than 1 remaining
      }
    }

    return rowCount;
  }

  int _getImageIndexForOddRow(int rowIndex, int totalImages) {
    // Odd rows: 0, 2, 4, 6... (rowIndex 0, 2, 4, 6...)
    // Images used: 0, 3, 6, 9...
    int groupIndex = rowIndex ~/ 2;
    return groupIndex * 3;
  }

  int _getFirstImageIndexForEvenRow(int rowIndex) {
    // Even rows: 1, 3, 5, 7... (rowIndex 1, 3, 5, 7...)
    // First images used: 1, 4, 7, 10...
    int groupIndex = (rowIndex - 1) ~/ 2;
    return groupIndex * 3 + 1;
  }

  Widget _buildFullWidthImage(String imageUrl, int index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.viewImageScreen,
          arguments: List<String>.from(Get.arguments),
          parameters: {"index": index.toString()},
        );
      },
      child: Container(
        width: double.infinity,
        height: 180,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.error,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalImage(String imageUrl, int index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.viewImageScreen,
          arguments: List<String>.from(Get.arguments),
          parameters: {"index": index.toString()},
        );
      },
      child: Container(
        width: double.infinity,
        height: 200,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.error,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
