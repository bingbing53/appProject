/*
 * Created by 王振宇 on 2019/3/12.
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:helloworld/common/net_utils.dart';
import 'package:helloworld/common/style.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/consumer/comm/free_shoot_page.dart';
import 'package:helloworld/tviews/consumer/comm/leader_mailbox_page.dart';
import 'package:helloworld/tviews/consumer/consumer_page_index.dart';
import 'package:helloworld/tviews/consumer/login/login_base_page.dart';
import 'package:helloworld/tviews/consumer/login/select_org_page.dart';
import 'package:helloworld/utils/dialog.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'package:helloworld/utils/util_index.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:helloworld/utils/base_utils.dart';

const String text1 =
"""为提高居民投诉处理效率，请率先在街道、社区反馈您的意见和建议，街道处理不了会及时反馈上级领导部门为您解决""";
const int color = 0xFFF5534B;

class CommunicatePage extends StatefulWidget {
  @override
  _CommunicatePageState createState() => _CommunicatePageState();
}

class _CommunicatePageState extends State<CommunicatePage> with AutomaticKeepAliveClientMixin {

  var streetText = '街道直拨热线';
  var commText = '拨打社区电话';
  var streetPhone = "";
  var commPhone = "";
  var streetName = "";
  var _param = {'code':''};
  var code = "";
  var baseInfo = {};
  var count = "0";
  var dealCount = "0";

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  bool get wantKeepAlive => true;

  Future getInfo() async {
      code = SpUtil.getString(SharedPreferencesKeys.sysOrgCode,defValue: '');
      _param['code'] = code;
      var response = await NetUtils.get(Api.BASE_INFO,params: _param);
      print(response);
      setState((){
        streetPhone = response[0]['streetPhone'];
        commPhone = response[0]['commPhone'];
        streetName = response[0]['streetName'];
        if(streetName==null||streetName==''||streetName=='null'){
          streetName = '';
        }
        count = response[0]['count'];
        dealCount = response[0]['dealCount'];

        //streetText = streetText + streetPhone;
        //commText = commText + commPhone;
        baseInfo = response[0];
      });
  }

  void callPhone(String phone){
    if(null!=phone&&phone!=''){
      var url = 'tel:' + phone;
      launch(url); 
    }else{
      BaseUtils.showToast("暂未设置电话");
    }
  }

  void showDialogWarning(String text){
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
            child: Container(
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(text),
                  RaisedButton(
//                    color: new Color(color),
                    child: Text('确定'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            )
        );
      },
    );
  }

  //是否正在加载中
  bool freeShoot = false;
  Future toFree2Shoot({type}) async {
    if(freeShoot) return;
    try {
      freeShoot = true;
      var login = await BaseUtils.getLoginState(context);
      if (!login) {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new LoginPage()),
        );
        return;
      }
      if (type == 1) {
        Navigator.push(
            context, new MaterialPageRoute(builder: (BuildContext context) {
          return new FreeShootPage();
        }));
      } else if (type == 2) {
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => new LeaderMailboxPage()),
        );
      }
    }catch(err){
      print(err);
    }finally{
      freeShoot = false;
    }
  }

//  micphoneSendMessStart() async {
//
//    // Check permissions before starting
//    bool hasPermissions = await AudioRecorder.hasPermissions;
//
//    // Get the state of the recorder
//    bool isRecording = await AudioRecorder.isRecording;
//
//    // Start recording
//    await AudioRecorder.start(path: '/test', audioOutputFormat: AudioOutputFormat.AAC);
//
//  }
//  micphoneSendMessEnd() async{
//    // Stop recording
//    Recording recording = await AudioRecorder.stop();
//    print("Path : ${recording.path},  Format : ${recording.audioOutputFormat},  Duration : ${recording.duration},  Extension : ${recording.extension},");
//
//  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: new SingleChildScrollView(
        child: new Container(
              decoration: new BoxDecoration(color: Colors.white),
              child: new Column(
                children: <Widget>[
                  new Container(
                    child: new Stack(
                      //指定未定位或部分定位widget的对齐方式
                      alignment:Alignment.center,
                      children: <Widget>[
                        new Image.asset(
                          'assets/images/leader_email.png',        //图片的路径
                        ),
                        new Positioned(
                          left:10.0,
                          right: 35.0,
                          top: 35.0,
                          child:new Text('欢迎进入$streetName',style: AppText.SubTitle_Size_Big_White),
                        ),
                        new Positioned(
                          //left:20.0,
                          right: 10.0,
                          top: 20.0,
                          child:FlatButton(
                            child: new Text('换社区看看',style: AppText.Info_Size_Medium_White),
                            onPressed: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(builder: (context) => new SelectOrgPage()),
                              );
                            },
                          ),
                        ),
                        new Positioned(
                            top: 80.0,
                            child:new Text('共同监督  打造和谐社区',style: AppText.Title_Big)
                        ),
                        new Positioned(
                          left:20.0,
                          right:20.0,
                          top: 140.0,
                          child:new Card(
                            clipBehavior:Clip.antiAlias,// 根据设置裁剪内容
                            color:Colors.white, //  卡片背景颜色
                            elevation:2.0, // 卡片的z坐标,控制卡片下面的阴影大小
                            margin:EdgeInsets.symmetric(horizontal: 0.0,vertical: 10.0),
                            //  margin: EdgeInsetsDirectional.only(bottom: 30.0, top: 30.0, start: 30.0),// 边距
                            semanticContainer:true, // 表示单个语义容器，还是false表示单个语义节点的集合，接受单个child，但该child可以是Row，Column或其他包含子级列表的widget
                            shape:RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)), // 圆角
                            child: new Column(
                              children: <Widget>[
                                SizedBox(height: 10,),
                                new Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: new Image.asset(
                                          'assets/images/envelope.png',        //图片的路径
                                          height: 30.0, //图片控件的高度
                                          //fit: BoxFit.fill, //告诉引用图片的控件，图像应尽可能小，但覆盖整个控件。
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child:new Text('书记信箱',style: AppText.Title_Size_Big),
                                      flex: 2,
                                    ),
                                    Expanded(
                                      child: new Align(
                                        alignment: Alignment.centerRight,
                                        child: FlatButton(
                                          child: Text('给书记写信>',style: TextStyle(fontSize: 13.0, color: Colors.blue),
                                          ),
                                          onPressed: () {
                                            toFree2Shoot(type:2);
                                          },
                                        ),
                                      ),
                                      flex: 3,
                                    ),
                                  ],
                                ),
                                new Row(
                                  children: <Widget>[
                                    Expanded(
                                        child:new Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            '已收信件',
                                            style: TextStyle(fontSize: 13.0, color: Colors.grey),
                                          ),
                                        ),
                                        flex:1
                                    ),
                                    Expanded(
                                        child:new Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            '已处理',
                                            style: TextStyle(fontSize: 13.0, color: Colors.grey),
                                          ),
                                        ),
                                        flex:1
                                    ),
                                  ],
                                ),
                                new Row(
                                  children: <Widget>[
                                    Expanded(
                                        child:new Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            '$count',
                                            style: TextStyle(fontSize: 15.0, color: Colors.black),
                                          ),
                                        ),
                                        flex:1
                                    ),
                                    Expanded(
                                        child:new Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            '$dealCount',
                                            style: TextStyle(fontSize: 15.0, color: Colors.black),
                                          ),
                                        ),
                                        flex:1
                                    ),
                                  ],
                                ),
                                new Padding(padding: const EdgeInsets.only(bottom: 15.0),)
                              ],
                            ),
                          ),
                        ),
                        new Positioned(
                            top: 280.0,
                            child: Container(
                              color: Colors.white,
                            ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                      margin: EdgeInsets.only(top:20.0),
                      child: new Container(
                        //elevation: 8.0,  //设置阴影
                        //shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14.0))),  //设置圆角
                        child: new Column(  // card只能有一个widget，但这个widget内容可以包含其他的widget
                          children: [
                            new InkWell(
                                onTap: (){
                                  //callPhone(streetPhone);
                                },
                                child:new Row(
                                  children: <Widget>[
                                    new Padding(
                                      padding: const EdgeInsets.only(left: 20.0,top: 15.0,bottom: 15.0),
                                      child: new Icon(
                                        Icons.mobile_screen_share,
                                        color: Colours.text_gray,
                                        size: 20.0,
                                      ),
                                    ),
                                    new Padding(
                                        padding: const EdgeInsets.only(left: 10.0),
                                      child: new Text(streetText,
                                          style: AppText.Title_Size_Medium ),
                                    ),
                                    new Padding(
                                        padding: const EdgeInsets.only(right:10.0,left: 90.0),
                                      child: FlatButton(
                                        child: Text(
                                          streetPhone,
                                          style: AppText.Title_Size_Medium_Blue,
                                        ),
                                        onPressed: () {
                                          callPhone(streetPhone);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                            ),
                            new Divider(
                              height: 0.0,
                            ),
                            new InkWell(
                              onTap: (){

                              },
                              child:new Row(
                                children: <Widget>[
                                  new Padding(
                                    padding: const EdgeInsets.only(left: 20.0,top: 15.0,bottom: 15.0),
                                    child: new Icon(
                                      Icons.contact_phone,
                                      color: Colours.text_gray,
                                      size: 20.0,
                                    ),
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: new Text(commText,
                                        style: AppText.Title_Size_Medium ),
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(right:10.0,left: 90.0),
                                    child: FlatButton(
                                      child: Text(
                                        commPhone,
                                        style: AppText.Title_Size_Medium_Blue,
                                      ),
                                      onPressed: () {
                                        callPhone(commPhone);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            new Divider(
                              height: 0.0,
                            ),
                            new InkWell(
                              onTap: (){
                                toFree2Shoot(type: 1);
                              },
                              child:new Row(
                                children: <Widget>[
                                  Expanded(
                                      child:new Row(
                                        children: <Widget>[
                                              new Padding(
                                                padding: const EdgeInsets.only(left: 20.0,top: 15.0,bottom: 15.0),
                                                child: new Icon(
                                                  Icons.camera_alt,
                                                  color: Colours.text_gray,
                                                  size: 20.0,
                                                ),
                                              ),
                                              new Padding(
                                                padding: const EdgeInsets.only(left: 10.0),
                                                child: new Text("随手拍反馈问题",
                                                    style: AppText.Title_Size_Medium ),
                                              ),
                                            ],
                                        ),
                                      flex:1
                                  ),
                                  Expanded(
                                      child: new Align(
                                        alignment: Alignment.centerRight,
                                        //padding: const EdgeInsets.only(right:0.0,left: 98.0),
                                        child: FlatButton(
                                          child: Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 20.0),
                                          onPressed: () {
                                            toFree2Shoot();
                                          },
                                        ),
                                      ),
                                      flex:1
                                  ),
//                                  new Padding(
//                                    padding: const EdgeInsets.only(left: 100.0),
//                                    child: new Align(
//                                      alignment: Alignment.centerRight,
//                                      //padding: const EdgeInsets.only(right:0.0,left: 98.0),
//                                      child: FlatButton(
//                                        child: Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 20.0),
//                                        onPressed: () {
//                                          toFree2Shoot();
//                                        },
//                                      ),
//                                    ),
//                                  ),
                                ],
                              ),
                            ),
                            new Divider(
                              height: 0.0,
                            ),
                          ],
                        ),
                      ),
                  ),
//                  new Container(
//                      child: Center(
//                        child:new Column(
//                          children: <Widget>[
//                            new Padding(padding: const EdgeInsets.only(bottom: 30.0),),
//                            new GestureDetector(
//                              child:  new Image.asset(
//                                'assets/images/microphone.png',        //图片的路径
//                                width: 60.0,
//                              ),
////                              new Icon(
////                                Icons.keyboard_voice,
////                                //Icons.settings_voice,
////                                color: Colors.grey,
////                                size: 90,
////                              ),
//                              onLongPress: (){
//                                micphoneSendMessStart();
//                              },
//                              onLongPressUp: (){
//                                micphoneSendMessEnd();
//                              },
//                            ),
//                            new Text('长按话筒留言',style: AppText.Info_Size_Medium_Gray,),
//
//
////                            new Text('这是15号字',style: TextStyle(fontSize: 15.0),),
////                            new Text('这也是15号字',style: TextStyle(fontSize: ScreenUtil().setSp(15)),),
//
//                          ],
//                        ),
//                      )
//                  ),

//                  GestureDetector(
//                    child: Text('跳转测试'),
//                    onTap: (){
//                      NavigatorUtil.pushPage(context, AddPersoninfoPage(),pageName: '个人信息');
//                    },
//                  )

                ],
              )
            )
      )
    );
  }
}