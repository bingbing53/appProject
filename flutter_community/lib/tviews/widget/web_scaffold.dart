import 'dart:async';
import 'dart:ui';
import 'package:fluro/fluro.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/data/api/apis.dart';
import 'package:helloworld/routers/application.dart';
import 'package:helloworld/utils/util_index.dart';

import 'channels.dart';
class WebScaffold extends StatefulWidget {
  const WebScaffold({
    Key key,
    this.title,
    this.titleId,
    this.url,
    this.refreshCache,
    this.hideTitleBar
  }) : super(key: key);

  final String title;
  final String titleId;
  final String url;
  final bool refreshCache;
  final bool hideTitleBar;

  @override
  State<StatefulWidget> createState() {
    return new WebScaffoldState();
  }
}
bool initedWebView = false;
class WebScaffoldState extends State<WebScaffold> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool isLoading = false,canClose = true;
  MainBloc _mainBloc;
  int progress = 0;
  Timer _timer;

  String title;
  bool hideTitleBar = false;

  String token = '';

  FlutterWebviewPlugin flutterWebViewPlugin;
  @override
  void initState() {
    super.initState();
    hideTitleBar = widget.hideTitleBar??false;

    flutterWebViewPlugin = FlutterWebviewPlugin();
    Channels.flutterWebViewPlugin = flutterWebViewPlugin;
    _mainBloc = BlocProvider.of<MainBloc>(context);
    Channels.mainBloc = _mainBloc;
    Channels.context = context;

    _simulateProgress();

    title = widget.title;
    token = SpUtil.getString(Constant.key_token_name,defValue: '');

    _addListener();
    initedWebView = true;
  }

  void _addListener(){
    flutterWebViewPlugin.onStateChanged.listen((viewState) async {
      switch(viewState.type){
        case WebViewState.shouldStart:
          // 准备加载
          print('准备加载');
          setState(() {
            isLoading = true;
          });

//          try{
//            String token = SpUtil.getString('X-AUTH-TOKEN',defValue: '');
//            String sysOrgCode = SpUtil.getString(SharedPreferencesKeys.sysOrgCode,defValue: '');
//            flutterWebViewPlugin.evalJavascript("window.localStorage.setItem('token', '$token');window.localStorage.setItem('sysOrgCode', '$sysOrgCode');");
//          }catch(err){
//
//          }

          break;
        case WebViewState.startLoad:
          // 开始加载
          print('开始加载');
          try{
            String token = SpUtil.getString('X-AUTH-TOKEN',defValue: '');
            String sysOrgCode = SpUtil.getString(SharedPreferencesKeys.sysOrgCode,defValue: '');
            flutterWebViewPlugin.evalJavascript("window.localStorage.setItem('token', '$token');window.localStorage.setItem('sysOrgCode', '$sysOrgCode');");
          }catch(err){

          }
          setState(() {
            isLoading = true;
          });
          break;
        case WebViewState.finishLoad:
          //加载完成
          print('加载完成');
          try{
            String token = SpUtil.getString('X-AUTH-TOKEN',defValue: '');
            String sysOrgCode = SpUtil.getString(SharedPreferencesKeys.sysOrgCode,defValue: '');
            flutterWebViewPlugin.evalJavascript("window.localStorage.setItem('token', '$token');window.localStorage.setItem('sysOrgCode', '$sysOrgCode');");
          }catch(err){

          }
          setState(() {
            isLoading = false;
          });
          progress = 100;
          break;
        case WebViewState.abortLoad:
          //取消加载
          setState(() {
            isLoading = false;
          });
          break;
      }
    });

    flutterWebViewPlugin.onUrlChanged.listen((url){
      if(url == widget.url){
        canClose = true;
      }else{
        canClose = false;
      }
      flutterWebViewPlugin.evalJavascript("window.document.title").then((result){
        if(!ObjectUtil.isEmpty(result) && result.length > 0 && result != '""' && !result.contains("undefined")) {
          if(result.startsWith("'") || result.startsWith('"')) {
            title = result.substring(1, result.length - 1);
          }else {
            title = result;
          }
          if(mounted)
            setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    flutterWebViewPlugin.dispose();
    flutterWebViewPlugin = null;
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    }
  }

  Future _simulateProgress() async{
    if (_timer == null) {
      _timer = Timer.periodic(Duration(milliseconds: 50), (time) {
        progress++;
        if (progress > 95) {
          _timer.cancel();
          _timer = null;
          return;
        } else {
          setState(() {});
        }
      });
    }
  }

  Future<bool> _requestBack() async {
     bool canGoBack = await flutterWebViewPlugin.canGoBack();
     if(canGoBack){
         await flutterWebViewPlugin.goBack();
         String backUrl = await flutterWebViewPlugin.evalJavascript("location.href");
         if(backUrl.contains("forceClose")) {
           destroyWebViewPlugin();
           Navigator.pop(context);
         }else{
           flutterWebViewPlugin.evalJavascript('reload()');
         }
     }else{
       destroyWebViewPlugin();
       Navigator.pop(context);
     }
  }

  void destroyWebViewPlugin(){
    flutterWebViewPlugin.close();
    flutterWebViewPlugin.dispose();
    flutterWebViewPlugin = null;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> titleContent = [];
    titleContent.add(Text(
      widget.title,
      style: TextStyle(color: Colors.white),
    ));
    var url = ShequejiaApi.formatH5Path(widget.url);
    print(url);
    return WillPopScope(
        onWillPop: (){
          _requestBack();
          return Future.value(false);
        },
        child: WebviewScaffold(
            key: _scaffoldKey,
            url: url,
            appBar:new CustomAppbar(
              navigationBarBackgroundColor: Colours.app_main,
              title: title,
              contentHeight: hideTitleBar ? 0 : 45,
              leadingWidget: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.arrow_back_ios,size: 22,),color: Colors.white, onPressed: (){
                    _requestBack();
                  }),
                  SizedBox(width: 8),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: Text('关闭',style: TextStyle(color: Colors.white,fontSize: 17)),
                    onTap: (){
                      flutterWebViewPlugin.close();
                      flutterWebViewPlugin.dispose();
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
            withZoom: false,
            // 允许网页缩放
            withLocalStorage: true,
            // 允许LocalStorage
            withJavascript: true,
            // 允许执行js代码
            resizeToAvoidBottomInset: true,
            supportMultipleWindows:true,
            scrollBar:false,
            clearCache: true,
            javascriptChannels: Channels.getChannels(),
        )
    );

    return WebviewScaffold(
          key: _scaffoldKey,
          url: url,
          appBar:new CustomAppbar(
            navigationBarBackgroundColor: Colours.app_main,
            title: title,
            contentHeight: hideTitleBar ? 0 : 45,
            leadingWidget: Row(
              children: <Widget>[
                  IconButton(icon: Icon(Icons.arrow_back_ios,size: 22,),color: Colors.white, onPressed: (){
                    _requestBack();
                  }),
                  SizedBox(width: 8),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: Text('关闭',style: TextStyle(color: Colors.white,fontSize: 17)),
                    onTap: (){
//                      flutterWebViewPlugin.close();
//                      flutterWebViewPlugin.dispose();
                      Navigator.pop(context);
                    },
                  )
              ],
            ),
          ),
          withZoom: false,
          // 允许网页缩放
          withLocalStorage: true,
          // 允许LocalStorage
          withJavascript: true,
          // 允许执行js代码
          resizeToAvoidBottomInset: true,
          supportMultipleWindows:true,
          scrollBar:false,
          clearCache: true,
          javascriptChannels: Channels.getChannels(),
    );
  }

  Widget _progressBar() {
    return SizedBox(
      height: isLoading && progress < 100 ? 2 : 0,
      child: LinearProgressIndicator(
        value: isLoading ? progress / 100 : 1,
        backgroundColor: Color(0xfff3f3f3),
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
      ),
    );
  }
}


class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  final double contentHeight; //从外部指定高度
  Color navigationBarBackgroundColor; //设置导航栏背景的颜色
  Widget leadingWidget;
  Widget trailingWidget;
  String title;
  CustomAppbar({
    @required this.leadingWidget,
    @required this.title,
    this.contentHeight = 45,
    this.navigationBarBackgroundColor = Colors.white,
    this.trailingWidget,
  }) : super();

  @override
  State<StatefulWidget> createState() {
    return new _CustomAppbarState();
  }

  @override
  Size get preferredSize => new Size.fromHeight(contentHeight);
}

/// 这里没有直接用SafeArea，而是用Container包装了一层
/// 因为直接用SafeArea，会把顶部的statusBar区域留出空白
/// 外层Container会填充SafeArea，指定外层Container背景色也会覆盖原来SafeArea的颜色
///     var statusheight = MediaQuery.of(context).padding.top;  获取状态栏高度

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var paddingTop = MediaQueryData.fromWindow(window).padding.top;
    return new Container(
      color: widget.navigationBarBackgroundColor,
      child: new Container(
//            decoration: new UnderlineTabIndicator(
//              borderSide: BorderSide(width: 1.0, color: Color(0xFFeeeeee)),
//            ),
//            decoration: BoxDecoration(
//              image: DecorationImage(
//                image: AssetImage(
//                  Utils.getImgPath('home_top'),
//                ),
//                fit: BoxFit.fitWidth,
//              ),
//            ),
            color: Color(0xFFFD4346),
            height: widget.contentHeight + paddingTop,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: paddingTop,),
                Container(
                  height: widget.contentHeight,
                  child: new Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                        left: 0,
                        child: new Container(
//                    padding: const EdgeInsets.only(left: 5),
                          child: widget.leadingWidget,
                        ),
                      ),
                      new Container(
                        alignment: Alignment.center,
                        child: new Text(widget.title,
                            style: new TextStyle(
                                fontSize: 19, color: Colors.white)),
                      ),
                      Positioned(
                        right: 0,
                        child: new Container(
//                    padding: const EdgeInsets.only(right: 5),
                          child: widget.trailingWidget,
                        ),
                      ),
                    ],
                  )
                )
              ],
            )),
    );
  }
}
