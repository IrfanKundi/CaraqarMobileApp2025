import 'package:careqar/controllers/profile_controller.dart';
import 'package:careqar/models/user_model.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../enums.dart';
import '../routes.dart';
import '../user_session.dart';

class AuthController extends GetxController {
  var status = Status.initial.obs;
  Rx<AuthState> authState = AuthState.unauthorized.obs;

  @override
  void onInit() {
    super.onInit();
    _initAuth();
  }

  Future<void> _initAuth() async {
    try {
      status(Status.loading);
      await UserSession.exist();
      authState(UserSession.isLoggedIn!
          ? AuthState.authorized
          : AuthState.unauthorized);
      status(Status.success);
      if (authState.value == AuthState.authorized) {
        Get.find<ProfileController>().getProfile();
      }
    } catch (e) {
      status(Status.error);
    }
  }

  Future<void> createSession(String accessToken, {socialLogin = false, loginWith}) async {
    try {
      status(Status.loading);
      await UserSession.create(accessToken, loginWith: loginWith);
      authState(UserSession.isLoggedIn!
          ? AuthState.authorized
          : AuthState.unauthorized);

      Get.find<ProfileController>().getProfile();

      status(Status.success);
    } catch (e) {
      status(Status.error);
    }
  }

  Future<void> logout() async {
    try {
      status(Status.loading);
      EasyLoading.show(status: "PleaseWait".tr);
      var loginWith = UserSession.loginWith;
      await UserSession.logout();
      Get.find<ProfileController>().user.value = UserModel();
      if (loginWith != null) {
        if (loginWith == EnumToString.convertToString(LoginWith.Google)) {
          await GoogleSignIn().disconnect();
        } else if (loginWith == EnumToString.convertToString(LoginWith.Facebook)) {
          await FacebookAuth.instance.logOut();
        }
      }
      EasyLoading.dismiss();
      authState(UserSession.isLoggedIn!
          ? AuthState.authorized
          : AuthState.unauthorized);
      status(Status.success);
      Get.offNamedUntil(Routes.navigationScreen, (route) => false);
    } catch (e) {
      status(Status.error);
    }
  }
}
