import 'package:flutter/material.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/data/api/apis.dart';
import 'package:estate/ui/dialog/simple_dialog.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

class MessageChatItem extends StatelessWidget {
  const MessageChatItem(this.model, {Key key, this.isHome,this.bloc,this.showTime,this.conversationType}) : super(key: key);

  final dynamic model;
  final bool isHome,showTime;
  final WorkBloc bloc;
  final JMConversationType conversationType;

  @override
  Widget build(BuildContext context) {

    if(model is JMEventMessage || model == null){
      return EventMessage(model:model,bloc: bloc);
    }else if(model is JMCustomMessage){
      return CustomMessage(model:model,bloc:bloc);
    }else if(model is JMTextMessage){
      if(model.extras != null && model.extras.length > 0){
        if(model.extras['msg_type'] != 'normal')
          return CustomMessage(model:model,bloc:bloc);
      }
    }
    //普通的聊天消息
    JMUserInfo jmUserInfo = model.from;
    String nickName = jmUserInfo.nickname; //昵称
    String portrait = WanAndroidApi.format(jmUserInfo.extras['portrait']); //头像
    String createTime = Utils.timeShortFormat(DateUtil.getDateStrByMs(model.createTime),short: "1");

    return new Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              showTime ? Center(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(3.0),
                    child:Container(
//                      color: Colors.white70,
                      padding: EdgeInsets.only(left:10.0,right: 10.0,top: 3.0,bottom: 3.0),
                      child: Text(createTime,style: TextStyle(fontSize: Dimens.font_sp12),),
                    )
                ),
              ):Container(height: 0),
              Row(
                  children: model.isSend ? getSentMessageLayout(context,portrait,nickName):getAcceptMessageLayout(context,portrait,nickName)
              )
            ],
          )
    );
  }

  //自己
  List<Widget> getSentMessageLayout(BuildContext context,String portrait,String nickname) {
    return <Widget>[
          Expanded(
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    conversationType == JMConversationType.group ? new Text(nickname,):Container(height: 0),
                    buildMessageList(context),
                  ])),
          new Container(
            margin: const EdgeInsets.only(left: 12.0),
            height: 45.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: ObjectUtil.isEmpty(portrait) ? Image.asset(Utils.getImgPath('chat_single')) :CachedNetworkImage(
                fit: BoxFit.cover,
                height: 45,
                width: 45,
                imageUrl: '$portrait',
                errorWidget: (context, url, error) => Image.asset(Utils.getImgPath('chat_single')),
              ),
            ),
          ),
        ];
  }

  //别人
  List<Widget> getAcceptMessageLayout(BuildContext context,String portrait,String nickname){
    return <Widget>[
      new Container(
        margin: const EdgeInsets.only(right: 12.0),
        height: 45.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.0),
          child: ObjectUtil.isEmpty(portrait) ? Image.asset(Utils.getImgPath('chat_single')) :CachedNetworkImage(
            fit: BoxFit.fill,
            width: 45,
            height: 45,
            imageUrl: '$portrait',
            errorWidget: (context, url, error) => Image.asset(Utils.getImgPath('chat_single')),
          ),
        ),
      ),
      Expanded(
          child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                conversationType == JMConversationType.group ? new Text(nickname,):Container(height: 0),
                buildMessageList(context),
              ])),
    ];
  }

  Widget buildMessageList(context){
    var state = model.state;
    if(model.isSend) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
              child: buildWidget(),
              onLongPress: (){
                SimpleDialogUtil.confirmDialog(context,(){
                  bloc.retractMessage(model.serverMessageId);
                },content:"是否撤回消息",confirmText: '撤回',confirmType: ConfrimType.warning);
              },
          ),
          state == JMMessageState.send_failed?Container(
            child: Text('消息发送失败',textAlign: TextAlign.center,style: TextStyle(color: Colors.red,fontSize: Dimens.font_sp12),),
//            width: 22,
            margin: EdgeInsets.only(right: 3.0),
//            decoration: new BoxDecoration(
//              color: Colors.red,
//              //用一个BoxDecoration装饰器提供背景图片
//              borderRadius: BorderRadius.all(Radius.circular(18.0)),
//            ),
          ):Container(width: 0,),
        ],
      );
    }else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildWidget(),
        ],
      );
    }
  }

  Widget buildWidget(){

    if(model is JMImageMessage){
      return ImageMessage(model:model,bloc: bloc);
    }else if (model is JMTextMessage){
      return TextMessage(model:model,bloc: bloc);
    }else if(model is JMVoiceMessage){
      return VoiceMessage(model:model,bloc: bloc);
    }else if(model is JMFileMessage){
      return FileMessage(model:model);
    }else if(model is JMCustomMessage){
      return CustomMessage(model:model);
    }else if(model is JMLocationMessage){
      return LocationMessage(model:model);
    }else{
      return Container(height: 0,width: 0,);
    }
  }
}
