import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helloworld/common/style.dart';
import 'package:helloworld/components/first_page_item.dart';
import 'package:helloworld/main.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/consumer/comm/communicate_page.dart';
import 'package:helloworld/utils/dialog.dart';
import '../../../common/net_utils.dart';

const int ThemeColor = 0xFFF5534B;

const int backgroundColor = 0xF7F7F7;

class LeaderMailboxPage extends StatefulWidget {
  @override
  _LeaderMailboxPageState createState() => _LeaderMailboxPageState();
}

class _LeaderMailboxPageState extends State<LeaderMailboxPage> with AutomaticKeepAliveClientMixin {
  FirstPageItem item;

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
    var _param = {'willType':type['code'],'title':title,'content':content};
    print(_param);
    isSubmit = true;
    var response = await NetUtils.post(Api.SEND_WILLRECORD,params: _param);
    print(response);
    print("response:=======");
    if(response==null||response==''){
      DialogUtil.showDialogWarning("网络超时，请稍后重试", context);
      isSubmit = false;
    }else{
      if(response.statusCode==200){
        DialogUtil.showDialogWarning("发送成功，页面将跳转", context);
        new Timer(new Duration(seconds: 2), () {
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
    print(response);
    types = response;
    for(int i=0;i<types.length;i++){
      String name = types[i]['name'];
      String code = types[i]['code'];
      _typeList.add(
          new SimpleDialogOption(
            child: new Text(name),
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

  @override
  bool get wantKeepAlive => true;
  GlobalKey<NavigatorState> _navigatorKey=new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: new AppBar(
          title: new Text('书记信箱'),
//          backgroundColor: new Color(color),
        ),
        body: new SingleChildScrollView(
          child: new ConstrainedBox(
              constraints: new BoxConstraints(
                minHeight: 120.0,
              ),
              child:Form(
                key: _formKey,
                child:new Container(
//                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      SizedBox(height: 10,),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            new ListTile( //区县
                              contentPadding: EdgeInsets.only(left: 20.0,top: 0.0,right: 20.0),
                              title: new Text('${_typeName}',
                                style: AppText.Title_Size_Medium,
                              ),
                              onTap: (){
                                showAreaDialog(context);
                              },
                              trailing: Icon(Icons.keyboard_arrow_right, color: Colors.grey, size: 30.0),
                            ),
//                      SizedBox(height: 10.0,),
                            Divider(height: 1.0,color: AppColor.borderColor,),
                            SizedBox(height: 10.0,),
                            Padding(
                              padding: EdgeInsets.only(left: 3.0,right: 3.0),
                              child: new TextField(
                                decoration: const InputDecoration(
                                  hintText: '请输入问题标题，不超过30字',
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
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),


                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.only(left: 3.0,right: 3.0),
                          child: new TextField(
                            decoration: const InputDecoration(
                              hintText: '请输入您反馈的问题内容详情，不超过500字',
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
                      SizedBox(height: 50,),
                      Align(
                        child: SizedBox(
                          height: 40.0,
                          width: MediaQuery.of(context).size.width - 30,
                          child: RaisedButton(
                            child: Text(
                              '发 信',
                              style: AppText.Title_Size_Big_White,
                            ),
                            color: Colours.app_main,
                            onPressed: () {
                              if(!isSubmit) {
                                submit();
                              }
                            },
//                            shape: StadiumBorder(side: BorderSide(color: new Color(DialogUtil.color))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ),
        ),
      );
  }

  Future<String> article() async{
    var response = await NetUtils.get(Api.ARTICLE_DETAIL+item.id);
    return response['article']['content'];
  }
}


