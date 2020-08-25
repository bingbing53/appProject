/*
 * Created by 王振宇 on 2019/3/12.
 */

import 'package:flutter/material.dart';
import 'package:helloworld/common/net_utils.dart';
import 'package:helloworld/common/style.dart';
import 'package:helloworld/main.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/consumer/login/select_page.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/tviews/h_main_page.dart';
import 'package:helloworld/tviews/widget/widget_index.dart';
import 'package:helloworld/utils/base_utils.dart';
import 'package:helloworld/utils/dialog.dart';
import 'package:helloworld/utils/util_index.dart';

const String text1 =
"""为提高居民投诉处理效率，请率先在街道、社区反馈您的意见和建议，街道处理不了会及时反馈上级领导部门为您解决""";

const int color = 0xFFF5534B;

class SelectOrgPage extends StatefulWidget {
  @override
  _SelectOrgPageState createState() => _SelectOrgPageState();
}

class _SelectOrgPageState extends State<SelectOrgPage> with AutomaticKeepAliveClientMixin {

  List streets = [
    {"code":"A01","name":"东湖街道"}
  ];
  List comms = [];
  List citys = [];
  List areas = [];
  bool cityClicked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  bool get wantKeepAlive => true;

  var _param  = {'code':''};
  var city = {'name':'城市','code':''};
  var _cityName = '城市';
  var area = {'name':'区县','code':''};
  var _areaName = '区县';

  var street = {'name':'街乡','code':''};
  var _streetName = '街乡';
  var comm = {'name':'社区','code':''};
  var _commName = '社区';

  String value = '';
  List<Widget> _cityList = [];
  List<Widget> _areaList = [];
  List<Widget> _list = [];
  List<Widget> _commList = [];

  onChange(v) {
    this.setState(() {
      value = v;
    });
  }

  void change(String code,String name){
    setState(() {
      this._streetName = name;
      this.street['name'] = name;
      this.street['code'] = code;
      comm = {'name':'社区','code':''};
      _commName = '社区';
    });
  }

  void changeCity(String code,String name){
    setState(() {
      this._cityName = name;
      this.city['name'] = name;
      this.city['code'] = code;
    });
  }

  void changeComm(String code,String name){
    setState(() {
      this._commName = name;
      this.comm['name'] = name;
      this.comm['code'] = code;
    });
  }

  void changeArea(String code,String name){
    setState(() {
      this._areaName = name;
      this.area['name'] = name;
      this.area['code'] = code;
    });
  }
  //
  Future<Widget> buildAreaList() async {
    String code = this.city['code'];
    _param['code'] = this.city['code'];
    if(null!=code && code != ''){
      var response = await NetUtils.get(Api.AREA_LIST,params: _param);
      print(response);
      areas = response;
      for(int i=0;i<areas.length;i++){
        String name = areas[i]['name'];
        String code = areas[i]['code'];
        _areaList.add(
            new SimpleDialogOption(
              child: new Text(name),
              onPressed: () {
                changeArea(code,name);
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
                children: _areaList,
              )
            ],
          );
        },
      );
    }else{
      //showDialogWarning("请先选择城市");
      DialogUtil.showDialogWarning("请先选择城市", context);
    }
  }

  Future<Widget> buildCommList() async {
    String code = this.street['code'];
    _param['code'] = this.street['code'];
    if(null!=code && code != ''){
      var response = await NetUtils.get(Api.COMM_LIST,params: _param);
      print(response);
      comms = response;
      for(int i=0;i<comms.length;i++){
        String name = comms[i]['name'];
        String code = comms[i]['code'];
        _commList.add(
            new SimpleDialogOption(
              child: new Text(name),
              onPressed: () {
                changeComm(code,name);
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
                children: _commList,
              )
            ],
          );
        },
      );
    }else{
      //showDialogWarning("请先选择街道");
      DialogUtil.showDialogWarning("请先选择街道", context);
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

  Future<Widget> buildCityList() async {
    if(!cityClicked){
      cityClicked = true;
      var response = await NetUtils.get(Api.CITY_LIST,params: _param);
      print(response);
      citys = response;
      for(int i=0;i<citys.length;i++){
        String name = citys[i]['name'];
        String code = citys[i]['code'];
        _cityList.add(
            new SimpleDialogOption(
              child: new Text(name),
              onPressed: () {
                changeCity(code,name);
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
                children: _cityList,
              )
            ],
          );
        },
      );
      cityClicked = false;
    }
  }

  Future<Widget> buildList() async {
    String code = this.area['code'];
    _param['code'] = this.area['code'];
    if(null!=code && code != ''){
      var response = await NetUtils.get(Api.STREET_LIST,params: _param);
      print(response);
      streets = response;
      for(int i=0;i<streets.length;i++){
        String name = streets[i]['name'];
        String code = streets[i]['code'];
        _list.add(
            new SimpleDialogOption(
              child: new Text(name),
              onPressed: () {
                change(code,name);
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
                children: _list,
              )
            ],
          );
        },
      );
    }else{
      //showDialogWarning("请先选择区县");
      DialogUtil.showDialogWarning("请先选择区县", context);
    }

  } //

  Future showCityDialog(BuildContext context) async {
    setState(() {
      _cityList = [];
      buildCityList();
    });
  }

  Future showAreaDialog(BuildContext context) async {
    setState(() {
      _areaList = [];
      buildAreaList();
    });
  }

  Future showAlertDialog(BuildContext context) async {
    setState(() {
      _list = [];
      buildList();
    });
  }

  Future showCommDialog(BuildContext context) async {
    setState(() {
      _commList = [];
      buildCommList();
    });
  }

  Future pageRout() async {
    if(null!=street['code']&&street['code']!=''){
      var value = comm['code'];
      var streetValue = _streetName;
      if(null!=value){
        streetValue = _commName;
      }else{
        value = street['code'];
      }
      SpUtil.putString(SharedPreferencesKeys.sysOrgCode, value);
      SpUtil.putString(SharedPreferencesKeys.streetValue, streetValue);

      //判断登录状态
      var login = await BaseUtils.getLoginState(context);
      if(login){
        var _param = {'street':value};
        var response = await NetUtils.post(Api.SAVE_PERSON_INRO,params: _param);
        if(response!=null){
          String isSuccess = response['isSuccess'];
          if('success'==isSuccess){
            Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(builder: (context) => new TabMainPage()
                ), (route) => route == null);
          }else{
            DialogUtil.showDialogWarning("更换社区失败，请稍后重试", context);
          }
        }
      }else{
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => new TabMainPage()
            ), (route) => route == null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('选择社区'),
        ),
        body: new SingleChildScrollView(
            child: new ConstrainedBox(
                constraints: new BoxConstraints(
                  minHeight: 120.0,
                ),
                child: new Column(
                  children: <Widget>[
                    new Container(
                      child: new Column(  // card只能有一个widget，但这个widget内容可以包含其他的widget
                        children: [
                          new Image.asset(
                            'assets/images/welcome.png',        //图片的路径
//                            width: 360.0, //图片控件的高度
                            fit: BoxFit.fill, //告诉引用图片的控件，图像应尽可能小，但覆盖整个控件。
                          ),
                          new ListTile( //城市
                            contentPadding: EdgeInsets.only(left: 30.0,top: 30.0,right: 20.0),
                            title: new Text('${_cityName}',
                              style: AppText.Title_Size_Medium,
                            ),
                            onTap: (){
                              showCityDialog(context);
                            },
                            trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 30.0),
                          ),
                          new Divider(
                            height: 3.0,
                          ),
                          new ListTile( //区县
                            contentPadding: EdgeInsets.only(left: 30.0,top: 0.0,right: 20.0),
                            title: new Text('${_areaName}',
                              style: AppText.Title_Size_Medium,
                            ),
                            onTap: (){
                              showAreaDialog(context);
                            },
                            trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 30.0),
                          ),
                          new Divider(
                            height: 3.0,
                          ),
                          new ListTile(
                            contentPadding: EdgeInsets.only(left: 30.0,top: 0.0,right: 20.0),
                            title: new Text('${_streetName}',
                                style: AppText.Title_Size_Medium,
                            ),
                            onTap: (){
                              showAlertDialog(context);
                            },
                            trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 30.0),
                          ),
                          new Divider(
                            height: 3.0,
                          ),
                          new ListTile(
                            contentPadding: EdgeInsets.only(left: 30.0,top: 0.0,right: 20.0),
                            title: new Text('${_commName}',
                                style: AppText.SubTitle_Size_Big ),
                            onTap: (){
                              showCommDialog(context);
                            },
                            trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 30.0),
                          ),
                          new Divider(
                            height: 3.0,
                          ),
                          SizedBox(height: 20),
                          RoundButton(
                            bgColor: Colours.app_main,
                            radius:5,
                            width: MediaQuery.of(context).size.width - 40,
                            text: '进入社区',
                            height: 50,
                            style: TextStyle(color: Colors.white),
                            onPressed: (){
                              pageRout();
                            },
                          ),
//                          new Padding(
//                              padding: EdgeInsets.only(top: 20.0),
//                            child: new SizedBox(
//                              height: 45.0,
//                              width: 270.0,
//                              child: RaisedButton(
//                                child: Text(
//                                  '进入社区',
//                                  style: AppText.Title_Size_Medium_White,
//                                ),
//                                //color: Colors.black,
////                                color: new Color(color),
//                                onPressed: () {
//                                  pageRout();
//                                },
//                              ),
//                            ),
//                          )
                        ],
                      ),
                    ),

                  ],
                )
            )
        ),

    );
  }
}