import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helloworld/common/list_view_item.dart';
import 'package:helloworld/components/list_refresh.dart' as listComp;
import 'package:helloworld/components/pagination.dart';
import 'package:helloworld/common/list_shoot_view_item.dart';
import 'package:helloworld/common/style.dart';
import 'package:helloworld/components/disclaimer_msg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:helloworld/model/api.dart';
//import 'package:flutter_picker/flutter_picker.dart';
import '../../../common/net_utils.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:helloworld/utils/base_utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';



GlobalKey<DisclaimerMsgState> key;

class ShootHistoryPage extends StatefulWidget {
  @override
  ShootHistoryPageState createState() => new ShootHistoryPageState();
}

class ShootHistoryPageState extends State<ShootHistoryPage>{

  Future<Map> getIndexListData([Map<String, dynamic> params]) async {
    var pageIndex = (params is Map) ? params['pageIndex'] : 1;
    final _param  = {'pageNo':pageIndex};

    var response = await NetUtils.get(Api.SEND_WILLRECORD, params: _param);

    var responseList = response['list'];

    var  pageTotal = response['totalRow'] ~/ 15 + 1;
    if (!(pageTotal is int) || pageTotal <= 0) {
      pageTotal = 0;
    }
    pageIndex += 1;
    List resultList = new List();
    for (int i = 0; i < responseList.length; i++) {
      resultList.add(responseList[i]);
    }
    Map<String, dynamic> result = {"list":resultList, 'total':pageTotal, 'pageIndex':pageIndex};
    return result;
  }

  Widget makeCard(index,item){
    return new ListShootViewItem(item: item);
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
    return new Column(
        children: <Widget>[
          new Expanded(
              child: listComp.ListRefresh(getIndexListData,makeCard)
          )
        ]

    );
  }


}


