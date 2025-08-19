import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/brand_controller.dart';
import 'package:careqar/controllers/vehicle_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      appBar: buildAppBar(context, title: "ChooseModelVariant"),
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
            Padding(
              padding: kHorizontalScreenPadding,
              child: CupertinoSearchTextField(
                onChanged: (val) => brandController.searchVariant(val),
                placeholder: "Search".tr,
              ),
            ),
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
                        controller.ModelVariant = null;
                        Get.toNamed(Routes.chooseModelYearScreen);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        margin: kScreenPadding,
                        decoration: BoxDecoration(
                          color: kLightBlueColor,
                          border: Border.all(
                            color: kLightBlueColor,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Continue".tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: kBlackColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  : ListView.separated(
                padding: kScreenPadding,
                itemCount: brandController.searchedVariants.length,
                separatorBuilder: (context, index) {
                  return kVerticalSpace12;
                },
                itemBuilder: (context, index) {
                  var item = brandController.searchedVariants[index];
                  return InkWell(
                    onTap: () {
                      controller.ModelVariant = item.variantId;
                      if (Get.arguments == true) {
                        Navigator.pop(context, item);
                      } else {
                        Get.toNamed(Routes.chooseModelYearScreen);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller.ModelVariant == item.variantId
                            ? kLightBlueColor
                            : null,
                        border: Border.all(
                          color: controller.ModelVariant == item.variantId
                              ? kLightBlueColor
                              : kGreyColor,
                        ),
                        borderRadius: kBorderRadius12,
                      ),
                      padding: EdgeInsets.all(8.w),
                      child: Text(
                        item.variantName!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kBlackColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                        ),
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