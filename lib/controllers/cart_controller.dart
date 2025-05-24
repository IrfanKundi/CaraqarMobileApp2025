
import 'package:careqar/models/cart_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';

class CartController extends GetxController {
  var status = Status.loading.obs;
  var actionStatus = Status.initial.obs;
  CartModel? cartModel;


  bool isGridView=true;

  Future<void> getCart() async {
    try {
      var response =
      await gApiProvider.get(path: "cart/get", authorization: true);



     await response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
      }, (r) async {
        status(Status.success);
        cartModel = CartModel.fromJson(r.data);

      });   update();
    } catch (e) {

      showSnackBar(message: "Error");
      status(Status.error);   update();
    }
  }

  Future<bool> increment(CartItem cartItem) async {
    try {
      actionStatus(Status.loading);
      EasyLoading.show();

      var response = await gApiProvider.get(
          path: "cart/increment?cartId=${cartItem.cartId}",
          authorization: true);

      EasyLoading.dismiss();
     return response.fold((l) {
        showSnackBar(message: l.message!);
        actionStatus(Status.error);
        return false;
      }, (r) async {
        actionStatus(Status.success);
        //showSnackBar(message: r.message);
        cartItem.quantity = cartItem.quantity!+1;
        cartModel?.totalPrice= (cartModel!.totalPrice! + cartItem.price!);
        update();
        return true;
      });
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "Error");
      actionStatus(Status.error);
      return false;
    }
  }
  Future<bool> decrement(CartItem cartItem) async {
    try {
      actionStatus(Status.loading);
      EasyLoading.show();

      var response = await gApiProvider.get(
          path: "cart/decrement?cartId=${cartItem.cartId}",
          authorization: true);

      EasyLoading.dismiss();
      return response.fold((l) {
        showSnackBar(message: l.message!);
        actionStatus(Status.error);
        return false;
      }, (r) async {
        actionStatus(Status.success);
        //showSnackBar(message: r.message);
        cartItem.quantity = cartItem.quantity!-1;
        cartModel?.totalPrice = cartModel!.totalPrice! - cartItem.price!;
        if(cartItem.quantity==0){
         cartModel?.cart.remove(cartItem);
        }
        update();
        return true;
      });
    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "Error");
      actionStatus(Status.error);
      return false;
    }
  }
}
