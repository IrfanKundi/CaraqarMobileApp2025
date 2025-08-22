import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/brand_controller.dart';
import 'package:careqar/controllers/car_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/models/type_model.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/dropdown_widget.dart';
import 'package:careqar/ui/widgets/text_button_widget.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';
import '../../../models/brand_model.dart';

class CarFilterScreen extends GetView<VehicleController> {
  const CarFilterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        controller.carController.resetFilters();
        return Future.value(true);
      },
      child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: buildAppBar(context, title: "Filters"),
          body: GetBuilder<CarController>(
              id: "filter",
              builder: (controller) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                          padding: EdgeInsets.all(16),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                // Select Province
                                _buildFilterItem(
                                  icon: Icons.location_on_outlined,
                                  title: 'Select Province'.tr,
                                  selectedValue: controller.selectedCity?.name ?? 'Select Province'.tr,
                                  onTap: () async {
                                    var result = await Get.toNamed(Routes.selectCityScreen, arguments: true);
                                    if (result != null && result is Map) {
                                      controller.selectedCity = result['city'];
                                      controller.selectedLocation = result['location'];
                                      controller.update(["filter"]);
                                    }
                                  },
                                ),

                                SizedBox(height: 12),

                                // Select City
                                _buildFilterItem(
                                  icon: Icons.location_city_outlined,
                                  title: "City".tr,
                                  selectedValue: controller.selectedLocation?.title ?? 'Select City'.tr,
                                  onTap: () async {
                                    if (controller.selectedCity == null) {
                                      showSnackBar(message: "SelectCity");
                                    } else {
                                      var result = await Get.toNamed(
                                          Routes.searchLocationScreen,
                                          parameters: {
                                            "cityId": controller.selectedCity!.cityId.toString()
                                          }
                                      );
                                      if (result != null) {
                                        controller.selectedLocation = result;
                                        controller.update(["filter"]);
                                      }
                                    }
                                  },
                                ),

                                SizedBox(height: 12),

                                // Choose Brand
                                _buildFilterItem(
                                  icon: Icons.directions_car_outlined,
                                  title: "Choose Brand".tr,
                                  selectedValue: controller.brand?.brandName ?? 'Choose Brand'.tr,
                                  onTap: () async {
                                    var result = await Get.toNamed(Routes.chooseBrandScreen, arguments: false) as Brand;
                                    if (result != null) {
                                      controller.brand = result;
                                      controller.brandId = controller.brand?.brandId;
                                      controller.update(["filter"]);
                                    }
                                  },
                                ),

                                SizedBox(height: 12),

                                // Choose Type
                                _buildFilterItem(
                                  icon: Icons.category_outlined,
                                  title: "Choose Type".tr,
                                  selectedValue: controller.type?.type ?? 'Choose Type'.tr,
                                  onTap: () async {
                                    var result = await Get.toNamed(Routes.chooseTypeScreen, arguments: true) as Type;
                                    if (result != null) {
                                      controller.type = result;
                                      controller.update(["filter"]);
                                    }
                                  },
                                ),

                                SizedBox(height: 12),

                                // Choose Model
                                _buildFilterItem(
                                  icon: Icons.model_training_outlined,
                                  title: "Choose Model".tr,
                                  selectedValue: controller.model?.modelName ?? 'Choose Model'.tr,
                                  onTap: () async {
                                    if(controller.brand != null) {
                                      Get.put(BrandController()).getModels(controller.brand!.brandId!);
                                      var result = await Get.toNamed(Routes.chooseModelScreen, arguments: true) as Model;
                                      if (result != null) {
                                        controller.model = result;
                                        controller.modelId = controller.model?.modelId;
                                        controller.update(["filter"]);
                                      }
                                    } else {
                                      showSnackBar(message: "SelectBrand");
                                    }
                                  },
                                ),

                                SizedBox(height: 12),

                                // Model Year
                                _buildFilterItem(
                                  icon: Icons.calendar_today_outlined,
                                  title: "Model Year".tr,
                                  selectedValue: _getModelYearText(controller),
                                  onTap: () {
                                    _showModelYearDialog(context, controller);
                                  },
                                ),

                                SizedBox(height: 12),

                                // Choose Color
                                _buildFilterItem(
                                  icon: Icons.palette_outlined,
                                  title: "Choose Color".tr,
                                  selectedValue: controller.color?.name ?? 'Choose Color'.tr,
                                  onTap: () async {
                                    var result = await Get.toNamed(Routes.selectColorScreen, arguments: true) as VehicleColor;
                                    if (result != null) {
                                      controller.color = result;
                                      controller.update(["filter"]);
                                    }
                                  },
                                ),

                                SizedBox(height: 12),

                                // Condition
                                _buildFilterItem(
                                  icon: Icons.verified_outlined,
                                  title: "Condition".tr,
                                  selectedValue: controller.condition != null
                                      ? EnumToString.convertToString(controller.condition!)
                                      : 'Select Condition'.tr,
                                  onTap: () {
                                    _showConditionDialog(context, controller);
                                  },
                                ),

                                SizedBox(height: 12),

                                // Transmission
                                _buildFilterItem(
                                  icon: Icons.settings_outlined,
                                  title: "Transmission".tr,
                                  selectedValue: controller.transmission != null
                                      ? EnumToString.convertToString(controller.transmission!)
                                      : 'Select Gear Type'.tr,
                                  onTap: () {
                                    _showTransmissionDialog(context, controller);
                                  },
                                ),

                                SizedBox(height: 12),

                                // Fuel Type
                                _buildFilterItem(
                                  icon: Icons.local_gas_station_outlined,
                                  title: "Fuel Type".tr,
                                  selectedValue: controller.fuelType != null
                                      ? EnumToString.convertToString(controller.fuelType!)
                                      : 'Select Fuel Type'.tr,
                                  onTap: () {
                                    _showFuelTypeDialog(context, controller);
                                  },
                                ),

                                SizedBox(height: 20),

                              ]
                          )
                      ),
                    ),

                    // Bottom buttons
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextButtonWidget(
                                text: "Reset".tr,
                                onPressed: controller.resetFilters,
                              )
                          ),
                          SizedBox(width: 12),
                          Expanded(
                              child: ButtonWidget(
                                  text: "Apply".tr,
                                  onPressed: () {
                                    controller.page.value = 1;
                                    controller.loadMore.value = true;
                                    controller.getFilteredCars();
                                  }
                              )
                          )
                        ],
                      ),
                    )
                  ],
                );
              }
          )
      ),
    );
  }

  Widget _buildFilterItem({
    required IconData icon,
    required String title,
    required String selectedValue,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: EdgeInsets.all(5),
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
                color: Colors.grey.shade600,
                icon,
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedValue,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Get.locale?.languageCode == "ar"
                  ? MaterialCommunityIcons.chevron_left
                  : MaterialCommunityIcons.chevron_right,
              color: Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  String _getModelYearText(CarController controller) {
    if ((controller.startYear?.isNotEmpty ?? false) || (controller.endYear?.isNotEmpty ?? false)) {
      return "${controller.startYear ?? ''} - ${controller.endYear ?? ''}";
    }
    return "Select Year Range";
  }

  void _showModelYearDialog(BuildContext context, CarController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Model Year".tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                    child: TextFieldWidget(
                      hintText: "Start Year",
                      keyboardType: TextInputType.number,
                      text: controller.startYear,
                      borderRadius: kBorderRadius8,
                      onChanged: (String val) {
                        controller.startYear = val;
                      },
                      validator: (String? val) {
                        if(val!.trim().isEmpty) {
                          return kRequiredMsg.tr;
                        } else
                          return null;
                      },
                    )
                ),
                Text(" ${"To".tr} ", style: TextStyle(color: kBlackColor, fontSize: 16.sp, fontWeight: FontWeight.w600)),
                Expanded(
                    child: TextFieldWidget(
                      hintText: "End Year",
                      keyboardType: TextInputType.number,
                      text: controller.endYear,
                      borderRadius: kBorderRadius8,
                      onChanged: (String val) {
                        controller.endYear = val;
                      },
                      validator: (String? val) {
                        if(val!.trim().isEmpty) {
                          return kRequiredMsg.tr;
                        } else
                          return null;
                      },
                    )
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              controller.update(["filter"]);
              Get.back();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showConditionDialog(BuildContext context, CarController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Condition".tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: VehicleCondition.values.map((condition) =>
              ListTile(
                title: Text(EnumToString.convertToString(condition)),
                onTap: () {
                  controller.condition = condition;
                  controller.update(["filter"]);
                  Get.back();
                },
              )
          ).toList(),
        ),
      ),
    );
  }

  void _showTransmissionDialog(BuildContext context, CarController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Transmission".tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: Transmission.values.map((transmission) =>
              ListTile(
                title: Text(EnumToString.convertToString(transmission)),
                onTap: () {
                  controller.transmission = transmission;
                  controller.update(["filter"]);
                  Get.back();
                },
              )
          ).toList(),
        ),
      ),
    );
  }

  void _showFuelTypeDialog(BuildContext context, CarController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Fuel Type".tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: FuelType.values.map((fuelType) =>
              ListTile(
                title: Text(EnumToString.convertToString(fuelType)),
                onTap: () {
                  controller.fuelType = fuelType;
                  controller.update(["filter"]);
                  Get.back();
                },
              )
          ).toList(),
        ),
      ),
    );
  }
}
