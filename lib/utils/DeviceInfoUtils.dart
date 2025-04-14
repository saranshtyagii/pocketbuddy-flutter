import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:http/http.dart' as http;

class DeviceInfoUtils {

  String deviceId = '';
  String ipAddress = '';
  String modelName = '';
  String modelVersion = '';
  String osVersion = '';
  String appVersion = 'mark01';

  static Future<DeviceInfoUtils> init() async {
    final deviceDetails = DeviceInfoUtils();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if(Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      deviceDetails.deviceId = androidInfo.id ?? '';
      deviceDetails.modelName = androidInfo.model ?? '';
      deviceDetails.modelVersion = androidInfo.device ?? '';
      deviceDetails.osVersion = 'Android ${androidInfo.version.release}';

    } else if(Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceDetails.deviceId = iosInfo.identifierForVendor ?? '';
      deviceDetails.modelName = iosInfo.name ?? '';
      deviceDetails.modelVersion = iosInfo.model ?? '';
      deviceDetails.osVersion = 'iOS ${iosInfo.systemVersion}';
    }

    // Ip Address
    try {
      final response = await http.get(Uri.parse('https://api.ipify.org?format=json'));
      if(response.statusCode == 200) {
        deviceDetails.ipAddress = jsonDecode(response.body)['ip'];
      }
    } catch(error) {
      deviceDetails.ipAddress = 'Unavailable';
    }

    // AppVersion
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      deviceDetails.appVersion = packageInfo.version;
    } catch(error) {
      deviceDetails.appVersion = 'mark01';
    }

    return deviceDetails;
  }

}