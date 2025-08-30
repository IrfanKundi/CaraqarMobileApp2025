import 'package:careqar/ui/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../global_variables.dart';
import '../../locale/app_localizations.dart';

class LanguageDropdownWidget extends StatefulWidget {
  @override
  _LanguageDropdownWidgetState createState() => _LanguageDropdownWidgetState();
}

class _LanguageDropdownWidgetState extends State<LanguageDropdownWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main ProfileMenuItem
        ProfileMenuItem(
          icon: MaterialCommunityIcons.translate,
          text: gSelectedLocale?.locale?.languageCode == "ar"
              ? "Arabic".tr
              : "English".tr,
          trailing: Image.asset(
            gSelectedLocale?.locale?.languageCode == "ar"
                ? "assets/images/qatar.png"
                : "assets/images/united-states.png",
            height: 20.w,
            width: 30.w,
          ),
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
        ),

        // Expandable dropdown options
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: isExpanded ? (supportedLocales.length * 60.h) : 0,
          child: isExpanded
              ? Column(
            children: supportedLocales.map<Widget>((AppLocale appLocale) {
              return Container(
                width: double.infinity,
                height: 60.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      AppLocalizations.setLocale(appLocale);
                      setState(() {
                        isExpanded = false;
                      });
                    },
                    borderRadius: BorderRadius.circular(50.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                      child: Row(
                        children: [
                          Image.asset(
                            appLocale.locale!.languageCode == "ar"
                                ? "assets/images/qatar.png"
                                : "assets/images/united-states.png",
                            height: 20.w,
                            width: 30.w,
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Text(
                              appLocale.locale!.languageCode == "ar" ? "Arabic" : "English",
                              style: TextStyle(
                                color: kBlackColor,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(
                            Get.locale?.languageCode == "ar"
                                ? MaterialCommunityIcons.chevron_left
                                : MaterialCommunityIcons.chevron_right,
                            color: Colors.grey[400],
                            size: 18.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          )
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}