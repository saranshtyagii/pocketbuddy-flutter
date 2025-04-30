import 'dart:convert';

import 'package:PocketBuddy/constants/UrlConstants.dart';
import 'package:PocketBuddy/mapper/UserJoinGroup.dart';
import 'package:PocketBuddy/utils/AuthUtils.dart';
import 'package:http/http.dart' as http;

class GroupDetailService {

  Future<List<UserJoinGroup>> loadUserJoinGroup(String userId) async {
    try {
      Uri url = Uri.parse("${UrlConstants.backendUrlV1}/group/find-user-joined-groups?userId=$userId");
      String token = await AuthUtils().getAuthToken();
      http.Response response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if(response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);

        // Safely map and convert to List<UserJoinGroup>
        List<UserJoinGroup> groups = jsonList.map<UserJoinGroup>((item) {
          return UserJoinGroup.fromJson(item as Map<String, dynamic>);
        }).toList();

        return groups;
      }

    } catch (error) {
      // ignore
    }
    return [];
  }

  Future<UserJoinGroup?> registerGroup(Map<String, dynamic> group) async {
    try {
      final Uri url = Uri.parse("${UrlConstants.backendUrlV1}/group/new-group");
      final String token = await AuthUtils().getAuthToken();

      final http.Response registerResponse = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(group),
      );
      if (registerResponse.statusCode == 200) {
        final responseJson = jsonDecode(registerResponse.body);
        return UserJoinGroup.fromJson(responseJson);
      }
    } catch (error) {
      // ignore
    }
    return null;
  }
}