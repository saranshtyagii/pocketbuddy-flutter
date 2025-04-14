import 'dart:convert';

import 'package:PocketBuddy/screens/HomeScreen.dart';
import 'package:PocketBuddy/services/UserServices.dart';
import 'package:PocketBuddy/utils/AuthUtils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:PocketBuddy/constants/UrlConstants.dart';
import 'package:PocketBuddy/exceptions/ErrorScreen.dart';
import 'package:PocketBuddy/main.dart';

import '../utils/DeviceInfoUtils.dart';

class AuthServices {
  final userServices = UserServices();

  createUserAccount(Map<String, dynamic> userJsonData) async {
    try {
      Uri uri = Uri.parse('${UrlConstants.backendUrlV1}/auth/register');

      http.Response registerResponse = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userJsonData),
      );

      if (registerResponse.statusCode == 200) {
        final DeviceInfoUtils deviceInfo = await DeviceInfoUtils.init();

        if (registerResponse.statusCode == 200) {
          Map<String, dynamic> userCredentials = {
            'usernameOrEmail': userJsonData['username'].toString(),
            'password': userJsonData['password'].toString(),
            'deviceId': deviceInfo.deviceId,
            'ipAddress': deviceInfo.ipAddress,
            'modelName': deviceInfo.modelName,
            'modelVersion': deviceInfo.modelVersion,
            'osVersion': deviceInfo.osVersion,
            'appVersion': deviceInfo.appVersion,
          };

          await authenticateUserAccount(userCredentials);

          if (await AuthUtils().havingAuthToken()) {
            await userServices.fetchUserDetails(
              userJsonData['username'].toString(),
            );
          }
        }
      }
    } catch (error) {
      print("AuthServices:\n$error");
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) => ErrorScreen()),
      );
    }
  }

  authenticateUserAccount(Map<String, dynamic> userCredentials) async {
    try {
      Uri uri = Uri.parse('${UrlConstants.backendUrlV1}/auth/login');

      http.Response authResponse = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userCredentials),
      );

      if (authResponse.statusCode == 200) {
        final jsonResponse = jsonDecode(authResponse.body);
        await AuthUtils().saveAuthToken(jsonResponse['token']);
      } else {
        _pushError();
      }
    } catch (error) {
      _pushError();
    }
  }

  _pushError() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => ErrorScreen()),
    );
  }

  Future<String> forgotPassword(String usernameOrEmail) async {
    try {
      Uri uri = Uri.parse(
        '${UrlConstants.backendUrlV1}/auth/forgot-password?usernameOrEmail=$usernameOrEmail',
      );
      http.Response response = await http.get(uri);
      return response.statusCode == 200 ? response.body : "";
    } catch (error) {
      return "";
    }
  }
}
