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
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';

class ChooseBrandScreen extends GetView<VehicleController> {
  ChooseBrandScreen({super.key}) {
    if (controller.vehicleType == null) {
      controller.vehicleType = VehicleType.Car; // default fallback
    }
    final typeStr = EnumToString.convertToString(controller.vehicleType);
    Get.put(BrandController()).getBrands(typeStr);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Padding(
              padding: kHorizontalScreenPadding,
              child: CupertinoSearchTextField(
                onChanged: (val) => brandController.search(val),
                placeholder: "Search".tr,
              ),
            ),
            Expanded(
              child: brandController.searchedBrands.isEmpty
                  ? Center(
                child: Text("NoDataFound".tr, style: kTextStyle16),
              )
                  : ListView.separated(
                shrinkWrap: true,
                padding: kScreenPadding,
                itemCount: brandController.searchedBrands.length,
                separatorBuilder: (context, index) => kVerticalSpace12,
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? kLightBlueColor : null,
                        border: Border.all(
                          color: isSelected ? kLightBlueColor : kGreyColor,
                        ),
                        borderRadius: kBorderRadius12,
                      ),
                      padding: EdgeInsets.all(8.w),
                      child: Row(
                        children: [
                          ImageWidget(item.image, width: 40.w, height: 40.w),
                          kHorizontalSpace12,
                          Expanded(
                            child: Text(
                              item.brandName!,
                              style: TextStyle(
                                color: kBlackColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 15.sp,
                              ),
                            ),
                          ),
                          if (isPriority)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Popular",
                                style: TextStyle(
                                  color: Colors.orange.shade800,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
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

