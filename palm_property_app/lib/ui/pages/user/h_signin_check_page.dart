import 'dart:async';

import 'package:flutter/material.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/data/net/dio_util.dart';

/**
 *验证码验证界面
 */
bool signInInit = true;
class SignInCheckPage extends StatefulWidget {
  final String mobile;

  const SignInCheckPage({Key key, this.mobile}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _SignInCheckPageState(mobile: this.mobile);
  }

}

class _SignInCheckPageState extends State<SignInCheckPage> {
  String mobile,code;
  LoginBloc _bloc;
  _SignInCheckPageState({@required this.mobile});

  FocusNode _contentFocusNode = FocusNode();
  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    signInInit = true;

    _bloc.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e("SignInCheckPage build......");
    if(signInInit) {
      _bloc = BlocProvider.of<LoginBloc>(context);
      signInInit = false;
      _bloc.sendValidCode(mobile);

      _bloc.sendCodeStream.listen((event){
        if(event)
          countdown();
      });

      _bloc.loginSuccessStream.listen((event){
        Navigator.pushNamedAndRemoveUntil(context, "/MainPage",(Route route) => false);
      });

    }
    return
      Scaffold(
        appBar: new AppBar(
            title: new Text('输入验证码',
            style: new TextStyle(fontSize: 16.0),
          ),
        ),
        body: Container(
          child: Padding(padding: const EdgeInsets.only(
              left: 15, right: 25, top: 40, bottom: 10),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                Text('验证码已发送至 $mobile',style: TextStyle(fontSize: 18.0),),
                SizedBox(height: 20.0,),

                TextField(
                  focusNode: _contentFocusNode,
                  //关联焦点
                  keyboardType:TextInputType.number,
                  decoration: new InputDecoration(
                      hintText: "输入验证码",
                  ),
                  style: new TextStyle(fontSize: 16, color: Colors.black),

                  onChanged: (val){
                    if(val.length == 4){
                      _contentFocusNode.unfocus();

                      _bloc.login(context,username: mobile,type: 1,code:val);

                    }
                  },
                  maxLength: 4,

                ),

                SizedBox(height: 20.0,),

                GestureDetector(onTap:(){
                      if(_canClick) {
                        _countdownNum = 60;
                        _bloc.sendValidCode(mobile);
                      }
                      },child:Text('$_codeCountdownStr',style: TextStyle(fontSize: 13.0,color: _canClick ?Colors.blueAccent:Colors.grey)))
              ],
            )
          )
        ),
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