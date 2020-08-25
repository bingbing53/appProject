/*
 * Created by 王振宇 on 2019/3/12.
 */

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:helloworld/common/net_utils.dart';
import 'package:helloworld/common/style.dart';
import 'package:helloworld/main.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/consumer/comm/free_shoot_page.dart';
import 'package:helloworld/tviews/consumer/login/login_base_page.dart';
import 'package:helloworld/tviews/consumer/login/select_org_page.dart';
import 'package:helloworld/tviews/widget/widget_index.dart';
import 'package:helloworld/utils/dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

//const int color = 0xFFF5534B;

class AddPersoninfoPage extends StatefulWidget {
  @override
  _AddPersoninfoPageState createState() => _AddPersoninfoPageState();

  String nickName = "";

  final Function selectCallback;

  AddPersoninfoPage({
    this.selectCallback,
  });
}

class _AddPersoninfoPageState extends State<AddPersoninfoPage> with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();
  String nickName;
  int _genderController = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

//  Future<File> _imageFile;
//  AsyncSnapshot<File> _snapshot;

  File imageData;

  void _selectedImage() async {
    imageData = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
    });
  }

  Widget _previewImage() {
    if(imageData != null)
      return ClipOval(
        child: new Image.file(imageData,height: 60,width: 60,fit:BoxFit.fitWidth)
      );
    else
      return new Image.asset(
              'assets/images/camera.png',
              width: 60.0,
              height: 60.0,
      );
  }

  Future save() async {
    _formKey.currentState.save();
    String sex = '0';
    if(_genderController==2){
      sex = '1'; // 女
    }

    List<File> file = [];
    var imageUrl = '';
    if(null != imageData) {
      file.add(imageData);
      var image = await NetUtils.uploadFile(file);
      if(image != null && image.length > 0){
        imageUrl = image[0]['url'];
      }
    }
    var _param = {
      'imgUrl':imageUrl,
      'nickName':nickName,
      'sex':sex
    };
    print(_param);
    var response = await NetUtils.post(Api.SAVE_PERSON_INRO,params: _param);
    if(response!=null){
      String isSuccess = response['isSuccess'];
      if('success'==isSuccess){
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => SelectOrgPage()),
        );
      }else{
        DialogUtil.showDialogWarning("保存信息失败，请稍后重试", context);
      }
    }else{
      DialogUtil.showDialogWarning("网络超时，请稍后重试", context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('个人信息'),
      ),
      body: new SingleChildScrollView(
        child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(bottom: 50),
            child: Form(
              key: _formKey,
              child: new Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '为自己取个名字吧',
                        style: TextStyle(fontSize: Dimens.font_sp18),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        foregroundDecoration: BoxDecoration(
                          color: Colors.white.withOpacity(imageData!=null?0.0: 0.7),
                        ),
                        child:GestureDetector(
                          onTap: (){
                            _selectedImage();
                          },
                          child: _previewImage(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0,left: 40.0,right: 40.0),
                    child: TextFormField(
                      onSaved: (String value) => nickName = value,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '请输入昵称';
                        }
                      },
                      decoration: InputDecoration(
                        labelText: '请输入昵称',
                      ),
                    ),
                  ),
                  new Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 50.0,left: 115.0),
                        child: GestureDetector(
                          onTap: (){
                            // 选择男人时返回1并更新组件。
                            setState(() {
                              _genderController = 1;
                              //widget.selectCallback(_genderController);
                            });
                          },
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                _genderController == 1
                                    ? 'assets/images/male_select.png'
                                    : 'assets/images/male.png',
                                fit: BoxFit.contain,
                                width: 40.0,
                              ),
                              Text(
                                '男',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: _genderController == 1
                                      ? Color(0xFF25C6CA)
                                      : Color(0xFF4A4A4A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 50.0,left: 60.0),
                        child: GestureDetector(
                          onTap: (){
                            // 选择女人时返回2并更新组件。
                            setState(() {
                              _genderController = 2;
                              //widget.selectCallback(_genderController);
                            });
                          },
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                _genderController == 2
                                    ? 'assets/images/female_select.png'
                                    : 'assets/images/female.png',
                                fit: BoxFit.contain,
                                width: 40.0,
                              ),
                              Text(
                                '女',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: _genderController == 2
                                      ? Color(0xFFFF6B47)
                                      : Color(0xFF4A4A4A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  RoundButton(
                    bgColor: Colours.app_main,
                    radius:5,
                    width: MediaQuery.of(context).size.width - 70,
                    text: '确 定',
                    height: 40,
                    style: TextStyle(color: Colors.white),
                    onPressed: (){
                      save();
                    },
                  ),
                ],
              ),
            )
          ),
      )
    );
  }
}