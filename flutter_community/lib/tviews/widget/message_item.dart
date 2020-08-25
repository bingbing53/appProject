import 'dart:async';

import 'package:flutter/material.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/data/api/apis.dart';
import 'package:helloworld/tviews/consumer/message/h_message_chat_page.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'package:helloworld/utils/util_index.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

class MessageItem extends StatelessWidget {
  const MessageItem(this.model, {Key key, this.isHome,this.bloc,this.showGroup}) : super(key: key);

  final JMConversationInfo model;
  final bool isHome;
  final MainBloc bloc;
  final String showGroup;

  @override
  Widget build(BuildContext context) {

    String portrait = '',chatName = model.title,lastMessage = '',lastTime='';
    Widget defaultChatIcon;
    if(model.conversationType == JMConversationType.single){
      //单聊
      JMUserInfo jmUserInfo = model.target;
      portrait = ShequejiaApi.format(jmUserInfo.extras['portrait']);
      defaultChatIcon = Image.asset(Utils.getImgPath('chat_single'));
      if(showGroup == '1'){
        return SizedBox(height: 0,);
      }
    }else if(model.conversationType == JMConversationType.group){
      JMGroupInfo groupInfo = model.target;
      if(groupInfo.ownerAppKey == '' && groupInfo.owner == ''){
        return Container(height: 0,);
      }
      //群聊
      defaultChatIcon = Image.asset(Utils.getImgPath('chat_group'));

      if(groupInfo.groupType == JMGroupType.public){
        defaultChatIcon = Image.asset(Utils.getImgPath('public_group'));
      }else if(groupInfo.groupType == JMGroupType.private && showGroup == '1'){
        return SizedBox(height: 0,);
      }
    }
    if(portrait == 'null'){
      portrait = '';
    }

    if(model.latestMessage != null) {
      if (model.latestMessage is JMTextMessage) {
        lastMessage = model.latestMessage.text;
      } else if (model.latestMessage is JMImageMessage) {
        lastMessage = '[图片]';
      } else if (model.latestMessage is JMVoiceMessage) {
        lastMessage = '[语音]';
      } else if(model.latestMessage is JMCustomMessage){
        try {
          JMCustomMessage customMessage = model.latestMessage;
          lastMessage = customMessage.extras['title'];
        }catch(_){}
      }
      lastTime = Utils.timeShortFormat(DateUtil.getDateStrByMs(model.latestMessage.createTime));
    }
    return new InkWell(
      onTap: () {
        LogUtil.e("ReposModel: " + model.toString());

        bloc.enterConversation(model);
        bloc.getHistoryMessages(model);

        NavigatorUtil.pushPage(context, MessageChatPage(model:model,labelId: Ids.titleChatMessage,),pageName:'测试');
      },
      onLongPress: (){
        _showMenu(context);
      },
      child: new Container(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Container(
                height: 55,
                width: 55,
                padding: EdgeInsets.only(left:6.0,right: 6.0,top:6.0,bottom: 6.0),
                margin: EdgeInsets.only(right: 10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child:ObjectUtil.isEmpty(portrait)? defaultChatIcon :CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: '$portrait',
                        errorWidget: (context, url, error) => new Icon(Icons.person,color: Colors.white,),
                      ),
                ),
              ),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('$chatName',style: TextStyle(fontSize: Dimens.font_sp16),maxLines: 1,overflow: TextOverflow.ellipsis,),
                          ),
                          Container(
                            padding: EdgeInsets.only(bottom: 6.0),
                            child: Text(lastTime,style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),),
                          )
                        ],
                      ),

                      SizedBox(height: 5.0,),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('${(lastMessage??'').trim()}',style: TextStyle(color: Colours.text_gray,fontSize: Dimens.font_sp12),overflow: TextOverflow.ellipsis,maxLines: 1,),
                          ),
                          model.unreadCount > 0 ? Container(
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.redAccent,
                              child: Text('${model.unreadCount}',style: TextStyle(color: Colors.white,fontSize: Dimens.font_sp12),)
                            )
                          ):SizedBox()
                        ],
                      )
                    ],
                  )
              )
            ],
          ),
          decoration: new BoxDecoration(
              color: Colors.white,
              border: new Border.all(width: 0.33, color: Colours.divider))),
    );
  }

  _showMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(0, 0), ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    showMenu<String>(
      context: context,
      items: _getPopupMenu(context),
      position: position,
    ).then<void>((String newValue) {
      if(newValue == 'delete'){
        bloc.deleteConversation(model);
      }
    });
  }

  _getPopupMenu(BuildContext context) {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'delete',
        child: Text('删除聊天记录'),
      )
    ];
  }
}
