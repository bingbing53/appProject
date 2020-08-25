import 'dart:async';
import 'package:flutter/material.dart';

import 'package:helloworld/common/list_view_item.dart';
import 'package:helloworld/components/list_refresh.dart' as listComp;
import 'package:helloworld/components/pagination.dart';
import 'package:helloworld/common/list_survey_view_item.dart';
import 'package:helloworld/components/disclaimer_msg.dart';
import 'package:helloworld/components/survey_page_item.dart';
import 'package:helloworld/data/api/consumer_apis.dart';
import 'package:helloworld/data/net/dio_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:helloworld/model/api.dart';

import '../../../common/net_utils.dart';

GlobalKey<DisclaimerMsgState> key;

class SurveyPage extends StatefulWidget {
  @override
  SurveyPageState createState() => new SurveyPageState();
}

class SurveyPageState extends State<SurveyPage> with AutomaticKeepAliveClientMixin{

  SurveyPageState();

  @override
  bool get wantKeepAlive => true;

  Future<Map> getIndexListData([Map<String, dynamic> params]) async {
    var pageIndex = (params is Map) ? params['pageIndex'] : 1;
    final _param  = {'pageNo':pageIndex};
//    var response = await NetUtils.get(Api.VOTE_LIST,params: _param);
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request<Map<String,dynamic>>(Method.get, ConsumerApis.SURVEY_LIST,data: _param);
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
          SurveyModel cellData = new SurveyModel.fromJson(responseList[i]);
          resultList.add(cellData);
        } catch (e) {
          print(e.toString());
          // No specified type, handles all
        }
      }
      Map<String, dynamic> result = {
        "list": resultList,
        'total': pageTotal,
        'pageIndex': pageIndex
      };

      return result;
    }

//    var responseList = response['list'];
//    var  pageTotal = response['totalRow'] ~/ 20 + 1;
//    if (!(pageTotal is int) || pageTotal <= 0) {
//      pageTotal = 0;
//    }
//    pageIndex += 1;
//    List resultList = new List();
//    for (int i = 0; i < responseList.length; i++) {
//      try {
//        resultList.add(responseList[i]);
//      } catch (e) {
//        print(e.toString());
//        // No specified type, handles all
//      }
//    }
//    Map<String, dynamic> result = {"list":resultList, 'total':pageTotal, 'pageIndex':pageIndex};
//    return result;
  }

  Widget makeCard(index,item){
    return new ListSurveyViewItem(item:item);
  }

  headerView(){
    return
      Column(
        children: <Widget>[
          Stack(
              alignment: const FractionalOffset(0.9, 0.1),//方法一
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
            child: listComp.ListRefresh(getIndexListData,makeCard),
          ),
        ]
    );
  }
}


