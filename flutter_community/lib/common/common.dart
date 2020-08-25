import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Constant {
  static const String keyLanguage = 'key_language';

  static const int status_success = 200;

  //测试换成生产prod_server_android
//  static const String server_address = wan_android;
  static const String server_address = test_server_android;

  static const String wan_android = "http://www.wanandroid.com/";

  //开发
  static const String dev_server_android = "http://192.108.1.108:8080/server/rest/";
  //测试
//  static const String test_server_android = "https://mongo.qicaidonghu.cn/server/rest/";
  static const String test_server_android = "https://api.dev.shequyijia.cn/";
  //生产
  static const String prod_server_android = "https://api.shequyijia.cn/";

  //测试换成生产切换
  static const String test_pic_server = "https://mongo.qicaidonghu.cn/pic/";
//  static const String test_pic_server = "https://image.shequyijia.cn/pic/";

  static const int type_sys_update = 1;
  static const String key_theme_color = 'key_theme_color';
  static const String key_guide = 'key_guide';
  static const String key_splash_model = 'key_splash_models';

  //token名称
  static const String key_token_name = "X-AUTH-TOKEN";
  //手机号
  static const String key_login_name = "X-AUTH-MOBILE";
  //街道
  static const String key_street = "X-SYS-ORGCODE";
  //蓝牙
  static const String key_bluepermission = "blue-devices";

}

class AppConfig {
  static const String appName = 'jm_app';
  static const String version = '20200809.170000';
  static const bool isDebug = false;
}

class WebViewPlugin{
  static FlutterWebviewPlugin flutterWebViewPlugin = FlutterWebviewPlugin();
}

class LoadStatus {
  static const int fail = -1;
  static const int loading = 0;
  static const int success = 1;
  static const int empty = 2;
}

class BaseConstant {
  static const String packageBase = 'base_library';

  static const String keyShowGuide = 'show_guide';
  static const String keyUserName = 'user_name';
  static const String keyUserModel = 'user_model';
  static const String keyAppToken = 'app_token';

  static const String routeMain = 'route_main';
  static const String routeLogin = 'route_login';
}