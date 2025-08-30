import 'package:careqar/enums.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../controllers/location_controller.dart';

class SelectAdLocationScreen extends StatelessWidget {
  const SelectAdLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationController = Get.find<LocationController>();
    final int cityId = int.tryParse(Get.parameters["cityId"] ?? "") ?? -1;
    final String title = Get.parameters["title"] ?? "SelectCity".tr;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: buildAppBar(context, title: title),
      body: Obx(() {
        final status = locationController.status.value;

        if (status == Status.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (status == Status.error) {
          return Center(child: Text("Failed to load city data"));
        }

        final city = locationController.cityModel.value.cities
            .firstWhereOrNull((element) => element.cityId == cityId);

        if (city == null) {
          return Center(child: Text("City not found"));
        }

        if (city.locations.isEmpty) {
          return Center(child: Text("No locations found"));
        }

        return ListView.separated(
          padding: EdgeInsets.all(16),
          separatorBuilder: (context, index) => SizedBox(height: 12),
          itemCount: city.locations.length,
          itemBuilder: (context, index) {
            final location = city.locations[index];
            return InkWell(
              onTap: () {
                Get.back(result: location);
              },
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
                    SizedBox(height: 40),
                    Expanded(
                      child: Text(
                        location.title ?? "",
                        textAlign: TextAlign.center,
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
          },
        );
      }),
    );
  }
}




