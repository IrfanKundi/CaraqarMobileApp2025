
import 'package:careqar/controllers/add_request_controller.dart';
import 'package:careqar/controllers/agent_controller.dart';
import 'package:careqar/controllers/auth_controller.dart';
import 'package:careqar/controllers/city_controller.dart';
import 'package:careqar/controllers/company_controller.dart';
import 'package:careqar/controllers/home_controller.dart';
import 'package:careqar/controllers/login_controller.dart';
import 'package:careqar/controllers/my_property_controller.dart';
import 'package:careqar/controllers/order_controller.dart';
import 'package:careqar/controllers/otp_controller.dart';
import 'package:careqar/controllers/password_controller.dart';
import 'package:careqar/controllers/profile_controller.dart';
import 'package:careqar/controllers/signup_controller.dart';
import 'package:careqar/controllers/social_signin_controller.dart';
import 'package:careqar/controllers/view_car_controller.dart';
import 'package:careqar/controllers/view_image_controller.dart';
import 'package:careqar/controllers/view_my_car_controller.dart';
import 'package:careqar/controllers/view_request_controller.dart';
import 'package:careqar/ui/screens/seller_profile_page.dart';
import 'package:get/get.dart';

import 'controllers/add_car_controller.dart';
import 'controllers/add_property_controller.dart';
import 'controllers/add_to_cart_controller.dart';
import 'controllers/brand_controller.dart';
import 'controllers/category_controller.dart';
import 'controllers/checkout_controller.dart';
import 'controllers/content_controller.dart';
import 'controllers/my_numberplate_controller.dart';
import 'controllers/my_request_controller.dart';
import 'controllers/number_plate_controller.dart';
import 'controllers/view_bike_controller.dart';
import 'controllers/view_my_bike_controller.dart';
import 'controllers/view_my_numberplate_controller.dart';
import 'controllers/view_my_property_controller.dart';
import 'controllers/view_my_request_controller.dart';
import 'controllers/view_number_plate_controller.dart';
import 'controllers/view_property_controller.dart';
class AppBindings extends Bindings{

  @override
  void dependencies() {
    Get.put(ContentController(),permanent: true);
    Get.put(AuthController(),permanent: true);
    Get.put(ProfileController(),permanent: true);

  }
}

class SellerProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellerProfileController>(() => SellerProfileController());
  }
}

class LoginBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => SocialSignInController());
  }
}

class AddToCartBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => AddToCartController());
  }
}
class CheckoutBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => CheckoutController());
  }
}

class OrderBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => OrderController());
  }
}
class CityBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => CityController());
  }
}


class SignUpBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => SignUpController());
    Get.lazyPut(() => SocialSignInController());
  }
}
class AgentBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => AgentController());
  }
}
class PasswordBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => PasswordController());
    Get.lazyPut(() => OtpController());
  }
}
class OtpBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => OtpController());
  }
}

class AddRequestBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => AddRequestController());
  }
}
class MyRequestBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => MyRequestController());
  }
}
class MyNumberPlateBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => MyNumberPlateController());
  }
}
class ViewMyNumberPlateBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => ViewMyNumberPlateController());
  }
}

class CompanyBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => CompanyController());
  }
}
class MyPropertyBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => MyPropertyController());
  }
}
class ViewMyPropertyBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => ViewMyPropertyController());
  }
}
class AddPropertyBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => AddPropertyController());
  }
}
class AddCarBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => AddCarController());
  }
}

class HomeBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
class ViewMyCarBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => ViewMyCarController());
  }
}

class ViewImageBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => ViewImageController());
  }
}


class ViewCarBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => ViewCarController());
  }
}

class ViewMyBikeBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => ViewMyBikeController());
  }
}
class ViewBikeBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => ViewBikeController());
  }
}
class ViewNumberPlateBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => ViewNumberPlateController());
  }
}

class NumberPlateBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => NumberPlateController());
  }
}

class ViewRequestBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => ViewRequestController());
  }
}
class ViewMyRequestBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => ViewMyRequestController());
  }
}
class ViewPropertyBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => ViewPropertyController());
  }
}

class CategoryBindings extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => CategoryController());
    Get.lazyPut(() => BrandController());
  }
}