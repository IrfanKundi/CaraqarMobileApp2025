import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/add_property_controller.dart';
import 'package:careqar/models/property_model.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/text_button_widget.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class AddFeaturesScreen extends GetView<AddPropertyController> {
  const AddFeaturesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: "AddFeatures", actions: [
        TextButtonWidget(
          text: "Done",
          onPressed: () {
            controller.featuresFormKey.value.currentState?.save();
            Get.back();
          },
        )
      ]),
      body: GetBuilder<AddPropertyController>(
        builder: (controller) => controller.featureModel.value.featureHeads.isNotEmpty
            ? Form(
            key: controller.featuresFormKey.value,
            child: ListView.separated(
              itemBuilder: (context, index) {
                var item = controller.featureModel.value.features[index];

                if (item.requireQty!) {
                  return ListTile(
                    dense: true,
                    title: Text(item.title!, style: kTextStyle14),
                    trailing: Container(
                      width: 0.5.sw,
                      height: 30.h,
                      child: TextFieldWidget(
                          text: controller.property.features
                              .firstWhereOrNull((element) => element.featureId == item.featureId)
                              ?.quantity?.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (String val) {
                            var x = controller.property.features
                                .firstWhereOrNull((element) => element.featureId == item.featureId);
                            if (x != null) {
                              if (val.trim() != "") {
                                x.quantity = int.parse(val);
                              } else {
                                controller.property.features.remove(x);
                              }
                            } else {
                              if (val.trim() != "") {
                                var f = PropertyFeature();
                                f.quantity = int.parse(val);
                                f.headId = item.headId;
                                f.featureAr = item.titleAr;
                                f.featureEn = item.titleEn;
                                f.featureId = item.featureId;
                                controller.property.features.add(f);
                              }
                            }
                          }
                      ),
                    ),
                  );
                } else if (item.options!.isNotEmpty) {
                  // Convert dropdown to checkboxes
                  List<String> options = item.options!.split(",");

                  // Get currently selected options for this feature
                  List<String> selectedOptions = controller.property.features
                      .where((element) => element.featureId == item.featureId)
                      .map((e) => e.featureOption ?? "")
                      .where((option) => option.isNotEmpty)
                      .toList();

                  return ListTile(
                    dense: true,
                    title: Text(item.title!, style: kTextStyle14),
                    trailing: Container(
                      width: 0.5.sw,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: options.map((option) {
                          bool isSelected = selectedOptions.contains(option);

                          return Padding(
                            padding: EdgeInsets.only(left: 8.w),
                            child: GestureDetector(
                              onTap: () {
                                if (isSelected) {
                                  // Remove this option
                                  controller.property.features.removeWhere(
                                          (element) =>
                                      element.featureId == item.featureId &&
                                          element.featureOption == option
                                  );
                                } else {
                                  // Add this option
                                  var f = PropertyFeature();
                                  f.headId = item.headId;
                                  f.featureAr = item.titleAr;
                                  f.featureEn = item.titleEn;
                                  f.featureOption = option;
                                  f.featureId = item.featureId;
                                  controller.property.features.add(f);
                                }
                                controller.update();
                              },
                              child: Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected ? kAccentColor : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected ? kAccentColor : kGreyColor,
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.check,
                                  size: 16.sp,
                                  color: isSelected ? Colors.white : Colors.transparent,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                } else {
                  return ListTile(
                    dense: true,
                    title: Text(item.title!, style: kTextStyle14),
                    onTap: () {
                      var x = controller.property.features.firstWhere(
                              (element) => element.featureId == item.featureId,
                          orElse: () => null!
                      );

                      if (x != null) {
                        controller.property.features.remove(x);
                      } else {
                        var f = PropertyFeature();
                        f.headId = item.headId;
                        f.featureAr = item.titleAr;
                        f.featureEn = item.titleEn;
                        f.featureId = item.featureId;
                        controller.property.features.add(f);
                      }

                      controller.update();
                    },
                    trailing: Icon(
                      MaterialCommunityIcons.check_circle,
                      size: 20.sp,
                      color: controller.property.features.any((element) => element.featureId == item.featureId)
                          ? kAccentColor
                          : kGreyColor,
                    ),
                  );
                }
              },
              separatorBuilder: (context, index) {
                return kVerticalSpace12;
              },
              itemCount: controller.featureModel.value.features.length,
              shrinkWrap: true,
            )
        )
            : Center(child: Text("NoDataFound".tr, style: kTextStyle16)),
      ),
    );
  }
}


//
// GetBuilder<AddPropertyController>(
// builder: (controller)=>controller.featureModel.value.featureHeads.isNotEmpty?
// Form(
// key: controller.featuresFormKey.value,
// child: Column(
// children: [
// ExpansionPanelList(
// elevation: 0,
// animationDuration: Duration(milliseconds: 800),
// children: List.generate(controller.featureModel.value.featureHeads.length,
// (index){
// var head=controller.featureModel.value.featureHeads[index];
// return    ExpansionPanel(backgroundColor:kBgColor,
// headerBuilder: (context, isExpanded) {
// return  ListTile(
// title: Text(head.title, style: kTextStyle16,));
//
// },
// body:ListView.separated(itemBuilder: (context,featureIndex){
// var item=head.features[featureIndex];
// if(item.requireQty){
// return ListTile(
// dense: true,
// title:Text(item.title,style: kTextStyle14,),
// trailing: Container(
// width: 0.5.sw,
// height: 30.h,
// child: TextFieldWidget(
// text: controller.property.features.firstWhere((element) => element.featureId==item.featureId,orElse: ()=>null)?.quantity?.toString(),
// keyboardType: TextInputType.number,
// onChanged: (String val) {
// var x = controller.property.features
//     .firstWhere((element) =>
// element.featureId == item.featureId,
// orElse: () => null);
// if (x != null) {
// if (val.trim() != "") {
// x.quantity = int.parse(val);
// } else {
// controller.property.features.remove(x);
// }
// } else {
// if (val.trim() != "") {
// var f = PropertyFeature();
//
// f.quantity = int.parse(val);
// f.headId = head.headId;
// f.headAr = head.titleAr;
// f.headEn = head.titleEn;
// f.featureAr = item.titleAr;
// f.featureEn = item.titleEn;
// f.featureId = item.featureId;
// controller.property.features.add(f);
// }
// }
// }
// ),
// ),
// );
//
// }else if(item.options.isNotEmpty){
//
// return ListTile(
// dense: true,
// title: Text(item.title,style: kTextStyle14,),
// trailing: Container(
// width: 0.5.sw,
// height: 30.h,
// child: DropdownWidget(
// value: controller.property.features.firstWhere((element) => element.featureId==item.featureId,orElse: ()=>null)?.featureOption,
// onChanged: (val){
// var x = controller.property.features.firstWhere((element) => element.featureId==item.featureId,orElse: ()=>null);
//
// if(x!=null){
// x.featureOption=val;
// }else{
// var f=PropertyFeature();
//
// f.headId=head.headId;
// f.headAr = head.titleAr;
// f.headEn = head.titleEn;
// f.featureAr = item.titleAr;
// f.featureEn = item.titleEn;
// f.featureOption=val;
// f.featureId=item.featureId;
// controller.property.features.add(f);
// }
//
// controller.update();
// },
// hint: "SelectOption",
// items: item.options.split(",").map((e) => DropdownMenuItem(child: Text(e,style: kTextStyle14,),value: e,)).toList(),
// ),
// ),
// );
// }else {
// return ListTile(
// dense: true,
// title: Text(item.title,style: kTextStyle14,),
// onTap: (){
//
// var x = controller.property.features.firstWhere((element) => element.featureId==item.featureId,orElse: ()=>null);
//
// if(x!=null){
// controller.property.features.remove(x);
// }else{
// var f=PropertyFeature();
//
// f.headId=head.headId;
// f.headAr = head.titleAr;
// f.headEn = head.titleEn;
// f.featureAr = item.titleAr;
// f.featureEn = item.titleEn;
// f.featureId=item.featureId;
// controller.property.features.add(f);
// }
//
// controller.update();
//
// },
// trailing: Icon(MaterialCommunityIcons.check_circle,size: 20.sp,color: controller.property.features.any((element) => element.featureId==item.featureId)? kAccentColor: kGreyColor,),
// );
// }
// }, separatorBuilder: (context,index){
// return kVerticalSpace12;
// }, itemCount: head.features.length,
//
// shrinkWrap:
// true,),
// isExpanded: controller.expansionIndexes[index],
// canTapOnHeader: true,
// );}
// ),
// dividerColor: Colors.grey,
// expansionCallback: (panelIndex, isExpanded) {
// controller.expansionIndexes[panelIndex] = !isExpanded;
// controller.update();
// },
// ),
// ],
// ),
// ):
// Center(child: Text("NoDataFound".tr,style: kTextStyle16,))
// ,
// )
