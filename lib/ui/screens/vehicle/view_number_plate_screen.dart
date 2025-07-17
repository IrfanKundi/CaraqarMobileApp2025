import 'dart:io';

import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/services/dynamic_link.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:careqar/ui/widgets/remove_splash.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controllers/favorite_controller.dart';
import '../../../controllers/view_number_plate_controller.dart';
import '../../../global_variables.dart';

class ViewNumberPlateScreen extends GetView<ViewNumberPlateController> {
   ViewNumberPlateScreen({Key? key}) : super(key: key){
    //print(Get.arguments);
    controller.sliderIndex(0);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(backgroundColor: kWhiteColor,
      body: Obx(() {
        var numberPlate = controller.numberPlate.value;
        return controller.status.value==Status.success? NestedScrollView(
          headerSliverBuilder: (BuildContext context,
              bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                  backgroundColor: kWhiteColor,
                  iconTheme: const IconThemeData(color: kBlackColor),
                  expandedHeight: 0.6.sh,
                  pinned: true,
                  title: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text("Details".tr.toUpperCase(),textAlign: TextAlign.center,maxLines: 1,style: kAppBarStyle,))
                          ,

                          kHorizontalSpace12,
                          IconButtonWidget(icon: MaterialCommunityIcons
                              .share_variant,
                            color: kBlackColor,
                            onPressed: () async {
                              String adUrl = await DynamicLink.createDynamicLink(false,
                                  uri: "/NumberPlates/Detail/${numberPlate!.numberPlateId}",
                                  title: numberPlate.title,
                                  desc: numberPlate.description,
                                  image: numberPlate.images.first);
                              String webUrl = "https://www.caraqar.co/Properties/Detail/${numberPlate.numberPlateId}";
                              // var message = "Hey! you might be interested in this.\n$adUrl\nor Check this ad on Car aqar\n$webUrl";
                              var message = "Hey! you might be interested in this.\n$adUrl";

                              Share.share(message);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background: Stack(
                      alignment: Alignment.center,
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: double.infinity,
                            autoPlayCurve: Curves.linearToEaseOut,
                            autoPlay: true,
                            scrollPhysics: const BouncingScrollPhysics(),
                            enableInfiniteScroll: false,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            enlargeCenterPage: true,
                            enlargeStrategy:
                            CenterPageEnlargeStrategy.height,
                            initialPage: controller.sliderIndex.value,
                            onPageChanged: (index, reason) {
                              controller.sliderIndex.value=index;
                              controller.update();
                            },
                          ),
                          items:  numberPlate!.images.map((item) {
                            return Builder(
                              builder: (BuildContext context) {
                                return GestureDetector(
                                  onTap: (){
                                    Get.toNamed(Routes.viewImageScreen,
                                        arguments: numberPlate.images,parameters: {"index":numberPlate.images.indexOf(item).toString()});
                                  },
                                  child: ImageWidget(
                                    item,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.scaleDown,

                                  ),
                                );
                              },
                            );
                          }).toList(),
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
                        Positioned(
                            bottom: 40.h,
                            child: Container(width: 1.sw,
                              padding: kScreenPadding.copyWith(top: 8.w,bottom: 8.w),
                              decoration: const BoxDecoration(
                                color: Colors.black12,

                              ),

                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        Text(numberPlate.number!,
                                            maxLines: 2, textAlign: TextAlign.center,
                                            style: kLightTextStyle18),
                                        kVerticalSpace4,
                                        Row(
                                          children: [ Icon(  MaterialCommunityIcons.map_marker_outline,    size: 16.sp,
                                            color: kWhiteColor,),
                                            Expanded(
                                              child: Text(
                                                  numberPlate.cityName!, style: kTextStyle14.copyWith(color: kWhiteColor)),
                                            ),

                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      GetBuilder<ViewNumberPlateController>(
                                        builder: (controller)=>
                                            IconButtonWidget(icon: numberPlate.favoriteId>0?
                                            MaterialCommunityIcons.heart:
                                            MaterialCommunityIcons
                                                .heart_outline,
                                              color:numberPlate.favoriteId>0? kRedColor:kWhiteColor,
                                              width: 30.w,
                                              onPressed: ()async {
                                                var favController =  Get.put(FavoriteController());
                                                if(numberPlate.favoriteId>0){

                                                  if(await favController.deleteFavorite(numberPlate: numberPlate)){
                                                    controller.update();
                                                  }
                                                }else{
                                                  if(await favController.addToFavorites(numberPlate:numberPlate)){
                                                    controller.update();
                                                  }
                                                }


                                              },),
                                      ),
                                      kVerticalSpace8,
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.black38,
                                          borderRadius: kBorderRadius30,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(MaterialCommunityIcons.eye_outline,size: 16.sp,color: kWhiteColor,),
                                            Text(
                                              " ${numberPlate.clicks}",
                                              style: TextStyle(
                                                  color: kWhiteColor, fontSize: 12.sp),),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )),


                      ],
                    ),
                  ), systemOverlayStyle: SystemUiOverlayStyle.dark),
            ];
          },
          body: RemoveSplash(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(

                    padding: EdgeInsets.symmetric(horizontal: 12.w,
                        vertical: 8.w),

                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            if(numberPlate?.companyId!=null){
                              if(Get.previousRoute=="${Routes.companyScreen}?type=NumberPlate&agentAds=${numberPlate?.isAgentAd}"){
                                Get.back();
                              }else{
                                Get.offNamed(Routes.companyScreen,arguments: numberPlate?.companyId,parameters:{"type":"NumberPlate","agentAds":"${numberPlate?.isAgentAd}"});
                              }

                            }else if(numberPlate?.agentId!=null){
                              if(Get.previousRoute=="${Routes.agentScreen}?type=NumberPlate&agentAds=${numberPlate?.isAgentAd}"){
                                Get.back();
                              }else{
                                Get.offNamed(Routes.agentScreen,arguments: numberPlate?.agentId,parameters:{"type":"NumberPlate","agentAds":"${numberPlate?.isAgentAd}"});
                              }

                            }

                          },
                          child: ImageWidget(numberPlate?.agentImage==""|| numberPlate?.agentImage==null ?"assets/images/profile2.jpg":numberPlate?.agentImage,width: 70.r,height: 70.r,
                            isCircular: true,isLocalImage: numberPlate?.agentImage==""|| numberPlate?.agentImage==null,fit: BoxFit.cover,),
                        ),

                        kHorizontalSpace12,
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(numberPlate!.agentName!, style: kTextStyle16.copyWith(color: kAccentColor),),
                              kVerticalSpace4,
                              Text("Owner".tr, style: kTextStyle14.copyWith(color: kGreyColor),),

                            ],
                          ),
                        ),



                        Container(
                          width: 40.w,
                          child: OutlinedButton(onPressed: ()async{
                            await  launch("tel://${numberPlate.contactNo}");
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
                            String adUrl = await DynamicLink
                                .createDynamicLink(false,
                                uri: "/NumberPlates/Detail/${numberPlate.numberPlateId}",
                                title: numberPlate.number,
                                desc: numberPlate.description,
                                image: numberPlate.images.first);

                            String url;
                            //var message = Uri.encodeFull("Hello,\n${numberPlate.agentName}\nI would like to get more information about this ad you posted on.\n$adUrl \n or Check this ad on Car aqar \n https://www.caraqar.co/NumberPlates/Detail/${numberPlate.numberPlateId}");
                            var message = Uri.encodeFull("Hello,\n${numberPlate.agentName}\nI would like to get more information about this ad you posted on.\n$adUrl");
                            if (Platform.isIOS) {
                              url =
                              "https://wa.me/${numberPlate.contactNo}?text=$message";
                            } else {
                              url =
                              "whatsapp://send?phone=${numberPlate.contactNo}&text=$message";
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
                        // SizedBox(
                        //   width: 40.w,
                        //   child: OutlinedButton(onPressed: ()async {
                        //     controller.updateClicks(isEmail: true);
                        //
                        //     String adUrl = await DynamicLink.createDynamicLink(
                        //       false,
                        //       uri: "/NumberPlates/Detail/${numberPlate.numberPlateId}",
                        //         title: numberPlate.number,
                        //         desc: numberPlate.description,
                        //         image: numberPlate.images.first
                        //     );
                        //
                        //     String webUrl = "https://www.caraqar.co/NumberPlates/Detail/${numberPlate.numberPlateId}";
                        //     String subject = numberPlate.title!;
                        //
                        //     // Properly encode the message to handle spaces and special characters
                        //     var message = "Hello,\n${numberPlate.agentName}\nI would like to get more information about this ad you posted on.\n$adUrl\nOr check this ad on Car aqar\n$webUrl";
                        //
                        //     final Email email = Email(
                        //       body: message,
                        //       subject: subject,
                        //       recipients: [numberPlate.email!],
                        //       isHTML: false,
                        //     );
                        //
                        //     await FlutterEmailSender.send(email);
                        //   },
                        //     style: OutlinedButton.styleFrom(
                        //         padding: EdgeInsets.zero,
                        //         side: const BorderSide(color: Colors.transparent)
                        //     ), child:Icon(MaterialCommunityIcons.email,color: kAccentColor,size: 25.w,),
                        //   ),
                        // ),


                      ],
                    ),
                  ),


                  Text("CurrentPrice".tr,
                    textAlign: TextAlign.center, style: kTextStyle14.copyWith(color: kAccentColor),),
                  kVerticalSpace8,
                  Text(getPrice(numberPlate.price), textAlign: TextAlign.center,textDirection: TextDirection.ltr,
                    style: kTextStyle18.copyWith(color: kPrimaryColor),),
                  Padding(  padding: kScreenPadding,
                      child:  Column(
                        children: [

                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text("Digits".tr, style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
                                    kVerticalSpace8,
                                    Text(
                                      numberPlate.digits!,
                                      style: kTextStyle16.copyWith(color: kAccentColor),),
                                  ],
                                ),
                              ), SizedBox(
                                height: 40.h,
                                child: const VerticalDivider(),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text("Privilege".tr, style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
                                    kVerticalSpace8,
                                    Text(
                                      numberPlate.privilege!,
                                      style: kTextStyle16.copyWith(color: kAccentColor),),
                                  ],
                                ),)
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text("PlateType".tr, style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
                                    kVerticalSpace8,
                                    Text(
                                      numberPlate.plateType!,
                                      style: kTextStyle16.copyWith(color: kAccentColor),),
                                  ],
                                ),
                              ), SizedBox(
                                height: 40.h,
                                child: const VerticalDivider(),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text("City".tr, style: kTextStyle16.copyWith(fontWeight: FontWeight.bold),),
                                    kVerticalSpace8,
                                    Text(
                                      numberPlate.cityName!,
                                      style: kTextStyle16.copyWith(color: kAccentColor),),
                                  ],
                                ),
                              ),
                            ],
                          ),



                        ],



                      )),


                  Padding(
                    padding: kScreenPadding,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [


                          Text("Description".tr, style: kTextStyle16.copyWith(color: kAccentColor,fontWeight: FontWeight.bold),),
                          kVerticalSpace4,
                          Text(
                            numberPlate.description!,
                            style: kTextStyle14.copyWith(color: kAccentColor),),





                        ]
                    ),
                  )


                ],
              ),
            ),
          ),
        ):CircularLoader();
      }
      ),
    );

  }
}
