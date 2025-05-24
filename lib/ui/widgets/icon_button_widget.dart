import 'package:careqar/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconButtonWidget extends StatelessWidget {
  final IconData? icon;
  final void Function()? onPressed;
  final bool? elevation;
  final Color? color;
  final double? width;
  final double? iconSize;

  const IconButtonWidget(
      {Key? key,
        required this.icon,
        this.onPressed,
        this.iconSize,
        this.color = kAccentColor,
        this.elevation = false,
        this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      alignment: Alignment.center,
      constraints:
      BoxConstraints(minHeight: width ?? 30.r, minWidth: width ?? 30.r),
      onPressed: onPressed,
      icon: Icon(
        icon,
      ),
      iconSize: iconSize?? 25.sp,
      color: color,
      padding: EdgeInsets.zero,
    );
  }
}
