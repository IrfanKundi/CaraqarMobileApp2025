import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:careqar/user_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import 'constants/colors.dart';
import 'constants/strings.dart';
import 'constants/style.dart';
import 'controllers/country_controller.dart';
import 'controllers/select_country_controller.dart';
import 'enums.dart';
import 'global_variables.dart';

class SelectCountryScreen extends GetView<SelectCountryController> {
  const SelectCountryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: buildAppBar(context, title: "Countries".tr),
      body: GetBuilder<CountryController>(
        builder: (controller) {
          if (controller.status.value == Status.loading) {
            return const Center(child: CircularLoader());
          }

          if (controller.status.value == Status.error) {
            return Center(
              child: Text(
                kCouldNotLoadData,
                style: kTextStyle16,
              ),
            );
          }

          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemCount: controller.countries.length,
            padding: kScreenPadding,
            itemBuilder: (context, index) {
              var item = controller.countries[index];
              bool isSelected = gSelectedCountry?.countryId == item.countryId;

              return InkWell(
                onTap: () async {
                  gSelectedCountry = item;
                  if (!deepLinkHandled) {
                    await UserSession.changeCountry(item.countryId!);
                    Get.offNamedUntil(Routes.chooseOptionScreenNew, (route) => false);
                  }
                },
                borderRadius: BorderRadius.circular(30.r),
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: isSelected ? kLightBlueColor : Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(
                      color: isSelected
                          ? kLightBlueColor
                          : Colors.grey.shade200,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Flag image
                      Container(
                        width: 40.w,
                        height: 40.h,
                        margin: EdgeInsets.symmetric(horizontal: 12.w),
                        child: ImageWidget(
                          item.flag,
                          width: 30.h,
                        ),
                      ),

                      // Country name
                      Expanded(
                        child: Text(
                          item.name!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // Arrow icon
                      Icon(
                        Get.locale?.languageCode == "ar"
                            ? MaterialCommunityIcons.chevron_left
                            : MaterialCommunityIcons.chevron_right,
                        color: isSelected
                            ? Colors.white.withOpacity(0.7)
                            : Colors.grey.shade400,
                        size: 20.w,
                      ),
                      SizedBox(width: 12.w),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
