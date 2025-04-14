import 'dart:convert';

import 'package:PocketBuddy/constants/ConstantValues.dart';
import 'package:PocketBuddy/main.dart';
import 'package:PocketBuddy/utils/AuthUtils.dart';

import '../constants/ConstantValues.dart';
import '../main.dart';
import '../utils/AuthUtils.dart';

class UserDetails {
  final String userId;
  final String userFirstName;
  final String userLastName;
  final String username;
  final String email;
  final String mobileNumber;
  final String password;

  static UserDetails? _savedUserDetails;

  UserDetails({
    required this.userId,
    required this.userFirstName,
    required this.userLastName,
    required this.username,
    required this.email,
    required this.mobileNumber,
    required this.password,
  });

  static Map<String, dynamic> convertToJson(UserDetails user) {
    return {
      'userId': user.userId,
      'userFirstName': user.userFirstName,
      'userLastName': user.userLastName,
      'username': user.username,
      'email': user.email,
      'mobileNumber': user.mobileNumber,
      'password': user.password,
    };
  }

  static UserDetails jsonToUserDetails(Map<String, dynamic> jsonUser) {
    return UserDetails(
      userId: jsonUser['userId'].toString(),
      userFirstName: jsonUser['userFirstName'].toString(),
      userLastName: jsonUser['userLastName'].toString(),
      username: jsonUser['username'].toString(),
      email: jsonUser['email'].toString(),
      mobileNumber: jsonUser['mobileNumber'].toString(),
      password: jsonUser['password'].toString(),
    );
  }

  static saveUserDetailsToStorage(UserDetails userDetails) async {
    final data = jsonEncode(convertToJson(userDetails));
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

  static Future<UserDetails?> getInstance() async {
    _savedUserDetails ??= await fetchUserDetailsFromStorage();
    return _savedUserDetails;
  }

}
