import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:fluwx/fluwx.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/data/api/apis.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/consumer/article/article_page.dart';
import 'package:helloworld/tviews/consumer/article/video_page.dart';
import 'package:helloworld/tviews/consumer/message/h_message_chat_page.dart';
import 'package:helloworld/tviews/widget/reverseIDCard.dart';
import 'package:helloworld/tviews/widget/uploadidcard.dart';
import 'package:helloworld/tviews/widget/IdentifyFace.dart';
import 'package:helloworld/tviews/widget/web_scaffold.dart';

import 'package:helloworld/utils/util_index.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tobias/tobias.dart' as fluali;
import 'package:amap_base_location/amap_base_location.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:helloworld/tviews/consumer/login/login_base_page.dart';
import 'package:helloworld/tviews/webview/webview_flutter.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'package:helloworld/utils/shared_preferences_keys.dart';
import 'package:camera/camera.dart';
import 'IdentifyFace.dart';
//import 'facedIstinguish.dart';
import 'uploadidcard.dart';
import 'widget_index.dart';

class Channels {
  static FlutterWebviewPlugin flutterWebViewPlugin;
  static MainBloc mainBloc;
  static BuildContext context;
  static BuildContext _context;


  static Set<JavascriptChannel> getChannels(){
    try{
      String token = SpUtil.getString('X-AUTH-TOKEN',defValue: '');
      String sysOrgCode = SpUtil.getString(SharedPreferencesKeys.sysOrgCode,defValue: '');
      flutterWebViewPlugin.evalJavascript("window.localStorage.setItem('token', '$token');window.localStorage.setItem('sysOrgCode', '$sysOrgCode');");
    }catch(err){

    }

    Set<JavascriptChannel> set = new Set();
    set.add(_alertJavascriptChannel(context));
    set.add(_choiseFileJavascriptChannel(context));
    //上传身份证正面
    set.add(_uploadJavascriptChannel(context));
    //人脸识别
   // set.add(_IdentifyFaceJavascriptChannel(context));
    //上传身份证反面
    //set.add(_reverseIDCardJavascriptChannel(context));
    set.add(_loadingJavascriptChannel(context));
    set.add(_finiashLoadingJavascriptChannel(context));
    set.add(_shareJavascriptChannel(context));
    set.add(_payJavascriptChannel(context));
    set.add(_toolBarJavascriptChannel(context));
    set.add(_loginJavascriptChannel(context));
    set.add(_contactJavascriptChannel(context));
    set.add(_popPageJavascriptChannel(context));
    set.add(_jumpPageJavascriptChannel(context));
    set.add(_goBackJavascriptChannel(context));
    set.add(_scanQRCodeJavascriptChannel(context));
    set.add(_diaMobileJavascriptChannel(context));
    set.add(_choiseMultiImageJavascriptChannel(context));

    _context = context;

    return set;
  }

  //打电话
  static JavascriptChannel _diaMobileJavascriptChannel(BuildContext context){
    return JavascriptChannel(
        name: 'diaMobile',
        onMessageReceived: (JavascriptMessage message) async {
          var result = '${convert.jsonDecode(message.message)}';
          if(result != null && result.length > 0){
            NavigatorUtil.diaMobile(result);
          }
        }
    );
  }

  //扫码
  static JavascriptChannel _scanQRCodeJavascriptChannel(BuildContext context){
    return JavascriptChannel(
        name: 'scanQRCode',
        onMessageReceived: (JavascriptMessage message) async {
          flutterWebViewPlugin.hide();
          BarcodeScanner.scan().then((value){
            flutterWebViewPlugin.evalJavascript('scanSuccess("'+value+'")');
            flutterWebViewPlugin.show();
          }).catchError((err){
            flutterWebViewPlugin.evalJavascript('scanError("'+err.toString()+'")');
            flutterWebViewPlugin.show();
          });
        }
    );
  }

  //返回页面
  static JavascriptChannel _goBackJavascriptChannel(BuildContext context){
    return JavascriptChannel(
        name: 'goBack',
        onMessageReceived: (JavascriptMessage message) async {
          bool canGoBack = await flutterWebViewPlugin.canGoBack();
          if(canGoBack){
            await flutterWebViewPlugin.goBack();
            String backUrl = await flutterWebViewPlugin.evalJavascript("location.href");
            if(backUrl.contains("forceClose")) {
              flutterWebViewPlugin.close();
              flutterWebViewPlugin.dispose();
              flutterWebViewPlugin = null;
              Navigator.pop(context);
            }else{
              flutterWebViewPlugin.evalJavascript('reload()');
            }
          }else{
            flutterWebViewPlugin.close();
            flutterWebViewPlugin.dispose();
            flutterWebViewPlugin = null;
            Navigator.pop(context);
          }
        }
     );
  }

  static JavascriptChannel _toolBarJavascriptChannel(BuildContext context){
    return JavascriptChannel(
        name: 'toolBar',
        onMessageReceived: (JavascriptMessage message) async {
          var result = convert.jsonDecode(message.message);
          if(result != null && result.length > 0){
//            dynamicButton = [];
//            for(var i = 0;i<result.length;i++){
//              if(result[i]['text'] != null && result[i]['text'].length > 0){
//                dynamicButton.add(
//                    OutlineButton(
//                        child: Text(result[i]['text'],style: TextStyle(color: Colors.white,fontSize: Dimens.font_sp16)),
//                        borderSide:new BorderSide(color: Colors.transparent),
//                        onPressed: (){
//                          NavigatorUtil.pushPage(context, WebViewFlutterPage(url:result[i]['url'],showTitle: true),pageName: '随手拍表单');
//                        }
//                    )
//                );
//              }else if(result[i]['icon'] != null && result[i]['icon'].length > 0){
//                dynamicButton.add(
//                    IconButton(icon: Icon(IconData(int.parse(result[i]['icon']), fontFamily: 'MaterialIcons')), onPressed: (){
//                      return NavigatorUtil.pushPage(context, WebViewFlutterPage(url:result[i]['url'],showTitle: true),pageName: 'url');
//                    })
//                );
//              }
//            }
          }
        });
  }
  //返回页面
  static JavascriptChannel _popPageJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'navigatorpop',
        onMessageReceived: (JavascriptMessage message) {
          var msg = message.message??'0';
          if(msg == '1'){
            Navigator.pop(context,int.parse(msg));
          }
          Navigator.pop(context,int.parse(msg));
        }
    );
  }
  //选择文件
  static JavascriptChannel _choiseFileJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'chooseImage',
        onMessageReceived: (JavascriptMessage message) async {
          var data = convert.jsonDecode(message.message);
          print(data);
          if(ObjectUtil.isEmpty(data['source']) || data['source'] == 'gallery'){
            flutterWebViewPlugin.hide();
            List<String> images = await _pickAsset(PickType.onlyImage);
            flutterWebViewPlugin.show();

            flutterWebViewPlugin.evalJavascript('choiseImageSuccess("data:image/jpeg;base64,'+images[0]+'")');
          }else if(data['source'] == 'camera'){
            flutterWebViewPlugin.hide();
            ImagePicker.pickImage(source: ImageSource.camera).then((file) async{
              flutterWebViewPlugin.show();
              File compressedFile = await FlutterNativeImage.compressImage(file.path, quality: 70, percentage: 60);

              List<int> imageBytes = await compressedFile.readAsBytes();
              flutterWebViewPlugin.evalJavascript('choiseImageSuccess("data:image/jpeg;base64,'+base64Encode(imageBytes)+'")');
            }).catchError((_){
              flutterWebViewPlugin.show();
              flutterWebViewPlugin.evalJavascript('choiseImageError("'+_.toString()+'")');
            });
          }
        });
  }

  //上传人脸信息
//  static JavascriptChannel _IdentifyFaceJavascriptChannel(BuildContext context){
//    return JavascriptChannel(
//        name:'IdentifyFace',
//        onMessageReceived: (JavascriptMessage message) async {
//          var data = convert.jsonDecode(message.message);
//          print(data);
//          flutterWebViewPlugin.hide();
//          String result = await NavigatorUtil.pushPageAsync(context, IdentifyFace());
//          flutterWebViewPlugin.show();
//          flutterWebViewPlugin.evalJavascript('uploadIDCardSuccess("data:image/jpeg;base64,'+result+'")');
//        }
//    );
//  }

  //上传身份证
  static JavascriptChannel _uploadJavascriptChannel(BuildContext context){
    return JavascriptChannel(
        name:'uploadIDCard',
        onMessageReceived: (JavascriptMessage message) async {
          var data = convert.jsonDecode(message.message);
          print(message.message);
          flutterWebViewPlugin.hide();
          String result = await NavigatorUtil.pushPageAsync(context, uploadIDCard(type:data['source']));
          flutterWebViewPlugin.show();
          if(result != '-1') {
            flutterWebViewPlugin.evalJavascript(
                'uploadIDCardSuccess("data:image/jpeg;base64,' + result + '")');
          }
        });
  }

  //跳转原生页面
  static JavascriptChannel _jumpPageJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'jumpAppPage',
        onMessageReceived: (JavascriptMessage message) async {
          print('jmpApp'+message.message);
          var msg = convert.jsonDecode(message.message);

          if(msg["page"] == 'articleHome'){
            Map<String, dynamic> param = new Map();
            param['sysOrgCode'] = msg['sysOrgCode'];
            flutterWebViewPlugin.hide();
            final result = await Navigator.pushReplacement(
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
            flutterWebViewPlugin.show();
          }else if(msg["page"] == 'videoPage'){
            //视频页面
            String id = msg['id'];
            String images = msg['images'];
            NavigatorUtil.pushReplacePage(context, VideoDetailPage(id,images),pageName: '视频详情');

          }else if(msg['url'] != null && msg['url'].length > 0){
            NavigatorUtil.pushReplacePage(context,WebViewFlutterPage(url:msg['url'],showTitle: false),pageName: '跳转网页');
          }
        }
    );
  }
  //跳转APP登录页面
  static JavascriptChannel _loginJavascriptChannel(BuildContext context){
    return JavascriptChannel(
        name: 'login',
        onMessageReceived: (JavascriptMessage message) async {
          var result = 0;
          var msg = message.message;
          if(msg == 'login'){
            //基础登录
            flutterWebViewPlugin.hide();
            result = await NavigatorUtil.pushPageAsync(context,LoginPage());
            flutterWebViewPlugin.show();

            if(result == 1) {
              try {
                String token = SpUtil.getString('X-AUTH-TOKEN', defValue: '');
                String sysOrgCode = SpUtil.getString(
                    SharedPreferencesKeys.sysOrgCode, defValue: '');
                flutterWebViewPlugin.evalJavascript(
                    "window.localStorage.setItem('token', '$token');window.localStorage.setItem('sysOrgCode', '$sysOrgCode');");
              } catch (err) {
                print(err);
              }
              Future.delayed(Duration(milliseconds: 500), () {
                flutterWebViewPlugin.reload();
              });
            }
          }else{
            flutterWebViewPlugin.hide();

            showDialog(context: context,
                barrierDismissible: false,
                builder: (BuildContext context2) {
                  return CupertinoAlertDialog(
                    title: Text("认证提示"),
                    content: Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text("您还未填写系统认证信息，是否开始认证？",style: TextStyle(fontSize: Dimens.font_sp14),),
                    ),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text("稍后"),
                        onPressed: () {
                          flutterWebViewPlugin.show();
                          Navigator.pop(context2);
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text("确定"),
                        onPressed: () async {

                          flutterWebViewPlugin.show();
                          Navigator.of(context2).pop();
                          if(msg == 'login1'){

                            result = await NavigatorUtil.pushPageAsync(context, WebScaffold(url:'/#/certificate/cert1/',title: '一级认证'));
                            if(result == null) Navigator.pop(context);
                          }else if(msg == 'login2'){
                            //个人信息
                            result = await NavigatorUtil.pushPageAsync(context, WebScaffold(url:'/#/estate/bindEstate/',title: '二级认证'));
                            if(result == null) Navigator.pop(context);
                          }else if(msg == 'login21'){
                            //绑定物业信息
                            result = await NavigatorUtil.pushPageAsync(context, WebScaffold(url:'/#/estate/bindEstate/',title: '二级认证'));
                            print('返回：$result');
                            if(result == null) Navigator.pop(context);
                          }else if(msg.startsWith('welfare-')){
                            String code = msg.split('-')[1];
                            result = await NavigatorUtil.pushPageAsync(context, WebScaffold(url:'/#/certificate/welfare?code=$code',title: '加入志愿者'));
                            if(result == null) Navigator.pop(context);
                          }else if(msg == 'login3'){
                            //第三级认证
                            result = await NavigatorUtil.pushPageAsync(context, WebScaffold(url:'/#/estate/bindEstate/?type=cert3',title: '三级认证'));
                            if(result == null) Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  );
                }
            );
            return;

            showDialog<void>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (_) => new AlertDialog(
                    title: new Text("提示信息"),
                    content: new Text("您还未填写系统认证信息，是否开始认证？"),
                    actions:<Widget>[
                      new FlatButton(child:new Text("稍后",style: TextStyle(color: Colors.grey),), onPressed: (){
                        flutterWebViewPlugin.show();
                        Navigator.of(context).pop();
                      },),
                      new FlatButton(child:new Text("确定"),
                        onPressed: () async {
                          flutterWebViewPlugin.show();
                          Navigator.of(context).pop();
                          if(msg == 'login1'){

                            result = await NavigatorUtil.pushPageAsync(context, WebScaffold(url:'/#/certificate/cert1/',title: '一级认证'));
                            if(result == null) Navigator.pop(context);
                          }else if(msg == 'login2'){
                            //个人信息
                            result = await NavigatorUtil.pushPageAsync(context, WebScaffold(url:'/#/estate/bindEstate/',title: '二级认证'));
                            if(result == null) Navigator.pop(context);
                          }else if(msg == 'login21'){
                            //绑定物业信息
                            result = await NavigatorUtil.pushPageAsync(context, WebScaffold(url:'/#/estate/bindEstate/',title: '二级认证'));
                            print('返回：$result');
                            if(result == null) Navigator.pop(context);
                          }else if(msg.startsWith('welfare-')){
                            String code = msg.split('-')[1];
                            result = await NavigatorUtil.pushPageAsync(context, WebScaffold(url:'/#/certificate/welfare?code=$code',title: '加入志愿者'));
                            if(result == null) Navigator.pop(context);
                          }else if(msg == 'login3'){
                            //第三级认证
                            result = await NavigatorUtil.pushPageAsync(context, WebScaffold(url:'/#/estate/bindEstate/?type=cert3',title: '三级认证'));
                            if(result == null) Navigator.pop(context);
                          }
                        },)
                    ]
                ));
          }
        }
    );
  }

  //跳转聊天
  static JavascriptChannel _contactJavascriptChannel(BuildContext context){
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
          mainBloc.createConversation(username,appKey:appKey).then((model) async {
            mainBloc.enterConversation(model);
            mainBloc.getHistoryMessages(model);
            flutterWebViewPlugin.hide();
            var result = await NavigatorUtil.pushPageAsync(context, MessageChatPage(model:model,labelId: Ids.titleChatMessage,));
            flutterWebViewPlugin.show();
          }).catchError((_){

          });
        }
    );
  }
  //微信支付宝支付
  static JavascriptChannel _payJavascriptChannel(BuildContext context){
    return JavascriptChannel(
        name: 'pay',
        onMessageReceived: (JavascriptMessage message) async {
          var result = convert.jsonDecode(message.message);

          print('#############$result');

          var orderId = result['orderId'];
          if(result['payment'] == 'alipay'){
            bool installed = await fluali.isAliPayInstalled();
            if(installed){
              mainBloc.aliOrderPay(orderId).then((payInfo){
                print(payInfo);
                fluali.aliPay(payInfo).then((v){
                  print(v);
//                  Fluttertoast.showToast(msg: '调用支付成功：$v');
                }).catchError((err){
                  print(err);
//                  Fluttertoast.showToast(msg: '调用支付失败：$err');
                });
              }).catchError((err){
//                Fluttertoast.showToast(msg: '获取支付接口失败：$err');
              });
            }else{
              Fluttertoast.showToast(msg: '您未安装支付宝，请安装后重试！');
            }
          }else if(result['payment'] == 'wxpay'){
            mainBloc.wechatOrderPay(orderId).then((wxPayInfo){
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
                flutterWebViewPlugin.evalJavascript("paySuccess('${convert.jsonEncode(data)}')");
              }).catchError((e){
                print('err #### $e');
                flutterWebViewPlugin.evalJavascript("payError('支付失败')");
              });
            }).catchError((err){

            });
          }
        });
  }
  //分享设置
  static JavascriptChannel _shareJavascriptChannel(BuildContext context){
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
  static JavascriptChannel _loadingJavascriptChannel(BuildContext context){
    return JavascriptChannel(
        name: 'loading',
        onMessageReceived: (JavascriptMessage message) async {
          flutterWebViewPlugin.hide();
          Loading.show(text: message.message??'加载中');
        });
  }
  //停止加载
  static JavascriptChannel _finiashLoadingJavascriptChannel(BuildContext context){
    return JavascriptChannel(
        name: 'closeLoading',
        onMessageReceived: (JavascriptMessage message) async {
          Loading.close();
          flutterWebViewPlugin.show();
        });
  }
  //获取地理位置信息
  static final _amapLocation = AMapLocation();
  static List<Location> _result = [];
  static JavascriptChannel _geoLocationJavascriptChannel(BuildContext context){
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
              flutterWebViewPlugin.evalJavascript("geoLocationSuccess('${convert.jsonEncode(location)}')");
            }
          });
//          } else {
//            flutterWebViewPlugin.evalJavascript('geoLocationError("用户未授权")');
//          }

        });
  }
  //弹出提示内容
  static JavascriptChannel _alertJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'toast',
        onMessageReceived: (JavascriptMessage message) async {
          Fluttertoast.showToast(msg: message.message);
        });
  }
  

  //多选照片
  static JavascriptChannel _choiseMultiImageJavascriptChannel(BuildContext context){
    return JavascriptChannel(
        name: 'choiseMultiImage',
        onMessageReceived: (JavascriptMessage message) async {
            var data = convert.jsonDecode(message.message);
            var maxSelected = data['maxSelected'] ?? 1;
            flutterWebViewPlugin.hide();
            List<String> images = await _pickAsset(PickType.onlyImage,maxSelected: maxSelected);
            flutterWebViewPlugin.show();

            List<String> imageArr = [];
            print('${imageArr.length}');
            if(images.length > 0){
              for(int i = 0;i<images.length;i++){
                imageArr.add("data:image/jpeg;base64,${images[i]}");
              }
            }
            var result = '${json.encode(imageArr)}';
            flutterWebViewPlugin.evalJavascript("choiseMultiImageSuccess('${result}')");
        });
  }

  static Future<List<String>> _pickAsset(PickType type, {List<AssetPathEntity> pathList,int maxSelected = 1}) async {
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
      maxSelected: maxSelected,
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
  }

}