import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:helloworld/components/disclaimer_msg.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/utils/util_index.dart';
import '../../../common/net_utils.dart';
import 'package:helloworld/common/list_message_list_item.dart';
import 'package:helloworld/components/list_refresh.dart' as listComp;

GlobalKey<DisclaimerMsgState> key;

class MessageIndexPage extends StatefulWidget {

  @override
  MessageIndexPageState createState() => new MessageIndexPageState();
}

class MessageIndexPageState extends State<MessageIndexPage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  Future<Map> getIndexListData([Map<String, dynamic> params]) async {
    var pageIndex = (params is Map) ? params['pageIndex'] : 1;
    var response = await NetUtils.get(Api.MESSAGE_LIST);
    Map<String, dynamic> result = {"list":response, 'total':0, 'pageIndex':1};
    return result;
  }

  Widget makeCard(index,item){
    return new ListMessageListItem(item:item,callback: (val) => _onDataChange(item),);
  }

  _onDataChange(item){
    setState((){
      item['total']  = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('我的消息'),
        flexibleSpace: Image(
          image: AssetImage(Utils.getImgPath('home_top')),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
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


