
import 'package:careqar/controllers/add_to_cart_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../../constants/colors.dart';
import '../../../constants/style.dart';
import '../../../models/product_model.dart';
import '../../../routes.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/image_widget.dart';

class AddToCartScreen extends GetView<AddToCartController> {
   const AddToCartScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=> Future.value(!EasyLoading.isShow),
      child:  Scaffold(
          appBar:buildAppBar(context,title: "AddToCart"),
          body: GetBuilder<AddToCartController>(
            builder: (controller) {

              return
                controller.status.value==Status.success?

                SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 0.3.sh,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: double.infinity,
                          autoPlayCurve: Curves.linearToEaseOut,
                          autoPlay: true,
                          scrollPhysics: BouncingScrollPhysics(),
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
                        items:  controller.product?.images.map((item) {
                          return Builder(
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: (){
                                  Get.toNamed(Routes.viewImageScreen,
                                      arguments: controller.product?.images,parameters: {"index":controller.product!.images.indexOf(item).toString()});
                                },
                                child: ImageWidget(
                                  item,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,

                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: kScreenPadding,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("${controller.product?.productName}".toUpperCase(),style: kTextStyle18,),
                          kVerticalSpace4,
                          Text("${controller.product?.description??''}",style: kTextStyle14,),
                          kVerticalSpace20,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap:controller.quantity>1? (){
                                  controller.quantity--;
                                  controller.update();
                                }:null,
                                child: Container(width: 40.w,height: 40.h,
                                  child: Icon(MaterialCommunityIcons.minus,color: kAccentColor,),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: kAccentColor,width: 2)
                                  ),
                                ),
                              ),
                              kHorizontalSpace20,
                              Text(controller.quantity.toString(),style: TextStyle(fontSize: 24,fontWeight: FontWeight.w600,)),
                              kHorizontalSpace20,
                              InkWell(
                                onTap: (){
                                  controller.quantity++;
                                  controller.update();

                                },
                                child: Container(width: 40.w,height: 40.h,child: Icon(Icons.add,color: kAccentColor,),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: kAccentColor,width: 2)
                                  ),
                                ),
                              ),
                            ],
                          ),
                          kVerticalSpace28,


                          _buildChoices(),

                          kVerticalSpace16,



                          ButtonWidget(color: kAccentColor,text:"${"Add".tr} (${getPrice(controller.price*controller.quantity)})",onPressed:controller.addToCart,),

                        ],
                      ),
                    )
                      ],
                ),
              ):CircularLoader();
            }
          ),
        ),
    );
  }




  _buildChoices(){
    return GetBuilder<AddToCartController>(builder: (controller)=>

        controller.choicesStatus.value==Status.success?
        Column(
          children: [
            controller.product!.price!>0? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Price".tr.toUpperCase(),style: TextStyle(fontSize: 14.sp,color: Colors.black54),),
                kVerticalSpace8,
                Container(
                    height: 45.h,
                    width: 1.sw,
                    decoration: BoxDecoration(
                        color:  kAccentColor,
                        borderRadius:
                        kBorderRadius4),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Price".tr,
                          maxLines: 1,overflow: TextOverflow.ellipsis,
                          style: kLightTextStyle16,textAlign: TextAlign.center,),
                        kVerticalSpace4,
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(getPrice(controller.product!.price!),
                            style: TextStyle(color: kWhiteColor,fontSize: 11.sp),),
                        )
                      ],
                    )),
                kVerticalSpace20,
              ],
            ):Container(),
            ListView.separated(

              separatorBuilder: (context,index){
                return kVerticalSpace8;
              },
              itemBuilder: (context,index){

                ProductChoice? choice=controller.productChoiceModel?.productChoices[index];
                return  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text("${choice?.choice}".toUpperCase(),
                      style: TextStyle(fontSize: 14.sp,color: Colors.black54),),
                    kVerticalSpace8,
                    Container(
                      width: 1.sw,
                      height: 45.h,
                      decoration: BoxDecoration(
                          border: choice!.allowMultiple!?null:
                          Border.all(color: kAccentColor,width: 2),borderRadius:
                      kBorderRadius4),

                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        separatorBuilder: (context,index){
                          return kHorizontalSpace8;
                        },
                        scrollDirection: Axis.horizontal,
                        itemCount: choice.options.length,
                        itemBuilder: (context,optionIndex){

                          return  InkWell(
                            onTap: (){

                              if(choice.allowMultiple!){
                                if(controller.selectedOptions[choice.choiceId.toString()]!.contains(choice.options[optionIndex])){
                                  controller.price-=choice.options[optionIndex].price!;
                                  controller.selectedOptions[choice.choiceId.toString()]?.remove(choice.options[optionIndex]);

                                }else{
                                  controller.price+=choice.options[optionIndex].price!;
                                  controller.selectedOptions[choice.choiceId.toString()]?.add(choice.options[optionIndex]);

                                }
                              }else{
                                if(!controller.selectedOptions[choice.choiceId.toString()]!.contains(choice.options[optionIndex])){
                                  controller.price-=controller.selectedOptions[choice.choiceId.toString()]!.first.price!;
                                  controller.selectedOptions[choice.choiceId.toString()]?.remove(controller.selectedOptions[choice.choiceId.toString()]?.first);
                                  controller.selectedOptions[choice.choiceId.toString()]?.add(choice.options[optionIndex]);
                                  controller.price+=choice.options[optionIndex].price!;

                                }
                              }
                            controller.update();
                            },
                            child: ClipRRect(
                              borderRadius:kBorderRadius4,
                              child: Container(
                                  width: choice.options.length>1? (1.sw-kScreenPadding.horizontal)/2:1.sw-kScreenPadding.horizontal-3.5.w,
                                  decoration: BoxDecoration(
                                      color: controller.selectedOptions[choice.choiceId.toString()]!.
                                      contains(choice.options[optionIndex])? kAccentColor:Colors.transparent,
                                      border: choice.allowMultiple!?
                                      Border.all(color: kAccentColor,width: 2):null
                                      ,borderRadius:kBorderRadius4),

                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("${choice.options[optionIndex].optionText}",
                                        maxLines: 1,overflow: TextOverflow.ellipsis,
                                        style: kLightTextStyle16.copyWith(color: controller.selectedOptions[choice.choiceId.toString()]!.
                                        contains(choice.options[optionIndex])? kWhiteColor:kAccentColor),textAlign: TextAlign.center,),
                                      kVerticalSpace4,
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text("${getPrice(choice.options[optionIndex].price!)}",
                                          style: TextStyle(color:  controller.selectedOptions[choice.choiceId.toString()]!.
                                          contains(choice.options[optionIndex])? kWhiteColor:kAccentColor,fontSize: 11),),
                                      )
                                    ],
                                  )),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },itemCount:controller.productChoiceModel!.productChoices.length,shrinkWrap: true,
              physics: PageScrollPhysics(),
            ),
          ],
        ):
            CircularLoader()

    );
  }

}
