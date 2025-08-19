import 'package:careqar/constants/style.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/location_controller.dart';

class SelectAdLocationScreen extends StatelessWidget {
  const SelectAdLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locationController = Get.find<LocationController>();
    final int cityId = int.tryParse(Get.parameters["cityId"] ?? "") ?? -1;

    return Scaffold(
      appBar: buildAppBar(context, title: "SelectCity".tr),
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
          padding: kScreenPadding,
          separatorBuilder: (context, index) => Divider(),
          itemCount: city.locations.length,
          itemBuilder: (context, index) {
            final location = city.locations[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(location.title??"", style: kTextStyle14),
              onTap: () {
                Get.back(result: location);
              },
            );
          },
        );
      }),
    );
  }
}




