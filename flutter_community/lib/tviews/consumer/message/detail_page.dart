import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:helloworld/components/disclaimer_msg.dart';
import 'package:helloworld/model/api.dart';
import '../../../common/net_utils.dart';
import 'package:helloworld/common/list_message_detail_item.dart';
import 'package:helloworld/components/list_refresh.dart' as listComp;

GlobalKey<DisclaimerMsgState> key;

class MessageDetailPage extends StatefulWidget {

  final Map item;

  MessageDetailPage(this.item);

  @override
  MessageDetailPageState createState() => new MessageDetailPageState();
}

class MessageDetailPageState extends State<MessageDetailPage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    updateMessageState();
  }

  //更新消息状态
  Future updateMessageState() async{
    final _param  = {'messageType':widget.item['code']};
    await NetUtils.post(Api.MESSAGE_UPDATE_READ,params: _param);
  }

  //获取消息
  Future<Map> getIndexListData([Map<String, dynamic> params]) async {
    var pageIndex = (params is Map) ? params['pageIndex'] : 1;
    final _param  = {'pageNo':pageIndex,'code':widget.item['code']};
    var response = await NetUtils.get(Api.MESSAGE_DETAIL_LIST,params: _param);
    var responseList = response['list'];
    var  pageTotal = response['totalRow'] ~/ 20 + 1;
    if (!(pageTotal is int) || pageTotal <= 0) {
      pageTotal = 0;
    }
    pageIndex += 1;
    List resultList = new List();
    for (int i = 0; i < responseList.length; i++) {
      try {
        resultList.add(responseList[i]);
      } catch (e) {
        print(e.toString());
        // No specified type, handles all
      }
    }
    Map<String, dynamic> result = {"list":resultList, 'total':pageTotal, 'pageIndex':pageIndex};
    return result;
  }

  Widget makeCard(index,item){
    return new ListMessageDetailItem(item:item);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('我的消息'),
      ),
      body: new Column(
          children: <Widget>[
            new Expanded(
              child: listComp.ListRefresh(getIndexListData,makeCard),
            ),
          ])
    );
  }
}


