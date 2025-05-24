import 'package:careqar/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../constants/colors.dart';

class TextFieldWidget extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final bool obscureText;
  final keyboardType;
  final borderRadius;
  final textInputAction;
  final Function(String)? onChanged;
  final Function()? onTap;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final int maxLines;
  final maxLength;
  final TextAlign textAlign;
  final text;
  final width;
  final suffixIcon;
  final prefixIcon;
  final readonly;
  final inputFormatters;
  final bool isRight;
  final enabled;
  const TextFieldWidget(
      {Key? key, this.enabled = true,
      this.inputFormatters,
      this.isRight = false,
      this.prefixIcon,
      this.readonly = false,
      this.labelText,
      this.suffixIcon,
      this.width,
        this.borderRadius,
      this.textAlign=TextAlign.start,
      this.text,
      this.maxLength,
      this.maxLines = 1,
      this.hintText,
      this.obscureText = false,
      this.keyboardType,
      this.textInputAction,
      this.validator,
      this.onChanged,
      this.onTap,
      this.onSaved}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: text!=""?TextEditingController(text: text):null,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      style: kTextFieldStyle,
      textInputAction: textInputAction ?? TextInputAction.next,
      keyboardType: keyboardType,
      validator: validator,
      onTap: onTap,
      readOnly: readonly,
      onSaved: onSaved,
      textAlign: textAlign,
      cursorColor: kAccentColor,
      cursorHeight: 20.h,
      maxLines: maxLines,
      cursorWidth: 1.3,
      onChanged: onChanged,
      focusNode: onTap != null ? NeverFocusNode() : null,
      decoration: InputDecoration(
          contentPadding: maxLines > 1
              ? EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.w)
              : prefixIcon != null
                  ? EdgeInsets.symmetric(horizontal: 8.w).copyWith(top: 15.w)
                  : EdgeInsets.symmetric(horizontal: 8.w),
          hintText: hintText?.tr,
          labelText: labelText?.tr,
          hintStyle: kHintStyle,
          suffixIcon: suffixIcon,

          prefixIcon: prefixIcon,
          filled: true,
          fillColor: kWhiteColor,
          errorStyle: kErrorStyle,
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kSuccessColor,width: 1.w),
            borderRadius: borderRadius??kBorderRadius30,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300,width: 1.w),
            borderRadius:borderRadius?? kBorderRadius30,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kSuccessColor,width: 1.w),
            borderRadius:borderRadius?? kBorderRadius30,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red,width: 1.w),
            borderRadius: borderRadius?? kBorderRadius30,
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color:Colors.grey.shade300,width: 1.w),
            borderRadius: borderRadius??kBorderRadius30,
          ),
          labelStyle: kHintStyle),
    );
  }
}

class NeverFocusNode extends FocusNode {
  @override
  bool get hasFocus {
    return false;
  }
}
