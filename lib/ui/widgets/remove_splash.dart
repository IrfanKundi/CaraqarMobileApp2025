import 'package:flutter/material.dart';

class RemoveSplash extends StatelessWidget {
  const RemoveSplash({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          // overscroll.disallowIndicator();
          return true;
        },
        child: child);
  }
}
