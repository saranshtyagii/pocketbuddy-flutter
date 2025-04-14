import 'dart:convert';

import 'package:PocketBuddy/constants/UrlConstants.dart';
import 'package:PocketBuddy/mapper/PersonalExpenseData.dart';
import 'package:PocketBuddy/mapper/UserDetails.dart';
import 'package:PocketBuddy/utils/AuthUtils.dart';
import 'package:http/http.dart' as http;

class PersonalExpenseService {
  Future<List<PersonalExpenseData>> fetchExpense() async {
    try {
      UserDetails? userDetails = await UserDetails.getInstance();
      String token = await AuthUtils().getAuthToken();
      Uri url = Uri.parse(
        '${UrlConstants.backendUrlV1}/personal/fetchAll?userId=${userDetails?.userId}',
      );
      http.Response response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList
            .map((json) => PersonalExpenseData.convertToObject(json))
            .toList();
      }
    } catch (error) {
      print("Error while refresh personal expense data list: $error");
    }
    return [];
  }

  Future<bool> addExpense(Map<String, dynamic> addRequest) async {
    try {
      Uri url = Uri.parse('${UrlConstants.backendUrlV1}/personal/register');
      String token = await AuthUtils().getAuthToken();
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(addRequest),
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (error) {
      print("Error while add expense: $error");
    }
    return false;
  }
  
  Future<bool> deleteExpense(String expenseId) async {
    try {
      Uri url = Uri.parse('${UrlConstants.backendUrlV1}/personal/delete?expenseId=$expenseId');
      String token = await AuthUtils().getAuthToken();
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if(response.statusCode == 200) {
        return true;
      }
    } catch (error) {
      print("Error while deleting expense: $error");
    }
    return false;
  }

}
