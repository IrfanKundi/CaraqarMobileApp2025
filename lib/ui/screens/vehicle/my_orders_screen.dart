import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/order_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/models/order_model.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/text_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../global_variables.dart';

class MyOrdersScreen extends StatefulWidget {

  MyOrdersScreen({super.key}){

  }

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> with TickerProviderStateMixin{

  TabController? tabController;
  OrderController? orderController;

  @override
  void initState() {
    super.initState();
    orderController=Get.put(OrderController());
    tabController=TabController(initialIndex: 0,length: 2,vsync: this);
    orderController?.getOrders(true);
    tabController?.addListener(() {
      if(tabController?.index==0){
        orderController?.getOrders(true);
      }else{
        orderController?.getOrders(false);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context,title: "MyOrders"),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: kWhiteColor,
              child: TabBar(
                labelStyle: kTextStyle16,
                  controller: tabController,
                  tabs: [
                Tab(text: "Upcoming".tr,),
                    Tab(text: "Past".tr,),
              ],dividerColor: Colors.transparent),
            ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                // ---------------- Upcoming Orders ----------------
                GetBuilder<OrderController>(
                  builder: (controller) =>
                  controller.status.value == Status.loading
                      ? Center(child: CircularLoader())
                      : controller.status.value == Status.error
                      ? Center(
                    child: Text(
                      "Couldn't load orders",
                      style: kTextStyle14,
                    ),
                  )
                      : controller.upcomingOrders.isEmpty
                      ? Center(
                    child: Text(
                      "Look like there are no orders",
                      style: kTextStyle14,
                    ),
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    padding: kScreenPadding,
                    physics: PageScrollPhysics(),
                    itemCount: controller.upcomingOrders.length,
                    itemBuilder: (context, index) {
                      Order order = controller.upcomingOrders[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 16.h),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 16.w),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "#${order.invoiceNo ?? "-"}",
                                        style: Get
                                            .textTheme.titleMedium,
                                      ),
                                    ),
                                  ),
                                  kHorizontalSpace12,
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        order.createdAt ?? "N/A",
                                        style: Get
                                            .textTheme.labelSmall,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              kVerticalSpace12,
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "TotalAmount".tr,
                                    style: Get.textTheme.labelSmall,
                                  ),
                                  Text(
                                    getPrice(order.totalPrice ?? 0),
                                    style: Get.textTheme.titleSmall,
                                  ),
                                ],
                              ),
                              kVerticalSpace8,
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "OrderDate".tr,
                                    style: Get.textTheme.labelSmall,
                                  ),
                                  Text(
                                    order.createdAt ?? "N/A",
                                    style: Get.textTheme.titleSmall,
                                  ),
                                ],
                              ),
                              kVerticalSpace8,
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "OrderStatus".tr,
                                    style: Get.textTheme.labelSmall,
                                  ),
                                  Text(
                                    order.orderStatus ?? "Unknown",
                                    style: Get.textTheme.titleSmall,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButtonWidget(
                                    text: "ViewDetails",
                                    color: kSuccessColor,
                                    onPressed: () {
                                      controller.getOrderDetails(order);
                                      Get.toNamed(
                                        Routes.orderDetailScreen,
                                        arguments: order,
                                      );
                                    },
                                  ),
                                  if ((order.status ?? 0) < 2)
                                    TextButtonWidget(
                                      text: "CancelOrder",
                                      color: kRedColor,
                                      onPressed: () async {
                                        showConfirmationDialog(
                                          title: "CancelOrder",
                                          message:
                                          "DoYouReallyWantToCancelThisOrder?",
                                          onConfirm: () {
                                            Get.back();
                                            controller
                                                .cancelOrder(order);
                                          },
                                        );
                                      },
                                    ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ---------------- Past Orders ----------------
                GetBuilder<OrderController>(
                  builder: (controller) =>
                  controller.status.value == Status.loading
                      ? Center(child: CircularLoader())
                      : controller.status.value == Status.error
                      ? Center(
                    child: Text(
                      "Couldn't load orders",
                      style: kTextStyle14,
                    ),
                  )
                      : controller.pastOrders.isEmpty
                      ? Center(
                    child: Text(
                      "Look like there are no orders",
                      style: kTextStyle14,
                    ),
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    padding: kScreenPadding,
                    physics: PageScrollPhysics(),
                    itemCount: controller.pastOrders.length,
                    itemBuilder: (context, index) {
                      Order order = controller.pastOrders[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 16.h),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 16.w),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "#${order.invoiceNo ?? "-"}",
                                        style: Get
                                            .textTheme.titleMedium,
                                      ),
                                    ),
                                  ),
                                  kHorizontalSpace12,
                                  Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        order.createdAt ?? "N/A",
                                        style: Get
                                            .textTheme.labelSmall,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              kVerticalSpace12,
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "TotalAmount".tr,
                                    style: Get.textTheme.labelSmall,
                                  ),
                                  Text(
                                    getPrice(order.totalPrice ?? 0),
                                    style: Get.textTheme.titleSmall,
                                  ),
                                ],
                              ),
                              kVerticalSpace8,
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "OrderDate".tr,
                                    style: Get.textTheme.labelSmall,
                                  ),
                                  Text(
                                    order.createdAt ?? "N/A",
                                    style: Get.textTheme.titleSmall,
                                  ),
                                ],
                              ),
                              kVerticalSpace8,
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "OrderStatus".tr,
                                    style: Get.textTheme.labelSmall,
                                  ),
                                  Text(
                                    order.orderStatus ?? "Unknown",
                                    style: Get.textTheme.titleSmall,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButtonWidget(
                                    text: "ViewDetails",
                                    color: kSuccessColor,
                                    onPressed: () {
                                      controller.getOrderDetails(order);
                                      Get.toNamed(
                                        Routes.orderDetailScreen,
                                        arguments: order,
                                      );
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ],
        ),
      ),
    );
  }
}
