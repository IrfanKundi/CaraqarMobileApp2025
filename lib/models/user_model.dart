import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class UserModel {
  int? userId;
  String? firstName;
  String? lastName;
  String? profileImage;
  String? email;
  PhoneNumber? phoneNumber;
  String? loginWith;

  UserModel();
  UserModel.fromMap(map) {
    userId = map[0]["UserId"];
    firstName = map[0]["FirstName"];
    lastName = map[0]["LastName"];
    profileImage = map[0]["Image"];
    email = map[0]["Email"];
    loginWith = map[0]["LoginWith"];
    if(map[0]["PhoneNumber"]!=null){
      phoneNumber = PhoneNumber(phoneNumber: map[0]["PhoneNumber"],dialCode: map[0]["CountryCode"],isoCode: map[0]["IsoCode"]);
    }

  }
}
