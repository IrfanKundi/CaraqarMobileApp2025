import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/profile_controller.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../enums.dart';

class EditProfileScreen extends GetView<ProfileController> {
  EditProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        title: Text("EditProfile".tr, style: kAppBarStyle),
        iconTheme: IconThemeData(color: kBlackColor),
        elevation: 0,
      ),
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: Obx(() {
          // Wait for profile to load before building form
          if (controller.status.value == Status.loading) {
            return Center(child: CircularProgressIndicator());
          }

          // Ensure userModel is synced with loaded data
          controller.userModel = controller.user.value;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.w),
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: controller.formKey.value,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFieldWidget(
                    text: controller.userModel.firstName,
                    labelText: "Name",
                    onChanged: (String val) {
                      controller.userModel.firstName = val.trim();
                    },
                    validator: (String? val) {
                      val = val!.trim();
                      if (val.isEmpty)
                        return kRequiredMsg.tr;
                      else
                        return null;
                    },
                  ),
                  kVerticalSpace20,
                  TextFieldWidget(
                    text: controller.userModel.email,
                    labelText: "EmailAddress",
                    onChanged: (String val) {
                      controller.userModel.email = val.trim();
                    },
                    validator: (String? val) {
                      val = val!.trim();
                      if (val.isEmpty)
                        return kRequiredMsg.tr;
                      else if (!RegExp(kEmailRegExp).hasMatch(val))
                        return kInvalidEmailMsg.tr;
                      else
                        return null;
                    },
                  ),
                  kVerticalSpace20,
                  // City & Location Selection Field
                  InkWell(
                    onTap: () => controller.selectCityAndLocation(),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.grey.shade200,
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
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Obx(() {
                                // Check if both city and location are available
                                bool hasCity = controller.selectedCityName.value.isNotEmpty;
                                bool hasLocation = controller.selectedLocationName.value.isNotEmpty;

                                if (hasCity && hasLocation) {
                                  return Text(
                                    "${controller.selectedCityName.value}, ${controller.selectedLocationName.value}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  );
                                } else if (hasCity) {
                                  return Text(
                                    controller.selectedCityName.value,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  );
                                } else {
                                  return Text(
                                    "Enter address".tr,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                  );
                                }
                              }),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Obx(() => (controller.selectedCityName.value.isNotEmpty &&
                      controller.selectedLocationName.value.isNotEmpty)
                      ? kVerticalSpace16 : SizedBox.shrink()),
                  ButtonWidget(
                    text: "Update",
                    onPressed: controller.updateProfile,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}



