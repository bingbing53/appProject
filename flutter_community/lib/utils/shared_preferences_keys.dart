
// Created with Android Studio.
// User: 三帆
// Date: 31/01/2019
// Time: 18:13
// email: sanfan.hx@alibaba-inc.com
// target:  xxx
//


//enum DateType {
//  Int,
//  Double,
//  Bool,
//  String,
//  Dynamic
//}

//class spKey {
//  String name;
//  DateType type;
//
//  spKey({this.name, this.type});
//}

class SharedPreferencesKeys {
  /// boolean
  /// 用于存储用户的社区属性
  static String sysOrgCode = 'sysOrgCode';

  /// 用于存储用户的社区名
  static String streetValue = 'streetValue';

  //用于判断是否登录
  static String isLogin = 'isLogin';
  /// json 
  /// 用于存放搜索页的搜索数据.
  /// [{
  ///  name: 'name'
  ///  
  /// }]
  static String searchHistory = 'searchHistory';

  //存放所有的社区
  static String commName = 'commName';

}

