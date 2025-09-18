import 'dart:io';

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/brand_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:careqar/ui/widgets/text_button_widget.dart';
import 'package:careqar/ui/widgets/text_field_widget.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';
import '../../../locale/convertor.dart';
import '../../widgets/alerts.dart';
import '../../widgets/phone_number_text_field.dart';

class ReviewAdScreen extends GetView<VehicleController> {
  ReviewAdScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          _showExitConfirmation();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: buildAppBar(context, title: "ReviewAd"),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: GetBuilder<VehicleController>(
              builder: (controller) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ReviewAdItem(
                      title: "OfferType".tr,
                      onPressed: () async {
                        await Get.toNamed(
                          Routes.chooseAdTypeScreen,
                          arguments: true,
                        );
                        controller.update();
                      },
                      value:
                      "${EnumToString.convertToString(controller.vehicleType).tr} ${"For".tr} ${controller.purpose?.tr}",
                    ),
                    VehicleType.NumberPlate != controller.vehicleType
                        ? Column(
                      children: [
                        ReviewAdItem(
                          title: "Brand".tr,
                          value: "${controller.brand?.brandName}",
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.chooseBrandScreen,
                              arguments: true,
                            );
                            controller.update();
                          },
                        ),
                        ReviewAdItem(
                          title: "Model".tr,
                          value: "${controller.model?.modelName}",
                          onPressed: () async {
                            Get.put(
                              BrandController(),
                            ).getModels(controller.brand!.brandId!);
                            await Get.toNamed(
                              Routes.chooseModelScreen,
                              arguments: true,
                            );
                            controller.update();
                          },
                        ),
                        ReviewAdItem(
                          title: "Variant".tr,
                          value: "${controller.modelVariantName}",
                          onPressed: () async {
                            Get.put(
                              BrandController(),
                            ).getModels(controller.brand!.brandId!);
                            await Get.toNamed(
                              Routes.chooseModelVariants,
                              arguments: true,
                            );
                            controller.update();
                          },
                        ),
                        ReviewAdItem(
                          title: "Model Year".tr,
                          value: "${controller.modelYear}",
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.chooseModelYearScreen,
                              arguments: true,
                            );
                            controller.update();
                          },
                        ),
                        ReviewAdItem(
                          title: "Assembly".tr,
                          value: "${controller.origin}".tr,
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.selectOriginScreen,
                              arguments: true,
                            );
                            controller.update();
                          },
                        ),
                        if (controller.importYear != null && controller.importYear!.isNotEmpty)
                          ReviewAdItem(
                            title: "Import Year".tr,
                            value: "${controller.importYear}".tr,
                            onPressed: () async {
                              await Get.toNamed(
                                Routes.importYearScreen,
                                arguments: true,
                              );
                              controller.update();
                            },
                          ),
                        ReviewAdItem(
                          title: "Registered In".tr,
                          value: "${controller.registrationProvinceName}".tr,
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.selectProvinceScreen,
                              arguments: true,
                            );
                            controller.update();
                          },
                        ),
                        ReviewAdItem(
                          title: "Your Location".tr,
                          value: "${controller.city?.name}",
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.selectCityScreen,
                              arguments: true,
                            );
                            controller.update();
                          },
                        ),
                        ReviewAdItem(
                          title: "Body Type".tr,
                          value: "${controller.type?.type}",
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.chooseTypeScreen,
                              arguments: true,
                            );
                            controller.update();
                          },
                        ),

                        ReviewAdItem(
                          title: "Registration Year".tr,
                          value: "${controller.registrationYear}".tr,
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.selectRegistrationYearScreen,
                              arguments: true,
                            );
                            controller.update();
                          },
                        ),
                        if (VehicleType.Car == controller.vehicleType)
                          ReviewAdItem(
                            title: "Transmission".tr,
                            value: "${controller.transmission}".tr,
                            onPressed: () async {
                              await Get.toNamed(
                                Routes.chooseTransmissionScreen,
                                arguments: true,
                              );
                              controller.update();
                            },
                          ),
                        if (VehicleType.Car == controller.vehicleType)
                          ReviewAdItem(
                            title: "FuelType".tr,
                            value: "${controller.fuelType}".tr,
                            onPressed: () async {
                              await Get.toNamed(
                                Routes.selectFuelTypeScreen,
                                arguments: true,
                              );
                              controller.update();
                            },
                          ),
                        ReviewAdItem(
                          title: "Color".tr,
                          value: "${controller.color}".tr,
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.selectColorScreen,
                              arguments: true,
                            );
                            controller.update();
                          },
                        ),
                        ReviewAdItem(
                          title: "Engine".tr,
                          value: "${controller.engine}cc",
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.enterEngineScreen,
                              arguments: true,
                            );
                            controller.update();
                          },
                        ),
                        if (VehicleType.Car == controller.vehicleType)
                          ReviewAdItem(
                            title: "Seats".tr,
                            value: "${controller.seats}",
                            onPressed: () async {
                              await Get.toNamed(
                                Routes.enterSeatsScreen,
                                arguments: true,
                              );
                              controller.update();
                            },
                          ),
                        ReviewAdItem(
                          title: "Vehicle Condition".tr,
                          value: "${controller.condition}".tr,
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.selectConditionScreen,
                              arguments: true,
                            );
                            controller.update();
                          },
                        ),
                        ReviewAdItem(
                          title: "PaymentMethod".tr,
                          value: "${controller.paymentMethod}".tr,
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.selectPaymentMethodScreen,
                              arguments: true,
                            );
                            controller.update();
                          },
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mileage".tr,
                                style: kTextStyle16.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 12),
                              TextFieldWidget(
                                hintText: "Enter mileage".tr,
                                text: controller.mileage,
                                keyboardType: TextInputType.number,
                                borderRadius: kBorderRadius4,
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return "Mileage is required".tr;
                                  }
                                  return null;
                                },
                                onChanged: (String val) {
                                  controller.mileage = val.trim();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                        : Column(
                      children: [
                        ReviewAdItem(
                          title: "Number".tr,
                          value: "${controller.number}",
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.enterNumberScreen,
                              arguments: true,
                            );
                            controller.update();
                          },
                        ),
                        ReviewAdItem(
                          title: "Digits".tr,
                          value: "${controller.digits}",
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.selectPlateDigitsScreen,
                              arguments: true,
                            );
                            controller.update();
                          },
                        ),
                        ReviewAdItem(
                          title: "PlateType".tr,
                          value: "${controller.plateType}",
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.selectPlateTypeScreen,
                              arguments: true,
                            );
                            controller.update();
                          },
                        ),
                        ReviewAdItem(
                          title: "Privilege".tr,
                          value: "${controller.privilege}",
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.selectPrivilegeScreen,
                              arguments: true,
                            );
                            controller.update();
                          },
                        ),
                        ReviewAdItem(
                          title: "City".tr,
                          value: "${controller.city?.name}",
                          onPressed: () async {
                            await Get.toNamed(
                              Routes.selectCityScreen,
                              arguments: true,
                            );
                            controller.update();
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 12),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
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
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Description".tr,
                                  style: kTextStyle16.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GetBuilder<VehicleController>(
                                id: "lang",
                                builder:
                                    (controller) => Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        controller.lang = 0;
                                        controller.update(["lang"]);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                          gSelectedCountry?.countryId ==
                                              11
                                              ? kAccentColor
                                              : controller.lang == 0
                                              ? kAccentColor
                                              : null,
                                          borderRadius: kBorderRadius30,
                                        ),
                                        child: Text(
                                          "English".tr,
                                          textAlign: TextAlign.center,
                                          style:
                                          gSelectedCountry?.countryId ==
                                              11
                                              ? kLightTextStyle12
                                              : controller.lang == 0
                                              ? kLightTextStyle12
                                              : kTextStyle12,
                                        ),
                                      ),
                                    ),
                                    gSelectedCountry?.countryId == 11
                                        ? SizedBox()
                                        : InkWell(
                                      onTap: () {
                                        controller.lang = 1;
                                        controller.update(["lang"]);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                          controller.lang == 1
                                              ? kAccentColor
                                              : null,
                                          borderRadius: kBorderRadius30,
                                        ),
                                        child: Text(
                                          "Arabic".tr,
                                          textAlign: TextAlign.center,
                                          style:
                                          controller.lang == 1
                                              ? kLightTextStyle12
                                              : kTextStyle12,
                                        ),
                                      ),
                                    ),
                                    gSelectedCountry?.countryId == 11
                                        ? SizedBox()
                                        : InkWell(
                                      onTap: () {
                                        controller.lang = 2;
                                        controller.update(["lang"]);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                          controller.lang == 2
                                              ? kAccentColor
                                              : null,
                                          borderRadius: kBorderRadius30,
                                        ),
                                        child: Text(
                                          "Both".tr,
                                          textAlign: TextAlign.center,
                                          style:
                                          controller.lang == 2
                                              ? kLightTextStyle12
                                              : kTextStyle12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          GetBuilder<VehicleController>(
                            id: "lang",
                            builder:
                                (controller) => Column(
                              children: [
                                gSelectedCountry?.countryId == 11 ||
                                    controller.lang == 0 ||
                                    controller.lang == 2
                                    ? Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 12,
                                  ),
                                  child: TextFieldWidget(
                                    hintText: "DescriptionEnglish",
                                    maxLines: 3,
                                    text: controller.descriptionEn,
                                    borderRadius: kBorderRadius4,
                                    textInputAction:
                                    TextInputAction.newline,
                                    onChanged: (String val) {
                                      controller.descriptionEn =
                                          val.trim();
                                    },
                                    validator: (String? val) {
                                      if (val!.trim().isEmpty)
                                        return kRequiredMsg.tr;
                                      else
                                        return null;
                                    },
                                  ),
                                )
                                    : Container(),
                                gSelectedCountry?.countryId != 11 &&
                                    (controller.lang == 1 ||
                                        controller.lang == 2)
                                    ? Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 12,
                                  ),
                                  child: TextFieldWidget(
                                    hintText: "DescriptionArabic",
                                    maxLines: 3,
                                    text: controller.descriptionAr,
                                    borderRadius: kBorderRadius4,
                                    textInputAction:
                                    TextInputAction.newline,
                                    onChanged: (String val) {
                                      controller.descriptionAr =
                                          val.trim();
                                    },
                                    validator: (String? val) {
                                      if (val!.trim().isEmpty)
                                        return kRequiredMsg.tr;
                                      else
                                        return null;
                                    },
                                  ),
                                )
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
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
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "${"Price".tr} (${gSelectedCountry?.currency})",
                            style: kTextStyle16.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          TextFieldWidget(
                            hintText: "Price (Optional)",
                            keyboardType: TextInputType.number,
                            borderRadius: kBorderRadius4,
                            text: controller.price?.toString(),
                            onChanged: (String val) {
                              if (val == "") {
                                controller.price = 0.0;
                                controller.priceInWords.value = '';
                              } else {
                                try {
                                  controller.price = double.parse(val);
                                  final formatted = formatIndianNumber(
                                    controller.price!.toInt(),
                                  );
                                  controller.priceInWords.value =
                                      formatted.capitalize!.trim() ?? '';
                                } catch (_) {
                                  controller.priceInWords.value = '';
                                }
                              }
                            },
                            validator: (String? val) {
                              return null;
                            },
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Skip the price to display 'Call for Price'",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: kGreyColor,
                            ),
                          ),
                          Obx(() {
                            if (controller.priceInWords.isEmpty)
                              return SizedBox.shrink();
                            return Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Text(
                                controller.priceInWords.value,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    if (VehicleType.NumberPlate != controller.vehicleType)
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
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
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Features".tr,
                              style: kTextStyle16.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            GetBuilder<VehicleController>(
                              builder:
                                  (controller) => GestureDetector(
                                onTap: () async {
                                  if (Get.focusScope != null) {
                                    Get.focusScope?.unfocus();
                                  }
                                  await Get.toNamed(
                                    Routes.addVehicleFeaturesScreen,
                                  );
                                  controller.update();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: kWhiteColor,
                                    border: Border.all(
                                      width: 1,
                                      color: kGreyColor.shade300,
                                    ),
                                    borderRadius: kBorderRadius4,
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        controller.vehicleFeatures.isEmpty
                                            ? "AddFeatures".tr
                                            : "AddAnotherFeature".tr,
                                        style: kHintStyle,
                                      ),
                                      SizedBox(height: 8),
                                      Wrap(
                                        runSpacing: 4,
                                        spacing: 4,
                                        children:
                                        controller.vehicleFeatures
                                            .map(
                                              (e) => Container(
                                            padding:
                                            EdgeInsets.symmetric(
                                              vertical: 2,
                                              horizontal: 8,
                                            ).copyWith(
                                              right: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              kBorderRadius30,
                                              color:
                                              kGreyColor
                                                  .shade300,
                                            ),
                                            child: Row(
                                              mainAxisSize:
                                              MainAxisSize.min,
                                              children: [
                                                Text(
                                                  e.feature!,
                                                  style:
                                                  kTextStyle12,
                                                ),
                                                SizedBox(width: 4),
                                                GestureDetector(
                                                  child: Icon(
                                                    MaterialCommunityIcons
                                                        .close,
                                                    size: 15,
                                                  ),
                                                  onTap: () {
                                                    controller
                                                        .vehicleFeatures
                                                        .remove(e);
                                                    controller
                                                        .update();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
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
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "PhoneNumber".tr,
                            style: kTextStyle16.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          PhoneNumberTextField(
                            hintText: "PhoneNumber",
                            value: controller.phoneNumber,
                            borderRadius: kBorderRadius4,
                            onChanged: (val) {
                              controller.phoneNumber = val;
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
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
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Images".tr,
                                style: kTextStyle16.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 12),
                              TextButtonWidget(
                                onPressed: controller.uploadImages,
                                text: "AddImages",
                              ),
                            ],
                          ),
                          GetBuilder<VehicleController>(
                            builder:
                                (controller) => Visibility(
                              visible:
                              controller.newImages.value.isNotEmpty,
                              child: Container(
                                margin: EdgeInsets.only(bottom: 16),
                                height: 50,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    if (controller.newImages.value[index]
                                    is File) {
                                      return Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          ImageWidget(
                                            null,
                                            file:
                                            controller
                                                .newImages
                                                .value[index],
                                            width: 100,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                            top: -8,
                                            right: -4,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black38,
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButtonWidget(
                                                icon:
                                                MaterialCommunityIcons
                                                    .close,
                                                iconSize: 16.sp,
                                                width: 23,
                                                color: kWhiteColor,
                                                onPressed: () {
                                                  controller.newImages.value
                                                      .removeAt(index);
                                                  controller.update();
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          ImageWidget(
                                            controller
                                                .newImages
                                                .value[index],
                                            width: 100,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          ),
                                          Positioned(
                                            top: -8,
                                            right: -4,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black38,
                                                shape: BoxShape.circle,
                                              ),
                                              child: IconButtonWidget(
                                                icon:
                                                MaterialCommunityIcons
                                                    .close,
                                                iconSize: 16.sp,
                                                width: 23,
                                                color: kWhiteColor,
                                                onPressed: () {
                                                  controller.newImages.value
                                                      .removeAt(index);
                                                  controller.images
                                                      .removeAt(index);
                                                  controller.update();
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(width: 12);
                                  },
                                  itemCount:
                                  controller.newImages.value.length,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: kBgColor,
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      child: ButtonWidget(
                        onPressed: () {
                          controller.uploadNow();
                        },
                        text: "UploadNow",
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showExitConfirmation() {
    showConfirmationDialog(
      title: "Leave Ad Posting",
      message:
      "Are you sure you want to leave? Your progress will be lost and cannot be recovered.",
      textConfirm: "Yes, Leave",
      textCancel: "No, Stay",
      onConfirm: () {
        Get.back(); // Close the dialog first
        Get.offAllNamed(
          '/navigationScreen',
        ); // Navigate to main page and clear all routes
        // Alternative if you have a specific main page widget:
        // Get.offAll(() => MainPage());
      },
      onCancel: () {
        //Get.back(); // Just close the dialog and stay on current page
      },
    );
  }
}

class ReviewAdItem extends GetView<VehicleController> {
  const ReviewAdItem({
    Key? key,
    required this.title,
    required this.value,
    this.onPressed,
  }) : super(key: key);

  final title;
  final value;
  final onPressed;

  IconData _getIconForTitle(String title) {
    // Remove .tr if present for comparison
    String cleanTitle = title.replaceAll('.tr', '');

    switch (cleanTitle.toLowerCase()) {
      case 'offertype':
        return Icons.local_offer_outlined;
      case 'type':
        return Icons.category_outlined;
      case 'brand':
        return Icons.directions_car_outlined;
      case 'model':
        return Icons.model_training_outlined;
      case 'year':
        return Icons.calendar_today_outlined;
      case 'fuel type':
        return Icons.local_gas_station_outlined;
      case 'vehicle origin':
        return Icons.public_outlined;
      case 'registration':
        return Icons.location_on_outlined;
      case 'vehicle condition':
        return Icons.verified_outlined;
      case 'registration year':
        return Icons.calendar_today_outlined;
      case 'transmission':
        return Icons.settings_outlined;
      case 'color':
        return Icons.palette_outlined;
      case 'engine':
        return Icons.engineering_outlined;
      case 'seats':
        return Icons.event_seat_outlined;
      case 'city':
        return Icons.location_city_outlined;
      case 'payment method':
        return Icons.payment_outlined;
      case 'mileage':
        return Icons.speed_outlined;
      case 'number':
        return Icons.pin_outlined;
      case 'digits':
        return Icons.numbers_outlined;
      case 'plate type':
        return Icons.rectangle_outlined;
      case 'privilege':
        return Icons.star_outline;
      default:
        return Icons.edit_outlined;
    }
  }

  // Helper method to get color from gVehicleColors list
  Color? _getColorFromName(String colorName) {
    try {
      final vehicleColor = gVehicleColors.firstWhere(
            (color) => color.name.toLowerCase() == colorName.toLowerCase(),
      );
      return vehicleColor.color;
    } catch (e) {
      return null;
    }
  }

  // Check if this is a color field
  bool _isColorField() {
    String cleanTitle = title.toString().replaceAll('.tr', '').toLowerCase();
    return cleanTitle == 'color';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
              child: _isColorField() && _getColorFromName(value.toString()) != null
                  ? Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getColorFromName(value.toString()),
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
              )
                  : Icon(
                _getIconForTitle(title),
                color: Colors.grey.shade600,
                size: 20,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: kAccentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
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
}
