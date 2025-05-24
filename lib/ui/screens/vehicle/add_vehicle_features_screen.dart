import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/vehicle_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/models/car_model.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/dropdown_widget.dart';
import 'package:careqar/ui/widgets/text_button_widget.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../constants/strings.dart';
import '../../widgets/circular_loader.dart';

class AddVehicleFeaturesScreen extends GetView<VehicleController> {
   AddVehicleFeaturesScreen({Key? key}) : super(key: key){
    controller.getFeatures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context,title: "AddFeatures",actions: [
        TextButtonWidget(text: "Done",onPressed: (){
          controller.featuresFormKey.value.currentState?.save();
        Navigator.pop(context);
        },)
      ]),
      body:

      GetBuilder<VehicleController>(
        builder: (controller)=>
        controller
            .featuresStatus.value ==
            Status.loading
            ? CircularLoader():

        controller.featuresStatus.value ==
            Status.error
            ? Center(
          child: Text(kCouldNotLoadData,
              style: kTextStyle16),
        )
            :


        controller.featureModel.value.featureHeads.isNotEmpty?
         Form(
           key: controller.featuresFormKey.value,
           child: ListView.separated(itemBuilder: (context,index){
                      var item=controller.featureModel.value.features[index];
                      if(item.requireQty!){
                        return ListTile(
                          dense: true,
                          title:Text(item.title!,style: kTextStyle14,),
                          trailing: SizedBox(
                            width: 0.5.sw,
                            height: 30.h,
                            child: TextFieldWidget(
                                text: controller.vehicleFeatures.firstWhere((element) => element.featureId==item.featureId,orElse: ()=>null!).quantity?.toString(),
                                keyboardType: TextInputType.number,
                                onChanged: (String val) {
                                  var x = controller.vehicleFeatures
                                      .firstWhere((element) =>
                                  element.featureId == item.featureId,
                                      orElse: () => null!);
                                  if (x != null) {
                                    if (val.trim() != "") {
                                      x.quantity = int.parse(val);
                                    } else {
                                      controller.vehicleFeatures.remove(x);
                                    }
                                  } else {
                                    if (val.trim() != "") {
                                      var f = VehicleFeature();

                                      f.quantity = int.parse(val);
                                      f.headId = item.headId;
                                      f.featureAr = item.titleAr;
                                      f.featureEn = item.titleEn;
                                      f.featureId = item.featureId;
                                      controller.vehicleFeatures.add(f);
                                    }
                                  }
                                }
                            ),
                          ),
                        );
                      }
                      else if(item.options!.isNotEmpty){
                        return ListTile(
                          dense: true,
                          title: Text(item.title!,style: kTextStyle14,),
                          trailing: SizedBox(
                            width: 0.5.sw,
                            height: 30.h,
                            child: DropdownWidget(
                              value: controller.vehicleFeatures.firstWhere((element) => element.featureId==item.featureId,orElse: ()=>null!).featureOption,
                              onChanged: (val){
                                var x = controller.vehicleFeatures.firstWhere((element) => element.featureId==item.featureId,orElse: ()=>null!);

                                if(x!=null){
                                  x.featureOption=val;
                                }else{
                                  var f=VehicleFeature();

                                  f.headId=item.headId;
                                  f.featureAr = item.titleAr;
                                  f.featureEn = item.titleEn;
                                  f.featureOption=val;
                                  f.featureId=item.featureId;
                                  controller.vehicleFeatures.add(f);
                                }

                                controller.update();
                              },
                              hint: "SelectOption",
                              items: item.options!.split(",").map((e) => DropdownMenuItem(child: Text(e,style: kTextStyle14,),value: e,)).toList(),
                            ),
                          ),
                        );
                      }
                      else {
                        return ListTile(
                          dense: true,
                          title: Text(item.title!,style: kTextStyle14,),
                          onTap: (){

                            var existingFeature = controller.vehicleFeatures.firstWhereOrNull(
                                  (element) => element.featureId == item.featureId
                            );

                            if (existingFeature != null) {
                              controller.vehicleFeatures.remove(existingFeature);
                            } else {
                              var newFeature = VehicleFeature()
                                ..headId = item.headId
                                ..featureAr = item.titleAr
                                ..featureEn = item.titleEn
                                ..featureId = item.featureId;

                              controller.vehicleFeatures.add(newFeature);
                            }

                            controller.update();

                          },
                          trailing: Icon(MaterialCommunityIcons.check_circle,size: 20.sp,color: controller.vehicleFeatures.any((element) => element.featureId==item.featureId)? kAccentColor: kGreyColor,),
                        );
                      }
                    },
             separatorBuilder: (context,index){
                      return kVerticalSpace12;
                    },
             itemCount: controller.featureModel.value.features.length,

                      shrinkWrap:
                      true,)



         ):
        Center(child: Text("NoDataFound".tr,style: kTextStyle16,))
        ,
      )
    );
  }
}

