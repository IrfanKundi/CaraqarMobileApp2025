import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/location_controller.dart';
import 'package:careqar/models/city_model.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SearchLocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LocationController>();

    int id = int.parse(Get.parameters["cityId"]!);

    return Scaffold(
      appBar: buildAppBar(context, title: "SearchCity".tr),
      body: Obx(() {
        // Wait for data to be available
        if (controller.cityModel.value.cities.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        // Now safely access city
        final cities = controller.cityModel.value.cities;
        final city = cities.firstWhere(
              (element) => element.cityId == id, // fallback
        );

        if (city.cityId == -1) {
          return Center(child: Text("City not found"));
        }

        return ListView.separated(
          padding: kScreenPadding,
          shrinkWrap: true,
          separatorBuilder: (context, index) => Divider(),
          itemCount: city.locations.length,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("${city.locations[index].title}", style: kTextStyle14),
              onTap: () {
                Get.back(result: city.locations[index]);
              },
            );
          },
        );
      }),
    );
  }
}

