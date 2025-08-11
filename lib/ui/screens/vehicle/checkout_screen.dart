import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/checkout_controller.dart';
import 'package:careqar/controllers/profile_controller.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/models/city_model.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../widgets/cities_bottom_sheet.dart';
import '../../widgets/phone_number_text_field.dart';

class CheckoutScreen extends GetView<CheckoutController> {
    CheckoutScreen({Key? key}) : super(key: key){
      controller.totalPrice=Get.arguments;
      var user=Get.find<ProfileController>().user.value;
      controller.firstName=user.firstName;
      controller.lastName=user.lastName;
      controller.phoneNumber=(user.phoneNumber==null?controller.phoneNumber:user.phoneNumber?.isoCode==null|| user.phoneNumber?.isoCode==""?controller.phoneNumber:user.phoneNumber)!;
      controller.email=user.email;
    }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBar(context,title: "Checkout")
      ,
      body: SingleChildScrollView(
        padding: kVerticalScreenPadding,
        child: Form(
          key:controller.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              kVerticalSpace12,
              Container(
                padding: EdgeInsets.symmetric(vertical: 8.w,horizontal: 16.w),
                child: Column(
                  children: [
                    TextFieldWidget(
                      text: controller.firstName,
                      labelText: "FirstName",
                      onChanged: (String val){
                        controller.firstName=val.trim();
                      },
                      validator: (String? val){
                        val=val!.trim();
                        if(val.isEmpty)
                          return kRequiredMsg.tr;
                        else
                          return null;
                      },
                    )
                    ,kVerticalSpace12,
                    TextFieldWidget(
                      text: controller.lastName,
                      labelText: "LastName",
                      onChanged: (String val){
                        controller.lastName=val.trim();
                      },
                      validator: (String? val){
                        val=val!.trim();
                        if(val.isEmpty)
                          return kRequiredMsg.tr;
                        else
                          return null;
                      },
                    )
                    ,kVerticalSpace12,
                    PhoneNumberTextField(value: controller.phoneNumber,
                      labelText: "PhoneNumber",
                      onChanged: (PhoneNumber val){
                        controller.phoneNumber=val;
                      },
                    ),
                    kVerticalSpace12,
                    TextFieldWidget(
                      text: controller.email,
                      labelText: "EmailAddress",
                      onChanged: (String val){
                        controller.email=val.trim();
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
                    kVerticalSpace12,

                    GetBuilder<CheckoutController>(builder:(controller)=> TextFieldWidget(hintText: "SearchCity",onTap: ()async{
                      var result =  await showCitiesSheet(context) as City;
                      if(result!=null){
                        controller.city=result;
                        controller.update();
                      }
                    },   labelText: "City",
                         validator: (String? val){
                        val=val!.trim();
                        if(val.isEmpty)
                          return kRequiredMsg.tr;
                        else
                          return null;
                      },
                      text: controller.city?.name,
                    )),

                  kVerticalSpace12,
              TextFieldWidget(
              text: controller.zipCode,
                  labelText: "ZipCode",
                  onChanged: (String val){
          controller.zipCode=val.trim();
          },
            validator: (String? val){
              val=val!.trim();
              if(val.isEmpty)
                return kRequiredMsg.tr;
              else
                return null;
            },
          ),

                    kVerticalSpace12,

                    TextFieldWidget(
                      text: controller.address,
                      labelText: "Address",
                      maxLines: 2,
                      textInputAction: TextInputAction.newline,
                      onChanged: (String val){
                        controller.address=val.trim();
                      },
                      validator: (String? val){
                        val=val!.trim();
                        if(val.isEmpty)
                          return kRequiredMsg.tr;
                        else
                          return null;
                      },
                    ),
                    kVerticalSpace12,
                    GetBuilder<CheckoutController>(builder:(controller)=> TextFieldWidget(

                      hintText: "SelectLocation",onTap: ()async{
                        if(Get.focusScope!=null){
                          Get.focusScope?.unfocus();
                        }


                    },   labelText: "LocationFromMap",
                      validator: (String? val){
                        val=val!.trim();
                        if(val.isEmpty)
                          return kRequiredMsg.tr;
                        else
                          return null;
                      },
                      text: controller.coordinates,
                    )),


                  ],
                ),
              )
              ,

              Container(color: kBgColor,
                width: 1.sw,
                padding:kScreenPadding,

                child:  Row(
                  children: [

                    Expanded(child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text("${"Total".tr} ${getPrice(controller.totalPrice!)}",style: kTextStyle18,))),

                    kHorizontalSpace12,
                    Expanded(
                      child:  ButtonWidget(onPressed: controller.placeOrder,text: "PlaceOrder",

                      ),
                    )
                  ],
                ),  )



            ],
          ),
        ),

      ),
    );
  }



}

