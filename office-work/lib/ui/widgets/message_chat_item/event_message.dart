
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/blocs/bloc_index.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

//图片消息
class EventMessage extends StatefulWidget{
  const EventMessage({Key key, this.model,this.bloc}) : super(key: key);
  final JMEventMessage model;
  final WorkBloc bloc;
  @override
  State<StatefulWidget> createState() {
    return _EventMessagePage();
  }

}
class _EventMessagePage extends State<EventMessage>{

  String text = '';

  @override
  void initState() {
    super.initState();
    text = '';
    try {
      initEventMessage();
    }catch(_){}
  }

  void initEventMessage() async{
    if(widget.model == null || widget.model.eventType == null)
      return;

    print(widget.model.toJson());

    List<dynamic> usernames = widget.model.usernames;
    if(usernames.length > 1) {
      for (var i = 0; i < usernames.length - 1; i++) {
        JMUserInfo userInfo = await widget.bloc.getUserInfoByUsername(
            usernames[i].toString());
        text += userInfo.nickname + '、';
      }
      text = text.substring(0, text.length - 1);
      switch (widget.model.eventType) {
        case JMEventType.group_member_added:
          text += '加入群聊';
          break;
        case JMEventType.group_member_removed:
          text += '被移除群聊';
          break;
        case JMEventType.group_member_exit:
          text += '退出群聊';
          break;
      }

      setState(() {
        text = text;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    if(text == ''){
      return SizedBox(height: 0,);
    }else {
      return Container(
          margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: Container(
                color: Colours.transparent_40,
                padding: EdgeInsets.only(
                    left: 10.0, top: 3.0, bottom: 3.0, right: 10.0),
                child: new Text(
                  text, style: TextStyle(fontSize: Dimens.font_sp12),),
              )
          )
      );
    }
  }
}