import 'dart:io';

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/company_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/screens/home_screen.dart';
import 'package:careqar/ui/screens/vehicle/bikes_screen.dart';
import 'package:careqar/ui/screens/vehicle/number_plates_screen.dart';
import 'package:careqar/ui/screens/vehicle/vehicle_home_screen.dart';
import 'package:careqar/ui/screens/view_property_screen.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:careqar/ui/widgets/remove_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyScreen extends StatelessWidget {


  late CompanyController controller;
  CompanyScreen({Key? key}) : super(key: key){
    initData();
      //controller.getCompanies();


  }

  void initData() {
     controller =Get.put<CompanyController>(CompanyController());
     controller.companyStatus.value=Status.loading;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp)async {

      // Get Company if not available or by its ID, If it is sent as argument than assign it

      if(Get.arguments is int){
        await controller.getCompany(Get.arguments,type: Get.parameters["type"]);

      }
      else{
        controller.company=Get.arguments;
        controller.companyStatus.value=Status.success;
      }

      // check type and then load all the select company ads
      if(Get.parameters["type"]=="Real State"){
        controller.getAds(controller.company!);
      }
      else if(Get.parameters["type"]=="Car"){
        controller.getCars(controller.company!);
      }
      else if(Get.parameters["type"]=="Bike"){
        controller.getBikes(controller.company!);
      }
      else{
        controller.getNumberPlates(controller.company!);
      }



    });
  }


  @override
  Widget build(BuildContext context) {



    return Scaffold(backgroundColor: kWhiteColor,
      body: GetBuilder<CompanyController>(
        builder: (controller)=>
        controller.companyStatus.value==Status.loading?

            const CircularLoader():

            controller.companyStatus.value==Status.error?
            Center(
              child: Text(kCouldNotLoadData.tr,
                  style: kTextStyle16),
            )

                :


         NestedScrollView(
          headerSliverBuilder: (BuildContext context,
              bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                  backgroundColor: kWhiteColor,
                  iconTheme: const IconThemeData(color: kBlackColor),
                  expandedHeight: 0.25.sh,
                  pinned: true,
                  title: Row(
                    children: [
                      Expanded(
                        child: Text("Profile".tr.toUpperCase(),
                          textAlign: TextAlign.center,maxLines: 1,style: kAppBarStyle,),
                      ),
            GetBuilder<CompanyController>(builder: (controller)=>
                           ButtonWidget(text: controller.company!.followId!=null?"Unfollow":"Follow", onPressed: ()=>controller.followUnfollow(controller.company),
                               height: 30.h)

                      )
                    ],
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background: SizedBox(
                      height: double.infinity,
                      child: Stack(
                        children: [
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Get.toNamed(Routes.viewImageScreen,
                                      arguments: controller.company!.image,parameters: {"index":0.toString()});
                                },
                                child: ImageWidget(
                                  controller.company!.image,
                                  width: double.infinity,
                                  height:double.infinity,
                                  fit: BoxFit.fill,

                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  height:20.h,width: 1.sw,
                                  decoration: const BoxDecoration(
                                      boxShadow:[ BoxShadow(
                                        color: Colors.white,
                                        spreadRadius: 15,
                                        blurRadius: 15,
                                        offset: Offset(0, 15),

                                      )]
                                  ),
                                ),),
                            ],
                          ),

                          // Positioned(
                          //   bottom: 0,
                          //   child:
                          // ),

                        ],
                      ),
                    ),
                  ), systemOverlayStyle: SystemUiOverlayStyle.dark),
            ];
          },
          body: RemoveSplash(
            child: SingleChildScrollView(

              child: Column(
                children: [
                  SizedBox(
                    width: 1.sw,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: kPrimaryColor),
                                shape: BoxShape.circle
                            ),
                            child: ImageWidget(controller.company!.logo,isCircular: true,height: 90.r,width: 90.r,fit: BoxFit.cover,)),
                        kVerticalSpace12,
                        Text("${controller.company!.companyName}".toUpperCase(),style: kTextStyle16,),
                        kVerticalSpace4,
                        Text(controller.company!.description??"NoDescription".tr,style: kTextStyle14.copyWith(color:kGreyColor),),

                        kVerticalSpace4,

                        // Contact Icons and Links

                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 40.w,
                              child: OutlinedButton(onPressed: ()async{
                                await  launch("tel://${controller.company!.contactNo}");
                              },
                                style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    side: const BorderSide(color: Colors.transparent)
                                ), child:Icon(MaterialCommunityIcons.phone,color: kAccentColor,size: 25.w),
                              ),
                            ),
                            SizedBox(
                              width: 40.w,
                              child: OutlinedButton(onPressed: ()async{
                                String url;
                                if (Platform.isIOS) {
                                  url =
                                  "whatsapp://wa.me/${controller.company!.contactNo}/?text=Hello";
                                } else {
                                  url =
                                  "whatsapp://send?phone=${controller.company!.contactNo}&text=Hello";
                                }

                                try{

                                  await launchUrl(Uri.parse(url),);

                                }catch(e){
                                  showSnackBar(message: "CouldNotLaunchWhatsApp");
                                }
                              },
                                style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    side: const BorderSide(color: Colors.transparent)
                                ), child: Image.asset("assets/images/whatsapp.png",width: 22.w,),
                              ),
                            ),
                            SizedBox(
                              width: 40.w,
                              child: OutlinedButton(onPressed: ()async{
                                final Uri emailLaunchUri = Uri(
                                  scheme: 'mailto',
                                  path: '${controller.company!.email}',
                                  query: encodeQueryParameters(<String, String>{
                                    'subject': ''
                                  }),
                                );
                                if (await canLaunch(emailLaunchUri.toString())) {
                                  await launch(emailLaunchUri.toString());
                                } else {
                                  //  throw 'Could not launch';
                                }
                              },
                                style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    side: const BorderSide(color: Colors.transparent)
                                ), child:Icon(MaterialCommunityIcons.email,color: kAccentColor,size: 25.w,),
                              ),
                            ),

                          ],
                        ),

                        kVerticalSpace8,

                        Divider(endIndent: 0.1.sw,indent: 0.1.sw,),
                        Container(
                            margin: EdgeInsets.symmetric(horizontal: 0.1.sw),
                            child:  GetBuilder<CompanyController>(builder: (controller)=>  Row(
                              children: [
                                Expanded(
                                  child: Column(
                                      children: [
                                        Text("${controller.company!.followers}",style: kTextStyle14,),
                                        kVerticalSpace4,
                                        FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text("Followers".tr,style: kTextStyle14,)),
                                      ]),
                                ),

                                SizedBox(
                                  height: 40.w,
                                  child: const VerticalDivider(),
                                ),


                                Expanded(
                                    child:   Column(
                                        children: [
                                          Text("${controller.company!.totalAds}",style: kTextStyle14,),
                                          kVerticalSpace4,
                                          Text("Ads".tr,style: kTextStyle14,),
                                        ])),

                                SizedBox(
                                  height: 40.w,
                                  child: const VerticalDivider(),
                                ),


                                Expanded(
                                    child:   Column(
                                        children: [
                                          Text("${controller.company!.totalViews}",style: kTextStyle14,),
                                          kVerticalSpace4,
                                          FittedBox(

                                              fit: BoxFit.scaleDown,
                                              child: Text("TotalViews".tr,style: kTextStyle14,)),
                                        ]))
                              ],
                            ),
                            )),
                        Divider(endIndent: 0.1.sw,indent: 0.1.sw,),


                      ],
                    ),
                  ),
                  Get.parameters["type"]=="Real State"?
                  GetBuilder<CompanyController>(builder: (controller)=>
                      Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [


                          Padding(
                            padding: kScreenPadding,
                            child: Row(
                              children: [
                                Text("${"Ads".tr} (${controller.company!.ads.length})",style: kTextStyle16,),
                                kHorizontalSpace8,
                                IconButtonWidget(color: kAccentColor,
                                  onPressed: (){
                                    controller.isGridView=!controller.isGridView;
                                    controller.update();
                                  },icon:controller.isGridView?
                                  MaterialCommunityIcons.view_list: MaterialCommunityIcons.view_grid
                                  ,)
                              ],
                            ),
                          ),

                          controller
                              .adsStatus.value ==
                              Status.loading
                              ? CircularLoader():

                          controller.adsStatus.value ==
                              Status.error
                              ? Center(
                            child: Text(kCouldNotLoadData.tr,
                                style: kTextStyle16),
                          )
                              :

                          controller.company!.ads.isEmpty?
                          Center(
                            child: Text("NoDataFound".tr,
                                style: kTextStyle16),
                          ):
                          controller.isGridView?  GridView.builder(
                              padding: EdgeInsets.zero,
                              physics: const PageScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:controller.company!.ads.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,
                              childAspectRatio: 0.45, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
                              itemBuilder: (context, index) {

                                var item = controller.company!.ads[index];
                                return PropertyItem(item: item,);


                              }):    ListView.builder(
                              padding: EdgeInsets.zero,   physics: const PageScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:controller.company!.ads.length,
                              itemBuilder: (context, index) {

                                var item = controller.company!.ads[index];
                                return PropertyItem(item: item,isGridView: false,);


                              }),

                        ],
                      ),
                  ):
                  Get.parameters["type"]=="Car"?
                  GetBuilder<CompanyController>(builder: (controller)=>
                      Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [


                          Padding(
                            padding: kScreenPadding,
                            child: Row(
                              children: [
                                Text("${"Ads".tr} (${controller.company!.cars.length})",style: kTextStyle16,),
                                kHorizontalSpace8,
                                IconButtonWidget(color: kAccentColor,
                                  onPressed: (){
                                    controller.isGridView=!controller.isGridView;
                                    controller.update();
                                  },icon:controller.isGridView?
                                  MaterialCommunityIcons.view_list: MaterialCommunityIcons.view_grid
                                  ,)
                              ],
                            ),
                          ),

                          controller
                              .adsStatus.value ==
                              Status.loading
                              ? CircularLoader():

                          controller.adsStatus.value ==
                              Status.error
                              ? Center(
                            child: Text(kCouldNotLoadData.tr,
                                style: kTextStyle16),
                          )
                              :

                          controller.company!.cars.isEmpty?
                          Center(
                            child: Text("NoDataFound".tr,
                                style: kTextStyle16),
                          ):
                          controller.isGridView?  GridView.builder(
                              padding: EdgeInsets.zero,
                              physics: const PageScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:controller.company!.cars.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,
                              childAspectRatio: 0.45, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
                              itemBuilder: (context, index) {

                                var item = controller.company!.cars[index];
                                return CarItem(item: item,);


                              }):    ListView.builder(
                              padding: EdgeInsets.zero,   physics: const PageScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:controller.company!.cars.length,
                              itemBuilder: (context, index) {

                                var item = controller.company!.cars[index];
                                return CarItem(item: item,isGridView: false,);


                              }),

                        ],
                      ),
                  ):
                  Get.parameters["type"]=="Bike"?
                  GetBuilder<CompanyController>(builder: (controller)=>
                      Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [


                          Padding(
                            padding: kScreenPadding,
                            child: Row(
                              children: [
                                Text("${"Ads".tr} (${controller.company!.bikes.length})",style: kTextStyle16,),
                                kHorizontalSpace8,
                                IconButtonWidget(color: kAccentColor,
                                  onPressed: (){
                                    controller.isGridView=!controller.isGridView;
                                    controller.update();
                                  },icon:controller.isGridView?
                                  MaterialCommunityIcons.view_list: MaterialCommunityIcons.view_grid
                                  ,)
                              ],
                            ),
                          ),

                          controller
                              .adsStatus.value ==
                              Status.loading
                              ? CircularLoader():

                          controller.adsStatus.value ==
                              Status.error
                              ? Center(
                            child: Text(kCouldNotLoadData.tr,
                                style: kTextStyle16),
                          )
                              :

                          controller.company!.bikes.isEmpty?
                          Center(
                            child: Text("NoDataFound".tr,
                                style: kTextStyle16),
                          ):
                          controller.isGridView?  GridView.builder(
                              padding: EdgeInsets.zero,
                              physics: const PageScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:controller.company!.bikes.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,
                              childAspectRatio: 0.45, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
                              itemBuilder: (context, index) {

                                var item = controller.company!.bikes[index];
                                return BikeItem(item: item,);


                              }):    ListView.builder(
                              padding: EdgeInsets.zero,   physics: const PageScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:controller.company!.bikes.length,
                              itemBuilder: (context, index) {

                                var item = controller.company!.bikes[index];
                                return BikeItem(item: item,isGridView: false,);


                              }),

                        ],
                      ),
                  ):
                  GetBuilder<CompanyController>(builder: (controller)=>
                      Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [


                          Padding(
                            padding: kScreenPadding,
                            child: Row(
                              children: [
                                Text("${"Ads".tr} (${controller.company!.numberPlates.length})",style: kTextStyle16,),
                                kHorizontalSpace8,
                                IconButtonWidget(color: kAccentColor,
                                  onPressed: (){
                                    controller.isGridView=!controller.isGridView;
                                    controller.update();
                                  },icon:controller.isGridView?
                                  MaterialCommunityIcons.view_list: MaterialCommunityIcons.view_grid
                                  ,)
                              ],
                            ),
                          ),

                          controller
                              .adsStatus.value ==
                              Status.loading
                              ? CircularLoader():

                          controller.adsStatus.value ==
                              Status.error
                              ? Center(
                            child: Text(kCouldNotLoadData.tr,
                                style: kTextStyle16),
                          )
                              :

                          controller.company!.numberPlates.isEmpty?
                          Center(
                            child: Text("NoDataFound".tr,
                                style: kTextStyle16),
                          ):
                          controller.isGridView?  GridView.builder(
                              padding: EdgeInsets.zero,
                              physics: const PageScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:controller.company!.numberPlates.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,
                              childAspectRatio: 0.45, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
                              itemBuilder: (context, index) {

                                var item = controller.company!.numberPlates[index];
                                return NumberPlateItem(item: item,);


                              }):    ListView.builder(
                              padding: EdgeInsets.zero,   physics: const PageScrollPhysics(),
                              shrinkWrap: true,
                              itemCount:controller.company!.numberPlates.length,
                              itemBuilder: (context, index) {

                                var item = controller.company!.numberPlates[index];
                                return NumberPlateItem(item: item,isGridView: false,);


                              }),

                        ],
                      ),
                  ),
                ],
              )

            ),
          )
        ),
      )

     );
  }
}
