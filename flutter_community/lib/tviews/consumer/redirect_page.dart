import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/components/disclaimer_msg.dart';
import 'dart:convert';

const int ThemeColor = 0xFFF5534B;
GlobalKey<DisclaimerMsgState> key;

class RedirectPage extends StatefulWidget{

  RedirectPage();
  @override
  _RedirectPageState createState() => _RedirectPageState();
}

class _RedirectPageState extends State<RedirectPage> with AutomaticKeepAliveClientMixin {

  var description = '',detail,step = 0,over = '1',content;

  @override
  void initState() {
    super.initState();
    survey();
  }

  @override
  bool get wantKeepAlive => true;

  Future survey() async{
//    var response = await NetUtils.get(Api.VOTE_DETAIL+widget.item['id']);
//    print(response);
//    setState(() {
//        if(response != null && response['vote'] != null){
//          description = response['vote']['voteRule'];
//          detail = response['vote']['detail'];
//          var fileds = json.decode(detail);
//          content = fileds['fields'];
//        }
//    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('');

  }
}
