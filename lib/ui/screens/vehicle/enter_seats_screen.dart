import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';
import '../../widgets/dropdown_widget.dart';

class EnterSeatsScreen extends GetView<VehicleController> {
   EnterSeatsScreen({Key? key}) : super(key: key);

  final formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: buildAppBar(context, title: "Seats"),
      body: Padding(
        padding: kScreenPadding,
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
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final seatCount = index + 1;
                      final isSelected = controller.seats == seatCount;

                      return InkWell(
                        onTap: () {
                          controller.seats = seatCount;
                          controller.update(["seats"]);
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
                            "$seatCount ${'Seats'.tr}",
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
                kVerticalSpace16,
                ButtonWidget(
                  text: "Next",
                  onPressed: () {
                    if (controller.seats == null) {
                      showSnackBar(message: kRequiredMsg.tr);
                      return;
                    }

                    if (Get.arguments == true) {
                      Navigator.pop(context);
                    } else {
                      Get.toNamed(Routes.reviewAdScreen);
                    }
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
    ;
  }
}
