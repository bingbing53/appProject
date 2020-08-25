
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/data/net/dio_util.dart';

//系统用户注册
class UserRegister extends StatefulWidget{
  final String mobile;

  const UserRegister({Key key, this.mobile}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UserRegisterPage();
  }
}

class _UserRegisterPage extends State<UserRegister>{

  GlobalKey<FormState> _SignInFormKey = new GlobalKey();

  String _mobile='',_realname,_inviteCode,_validCode,_idcard,_address;

  LoginBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<LoginBloc>(context);

    _bloc.sendCodeStream.listen((event){
      if(event)
        countdown();
    });

    _bloc.loginSuccessStream.listen((event){
      Navigator.pushNamedAndRemoveUntil(context, "/MainPage",(Route route) => false);
      SpUtil.putString(Constant.key_token_name,event);
      DioUtil().setCookie(event);
    });

    if(widget.mobile != null && widget.mobile.trim().length > 0){
      _mobile = widget.mobile;
    }
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
        title: Text('邀请码注册'),
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
              child: Text('注 册',style: TextStyle(fontSize: Dimens.font_sp18),),
              onPressed: () {
                var _form = _SignInFormKey.currentState;
                _form.save();
                if(!RegexUtil.isMobileSimple(_mobile)){
                  Fluttertoast.showToast(msg: '请输入正确的手机号');
                  return;
                }
//                if(!RegexUtil.isIDCard(_idcard)){
//                  Fluttertoast.showToast(msg: '请输入正确的身份证号');
//                  return;
//                }
//                if(_address == null || _address == ''){
//                  Fluttertoast.showToast(msg: '请输入居住地址');
//                  return;
//                }
                if(_inviteCode == null || _inviteCode.trim().length < 6){
                  Fluttertoast.showToast(msg: '请输入六位邀请码');
                  return;
                }
                if(_validCode == null || _validCode.trim().length <= 0){
                  Fluttertoast.showToast(msg: '请输入验证码');
                  return;
                }

                _bloc.login(context,username: _mobile,type: 2,code:_validCode,invite: _inviteCode,address: _address,idcard: _idcard);

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
                    left: 15, right: 15, top: 10, bottom: 10),
                child: new TextFormField(
                  initialValue:_mobile,
                  //关联焦点
                  keyboardType: TextInputType.phone,
                  decoration: new InputDecoration(
                      icon: new Icon(Icons.phone_android, color: Colors.grey,),
                      hintText: "请输入手机号",
                      border: InputBorder.none
                  ),
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                  //验证
                  validator: (value) {
                    if (value.isEmpty) {
                      return "手机号不能为空!";
                    }
                  },
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],//只允2
                  // 许输入数字
                  onSaved: (value) {
                    _mobile = value;
                  },
                  maxLength: 11,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10),
                child: new TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    icon: new Icon(Icons.person_outline, color: Colors.grey,),
                    hintText: "请输入真实姓名",
                    border: InputBorder.none,
                  ),
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 2) {
                      return "长度不小于2位";
                    }
                  },
                  onSaved: (value) {
                    _realname = value;
                  },
                  maxLength: 20,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10),
                child: new TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                    icon: new Icon(Icons.portrait, color: Colors.grey,),
                    hintText: "请输入身份证号（可选）",
                    border: InputBorder.none,
                  ),
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                  validator: (value) {

                  },
                  onSaved: (value) {
                    _idcard = value;
                  },
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]")),
                  ],//只允
                  maxLength: 18,
                ),
              ),
            ),

//            Flexible(
//              child: Padding(
//                padding: const EdgeInsets.only(
//                    left: 15, right: 15, top: 20),
//                child: new TextFormField(
//                  keyboardType: TextInputType.text,
//                  maxLines: 2,
//                  decoration: new InputDecoration(
//                    icon: new Icon(Icons.business, color: Colors.grey,),
//                    hintText: "请输入居住地址",
//                    border: InputBorder.none,
//                  ),
//                  style: new TextStyle(fontSize: 16, color: Colors.black),
//                  validator: (value) {
//
//                  },
//                  onSaved: (value) {
//                    _address = value;
//                  },
//                ),
//              ),
//            ),
//            new Container(
//              height: 1,
//              width: 320,
//              color: Colors.grey[400],
//            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10),
                child: new TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                    icon: new Icon(Icons.share, color: Colors.grey,),
                    hintText: "请输入6位邀请码",
                    border: InputBorder.none,
                  ),
                  style: new TextStyle(fontSize: 16, color: Colors.black),
                  validator: (value) {

                  },
                  onSaved: (value) {
                    _inviteCode = value;
                  },
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9]")),
                  ],//只允
                  maxLength: 6,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 10),
                child: new TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                    icon: new Icon(Icons.lock_outline, color: Colors.grey,),
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
                            _bloc.sendValidCode(_mobile);
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
            ),
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