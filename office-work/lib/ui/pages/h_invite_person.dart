
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wanandroid/blocs/bloc_index.dart';
import 'package:flutter_wanandroid/common/component_index.dart';

//添加邀请居民代表
class InvitePerson extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _InvitePersonPage();
  }

}

class _InvitePersonPage extends State<InvitePerson>{

  WorkBloc _workBloc ;
  GlobalKey<FormState> _SignInFormKey = new GlobalKey();

  String _realname,_mobile;

  bool enableButton = true;

  @override
  void initState() {
    super.initState();
    _workBloc = BlocProvider.of<WorkBloc>(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('邀请居民'),
        ),
        body: SingleChildScrollView(
            child: Container(
//          margin: EdgeInsets.only(top:50.0,left: 10.0,right: 10.0),
              padding: EdgeInsets.only(top:50.0,left: 10.0,right: 10.0,bottom: 50.0),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  buildTextForm(),
                  SizedBox(height: 30.0,),
                  buildSignInButton(context)
                ],
              ),
            )
        )
    );
  }

  Widget buildSignInButton(context) {

    return Row(
      children: <Widget>[
        Expanded(
            child: RoundButton(
              margin: EdgeInsets.all(50),

//              color: enableButton?Colors.blue:Colours.text_gray,
//              textColor: Colors.white,
//              shape : const RoundedRectangleBorder(
//                  side: BorderSide.none,
//                  borderRadius: BorderRadius.all(Radius.circular(50))),
              text:'发送邀请',
//              Text('发 送 邀 请',style: TextStyle(fontSize: Dimens.font_sp18),),
              onPressed: () {
                if(enableButton) {
                  var _form = _SignInFormKey.currentState;
                  _form.save();
                  if (!RegexUtil.isMobileSimple(_mobile)) {
                    Fluttertoast.showToast(msg: '请输入正确的手机号');
                    return;
                  }
                  if (_realname == null || _realname
                      .trim()
                      .length <= 0) {
                    Fluttertoast.showToast(msg: '请输入真实姓名');
                    return;
                  }

                  setState((){
                    enableButton = false;
                  });

                  _workBloc.invitePerson(
                      context, mobile: _mobile, realname: _realname).then((_){
                    Fluttertoast.showToast(msg: '邀请成功');
                    Navigator.pop(context);
                  }).catchError((_){
                    Fluttertoast.showToast(msg: _.message);
                    setState((){
                      enableButton = true;
                    });
                  });
                }
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
                    left: 15, right: 15, top: 20, bottom: 10),
                child: new TextFormField(
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
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 20),
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
                ),
              ),
            ),
          ],
        ),),
    );
  }

}