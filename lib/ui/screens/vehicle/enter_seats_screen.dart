import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';
import '../../widgets/dropdown_widget.dart';

class EnterSeatsScreen extends GetView<VehicleController> {
   EnterSeatsScreen({Key? key}) : super(key: key);

  final formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: buildAppBar(context,title: "Seats"),
      body:  Padding(
        padding: kScreenPadding,
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GetBuilder<VehicleController>(
                  id: "seats",

                  builder:(controller)=>    DropdownWidget(hint: "NoOfSeats",value:
                  controller.seats,onChanged: (val){
                    controller.seats=val;
                    controller.update(["seats"]);
                  },validator: (value) => value == null ? kRequiredMsg.tr: null,
                    items: [DropdownMenuItem(child: Text("2".tr),value: 2,),
                      DropdownMenuItem(child: Text("4".tr),value: 4,),
                      DropdownMenuItem(child: Text("6".tr),value: 6,),
                      DropdownMenuItem(child: Text("8".tr),value: 8,),
                    ],
                  )),

              kVerticalSpace16,

              ButtonWidget(text: "Next", onPressed: (){
                if(formKey.currentState!.validate()){
    if(Get.arguments==true){
     Navigator.pop(context);
    }else{
      Get.toNamed(Routes.reviewAdScreen);
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
