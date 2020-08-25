import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewLocalFlutter extends StatefulWidget{

  final String content;

  const WebViewLocalFlutter({Key key, this.content}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WebViewFlutterState();
  }

}

class WebViewFlutterState extends State<WebViewLocalFlutter>{

  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: new Uri.dataFromString('${widget.content}',mimeType: 'text/html',encoding: Encoding.getByName('utf-8')).toString(),//'https://www.github.com',///初始化url
      javascriptMode: JavascriptMode.unrestricted,///JS执行模式
      onWebViewCreated: (WebViewController webViewController) {///在WebView创建完成后调用，只会被调用一次
        _controller.complete(webViewController);
      },
      javascriptChannels: <JavascriptChannel>[///JS和Flutter通信的Channel；
//        _alertJavascriptChannel(context),
      ].toSet(),
      navigationDelegate: (NavigationRequest request) {//路由委托（可以通过在此处拦截url实现JS调用Flutter部分）；
        ///通过拦截url来实现js与flutter交互
        if (request.url.startsWith('js://webview')) {
//          Fluttertoast.showToast(msg:'JS调用了Flutter By navigationDelegate');
          print('blocking navigation to $request}');
          return NavigationDecision.prevent;///阻止路由替换，不能跳转，因为这是js交互给我们发送的消息
        }

        return NavigationDecision.navigate;///允许路由替换
      },
      onPageFinished: (String url) {///页面加载完成回调
        print('Page finished loading: $url');
      },
    );
  }
}