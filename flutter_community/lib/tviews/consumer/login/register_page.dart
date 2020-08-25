/*
 * Created by wzy on 2019/3/12.
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:helloworld/common/net_utils.dart';
import 'package:helloworld/common/style.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/consumer/comm/communicate_page.dart';
import 'package:helloworld/tviews/consumer/login/login_base_page.dart';
import 'package:helloworld/tviews/widget/widget_index.dart';
import 'package:helloworld/utils/base_utils.dart';
import 'package:helloworld/utils/dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String mobile, _password,password;
  bool _isObscure = true;
  Color _eyeColor;
  var _param = {'mobile':''};

  Future submit() async {
    if (_formKey.currentState.validate()) {
      ///只有输入的内容符合要求通过才会到达此处
      _formKey.currentState.save();
      //TODO 执行登录方法
      //print('email:$mobile , assword:$_password');

      _param['code'] = _password;
      _param['mobile'] = mobile;
      _param['password'] = password;

      var response = await NetUtils.post(Api.REGISTER,params: _param);
      if(null==response){
        DialogUtil.showDialogWarning("验证码失效，请稍后重试...", context);
      }else{
        print("注册");
        print(response);

        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                ),
                buildTitle(),
                buildTitleLine(),
                SizedBox(height: 30.0),
                buildEmailTextField(),
                SizedBox(height: 10.0),
                buildValidCodeText(context),
                buildPassword2TextField(context),
                SizedBox(height: 50.0),
                buildLoginButton(context),
                SizedBox(height: 30.0),
                buildRegisterText(context),
              ],
            )));
  }

  Align buildRegisterText(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: Text(
                '去登录',
              ),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new LoginPage()),
                );
              },
            )
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
    var _param = {'mobile':mobile};
    var response = await NetUtils.get(Api.SEND_VERIFY_CODE,params: _param);
    if(null != response) {
      BaseUtils.showToast('验证码发送成功');
      _startTimer();
    }else{
      verifyAvailable = true;
    }

  }

  Widget buildLoginButton(BuildContext context) {
    return RoundButton(
      bgColor: Colours.app_main,
      radius:5,
      width: MediaQuery.of(context).size.width - 60,
      text: '注  册',
      height: 40,
      style: TextStyle(color: Colors.white),
      onPressed: (){
        submit();
      },
    );
  }

  Widget buildValidCodeText(BuildContext context) {
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

  TextFormField buildPassword2TextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => password = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
      },
      decoration: InputDecoration(
        labelText: '密码',
        suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = _isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color;
                });
              }
          ),
      ),
    );
  }

  TextFormField buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: '手机号',
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

  Padding buildTitleLine() {
    return Padding(
      padding: EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.black,
          width: 40.0,
          height: 2.0,
        ),
      ),
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

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '注册',
        style: TextStyle(fontSize: 30.0),
      ),
    );
  }
}