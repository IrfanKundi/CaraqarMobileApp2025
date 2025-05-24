import 'package:careqar/constants/colors.dart';
import 'package:careqar/controllers/profile_controller.dart';
import 'package:careqar/models/comment_model.dart';
import 'package:careqar/models/property_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:careqar/user_session.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';
import '../routes.dart';

class ViewPropertyController extends GetxController {
  var status = Status.initial.obs;
  var commentsStatus = Status.initial.obs;

  var sliderIndex=0.obs;

  Rx<Property?> property=Rx(null);

  List<Comment> comments=[];

  @override
  void onInit() {
    status(Status.loading);

    // TODO: implement onInit
    super.onInit();
  }


  Future<void> getProperty(var propertyId) async {
    try {
      status(Status.loading);

      var response =
      await gApiProvider.get(path: "property/get?propertyId=$propertyId", authorization: true);



     return response.fold((l) {
        showSnackBar(message: l.message!);
        status(Status.error);
      }, (r) async {
        status(Status.success);
        property.value = PropertyModel.fromMap(r.data["properties"]).properties.first;
        getComments(propertyId);
        updateClicks();
      });
    } catch (e) {

      showSnackBar(message: "Error");
      status(Status.error);
    }
  }
  Future<void> getComments(var propertyId) async {
    try {
      commentsStatus(Status.loading);

      var response =
      await gApiProvider.get(path: "property/getComments?propertyId=$propertyId", authorization: true);



      return response.fold((l) {
        showSnackBar(message: l.message!);
        commentsStatus(Status.error);
      }, (r) async {
        comments = CommentModel.fromMap(r.data).comments;
        update(["comments"]);
        commentsStatus(Status.success);
      });
    } catch (e) {

      showSnackBar(message: "Error");
      commentsStatus(Status.error);
    }
  }

  Future<bool> updateClicks({isEmail=false,isWhatsapp=false,isCall=false}) async {
    try {



      var userId;

      if(UserSession.isLoggedIn!){
      userId=Get.put(ProfileController()).user.value.userId;
      }else{
    userId=UserSession.guestUserId;
      }


      var response = await gApiProvider
          .post(
        path: "property/updateClicks?propertyId=${property.value?.propertyId}&userId=$userId&isEmail=$isEmail&isCall=$isCall&isWhatsapp=$isWhatsapp");


      return  response.fold((l) {
        return false;
      }, (r) async {
        return true;
      });

    } catch (e) {
      return false;
    }
  }

  var comment = "";

  Future<void> deleteComment(int commentId) async {
    try {

      EasyLoading.show(status: "PleaseWait".tr);
      var response = await gApiProvider
          .post(
          path: "property/deleteComment?commentId=$commentId",authorization: true);

      EasyLoading.dismiss();

      return response.fold((l) {

        showSnackBar(message: l.message!);


      }, (r) async {
        comments.removeWhere((element) => element.commentId==commentId);
        showSnackBar(
            message: r.message, color: kSuccessColor);
      });

    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "Failed");
    }
  }
  var formKey;

  Future<void> saveComment() async {
    if(UserSession.isLoggedIn!){
      try {

        if (formKey.currentState.validate()) {
          Get.focusScope?.unfocus();
          formKey.currentState.save();

          EasyLoading.show(status: "PleaseWait".tr);

          var response = await gApiProvider.post(
              path: "property/saveComment",
              body: {
                "comment": comment,
                "createdAt": DateTime.now().toString(),
                "propertyId":property.value?.propertyId},authorization: true);
          EasyLoading.dismiss();

          return response.fold((l) {

            showSnackBar(message: l.message!);


          }, (r) async {
            comment="";
            formKey.currentState.reset();
            getComments(property.value?.propertyId);
            // showSnackBar(
            //     message: r.message, color: kSuccessColor);

          });
        }
      } catch (e) {
        EasyLoading.dismiss();
        showSnackBar(message: "Failed");

      }
    }else{
      Get.toNamed(Routes.loginScreen);
    }

  }

  @override
  void onReady() {
    if(Get.arguments is String){
      getProperty(Get.arguments);
    }else{
      property.value=Get.arguments;
      getComments(property.value?.propertyId);
      updateClicks();
      status(Status.success);
    }

    // TODO: implement onReady
    super.onReady();
  }

}
