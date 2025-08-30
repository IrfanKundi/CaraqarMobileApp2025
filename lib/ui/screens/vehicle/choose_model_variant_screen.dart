import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/brand_controller.dart';
import 'package:careqar/controllers/vehicle_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';

class ChooseModelVariantScreen extends GetView<VehicleController> {
  const ChooseModelVariantScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Load variants when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.model != null) {
        Get.find<BrandController>().getVariants(controller.model!.modelId);
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: buildAppBar(context, title: "Choose Variant"),
      body: GetBuilder<BrandController>(
        builder: (brandController) => brandController.variantsStatus.value == Status.loading
            ? CircularLoader()
            : brandController.variantsStatus.value == Status.error
            ? Text(
          kCouldNotLoadData.tr,
          style: kTextStyle16,
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
                        onChanged: (val) => brandController.searchVariant(val),
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

            // Variants List
            Expanded(
              child: brandController.searchedVariants.isEmpty
                  ? Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        "NoDataFound".tr,
                        style: kTextStyle16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: InkWell(
                      onTap: () {
                        controller.modelVariant = null;
                        Get.toNamed(Routes.chooseModelYearScreen);
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        margin: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: kLightBlueColor,
                          border: Border.all(
                            color: kLightBlueColor,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          "Continue".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  : ListView.separated(
                padding: EdgeInsets.all(16),
                itemCount: brandController.searchedVariants.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 12);
                },
                itemBuilder: (context, index) {
                  var item = brandController.searchedVariants[index];
                  bool isSelected = controller.modelVariant == item.variantId;

                  return InkWell(
                    onTap: () {
                      controller.modelVariant = item.variantId;
                      if (Get.arguments == true) {
                        Navigator.pop(context, item);
                      } else {
                        //Get.toNamed(Routes.chooseModelYearScreen);
                        Get.toNamed(Routes.selectOriginScreen);
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
                          SizedBox(height: 40),
                          Expanded(
                            child: Text(
                              item.variantName!,
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