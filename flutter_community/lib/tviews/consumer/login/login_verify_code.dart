/*
 * Created by wzy on 2019/3/12.
 */

import 'package:flutter/material.dart';
import 'package:helloworld/common/net_utils.dart';
import 'package:helloworld/common/style.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/tviews/consumer/comm/communicate_page.dart';
import 'package:helloworld/tviews/consumer/login/add_personinfo_page.dart';
import 'package:helloworld/tviews/consumer/login/login_base_page.dart';
import 'package:helloworld/tviews/consumer/login/register_page.dart';
import 'package:helloworld/tviews/consumer/login/select_org_page.dart';
import 'package:helloworld/utils/dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class LoginVerifyPage extends StatefulWidget {
  @override
  _LoginVerifyPageState createState() => _LoginVerifyPageState();
}

class _LoginVerifyPageState extends State<LoginVerifyPage> {
  final _formKey = GlobalKey<FormState>();
  String mobile, _password;
  //bool _isObscure = true;
  bool _isObscure = false;
  Color _eyeColor;
  List _loginMethod = [
    {
      "title": "facebook",
      "icon":  new Icon(Icons.feedback),
    },
    {
      "title": "google",
      "icon":  new Icon(Icons.language),
    },
    {
      "title": "twitter",
      "icon":  new Icon(Icons.language),
    },
  ];
  var _param = {'mobile':''};

  Future submit() async {
    if (_formKey.currentState.validate()) {
      ///只有输入的内容符合要求通过才会到达此处
      _formKey.currentState.save();
      //TODO 执行登录方法
      //print('email:$mobile , assword:$_password');

      _param['code'] = _password;
      _param['mobile'] = mobile;
      _param['model'] = '1';
      var response = await NetUtils.post(Api.LOGIN,params: _param);
      if(null==response){
        DialogUtil.showDialogWarning("验证码失效，请稍后重试...", context);
      }else{
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('X-AUTH-TOKEN', response['tokens']);
        prefs.setString("isLogin", "isLogin");
        String tokens = prefs.getString('X-AUTH-TOKEN');
        print("登录成功");
        print(tokens);

        String isNew = response['isNew'];
        print(isNew);
        if("1"==isNew){
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new AddPersoninfoPage()),
          );
        }else if(response['orgcode'] != null && response['orgCode'] != ''){

        }else{
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new SelectOrgPage()),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:new SingleChildScrollView(
            child: new ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: 120.0,
              ),
              child:Form(
                key: _formKey,
                child: new Container(
                  child: new Column(
                    children: <Widget>[
                      SizedBox(height: 120.0),
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
                        padding: const EdgeInsets.only(left: 40.0,right: 40.0),
                        child: buildEmailTextField(),
                      ),
                      SizedBox(height: 30.0),
                      new Padding(
                        padding: const EdgeInsets.only(left: 40.0,right: 40.0),
                        child: buildPasswordTextField(context),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0,right: 20.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FlatButton(
                              onPressed:(){
                                sendVerifyCode();
                              },
                              child: new Text('获取验证码',style: AppText.SubTitle_Size_Medium_Gray,)
                          ),
                        ),
                      ),

                      SizedBox(height: 40.0),
                      buildLoginButton(context),
                      SizedBox(height: 10.0),
                      new Padding(
                        padding: const EdgeInsets.only(left: 133.0),
                        child: new Row(
                          children: <Widget>[
                            new Align(
                              alignment: Alignment.centerLeft,
                              child: FlatButton(
                                  onPressed:(){
                                    Navigator.pop(context);
//                                    Navigator.push(
//                                      context,
//                                      new MaterialPageRoute(builder: (context) => new LoginPage()),
//                                    );
                                  },
                                  child: new Text('密码登录>',style: AppText.SubTitle_Size_Medium_Gray,)
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
        )

    );
  }

/*
ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                ),
                buildTitle(),
                buildTitleLine(),
                SizedBox(height: 30.0),
                buildEmailTextField(),
                SizedBox(height: 30.0),
                buildPasswordTextField(context),
                buildForgetPasswordText(context),
                SizedBox(height: 40.0),
                buildLoginButton(context),
                SizedBox(height: 30.0),
                //buildOtherLoginText(),
                //buildOtherMethod(context),
                buildRegisterText(context),
              ],
            )
  */

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
                '账号密码登录  ',
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {
                //TODO 跳转到注册页面
                print('验证码登录');
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new LoginPage()),
                );
              },
            ),
            Text('没有账号？'),
            GestureDetector(
              child: Text(
                '点击注册',
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {
                //TODO 跳转到注册页面
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
    print("手机号码");
    print(mobile);
    var _param = {'mobile':mobile};
    var response = await NetUtils.get(Api.SEND_VERIFY_CODE,params: _param);
    DialogUtil.showDialogWarning(response, context);
  }

  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 40.0,
        width: 290.0,
        child: RaisedButton(
          child: Text(
            '登 录',
            style: AppText.Title_Size_Big_White,
          ),
//          color: new Color(DialogUtil.color),
          onPressed: () {
            submit();
          },
        ),
      ),
    );
  }

  Padding buildForgetPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: FlatButton(
          child: Text(
            '点击获取验证码',
            style: TextStyle(fontSize: 14.0, color: Colors.green),
          ),
          onPressed: () {
            sendVerifyCode();
          },
        ),
      ),
    );
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _password = value,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入验证码';
        }
      },
      decoration: InputDecoration(
          labelText: '验证码',
        prefixIcon: Icon(
          Icons.lock,
          color: _eyeColor,
        ),
      ),
    );
  }

  TextFormField buildEmailTextField() {
    return TextFormField(
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
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

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '登录',
        style: TextStyle(fontSize: 42.0),
      ),
    );
  }
}