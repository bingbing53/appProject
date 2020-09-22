import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/net/dio_util.dart';
import 'package:flutter_wanandroid/ui/dialog/simple_dialog.dart';
import 'package:flutter_wanandroid/ui/pages/page_index.dart';

import 'h_signin_check_page.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_wanandroid/blocs/bloc_index.dart';
import 'package:flutter_wanandroid/res/res_index.dart';

class LoginMainPage extends StatefulWidget {
  LoginMainPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginMainPage();
  }
}

class _LoginMainPage extends State<LoginMainPage> {

  //0 账户密码登录 1 验证码登录
  int type = 0;

  FocusNode emailFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();
  FocusScopeNode focusScopeNode = new FocusScopeNode();
  String _mobile,_password;

  GlobalKey<FormState> _SignInFormKey = new GlobalKey();

  bool isShowPassWord = false,loginDisabled = false;

  LoginBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<LoginBloc>(context);
    _bloc.loginSuccessStream.listen((event){
      Navigator.pushNamedAndRemoveUntil(context, "/MainPage",(Route route) => false);
      SpUtil.putString(Constant.key_token_name,event);
      DioUtil().setCookie(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new SafeArea(
          child: new SingleChildScrollView(
              child: new Container(
                /**这里要手动设置container的高度和宽度，不然显示不了
                 * 利用MediaQuery可以获取到跟屏幕信息有关的数据
                 */
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(Dimens.gap_dp16),
                  color:Colors.white,
                  child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new SizedBox(
                        height: 35,
                      ),
                      //顶部图片
                      new Image(
                          width: 250,
                          height: 80,
                          image: new AssetImage(Utils.getImgPath("icon_wan_android"))),
                      new SizedBox(
                        height: 20,
                      ),

                      buildForm(),

                      buildSignInButton(),

                      SizedBox(height: 20.0,),

                      Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              child: Center(child:Text(type == 0 ? '验证码登录' : '密码登录',)),
                              onTap: (){
                                setState((){
                                  type = type == 0 ? 1:0;
                                });
                              },
                            ),
//                            flex: 5,
                          ),
//                          Expanded(
//                            child: GestureDetector(
//                              child: Center(child: Text('|',style: TextStyle(color: Colors.grey),),),
//                            ),
//                            flex: 1,
//                          ),
//                          Expanded(
//                            child: GestureDetector(
////                              child: Center(child:Text('忘记密码')),
//                            ),
//                            flex: 5,
//                          ),
                        ],
                      ),

                      SizedBox(height: 50.0,),
                      GestureDetector(
                        child: Center(child: Text('被邀居民注册',style: TextStyle(color: Colors.blue),),),
                        onTap: (){
                          _SignInFormKey.currentState.save();
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return BlocProvider<LoginBloc>(
                                  child: UserRegister(mobile: _mobile,),
                                  bloc: LoginBloc());
                            }),
                          );
                        },
                      ),

                    ],
                  ))),
        ));
  }

  //登录form表单
  Widget buildForm(){
    return new Container(
      decoration:
      new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8))
//          , color: Colors.white
      ),
//      width: 300,
      height: type == 0 ? 190 : 100,
      /**
       * Flutter提供了一个Form widget，它可以对输入框进行分组，
       * 然后进行一些统一操作，如输入内容校验、输入框重置以及输入内容保存。
       */
      child: new Form(
        key: _SignInFormKey,
        //开启自动检验输入内容，最好还是自己手动检验，不然每次修改子孩子的TextFormField的时候，其他TextFormField也会被检验，感觉不是很好
//        autovalidate: true,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 20, bottom: 10),
                child: new TextFormField(
                  //关联焦点
                  focusNode: emailFocusNode,
                  keyboardType: TextInputType.phone,
                  onEditingComplete: () {
                    if (focusScopeNode == null) {
                      focusScopeNode = FocusScope.of(context);
                    }
                    focusScopeNode.requestFocus(passwordFocusNode);
                  },
                  decoration: new InputDecoration(
                      icon: new Icon(Icons.phone_android, color: Colors.grey,),
                      hintText: "请输入手机号",

//                      border: InputBorder.none,
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
            type == 0?Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15,top: 10),
                child: new TextFormField(
                  focusNode: passwordFocusNode,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                      icon: new Icon(Icons.lock_outline, color: Colors.grey,),
                      hintText: "请输入密码",
                      border: InputBorder.none,
                      suffixIcon: new IconButton(icon: new Icon(
                        Icons.remove_red_eye, color: Colors.black,),
                          onPressed: showPassWord)
                  ),
                  //输入密码，需要用*****显示
                  obscureText: !isShowPassWord,
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
            ):SizedBox(height: 0,),


          ],
        ),),
    );
  }

  /**
   * 点击控制密码是否显示
   */
  void showPassWord() {
    setState(() {
      isShowPassWord = !isShowPassWord;
    });
  }

  Widget buildSignInButton() {
    return Row(

      children: <Widget>[

        Expanded(

              child: RoundButton(
                margin: EdgeInsets.all(40),

//                shape : const RoundedRectangleBorder(
//                    side: BorderSide.none,
//                    borderRadius: BorderRadius.all(Radius.circular(50))),
                text:(type == 0 ? '登  录':'获取验证码'/*style: TextStyle(fontSize: Dimens.font_sp18)*/),
                onPressed: () async {
                  var _form = _SignInFormKey.currentState;
                  _form.save();
                  if(!RegexUtil.isMobileSimple(_mobile)){
                    Fluttertoast.showToast(msg: '请输入正确的手机号');
                    return;
                  }

                  _bloc.checkMobile(_mobile).then((_) async {
                    print('success');
                    if(type == 1){
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return BlocProvider<LoginBloc>(
                              child: SignInCheckPage(mobile: _mobile,),
                              bloc: LoginBloc());
                        }),
                      );
                    }else if(type == 0){
                      //账户密码登录
                      if(_password.length < 6){
                        Fluttertoast.showToast(msg: '密码不得少于6位');
                        return;
                      }
                      await _bloc.login(context,username: _mobile,password: _password,type: type);
                    }
                  }).catchError((_){
                    SimpleDialogUtil.showDialogs(context,'错误提示',_.message);
                  });
                },
              )
          ),


      ],
    );
  }
}