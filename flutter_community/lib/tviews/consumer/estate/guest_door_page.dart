import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helloworld/blocs/bloc_index.dart';
import 'package:helloworld/blocs/bloc_provider.dart';
import 'package:helloworld/blocs/main_bloc.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/data/protocol/consumer_models.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/webview/webview_flutter.dart';
import 'package:helloworld/tviews/widget/simple_dialog.dart';
import 'package:helloworld/tviews/widget/web_scaffold.dart';
import 'package:helloworld/tviews/widget/widget_index.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'package:helloworld/utils/util_index.dart';
//import 'package:native_contact_picker/native_contact_picker.dart';

/**
 * 访客授权
 */

class GuestDoorPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return GuestDoorPageState();
  }
}

class GuestDoorPageState extends State<GuestDoorPage>{
//  final NativeContactPicker _contactPicker = new NativeContactPicker();

  TextEditingController _controller = new TextEditingController();
  TextEditingController _memoController = new TextEditingController();
  String startTime = DateUtil.formatDate(DateTime.now(),format: 'yyyy-MM-dd HH:mm'),endTime = DateUtil.formatDate(DateTime.now().add(Duration(hours: 2)),format: 'yyyy-MM-dd HH:mm');

  MainBloc _mainBloc;

  VisitorTempPwd visitorTempPwd = new VisitorTempPwd();
  String useCountStr = '密码默认使用一次';
  @override
  void initState() {
    super.initState();
    _mainBloc = BlocProvider.of<MainBloc>(context);
    visitorTempPwd.useCount = 1;
    visitorTempPwd.devName = '请选择楼栋/设备';
    visitorTempPwd.startDatetime = DateUtil.formatDate(DateTime.now(),format: 'yyyyMMddHHmmss');
    visitorTempPwd.endDatetime = DateUtil.formatDate(DateTime.now().add(Duration(hours: 2)),format: 'yyyyMMddHHmmss');
    _mainBloc.getDeviceList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('访客授权'),
        flexibleSpace: Image(
          image: AssetImage(Utils.getImgPath('home_top')),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.history,size: 26),
              onPressed: () {
                NavigatorUtil.pushPage(context, WebScaffold(url:'/#/estate/visitor',title: '访客历史',),pageName: '历史');
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(Dimens.gap_dp15),
                color: Colors.white,
                child: GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Text('楼栋/设备',style: TextStyle(fontSize: Dimens.font_sp16)),
                      Expanded(
                          child: Text(visitorTempPwd.devName,style: TextStyle(fontSize: Dimens.font_sp16,color: Colours.text_gray),textAlign: TextAlign.end)
                      ),
                      Icon(Icons.keyboard_arrow_right,color: Colours.text_gray)
                    ],
                  ),
                  onTap: (){
                    showDialog<Null>(
                      context: context,
                      builder: (BuildContext context) {
                        return new SimpleDialog(
                          title: new Text('请选择'),
                          children: <Widget>[
                            new Column(
                              children: <Widget>[
                                new StreamBuilder(
                                    stream: _mainBloc.deviceListDataStream,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List> snapshot) {
                                      if(snapshot.data == null){
                                        return Container();
                                      }
                                      return Column(
                                        children: snapshot.data.map((item){
                                          return ListTile(
                                            leading: Icon(Icons.lock,size: 22,color: Colours.app_main),
                                            title: Text(item.name),
                                            onTap: (){
                                              visitorTempPwd.devSnList = [];
                                              visitorTempPwd.devSnList.add(item.code);
                                              visitorTempPwd.devName = item.name;
                                              setState(() {});
                                              Navigator.pop(context);
                                            },
                                          );
                                        }).toList(),
                                      );
                                    }),
                              ],
                            )
                          ],
                        );
                      },
                    );
                  },
                )
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: Dimens.gap_dp15),
              child: Divider(height: 1),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: Dimens.gap_dp5,horizontal: Dimens.gap_dp15),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Text('电话',style: TextStyle(fontSize: Dimens.font_sp16)),
                  SizedBox(width: MediaQuery.of(context).size.width / 4),
                  Expanded(
                    child: TextField(
                      style: TextStyle(fontSize: Dimens.font_sp16),
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '请输入手机号码',
                        border:InputBorder.none,
                        focusedBorder:InputBorder.none,
                        enabledBorder:InputBorder.none
                      ),
                      autofocus: false,
                      controller: _controller,
                    ),
                  ),
                  GestureDetector(
                    child: Image.asset(Utils.getImgPath('contact_phone'),width: 24,height: 24),
                    onTap: () async {

//                      Contact _contact = await _contactPicker.selectContact();
//                      if(_contact != null){
//                        setState(() {
//                          _controller.text = _contact.phoneNumber;
//                          if(ObjectUtil.isEmpty(_memoController.text)){
//                            _memoController.text = _contact.fullName;
//                          }
//                        });
//                      }
                    },
                  )
                ],
              )
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: Dimens.gap_dp15),
              child: Divider(height: 1),
            ),
            Container(
                padding: EdgeInsets.all(Dimens.gap_dp15),
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    Text('关系',style: TextStyle(fontSize: Dimens.font_sp16)),
                    SizedBox(width: MediaQuery.of(context).size.width / 4),
                    Expanded(
//                        child: Text('请对访客进行备注',style: TextStyle(fontSize: Dimens.font_sp16,color: Colours.text_gray),textAlign: TextAlign.end)
                      child: TextField(
                        style: TextStyle(fontSize: Dimens.font_sp16),
                        decoration: InputDecoration(
                            hintText: '请对访客进行备注',
                            border:InputBorder.none,
                            focusedBorder:InputBorder.none,
                            enabledBorder:InputBorder.none
                        ),
                        autofocus: false,
                        controller: _memoController,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right,color: Colours.text_gray)
                  ],
                )
            ),

            Container(
              margin: EdgeInsets.only(top: Dimens.gap_dp10),
              padding: EdgeInsets.symmetric(vertical:Dimens.gap_dp10,horizontal: Dimens.gap_dp15),
              color: Colors.white,
              width: double.infinity,
              child: Text('有效期（默认时长为2小时）',style: TextStyle(fontSize: Dimens.font_sp16,color: Colours.text_gray)),
            ),
            GestureDetector(
              child: Container(
                  padding: EdgeInsets.all(Dimens.gap_dp15),
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Text('开始时间',style: TextStyle(fontSize: Dimens.font_sp16)),
                      Expanded(
                          child: Text(startTime,style: TextStyle(fontSize: Dimens.font_sp16,color: Colours.text_gray),textAlign: TextAlign.end)
                      ),
                      Icon(Icons.keyboard_arrow_right,color: Colours.text_gray)
                    ],
                  )
              ),
              onTap: (){
                DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    maxTime: DateTime.now().add(Duration(days: 7)),
                    onChanged: (date) {
                    }, onConfirm: (date) {
                  startTime = DateUtil.formatDate(date,format: 'yyyy-MM-dd HH:mm');
                  visitorTempPwd.startDatetime = DateUtil.formatDate(date,format: 'yyyyMMddHHmmss');
                  setState((){});
                }, currentTime: DateUtil.getDateTime(startTime),locale: LocaleType.zh);
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: Dimens.gap_dp15),
              child: Divider(height: 1),
            ),
            GestureDetector(
              child: Container(
                  padding: EdgeInsets.all(Dimens.gap_dp15),
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Text('结束时间',style: TextStyle(fontSize: Dimens.font_sp16)),
                      Expanded(
                          child: Text(endTime,style: TextStyle(fontSize: Dimens.font_sp16,color: Colours.text_gray),textAlign: TextAlign.end)
                      ),
                      Icon(Icons.keyboard_arrow_right,color: Colours.text_gray)
                    ],
                  )
              ),
              onTap: (){
                DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    maxTime: DateTime.now().add(Duration(days: 7)),
                    onChanged: (date) {
                    }, onConfirm: (date) {
                      endTime = DateUtil.formatDate(date,format: 'yyyy-MM-dd HH:mm');
                      visitorTempPwd.endDatetime = DateUtil.formatDate(date,format: 'yyyyMMddHHmmss');
                      setState((){});
                    }, currentTime: DateUtil.getDateTime(endTime),locale: LocaleType.zh);
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: Dimens.gap_dp15),
              child: Divider(height: 1),
            ),
            Container(
                padding: EdgeInsets.all(Dimens.gap_dp15),
                color: Colors.white,
                child: GestureDetector(
                  child: Row(
                    children: <Widget>[
                      Text('次数',style: TextStyle(fontSize: Dimens.font_sp16)),
                      Expanded(
                          child: Text(useCountStr,style: TextStyle(fontSize: Dimens.font_sp16,color: Colours.text_gray),textAlign: TextAlign.end)
                      ),
                      Icon(Icons.keyboard_arrow_right,color: Colours.text_gray)
                    ],
                  ),
                  onTap: (){
                    showDialog<Null>(
                      context: context,
                      builder: (BuildContext context) {
                        return new SimpleDialog(
                          title: new Text('请选择'),
                          children: <Widget>[
                            new Column(
                              children: [1,2,3,4,5,6,7,8,].map((item){
                                return ListTile(
                                    leading: Icon(Icons.sort_by_alpha,size: 22,color: Colours.app_main),
                                    title: Text('密码使用$item次'),
                                    onTap: (){
                                      visitorTempPwd.useCount = item;
                                      useCountStr = '密码使用$item次';
                                      setState(() {});
                                      Navigator.pop(context);
                                    }
                                );
                              }).toList(),
                            )
                          ],
                        );
                      },
                    );
                  },
                )
            ),
          ],
        ),
      ),
      bottomNavigationBar: RoundButton(
        radius: 0,
        text: '创建动态密码',
        bgColor: Colours.app_main,
        onPressed: (){
          visitorTempPwd.mobile = _controller.text;
          visitorTempPwd.memo = _memoController.text;
          if(ObjectUtil.isEmpty(visitorTempPwd.mobile)){
            Fluttertoast.showToast(msg: '电话不能为空');
            return;
          }
          if(ObjectUtil.isEmpty(visitorTempPwd.memo)){
            Fluttertoast.showToast(msg: '请对关系备注');
            return;
          }
          if(ObjectUtil.isEmpty(visitorTempPwd.devSnList) || visitorTempPwd.devSnList.length <= 0){
            Fluttertoast.showToast(msg: '请选择设备');
            return;
          }
          _mainBloc.createTempPwd(visitorTempPwd).then((result){

              String content = '${visitorTempPwd.devName}临时密码为${result.tempPwd}，有效期为$startTime到$endTime，有效期内共可使用${visitorTempPwd.useCount}次';

              SimpleDialogUtil.confirmDialog(context,(){
                Clipboard.setData(ClipboardData(text: content));

                Fluttertoast.showToast(msg: '复制成功');

              },title: '密码创建成功',content: content,confirmText: '复制到粘贴板');

          }).catchError((_){
            print(_);
            Fluttertoast.showToast(msg: _.message);
          });
        },
      ),
    );
  }
}