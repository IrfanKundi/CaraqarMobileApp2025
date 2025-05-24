
import 'package:careqar/global_variables.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _accessTokenKey = "access-token";
const String _fcmTokenKey = "fcm-token";
const String _loginWithKey = "login-with";
const String _firstLaunch = "first_launch";
const String _country = "country";
const String _guestUserId = "guestUserId";
const String _lat = "lat";
const String _lng = "lng";

class UserSession {
  static String? accessToken;
  static String? loginWith;
  static int? country;
  static String? countryName;
  static String? countryImageUrl;
  static String? guestUserId;
  static bool? isLoggedIn = false;
  static String? fcmToken;
  static SharedPreferences? _sharedPreferences;
  static bool firstLaunch = true;
  static double? lat;
  static double? lng;

  static Future<void> changeCountry(int countryId) async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    await _sharedPreferences?.setInt(_country, countryId);
    country=countryId;
  }

  static Future<void> emptyCountry() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    await _sharedPreferences?.remove(_country);
  }

  static Future<int?> getCountry() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();

    country= _sharedPreferences?.getInt(_country);
    return country;
  }

  static Future<void> changeFirstLaunch(bool val) async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    await _sharedPreferences?.setBool(_firstLaunch, val);

    var guestId=await getDeviceId();
    await _sharedPreferences?.setString(_guestUserId,guestId! );
    UserSession.firstLaunch = val;
    UserSession.guestUserId = guestId;
  }

  static Future<bool> isFirstLaunch() async {

    _sharedPreferences ??= await SharedPreferences.getInstance();
    firstLaunch = _sharedPreferences?.getBool(_firstLaunch) ?? true;
    return firstLaunch;
  }

  static Future<void> create(
      String accessToken,{String? fcmToken,String? loginWith}) async {
    _sharedPreferences ??= await SharedPreferences.getInstance();

    _sharedPreferences?.setString(_accessTokenKey, accessToken);
    if (fcmToken != null) {
      _sharedPreferences?.setString(_fcmTokenKey, fcmToken);
    }
    if (loginWith != null) {
      _sharedPreferences?.setString(_loginWithKey, loginWith);
    }

    UserSession.accessToken = accessToken;
    UserSession.loginWith = loginWith;
    UserSession.fcmToken = fcmToken;
    UserSession.isLoggedIn = true;
  }

  static Future<void> saveFCMToken({fcmToken}) async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    _sharedPreferences?.setString(_fcmTokenKey, fcmToken);
    UserSession.fcmToken = fcmToken;
  }

  static Future<void> saveCurrentLocation({lat,lng}) async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    _sharedPreferences?.setDouble(_lat, lat);
    _sharedPreferences?.setDouble(_lng, lng);
    UserSession.lat = lat;
    UserSession.lng = lng;
  }

  static Future<void> getCurrentLocation() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    lat = _sharedPreferences?.getDouble(_lat);
    lng = _sharedPreferences?.getDouble(_lng);
    if(lat!=null && lng!=null){
      gCurrentLocation = LatLng(lat!, lng!);
    }
  }

  static Future<bool?> exist() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    accessToken = _sharedPreferences?.getString(_accessTokenKey);
    guestUserId = _sharedPreferences?.getString(_guestUserId);
    if(guestUserId==null){
      var guestId=await getDeviceId();
      await _sharedPreferences?.setString(_guestUserId,guestId! );
      guestUserId=guestId;
    }

    fcmToken = _sharedPreferences?.getString(_fcmTokenKey);
    loginWith = _sharedPreferences?.getString(_loginWithKey);
    firstLaunch = _sharedPreferences?.getBool(_firstLaunch) ?? true;
    if (accessToken != null) {
      isLoggedIn = true;
    }
    return isLoggedIn;
  }

  static Future<void> logout() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
   await Future.wait([ _sharedPreferences!.remove(_accessTokenKey),
    _sharedPreferences!.remove(_fcmTokenKey),
    _sharedPreferences!.remove(_loginWithKey)]);

  //  await NotificationHandler.deleteToken();
    UserSession.isLoggedIn = false;
    UserSession.fcmToken = null;
    UserSession.loginWith = null;
    UserSession.accessToken = null;
  }
}
