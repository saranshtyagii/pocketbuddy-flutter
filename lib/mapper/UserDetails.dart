import 'dart:convert';

import 'package:PocketBuddy/constants/ConstantValues.dart';
import 'package:PocketBuddy/main.dart';
import 'package:PocketBuddy/utils/AuthUtils.dart';


class UserDetails {
  final String userId;
  final String userFirstName;
  final String userLastName;
  final String email;
  final String mobileNumber;
  final String password;
  final bool emailVerified;

  UserDetails({
    required this.userId,
    required this.userFirstName,
    required this.userLastName,
    required this.email,
    required this.mobileNumber,
    required this.password,
    required this.emailVerified
  });

  static Map<String, dynamic> convertToJson(UserDetails user) {
    return {
      'userId': user.userId,
      'userFirstName': user.userFirstName,
      'userLastName': user.userLastName,
      'email': user.email,
      'mobileNumber': user.mobileNumber,
      'password': user.password,
      "emailVerified" : user.emailVerified
    };
  }

  static UserDetails jsonToUserDetails(Map<String, dynamic> jsonUser) {
    return UserDetails(
      userId: jsonUser['userId'].toString(),
      userFirstName: jsonUser['userFirstName'].toString(),
      userLastName: jsonUser['userLastName'].toString(),
      email: jsonUser['email'].toString(),
      mobileNumber: jsonUser['mobileNumber'].toString(),
      password: jsonUser['password'].toString(),
      emailVerified: jsonUser['emailVerified']
    );
  }

  static saveUserDetailsToStorage(UserDetails userDetails) async {
    final data = jsonEncode(convertToJson(userDetails));
    await storage.delete(key: ConstantValues.userKey);
    await storage.write(key: ConstantValues.userKey, value: data);
  }

  static Future<UserDetails?> fetchUserDetailsFromStorage() async {
    final data = await storage.read(key: ConstantValues.userKey);
    if(data == null) {
      AuthUtils().removeAuthToken();
      return null;
    }
    return convertStringToUserDetails(data);
  }

  static UserDetails convertStringToUserDetails(String data) {
    Map<String, dynamic> jsonUser = jsonDecode(data);
    return jsonToUserDetails(jsonUser);
  }

}
