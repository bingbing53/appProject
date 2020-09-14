
//web组件工具类
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/api/apis.dart';
import 'package:flutter_wanandroid/utils/util_index.dart';
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
//            // add
//            javascriptChannels: <JavascriptChannel>[ //javascriptChannels这个是api提供的互调的方法，
//              _toastJavascriptChannel(context),
//            ].toSet();
          },
          // add
          // javascriptChannels: <JavascriptChannel>[
          //   JavascriptChannel(
          //     name: "share",
          //     onMessageReceived: (JavascriptMessage message) {
          //       print("参数： ${message.message}");
          //     }
          //   ),
          // ].toSet(),
          // 往h5 window 里面插入全局方法 Toaster
          // JavascriptChannel _toastJavascriptChannel(BuildContext context) {
          //   return JavascriptChannel(
          //     name: 'Toaster',
          //     onMessageReceived: (JavascriptMessage message) {
          //       print(message);
          //       Fluttertoast.showToast(
          //         msg: message.message
          //       );
          //     });
          // }


        ),
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