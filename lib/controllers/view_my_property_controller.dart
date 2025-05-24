import 'package:careqar/models/comment_model.dart';
import 'package:careqar/models/property_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:get/get.dart';

import '../enums.dart';
import '../global_variables.dart';

class ViewMyPropertyController extends GetxController {
  var status = Status.initial.obs;
  var commentsStatus = Status.initial.obs;
  var sliderIndex=0.obs;
  List<Comment> comments=[];

  Rx<Property?> property=Rx(null);
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
  @override
  void onReady() {

      property.value=Get.arguments;
      getComments(property.value?.propertyId);
      status(Status.success);

    // TODO: implement onReady
    super.onReady();
  }
}
