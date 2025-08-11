import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/company_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class CompaniesScreen extends GetView<CompanyController> {

  String? type;


   CompaniesScreen({Key? key}) : super(key: key){
     type=Get.arguments;
     if(type=="Real State"){
       controller.getCompanies(type: "Real State");
     }else if(type=="Car"){
       controller.getCompanies(type: "Car");
     }else if(type=="Bike"){
       controller.getCompanies(type: "Bike");
     }else{
       controller.getCompanies(type: "NumberPlate");
     }
  }





  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: buildAppBar(context,title: type=="Real State"?"Companies":"Showroom",),
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

                          await   Get.toNamed(Routes.companyScreen,arguments: item,parameters: {"type":Get.arguments});

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
                        padding: kScreenPadding.copyWith(top: 0.w,bottom: 50.h),
                        itemCount: controller.searchedCompanies.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                        childAspectRatio: 1, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
                        itemBuilder: (context, index) {

                          var item = controller.searchedCompanies[index];
                          return InkWell(
                            onTap: ()async{

                              await  Get.toNamed(Routes.companyScreen,arguments: item,parameters: {"type":Get.arguments});
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              child: Padding(
                                padding:  EdgeInsets.all(8.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ImageWidget(item.logo,fit: BoxFit.cover,isCircular: true,width: 80.r,height: 80.r,),
                                    Text(
                                      "${item.companyName}".toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: kTextStyle14,
                                      maxLines: 1,
                                    ),
                                    kVerticalSpace4,
                                    Text(
                                      "${item.description??"NoDescription".tr}",
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      style: TextStyle(color: kGreyColor, fontSize: 13.sp),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );


                        }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
