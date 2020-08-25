import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helloworld/components/disclaimer_msg.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

GlobalKey<DisclaimerMsgState> key;

class WebViewPage extends StatefulWidget {

  final String url,title;

  WebViewPage(this.url,this.title);

  @override
  WebViewPageState createState() => new WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> with AutomaticKeepAliveClientMixin{

  TextEditingController controller = TextEditingController();
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

  // WebView加载状态变化监听器
  StreamSubscription<WebViewStateChanged> onStateChanged;

  // 插件提供的对象，该对象用于WebView的各种操作
  FlutterWebviewPlugin flutterWebViewPlugin = new FlutterWebviewPlugin();

  // 标记是否是加载中
  bool loading = true;

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged wvs) {
      print(wvs.type);
    });

    onStateChanged = flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state){
      // state.type是一个枚举类型，取值有：WebViewState.shouldStart, WebViewState.startLoad, WebViewState.finishLoad
      switch (state.type) {
        case WebViewState.shouldStart:
        // 准备加载
          setState(() {
            loading = true;
          });
          break;
        case WebViewState.startLoad:
        // 开始加载
          break;
        case WebViewState.finishLoad:
        // 加载完成
          setState(() {
            loading = false;
          });
//          if (isLoadingCallbackPage) {
//            // 当前是回调页面，则调用js方法获取数据
//            parseResult();
//          }
          break;
        case WebViewState.abortLoad:
          // TODO: Handle this case.
          break;
      }
    });
  }

//  launchUrl() {
//    setState(() {
//      urlString = controller.text;
//      flutterWebviewPlugin.reloadUrl(urlString);
//    });
//  }

  @override
  Widget build(BuildContext context) {

    List<Widget> titleContent = [];
    titleContent.add(new Text(
      widget.title,
      style: new TextStyle(color: Colors.white),
    ));
    if (loading) {
      // 如果还在加载中，就在标题栏上显示一个圆形进度条
      titleContent.add(SpinKitCircle(size: 26.0, color: Colors.white));
    }
    titleContent.add(new Container(width: 50.0));
    // WebviewScaffold是插件提供的组件，用于在页面上显示一个WebView并加载URL

    return WebviewScaffold(
      appBar: new AppBar(
        title: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: titleContent,
        ),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
//      appBar: AppBar(
//        title: TextField(
//          autofocus: false,
//          controller: controller,
//          textInputAction: TextInputAction.done,
////          onSubmitted: (url) => launchUrl(),
//          style: TextStyle(color: Colors.white),
//          decoration: InputDecoration(
//            border: InputBorder.none,
//            hintText: widget.title,
//            hintStyle: TextStyle(color: Colors.white),
//          ),
//        ),
////        actions: <Widget>[
////          IconButton(
////            icon: Icon(Icons.navigate_next),
////            onPressed: () => launchUrl(),
////          )
////        ],
//      ),
      url: widget.url,
      withZoom: false,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


