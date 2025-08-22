import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';

class EnterSeatsScreen extends GetView<VehicleController> {
  EnterSeatsScreen({super.key});

  final formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: buildAppBar(context, title: "Seats"),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GetBuilder<VehicleController>(
          id: "seats",
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: 35,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final seatCount = index + 1;
                      final isSelected = controller.seats == seatCount;

                      return InkWell(
                        onTap: () {
                          controller.seats = seatCount;
                          controller.update(["seats"]);

                          // Auto-navigate after selection
                          if (Get.arguments == true) {
                            Navigator.pop(context);
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
                                  Icons.event_seat_outlined,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey.shade600,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "$seatCount ${'Seats'.tr}",
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
            );
          },
        ),
      ),
    );
  }
}
