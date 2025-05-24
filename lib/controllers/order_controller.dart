
import 'package:careqar/models/order_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';
import '../ui/widgets/alerts.dart';

class OrderController extends GetxController {
  var status = Status.loading.obs;
  var detailsStatus = Status.loading.obs;
  List<Order> upcomingOrders=[];
  List<Order> pastOrders=[];

  Future<void> getOrders(bool newOrders) async {
    try {
      status(Status.loading);
      update();
      var response =
      await gApiProvider.get(path: "order/get?newOrders=$newOrders", authorization: true);



      await response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
      }, (r) async {
        status(Status.success);
        if(newOrders){
          upcomingOrders.clear();
          upcomingOrders = OrderModel.fromJson(parsedJson: r.data).orders;
        }else{
          pastOrders.clear();
          pastOrders = OrderModel.fromJson(parsedJson: r.data).orders;
        }
      });
      update();
    } catch (e) {

      showSnackBar(message: "Error");
      status(Status.error);
      update();
    }
  }
  Future<void> cancelOrder(Order order) async {
    try {

      EasyLoading.show();

      var response = await gApiProvider.get(
          path: "order/CancelOrder?invoiceNo=${order.invoiceNo}",
          authorization: true);

      EasyLoading.dismiss();
      await response.fold((l) {
        showSnackBar(message: l.message!);

      }, (r) async {

        showSnackBar(message: r.message);
        upcomingOrders.remove(order);
      });
      update();
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "Error");
      update();
    }
  }


  Future<void> getOrderDetails(Order order) async {
    try {
      detailsStatus(Status.loading);
      update();
      var response =
      await gApiProvider.get(path: "order/OrderDetails?invoiceNo=00005", authorization: true);



      await response.fold((l) {
        showSnackBar(message: l.message!);
        detailsStatus(Status.error);
      }, (r) async {
        detailsStatus(Status.success);
        order.items.clear();
        for (var item in r.data) {
          order.items.add(OrderItem(item));
        }
      });
      update();
    } catch (e) {

      showSnackBar(message: "Error");
      detailsStatus(Status.error);
      update();
    }
  }
}


