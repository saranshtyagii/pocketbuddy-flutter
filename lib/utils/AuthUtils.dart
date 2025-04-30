import 'package:PocketBuddy/constants/ConstantValues.dart';
import 'package:PocketBuddy/main.dart';
import 'package:PocketBuddy/mapper/UserDetails.dart';
import 'package:PocketBuddy/services/AuthServices.dart';

class AuthUtils {

  final authService = AuthServices();

  // Singleton implementation (if needed globally)
  static final AuthUtils _instance = AuthUtils._internal();

  factory AuthUtils() {
    return _instance;
  }

  AuthUtils._internal();

  Future<bool> havingAuthToken() async {
    String token = await getAuthToken();
    return token.isNotEmpty;
  }

  Future<String> getAuthToken() async {
    try {
      String? token = await storage.read(key: ConstantValues.authKey);
      if (token != null && token.isNotEmpty) {
        return token;
      }
      removeAuthToken();
      return "";
    } catch (error) {
      return "";
    }
  }

  Future<bool> removeAuthToken() async {
    try {
      await storage.delete(key: ConstantValues.authKey);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> saveAuthToken(String token) async {
    try {
      await storage.write(key: ConstantValues.authKey, value: token);
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await removeAuthToken();
      await storage.delete(key: ConstantValues.userKey);
      return true;
    } catch (error) {
      return false;
    }
  }
}
