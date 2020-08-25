import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/res/res_index.dart';
import 'package:flutter_wanandroid/utils/util_index.dart';
import 'package:lpinyin/lpinyin.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

class Utils {
  static String getImgPath(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
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
  //时间转为类似微信的时间
//  static String trans2WxTime (int time) {
//    var now = new DateTime.now();
//    var toDay = now.day;; // 今天是哪号
//
//    var date = DateTime.fromMicrosecondsSinceEpoch(time);
//    var timeDay = date.day; // 时间缀转为具体的哪一号
//
//    var toYear = now.year; // 获取年
//    var timeYear = date.year; // 获取年
//
//    var toMonth = now.month + 1; // 获取月
//    var timeMonth = date.month + 1; // 获取月
//    var myMonth = toMonth - timeMonth;
//    var toHours = now.hour; // 获取小时
//    dynamic timeHours = date.hour; // 获取小时
//    dynamic Minutes = now.minute; // 获取分钟
//    var timeMinutes = date.minute; // 获取分钟
//    if (timeHours < 10) {
//      timeHours = '0$timeHours';
//    }
//    if (Minutes < 10) {
//      Minutes = '0$Minutes';
//    }
//    // console.log(toYear, timeYear)
//    if (toYear - timeYear > 0) {
//      dynamic tm = timeMonth;
//      if (tm < 10) {
//        tm = ('0' + tm);
//      }
//      dynamic td = timeDay;
//      if (td < 10) {
//        td = ('0' + td);
//      }
//      // console.log('一年前')
//      // console.log(timeYear + '-' + timeMonth + '-' + timeDay)
//      return '$timeYear-$tm-$td  $timeHours:$Minutes';
//    }
//    // 大于一周
//    // console.log(toDay, timeDay)
//    if ((myMonth == 0) && ((toYear - timeYear) == 0)) {
//      // 本月
//      // 一周内的
//      if ((toDay - timeDay) == 0) {
//        // 日期是今天的
//        // 一个小时内3分钟前的
//        // 15分内3分前的
//        if ((toHours - timeHours) == 0) {
//          // 一个小时内
//          var xz = ((new Date()) - time) / 60000;
//          var fz = Math.floor(xz);
//          if (fz > 3) {
//            return Math.floor(xz) + '分钟前';
//          }
//        } else {
//          // 大于一个小时
//          if (timeMinutes < 10) {
//            timeMinutes = '0' + timeMinutes;
//          }
//          return (timeHours + ':' + timeMinutes);
//        }
//      } else if (((toDay - timeDay) >= 1) && (toDay - timeDay <= 7)) {
//        // 1周内的
//        var weekTime = (new Date(time)).getDay();
//        var weekD;
//        if (weekTime == 0) weekD = '星期日';
//        if (weekTime == 1) weekD = '星期一';
//        if (weekTime == 2) weekD = '星期二';
//        if (weekTime == 3) weekD = '星期三';
//        if (weekTime == 4) weekD = '星期四';
//        if (weekTime == 5) weekD = '星期五';
//        if (weekTime == 6) weekD = '星期六';
//        // console.log(weekD)
//        return (weekD + ' ' + timeHours + ':' + Minutes);
//        // console.log('昨天')
//      } else {
//        // 大于一周显示日期（如：3月25日
//        var tm = timeMonth;
//        if (tm < 10) {
//          tm = ('0' + tm);
//        }
//        var td = timeDay;
//        if (td < 10) {
//          td = ('0' + td);
//        }
//        return (timeYear + '-' + tm + '-' + td + ' ' + timeHours + ':' + Minutes);
//      }
//    }
//    if ((myMonth > 0) && ((toYear - timeYear) == 0)) {
//      // 大于1个月，同一年的
//      var tm = timeMonth;
//      if (tm < 10) {
//        tm = ('0' + tm);
//      }
//      var td = timeDay;
//      if (td < 10) {
//        td = ('0' + td);
//      }
//      return (timeYear + '-' + tm + '-' + td + ' ' + timeHours + ':' + Minutes);
//    }
//  }

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
    if(ObjectUtil.isEmpty(localVersion) || ObjectUtil.isEmpty(remoteVersion)){
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

  //将日期格式化为 年 月 日 时间
  static String timeShortFormat(String dateStr,{String short}){
    if(dateStr == null)
      return '';
    DateTime date = DateUtil.getDateTime(dateStr);
    int year = DateTime.now().year;
    if(year == date.year){

      if(short == '1'){
        int month = DateTime.now().month;
        int day = DateTime.now().day;
        if(month == date.month && day == date.day){
          return '${date.hour<10?'0${date.hour}':date.hour}:${date.minute<10?'0${date.minute}':date.minute}';
        }
      }

      return '${date.month}-${date.day} ${date.hour<10?'0${date.hour}':date.hour}:${date.minute<10?'0${date.minute}':date.minute}';
    }else{
      return '${date.year}-${date.month}-${date.day} ${date.hour<10?'0${date.hour}':date.hour}:${date.minute<10?'0${date.minute}':date.minute}';
    }
  }

  static changeChatUserSort(){
    String sort = SpUtil.getString("chat_sort",defValue:"realname");
    if(sort == 'realname') {
      SpUtil.putString("chat_sort", "depart");
    }else if(sort == 'depart'){
      SpUtil.putString("chat_sort", "personType");
    }else if(sort == 'personType'){
      SpUtil.putString("chat_sort", "realname");
    }
  }
}
