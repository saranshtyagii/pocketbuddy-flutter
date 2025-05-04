import 'dart:convert';

import 'package:PocketBuddy/constants/UrlConstants.dart';
import 'package:PocketBuddy/utils/AuthUtils.dart';

import '../mapper/GroupExpenseDetails.dart';

import 'package:http/http.dart' as http;

class GroupExpenseService {
  Future<List<GroupExpenseDetails>> fetchAllExpenses(String groupId) async {
    try {
      Uri url = Uri.parse(
        '${UrlConstants.backendUrlV1}/group-expenses/fetch?groupId=$groupId',
      );

      // fetch Auth Token
      String token = await AuthUtils().getAuthToken();

      http.Response response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("User Joined Group: \n $jsonResponse");
      }
    } catch (error) {}
    return [];
  }

  Future<Map<String, String>> fetchJoinMembers(String groupId) async {
    Map<String, String> members = {};

    try {
      final Uri url = Uri.parse(
        '${UrlConstants.backendUrlV1}/group/find-members?groupId=$groupId',
      );
      final String token = await AuthUtils().getAuthToken();

      final http.Response response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        members = responseJson.map(
          (key, value) => MapEntry(key, value.toString()),
        );
      } else {
        print('Failed to fetch members. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print("Error fetching members: $error");
    }

    return members;
  }
}
