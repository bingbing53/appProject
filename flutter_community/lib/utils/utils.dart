import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/common/common.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:lpinyin/lpinyin.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class Utils {

  //隐藏手机号
  static String hideMobile(String phoneNumber){
    if(ObjectUtil.isEmpty(phoneNumber))
      return "";
    return phoneNumber.replaceFirst(new RegExp(r'\d{4}'), '****', 3);
  }
  //截取长度多余隐藏
  static String subLength(String str,int length){
    if(ObjectUtil.isEmpty(str)){
      return '';
    }
    if(ObjectUtil.getLength(str) <= length){
      return str;
    }
    return str.substring(0,length)+"...";
  }

  static String getImgPath(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
  }

  static String getUrlParam(String url,String name){
    Uri u = Uri.parse(url);
    String param = u.queryParameters[name];
    return param;
  }

  static String getPinyin(String str) {
    return PinyinHelper.getShortPinyin(str).substring(0, 1).toUpperCase();
  }

  static Color getCircleBg(String str) {
    String pinyin = getPinyin(str);
    return getCircleAvatarBg(pinyin);
  }

  static Color getCircleAvatarBg(String key) {
    return circleAvatarMap[key];
  }

  static Color getChipBgColor(String name) {
    String pinyin = PinyinHelper.getFirstWordPinyin(name);
    pinyin = pinyin.substring(0, 1).toUpperCase();
    return nameToColor(pinyin);
  }

  static Color nameToColor(String name) {
    // assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  static String getTimeLine(BuildContext context, int timeMillis) {
//    LogUtil.e("countryCode: " +
//        Localizations.localeOf(context).countryCode +
//        "   languageCode: " +
//        Localizations.localeOf(context).languageCode);
    return TimelineUtil.format(timeMillis,
        locale: Localizations.localeOf(context).languageCode,
        dayFormat: DayFormat.Common);
  }

  static String getTimeLineByDateTime(BuildContext context,DateTime dateTime){
    return TimelineUtil.formatByDateTime(dateTime,locale: Localizations.localeOf(context).languageCode,dayFormat: DayFormat.Common);
  }

  static double getTitleFontSize(String title) {
    if (ObjectUtil.isEmpty(title) || title.length < 10) {
      return 18.0;
    }
    int count = 0;
    List<String> list = title.split("");
    for (int i = 0, length = list.length; i < length; i++) {
      String ss = list[i];
      if (RegexUtil.isZh(ss)) {
        count++;
      }
    }
    return (count >= 10 || title.length > 16) ? 14.0 : 18.0;
  }

  /// 0
  /// -1
  /// 1
  static int getUpdateStatus(String version) {
    String locVersion = AppConfig.version;
    int remote = int.tryParse(version.replaceAll('.', ''));
    int loc = int.tryParse(locVersion.replaceAll('.', ''));
    if (remote <= loc) {
      return 0;
    } else {
      return (remote - loc >= 2) ? -1 : 1;
    }
  }

  //是否需要刷新页面
  static bool getRefreshWeb(String localVersion,String remoteVersion){
    if(localVersion == null || remoteVersion == null){
      return true;
    }
    int remote = int.tryParse(remoteVersion.replaceAll('.', ''));
    int loc = int.tryParse(localVersion.replaceAll('.', ''));
    return remote > loc;
  }

  // md5 加密
  static String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }


  static int getLoadStatus(bool hasError, List data) {
    if (hasError) return LoadStatus.fail;
    if (data == null) {
      return LoadStatus.loading;
    } else if (data.isEmpty) {
      return LoadStatus.empty;
    } else {
      return LoadStatus.success;
    }
  }
  //将日期格式化为 年 月 日 周几 时间
  static String timeShowFormat(DateTime date){
    if(date == null)
      return '';
    int year = DateTime.now().year;
    int week = date.weekday;
    String weekStr = '';
    switch(week){
      case 1:weekStr = '一';break;
      case 2:weekStr = '二';break;
      case 3:weekStr = '三';break;
      case 4:weekStr = '四';break;
      case 5:weekStr = '五';break;
      case 6:weekStr = '六';break;
      case 7:weekStr = '天';break;
    }
    if(year == date.year){
      return '${date.month}月${date.day}日 周$weekStr ${date.hour<10?'0${date.hour}':date.hour}:${date.minute<10?'0${date.minute}':date.minute}';
    }else{
      return '${date.year}年${date.month}月${date.day}日 周$weekStr ${date.hour<10?'0${date.hour}':date.hour}:${date.minute<10?'0${date.minute}':date.minute}';
    }
  }

  //将日期格式化为 年 月 日 周几 时间
  static String timeShortFormat(String dateStr){
    if(dateStr == null)
      return '';
    DateTime date = DateUtil.getDateTime(dateStr);
    int year = DateTime.now().year;
    if(year == date.year){
      return '${date.month}-${date.day} ${date.hour<10?'0${date.hour}':date.hour}:${date.minute<10?'0${date.minute}':date.minute}';
    }else{
      return '${date.year}-${date.month}-${date.day} ${date.hour<10?'0${date.hour}':date.hour}:${date.minute<10?'0${date.minute}':date.minute}';
    }
  }

}
