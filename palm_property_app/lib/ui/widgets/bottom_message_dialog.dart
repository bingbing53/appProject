
import 'dart:async';
import 'dart:io';

import 'package:estate/common/component_index.dart';
import 'package:estate/data/api/apis.dart';
import 'package:estate/data/protocol/estate_models.dart';
import 'package:estate/res/res_index.dart';
import 'package:estate/ui/dialog/simple_dialog.dart';
import 'package:estate/ui/widgets/widget_index.dart';
import 'package:flutter/material.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

/**
 * 底部弹出输入框
 */

JMUserInfo userInfo1;
JMUserInfo userInfo2;

class BottomMessageDialog extends StatelessWidget {

  final String orderId;

  const BottomMessageDialog({Key key, this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final WorkBloc bloc = BlocProvider.of<WorkBloc>(context);
    final EstateBloc estateBloc = BlocProvider.of<EstateBloc>(context);
    estateBloc.getOrderMessageList(orderId);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: <Widget>[
          Expanded(
              child: GestureDetector(
                child: Container(
                  color: Colors.black54,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
          ),
          Container(
            color: Colors.black54,
            child: Container(
                height: MediaQuery.of(context).size.height / 4 * 3,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(12),topRight: Radius.circular(12))
                ),
                padding: EdgeInsets.all(Dimens.gap_dp10),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: Dimens.gap_dp10,horizontal: Dimens.gap_dp10),
                      child:Row(
                        children: <Widget>[
                          SizedBox(width: Dimens.gap_dp10),
                          Image.asset(
                            Utils.getImgPath('contact_icon'),
                            width: 22.0,
                            height: 22.0,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: Dimens.gap_dp10),
                          Text('沟通记录',style: TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp16),),
                          Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  child: Container(
                                      padding: EdgeInsets.only(right: Dimens.gap_dp10),
                                      child:Icon(Icons.highlight_off,color: Colours.text_gray)
                                  ),
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                ),
                              )
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1,),

                    Expanded(
                      child:LayoutBuilder(
                          builder: (context,constraint){

//                            return SingleChildScrollView(
//                              child: ConstrainedBox(
//                                constraints: BoxConstraints(minHeight: constraint.maxHeight),
//                                child: IntrinsicHeight(
//                                  child: Column(
//                                    children: <Widget>[
//                                      Text("Header"),
//                                      Expanded(
//                                        child: Container(
//                                          color: Colors.red,
//                                        ),
//                                      ),
//                                      Text("Footer"),
//                                    ],
//                                  ),
//                                ),
//                              ),
//                            );

                            return  SingleChildScrollView(

                                physics: BouncingScrollPhysics(),
                                child:StreamBuilder(
                                    stream: estateBloc.messageHisotryCodeStream,
                                    builder: (BuildContext context,AsyncSnapshot<List<MessageHistoryModel>> snapshot) {
                                      print(snapshot.data);
                                      if(snapshot.data == null){
                                        return Container(padding: EdgeInsets.only(top:50.0),child: Text('加载中'));
                                      }
                                      if(snapshot.data.length == 0){
                                        return Container(padding: EdgeInsets.only(top:50.0),child: Text('没有记录',style: TextStyle(color: Colours.text_gray)));
                                      }
                                      return  buildContactMessage(snapshot.data,bloc);
                                    })
                            );
                          }
                      ),
                    ),
                  ],
                )
            )
          ),
        ],
      ),
    );
  }

  Widget buildContactMessage(List<MessageHistoryModel> data,WorkBloc bloc){
    //获取对话双方的极光注册信息
    if(data.length > 0){
      getUserInfo(bloc,from:data[0].from_id,fromAppKey:data[0].from_appkey,target: data[0].target_id,targetAppKey: data[0].target_appkey);
    }

    return StreamBuilder(
        stream: bloc.jmUserInfoStream,
        builder: (BuildContext context,AsyncSnapshot<Map<String,JMUserInfo>> snapshot) {
        if(snapshot.data == null){
          return Container(child: Text('加载中'));
        }

        return Container(
            child:Column(
              children: data.map((item){
                return buildChatItem(context,bloc,item,snapshot.data);
              }).toList(),
            )
        );;
    });
  }

  Widget buildChatItem(BuildContext context,WorkBloc bloc,MessageHistoryModel item,Map<String,JMUserInfo> jmUserInfos){
    return Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(3.0),
                  child:Container(
                    padding: EdgeInsets.only(left:10.0,right: 10.0,top: 3.0,bottom: 3.0),
                    child: Text(DateUtil.formatDate(item.msg_ctime),style: TextStyle(fontSize: Dimens.font_sp10,color: Colours.text_gray),),
                  )
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: item.target_appkey == shequejiaAppkey ? getSentMessageLayout(context,bloc,jmUserInfos[kMockAppkey],item,"0"):getAcceptMessageLayout(context,bloc,jmUserInfos[shequejiaAppkey],item,"1")
            )
          ],
        )
    );
  }

  //自己
  List<Widget> getSentMessageLayout(BuildContext context,WorkBloc bloc,JMUserInfo jmUserInfo,MessageHistoryModel item,String type) {
    String portrait = jmUserInfo.extras['portrait'];
    return <Widget>[
      Container(
        width: double.infinity,
        child:new Text('${jmUserInfo.nickname}（物业）',style: TextStyle(color: Colours.app_main),textAlign: TextAlign.end),
      ),
      SizedBox(height: 5),
      Row(
        children: <Widget>[
          Expanded(
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    buildMessageList(context,bloc,item,type),
                  ])),
          SizedBox(width: 10),
          new Container(
            margin: const EdgeInsets.only(right: 12.0),
            height: 40.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              child: ObjectUtil.isEmpty(portrait) ? Image.asset(Utils.getImgPath('chat_single')) :CachedNetworkImage(
                fit: BoxFit.cover,
                height: 40,
                width: 40,
                imageUrl: '${WanAndroidApi.format(portrait)}',
                errorWidget: (context, url, error) => Image.asset(Utils.getImgPath('chat_single')),
              ),
            ),
          ),
        ],
      ),
    ];
  }

  //业主
  List<Widget> getAcceptMessageLayout(BuildContext context,WorkBloc bloc,JMUserInfo jmUserInfo,MessageHistoryModel item,String type){
    String portrait = jmUserInfo.extras['portrait'];
    return <Widget>[
      Text('${jmUserInfo.nickname}（业主）',style: TextStyle(fontFamily: 'PingFang')),
      SizedBox(height: 5),
      Row(
        children: <Widget>[
          Container(
            height: 40.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              child: ObjectUtil.isEmpty(portrait) ? Image.asset(Utils.getImgPath('chat_single')) :CachedNetworkImage(
                fit: BoxFit.fill,
                width: 40,
                height: 40,
                imageUrl: '${WanAndroidApi.format(portrait)}',
                errorWidget: (context, url, error) => Image.asset(Utils.getImgPath('chat_single')),
              ),
            ),
          ),
          SizedBox(width:10),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildMessageList(context,bloc,item,type),
                  ])),
        ],
      ),
    ];
  }

  Widget buildMessageList(BuildContext context,WorkBloc bloc,MessageHistoryModel item,String type){
    if(item.msg_type == 'text'){
      return Container(
          margin: const EdgeInsets.only(top:5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child:Container(
                color: type == '0'?Colours.app_main:Color(0xfff8f8f8),
                padding: EdgeInsets.only(top:6.0,bottom: 6.0,left: 10.0,right: 10.0),
                child:new Text(item.msg_body['text']??' ',style: TextStyle(fontFamily:'PingFang',color: type == '0'?Colors.white:Color(0xff434b65)),),
              )
          )
      );
    }else if(item.msg_type == 'image'){
      return GestureDetector(
        child:Container(
            height: 120,
            width: 80,
            child:CachedNetworkImage(imageUrl: item.filePath,fit: BoxFit.cover)
        ),
        onTap: (){
          NavigatorUtil.pushPage(context, PreviewImagesWidget([item.filePath],initialPage: 0),pageName: 'preview');
        },
      );
    }else if(item.msg_type == 'voice'){
      int duration = item.msg_body['duration'];
      return Container(child:
          GestureDetector(
              child: Row(
              mainAxisAlignment:type == '0' ? MainAxisAlignment.end: MainAxisAlignment.start,
              children: type == '0' ?
              <Widget>[
                Text('${duration~/1}″ ',style: TextStyle(color: Colours.text_gray),),
                ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child:Container(
                      color: Colours.app_main,
                      padding: EdgeInsets.only(left:6.0+duration*3,right: 6.0,top: 4.0,bottom: 4.0),
                      child:Icon(Icons.surround_sound,color: Colours.divider,),
                    )
                ),
              ]:
              <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child:Container(
                      color: Color(0xfff8f8f8),
                      padding: EdgeInsets.only(left:6.0,right: 6.0+duration,top: 4.0,bottom: 4.0),
                      child:Icon(Icons.surround_sound,color: Colours.divider,),
                    )
                ),
                Text(' ${duration~/1}″',style: TextStyle(color: Colours.text_gray),),
              ]
          ),
          onTap: (){
            bloc.startPlayer(item.filePath);
          },
        )
      );
    }else{
      return Container();
    }
  }

  //获取用户的信息
  Future getUserInfo(WorkBloc bloc,{String from,String fromAppKey,String target,String targetAppKey}) async {
    userInfo1 = await bloc.getUserInfoByUsername(from,appkey: fromAppKey);
    userInfo2 = await bloc.getUserInfoByUsername(target,appkey: targetAppKey);

    Map<String,JMUserInfo> userInfoMap = {
      fromAppKey:userInfo1,
      targetAppKey:userInfo2
    };

    bloc.jmUserInfoSink.add(userInfoMap);
  }
}