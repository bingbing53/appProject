import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helloworld/common/list_activity_view_item.dart';
import 'package:helloworld/components/activity_page_item.dart';
import 'package:helloworld/components/list_refresh.dart' as listComp;
import 'package:helloworld/components/pagination.dart';
import 'package:helloworld/components/disclaimer_msg.dart';
import 'package:helloworld/data/api/consumer_apis.dart';
import 'package:helloworld/data/net/dio_util.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/utils/shared_preferences_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common/net_utils.dart';

GlobalKey<DisclaimerMsgState> key;

class ActivityPage extends StatefulWidget {
  final String url,type;

  ActivityPage({this.url,this.type});

  @override
  ActivityPageState createState() => new ActivityPageState();
}

class ActivityPageState extends State<ActivityPage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  var activityType;

  Future<Map> getIndexListData([Map<String, dynamic> params]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String street = prefs.getString(SharedPreferencesKeys.sysOrgCode);
    var pageIndex = (params is Map) ? params['pageIndex'] : 1;
    final _param  = {'pageNo':pageIndex,'street':street};

    if(widget.type != null && widget.type == 'hisotry'){
      var response = await NetUtils.get(widget.url,params:_param);
      var responseList = response['list'];

      var pageTotal = response['totalRow'] ~/ 15 + 1;
      if (!(pageTotal is int) || pageTotal <= 0) {
        pageTotal = 0;
      }
      pageIndex += 1;
      List resultList = new List();
      for (int i = 0; i < responseList.length; i++) {
//        try {
//          Map<String, dynamic> json = responseList[i];
//          ActivityPageItem cellData = new ActivityPageItem.fromJson(responseList[i]);
          resultList.add(responseList[i]);
//        } catch (e) {
//          // No specified type, handles all
//        }
      }
      Map<String, dynamic> result = {
        "list": resultList,
        'total': pageTotal,
        'pageIndex': pageIndex,
      };
      return result;
    }else {

      BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request<Map<String,dynamic>>(Method.get, ConsumerApis.ACTIVITY_LIST,data: _param);
      if(baseResp.code == 200) {
        var data = baseResp.data;
        List responseList = data["records"];
        print(responseList);
        var pageTotal = data['total'] ~/ 10 + 1;
        if (!(pageTotal is int) || pageTotal <= 0) {
          pageTotal = 0;
        }
        pageIndex += 1;
        List resultList = new List();

        for (int i = 0; i < responseList.length; i++) {
          try {
            ActivityPageItem cellData = ActivityPageItem.fromJson(responseList[i]);
            resultList.add(cellData);
          } catch (e) {
            print(e.toString());
          }
        }
        Map<String, dynamic> result = {
          "list": resultList,
          'total': pageTotal,
          'pageIndex': pageIndex
        };

        return result;
      }
    }
  }

  Widget makeCard(index,item){
//    if(widget.type != null && widget.type == 'hisotry'){
//      return new ListActivityHistoryItem(item: item,);
//    }else {
      return new ListActivityViewItem(item: item);
//    }
  }

  headerView(){
    return
      Column(
        children: <Widget>[
        Stack(
        //alignment: const FractionalOffset(0.9, 0.1),//方法一
        children: <Widget>[
            Pagination(),
            Positioned(//方法二
            top: 10.0,
            left: 0.0,
            child: DisclaimerMsg(key:key,pWidget:this)
            ),
          ]),
        SizedBox(height: 1, child:Container(color: Theme.of(context).primaryColor)),
        SizedBox(height: 10),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Column(
        children: <Widget>[
          new Expanded(
            child: listComp.ListRefresh(getIndexListData,makeCard)
          )
        ]

    );
  }
}


