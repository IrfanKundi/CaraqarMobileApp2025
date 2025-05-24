import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:careqar/constants/colors.dart';
import 'package:careqar/models/user_model.dart';
import 'package:careqar/ui/widgets/alerts.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../enums.dart';
import '../global_variables.dart';
import '../routes.dart';
import 'auth_controller.dart';

class SocialSignInController extends GetxController {
  var status = Status.initial.obs;

  Future<void> signInWithGoogle() async {
    try {

        Get.focusScope?.unfocus();
        status(Status.loading);
        // Trigger the authentication flow

          final googleSignIn = GoogleSignIn();
          if(await googleSignIn.isSignedIn()){
          await   googleSignIn.disconnect();
          }

          final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

          if(googleUser!=null){


            EasyLoading.show(status: "AuthenticatingPleaseWait".tr);
            var user =UserModel();
            // var name=googleUser.displayName.split(" ");
            // user.firstName=name.first;
            // name.removeAt(0);
            // user.lastName=name.join(" ");
            user.firstName=googleUser.displayName!;
            user.email=googleUser.email;
            user.profileImage=googleUser.photoUrl!;
            user.loginWith=EnumToString.convertToString(LoginWith.Google);
            var response = await gApiProvider.post(
                path: "user/socialLogin",
                body: {
                  "loginWith":user.loginWith,
                  "accountId": googleUser.id,
                  "firstName":user.firstName,
                  //"lastName":user.lastName,
                  "email":user.email,
                  "image":user.profileImage,
                },isFormData: true,
            );
            EasyLoading.dismiss();

            response.fold((l) {
                showSnackBar(message: l.message!);
                status(Status.error);

            }, (r) async {
              status(Status.success);
              await Get.find<AuthController>()
                  .createSession(r.data["token"],socialLogin: true,loginWith:user.loginWith);

              Get.offNamedUntil(Routes.navigationScreen, (route) => false);
              showSnackBar(
                  message: r.message, color: kSuccessColor);
            });

          }


    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "LoginFailed");
      status(Status.error);
    }
  }


  Future<void> signInWithFacebook() async {
    try {

      Get.focusScope?.unfocus();
      status(Status.loading);
      // Trigger the authentication flow

      final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile

      if (result.status == LoginStatus.success) {
        // you are logged
        final userData = await FacebookAuth.instance.getUserData();


        EasyLoading.show(status: "AuthenticatingPleaseWait".tr);
        var user =UserModel();
        // var name=userData["name"].split(" ");
        // user.firstName=name.first;
        // name.removeAt(0);
        // user.lastName=name.join(" ");
        user.firstName=userData["name"];
        user.email=userData["email"];
        user.profileImage=userData["picture"]["data"]["url"];
        user.loginWith=EnumToString.convertToString(LoginWith.Facebook);
        var response = await gApiProvider.post(
          path: "user/socialLogin",
          body: {
            "loginWith": user.loginWith,
            "accountId": userData["id"],
            "firstName":user.firstName,
            //"lastName":user.lastName,
            "email":user.email,
            "image":user.profileImage,
          },isFormData: true,
        );
        EasyLoading.dismiss();

        response.fold((l) {
          showSnackBar(message: l.message!);
          status(Status.error);

        }, (r) async {
          status(Status.success);
          await Get.find<AuthController>()
              .createSession(r.data["token"],socialLogin: true,loginWith:user.loginWith);

          Get.offNamedUntil(Routes.navigationScreen, (route) => false);
          showSnackBar(
              message: r.message, color: kSuccessColor);
        });

      } else {
        showSnackBar(message: result.message!);
        status(Status.error);
      }


    } catch (e) {
      EasyLoading.dismiss();
      showSnackBar(message: "LoginFailed");
      status(Status.error);
    }
  }



  Future<void> signInWithApple() async {
    try {

      Get.focusScope?.unfocus();
      status(Status.loading);
      // Trigger the authentication flow

      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.


      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );


      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      EasyLoading.show(status: "AuthenticatingPleaseWait".tr);
      var firebaseAuth= FirebaseAuth.instance;
      final _res = await firebaseAuth
          .signInWithCredential(oauthCredential);
      var firebaseUser=firebaseAuth.currentUser;

      if (firebaseUser != null) {
        // you are logged

        if(_res.additionalUserInfo!.isNewUser){
          await firebaseUser.updateDisplayName("${appleCredential.givenName} ${appleCredential.familyName}");
        }


        var user = UserModel();
        //var name=firebaseUser.displayName.split(" ");
        // user.firstName=name.first;
        // name.removeAt(0);
        // user.lastName=name.join(" ");
        user.firstName=firebaseUser.displayName!;
        user.email=firebaseUser.email!;
        user.loginWith=EnumToString.convertToString(LoginWith.Apple);
        var response = await gApiProvider.post(
          path: "user/socialLogin",
          body: {
            "loginWith": user.loginWith,
            "accountId": appleCredential.userIdentifier,
            "firstName":user.firstName,
            //"lastName":user.lastName,
            "email":user.email,
          },isFormData: true,
        );
        EasyLoading.dismiss();

        response.fold((l) {
          showSnackBar(message: l.message!);
          status(Status.error);

        }, (r) async {
          status(Status.success);
          await Get.find<AuthController>()
              .createSession(r.data["token"],socialLogin: true,loginWith:user.loginWith);


          Get.offNamedUntil(Routes.navigationScreen, (route) => false);
          showSnackBar(
              message: r.message, color: kSuccessColor);
        });

      } else {
        showSnackBar(message: "LoginFailed");
        status(Status.error);
      }


    } catch (e) {
      showAlertDialog(message: e.toString(),title: "");
      EasyLoading.dismiss();
      showSnackBar(message: "LoginFailed");
      status(Status.error);
    }
  }
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

}
