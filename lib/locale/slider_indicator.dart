// First, add this SIMPLE custom indicator widget at the top of your file or in a separate file
import 'package:flutter/material.dart';

class WorkingSlidingIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;

  const WorkingSlidingIndicator({
    Key? key,
    required this.itemCount,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Always show exactly 4 dots
    const int maxDots = 4;

    if (itemCount <= maxDots) {
      // If 4 or fewer items, show all
      return _buildDots(
        startIndex: 0,
        endIndex: itemCount - 1,
        currentIndex: currentIndex,
      );
    }

    // FIXED LOGIC - This will slide continuously
    int startIndex;

    // Simple rule: start sliding from index 1 onwards
    if (currentIndex == 0) {
      startIndex = 0; // [0,1,2,3]
    } else if (currentIndex >= itemCount - maxDots + 1) {
      // Near end: show last 4 dots
      startIndex = itemCount - maxDots; // [...,n-3,n-2,n-1,n]
    } else {
      // Keep sliding: always put current index at position 1 in the window
      startIndex = currentIndex - 1; // [curr-1, curr, curr+1, curr+2]
    }

    return _buildDots(
      startIndex: startIndex,
      endIndex: startIndex + maxDots - 1,
      currentIndex: currentIndex,
    );
  }

  Widget _buildDots({
    required int startIndex,
    required int endIndex,
    required int currentIndex,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(endIndex - startIndex + 1, (i) {
          int dotIndex = startIndex + i;
          bool isActive = dotIndex == currentIndex;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isActive ? 12.0 : 8.0,
            height: 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 3.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
            ),
          );
        }),
      ),
    );
  }
}