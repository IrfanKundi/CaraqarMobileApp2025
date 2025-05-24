import 'package:careqar/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class CircularLoader extends StatelessWidget {
  final color;

  const CircularLoader({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 20.r,
        width: 20.r,
        child: CircularProgressIndicator(
            strokeWidth: 2.3,
            valueColor: color != null
                ? AlwaysStoppedAnimation<Color>(color)
                : const AlwaysStoppedAnimation<Color>(kAccentColor)),
      ),
    );
  }
}
