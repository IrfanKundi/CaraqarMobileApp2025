import 'package:careqar/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class TextButtonWidget extends StatelessWidget {

  final IconData? icon;
  final Function()? onPressed;
  final Color color;
  final Color iconColor;
  final String? text;
  final bool rightIcon;


  const TextButtonWidget({Key? key,this.iconColor=kPrimaryColor,this.rightIcon=false,this.onPressed,@required this.text,this.color=kAccentColor,this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(icon==null){
      return TextButton(
        onPressed: onPressed,
        child:Text(text!.tr,
        ),
        style: TextButton.styleFrom(
            foregroundColor: color, padding: EdgeInsets.zero,
            textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: color)),
      );
    }else{
     return rightIcon?
       Row(mainAxisSize: MainAxisSize.min,
        children: [

          TextButton(
            onPressed: onPressed,
            child:Text(text!.tr,style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: kPrimaryColor),),
          ),
          Icon(icon,size: 18.sp,color: onPressed!=null? iconColor:kDisabledColor,)
        ],
      ): Row(mainAxisSize: MainAxisSize.min,
       children: [
         Icon(icon,size: 18.sp,color: onPressed!=null? iconColor:kDisabledColor,),
         TextButton(
           onPressed: onPressed,
           child:Text(text!.tr),
             style: TextButton.styleFrom(
                 foregroundColor: color,
                 padding: EdgeInsets.zero,
                 textStyle: TextStyle(
                     fontWeight: FontWeight.w600,
                     fontSize: 14.sp,
                     color: color))
         ),

       ],
     );


    }

  }
}
