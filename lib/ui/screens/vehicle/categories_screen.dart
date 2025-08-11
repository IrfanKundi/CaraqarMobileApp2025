import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/category_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CategoriesScreen extends StatelessWidget {
   CategoriesScreen({Key? key}) : super(key: key){
  Get.put(CategoryController()).getCategories();
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: buildAppBar(context,title: "ChooseCategory"),
      body: GetBuilder<CategoryController>(builder: (categoryController)=> categoryController
          .categoriesStatus.value ==
          Status.loading
          ? CircularLoader():

      categoryController.categoriesStatus.value ==
          Status.error
          ? Center(
            child: Text(kCouldNotLoadData.tr,
            style: kTextStyle16),
          )
          :

      categoryController.searchedCategories.isEmpty?
          Center(
            child: Text("NoDataFound".tr,
                style: kTextStyle16),
          ):
      GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 8.w,crossAxisSpacing: 8.w,
          crossAxisCount: 3
        ),
        padding: kScreenPadding,
          itemCount: categoryController.searchedCategories.length,
        itemBuilder: (context, index) {
            var item = categoryController.searchedCategories[index];
            return InkWell(
              onTap: (){

                categoryController.getSubCategories(item.categoryId!);
                Get.toNamed(Routes.subCategoriesScreen);

              },
              child:Container(
                decoration: BoxDecoration(
                  border: Border.all(color: kAccentColor),
                  borderRadius: kBorderRadius12,
                ),
                padding: EdgeInsets.all(8.w),
                        child: Column(
                          children: [
                            ImageWidget(item.imageUrl,width: 50.w,height: 50.w),
                            kVerticalSpace8,
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                item.categoryName!,
                textAlign: TextAlign.center,
                style: TextStyle(color: kBlackColor, fontWeight: FontWeight.w700, fontSize: 15.sp),
              ),
                            ),
                          ],
                        )));

          }
          ),
      ),
    );
  }
}
