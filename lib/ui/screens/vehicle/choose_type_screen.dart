import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/type_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';

class ChooseTypeScreen extends GetView<VehicleController> {
  ChooseTypeScreen({super.key}) {
    Get.put(TypeController()). getTypes(
      vehicleType: EnumToString.convertToString(controller.vehicleType),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: buildAppBar(context, title: "ChooseType"),
      body: GetBuilder<TypeController>(
        builder:
            (typeController) =>
        typeController.typesStatus.value == Status.loading
            ? CircularLoader()
            : typeController.typesStatus.value == Status.error
            ? Text(kCouldNotLoadData, style: kTextStyle16)
            : Column(
          children: [
            // Search Field
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.search,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (val) => typeController.search(val),
                        decoration: InputDecoration(
                          hintText: "Search".tr,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            ),

            // Types List
            Expanded(
              child:
              typeController.searchedTypes.isEmpty
                  ? Center(
                child: Text(
                  "NoDataFound".tr,
                  style: kTextStyle16,
                ),
              )
                  : ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.all(16),
                itemCount:
                typeController.searchedTypes.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 12);
                },
                itemBuilder: (context, index) {
                  var item =
                  typeController.searchedTypes[index];
                  bool isSelected = controller.typeId == item.typeId;

                  return InkWell(
                    onTap: () {
                      controller.type = item;
                      if (Get.arguments == true) {
                        Navigator.pop(context, item);
                      } else {
                        Get.toNamed(
                            Routes.selectConditionScreen
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: isSelected ? kLightBlueColor : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                              ? kLightBlueColor
                              : Colors.grey.shade200,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            child: ImageWidget(
                              item.image,
                              width: 24,
                              height: 24,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.type!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(
                            Get.locale?.languageCode == "ar"
                                ? MaterialCommunityIcons.chevron_left
                                : MaterialCommunityIcons.chevron_right,
                            color: isSelected
                                ? Colors.white.withOpacity(0.7)
                                : Colors.grey.shade400,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
