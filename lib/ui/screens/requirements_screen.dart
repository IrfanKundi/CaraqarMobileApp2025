import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/content_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RequirementsScreen extends GetView<ContentController> {

  RequirementsScreen({Key? key}) : super(key: key){

    controller.getRequirements();

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBar(context,title: "Requirements"),
      body:
      GetBuilder<ContentController>(builder:(controller)=>
      controller.requirementsStatus.value==Status.success?
      controller.requirements.isEmpty?
      Center(child:
      Text("NoDataFound".tr),)
          : ListView.separated(
          physics: const PageScrollPhysics(),
          padding: kScreenPadding,
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              Get.toNamed(Routes.requirementDetailScreen,
                  arguments: controller.requirements[index]);
            },
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                ImageWidget(
                  controller.requirements[index].images.first,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 0.25.sh,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 4.w, horizontal: 8.w),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: kBorderRadius4,
                  ),
                  child: Text(
                    controller.requirements[index].title!,
                    style: TextStyle(
                        color: kWhiteColor,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
          separatorBuilder: (context, index) => kVerticalSpace12,
          shrinkWrap: true,
          itemCount: controller.requirements.length):

      SizedBox(
          height: 0.9.sh,
          child: const Center(child: CircularLoader()))),
    );
  }
}
