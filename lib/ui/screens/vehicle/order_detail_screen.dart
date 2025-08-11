import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/order_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/models/order_model.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/remove_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OrderDetailScreen extends GetView<OrderController> {
   OrderDetailScreen({Key? key}) : super(key: key){
    
    order=Get.arguments;
  }
  
  Order? order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: buildAppBar(context,isPrimaryAppBar: true,title: "Invoice"),
      body: SafeArea(
        child:

        Center(
          child: GetBuilder<OrderController>(
            builder: (controller) {
             return controller.detailsStatus.value==Status.success?
               Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero
                ),
                margin: kScreenPadding,
                child: RemoveSplash(
                  child: SingleChildScrollView(
                    padding: kScreenPadding,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text("Invoice".tr.toUpperCase(),style: kTextStyle18,),
                            kHorizontalSpace4,
                            Expanded(child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: AlignmentDirectional.centerStart,
                                child: Text("#${order?.invoiceNo}",style: kTextStyle18.copyWith(color: kGreyColor),))),


                            Container(
                              padding: EdgeInsets.all(4.w),
                              child: Text("${order?.orderStatus}",style: kLightTextStyle12,),
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                borderRadius: kBorderRadius4
                              ),
                            )
                          ],
                        ),
kVerticalSpace12,
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("OrderDate".tr,style: Get.textTheme.labelSmall,),
                            kHorizontalSpace4,
                            Text(order?.createdAt??"",style: Get.textTheme.labelSmall,),  ],
                        ),
                        kVerticalSpace12,

                        Row(
                          children: [
                            Expanded(
                                flex: 2,
                                child: Text("Product".tr,style: kTextStyle12.copyWith(fontWeight: FontWeight.w600),)),
                            kHorizontalSpace12,
                            Expanded(child: Text("Qty".tr,style: kTextStyle12.copyWith(fontWeight: FontWeight.w600),textAlign: TextAlign.center,)),
                            kHorizontalSpace12,
                            Expanded(child: Text("Price".tr,style: kTextStyle12.copyWith(fontWeight: FontWeight.w600),textAlign: TextAlign.end,))
                          ],
                        ),  Divider(),
                        ListView.builder(itemCount: order?.items.length,itemBuilder: (context,index){
                          var item = order?.items[index];
                          return Container(
                            padding: EdgeInsets.all(8.w),
                            color: index%2==0?Colors.grey.shade100:Colors.transparent,
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: Text("${item?.productName}",maxLines: 1,style: kTextStyle12,)),

                                kHorizontalSpace12,
                                Expanded(child: Text("${item?.quantity}",style: kTextStyle12,textAlign: TextAlign.center,)),
                                kHorizontalSpace12,
                                Expanded(child: FittedBox(
                                    fit:BoxFit.scaleDown,
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: Text("${getPrice(item!.totalPrice!)}",style: kTextStyle12,)))
                              ],
                            ),
                          );
                        },

                        shrinkWrap: true,
                          physics: PageScrollPhysics(),
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text("Total".tr,style: kTextStyle16,),
                            kHorizontalSpace4,
                            Expanded(child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: AlignmentDirectional.centerEnd,
                                child: Text("${getPrice(order!.totalPrice!)}",style: kTextStyle16,))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ):CircularLoader();
            }
          ),
        ),
      ),
    );
  }
}
