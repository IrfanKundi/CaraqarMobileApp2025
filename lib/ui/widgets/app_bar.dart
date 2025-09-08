

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

buildAppBar(
    BuildContext context, {
      String? title,
      Widget? child,
      List<Widget>? actions,
      bool isPrimaryAppBar = false,
      bool showBack = true, // default true
    }) {
  return AppBar(
    centerTitle: true,
    backgroundColor: isPrimaryAppBar ? kAccentColor : kWhiteColor,
    surfaceTintColor: Colors.transparent,
    scrolledUnderElevation: 0,
    shadowColor: Colors.transparent,
    foregroundColor: isPrimaryAppBar ? kWhiteColor : kBlackColor,
    iconTheme: IconThemeData(color: isPrimaryAppBar ? kWhiteColor : kBlackColor),
    leading: showBack
        ? IconButton(
      icon: FaIcon(
        FontAwesomeIcons.angleLeft,
        color: isPrimaryAppBar ? kWhiteColor : kBlackColor,
        size: 20,
      ),
      onPressed: () => Navigator.of(context).maybePop(),
    )
        : null,
    title: child ??
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            (title ?? "").tr,
            style: isPrimaryAppBar
                ? kAppBarStyle.copyWith(color: kWhiteColor)
                : kDarkTextStyle16,
          ),
        ),
    elevation: 0,
    actions: actions ?? [],
  );
}
