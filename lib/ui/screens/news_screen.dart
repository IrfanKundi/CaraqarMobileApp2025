import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/content_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gif_view/gif_view.dart';

import '../../global_variables.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late ContentController contentController;
  int sliderIndex = 0;

  @override
  void initState() {
    contentController = Get.put(ContentController());
    contentController.getNews();
    super.initState();
  }

  Widget buildBannerWidget() {
    if (contentController.newsContent == null) {
      return const SizedBox(height: 20);
    }

    // Case 1: use files (GIF or WebP in memory)
    if (contentController.newsContent!.files.isNotEmpty) {
      return GifView.memory(
        contentController.newsContent!.files.last.readAsBytesSync(),
        fit: BoxFit.fill,
        height: 220.h,
        width: 1.sw,
        progress: const Center(child: CircularLoader()),
        frameRate: 15,
      );
    }

    // Case 2: use fallback animated WebP asset
    return Image.asset(
      gIsVehicle ? kVehicleVideo : kRealStateVideo,
      fit: BoxFit.cover,
      height: 220.h,
      width: 1.sw,
      gaplessPlayback: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 50.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildBannerWidget(),

            GetBuilder<ContentController>(
              builder: (controller) {
                if (controller.newsStatus.value != Status.success) {
                  return SizedBox(
                    height: 0.9.sh,
                    child: const Center(child: CircularLoader()),
                  );
                }

                if (controller.news.isEmpty) {
                  return SizedBox(
                    height: 0.9.sh,
                    child: Center(child: Text("NoDataFound".tr)),
                  );
                }

                return ListView.separated(
                  physics: const PageScrollPhysics(),
                  padding: kScreenPadding,
                  itemBuilder:
                      (context, index) => InkWell(
                        onTap: () {
                          Get.toNamed(
                            Routes.newsDetailScreen,
                            arguments: controller.news[index],
                          );
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            ImageWidget(
                              controller.news[index].images.first,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 0.25.sh,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4.w,
                                horizontal: 8.w,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: kBorderRadius4,
                              ),
                              child: Text(
                                controller.news[index].title!,
                                style: TextStyle(
                                  color: kWhiteColor,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  separatorBuilder: (context, index) => kVerticalSpace12,
                  shrinkWrap: true,
                  itemCount: controller.news.length,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
