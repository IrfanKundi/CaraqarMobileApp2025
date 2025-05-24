
import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/locale/app_localizations.dart';
import 'package:careqar/ui/widgets/remove_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import 'icon_button_widget.dart';


showLangBottomSheet(BuildContext context) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const Languages();
      });
}

class Languages extends StatefulWidget {
  const Languages({Key? key}) : super(key: key);

  @override
  _LanguagesState createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1.sw,
        height: 0.3.sh,

      decoration: BoxDecoration(
          color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(12.r)
        )
      ),
      padding: kScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Language".tr,

                    style: TextStyle(
                        fontSize: 18.sp,
                        color: kBlackColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                IconButtonWidget(icon: MaterialCommunityIcons.close,
                  color: kBlackColor,onPressed: (){
                  Navigator.pop(context);
                },),
              ],
            ),
            kVerticalSpace12,
            Expanded(
              child: RemoveSplash(
                child: ListView.builder(

                  shrinkWrap: true,
                  itemBuilder: (context,index){
                    return    ListTile(
                      contentPadding: EdgeInsets.zero,
                        title: Text(
                          "${supportedLocales[index].name}".tr,
                          style: kTextStyle16,
                        ),
                        trailing: Transform.scale(
                          scale: 1.3,
                          child: Radio<int>(
                            value: supportedLocales[index].langCode!,
                            groupValue: gSelectedLocale?.langCode,
                            onChanged: (val)async{

                              await AppLocalizations.setLocale(supportedLocales[index]);

                             Get.back();




                            },
                          ),
                        ),
                      );
                  },itemCount: supportedLocales.length,),
              ),
            )

          ],
        ),
      )
    ;
  }
}
