import 'package:careqar/locale/app_localizations.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/screens/add_features_screen.dart';
import 'package:careqar/ui/screens/add_property_screen.dart';
import 'package:careqar/ui/screens/agent_screen.dart';
import 'package:careqar/ui/screens/choose_foreigner_city_screen.dart';
import 'package:careqar/ui/screens/choose_option_screen.dart';
import 'package:careqar/ui/screens/choose_option_screen_new.dart';
import 'package:careqar/ui/screens/choose_signin_screen.dart';
import 'package:careqar/ui/screens/choose_subtype_screen.dart';
import 'package:careqar/ui/screens/city_screen.dart';
import 'package:careqar/ui/screens/companies_screen.dart';
import 'package:careqar/ui/screens/company_screen.dart';
import 'package:careqar/ui/screens/contact_us_screen.dart';
import 'package:careqar/ui/screens/current_location_screen.dart';
import 'package:careqar/ui/screens/edit_profile_screen.dart';
import 'package:careqar/ui/screens/favorites_screen.dart';
import 'package:careqar/ui/screens/filters_screen.dart';
import 'package:careqar/ui/screens/foreigner_screen.dart';
import 'package:careqar/ui/screens/forgot_password_screen.dart';
import 'package:careqar/ui/screens/initial_screen.dart';
import 'package:careqar/ui/screens/intro_screen.dart';
import 'package:careqar/ui/screens/login_screen.dart';
import 'package:careqar/ui/screens/my_properties_screen.dart';
import 'package:careqar/ui/screens/navigation_screen.dart';
import 'package:careqar/ui/screens/new_property_ad_screen.dart';
import 'package:careqar/ui/screens/news_detail_screen.dart';
import 'package:careqar/ui/screens/otp_screen.dart';
import 'package:careqar/ui/screens/profile_screen.dart';
import 'package:careqar/ui/screens/properties_screen.dart';
import 'package:careqar/ui/screens/request_property_screen.dart';
import 'package:careqar/ui/screens/requests_screen.dart';
import 'package:careqar/ui/screens/requirement_detail_screen.dart';
import 'package:careqar/ui/screens/requirements_screen.dart';
import 'package:careqar/ui/screens/reset_password_screen.dart';
import 'package:careqar/ui/screens/search_location_screen.dart';
import 'package:careqar/ui/screens/services_screen.dart';
import 'package:careqar/ui/screens/signup_screen.dart';
import 'package:careqar/ui/screens/splash_screen.dart';
import 'package:careqar/ui/screens/vehicle/SelectOriginScreen.dart';
import 'package:careqar/ui/screens/vehicle/SelectProvinceScreen.dart';
import 'package:careqar/ui/screens/vehicle/SelectRegistrationYearScreen.dart';
import 'package:careqar/ui/screens/vehicle/add_car_screen.dart';
import 'package:careqar/ui/screens/vehicle/add_to_cart_screen.dart';
import 'package:careqar/ui/screens/vehicle/add_vehicle_features_screen.dart';
import 'package:careqar/ui/screens/vehicle/all_ads_screen.dart';
import 'package:careqar/ui/screens/vehicle/bike_filter_screen.dart';
import 'package:careqar/ui/screens/vehicle/bikes_screen.dart';
import 'package:careqar/ui/screens/vehicle/brands_screen.dart';
import 'package:careqar/ui/screens/vehicle/car_filter_screen.dart';
import 'package:careqar/ui/screens/vehicle/cars_screen.dart';
import 'package:careqar/ui/screens/vehicle/cart_screen.dart';
import 'package:careqar/ui/screens/vehicle/categories_screen.dart';
import 'package:careqar/ui/screens/vehicle/checkout_screen.dart';
import 'package:careqar/ui/screens/vehicle/choose_ad_type_screen.dart';
import 'package:careqar/ui/screens/vehicle/choose_brand_screen.dart';
import 'package:careqar/ui/screens/vehicle/choose_model_screen.dart';
import 'package:careqar/ui/screens/vehicle/choose_model_variant_screen.dart';
import 'package:careqar/ui/screens/vehicle/choose_model_year_screen.dart';
import 'package:careqar/ui/screens/vehicle/choose_service_screen.dart';
import 'package:careqar/ui/screens/vehicle/choose_subservice_screen.dart';
import 'package:careqar/ui/screens/vehicle/coming_soon_screen.dart';
import 'package:careqar/ui/screens/vehicle/enter_engine_screen.dart';
import 'package:careqar/ui/screens/vehicle/enter_mileage_screen.dart';
import 'package:careqar/ui/screens/vehicle/enter_number_screen.dart';
import 'package:careqar/ui/screens/vehicle/enter_seats_screen.dart';
import 'package:careqar/ui/screens/vehicle/estore/estore_screen.dart';
import 'package:careqar/ui/screens/vehicle/my_orders_screen.dart';
import 'package:careqar/ui/screens/vehicle/new_ad_screen.dart';
import 'package:careqar/ui/screens/vehicle/number_plate_filter_screen.dart';
import 'package:careqar/ui/screens/vehicle/number_plate_types_screen.dart';
import 'package:careqar/ui/screens/vehicle/number_plates_screen.dart';
import 'package:careqar/ui/screens/vehicle/order_detail_screen.dart';
import 'package:careqar/ui/screens/vehicle/products_screen.dart';
import 'package:careqar/ui/screens/vehicle/review_ad_screen.dart';
import 'package:careqar/ui/screens/vehicle/select_ad_location_screen.dart';
import 'package:careqar/ui/screens/vehicle/select_city_screen.dart';
import 'package:careqar/ui/screens/vehicle/select_color_screen.dart';
import 'package:careqar/ui/screens/vehicle/select_condition_screen.dart';
import 'package:careqar/ui/screens/vehicle/select_fuel_type_screen.dart';
import 'package:careqar/ui/screens/vehicle/select_location_screen.dart';
import 'package:careqar/ui/screens/vehicle/select_payment_method_screen.dart';
import 'package:careqar/ui/screens/vehicle/select_plate_digits_screen.dart';
import 'package:careqar/ui/screens/vehicle/select_plate_type_screen.dart';
import 'package:careqar/ui/screens/vehicle/select_privilege_screen.dart';
import 'package:careqar/ui/screens/vehicle/select_transmission_screen.dart';
import 'package:careqar/ui/screens/vehicle/service_providers_screen.dart';
import 'package:careqar/ui/screens/vehicle/showrooms_screen.dart';
import 'package:careqar/ui/screens/vehicle/subcategories_screen.dart';
import 'package:careqar/ui/screens/vehicle/view_bike_screen.dart';
import 'package:careqar/ui/screens/vehicle/view_car_screen.dart';
import 'package:careqar/ui/screens/vehicle/view_my_bike_screen.dart';
import 'package:careqar/ui/screens/vehicle/view_my_car_screen.dart';
import 'package:careqar/ui/screens/vehicle/view_my_number_plate_screen.dart';
import 'package:careqar/ui/screens/vehicle/view_number_plate_screen.dart';
import 'package:careqar/ui/screens/view_image_screen.dart';
import 'package:careqar/ui/screens/view_my_property_screen.dart';
import 'package:careqar/ui/screens/view_my_request_screen.dart';
import 'package:careqar/ui/screens/view_property_screen.dart';
import 'package:careqar/ui/screens/view_request_screen.dart';
import 'package:careqar/ui/widgets/init_easy_loading.dart';
import 'package:careqar/ui/widgets/staggered_gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bindings.dart';
import 'constants/colors.dart';
import 'constants/style.dart';
import 'controllers/location_controller.dart';
import 'controllers/view_car_controller.dart';
import 'global_variables.dart';
import 'my_route_observer.dart';
import 'ui/screens/seller_profile_page.dart';
import 'ui/screens/vehicle/choose_type_screen.dart';
import 'ui/screens/vehicle/import_year_screen.dart';
import 'ui/screens/vehicle/provider_detail_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, widget) => GetMaterialApp(
        translationsKeys: Get.translations,
        locale: Get.locale,
        fallbackLocale: supportedLocales.first.locale,
        navigatorObservers: [MyRouteObserver()],
        navigatorKey: gNavigatorKey,
        initialBinding: AppBindings(), // Putting Controllers using Getx
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          dividerTheme: const DividerThemeData(color: Colors.grey),
          floatingActionButtonTheme:
          const FloatingActionButtonThemeData(backgroundColor: kAccentColor),
          buttonTheme: const ButtonThemeData(buttonColor: kAccentColor),
          cardTheme: CardThemeData(
            shadowColor: Colors.white,
            elevation: kCardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: kCardBorderRadius,
            ),
          ),
          scaffoldBackgroundColor: kBgColor,
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
          }),
          // Apply Poppins font to the entire app
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
          primaryTextTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).primaryTextTheme,
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: kPrimarySwatch)
              .copyWith(secondary: kAccentColor),
        ),
        builder: initEasyLoading(), // Initialize easyLoading
        initialRoute: Routes.chooseOptionScreenNew,
        getPages: _getPages(), // Routes Initialization
      ),
    );
  }


  _getPages() {
    return  [
      GetPage(
        name: Routes.sellerProfile,
        page: () => SellerProfilePage(),
        binding: SellerProfileBinding(),
      ),
      GetPage(
        name: Routes.importYearScreen,
        page: () => ImportYearScreen(),
      ),
      GetPage(
        name: Routes.servicesScreen,
        page: () => const ServicesScreen(),
      ),
      GetPage(name: Routes.checkoutScreen, page: () => CheckoutScreen(),binding: CheckoutBindings()),
      GetPage(name: Routes.myOrdersScreen, page: () => MyOrdersScreen(),binding: OrderBindings()),
      GetPage(name: Routes.orderDetailScreen, page: () => OrderDetailScreen()),
      GetPage(name: Routes.cartScreen, page: () => const CartScreen()),
      GetPage(name: Routes.chooseSubServiceScreen, page: () => ChooseSubSubServiceScreen()),
      GetPage(name: Routes.categoriesScreen, page: () => CategoriesScreen()),
      GetPage(name: Routes.addToCartScreen, page: () => const AddToCartScreen(),binding: AddToCartBindings()),
      GetPage(name: Routes.subCategoriesScreen, page: () => SubCategoriesScreen()),
      GetPage(name: Routes.productsScreen, page: () => ProductsScreen()),
      GetPage(name: Routes.chooseServiceScreen, page: () => ChooseServiceScreen()),
      GetPage(name: Routes.serviceProvidersScreen, page: () => ServiceProvidersScreen()),
      GetPage(name: Routes.requirementsScreen, page: () => RequirementsScreen()),
      GetPage(name: Routes.newPropertyAdScreen, page: () => NewPropertyAdScreen()),
      GetPage(name: Routes.newAdScreen, page: () => const NewAdScreen()),
      GetPage(name: Routes.selectPlateDigitsScreen, page: () => const SelectPlateDigitsScreen()),
      GetPage(name: Routes.selectPlateTypeScreen, page: () => const SelectPlateTypeScreen()),
      GetPage(name: Routes.selectPrivilegeScreen, page: () => const SelectPrivilegeScreen()),
      GetPage(name: Routes.enterNumberScreen, page: () => EnterNumberScreen()),
      GetPage(name: Routes.companiesScreen, page: () => CompaniesScreen(),binding: CompanyBindings()),
      GetPage(name: Routes.viewMyNumberPlateScreen, page: () => ViewMyNumberPlateScreen(),binding: ViewMyNumberPlateBindings()),
      GetPage(name: Routes.allAdsScreen, page: () => const AllAdsScreen()),
      GetPage(name: Routes.showroomsScreen, page: () => const ShowroomsScreen()),
      GetPage(name: Routes.chooseForeignerCityScreen, page: () => const ChooseForeignerCityScreen()),
      GetPage(name: Routes.numberPlateFilterScreen, page: () => const NumberPlateFilterScreen()),
      GetPage(name: Routes.bikeFilterScreen, page: () => const BikeFilterScreen()),
      GetPage(name: Routes.carFilterScreen, page: () => const CarFilterScreen()),
      GetPage(name: Routes.numberPlateTypesScreen, page: () => const NumberPlateTypesScreen(),binding: NumberPlateBindings()),
      GetPage(name: Routes.brandsScreen, page: () => BrandsScreen()),
      GetPage(name: Routes.chooseAdTypeScreen, page: () => const ChooseAdTypeScreen()),
      GetPage(name: Routes.chooseBrandScreen, page: () => ChooseBrandScreen()),
      GetPage(name: Routes.chooseModelScreen, page: () => const ChooseModelScreen()),
      GetPage(
        name: Routes.chooseModelVariants,
        page: () => const ChooseModelVariantScreen(),
      ),
      GetPage(name: Routes.selectConditionScreen, page: () => const SelectConditionScreen()),
      GetPage(name: Routes.selectRegistrationYearScreen, page: () => const SelectRegistrationYearScreen()),
      GetPage(name: Routes.selectProvinceScreen, page: () => SelectProvinceScreen()),
      GetPage(name: Routes.selectOriginScreen, page: () => const SelectOriginScreen()),
      GetPage(name: Routes.chooseModelYearScreen, page: () => ChooseModelYearScreen()),
      GetPage(name: Routes.chooseTypeScreen, page: () => ChooseTypeScreen()),
      GetPage(name: Routes.chooseTransmissionScreen, page: () => const SelectTransmissionScreen()),
      GetPage(name: Routes.selectFuelTypeScreen, page: () => const SelectFuelTypeScreen()),
      GetPage(name: Routes.selectColorScreen, page: () => const SelectColorScreen()),
      GetPage(name: Routes.selectCityScreen, page: () => SelectCityScreen()),
      GetPage(name: Routes.selectLocationScreen, page: () => SelectLocationScreen()),
      GetPage(
        name: Routes.selectAdLocationScreen,
        page: () => SelectAdLocationScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<LocationController>(() => LocationController());
        }),
      ),
      GetPage(name: Routes.enterEngineScreen, page: () => EnterEngineScreen()),
      GetPage(name: Routes.enterMileageScreen, page: () => EnterMileageScreen()),
      GetPage(name: Routes.enterSeatsScreen, page: () => EnterSeatsScreen()),
      GetPage(name: Routes.reviewAdScreen, page: () => ReviewAdScreen()),
      GetPage(name: Routes.selectPaymentMethodScreen, page: () => const SelectPaymentMethodScreen()),

      GetPage(name: Routes.initialScreen, page: () => const InitialScreen()),
      GetPage(name: Routes.favoritesScreen, page: () => const FavoritesScreen()),
      GetPage(name: Routes.addFeaturesScreen, page: () => const AddFeaturesScreen()),
      GetPage(name: Routes.companyScreen, page: () => CompanyScreen()),
      GetPage(name: Routes.addPropertyScreen, page: () => const AddPropertyScreen(),binding: AddPropertyBindings()),
      GetPage(name: Routes.foreignerScreen, page: () => const ForeignerScreen(),binding: CityBindings()),
      GetPage(name: Routes.cityScreen, page: () => CityScreen()),
      GetPage(name: Routes.myPropertiesScreen, page: () => MyPropertiesScreen(),binding: MyPropertyBindings()),
      GetPage(name: Routes.myRequestsScreen, page: () => RequestsScreen(),binding: MyRequestBindings()),

      GetPage(name: Routes.splashScreen, page: () => const SplashScreen()),
      GetPage(name: Routes.introScreen, page: () => const IntroScreen()),
      GetPage(name: Routes.currentLocationScreen, page: () => const CurrentLocationScreen()),
      GetPage(name: Routes.propertiesScreen, page: () => PropertiesScreen()),
      GetPage(name: Routes.chooseOptionScreen, page: () => const ChooseOptionScreen()),
      GetPage(name: Routes.chooseOptionScreenNew, page: () => const ChooseOptionScreenNew()),
      GetPage(name: Routes.chooseSignInScreen, page: () => const ChooseSignInScreen()),
      GetPage(name: Routes.chooseSubtypeScreen, page: () => const ChooseSubtypeScreen()),
      GetPage(name: Routes.comingSoonScreen, page: () => ComingSoonScreen()),
      GetPage(
        name: Routes.staggeredGalleryScreen,
        page: () => const StaggeredGalleryScreen(),
          binding: ViewImageBindings()
      ),

    GetPage(name: Routes.viewImageScreen, page: () => const ViewImageScreen(),binding: ViewImageBindings()),
      GetPage(name: Routes.numberPlatesScreen, page: () => NumberPlatesScreen(),binding: NumberPlateBindings()),
      GetPage(name: Routes.viewNumberPlateScreen, page: () => ViewNumberPlateScreen(),binding: ViewNumberPlateBindings()),
      GetPage(
        name: Routes.viewCarScreen,
        page: () => ViewCarScreen(),
        binding: BindingsBuilder(() {
          Get.lazyPut<ViewCarController>(() => ViewCarController());
          Get.lazyPut<LocationController>(() => LocationController());
        }),
      ),

      GetPage(name: Routes.viewMyBikeScreen, page: () => ViewMyBikeScreen(),binding: ViewMyBikeBindings()),
      GetPage(name: Routes.viewBikeScreen, page: () => ViewBikeScreen(),binding: ViewBikeBindings()),
      GetPage(name: Routes.addCarScreen, page: () => const AddCarScreen(),binding: AddCarBindings()),
      GetPage(name: Routes.addVehicleFeaturesScreen, page: () => AddVehicleFeaturesScreen()),
      GetPage(name: Routes.viewMyCarScreen, page: () => ViewMyCarScreen(),binding: ViewMyCarBindings()),
      GetPage(name: Routes.chooseBrandScreen, page: () => ChooseBrandScreen()),
      GetPage(name: Routes.carsScreen, page: () => CarsScreen()),
      GetPage(name: Routes.bikesScreen, page: () => BikesScreen()),
      GetPage(name: Routes.viewMyRequestScreen, page: () => ViewMyRequestScreen(),binding: ViewMyRequestBindings()),
      GetPage(name: Routes.viewRequestScreen, page: () => ViewRequestScreen(),binding: ViewRequestBindings()),
      GetPage(name: Routes.searchLocationScreen, page: () => SearchLocationScreen()),
      GetPage(name: Routes.loginScreen, page: () => const LoginScreen(),binding: LoginBindings()),
      GetPage(name: Routes.contactUsScreen, page: () => const ContactUsScreen()),
      GetPage(name: Routes.requestPropertyScreen, page: () => const RequestPropertyScreen(),binding: AddRequestBindings()),
      GetPage(name: Routes.viewPropertyScreen, page: () => ViewPropertyScreen(),binding: ViewPropertyBindings()),
      GetPage(name: Routes.viewMyPropertyScreen, page: () => ViewMyPropertyScreen(),binding: ViewMyPropertyBindings()),
      GetPage(name: Routes.navigationScreen, page: () => const NavigationScreen(),binding: HomeBindings()),
      GetPage(name: Routes.signUpScreen, page: () => const SignUpScreen(),binding: SignUpBindings()),
      GetPage(name: Routes.otpScreen, page: () => OtpScreen(),binding: OtpBindings()),
      GetPage(name: Routes.filtersScreen, page: () => const FiltersScreen()),
      GetPage(name: Routes.profileScreen, page: () => const ProfileScreen()),
      GetPage(name: Routes.editProfileScreen, page: () => EditProfileScreen()),
      GetPage(name: Routes.providerDetailScreen, page: () => ProviderDetailScreen()),
      GetPage(name: Routes.agentScreen, page: () => AgentScreen(),binding:AgentBindings()),
      GetPage(name: Routes.forgotPasswordScreen, page: () => ForgotPasswordScreen(),binding: PasswordBindings()),
      GetPage(name: Routes.resetPasswordScreen, page: () => ResetPasswordScreen(),binding: PasswordBindings()),
      GetPage(name: Routes.eStoreScreen, page: () => EStoreScreen(),binding: CategoryBindings()),
      GetPage(name: Routes.newsDetailScreen, page: () => const NewsDetailScreen()),
      GetPage(name: Routes.requirementDetailScreen, page: () => const RequirementDetailScreen()),
    ];


  }

}


class CustomPageRoute extends MaterialPageRoute {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  CustomPageRoute({builder, settings})
      : super(builder: builder, settings: settings);
}
