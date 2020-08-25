/*
 * Created by wzy on 2019/3/12.
 */

import 'dart:async';
import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:device_info/device_info.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/common/style.dart';
import 'package:helloworld/data/net/dio_util.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/consumer/login/register_page.dart';
import 'package:helloworld/tviews/webview/webview_flutter.dart';
import 'package:helloworld/tviews/widget/simple_dialog.dart';
import 'package:helloworld/tviews/widget/widget_index.dart';
import 'package:helloworld/utils/base_utils.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:helloworld/utils/navigator_util.dart';
import 'package:helloworld/utils/util_index.dart';
import 'package:tobias/tobias.dart' as tobias;

import 'bind_mobile_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}
/// 用户协议中“低调”文本的样式。
final TextStyle _lowProfileStyle = TextStyle(
  fontSize: 12.0,
  color: Color(0xFF4A4A4A),
);

/// 用户协议中“高调”文本的样式。
final TextStyle _highProfileStyle = TextStyle(
  fontSize: 12.0,
  color: Color(0xFF00CED2),
  fontWeight: FontWeight.bold
);
class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String mobile, _password;
  Color _eyeColor;
  var _param = {'mobile':''};

  MainBloc _mainBloc;

  BuildContext _context;

  StreamSubscription _dataSubscription;

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  bool wechatInstalled = false,alipayInstalled = false;

  @override
  void initState() {
    super.initState();
    _mainBloc = BlocProvider.of<MainBloc>(context);
    _context = context;
    //微信登录回调
    _dataSubscription = fluwx.responseFromAuth.listen((data) {
      int errCode = data.errCode;
      print("initState ======   ${data.errCode}  --- ${data.code}");
      if (errCode == 0) {
        String code = data.code;
        print('code  $code');
        wxMpLogin(code);
      } else {
        Fluttertoast.showToast(msg: '授权失败');
      }
    });

    _initWechatOrAlipayInstalled();
  }

  //微信登录回调
  Future wxMpLogin(String code) async{
    _mainBloc.wxMpLogin(code).then((value){
      var result = value;
      thirdLogin(result);
    }).catchError((_){
//      Fluttertoast.showToast(msg: _.message);
    });

  }

  //判断支付宝或者微信是否安装
  Future _initWechatOrAlipayInstalled() async {
    wechatInstalled = await fluwx.isWeChatInstalled();
    alipayInstalled = await tobias.isAliPayInstalled();
    setState((){});
  }

  Future thirdLogin(var result){
    if(result['login'] == 1){
      NavigatorUtil.pushPage(context, BindMobilePage(relateId: result['relateId'],),pageName: '绑定手机号');
    }else if(result['login'] == 0){
      SpUtil.putString(Constant.key_token_name, result['token']);
      DioUtil().setCookie(result['token']);
      _mainBloc.saveLogin(result['baseuser']);
      Fluttertoast.showToast(msg: '登录成功');
      Navigator.pushNamedAndRemoveUntil(_context, "/",(Route route) => false);
    }
  }

  Future submit() async {
    if (_formKey.currentState.validate()) {
      ///只有输入的内容符合要求通过才会到达此处
      _formKey.currentState.save();

      _param['code'] = _password;
      _param['mobile'] = mobile;
      _param['model'] = '1';

      _mainBloc.login(mobile, _password).then((value){
        var result = value;
        SpUtil.putString(Constant.key_token_name, result['token']);
        DioUtil().setCookie(result['token']);
        _mainBloc.saveLogin(result['baseuser']);
        Fluttertoast.showToast(msg: '登录成功');
        Navigator.pushNamedAndRemoveUntil(context, "/",(Route route) => false);
      }).catchError((_){
        Fluttertoast.showToast(msg: _.message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body:new SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Form(
                key: _formKey,
                child: new Container(
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      SizedBox(height: 80.0),
                      new Align(
                        alignment: Alignment.center,
                        child: new Padding(
                          padding: EdgeInsets.only(left:0.0),
                          child: new Image.asset(
                            'assets/images/comm_family.png',        //图片的路径
                            width: 180.0, //图片控件的高度
                            fit: BoxFit.fill, //告诉引用图片的控件，图像应尽可能小，但覆盖整个控件。
                          ),
                        ),
                      ),
                      SizedBox(height: 60.0),
                      new Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: buildEmailTextField(),
                      ),
                      SizedBox(height: 20.0),
                      new Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: buildPasswordTextField(context),
                      ),

                      SizedBox(height: 40.0),
                      buildLoginButton(context),

                      Container(
                          margin: EdgeInsets.only(top: 30),
                        child:Text('第三方快捷登录方式',style: TextStyle(color: Colours.text_gray,fontSize: 14))
                      ),

//                      Container(
//                        color:Colors.black,
//                        child:Row(
//                          children: <Widget>[
//                            CircleAvatar(
//                              radius: 20.0,
//                              backgroundColor:Colors.black,
//                              backgroundImage: AssetImage(
//                                Utils.getImgPath('apple_logo'),
//                              ),
//                            ),
//                            Text('通过Apple登录')
//                          ],
//                        )
//                      ),

                      Platform.isIOS ? GestureDetector(
                        child: Container(
                            margin: EdgeInsets.only(left: 40, top: 20,right: 40),
                            alignment: Alignment(0, 0),
                            height: 50,
                            width: 200,
                            decoration: new BoxDecoration(
                              color: Colors.black,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              //设置四周边框
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor:Colors.black,
                                  backgroundImage: AssetImage(
                                    Utils.getImgPath('apple_logo'),
                                  ),
                                ),
                                Text('通过Apple登录',style: TextStyle(color: Colors.white,fontSize: Dimens.font_sp16))
                              ],
                            )
                        ),
                        onTap: (){
                          logIn();
                        },
                      ):SizedBox(height:0),

                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            wechatInstalled ? GestureDetector(
                              child: Column(
                                children: <Widget>[
                                  new Image.asset(
                                    'assets/images/wechat_login.png',        //图片的路径
                                    width: 50.0, //图片控件的高度
                                    fit: BoxFit.fill, //告诉引用图片的控件，图像应尽可能小，但覆盖整个控件。
                                  ),
                                  SizedBox(height:5),
                                  Text('微信',style: TextStyle(color: Colours.text_gray,fontSize: 12))
                                ],
                              ),
                              onTap: () async {
                                bool installed = await fluwx.isWeChatInstalled();
                                if(!installed){
                                  SimpleDialogUtil.showDialogs(context,'提示','您还没有安装微信，请先安装微信');
                                }else{
                                  var result = await fluwx.sendAuth(scope: "snsapi_userinfo", state: "wechat_sdk_demo_test");
                                }
                              },
                            ):SizedBox(height: 0),
                            alipayInstalled ? SizedBox(width: 50):SizedBox(height: 0),
                            alipayInstalled ? GestureDetector(
                              child: Column(
                                children: <Widget>[
                                  new Image.asset(
                                    'assets/images/ali_login.png',        //图片的路径
                                    width: 50.0, //图片控件的高度
                                    fit: BoxFit.fill, //告诉引用图片的控件，图像应尽可能小，但覆盖整个控件。
                                  ),
                                  SizedBox(height:5),
                                  Text('支付宝',style: TextStyle(color: Colours.text_gray,fontSize: 12))
                                ],
                              ),
                              onTap: () async {
                                var install = await tobias.isAliPayInstalled();
                                if(install){
                                  String param = await _mainBloc.genAliLoginParam();

                                  tobias.aliPayAuth(param).then((map) {
                                    var result = 'http://www.shequyijia.cn?${map['result']}';
                                    String code = Utils.getUrlParam(result,'auth_code');
                                    _mainBloc.aliLogin(code).then((res){
                                      thirdLogin(res);
                                    }).catchError((err){

                                    });
                                  }).catchError((err) {
                                    print('回调失败：${err}');
                                  });
                                }else{
                                  SimpleDialogUtil.showDialogs(context,'提示','您还没有安装支付宝，请先安装支付宝');
                                }
                              },
                            ):SizedBox(height: 0)
                          ],
                        ),
                      ),
//                      buildRegisterText()

                      Container(
                          margin: EdgeInsets.only(top: 50,bottom: 30),
                          child:Text.rich(
                            // 文字跨度（`TextSpan`）组件，不可变的文本范围。
                            TextSpan(
                              // 文本（`text`）属性，跨度中包含的文本。
                              text: '登录本系统表明您已同意：',
                              // 样式（`style`）属性，应用于文本和子组件的样式。
                              style: _lowProfileStyle,
                              children: [
                                TextSpan(
                                  // 识别（`recognizer`）属性，一个手势识别器，它将接收触及此文本范围的事件。
                                  // 手势（`gestures`）库的点击手势识别器（`TapGestureRecognizer`）类，识别点击手势。
                                  recognizer: TapGestureRecognizer()..onTap = () {
//                                    NavigatorUtil.launchInBrowser(ShequejiaApi.formatH5Path('/#/privacy/'),title: '服务条款');

                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible: false,
                                      // user must tap button!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          //title: Text('免责声明'),
                                            contentPadding:EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                                            content: Container(
                                              width: MediaQuery.of(context).size.width - 10,
                                              child: Column(
                                                children: <Widget>[
                                                  Container(
                                                    padding: EdgeInsets
                                                        .fromLTRB(
                                                        5.0, 5.0, 10.0, 10.0),
                                                    //width: 100,
                                                    height: 40,
                                                    child: Text('服务协议及隐私政策',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight
                                                                .bold)),
                                                  ),
//                                                  SizedBox(height: 20),
                                                  Expanded(
                                                      child: WebViewFlutterPage(
                                                          url: "/#/privacy/",
                                                          showTitle: false)
                                                  ),
                                                  FlatButton(
                                                    child: Text('关闭',style:TextStyle(fontSize: 14,color: Colors.green)),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                        );
                                      },
                                    );
                                  },
                                  text: '“服务协议及隐私政策”',
                                  style: _highProfileStyle,
                                ),
                              ],
                            ),
                          )
                      )
                    ],
                  ),
                ),
              ),
            )
        )
    );
  }

  Align buildRegisterText() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30,vertical: 50.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                  child: Text(''),
                  onTap: () {
                    //TODO 跳转到注册页面
                    print('验证码登录');
                    Navigator.push(
                      context,
                      new MaterialPageRoute(builder: (context) => new LoginPage()),
                    );
                  },
                ),
              flex: 1,
            ),
            GestureDetector(
              child: Text(
                '没有账号？点击注册',
              ),
              onTap: () {
                print('去注册');
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new RegisterPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future sendVerifyCode() async {
    _formKey.currentState.save();

    if(!BaseUtils.isChinaPhoneLegal(mobile)){
      BaseUtils.showToast('请输入正确的手机号');
      return;
    }

    setState((){
      verifyAvailable = false;
    });

    _mainBloc.sendVerify(mobile).then((_){
      print(_);
      _startTimer();
    }).catchError((_){
      verifyAvailable = true;
    });
  }

  Widget buildLoginButton(BuildContext context) {
    return RoundButton(
      bgColor: Colours.app_main,
      radius:5,
      width: MediaQuery.of(context).size.width - 60,
      text: '登 录',
      height: 50,
      style: TextStyle(color: Colors.white),
      onPressed: (){
        submit();
      },
    );
  }

  buildPasswordTextField(BuildContext context) {

    return new Container(
      child: new Stack(
        children: <Widget>[
            TextFormField(
            onSaved: (String value) => _password = value,
            validator: (String value) {
              if (value.isEmpty) {
                return '请输入验证码';
              }
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '验证码',
              prefixIcon: Icon(
                Icons.lock,
                color: _eyeColor,
              ),
            ),
          ),
          new Positioned(
            right: 0,
            top: 25,
            child: InkWell(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Text('$_verifyStr',style: verifyAvailable?AppText.SubTitle_Size_Big:AppText.SubTitle_Size_Big_Gray,),
              ),
              onTap: (){
                if(verifyAvailable)
                  sendVerifyCode();
              },
            ),
          ),
        ],
      ),
    );
  }

  TextFormField buildEmailTextField() {
    return TextFormField(
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: '手机号',
        prefixIcon: Icon(
          Icons.mobile_screen_share,
          color: _eyeColor,
        ),
      ),
      validator: (String value) {
        var emailReg = RegExp(
            r"^1[345789]\d{9}");
        if (!emailReg.hasMatch(value)) {
          return '请输入正确的手机号';
        }
      },
      onSaved: (String value) => mobile = value,
    );
  }

  /// 倒计时的计时器。
  Timer _timer;
  /// 当前倒计时的秒数。
  int _seconds = 60;
  var _verifyStr = '获取验证码',verifyAvailable = true;
  /// 启动倒计时的计时器。
  void _startTimer() {
    // 计时器（`Timer`）组件的定期（`periodic`）构造函数，创建一个新的重复计时器。
    _timer = Timer.periodic(
        Duration(seconds: 1),
            (timer) {
          if (_seconds == 0) {
            _cancelTimer();
            _seconds = 60;
            verifyAvailable = true;
            setState(() {});
            return;
          }
          _seconds--;
          _verifyStr = '已发送$_seconds'+'s';
          setState(() {});
          if (_seconds == 0) {
            _verifyStr = '重新发送';
            verifyAvailable = true;
          }
        });
  }

  /// 取消倒计时的计时器。
  void _cancelTimer() {
    // 计时器（`Timer`）组件的取消（`cancel`）方法，取消计时器。
    _timer?.cancel();
  }

  @override
  void dispose() {
    _cancelTimer();
    _dataSubscription.cancel();
    super.dispose();
  }

  void logIn() async {
    String systemVersion = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    try {
      systemVersion = systemVersion.split(".")[0];
      double version = double.parse(systemVersion);
      if(version < 13){
        Fluttertoast.showToast(msg: '您的系统版本太低，请使用其它登录方式');
        return;
      }
    }catch(err){

    }

    String errorMessage = '';
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:
        String token = new String.fromCharCodes(result.credential.identityToken);
        _mainBloc.appleIdLogin(token).then((value){
          var result = value;
          thirdLogin(result);
        }).catchError((_){
//          Fluttertoast.showToast(msg: _.message);
        });
        break;
      case AuthorizationStatus.error:
        errorMessage = "登录失败，请切换登录方式";
        break;
      case AuthorizationStatus.cancelled:
        errorMessage = '您已取消登录';
        break;
    }
    Fluttertoast.showToast(msg: errorMessage);
  }


  String _readIosDeviceInfo(IosDeviceInfo data) {
    return  data.systemVersion;
  }

}