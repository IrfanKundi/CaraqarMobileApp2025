

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/company_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class ShowroomScreen extends GetView<CompanyController> {

  final String type;
   ShowroomScreen(this.type,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:    SafeArea(
        child:    Column(
          children: [

            Padding(
              padding: kScreenPadding,
              child:Row(
                children: [
                  Expanded(
                    child: GetBuilder<CompanyController>(
                        id: "search",
                        builder: (controller)=>
                            CupertinoSearchTextField(

                              onChanged: (val){
                                controller.searchText=val.trim();
                                controller.search(val.trim());
                              },placeholder: "Search".tr,onSubmitted: (val){
                              controller.searchText=val.trim();

                              controller.search(val.trim());

                            },
                              controller: TextEditingController(text: controller.searchText),
                              onSuffixTap: (){
                                controller.searchText="";
                                controller.search(controller.searchText);
                                controller.update(["search"]);


                              },)
                    ),
                  ),
                  kHorizontalSpace8,
                  GetBuilder<CompanyController>(
        builder: (controller)=> controller.status.value == Status.loading
            ? const SizedBox():
        controller.status.value == Status.error ? const SizedBox() :
        controller.searchedCompanies.isEmpty? const SizedBox():
        InkWell(
          onTap: (){
            controller.isGridView=!controller.isGridView;
            controller.update();
          },
          child: Icon(color: kBlackColor, controller.isGridView?
          MaterialCommunityIcons.view_list: MaterialCommunityIcons.view_grid,
            size: 30.sp,
          ),
        ),
      ),
                ],
              ),
            ),


            Expanded(
              child: GetBuilder<CompanyController>(
                builder: (controller)=> controller.status.value == Status.loading ? const CircularLoader():
                controller.status.value == Status.error ? Center(
                    child: Text("$kCouldNotLoadData".tr,
                    style: kTextStyle16),) :
                controller.searchedCompanies.isEmpty?
              Center(
                  child: Text("NoDataFound".tr,
                  style: kTextStyle16)):
              !controller.isGridView?
              ListView.separated(
                  separatorBuilder: (context,index){
                    return kVerticalSpace12;
                  },
                  physics: PageScrollPhysics(),
                  shrinkWrap: true,
                  padding: kScreenPadding.copyWith(top: 0),
                  itemCount: controller.searchedCompanies.length,
                  itemBuilder: (context, index) {

                    var item = controller.searchedCompanies[index];
                    return SizedBox(
                      height: 120.h,
                      child: InkWell(
                        onTap: ()async{

                          await   Get.toNamed(Routes.companyScreen,arguments: item,parameters: {"type":type});

                        },
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            ImageWidget(item.image,fit: BoxFit.cover,width: double.infinity,height: double.infinity,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 8.w),
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: kBorderRadius4,
                              ),
                              child: Text(
                                item.companyName!.toUpperCase(),   maxLines: 1,
                                style: TextStyle(
                                    color: kWhiteColor, fontSize: 17.sp,fontWeight: FontWeight.w600),),
                            )

                          ],
                        ),
                      ),
                    );


                  }):
              GridView.builder(
                physics: PageScrollPhysics(),
                shrinkWrap: true,
                padding: kScreenPadding.copyWith(top: 0.w, bottom: 50.h),
                itemCount: controller.searchedCompanies.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // Changed to 1 for full-width cards
                  childAspectRatio: 1.2, // Adjusted ratio for the new layout
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 12.w,
                ),
                itemBuilder: (context, index) {
                  var item = controller.searchedCompanies[index];
                  return InkWell(
                    onTap: () async {
                      await Get.toNamed(Routes.companyScreen, arguments: item, parameters: {"type": type});
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                      elevation: 2,
                      child: Column(
                        children: [
                          // Header with title and Follow button
                          Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "${item.companyName}",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: kBlackColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: kLableColor, // Green color from screenshot
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Text(
                                    "Follow",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Main image with overlaid followers count
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(horizontal: 12.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Stack(
                                children: [
                                  // Main image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: ImageWidget(
                                      item.logo,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),

                                  // Followers overlay in bottom right corner
                                  Positioned(
                                    bottom: 8.h,
                                    right: 8.w,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.group, color: Colors.white, size: 12.sp),
                                          SizedBox(width: 4.w),
                                          Text(
                                            "Followers 999",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Bottom section with location only
                          Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.location_on, color: kHeaderTitle, size: 14.sp),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    item.address ?? "NoDescription".tr,
                                    style: TextStyle(
                                      color: kBlackColor,
                                      fontSize: 11.sp,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
