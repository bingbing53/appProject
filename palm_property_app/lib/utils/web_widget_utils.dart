
//web组件工具类
import 'package:flutter/material.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/data/api/apis.dart';
import 'package:estate/utils/util_index.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebWidgetUtils{
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  static WebViewController _webViewController;

  static Widget getWebView(String url,double height){
    return Container(
        height: height,
        child:WebView(
          initialUrl: url,
          //JS执行模式 是否允许JS执行
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _webViewController = controller;
            injectToken();
          },
          onPageFinished: (url) {
            injectToken();
          },
        )
    );
  }
  //注入token
  static injectToken(){
    if(ObjectUtil.isNotEmpty(_webViewController)) {
      String token = SpUtil.getString(Constant.key_token_name,defValue: '');
      _webViewController.evaluateJavascript('token("$token")');
      _webViewController.evaluateJavascript('window.localStorage.setItem("token_message", "$token")');
    }
  }
}