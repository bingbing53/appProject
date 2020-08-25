import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:helloworld/tviews/widget/widget_index.dart';

//西墨门禁
class DoormasterUtils {
  static const MethodChannel _channel = const MethodChannel('doormaster_plugin');

  static const Map<int,String> openResult = { 0 : "操作成功",48:"通信连接超时",49:"蓝牙服务未发现"};

  //扫描设备
  static Future<List> scanDevice() async {
    var res = await _channel.invokeMethod('scanDevice');
    print(res);
    return res;
  }

  //开门
  static Future<String> openDoor({
    @required String eKey,@required String devSn,@required String devMac,@required int devType}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'eKey':eKey,
      'devSn':devSn,
      'devMac':devMac,
      'devType':devType
    };
    var res = await _channel.invokeMethod('openDoor', params);

    print('res-----'+res);
    Fluttertoast.showToast(msg: res);

    String result = openResult[res];

    return result;
  }

  //配置自动扫描
  static Future<bool> autoOpen({
    @required String auto,
    @required String devList,
    int limit = -75,

  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'auto':auto,
      'limit':limit,
      'devList':devList
    };
    var res = await _channel.invokeMethod('autoOpen', params);
    return res;
  }

  static Future<bool> closeAutoOpen() async {
    var res = await _channel.invokeMethod('closeAutoOpen');
    return res;
  }
}