
import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneNumberTextField extends StatelessWidget {

  final String? hintText;
  final String? labelText;
  final void Function(PhoneNumber)? onChanged;
  final PhoneNumber? value;
  final BorderRadius? borderRadius;
  const PhoneNumberTextField({
    Key? key,
    this.hintText,
    this.labelText,
    this.borderRadius,
     this.value,this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Directionality(
      textDirection: TextDirection.ltr,
      child: InternationalPhoneNumberInput(selectorTextStyle: kTextFieldStyle,

       cursorColor: kAccentColor,
        selectorConfig: const SelectorConfig(
          setSelectorButtonAsPrefixIcon: true,
          selectorType: PhoneInputSelectorType.DIALOG,
          showFlags: false
        ),
        spaceBetweenSelectorAndTextField: 0,
        inputDecoration: InputDecoration(

          contentPadding:  EdgeInsets.symmetric(horizontal: 8.w),
          hintText: hintText?.tr,
          labelStyle: kHintStyle,
          labelText: labelText?.tr,
          hintStyle: kHintStyle,
          filled: true,
          fillColor: kWhiteColor,
          errorStyle: kErrorStyle,
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kSuccessColor,width: 1.w),
            borderRadius:borderRadius?? kBorderRadius30,
          ) ,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300,width: 1.w),
            borderRadius:borderRadius??  kBorderRadius30,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300,width: 1.w),
            borderRadius:borderRadius??  kBorderRadius30,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red,width: 1.w),
            borderRadius:borderRadius??  kBorderRadius30,
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color:Colors.grey.shade300,width: 1.w),
            borderRadius:borderRadius??  kBorderRadius30,
          ),

        ),
        initialValue: value,textAlign:TextAlign.start,
        textStyle: kTextFieldStyle,
        errorMessage: kInvalidPhoneNumberMsg.tr,
        onInputChanged: onChanged,
      ),
    );
  }
}
