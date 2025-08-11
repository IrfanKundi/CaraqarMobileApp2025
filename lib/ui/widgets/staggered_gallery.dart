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
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          itemCount: _calculateRowCount(images.length),
          itemBuilder: (context, rowIndex) {
            final isOddRow = (rowIndex + 1) % 2 == 1;

            if (isOddRow) {
              final imageIndex = _getImageIndexForOddRow(rowIndex, images.length);
              if (imageIndex < images.length) {
                return _KeepAliveWrapper(
                  child: Column(
                    children: [
                      _buildFullWidthImage(images[imageIndex], imageIndex),
                      const SizedBox(height: 12),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            } else {
              final firstImageIndex = _getFirstImageIndexForEvenRow(rowIndex);
              final secondImageIndex = firstImageIndex + 1;

              if (firstImageIndex < images.length) {
                return _KeepAliveWrapper(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildHorizontalImage(images[firstImageIndex], firstImageIndex),
                          ),
                          const SizedBox(width: 12),
                          if (secondImageIndex < images.length)
                            Expanded(
                              child: _buildHorizontalImage(images[secondImageIndex], secondImageIndex),
                            )
                          else
                            const Expanded(child: SizedBox()),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  int _calculateRowCount(int imageCount) {
    if (imageCount == 0) return 0;
    int completeGroups = imageCount ~/ 3;
    int remainingImages = imageCount % 3;

    int rowCount = completeGroups * 2;
    if (remainingImages > 0) {
      rowCount++;
      if (remainingImages > 1) {
        rowCount++;
      }
    }
    return rowCount;
  }

  int _getImageIndexForOddRow(int rowIndex, int totalImages) {
    int groupIndex = rowIndex ~/ 2;
    return groupIndex * 3;
  }

  int _getFirstImageIndexForEvenRow(int rowIndex) {
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
      child: SizedBox(
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
              child: const Icon(Icons.error, color: Colors.grey),
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
      child: SizedBox(
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
              child: const Icon(Icons.error, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}

/// Keeps list items alive so they don’t reload when scrolled off-screen
class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const _KeepAliveWrapper({required this.child});

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

