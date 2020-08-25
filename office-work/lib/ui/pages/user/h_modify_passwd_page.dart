import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wanandroid/common/component_index.dart';

class ModifyPasswdPage extends StatefulWidget {
  ModifyPasswdPage({Key key,this.labelId}) : super(key: key);

  final String labelId;

  @override
  State<StatefulWidget> createState() {
    return _ModifyPasswdPage();
  }
}

class _ModifyPasswdPage extends State<ModifyPasswdPage> {

  GlobalKey<FormState> _SignInFormKey = new GlobalKey();

  String _password,_newPasswd,_validCode;

  LoginBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    if(_bloc != null)
      _bloc.dispose();

    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(IntlUtil.getString(context, widget.labelId)),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 20.0,left:10.0,bottom: 20.0,right: 10.0),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                buildTextForm(),
                SizedBox(height: 30,),
                buildSignInButton()
              ],
            ),
          ),
        )
    );
  }


  Widget buildSignInButton() {
    return Row(
      children: <Widget>[
        Expanded(
            child: MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              shape : const RoundedRectangleBorder(
                  side: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Text(IntlUtil.getString(context, widget.labelId),style: TextStyle(fontSize: Dimens.font_sp18),),
              onPressed: () {
                var _form = _SignInFormKey.currentState;
                _form.save();
                if(widget.labelId == Ids.titleModifyPwd && (_validCode == null || _validCode.trim().length <= 0)){
                  Fluttertoast.showToast(msg: '请输入验证码');
                  return;
                }
                if(ObjectUtil.isEmpty(_password)){
                  Fluttertoast.showToast(msg: '请输入新密码');
                  return;
                }
                if(_password.length < 6){
                  Fluttertoast.showToast(msg: '密码长度不小于6位');
                  return;
                }
                if(_password != _newPasswd){
                  Fluttertoast.showToast(msg: '两次输入密码不一致');
                  return;
                }

                if(widget.labelId == Ids.titleModifyPwd){

                  _bloc.modifyPasswd(_password, _validCode).then((val){
                    Fluttertoast.showToast(msg: '密码修改成功');
                    Navigator.pop(context);
                  });

                }else if(widget.labelId == Ids.titleResetPwd){
                  _bloc.resetPasswd(context,_password);
                }
//                _bloc.login(context,username: _mobile,type: 2,code:_validCode,invite: _inviteCode,address: _address,idcard: _idcard);

              },
            )
        ),
      ],
    );
  }

  Widget buildTextForm(){
    return new Container(
      decoration:
      new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      child: new Form(
        key: _SignInFormKey,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
                child: Padding(
                    padding: const EdgeInsets.only(
                    left: 15, right: 15,top: 10),
                child: new TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                      icon: new Icon(Icons.lock_outline, color: Colors.grey,),
                      hintText: "请输入新密码",
                      border: InputBorder.none
                  ),
                  //输入密码，需要用*****显示
                  obscureText:true,
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return "密码不少于6位";
                    }
                  },
                  onSaved: (value) {
                    _password = value;
                  },
                  inputFormatters: [
        //                    WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]")),//只允许输入字母
                  ],
                  maxLength: 30,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15,top: 10),
                child: new TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                      icon: new Icon(Icons.lock_outline, color: Colors.grey,),
                      hintText: "请再次输入新密码",
                      border: InputBorder.none
                  ),
                  //输入密码，需要用*****显示
                  obscureText:true,
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return "密码不少于6位";
                    }
                  },
                  onSaved: (value) {
                    _newPasswd = value;
                  },
                  inputFormatters: [
                    //                    WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]")),//只允许输入字母
                  ],
                  maxLength: 30,
                ),
              ),
            ),
            widget.labelId == Ids.titleModifyPwd ? Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10),
                child: new TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                    icon: new Icon(Icons.email, color: Colors.grey,),
                    hintText: "请输入验证码",
                    border: InputBorder.none,
                    suffixIcon: Container(
                        padding: EdgeInsets.only(top: 14,right: 15),
                        child: GestureDetector(
                          child: Text('$_codeCountdownStr'),
                          onTap: (){
                            if(_canClick) {
                              var _form = _SignInFormKey.currentState;
                              _form.save();
                              _countdownNum = 60;
                              String mobile = SpUtil.getString(Constant.key_login_name,defValue: '');
                              _bloc.sendValidCode(mobile);
                            }
                          },
                        )
                    ),
                  ),
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                  validator: (value) {

                  },
                  onSaved: (value) {
                    _validCode = value;
                  },
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]")),
                  ],//只允
                  maxLength: 6,
                ),
              ),
            ):Container(height: 0),
          ],
        ),),
    );
  }

  int _countdownNum = 60;
  Timer _countdownTimer;
  String _codeCountdownStr = '获取验证码';
  bool _canClick= true;
  //倒计时
  void countdown(){
    if (_countdownTimer != null) {
      return;
    }
    _canClick = false;
    // Timer的第一秒倒计时是有一点延迟的，为了立刻显示效果可以添加下一行。
    _codeCountdownStr = '${_countdownNum--}秒后重新获取';
    _countdownTimer = new Timer.periodic(new Duration(seconds: 1), (timer) {
      setState((){
        if (_countdownNum > 0) {
          _codeCountdownStr = '${_countdownNum--}秒后重新获取';
          _canClick = false;
        } else {
          _codeCountdownStr = '获取验证码';
          _countdownTimer.cancel();
          _countdownTimer = null;
          _canClick = true;
        }
      });
    });
  }
}