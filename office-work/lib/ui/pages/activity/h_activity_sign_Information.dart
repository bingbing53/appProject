import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_wanandroid/blocs/bloc_index.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/common/component_index.dart' as prefix1;
import 'package:flutter_wanandroid/main.dart' as prefix0;
import 'package:flutter_wanandroid/ui/dialog/simple_dialog.dart';
import 'package:flutter_wanandroid/utils/idcard_utils.dart';
import 'package:flutter/services.dart';
// base64库
import 'dart:convert' as convert;
import 'dart:convert';

class  ActivitySignInformationsPages extends StatefulWidget {

  final String activityId;

  const ActivitySignInformationsPages({Key key,this.activityId}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new _ActivitySignInformations();
  }
}

class _ActivitySignInformations extends State<ActivitySignInformationsPages>{
  WorkBloc workBloc;
  ReadidCardModel re;

  List<PickerItem> nationlPickerItem = [];
  List<PickerItem> polityPickerItem = [];
  List national,polity;

  TextEditingController _controllerName = new TextEditingController();
  TextEditingController _controllerIdCard = new TextEditingController();
  TextEditingController _controllerPhone = new TextEditingController();
  TextEditingController _controllerAddress = new TextEditingController();
  TextEditingController _controllerUnit = new TextEditingController();
  TextEditingController _controllerHouse = new TextEditingController();

  @override
  void initState() {
    super.initState();

    initDevice();

    workBloc = BlocProvider.of<WorkBloc>(context);
    workBloc.threeLevelLinkageModelList();
    Map<String,String> map =<String,String>{
     'name':'',
     'sex':'',
     'birthday':'',
     'national':'',
     'address':'',
     'idcard':'',
     'issued':'',
     'startData':'',
     'endData':'',
     'image':'',
    };
    re = ReadidCardModel.fromJson(map);

    workBloc.getDictionaryList("national,polity").then((result){
      national = result['national'];
      for(var i = 0;i<national.length;i++){
        nationlPickerItem.add(PickerItem(text: Text('${national[i]['typename']}',style: TextStyle(fontSize: Dimens.font_sp14)),value: '${jsonEncode(national[i])}'));
      }

      polity = result['polity'];
      for(var i = 0;i<polity.length;i++){
        polityPickerItem.add(PickerItem(text: Text('${polity[i]['typename']}',style: TextStyle(fontSize: Dimens.font_sp14)),value: '${jsonEncode(polity[i])}'));
      }

      setState(() {});

    });


  }

  Future initDevice() async{
    bool init = await IDCardUtils.initDevice();
    if(init && Platform.isIOS){
      Fluttertoast.showToast(msg: "蓝牙读卡器连接成功");
    }else if(!init && Platform.isIOS){
      Fluttertoast.showToast(msg: "蓝牙读卡器连接失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      appBar: AppBar(
        title: Text('录入签到人信息'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(left: 10,right: 10),
          color: Colors.white,
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Container(
                            child: Row(
                              children: <Widget>[
                                Container(child:Text('姓名',style: TextStyle(color: Colours.text_normal)),width:80,alignment: Alignment.centerLeft,),
                                Expanded(
                                  child: TextField(
                                    controller: _controllerName,
                                    maxLines: 1,
                                    autofocus: false,
                                    style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
                                    textInputAction: TextInputAction.next,
                                    decoration: new InputDecoration(
                                        hintText: "真实姓名",
                                        hintStyle:TextStyle(fontSize: Dimens.font_sp16)
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                        Container(
                            child: Row(
                              children: <Widget>[
                                Container(child:Text('身份证',style: TextStyle(color: Colours.text_normal)),width:80,alignment: Alignment.centerLeft,),
                                Expanded(
                                  child: TextField(
                                    controller: _controllerIdCard,
                                    maxLines: 1,
                                    autofocus: false,
                                    style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
                                    textInputAction: TextInputAction.next,
                                    decoration: new InputDecoration(
                                        hintText: "身份证",
                                        hintStyle:TextStyle(fontSize: Dimens.font_sp16)
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                  ),
                  re.image != '' ? image(
                    base64: '${re.image}',
                    source:'${re.image}',
                  ):new Container(
                      width: 100.0,
                      height: 123.0,
                      decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          Utils.getImgPath('idcard_icon'),
                        ),
                      )
                    )
                  )
                ],
              ),
              Container(
                  child: Row(
                    children: <Widget>[
                      Container(child:Text('户籍地址',style: TextStyle(color: Colours.text_normal)),width:80,alignment: Alignment.centerLeft,),
                      Expanded(
                        child: TextField(
                          controller: _controllerAddress,
                          maxLines: 1,
                          autofocus: false,
                          style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
                          textInputAction: TextInputAction.next,
                          decoration: new InputDecoration(
                              hintText: "户籍地址",
                              hintStyle:TextStyle(fontSize: Dimens.font_sp16)
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(height:10),
              Container(
                  child: Row(
                    children: <Widget>[
                      Container(child:Text('民族',style: TextStyle(color: Colours.text_normal)),width:80,alignment: Alignment.centerLeft,),

                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Container(padding:EdgeInsets.only(top: 5,bottom: 5),child: Text(ObjectUtil.isEmpty(re.nationalName)?'点击选择民族':re.nationalName),),
                        onTap: (){
                          Picker(
                              adapter: PickerDataAdapter(
                                  data: nationlPickerItem
                              ),
                              hideHeader: true,
                              title: Text("请选择民族"),
                              confirmText: '确认',
                              cancelText: '取消',
                              selectedTextStyle: TextStyle(color: Colors.blue),
                              onConfirm: (Picker picker, List value) {
                                if(ObjectUtil.isNotEmpty(picker.getSelectedValues()) && picker.getSelectedValues().length > 0){
                                  re.national = jsonDecode(picker.getSelectedValues()[0])['typecode'];
                                  re.nationalName = jsonDecode(picker.getSelectedValues()[0])['typename'];
                                  setState((){});
                                }
                              }
                          ).showDialog(context);
                        },
                      ),
                    ],
                  )
              ),
              SizedBox(height:10),
              Container(
                  child: Row(
                    children: <Widget>[
                      Container(child:Text('政治面貌',style: TextStyle(color: Colours.text_normal)),width:80,alignment: Alignment.centerLeft,),
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        child: Container(padding:EdgeInsets.only(top: 5,bottom: 5),child: Text(ObjectUtil.isEmpty(re.polityName)?'点击选择政治面貌':re.polityName),),
                        onTap: (){
                          Picker(
                              adapter: PickerDataAdapter(
                                  data: polityPickerItem
                              ),
                              hideHeader: true,
                              title: Text("请选择政治面貌"),
                              confirmText: '确认',
                              cancelText: '取消',
                              selectedTextStyle: TextStyle(color: Colors.blue),
                              onConfirm: (Picker picker, List value) {
                                if(ObjectUtil.isNotEmpty(picker.getSelectedValues()) && picker.getSelectedValues().length > 0){
                                  re.polity = jsonDecode(picker.getSelectedValues()[0])['typecode'];
                                  re.polityName = jsonDecode(picker.getSelectedValues()[0])['typename'];
                                  setState((){});
                                }
                              }
                          ).showDialog(context);
                        },
                      )
                    ],
                  )
              ),
              SizedBox(height:10),
              Container(
                  child: Row(
                    children: <Widget>[
                      Container(child:Text('手机号',style: TextStyle(color: Colours.text_normal)),width:80,alignment: Alignment.centerLeft,),
                      Expanded(
                        child: TextField(
                          controller: _controllerPhone,
                          maxLines: 1,
                          autofocus: false,
                          style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
                          textInputAction: TextInputAction.next,
                          decoration: new InputDecoration(
                              hintText: "手机号",
                              hintStyle:TextStyle(fontSize: Dimens.font_sp16)
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              SizedBox(height:15),
              Divider(),
              Container(
                child:Text('居住地址',style: TextStyle(fontSize:Dimens.font_sp16,color: Colours.text_normal),),
              ),
              Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            //一级联动
                            StreamBuilder(
                              stream: workBloc.ThreeLevellLinkageOneModelListReposStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<ThreeLevellLinkageOneModel>> snapshot){
                                if(ObjectUtil.isEmpty(snapshot.data) || snapshot.data.length <= 0){
                                  return Container(height: 0);
                                }
                                List<ThreeLevellLinkageOneModel> oneCitys=snapshot.data;
                                return buildItem(oneCitys);
                              },
                            ),
                            //二级联动
                            StreamBuilder(
                              stream: workBloc.ThreeLevellLinkageTwoModelListReposStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<ThreeLevellLinkageTwoModel>> snapshot){
                                if(ObjectUtil.isEmpty(snapshot.data) || snapshot.data.length <= 0){
                                  return Container(height: 0);
                                }
                                List<ThreeLevellLinkageTwoModel> twoCitys=snapshot.data;
                                return buildSecondItem(twoCitys);
                              },
                            ),
                            StreamBuilder(
                              stream: workBloc.ThreeLevellLinkageThreeModelListReposStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<ThreeLevellLinkageThreeModel>> snapshot){
                                if(ObjectUtil.isEmpty(snapshot.data) || snapshot.data.length <= 0){
                                  return Container(height: 0);
                                }
                                List<prefix1.ThreeLevellLinkageThreeModel> twoCitys=snapshot.data;
                                return buildThirdItem(twoCitys);
                              },
                            ),
                          ],
                        )
                      ),
                    ],
                  )
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child:Container(
                        child: Row(
                          children: <Widget>[
                            Container(child:Text('单元号',style: TextStyle(color: Colours.text_normal)),width:50,alignment: Alignment.centerLeft,),
                            Expanded(
                              child: TextField(
                                controller: _controllerUnit,
                                maxLines: 1,
                                autofocus: false,
                                style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
                                textInputAction: TextInputAction.next,
                                decoration: new InputDecoration(
                                    hintText: "单元号",
                                    hintStyle:TextStyle(fontSize: Dimens.font_sp16)
                                ),
                              ),
                            ),
                          ],
                        )
                    ),
                    flex:1
                  ),
                  Expanded(
                      child:Container(
                          child: Row(
                            children: <Widget>[
                              Container(child:Text('房号',style: TextStyle(color: Colours.text_normal)),width:50,alignment: Alignment.centerLeft,),
                              Expanded(
                                child: TextField(
                                  controller: _controllerHouse,
                                  maxLines: 1,
                                  autofocus: false,
                                  style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
                                  textInputAction: TextInputAction.next,
                                  decoration: new InputDecoration(
                                      hintText: "房号",
                                      hintStyle:TextStyle(fontSize: Dimens.font_sp16)
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                      flex:1
                  ),
                ],
              ),
              SizedBox(height:100),
            ],
          ),
        ),
      ),
      bottomNavigationBar:buildBottomNavigation(),
    );
  }

  bool canReadCard = true;
  Widget buildBottomNavigation(){
    return Container(
        height: 50.0,
        decoration: new BoxDecoration(
            color: Colors.white,
            border: new Border(top: BorderSide(color: Colours.divider,width: 0.2))
        ),
        child: Row(
          children: <Widget>[
            Expanded(
                child:InkWell(
                  child: Text('退出签到',textAlign: TextAlign.center,style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold),),
                  onTap: () {
                    Navigator.pop(context);
                  },
                )
            ),
            Expanded(
                child:InkWell(
                  child: Text('读卡',textAlign: TextAlign.center,style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: Dimens.font_sp16)),
                  onTap: () {
                    if(!canReadCard) return;
                    canReadCard = false;
                    CommonUtils.showLoadingDialog(context,msg: '请放置身份证');

                    _controllerName.text = '';
                    _controllerIdCard.text = '';
                    _controllerAddress.text = '';
                    _controllerUnit.text = '';
                    _controllerHouse.text = '';
                    _controllerPhone.text = '';
                    value = null;
                    value2 = null;
                    value3 = null;

                    welfareUserInfo = null;

                    Map<String,String> map =<String,String>{
                      'name':'',
                      'sex':'',
                      'birthday':'',
                      'national':'',
                      'address':'',
                      'idcard':'',
                      'issued':'',
                      'startData':'',
                      'endData':'',
                      'image':'',
                    };
                    re = ReadidCardModel.fromJson(map);

                    setState((){});

                    //调用接口获取后台的人口信息
                    IDCardUtils.read().then((value){
                      //签到人员数据详情
                      re = ReadidCardModel.fromJson(value['data']);//=>_$ReadidCardModel(json);

                      _controllerName.text = re.name;
                      _controllerIdCard.text = re.idcard;
                      _controllerAddress.text = re.address;
                      _controllerUnit.text = re.unitNo;
                      _controllerHouse.text = re.houseNo;


                      if(ObjectUtil.isNotEmpty(re.nationalName)){
                        for(var i = 0;i<national.length;i++) {
                          if(national[i]['typename'] == re.nationalName){
                              re.nationalName = national[i]['typename'];
                              re.national = national[i]['typecode'];
                          }
                        }
                      }

                      workBloc.getWelfareUserInfos(re.idcard).then((value){
                          if(!ObjectUtil.isEmptyList(value) && value.length == 1){
                            setFormValue(value[0]);
                          }else if(!ObjectUtil.isEmptyList(value) && value.length > 1){
                            List<String> choises = [];
                            for(var i = 0;i<value.length;i++){
                              choises.add('${value[i].realname} ${value[i].mobile}');
                            }
                            CommonUtils.showModalActionSheet(context, "请选择一个志愿者", choises, (index){
                              setFormValue(value[index]);
                            });
                          }
                      });

                      setState(() {});
                    }).catchError((_){
                      print('error---$_');
                      Fluttertoast.showToast(msg: '身份证信息读取失败');
                    }).whenComplete((){
                      Navigator.pop(context);
                      canReadCard = true;
                    });
                  },
                )
            ),
            Expanded(
                child:InkWell(
                  child:Text('提交签到',textAlign: TextAlign.center,style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                  onTap: () async {
                      submitSign();
                  }
                )
            ),
          ],
        )
    );
  }

  //提交签到信息
  void submitSign() async{
      if(welfareUserInfo == null){
        welfareUserInfo = WelfareUserInfoModel.fromJson({});
      }

      if(ObjectUtil.isEmpty(welfareUserInfo.userId) || ObjectUtil.isEmpty(welfareUserInfo.image)){
        List<ImageFileData> imageFileData = await workBloc.uploadBase64Image(re.image);
        if(!ObjectUtil.isEmptyList(imageFileData)){
            welfareUserInfo.image = imageFileData[0].url;
        }
      }

      welfareUserInfo.realname = _controllerName.text;
      welfareUserInfo.mobile = _controllerPhone.text;
      welfareUserInfo.idcard = _controllerIdCard.text;
      welfareUserInfo.buildingId = value3;
      welfareUserInfo.houseNo = _controllerHouse.text;
      welfareUserInfo.unitNo = _controllerUnit.text;
      welfareUserInfo.national = re.national;
      welfareUserInfo.polity = re.polity;
      welfareUserInfo.address = re.address;

      CommonUtils.showLoadingDialog(context,msg: '签到中');
      workBloc.submitActivitySign(widget.activityId, welfareUserInfo).then((value){
        Fluttertoast.showToast(msg: '签到成功');
        Navigator.pop(context);
      }).catchError((_){
        Navigator.pop(context);
        Fluttertoast.showToast(msg: '${_.message}');
        //SimpleDialogUtil.showModalBottom(context, Text('${_.message}111'), '错误提示');//.showDialogs(context,'错误提示',_.message);

      }).whenComplete((){
        //Navigator.pop(context);
      });
  }

  WelfareUserInfoModel welfareUserInfo;

  void setFormValue(WelfareUserInfoModel welfareUser){
    welfareUserInfo = welfareUser;
    //手机号
    _controllerPhone.text = welfareUser.mobile;
    value = welfareUser.orgCode;

    workBloc.threeLevelLinkageTwoModelList(value).then((value){
      value2 = welfareUser.villageId;
      workBloc.threeLevelLinkageThreeModelList(value2).then((v){
          value3 = welfareUser.buildingId;
      });
    });

    print(welfareUser.toJson());
    if(ObjectUtil.isNotEmpty(welfareUser.polity)){
      for(var i = 0;i<polity.length;i++) {
        print(polity[i]['typecode']);
        print(welfareUser.polity);
        if(polity[i]['typecode'] == welfareUser.polity){
          re.polity = polity[i]['typecode'];
          re.polityName = polity[i]['typename'];
          break;
        }
      }
    }

    _controllerUnit.text = welfareUser.unitNo;
    _controllerHouse.text = welfareUser.houseNo;

    setState((){});

  }

  var value;
  Widget buildItem(List<ThreeLevellLinkageOneModel> cityOnelinkage) {
    return new DropdownButton<String>( //下拉列
      value: value,// 表
      isExpanded: true,
      hint:Text('请选择社区',style:TextStyle(fontSize:Dimens.font_sp14)),
      items: cityOnelinkage.map((ThreeLevellLinkageOneModel value) {
        return new DropdownMenuItem<String>( //下拉项
          value: value.id,//下拉项值
          child: new Text(value.name,style: TextStyle(fontSize: Dimens.font_sp14)),//下拉项显示内容
        );
      }).toList(),
      onChanged: (value1) {
        setState(() {
          value=value1;
          value2 = null;
          value3 = null;
        });
        workBloc.threeLevelLinkageTwoModelList(value);
        workBloc.threeLevelLinkageThreeModelList('',init:true);
      },
    );
  }
  var value2;
  Widget buildSecondItem(List<ThreeLevellLinkageTwoModel> cityTwolinkage) {
    return new DropdownButton<String>( //下拉列
      value: value2,// 表
      isExpanded: true,
      hint:Text('请选择小区',style:TextStyle(fontSize:Dimens.font_sp14)),
      items: cityTwolinkage.map((item){
        return DropdownMenuItem(
          value: item.id,//下拉项值
          child: new Text(item.name,style: TextStyle(fontSize: Dimens.font_sp14)),
        );
    }).toList(),
      onChanged: (value) {
        value2 = value;
        value3 = null;
        setState(() {
        });
        workBloc.threeLevelLinkageThreeModelList(value);
      },
    );
  }

  var value3;
  Widget buildThirdItem(List<ThreeLevellLinkageThreeModel> cityThirdlinkage) {
    return new DropdownButton<String>( //下拉列
      value: value3,// 表
      isExpanded: true,
      hint:Text('请选择楼宇',style:TextStyle(fontSize:Dimens.font_sp14)),
      items: cityThirdlinkage.map((item){
        return DropdownMenuItem(
          value: item.id,//下拉项值
          child: new Text(item.name,style: TextStyle(fontSize: Dimens.font_sp14)),
        );
      }).toList(),
      onChanged: (value) {
        value3 = value;
        setState(() {

        });
      },//on change事件
    );
  }
}


// ignore: camel_case_types
class image extends StatefulWidget {
  /// base资源，已处理的
  final String source;
  /// 未处理的base64资源
  final String base64;
  /// 图像宽度
  final double width;
  /// 图像高度
  final double height;
  /// 缩放比例
  final double scale;
  image({
    Key key,
    this.source,
    this.base64,
    this.height: 123.0,
    this.width: 100.0,
    this.scale: 1.0,
  }) : super(key: key);

  @override
  _Base64ImageState createState() => _Base64ImageState();
}

class _Base64ImageState extends State<image> {
  Uint8List _source;
  @override
  void initState() {
    super.initState();
  }

  @override
  //页面加载就会调用build
  Widget build(BuildContext context) {
    String source = widget.source.trim().replaceAll("\n", "");
    print(source);
    try {
      _source = convert.base64.decode(source);
    }catch(err){
      return new Container(
          width: 100.0,
          height: 123.0,
          decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  Utils.getImgPath('idcard_icon'),
                ),
              )
          )
      );
    }
    return Image.memory(
      _source,
      height: widget.height,
      width: widget.width,
      scale: widget.scale,
    );
  }
}
