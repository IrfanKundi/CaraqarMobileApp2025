import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/cart_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/global_variables.dart';
import 'package:careqar/models/cart_model.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/button_widget.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/icon_button_widget.dart';
import 'package:careqar/user_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../../widgets/image_widget.dart';


class CartScreen extends StatefulWidget {
  const  CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context,title: "MyCart",  actions: [
      Padding(
      padding:  EdgeInsetsDirectional.only(end: 16.w),
      child: GetBuilder<CartController>(
          builder: (controller)  {
            return IconButtonWidget(color: kAccentColor,
              onPressed: (){
                controller.isGridView=!controller.isGridView;
                controller.update();
              },icon:controller.isGridView?
              MaterialCommunityIcons.view_list: MaterialCommunityIcons.view_grid
              ,);
          }
      ),
    )]),
      body:
    SafeArea(
      child:   GetBuilder<CartController>(
        builder: (controller)=>
        controller
            .status.value ==
            Status.loading
            ? CircularLoader()
            : controller.status.value == Status.error
            ? Center(
          child: Text(kCouldNotLoadData.tr,
              style: kTextStyle16),
        )
            : controller.cartModel!.cart
            .isEmpty
            ?
        Center(child: Text("YourCartIsEmpty".tr,style: kTextStyle16,))
            :    Column(crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: controller.isGridView?  GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount:controller.cartModel?.cart.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,
                  childAspectRatio: 0.5, crossAxisSpacing: 8.w, mainAxisSpacing: 8.w),
                  itemBuilder: (context, index) {

                    var item = controller.cartModel?.cart[index];
                    return MyCartItem(item: item!,);


                  }):ListView.builder(
                  padding: EdgeInsets.zero,   physics: const PageScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:controller.cartModel?.cart.length,
                  itemBuilder: (context, index) {

                    var item = controller.cartModel?.cart[index];
                    return MyCartItem(item: item!,isGridView: false,);


                  }),
                ),
                Padding(
                  padding: kScreenPadding,
                  child: Row(
                    children: [
    
                      Expanded(child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("${"Total".tr} ${getPrice(controller.cartModel!.totalPrice!)}",style: kTextStyle18,))),
    
    kHorizontalSpace12,
                      Expanded(
                        child: ButtonWidget(text: "Checkout", onPressed: (){

Get.toNamed(Routes.checkoutScreen,arguments: controller.cartModel!.totalPrice!);
                        }),
                      ),
                    ],
                  ),
                )
              ],
            ),

      ),
    )

      );
  }

  @override
  void initState() {
    if(UserSession.isLoggedIn!){
      var controller =  Get.put(CartController());
      controller.getCart();
    }
    super.initState();
  }
}




class MyCartItem extends StatefulWidget {
  const MyCartItem({
    Key? key,
    required this.item,
    this.isGridView=true
  }) : super(key: key);

  final CartItem item;
  final bool isGridView;

  @override
  State<MyCartItem> createState() => _MyCartItemState();
}

class _MyCartItemState extends State<MyCartItem> {
  @override
  Widget build(BuildContext context) {
    var controller=Get.find<CartController>();
    return Card(
      margin:  widget.isGridView?
      EdgeInsets.all(5.w):
      EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.w),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child:
      widget.isGridView?

      Column(
          crossAxisAlignment:
          CrossAxisAlignment
              .stretch,
          children: [
            Expanded(
              child:
              ImageWidget(
                widget.item.images
                    .first,
                fit: BoxFit
                    .cover,
              ),
            ),
            Expanded(
                child:
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Text("${widget.item.productName}",
                        maxLines: 2,
                        style: kTextStyle16.copyWith(color: kAccentColor),),
                      kVerticalSpace4,

                      Text(
                        "${widget.item.supplierName}",
                        maxLines:
                        1,
                        style:
                        TextStyle(color: kGreyColor,    height: 1.3, fontSize: 12.sp),
                      ),
                      kVerticalSpace4,

                      Text(
                        "${widget.item.details}",
                        maxLines:
                        1,
                        style:
                        TextStyle(color: kGreyColor,    height: 1.3, fontSize: 12.sp),
                      ),
                      kVerticalSpace4,



                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(getPrice(widget.item.price!),
                          textDirection: TextDirection.ltr,
                          style: TextStyle(
                              color: kPrimaryColor,
                              height: 1.3,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    kVerticalSpace8,

                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                InkWell(
                onTap: (){
                  controller.decrement(widget.item);
            },
              child: Container(width: 30.w,height: 30.h,
                child: Icon(MaterialCommunityIcons.minus,color: kAccentColor,),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kAccentColor,width: 2)
                ),
              ),
            ),
            kHorizontalSpace20,
            Text(widget.item.quantity.toString(),style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,)),
            kHorizontalSpace20,
            InkWell(
              onTap: (){
                controller.increment(widget.item);

              },
              child: Container(width: 30.w,height: 30.h,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kAccentColor,width: 2)
                ),child: Icon(Icons.add,color: kAccentColor,),

              ),
            ),
          ],
      ),

                    ],
                  ),
                ))
          ]):
      SizedBox(
        height: 150.h,
        child: Row(
            crossAxisAlignment:
            CrossAxisAlignment
                .stretch,
            children: [
              Expanded(flex: 2,
                child:
                ImageWidget(
                  widget.item.images
                      .first,
                  fit: BoxFit
                      .cover,
                ),
              ),
              Expanded(flex: 3,
                  child:
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Text("${widget.item.productName}",
                          maxLines: 2,
                          style: kTextStyle16.copyWith(color: kAccentColor),),
                        kVerticalSpace4,

                        Text(
                          "${widget.item.supplierName}",
                          maxLines:
                          1,
                          style:
                          TextStyle(color: kGreyColor,    height: 1.3, fontSize: 12.sp),
                        ),
                        kVerticalSpace4,

                        Text(
                          "${widget.item.details}",
                          maxLines:
                          1,
                          style:
                          TextStyle(color: kGreyColor,    height: 1.3, fontSize: 12.sp),
                        ),
                        kVerticalSpace4,


                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(getPrice(widget.item.price!), textDirection: TextDirection.ltr,
                            style: TextStyle(
                                color: kPrimaryColor,
                                height: 1.3,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        kVerticalSpace8,

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: (){
                                controller.decrement(widget.item);
                              },
                              child: Container(width: 30.w,height: 30.h,
                                child: Icon(MaterialCommunityIcons.minus,color: kAccentColor,),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: kAccentColor,width: 2)
                                ),
                              ),
                            ),
                            kHorizontalSpace20,
                            Text(widget.item.quantity.toString(),style: TextStyle(fontSize: 18.sp,fontWeight: FontWeight.w600,)),
                            kHorizontalSpace20,
                            InkWell(
                              onTap: (){
                                controller.increment(widget.item);

                              },
                              child: Container(width: 30.w,height: 30.h,child: Icon(Icons.add,color: kAccentColor,),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: kAccentColor,width: 2)
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))
            ]),
      ),

    );
  }
}
