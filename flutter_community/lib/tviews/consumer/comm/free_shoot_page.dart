import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:helloworld/common/style.dart';
import 'package:helloworld/components/first_page_item.dart';
import 'package:helloworld/main.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/consumer/comm/communicate_page.dart';
import 'package:helloworld/utils/dialog.dart';
import 'package:helloworld/utils/util_index.dart';
import '../../../common/net_utils.dart';
import 'package:helloworld/utils/base_utils.dart';
import 'package:image_picker/image_picker.dart';

const int ThemeColor = 0xFFF5534B;

const int backgroundColor = 0xFFFFFFFF;

class FreeShootPage extends StatefulWidget {
  @override
  _FreeShootPageState createState() => _FreeShootPageState();
}

class _FreeShootPageState extends State<FreeShootPage>{
  FirstPageItem item;
  List<Widget> shootWidget = [];
  List<File> images = [];

  List<Widget> _typeList = [];
  var _param  = {'code':''};
  List types = [];
  var type = {'name':'问题分类','code':''};
  var _typeName = '问题分类';
  String willType = '';
  String title = '';
  String content = '';
  final _formKey = GlobalKey<FormState>();

  bool isSubmit = false;
  @override
  void initState() {
    super.initState();

  }

  submit() async {
    _formKey.currentState.save();
    if(title==''){
      DialogUtil.showDialogWarning("标题不能为空", context);
      return ;
    }
    if(content==''){
      DialogUtil.showDialogWarning("内容不能为空", context);
      return ;
    }

    var imageStr = [];
    if(images.length > 0){
      var image = await NetUtils.uploadFile(images);
      for(var i = 0;i<image.length;i++){
        imageStr.add(image[i]['url']);
      }
    }


    var _param = {'willType':type['code'],'title':title,'content':content,'image':json.encode(imageStr)};
    print(_param);
    isSubmit = true;
    var response = await NetUtils.post(Api.SEND_WILLRECORD,params: _param);
    if(response==null||response==''){
      DialogUtil.showDialogWarning("网络超时，请稍后重试", context);
      isSubmit = false;
    }else{
      if(response.statusCode==200){
        BaseUtils.showToast("发送成功，页面即将跳转...");
        new Timer(new Duration(seconds: 3), () {
          Navigator.pop(context);
        });
      }else{
        DialogUtil.showDialogWarning("发送失败，请稍后重试", context);
        isSubmit = false;
      }
    }
  }

  Future showAreaDialog(BuildContext context) async {
    setState(() {
      _typeList = [];
      buildTypeList();
    });
  }

  void changeType(String code,String name){
    setState(() {
      this._typeName = name;
      this.type['name'] = name;
      this.type['code'] = code;
    });
  }

  Future<Widget> buildTypeList() async {

    _param['code'] = '';
    var response = await NetUtils.get(Api.TYPE_LIST,params: _param);
    types = response;
    for(int i=0;i<types.length;i++){
      String name = types[i]['name'];
      String code = types[i]['code'];
      _typeList.add(
          new SimpleDialogOption(
            child: new Container(
              padding: EdgeInsets.only(top:5.0,bottom: 5.0),
              child: Text(name,style: AppText.SubTitle_Size_Medium,textAlign: TextAlign.left,),
            ),
            onPressed: () {
              changeType(code,name);
              Navigator.of(context).pop();
            },
          )
      );
    }

    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          title: new Text('请选择'),
          children: <Widget>[
            new Column(
              children: _typeList,
            )
          ],
        );
      },
    );
  }

  Future getImage() async {
    if(shootWidget.length >= 3){
      BaseUtils.showToast('最多添加3张图片');
      return;
    }

    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    images.add(image);
    setImage();
  }

  setImage(){
    shootWidget = [];
    var width = MediaQuery.of(context).size.width;
    for(var i = 0;i<images.length;i++){
      var wiget = GestureDetector(onLongPress:(){
        BaseUtils.showConfirm(context,'是否确认移除此图片',(){
          setState((){
            shootWidget.removeAt(i);
            images.removeAt(i);
            setImage();
          });
        });
      },child:Container(padding:EdgeInsets.only(left: 5.0),child: Image.file(images[i],width: width / 3 - 10,),));

      setState(() {
        shootWidget.add(wiget);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('随手拍问题反馈'),
          flexibleSpace: Image(
            image: AssetImage(Utils.getImgPath('home_top')),
            fit: BoxFit.cover,
          ),
          backgroundColor: Colors.transparent,
        ),
        body: new SingleChildScrollView(
          child: new ConstrainedBox(
            constraints: new BoxConstraints(
              minHeight: 120.0,
            ),
            child:Form(
              key: _formKey,
              child:new Container(
                child: new Column(
                  children: <Widget>[
                    new Container(
                      decoration:new BoxDecoration(color:Colors.white),
                      padding: EdgeInsets.only(top: 10.0),
                      child: new Column(
                        children: <Widget>[
                          new Container(
                              child:new Column(
                            children: <Widget>[
                              new ListTile(
                                contentPadding: EdgeInsets.only(left: 20.0,top: 0.0,right: 20.0),
                                title: new Text('${_typeName}',
                                  style: AppText.Title_Size_Medium,
                                ),
                                onTap: (){
                                  showAreaDialog(context);
                                },
                                trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 30.0),
                              ),
//                              SizedBox(height: 10.0,),
                              Divider(height: 1.0,color: AppColor.borderColor,),
                              SizedBox(height: 10.0,),
                              Padding(
                                padding: EdgeInsets.only(left: 5.0,right: 5.0),
                                child: new TextField(
                                  decoration: const InputDecoration(
                                    hintText: '请输入问题标题',
                                    contentPadding: const EdgeInsets.all(10.0),
                                  ),
                                  maxLength: 30,
                                  // 当 value 改变的时候，触发
                                  onChanged: (val) {
                                    title = val;
                                  },
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          )),
                        ],
                      )),
                    SizedBox(
                      height: 10.0,
                    ),

                    Container(
                      child: Align(
                      alignment: Alignment.centerLeft,
                      child:new Row(
                        children: shootWidget,
                      ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    new Container(
                      decoration:new BoxDecoration(color:Colors.white),
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.0,right: 5.0),
                        child: new TextField(
                          decoration: const InputDecoration(
                            hintText: '请输入您反馈的问题内容详情',
                            contentPadding: const EdgeInsets.all(10.0),
                          ),
                          maxLength: 500,
                          // 当 value 改变的时候，触发
                          onChanged: (val) {
                            content = val;
                          },
                          maxLines: 5,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    Align(
                      child: SizedBox(
                        height: 45.0,
                        width: MediaQuery.of(context).size.width - 40,
                        child: RaisedButton(
                          color: Colours.app_main,
                          child: Text(
                            '提交反馈',
                            style: AppText.Title_Size_Big_White,
                          ),
//                          color: new Color(DialogUtil.color),
                          onPressed: () {
                            if(!isSubmit) {
                              submit();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  Future<String> article() async{
    var response = await NetUtils.get(Api.ARTICLE_DETAIL+item.id);
    return response['article']['content'];
  }
}


