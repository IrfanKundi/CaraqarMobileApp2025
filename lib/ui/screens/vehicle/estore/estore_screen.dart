import 'dart:io';

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/brand_controller.dart';
import 'package:careqar/controllers/category_controller.dart';
import 'package:careqar/controllers/content_controller.dart';
import 'package:careqar/controllers/product_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/models/category_model.dart';
import 'package:careqar/models/product_model.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/dropdown_widget.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../../constants/strings.dart';
import '../../../widgets/app_bar.dart';

class EStoreScreen extends StatelessWidget {
  EStoreScreen({Key? key}) : super(key: key) {
    contentController = Get.find<ContentController>();
    contentController.getContent();
    categoryController = Get.put(CategoryController());
    categoryController.getCategories();
    categoryController.getCategoriesAndProducts();

    categoryController.brandController
        .getBrands(EnumToString.convertToString(VehicleType.Car));
  }

  late CategoryController categoryController;

  late VideoPlayerController? _videoPlayerController;

  late ContentController contentController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context, title: ("EStore").tr,
        //     actions: [
        //   IconButton(onPressed: (){}, icon: const Icon(Icons.search,color: kBlackColor,))
        // ]
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GetBuilder<ContentController>(builder: (contentController) {
              List<String>? images =
                  contentController.eStoreContent?.images ?? [];

              return images.isNotEmpty
                  ? CarouselSlider.builder(
                      itemBuilder: (context, pageIndex, viewIndex) => Stack(
                        alignment: Alignment.center,
                        children: [
                          ImageWidget(
                            contentController.eStoreContent?.images[pageIndex],
                            fit: BoxFit.fill,
                            height: 0.35.sh,
                            width: 1.sw,
                            isLocalImage: false,
                          ),
                          Positioned(
                            bottom: 8.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: contentController.eStoreContent!.images
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                return contentController
                                            .eStoreContent?.images[pageIndex] ==
                                        entry.value
                                    ? Container(
                                        width: 15.w,
                                        height: 15.w,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 4.0),
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: kLogoColor),
                                      )
                                    : Container(
                                        width: 8.w,
                                        height: 8.w,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 4.0),
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: kLogoColor),
                                      );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      itemCount: contentController.eStoreContent?.images.length,
                      options: CarouselOptions(
                          aspectRatio: 9 / 16,
                          height: 0.35.sh,
                          autoPlay: true,
                          enlargeCenterPage: false,
                          viewportFraction: 1,
                          autoPlayCurve: Curves.easeInOut),
                    )
                  : const SizedBox();
            }),
            Column(
              children: [
                GetBuilder<CategoryController>(
                    builder: (categoryController) => SizedBox(
                          height: 0.17.sh,
                          width: 1.sw,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            itemCount:
                                categoryController.searchedCategories.length,
                            itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  categoryController.getSubCategories(
                                      categoryController
                                          .searchedCategories[index]
                                          .categoryId!);
                                  Get.toNamed(Routes.subCategoriesScreen);
                                },
                                child: EStoreMenuWidget(
                                    text: categoryController
                                        .searchedCategories[index]
                                        .categoryName!,
                                    imageUrl: categoryController
                                            .searchedCategories[index]
                                            .imageTw0Url ??
                                        categoryController
                                            .searchedCategories[index]
                                            .imageUrl)),
                          ),
                        )),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Find Car Parts".toUpperCase(),
                                style: Get.textTheme.titleLarge
                                    ?.copyWith(fontSize: 18.sp),
                              )),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 6.w),
                            color: kAccentColor,
                            child: Text("Special Requests",
                                style: Get.textTheme.labelSmall
                                    ?.copyWith(color: kWhiteColor)),
                          )
                        ],
                      ),
                      kVerticalSpace8,
                      GetBuilder<BrandController>(
                          builder: (brandController) => brandController
                                  .searched.value
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        runAlignment: WrapAlignment.center,
                                        runSpacing: 16.w,
                                        spacing: 0.2.sw,
                                        children: [
                                          Text(
                                              "Brand: ${brandController.brand.value}",
                                              style: Get.textTheme.titleSmall),
                                          Text(
                                              "Model: ${brandController.model.value}",
                                              style: Get.textTheme.titleSmall),
                                          Text(
                                              "Year: ${brandController.year.value}",
                                              style: Get.textTheme.titleSmall),
                                          Text(
                                              "Engine: ${brandController.engine.value}",
                                              style: Get.textTheme.titleSmall),
                                        ],
                                      ),
                                    ),
                                    IconButtonWidget(
                                      icon: Icons.close,
                                      onPressed: () {
                                        brandController
                                            .updateSearchButton(false);
                                      },
                                    )
                                  ],
                                )
                              : Column(
                                  children: [
                                    DropdownWidget(
                                      items: brandController.allBrands
                                          .map((brand) => DropdownMenuItem(
                                                value: brand.brandId,
                                                child: Text(
                                                  brand.brandName!,
                                                ),
                                              ))
                                          .toList(),
                                      value: brandController.brandId.value,
                                      borderRadius: kBorderRadius4,
                                      onChanged: (val) {
                                        brandController.brandId.value = val;

                                        brandController.modelId.value = null;
                                        brandController.engineId.value = null;
                                        brandController.getModels(val);
                                        brandController.brand.value =
                                            brandController.allBrands
                                                .where((brand) =>
                                                    brand.brandId == val)
                                                .first
                                                .brandName!;
                                      },
                                      hint: "Make",
                                    ),
                                    kVerticalSpace8,
                                    Row(
                                      children: [
                                        Expanded(
                                          child: DropdownWidget(
                                            items: brandController.allModels
                                                .map(
                                                    (model) => DropdownMenuItem(
                                                          value: model.modelId,
                                                          child: Text(
                                                            model.modelName!,
                                                          ),
                                                        ))
                                                .toList(),
                                            value:
                                                brandController.modelId.value,
                                            borderRadius: kBorderRadius4,
                                            onChanged: (val) {
                                              brandController.modelId.value =
                                                  val;
                                              brandController.engineId.value =
                                                  null;
                                              brandController.getEngines(
                                                  brandController.brandId.value,
                                                  brandController
                                                      .modelId.value);
                                              brandController.model.value =
                                                  brandController.allModels
                                                      .where((model) =>
                                                          model.modelId == val)
                                                      .first
                                                      .modelName!;
                                            },
                                            hint: "Model",
                                          ),
                                        ),
                                        kHorizontalSpace8,
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Select Year"),
                                                    content: SizedBox(
                                                      // Need to use container to add size constraint.
                                                      width: 300,
                                                      height: 300,
                                                      child: YearPicker(
                                                        firstDate:
                                                            DateTime(1966),
                                                        lastDate:
                                                            DateTime.now(),
                                                        initialDate:
                                                            DateTime.now(),
                                                        // save the selected date to _selectedDate DateTime variable.
                                                        // It's used to set the previous selected date when
                                                        // re-showing the dialog.
                                                        selectedDate:
                                                            brandController
                                                                .selectedDate
                                                                .value,
                                                        onChanged: (DateTime
                                                            dateTime) {
                                                          brandController
                                                                  .year.value =
                                                              dateTime.year
                                                                  .toString();
                                                          brandController
                                                              .updateDate(
                                                                  dateTime);

                                                          // close the dialog when year is selected.
                                                          Navigator.pop(
                                                              context);

                                                          // Do something with the dateTime selected.
                                                          // Remember that you need to use dateTime.year to get the year
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            child: Container(
                                                height: 45.h,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        kBorderRadius4,
                                                    color: kWhiteColor,
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300,
                                                        width: 1.w)),
                                                child: Center(
                                                    child: Text(
                                                  brandController.selectedDate
                                                          .value.year
                                                          .toString() ??
                                                      "Year",
                                                  style: kHintStyle,
                                                  textAlign: TextAlign.center,
                                                ))),
                                          ),
                                        ),
                                      ],
                                    ),
                                    kVerticalSpace8,
                                    DropdownWidget(
                                      items: brandController.allEngines
                                          .map((engine) => DropdownMenuItem(
                                                value: engine.engineId,
                                                child: Text(
                                                  engine.engineName!,
                                                ),
                                              ))
                                          .toList(),
                                      value: brandController.engineId.value,
                                      borderRadius: kBorderRadius4,
                                      onChanged: (val) {
                                        brandController.engineId.value = val;

                                        brandController.engine.value =
                                            brandController.allEngines
                                                .where((engine) =>
                                                    engine.engineId == val)
                                                .first
                                                .engineName!;
                                      },
                                      hint: "Engine",
                                    ),
                                    kVerticalSpace8,
                                    ButtonWidget(
                                        text: "Search Car",
                                        onPressed: () {
                                          brandController
                                              .updateSearchButton(true);
                                        },
                                        width: 1.sw,
                                        borderRadius: kBorderRadius8,
                                        color: kAccentColor),
                                  ],
                                )),
                      kVerticalSpace16,
                      Text(
                        "Car Parts",
                        style: Get.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),

                kVerticalSpace16,

                GetBuilder<CategoryController>(
                  builder: (categoryController) => SizedBox(
                    width: 1.sw,
                    height: 0.5.sh,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 4.w,
                          crossAxisSpacing: 4.w,
                          crossAxisCount: 3,
                          childAspectRatio: 1),
                      itemCount:
                          categoryController.searchedCategories.length > 9
                              ? 9
                              : categoryController.searchedCategories.length,
                      itemBuilder: (context, index) {
                        var item = categoryController.searchedCategories[index];
                        return InkWell(
                            onTap: () {
                              categoryController
                                  .getSubCategories(item.categoryId!);
                              Get.toNamed(Routes.subCategoriesScreen);
                            },
                            child: Container(
                              color: kWhiteColor,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      flex: 5,
                                      child: ImageWidget(
                                        item.imageUrl,
                                        width: 1.sw,
                                        fit: BoxFit.fitHeight,
                                      )),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.all(2.w),
                                      child: Text(item.categoryName!,
                                          textAlign: TextAlign.center,
                                          style: Get.textTheme.labelSmall
                                              ?.copyWith(fontSize: 9.sp)),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      },
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),

                GetBuilder<CategoryController>(
                    builder: (categoryController) => Column(
                          children: categoryController.allCategoriesAndProducts
                              .map(
                                (element) => MenuCardWidget(
                                    category: element.category,
                                    products: element.products,
                                    categoryController: categoryController),
                              )
                              .toList(),
                        )),

                // MenuCardWidget(imageUrl: "assets/images/bg-accent.png",iconUrl: "assets/images/accessories.png",title: "The best car accessories",
                //   headingOne: "Car",
                //   headingTwo: "Accessories",
                //   subHeading: "Car Cover, Car Security, Seat Cover, Stereo".toUpperCase(),
                // ),
                //
                // MenuCardWidget(imageUrl: "assets/images/bg-accent.png",title: "Best selling oils and fluids",iconUrl: "assets/images/oilLubes.png",
                //   headingOne: "Oil &",
                //   headingTwo: "Lubes",
                //   subHeading: "Change oil on time make your car work fine".toUpperCase(),),
                //
                // MenuCardWidget(imageUrl: "assets/images/bg-accent.png",title: "Superior quality products",iconUrl: "assets/images/44.png",
                //   headingOne: "",
                //   headingTwo: "Upgrade",
                //   subHeading: "Suspension, Lighting, Bumpers, Steps, recovery".toUpperCase(),),
                //
                // MenuCardWidget(imageUrl: "assets/images/bg-accent.png",title: "The best upgrade deals",iconUrl: "assets/images/tools.png",
                //   headingOne: "",
                //   headingTwo: "Tools",
                //   subHeading: "We have things that fit your needs".toUpperCase(),),
                //
                // MenuCardWidget(imageUrl: "assets/images/bg-accent.png",title: "The best deals of car batteries",iconUrl:  "assets/images/batteries.png",
                //   headingOne: "Batteries",
                //   headingTwo: "Best Deals",
                //   subHeading: "Nothing runs \nwithout battery".toUpperCase(),),
                //
                // MenuCardWidget(imageUrl: "assets/images/bg-accent.png",title: "Best Tool Deals",iconUrl: "assets/images/wheelsTires.png",
                //   headingOne: "Armour",
                //   headingTwo: "Brakes",
                //   subHeading: "Stop with power with a \nnoise of a feather".toUpperCase(),),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MenuCardWidget extends StatelessWidget {
  MenuCardWidget(
      {Key? key,
      required this.category,
      required this.products,
      required this.categoryController})
      : super(key: key);

  Category category;
  List<Product> products = [];
  CategoryController categoryController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.w),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              categoryController.getSubCategories(category.categoryId!);
              Get.toNamed(Routes.subCategoriesScreen);
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                ImageWidget(
                  "assets/images/bg-accent.png",
                  width: 1.sw,
                  height: 0.16.sh,
                  fit: BoxFit.fill,
                  isLocalImage: true,
                ),
                Row(
                  children: [
                    kHorizontalSpace12,
                    Container(
                        padding: EdgeInsets.all(0.01.sh),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: kWhiteColor, width: 6.w)),
                        child: ImageWidget(
                          category.imageTw0Url ?? category.imageUrl,
                          width: 0.08.sh,
                          height: 0.08.sh,
                          fit: BoxFit.fill,
                          isLocalImage: false,
                        )),
                    kHorizontalSpace12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 0.15.sw),
                            child: Text(category.categoryName!,
                                style: Get.textTheme.titleLarge?.copyWith(
                                    color: kWhiteColor,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 22.sp)),
                          ),
                          // Text(headingTwo,style: Get.textTheme.titleLarge.copyWith(color: kWhiteColor,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic, fontSize: 22.sp)),
                          // Padding(
                          //   padding: EdgeInsets.only(right: 0.15.sw,top: 4.w),
                          //   child: Text(subHeading,style: Get.textTheme.bodySmall.copyWith(color: kWhiteColor,fontWeight: FontWeight.w700,fontStyle: FontStyle.italic, fontSize: 8.sp)),
                          // )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(
                  "The best ${category.categoryName}",
                  style: Get.textTheme.bodyMedium,
                )),
                InkWell(
                  onTap: () {
                    var controller = Get.put(ProductController());

                    controller.resetFilters();
                    controller.categoryId.value = category.categoryId!;
                    controller.getProducts();
                    Get.toNamed(Routes.productsScreen);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kAccentColor),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
                      child: Text(
                        "View All",
                        style: Get.textTheme.titleSmall
                            ?.copyWith(color: kAccentColor),
                      )),
                )
              ],
            ),
          ),
          SizedBox(
              height: 0.3.sh,
              width: 1.sw,
              child: products.isEmpty
                  ? ImageWidget(
                      "assets/images/no-data.png",
                      width: 0.2.sh,
                      height: 0.2.sh,
                      isLocalImage: true,
                      fit: BoxFit.fill,
                    )
                  : ListView.builder(
                      itemCount: products.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              Get.toNamed(Routes.addToCartScreen,
                                  arguments: products[index]);
                            },
                            child: Card(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                height: 0.3.sh,
                                width: 0.55.sw,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: ImageWidget(
                                        products[index].images.first,
                                        height: 0.45.sw,
                                        width: 0.45.sw,
                                        fit: BoxFit.fill,
                                        isLocalImage: false,
                                      ),
                                    ),
                                    kVerticalSpace4,
                                    FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                            products[index].productName!,
                                            style: Get.textTheme.bodySmall)),
                                    kVerticalSpace4,
                                    Text(
                                      "$kCurrency ${products[index].price.toString()}",
                                      style: Get.textTheme.titleSmall?.copyWith(
                                          color: kAccentColor,
                                          fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )))
        ],
      ),
    );
  }
}

class EStoreMenuWidget extends StatelessWidget {
  const EStoreMenuWidget({Key? key, required this.text, required this.imageUrl})
      : super(key: key);

  final String text;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.28.sw,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 34.r,
            backgroundColor: kAccentColor,
            child: ImageWidget(imageUrl,
                fit: BoxFit.fill,
                isLocalImage: false,
                height: 45.w,
                width: 45.w),
          ),
          kVerticalSpace8,
          SizedBox(
              height: 0.05.sh,
              child: Text(
                text,
                style: Get.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 11.sp),
                textAlign: TextAlign.center,
                overflow: TextOverflow.fade,
              ))
        ],
      ),
    );
  }
}
