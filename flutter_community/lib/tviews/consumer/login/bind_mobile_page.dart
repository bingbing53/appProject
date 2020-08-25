/*
 * Created by wzy on 2019/3/12.
 */

import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/common/style.dart';
import 'package:helloworld/data/net/dio_util.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/consumer/login/register_page.dart';
import 'package:helloworld/tviews/widget/widget_index.dart';
import 'package:helloworld/utils/base_utils.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:helloworld/utils/utils.dart';
import 'package:tobias/tobias.dart' as tobias;

class BindMobilePage extends StatefulWidget {

  final String relateId;

  const BindMobilePage({Key key, this.relateId}) : super(key: key);

  @override
  _BindMobilePageState createState() => _BindMobilePageState();
}

class _BindMobilePageState extends State<BindMobilePage> {
  final _formKey = GlobalKey<FormState>();
  String mobile, _password;
  Color _eyeColor;
  var _param = {'mobile':''};

  MainBloc _mainBloc;

  @override
  void initState() {
    super.initState();
    _mainBloc = BlocProvider.of<MainBloc>(context);

  }

  Future submit() async {
    if (_formKey.currentState.validate()) {
      ///只有输入的内容符合要求通过才会到达此处
      _formKey.currentState.save();

      _param['code'] = _password;
      _param['mobile'] = mobile;
      _param['model'] = '1';
      _param['thirdUserId'] = widget.relateId;

      _mainBloc.login(mobile, _password, relateId:widget.relateId).then((value){
        var result = value;
        SpUtil.putString(Constant.key_token_name, result['token']);
        DioUtil().setCookie(result['token']);

        _mainBloc.saveLogin(result['baseuser']);
        Fluttertoast.showToast(msg: '登录成功');

        // 延时1s执行返回
        Future.delayed(Duration(seconds: 1), (){
          Navigator.pushNamedAndRemoveUntil(context, "/",(Route route) => false);
        });
      }).catchError((_){
        Fluttertoast.showToast(msg: _.message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('绑定手机'),
          flexibleSpace: Image(
            image: AssetImage(Utils.getImgPath('home_top')),
            fit: BoxFit.cover,
          ),
        ),
        body:new SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Form(
                key: _formKey,
                child: new Container(
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      SizedBox(height: 30.0),
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
                    ],
                  ),
                ),
              ),
            )
        )
    );
  }

  String buildAuthInfo(){

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
      height: 40,
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
    super.dispose();
  }

}