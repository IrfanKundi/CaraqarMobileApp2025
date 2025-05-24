import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';
import '../../widgets/text_field_widget.dart';

class EnterMileageScreen extends GetView<VehicleController> {
   EnterMileageScreen({Key? key}) : super(key: key);

  final formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: buildAppBar(context,title: "EnterMileage"),
      body:  Padding(
        padding: kScreenPadding,
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFieldWidget(hintText: "Mileage(KM)",
                text: controller.mileage,
                keyboardType: TextInputType.number,
                onChanged: (String val){

                  controller.mileage=val;


                },onSaved: (String? val){

                  controller.mileage=val;


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
                    Get.toNamed(Routes.enterEngineScreen);
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
