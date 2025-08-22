import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
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
          backgroundColor: Colors.grey[50],
          appBar: buildAppBar(context, title: "EnterEngine"),

          // ✅ Floating Next button
          bottomNavigationBar: Container(
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
            padding: EdgeInsets.all(16),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ✅ Engine input field
                  Container(
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
                            Icons.engineering_outlined,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            initialValue: currentEngine,
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
                            decoration: InputDecoration(
                              hintText: "Enter Engine Size",
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
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "cc",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // ✅ Engine list styled like other selection screens
                  Expanded(
                    child: ListView.separated(
                      itemCount: engineSizes.length,
                      padding: const EdgeInsets.only(bottom: 20),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
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
                                  child: Icon(
                                    Icons.engineering_outlined,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey.shade600,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "$size cc",
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
          ),
        );
      },
    );
  }
}




