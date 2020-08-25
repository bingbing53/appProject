import 'dart:async';
import 'dart:convert' as convert;
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:fluwx/fluwx.dart';
import 'package:helloworld/tviews/consumer/article/article_page.dart';
import 'package:helloworld/tviews/consumer/consumer_page_index.dart';
import 'package:helloworld/tviews/consumer/login/login_base_page.dart';
import 'package:helloworld/tviews/consumer/message/h_message_chat_page.dart';
import 'package:tobias/tobias.dart' as fluali;
import 'dart:io';
import 'package:amap_base_location/amap_base_location.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/data/api/apis.dart';
import 'package:helloworld/tviews/widget/widget_index.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'package:helloworld/utils/util_index.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

//webview_plugin 页面
class WebViewFlutterPage extends StatefulWidget{
  final String url;
  final bool showTitle,search;
  final List params;

  const WebViewFlutterPage({Key key, this.url,this.showTitle,this.search,this.params}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WebViewFlutterPageState();
  }
}

class IconModel{
  String name,icon;
  fluwx.WeChatScene code;
  IconModel(this.name,this.icon,this.code);
}

ShareModel shareModel;

class WebViewFlutterPageState extends State<WebViewFlutterPage>{

  List<IconModel> iconModels = [];

  WebViewController _webViewController;
  final searchController = TextEditingController();
  final FocusNode _commentFocus = FocusNode();

  MainBloc _mainBloc;

  String title = '';
  int subscribingId = -1;

  int sourceHeight = 0;

  WebViewFlutterPageState();

  get flutterWebViewPlugin => null;

  @override
  void dispose() {
    KeyboardVisibilityNotification().removeListener(subscribingId);
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
    _mainBloc = BlocProvider.of<MainBloc>(context);
    iconModels = [
      IconModel('微信','icon_wechat',fluwx.WeChatScene.SESSION),
      IconModel('朋友圈','icon_wechat_moments',fluwx.WeChatScene.TIMELINE)
    ];

    if(subscribingId == -1)
      subscribingId = KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) async {
        print(visible);
        if(visible) {

          String height1 = await _webViewController.evaluateJavascript("document.documentElement.scrollTop");
          String height2 = await _webViewController.evaluateJavascript("document.body.scrollTop");

          try {
            sourceHeight = int.parse(height1) + int.parse(height2);
          }catch(_){

          }
          _webViewController.evaluateJavascript(
              "document.documentElement.scrollTop = 10000");
          _webViewController.evaluateJavascript(
              "document.body.scrollTop = 10000");
        }else {
          _webViewController.evaluateJavascript(
              "document.documentElement.scrollTop = $sourceHeight");
          _webViewController.evaluateJavascript(
              "document.body.scrollTop = $sourceHeight");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var url = ShequejiaApi.formatH5Path(widget.url);
//    buildDynamicButton();
    print(url);
    return WillPopScope(
      onWillPop: requestPop,
      child: widget.showTitle ? Scaffold(
        appBar: AppBar(
          title: (widget.search == null || !widget.search) ? Text('$title'):
          Container(
            height: 52.0,
            child: new Padding(
                padding: const EdgeInsets.all(6.0),
                child: new Card(
                    child: new Container(
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(width: 5.0,),
                          Icon(Icons.search, color: Colors.grey,),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: TextField(
                                controller:searchController,
                                focusNode: _commentFocus,
                                decoration: new InputDecoration(
                                    contentPadding: EdgeInsets.only(top: 0.0),
                                    hintText: '请输入商家、服务',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none),
                                // onChanged: onSearchTextChanged,
                              ),
                            ),
                          ),
                          new IconButton(
                            icon: new Icon(Icons.cancel),
                            color: Colors.grey,
                            iconSize: 18.0,
                            onPressed: () {
                              searchController.clear();
                            },
                          ),
                        ],
                      ),
                    )
                )
            ),
          ),

          leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () async {
            bool back = await requestPop();
            if(back) Navigator.pop(context);
          }),
          flexibleSpace: Image(
            image: AssetImage(Utils.getImgPath('home_top')),
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
          actions: (widget.search == null || !widget.search) ? dynamicButton:[
            IconButton(icon: Icon(Icons.search), onPressed: (){
              _commentFocus.unfocus();
              _webViewController.evaluateJavascript("searchSuccess('${searchController.text}')");
            })
          ],
          bottom: PreferredSize(child: _progressBar(), preferredSize: Size.fromHeight(2.0)),
        ),
        body: WebView(
            initialUrl: url,//"https://mongo.qicaidonghu.cn/pic/flutter.html?version=12",
            initialMediaPlaybackPolicy:AutoMediaPlaybackPolicy.always_allow,
            onWebViewCreated: (WebViewController webViewController) {
              _webViewController = webViewController;
              _simulateProgress();
            },
            onPageFinished: (url) {
                isLoading = false;
                progress = 0;
                _getHtmlTitle();
                shareModel = null;
            },
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: <JavascriptChannel>[
              _alertJavascriptChannel(context),
              _choiseFileJavascriptChannel(context),
              _geoLocationJavascriptChannel(context),
              _loadingJavascriptChannel(context),
              _finiashLoadingJavascriptChannel(context),
              _shareJavascriptChannel(context),
              _payJavascriptChannel(context),
              _toolBarJavascriptChannel(context),
              _loginJavascriptChannel(context),
              _contactJavascriptChannel(context),
              _popPageJavascriptChannel(context),
              _jumpPageJavascriptChannel(context)
            ].toSet(),
            gestureRecognizers: Set()
            ..add(
                Factory<TapGestureRecognizer>(() => TapGestureRecognizer()
                  ..onTapDown = (tap) {
                    print("This one prints");
                  })
            )..add(Factory<LongPressGestureRecognizer>(() => LongPressGestureRecognizer()
                  ..onLongPress = (){
                    print("long press");
                  })
            ),
            navigationDelegate:(NavigationRequest request){
              bool flag = _requestNavigation(request);
              return flag ? NavigationDecision.navigate : NavigationDecision.prevent;
            }
        ),
      ):SafeArea(
          child: WebView(
              initialUrl: url,//"https://mongo.qicaidonghu.cn/pic/flutter.html?version=12",
              initialMediaPlaybackPolicy:AutoMediaPlaybackPolicy.always_allow,
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController = webViewController;
                print("onWebViewCreated");
              },
              onPageFinished: (url) {
                print(url);
              },
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: <JavascriptChannel>[
                _alertJavascriptChannel(context),
                _choiseFileJavascriptChannel(context),
                _geoLocationJavascriptChannel(context),
                _loadingJavascriptChannel(context),
                _finiashLoadingJavascriptChannel(context),
                _shareJavascriptChannel(context),
                _payJavascriptChannel(context),
                _toolBarJavascriptChannel(context),
                _loginJavascriptChannel(context),
                _contactJavascriptChannel(context),
                _popPageJavascriptChannel(context),
                _jumpPageJavascriptChannel(context)
              ].toSet(),
              navigationDelegate:(NavigationRequest request){
                bool flag = _requestNavigation(request);
                return flag ? NavigationDecision.navigate : NavigationDecision.prevent;
              }
          )
      )
    );
  }

  //地址拦截
  bool _requestNavigation(NavigationRequest request){
    if(request.url.startsWith('tel:')){
      //拨打手机号
      String mobile = request.url.substring(3);
      NavigatorUtil.diaMobile(mobile);
      return false;
    }else if(request.url.startsWith('email:')){
      //邮箱
      String email = '';
    }
    return true;
  }

  //按下了返回按钮
  Future<bool> requestPop() async {
    bool webCanGoBack = await _webViewController.canGoBack();
    if(webCanGoBack){
      _webViewController.goBack();
    }
    return !webCanGoBack;
  }

  void _getHtmlTitle(){
    if(_webViewController != null) {
      _webViewController.evaluateJavascript("document.title").then((result) {
        if (result == '"undefined"') return;
        setState(() {
          if (result.startsWith("\"") && result.endsWith("\"")) {
            title = result.substring(1, result.length - 1);
          }
        });
      });

      try{
        String token = SpUtil.getString('X-AUTH-TOKEN',defValue: '');
        String sysOrgCode = SpUtil.getString(SharedPreferencesKeys.sysOrgCode,defValue: '');
        _webViewController.evaluateJavascript("window.localStorage.setItem('token', '$token');window.localStorage.setItem('sysOrgCode', '$sysOrgCode');");
      }catch(err){

      }
    }
  }

  //***********************************展示顶部按钮**********************start
  Widget _shareWidget(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: MediaQuery.of(context).size.height / 4,
      child:Container(
//        padding: EdgeInsets.symmetric(vertical: 10.0),
        decoration: new BoxDecoration(
            color: Colours.gray_f0,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(Dimens.gap_dp15),
                topRight: const Radius.circular(Dimens.gap_dp15))),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding:EdgeInsets.symmetric(vertical: 20,horizontal: 10),
              child: Text('分享到',style: TextStyle(fontSize: Dimens.font_sp16),),
            ),
            Wrap(
              children: iconModels.map((value){
                  return GestureDetector(
                    child: Container(
                        padding: EdgeInsets.only(left: 20.0),
                        width: MediaQuery.of(context).size.width / 6,
                        child: Column(
                          children: <Widget>[
                            Image.asset(Utils.getImgPath(value.icon)),
                            SizedBox(height: 5),
                            Text(value.name,style: TextStyle(fontSize: Dimens.font_sp12),)
                          ],
                        )
                    ),
                    onTap: () async {
                      if(shareModel != null) {
                        var model = fluwx.WeChatShareWebPageModel(
                            webPage: shareModel.url,
                            title: shareModel.title,
                            thumbnail: shareModel.thumbnail,
                            scene: value.code,
                            transaction: "${shareModel.transaction.substring(0,
                                shareModel.transaction.length > 100 ? 100 : shareModel.transaction.length)}",
                            description: "${shareModel.description.substring(0, shareModel.description.length > 100 ? 100 : shareModel.description.length)}"
                        );
                        fluwx.share(model);
                      }
                    },
                  );
              }).toList(),
            ),
          ],
        ),
      )
    );
  }
  //***********************************展示顶部按钮**********************end
  //****************加载中******************************start
  bool isLoading = true; int progress = 0; Timer _timer;
  Widget _progressBar() {
    return SizedBox(
      height: isLoading ? 2 : 0,
      child: LinearProgressIndicator(
        value: isLoading ? progress / 100 : 1,
        backgroundColor: Color(0xfff3f3f3),
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
      ),
    );
  }
  /// 模拟异步加载
  Future _simulateProgress() async {
    if (_timer == null) {
      _timer = Timer.periodic(Duration(milliseconds: 50), (time) {
        _getHtmlTitle();
        progress++;
        if (progress > 98) {
          _timer.cancel();
          _timer = null;
          return;
        } else {
          setState(() {});
        }
      });
    }
  }
  //****************加载中******************************end
  //控制顶部按钮
  List<Widget> dynamicButton = [];
  buildDynamicButton(){
    dynamicButton = [
      IconButton(icon: Icon(Icons.more_horiz), onPressed: () {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
      return _shareWidget(context);
      }
    );
    })
    ];
  }
  JavascriptChannel _toolBarJavascriptChannel(BuildContext context){
    return JavascriptChannel(
        name: 'toolBar',
        onMessageReceived: (JavascriptMessage message) async {
          var result = convert.jsonDecode(message.message);
          if(result != null && result.length > 0){
            dynamicButton = [];
              for(var i = 0;i<result.length;i++){
                  if(result[i]['text'] != null && result[i]['text'].length > 0){
                    dynamicButton.add(
                        OutlineButton(
                            child: Text(result[i]['text'],style: TextStyle(color: Colors.white,fontSize: Dimens.font_sp16)),
                            borderSide:new BorderSide(color: Colors.transparent),
                            onPressed: (){
                              NavigatorUtil.pushPage(context, WebViewFlutterPage(url:result[i]['url'],showTitle: true),pageName: '随手拍表单');
                            }
                        )
                    );
                  }else if(result[i]['icon'] != null && result[i]['icon'].length > 0){
                    dynamicButton.add(
                      IconButton(icon: Icon(IconData(int.parse(result[i]['icon']), fontFamily: 'MaterialIcons')), onPressed: (){
                        return NavigatorUtil.pushPage(context, WebViewFlutterPage(url:result[i]['url'],showTitle: true),pageName: 'url');
                      })
                    );
                  }
              }
              setState((){
              });
          }
        });
  }
  //返回页面
  JavascriptChannel _popPageJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'navigatorpop',
        onMessageReceived: (JavascriptMessage message) {
          var msg = message.message??'0';
          Navigator.pop(context,int.parse(msg));
        }
    );
  }
  //跳转原生页面
  JavascriptChannel _jumpPageJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'jumpAppPage',
        onMessageReceived: (JavascriptMessage message) {
          print(message.message);
          var msg = convert.jsonDecode(message.message);
          if(msg["page"] == 'articleHome'){
            Map<String, dynamic> param = new Map();
            param['sysOrgCode'] = msg['sysOrgCode'];
            Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new Scaffold(
                    appBar: AppBar(
                      title: Text('主页'),
                      flexibleSpace: Image(
                        image: AssetImage(Utils.getImgPath('home_top')),
                        fit: BoxFit.cover,
                      ),
                      backgroundColor: Colors.transparent,
                    ),
                    body: new ArticleListPage('-999',param: param,showHeader: '1',headerItem: param)),
                )
            );
          }else if(msg['url'] != null && msg['url'].length > 0){
              NavigatorUtil.pushPage(context,WebViewFlutterPage(url:msg['url'],showTitle: true),pageName: '跳转网页');
          }
        }
    );
  }
  //跳转APP登录页面
  JavascriptChannel _loginJavascriptChannel(BuildContext context){
    return JavascriptChannel(
        name: 'login',
        onMessageReceived: (JavascriptMessage message) async {
          var result = 0;
          var msg = message.message;
          if(msg == 'login'){
            //基础登录
            result = await NavigatorUtil.pushPageAsync(context,LoginPage());
          }else if(msg == 'login2'){
            //个人信息
            result = await NavigatorUtil.pushPageAsync(context, WebViewFlutterPage(url:'/#/certificate/cert1',showTitle: true));
          }else if(msg == 'login21'){
            //绑定物业信息
            result = await NavigatorUtil.pushPageAsync(context, WebViewFlutterPage(url:'/#/estate/bindEstate/',showTitle: true));
          }else if(msg.startsWith('welfare-')){
            String code = msg.split('-')[1];
            result = await NavigatorUtil.pushPageAsync(context, WebViewFlutterPage(url:'/#/certificate/welfare?code=$code',showTitle: true));
          }else if(msg == 'login3'){
            //第三级认证
          }

          if(result == 1){
            try{
              String token = SpUtil.getString('X-AUTH-TOKEN',defValue: '');
              String sysOrgCode = SpUtil.getString(SharedPreferencesKeys.sysOrgCode,defValue: '');
              _webViewController.evaluateJavascript("window.localStorage.setItem('token', '$token');window.localStorage.setItem('sysOrgCode', '$sysOrgCode');");
            }catch(err){
            }

            Future.delayed(Duration(milliseconds: 500), (){
              _webViewController.reload();
            });
          }
        }
    );
  }

  //跳转聊天
  JavascriptChannel _contactJavascriptChannel(BuildContext context){
    return JavascriptChannel(
        name: 'contact',
        onMessageReceived: (JavascriptMessage message) async {
          var result = convert.jsonDecode(message.message);
          var username = result['username'];
          var app = result['app'];
          String appKey = "";
          if(app == 'estate'){
            appKey = estateAppkey;
          }else if(app == 'office'){
            appKey = officeAppkey;
          }else{
            appKey = kMockAppkey;
          }
          _mainBloc.createConversation(username,appKey:appKey).then((model){
            _mainBloc.enterConversation(model);
            _mainBloc.getHistoryMessages(model);
            NavigatorUtil.pushPage(context, MessageChatPage(model:model,labelId: Ids.titleChatMessage,),pageName:'测试');
          }).catchError((_){

          });
        }
    );
  }
  //微信支付宝支付
  JavascriptChannel _payJavascriptChannel(BuildContext context){
    return JavascriptChannel(
        name: 'pay',
        onMessageReceived: (JavascriptMessage message) async {
          var result = convert.jsonDecode(message.message);

          print('#############$result');

          var orderId = result['orderId'];
          if(result['payment'] == 'alipay'){
            bool installed = await fluali.isAliPayInstalled();
            if(installed){
              _mainBloc.aliOrderPay(orderId).then((payInfo){
                print(payInfo);
                fluali.aliPay(payInfo).then((v){
                  print(v);
                  Fluttertoast.showToast(msg: '调用支付成功：$v');
                }).catchError((err){
                  print(err);
                  Fluttertoast.showToast(msg: '调用支付失败：$err');
                });
              }).catchError((err){
                  Fluttertoast.showToast(msg: '获取支付接口失败：$err');
              });
            }else{
              Fluttertoast.showToast(msg: '您未安装支付宝，请安装后重试！');
            }
          }else if(result['payment'] == 'wxpay'){
            _mainBloc.wechatOrderPay(orderId).then((wxPayInfo){

                fluwx.pay(
                  appId: wxPayInfo.appid,
                  partnerId: wxPayInfo.partnerid,
                  prepayId: wxPayInfo.prepayId,
                  packageValue: wxPayInfo.package,
                  nonceStr: wxPayInfo.nonceStr,
                  timeStamp: wxPayInfo.time,
                  sign: wxPayInfo.sign,
                ) .then((data) {
                  print('success #### $data');
                  _webViewController.evaluateJavascript("paySuccess('${convert.jsonEncode(data)}')");
                }).catchError((e){
                  print('err #### $e');
                  _webViewController.evaluateJavascript("payError('支付失败')");
                });
            }).catchError((err){

            });
          }
        });
  }
  //分享设置
  JavascriptChannel _shareJavascriptChannel(BuildContext context){
    return JavascriptChannel(
        name: 'share',
        onMessageReceived: (JavascriptMessage message) async {
            var result = convert.jsonDecode(message.message);

            String picture = result['picture']??'https://image.shequyijia.cn/pic/notification/shequyijia/ic_launcher.png';
            String title = result['title']??'社区e家';
            String des = result['des']??'社区e家';

            if(des.length > 200){
              des.substring(0,200);
            }
            var model = fluwx.WeChatShareWebPageModel(
                webPage: ShequejiaApi.formatH5Path('/#/download/'),
                title: title,
                thumbnail: picture,
                scene: WeChatScene.SESSION,
                transaction: "社区e家",
                description: des
            );
            fluwx.share(model);
        });
  }
  //加载中
  JavascriptChannel _loadingJavascriptChannel(BuildContext context){
    return JavascriptChannel(
        name: 'loading',
        onMessageReceived: (JavascriptMessage message) async {
          Loading.show(text: message.message??'加载中');
        });
  }
  //停止加载
  JavascriptChannel _finiashLoadingJavascriptChannel(BuildContext context){
    return JavascriptChannel(
        name: 'closeLoading',
        onMessageReceived: (JavascriptMessage message) async {
          Loading.close();
        });
  }
  //获取地理位置信息
  final _amapLocation = AMapLocation();
  List<Location> _result = [];
  JavascriptChannel _geoLocationJavascriptChannel(BuildContext context){
    return JavascriptChannel(
        name: 'geoLocation',
        onMessageReceived: (JavascriptMessage message) async {
          // 申请结果
//          PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
//          if (permission == PermissionStatus.granted) {
            _amapLocation.init();
            final options = LocationClientOptions(
              isOnceLocation: true,
              locatingWithReGeocode: true,
            );
            _amapLocation.startLocate(options).map(_result.add).listen((_){
              if(_result.length > 0){
                Location location = _result[0];
                _webViewController.evaluateJavascript("geoLocationSuccess('${convert.jsonEncode(location)}')");
              }
            });
//          } else {
//            _webViewController.evaluateJavascript('geoLocationError("用户未授权")');
//          }

        });
  }
  //弹出提示内容
  JavascriptChannel _alertJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'toast',
        onMessageReceived: (JavascriptMessage message) async {
          Fluttertoast.showToast(msg: message.message);
        });
  }
  //选择文件
  JavascriptChannel _choiseFileJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'chooseImage',
        onMessageReceived: (JavascriptMessage message) async {
          var data = convert.jsonDecode(message.message);
          if(ObjectUtil.isEmpty(data['source']) || data['source'] == 'gallery'){
            List<String> images = await _pickAsset(PickType.onlyImage);

            _webViewController.evaluateJavascript('choiseImageSuccess("data:image/jpeg;base64,'+images[0]+'")');
          }else if(data['source'] == 'camera'){
            ImagePicker.pickImage(source: ImageSource.camera).then((file) async{

            File compressedFile = await FlutterNativeImage.compressImage(file.path, quality: 70, percentage: 60);

              List<int> imageBytes = await compressedFile.readAsBytes();
              _webViewController.evaluateJavascript('choiseImageSuccess("data:image/jpeg;base64,'+base64Encode(imageBytes)+'")');
            }).catchError((_){
              _webViewController.evaluateJavascript('choiseImageError("'+_.toString()+'")');
            });
          }
        });
  }

//  //身份证拍照
//  JavascriptChannel _uploadIDCardJavascriptChannel(BuildContext context){
//    return JavascriptChannel(
//        name:'uploadIDCard',
////        onMessageReceived:(JavascriptMessage message) async{
////          flutterWebViewPlugin.hide();
////          List<CameraDescription> cameras;
////          String result = await NavigatorUtil.pushPageAsync(context, (cameras));
////          _webViewController.evaluateJavascript('uploadIDCardSuccess("data:imaguploadIDCarde/jpeg;base64,'+result+'")');
////        });
//        onMessageReceived: (JavascriptMessage message) async {
//          var data = convert.jsonDecode(message.message);
//          if(ObjectUtil.isEmpty(data['source']) || data['source'] == 'camera'){
//            List<String> images = await _pickAsset(PickType.onlyImage);
//
//            _webViewController.evaluateJavascript('uploadIDCardSuccess("data:image/jpeg;base64,'+images[0]+'")');
//          }else if(data['source'] == 'gallery'){
//            ImagePicker.pickImage(source: ImageSource.camera).then((file) async{
//
//              File compressedFile = await FlutterNativeImage.compressImage(file.path, quality: 70, percentage: 60);
//
//              List<int> imageBytes = await compressedFile.readAsBytes();
//              _webViewController.evaluateJavascript('uploadIDCardSuccess("data:image/jpeg;base64,'+base64Encode(imageBytes)+'")');
//            }).catchError((_){
//              _webViewController.evaluateJavascript('uploadIDCardError("'+_.toString()+'")');
//            });
//          }
//        });
//  }


  Future<List<String>> _pickAsset(PickType type, {List<AssetPathEntity> pathList}) async {
    List<AssetEntity> imgList = await PhotoPicker.pickAsset(
      // BuildContext required
      context: context,

      /// The following are optional parameters.
      themeColor: Colours.app_main,
      // the title color and bottom color

      textColor: Colors.white,
      // text color
      padding: 1.0,
      // item padding
      dividerColor: Colours.divider,
      // divider color
      disableColor: Colors.grey.shade300,
      // the check box disable color
      itemRadio: 0.88,
      // the content item radio
      maxSelected: 1,
      // max picker image count
      // provider: I18nProvider.english,
      provider: I18nProvider.chinese,
      // i18n provider ,default is chinese. , you can custom I18nProvider or use ENProvider()
      rowCount: 3,
      // item row count

      thumbSize: 150,
      // preview thumb size , default is 64
      sortDelegate: SortDelegate.common,
      // default is common ,or you make custom delegate to sort your gallery
      checkBoxBuilderDelegate: DefaultCheckBoxBuilderDelegate(
        activeColor: Colors.white,
        unselectedColor: Colors.white,
        checkColor: Colours.app_main,
      ),
      // default is DefaultCheckBoxBuilderDelegate ,or you make custom delegate to create checkbox

//      loadingDelegate: this,
      // if you want to build custom loading widget,extends LoadingDelegate, [see example/lib/main.dart]

      badgeDelegate: const DurationBadgeDelegate(),
      // badgeDelegate to show badge widget

      pickType: type,

      photoPathList: pathList,
    );

    if (imgList == null) {

    } else {
      List<String> r = [];
      for (var e in imgList) {
        var file = await e.file;

        File compressedFile = await FlutterNativeImage.compressImage(file.path, quality: 70, percentage: 60);

        List<int> imageBytes = await compressedFile.readAsBytes();
        r.add(base64Encode(imageBytes));
      }
      return r;
    }
    setState(() {});
  }

}

class ShareModel{
  String title;
  String url;
  String thumbnail;
  String scence;
  String transaction;
  String description;

  ShareModel.toJson(Map<String,dynamic> json)
    : title = json['title'],
      url = json['url'],
      thumbnail = json['thumbnail'],
      scence = json['scence'],
      transaction = json['transaction'],
      description = json['description'];

}
