import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

//注册推送
class XPushUtils {
  static const MethodChannel _channel =
  const MethodChannel('xpush_plugin');

  static Future<Map<dynamic,dynamic>> getInfo() async {
    Map<dynamic,dynamic> registerInfo = await _channel.invokeMethod('getInfo');
    if(Platform.isIOS){
      registerInfo = {'platform':'ios'};
    }else{
      registerInfo = await _channel.invokeMethod('getInfo');
    }
    return registerInfo;
  }
}