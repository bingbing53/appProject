import 'package:flutter/services.dart';

//注册推送
class InstallApkUtils {
  static const MethodChannel _channel =const MethodChannel('install_apk');

  static install(String path) async {
    _channel.invokeMethod('install',path);
  }
}