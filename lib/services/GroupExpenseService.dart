import 'dart:convert';

import 'package:PocketBuddy/constants/UrlConstants.dart';
import 'package:PocketBuddy/utils/AuthUtils.dart';

import '../mapper/GroupExpenseDetails.dart';

import 'package:http/http.dart' as http;

class GroupExpenseService {
  Future<List<GroupExpenseDetails>> fetchAllExpenses(String userId) async {
    try {
      Uri url = Uri.parse(
        '${UrlConstants.backendUrlV1}/group/find-user-joined-groups?userId=$userId',
      );

      // fetch Auth Token
      String token = await AuthUtils().getAuthToken();

      http.Response response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if(response.statusCode==200) {
        final jsonResponse = jsonDecode(response.body);
        print("User Joined Group: \n $jsonResponse");
      }

    } catch (error) {
      // throw Error(error.toString());
    }
    return [];
  }
}
