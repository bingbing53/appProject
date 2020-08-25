import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class DoormasterUtils {
  static const MethodChannel _channel =
      const MethodChannel('doormaster_plugin');

  static Future<String> showToast({
    @required String msg,
    int timeInSecForIos = 1,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'msg': msg,
    };
    var res = await _channel.invokeMethod('showToast', params);
    print('调用了方法showToast$res');
    return res;
  }
}