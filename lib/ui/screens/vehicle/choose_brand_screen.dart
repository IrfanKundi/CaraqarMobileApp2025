import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/brand_controller.dart';
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

class ChooseBrandScreen extends GetView<VehicleController> {
  ChooseBrandScreen({super.key}) {
    try{
      final VehicleType? passedVehicleType = Get.arguments as VehicleType?;

      if (passedVehicleType != null) {
        controller.vehicleType = passedVehicleType;
      } else if (controller.vehicleType == null) {
        controller.vehicleType = VehicleType.Car; // fallback
      }

      debugPrint('Selected vehicle type: ${controller.vehicleType.toString()}');
      final typeStr = EnumToString.convertToString(controller.vehicleType);
      debugPrint('Selected vehicle type: $typeStr');
      Get.put(BrandController()).getBrands(typeStr);
    }catch (e){
      if (controller.vehicleType == null) {
        controller.vehicleType = VehicleType.Car; // default fallback
      }
      final typeStr = EnumToString.convertToString(controller.vehicleType);
      debugPrint('Selected vehicle type: $typeStr');
      Get.put(BrandController()).getBrands(typeStr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: buildAppBar(context, title: "ChooseBrand"),
      body: GetBuilder<BrandController>(
        builder: (brandController) => brandController.brandsStatus.value == Status.loading
            ? CircularLoader()
            : brandController.brandsStatus.value == Status.error
            ? Center(
          child: Text(kCouldNotLoadData.tr, style: kTextStyle16),
        )
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
                        onChanged: (val) => brandController.search(val),
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

            // Brands List
            Expanded(
              child: brandController.searchedBrands.isEmpty
                  ? Center(
                child: Text("NoDataFound".tr, style: kTextStyle16),
              )
                  : ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.all(16),
                itemCount: brandController.searchedBrands.length,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = brandController.searchedBrands[index];
                  final isSelected = controller.brandId == item.brandId;
                  final isPriority = ['Toyota', 'Honda', 'Suzuki'].contains(item.brandName);

                  return InkWell(
                    onTap: () {
                      controller.brand = item;
                      controller.brandId = item.brandId!;
                      if (Get.arguments == false) {
                        Navigator.pop(context, item);
                      } else {
                        brandController.getModels(item.brandId!);
                        Get.toNamed(Routes.chooseModelScreen, arguments: Get.arguments);
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
                                height: 24
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.brandName!,
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
                          SizedBox(width: 12),
                          if (isPriority)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white.withOpacity(0.2)
                                    : Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "Popular",
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.orange.shade800,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
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

