import 'dart:convert';

import 'package:PocketBuddy/constants/UrlConstants.dart';
import 'package:PocketBuddy/mapper/UserDetails.dart';
import 'package:PocketBuddy/utils/AuthUtils.dart';


import 'package:http/http.dart' as http;

class UserServices {
  fetchUserDetails(String usernameOrEmail) async {
    try {
      Uri uri = Uri.parse(
        '${UrlConstants.backendUrlV1}/user/find?email=$usernameOrEmail',
      );

      final token = await AuthUtils().getAuthToken();

      http.Response response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        // extract the data from response
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        // map string into object
        final userDetails = UserDetails.jsonToUserDetails(responseJson);
        // save data into storage
        UserDetails.saveUserDetailsToStorage(userDetails);
      }
    } catch (error) {}
  }
}
