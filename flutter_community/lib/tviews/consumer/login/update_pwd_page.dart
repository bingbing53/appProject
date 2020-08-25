/*
 * Created by 王振宇 on 2019/3/12.
 */

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helloworld/common/net_utils.dart';
import 'package:helloworld/common/style.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/tviews/consumer/comm/free_shoot_page.dart';
import 'package:helloworld/tviews/consumer/login/login_base_page.dart';
import 'package:helloworld/utils/dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

const int color = 0xFFF5534B;

class UpdatePwdPage extends StatefulWidget {
  @override
  _UpdatePwdPageState createState() => _UpdatePwdPageState();

}

class _UpdatePwdPageState extends State<UpdatePwdPage> {

  final _formKey = GlobalKey<FormState>();
  String _mobile="";
  String _password="";
  String _newpassword="";
  String code="";
  bool _isObscure1 = true; //密码是否可见
  bool _isObscure2 = true; //新密码是否可见
  Color _eyeColor;
  Color _eyeColor2;
  int _seconds = 0;
  String _verifyStr = '获取验证码';
  String _verifyCode = '';
  Timer _timer;

  @override
  void dispose() {
    super.dispose();
    _cancelTimer();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  submit() async {
    _formKey.currentState.save();
    if(_password!=_newpassword){
      DialogUtil.showDialogWarning("两次密码输入不一致", context);
      return ;
    }
    var _param = {'mobile':_mobile,'password':_password,'newpassword':_newpassword,'code':_verifyCode};
    print(_param);
    var response = await NetUtils.post(Api.UPDATE_PWD,params: _param);
    if(response!=null){
      String isOk = response['isOk'];
      if('1'==isOk){
        DialogUtil.showDialogWarning("密码更改成功，将跳转到登录页", context);
        Timer timer = new Timer(new Duration(seconds: 3), () {
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new LoginPage()),
          );
        });
      }else{
        DialogUtil.showDialogWarning(response, context);
      }
    }else{
      DialogUtil.showDialogWarning("网络超时，请稍后重试", context);
    }
  }

  Future sendVerifyCode() async {
    _formKey.currentState.save();
    print("手机号码");
    print(_mobile);
    var _param = {'mobile':_mobile};
    var response = await NetUtils.get(Api.SEND_VERIFY_CODE,params: _param);
    if(response==null||response==''){
      response = '验证码发送成功';
    }
    DialogUtil.showDialogWarning(response, context);
  }

  Widget _buildVerifyCodeEdit() {
    var node = new FocusNode();
    Widget verifyCodeEdit = new TextField(
      onChanged: (str) {
        _verifyCode = str;
        setState(() {});
      },
      decoration: new InputDecoration(
        hintText: '请输入验证码',
        prefixIcon: Icon(
          Icons.lock,
          color: Colors.grey,
        ),
      ),
      /*maxLines: 1,
      maxLength: 6,*/
      //键盘展示为数字
      keyboardType: TextInputType.number,
      //只能输入数字
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter.digitsOnly,
      ],
      onSubmitted: (text) {
//        FocusScope.of(context).reparentIfNeeded(node);
      },
    );

    Widget verifyCodeBtn = new InkWell(
      onTap: (_seconds == 0)
          ? () {
        sendVerifyCode();
        setState(() {
          _startTimer();
        });
      }
          : null,
      child: new Container(
        alignment: Alignment.center,
        width: 100.0,
        height: 36.0,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          border: new Border.all(
            width: 1.0,
            color: Colors.blue,
          ),
        ),
        child: new Text(
          '$_verifyStr',
          style: new TextStyle(fontSize: 14.0),
        ),
      ),
    );

    return new Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
      child: new Stack(
        children: <Widget>[
          verifyCodeEdit,
          new Align(
            alignment: Alignment.topRight,
            child: verifyCodeBtn,
          ),
        ],
      ),
    );
  }

  _startTimer() {
    _seconds = 10;

    _timer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        return;
      }

      _seconds--;
      _verifyStr = '$_seconds(s)';
      setState(() {});
      if (_seconds == 0) {
        _verifyStr = '重新发送';
      }
    });
  }

  _cancelTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(title: new Text('更改密码')),
      body: new SingleChildScrollView(
        child: new ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: 120.0,
              ),
              child:Form(
                key: _formKey,
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0,left: 40.0,right: 40.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onSaved: (String value) => _mobile = value,
                        decoration: InputDecoration(
                          labelText: '手机号',
                          prefixIcon: Icon(
                            Icons.mobile_screen_share,
                            color: Colors.grey,
                          ),
                        ),
                        validator: (String value) {
                          var emailReg = RegExp(
                              r"^1[345789]\d{9}");
                          if (!emailReg.hasMatch(value)) {
                            return '请输入正确的手机号';
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0,left: 40.0,right: 40.0),
                      child: TextFormField(
                        onSaved: (String value) => _password = value,
                        obscureText: _isObscure1,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return '请输入密码';
                          }
                        },
                        decoration: InputDecoration(
                            labelText: '新密码',
                            prefixIcon: Icon(
                              Icons.lock,
                              color: _eyeColor,
                            ),
                            suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  color: _eyeColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure1 = !_isObscure1;
                                    _eyeColor = _isObscure1
                                        ? Colors.grey
                                        : Theme.of(context).iconTheme.color;
                                  });
                                })),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0.0,left: 40.0,right: 40.0),
                      child: TextFormField(
                        onSaved: (String value) => _newpassword = value,
                        obscureText: _isObscure2,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return '请再次输入新密码';
                          }
                          _formKey.currentState.save();
                          if(value!=_password){
                            return '两次输入密码不一致';
                          }
                        },
                        decoration: InputDecoration(
                            labelText: '重复输入新密码',
                            prefixIcon: Icon(
                              Icons.lock,
                              color: _eyeColor2,
                            ),
                            suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.remove_red_eye,
                                  color: _eyeColor2,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure2 = !_isObscure2;
                                    _eyeColor2 = _isObscure2
                                        ? Colors.grey
                                        : Theme.of(context).iconTheme.color;
                                  });
                                })),
                      ),
                    ),
                    _buildVerifyCodeEdit(),
                    SizedBox(
                      height: 20.0,
                    ),
                    Align(
                      child: SizedBox(
                        height: 40.0,
                        width: 290.0,
                        child: RaisedButton(
                          child: Text(
                            '确 定',
                            style: AppText.Title_Size_Big_White,
                          ),
//                          color: new Color(DialogUtil.color),
                          onPressed: () {
                            submit();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            )
      )
    );
  }
}