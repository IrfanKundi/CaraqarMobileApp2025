import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';
import '../../widgets/text_field_widget.dart';

class EnterNumberScreen extends GetView<VehicleController> {
   EnterNumberScreen({Key? key}) : super(key: key);

  final formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: buildAppBar(context,title: "EnterNumber"),
      body:  Padding(
        padding: kScreenPadding,
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFieldWidget(hintText: "Number",
                text: controller.number,
                onChanged: (String val){

                  controller.number=val;


                }, onSaved: (String? val){

                  controller.number=val;


                },
                validator: (String? val){
                  if(val!.trim().isEmpty) {
                    return kRequiredMsg.tr;
                  } else {
                    return null;
                  }
                },),

              kVerticalSpace16,

              ButtonWidget(text: "Next", onPressed: (){
                if(formKey.currentState!.validate()){
                  formKey.currentState!.save();
                  if(Get.arguments==true){
                    Navigator.pop(context);
    }else {
                    Get.offNamed(Routes.selectPlateDigitsScreen);
                  }
                }

              })
            ],
          ),
        ),
      ),
    );
  }
}
