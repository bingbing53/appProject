import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/ui/pages/page_index.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
class WebScaffold extends StatefulWidget {
  const WebScaffold({
    Key key,
    this.title,
    this.titleId,
    this.url,
    this.refreshCache
  }) : super(key: key);

  final String title;
  final String titleId;
  final String url;
  final bool refreshCache;

  @override
  State<StatefulWidget> createState() {
    return new WebScaffoldState();
  }
}

class WebScaffoldState extends State<WebScaffold> {

  FlutterWebviewPlugin flutterWebViewPlugin = FlutterWebviewPlugin();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool isLoading = false,canClose = true;
  int progress = 0;
  Timer _timer;

  String title;

  String token = '';

  @override
  void initState() {
    super.initState();

    _simulateProgress();

    title = widget.title;
    token = SpUtil.getString(Constant.key_token_name,defValue: '');
    _addListener();
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


          NavigatorUtil.webUrlChangeJump(context,viewState.url,flutterWebViewPlugin);
          flutterWebViewPlugin.evalJavascript('token("$token")');
          flutterWebViewPlugin.evalJavascript('window.localStorage.setItem("token_message", "$token")');
          break;
        case WebViewState.startLoad:
          // 开始加载
          print('开始加载');
          flutterWebViewPlugin.evalJavascript('token("$token")');
          flutterWebViewPlugin.evalJavascript('window.localStorage.setItem("token_message", "$token")');
          setState(() {
            isLoading = true;
          });
          break;
        case WebViewState.finishLoad:
          //加载完成
          print('加载完成');
          flutterWebViewPlugin.evalJavascript('token("$token")');
          flutterWebViewPlugin.evalJavascript('window.localStorage.setItem("token_message", "$token")');
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
        if(!ObjectUtil.isEmpty(result) && result.length > 0) {
          if(result.startsWith("'") || result.startsWith('"')) {
            title = result.substring(1, result.length - 1);
          }else{
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

  Future<bool> _requestBack(){
      flutterWebViewPlugin.hide();
      flutterWebViewPlugin.dispose();
      Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> titleContent = [];
    titleContent.add(Text(
      widget.title,
      style: TextStyle(color: Colors.white),
    ));
    return WebviewScaffold(
          key: _scaffoldKey,
          url: widget.url,
          // 登录的URL
          appBar: AppBar(
            bottom: PreferredSize(
              child: _progressBar(),
              preferredSize: Size.fromHeight(2.0),
            ),
            leading:Container(
              child: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.close), onPressed: (){
                    _requestBack();
                  }),
                ],
              ),
            ),
            title: new Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          withZoom: false,
          // 允许网页缩放
          withLocalStorage: true,
          // 允许LocalStorage
          withJavascript: true,
          // 允许执行js代码
          resizeToAvoidBottomInset: true,
          scrollBar:false,
          clearCache: true,
          bottomNavigationBar: Theme.of(context).platform == TargetPlatform.iOS ? Row(
            children: <Widget>[
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios,color: Colors.grey,),
                  onPressed: (){
                    flutterWebViewPlugin.evalJavascript("history.go(-1);").then((result){
                    });
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios,color: Colors.grey,),
                  onPressed: (){
                    flutterWebViewPlugin.evalJavascript("window.history.go(1);");
                  },
                ),
              ),
            ],
          ):Container(height: 0,)
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
