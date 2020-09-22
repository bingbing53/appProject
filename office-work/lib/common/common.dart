class Constant {
  static const String keyLanguage = 'key_language';

  static const int status_success = 200;

//  static const String server_address = wan_android;

  // 生产
  static const String server_address = "https://www.qicaidonghu.cn/server/rest/";
  static const String community_server_address = "https://api.shequyijia.cn/";
  static const String pic_server = "https://image.shequyijia.cn/pic/";

  // 测试
//  static const String server_address = "https://mongo.qicaidonghu.cn/server/rest/";
//  static const String community_server_address = "https://api.dev.shequyijia.cn/";
//  static const String pic_server = "https://mongo.qicaidonghu.cn/pic/";


  static const String wan_android = "http://www.wanandroid.com/";

  static const int type_sys_update = 1;
  static const String key_theme_color = 'key_theme_color';
  static const String key_guide = 'key_guide';
  static const String key_splash_model = 'key_splash_models';

  //登录成功
  static const int type_sys_login = 200;

  //token名称
  static const String key_token_name = "X-AUTH-TOKEN";
  //手机号
  static const String key_login_name = "X-AUTH-MOBILE";

  //关注用户
  static const String collect_user = "user";
  //关注社区
  static const String collect_depart = "depart";

}

class AppConfig {
  static const String appName = 'flutter_wanandroid';
  static const String version = '20200921.120000';
  static const bool isDebug = true;
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