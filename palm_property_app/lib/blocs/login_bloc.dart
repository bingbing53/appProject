import 'dart:async';
import 'package:flutter/material.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/data/net/dio_util.dart';
import 'package:estate/data/repository/wan_repository.dart';
import 'package:estate/ui/pages/page_index.dart';

class LoginBloc implements BlocBase {

  ///****** ****** ****** 短信验证码跳转 ****** ****** ****** /
  BehaviorSubject<bool> _sendCode = BehaviorSubject<bool>();
  Sink<bool> get _sendCodeSink => _sendCode.sink;
  Stream<bool> get sendCodeStream =>  _sendCode.stream;
  ///****** ****** ****** 短信验证码跳转 ****** ****** ****** ///


  BehaviorSubject<String> _loginSuccess = BehaviorSubject<String>();
  Sink<String> get _loginSuccessSink => _loginSuccess.sink;
  Stream<String> get loginSuccessStream =>  _loginSuccess.stream;

  WanRepository wanRepository = new WanRepository();


  LoginBloc() {
    LogUtil.e("LoginBloc......");
  }

  @override
  Future getData({String labelId, int page}) {

  }

  @override
  Future onLoadMore({String labelId}) {

    return null;
  }

  @override
  Future onRefresh({String labelId}) {

    return null;
  }

  //登录
  Future login(context,{username,password,type,code,invite,address,idcard}) async{
    return wanRepository.login(username: username,password: password,type:type,code: code).then((result){
      SpUtil.putString(Constant.key_token_name, result['token']);
      SpUtil.putString(Constant.key_login_name, username);

      DioUtil().setCookie(result['token']);
      Navigator.pushNamedAndRemoveUntil(context, "/MainPage",(Route route) => false);
    }).catchError((_){
      print(_);
      Fluttertoast.showToast(msg: _.message);
    });
  }

  //**************************

  //密码重置
  Future resetPasswd(context,String passwd) async{
    return wanRepository.resetPasswd({'password':passwd}).then((val){
      Fluttertoast.showToast(msg: '密码设置成功');
      Navigator.pushNamedAndRemoveUntil(context, "/MainPage",(Route route) => false);
    });
  }
  //密码修改
  Future modifyPasswd(String passwd,String code) async{
    return wanRepository.modifyPasswd({"password":passwd,"code":code});
  }

  //获取验证码
  Future sendValidCode(mobile){
    if(!RegexUtil.isMobileSimple(mobile)){
      Fluttertoast.showToast(msg: '请输入正确的手机号');
    }else {
      return wanRepository.sendVerify(mobile: mobile).then((result) {
        Fluttertoast.showToast(msg: '验证码发送成功');
        _sendCodeSink.add(true);
      }).catchError((_) {
        Fluttertoast.showToast(msg: _.message);
      });
    }
  }

  //校验手机号
  Future checkMobile(mobile) async{
    return await wanRepository.checkMobile(mobile);
  }

  //绑定组织机构
  Future bindOrg(context,tokens,orgCode,ramdom){
    return wanRepository.bindOrg(tokens: tokens,orgCode: orgCode,random: ramdom).then((result){
      SpUtil.putString(Constant.key_token_name,tokens);
      DioUtil().setCookie(tokens);
      if(result != null && result['restPasswd'] == 1){
        NavigatorUtil.pushPage(context,
            BlocProvider<LoginBloc>(
                child: ModifyPasswdPage(labelId: Ids.titleResetPwd),
                bloc: new LoginBloc()
            ),
          pageName: '密码重置'
        );
      }else {
        Fluttertoast.showToast(msg: '登录成功');
        _loginSuccessSink.add(tokens);
      }
    }).catchError((_){
      Fluttertoast.showToast(msg: _.message);
    });

  }


  @override
  void dispose() {
//    _validCode.close();
  }
}
