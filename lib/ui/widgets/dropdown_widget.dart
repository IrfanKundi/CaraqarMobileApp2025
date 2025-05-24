import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DropdownWidget extends StatelessWidget {
  final void Function(dynamic)? onChanged;
  final String? hint;
  final String? Function(dynamic)? validator;
  final List<DropdownMenuItem<dynamic>> items;
  final value;
  final borderRadius;
  const DropdownWidget({Key? key, this.value, this.hint,this.borderRadius,  this.validator, required this.items, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      style: kTextFieldStyle,
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        fillColor: kWhiteColor, filled: true,
        border: InputBorder.none,contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
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
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      hint: Text(
        (hint ?? '').tr,
        style: kHintStyle,
      ),
      isExpanded: true,
      elevation: 0,
      validator: validator,

      onChanged: onChanged,
      items: items,
      value: value,
    );
  }
}
