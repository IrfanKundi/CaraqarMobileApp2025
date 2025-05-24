import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/profile_controller.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditProfileScreen extends GetView<ProfileController> {
   EditProfileScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    controller.userModel=controller.user.value;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        title: Text("EditProfile".tr,style: kAppBarStyle,),
        iconTheme: IconThemeData(color: kBlackColor),
        elevation: 0,
      ),
      backgroundColor: kWhiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
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
                  onChanged: (String val){
                    controller.userModel.firstName=val.trim();
                  },
                  validator: (String? val){
                    val=val!.trim();
                    if(val.isEmpty)
                      return kRequiredMsg.tr;
                    else
                      return null;
                  },
                ),
                // kVerticalSpace20,
                // TextFieldWidget(
                //   text: controller.userModel.lastName,
                //   labelText: "LastName",
                //   onChanged: (String val){
                //     controller.userModel.lastName=val.trim();
                //   },
                //   validator: (String val){
                //     val=val.trim();
                //     if(val.isEmpty)
                //       return kRequiredMsg.tr;
                //     else
                //       return null;
                //   },
                // ),

                kVerticalSpace20,

                TextFieldWidget(
                  text: controller.userModel.email,
                  labelText: "EmailAddress",
                  onChanged: (String val){
                    controller.userModel.email=val.trim();
                  },
                  validator: (String? val){
                    val=val!.trim();
                    if(val.isEmpty)
                      return kRequiredMsg.tr;
                    else if(!RegExp(kEmailRegExp).hasMatch(val))
                      return kInvalidEmailMsg.tr;
                    else
                      return null;
                  },
                ),
                kVerticalSpace16,
                ButtonWidget(text: "Update", onPressed: controller.updateProfile
                  ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}



