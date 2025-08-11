import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/product_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/category_controller.dart';

class SubCategoriesScreen extends StatelessWidget {
   SubCategoriesScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: buildAppBar(context,title: "ChooseSubCategory"),
      body: GetBuilder<CategoryController>(builder: (subCategoryController)=> subCategoryController
          .subCategoriesStatus.value ==
          Status.loading
          ? CircularLoader():

      subCategoryController.subCategoriesStatus.value ==
          Status.error
          ? Center(
            child: Text(kCouldNotLoadData.tr,
            style: kTextStyle16),
          )
          :

      subCategoryController.searchedSubCategories.isEmpty?
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
          itemCount: subCategoryController.searchedSubCategories.length,
        itemBuilder: (context, index) {
            var item = subCategoryController.searchedSubCategories[index];
            return InkWell(
              onTap: (){
              var controller= Get.put(ProductController());

              controller.resetFilters();
              controller.categoryId.value=item.categoryId!;
              controller.subCategoryId.value=item.subCategoryId!;
              controller.getProducts();
                Get.toNamed(Routes.productsScreen);

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
                item.subCategoryName!,
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
