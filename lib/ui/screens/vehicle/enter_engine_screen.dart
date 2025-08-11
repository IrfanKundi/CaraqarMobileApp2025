import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';
import '../../widgets/text_field_widget.dart';

class EnterEngineScreen extends GetView<VehicleController> {
  EnterEngineScreen({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  final List<String> engineSizes = [
    '660', '800', '1000', '1200', '1300', '1500',
    '1800', '2000', '2400', '2500', '2700', '2800',
    '3000', '3500', '4000',
  ];

  @override
  Widget build(BuildContext context) {
    String currentEngine = controller.engine ?? '';

    return StatefulBuilder(
      builder: (context, setState) {
        return Scaffold(
          appBar: buildAppBar(context, title: "EnterEngine"),

          // ✅ Floating Next button
          bottomNavigationBar: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: ButtonWidget(
              text: "Next",
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  if (Get.arguments == true) {
                    Navigator.pop(context);
                  } else if (controller.vehicleType == VehicleType.Car) {
                    Get.toNamed(Routes.enterMileageScreen);
                  } else {
                    Get.toNamed(Routes.reviewAdScreen);
                  }
                }
              },
            ),
          ),

          // ✅ Scrollable body
          body: Padding(
            padding: kScreenPadding,
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ✅ Engine input field
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextFieldWidget(
                        hintText: "Engine",
                        text: currentEngine,
                        onChanged: (String val) {
                          setState(() => currentEngine = val);
                          controller.engine = val;
                        },
                        onSaved: (String? val) {
                          controller.engine = val;
                        },
                        validator: (String? val) {
                          if (val!.trim().isEmpty) {
                            return kRequiredMsg.tr;
                          } else {
                            return null;
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Text(
                          "cc",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  kVerticalSpace16,

                  // ✅ Engine list styled like seat list
                  Expanded(
                    child: ListView.separated(
                      itemCount: engineSizes.length,
                      padding: const EdgeInsets.only(bottom: 20),
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final size = engineSizes[index];
                        final isSelected = controller.engine == size;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              currentEngine = size;
                              controller.engine = size;
                            });
                            FocusScope.of(context).unfocus();

                            // Auto-navigate after selection
                            if (Get.arguments == true) {
                              Navigator.pop(context);
                            } else if (controller.vehicleType == VehicleType.Car) {
                              Get.toNamed(Routes.enterSeatsScreen);
                            } else {
                              Get.toNamed(Routes.reviewAdScreen);
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: isSelected ? kLightBlueColor : Colors.transparent,
                              border: Border.all(
                                color: isSelected ? kLightBlueColor : Colors.grey.shade300,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "$size cc",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: kBlackColor,
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
          ),
        );
      },
    );
  }
}




