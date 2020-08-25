import 'dart:async';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/repository/wan_repository.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

/*const String kMockAppkey = 'f3ec3edba9f954c719c2a36a';
JmessageFlutter jmessage = new JmessageFlutter();//.private(_channel,const LocalPlatform());

final JMSingle kMockUser = JMSingle.fromJson({
  'username': '18301166286',
  'appKey': kMockAppkey
});*/
class MessageBloc /*implements BlocBase*/ {}

//  /*///****** ****** ****** 注册极光 ****** ****** ****** /
//  BehaviorSubject<JmessageFlutter> _sendCode = BehaviorSubject<JmessageFlutter>();
//  Sink<JmessageFlutter> get _sendCodeSink => _sendCode.sink;
//  Stream<JmessageFlutter> get sendCodeStream =>  _sendCode.stream;
//  ///****** ****** ****** 注册极光 ****** ****** ****** ///
//
//  ///***** ****** ******获取聊天列表
//  BehaviorSubject<List<JMConversationInfo>> _conversations = BehaviorSubject<List<JMConversationInfo>>();
//  Sink<List<JMConversationInfo>> get _conversationsSink => _conversations.sink;
//  Stream<List<JMConversationInfo>> get conversationsStream =>  _conversations.stream;
//  ///***** ****** ******获取聊天列表
//
//  WanRepository wanRepository = new WanRepository();
//
//  UserInfoModel userInfoModel;
//
//
//  MessageBloc() {
//    LogUtil.e("MessageBloc......");
//  }
//
//  @override
//  Future getData({String labelId, int page}) {
////    switch (labelId) {
////      case Ids.titleMessage:
////        return initMessageHome(labelId: labelId);
////        break;
////    }
//  }
//
//  @override
//  Future onLoadMore({String labelId}) {
//
//    return null;
//  }
//
//  @override
//  Future onRefresh({String labelId}) {
//
//    return null;
//  }
//
//  //初始化消息
//  Future initMessageHome({String labelId}){
//    userRegister();
//  }
//
//  //注册用户
//  void userRegister() async{
//    jmessage..setDebugMode(enable: true);
//    jmessage.init(isOpenMessageRoaming: true, appkey: kMockAppkey);
//
//    //先通过token获取个人基本信息
//    userInfoModel = await wanRepository.getUserInfo();
//    //注册用户
//    try {
//      await jmessage.userRegister(username: userInfoModel.mobilePhone,
//          password: Utils.generateMd5(userInfoModel.mobilePhone),
//          nickname: userInfoModel.realname);
//    }catch(_){
//
//    }finally {
//      await jmessage.login(username: userInfoModel.mobilePhone,
//          password: Utils.generateMd5(userInfoModel.mobilePhone));
//      await jmessage.updateMyInfo(gender: JMGender.female,
//          nickname: userInfoModel.realname,
//          extras: {
//            "personType": userInfoModel.personType,
//            "portrait": userInfoModel.portrait *//*,"userId":userInfoModel.id*//*
//          });
//      addListener(userInfoModel);
//
//      getMessageChatList();
//
//    }
//  }
//
//  //进入聊天
//  void enterConversation(JMConversationInfo conversationInfo){
//    jmessage.enterConversation(target: conversationInfo.target);
//  }
//  //离开聊天
//  void exitConversation(JMConversationInfo conversationInfo){
//    jmessage.exitConversation(target: conversationInfo.target);
//  }
//  //重置会话未读数量
//  void resetUnreadMessageCount(JMConversationInfo conversationInfo){
//    jmessage.resetUnreadMessageCount(target: conversationInfo.target);
//  }
//  //删除聊天会话，同时也会删除本地聊天记录。
//  void deleteConversation(JMConversationInfo conversationInfo){
//    jmessage.deleteConversation(target: conversationInfo.target);
//  }
//
//  //获取本地的聊天记录列表
//  void getMessageChatList() async{
//
//    //获取聊天记录列表
//    List<JMConversationInfo> jmConversations = await jmessage.getConversations();
//
//    _conversationsSink.add(jmConversations);
//
//    jmessage.resetUnreadMessageCount(
//        target: kMockUser
//    );
//
//  }
//
//
//
//  void testSendCustomMsg() async{
//    await jmessage.login(username: userInfoModel.mobilePhone, password: Utils.generateMd5(userInfoModel.mobilePhone));
//
//    JMConversationInfo conversation = await jmessage.createConversation(target: kMockUser);
//
//    conversation.sendTextMessage(text: '你好');
//
//    print(json.encode(conversation.latestMessage).toString());
//
////    jmessage.sendTextMessage(type: kMockUser,text: "i am your friend");
//
//  }
//
//  Future addListener(UserInfoModel userInfoModel) async {
//    LogUtil.e('添加消息监听');
////    await jmessage.login(username: userInfoModel.mobilePhone, password: Utils.generateMd5(userInfoModel.mobilePhone));
//    jmessage.addReceiveMessageListener((msg) {
//      getMessageChatList();
//      LogUtil.e('接收到消息 ${msg.toJson()}');
//      LogUtil.e('接收到消息00 ${msg}');
//      if (msg is JMVoiceMessage) {
//
//        jmessage.downloadVoiceFile(target: msg.from.targetType, messageId: msg.id);
//
////        print('send voice message11');
////        jmessage.sendVoiceMessage(
////          type: msg.from.targetType,
////          path: msg.path,
////        ).then((JMVoiceMessage message) {
////          // verifyMessage(message);
////          print('send voice message success ${message.toJson()}');
////        }).catchError((err) {
////          print('send voice error ${err}');
////        });
//      }
//
//      if (msg is JMImageMessage) {
//        jmessage.downloadThumbImage(target: msg.from.targetType, messageId: msg.id);
////        jmessage.sendImageMessage(
////          type: msg.from.targetType,
////          path: msg.thumbPath,
////
////        ).then((JMImageMessage message) {
////          print('send image success ${message.toJson()}');
////          jmessage.updateMyAvatar(imgPath: msg.thumbPath);
//////          jmessage.updateGroupAvatar(
//////              id: kMockGroupId,
//////              imgPath: msg.thumbPath
//////          );
////        }).catchError((err) {
////          print('the error ${err}');
////        });
//      }
//
//      if (msg is JMFileMessage) {
//
//        jmessage.downloadFile(
//          target: msg.from.targetType,
//          messageId: msg.id,
//        ).then((Map res) {
//
////          jmessage.sendFileMessage(
////              type: msg.from.targetType,
////              path: res['filePath'],
////              extras: {'fileType': 'video'}
////          ).then((JMFileMessage message) {
////            print('send file success ${message.toJson()}');
////          }).catchError((err) {
////            print('the error ${err}');
////          });
//        }).catchError((err) {
//          print('download file error');
//        });
//      }
//
//      print('send voice message22');
//    });
//
//    jmessage.addClickMessageNotificationListener((msg) {//+
//      print('flutter receive event  receive addClickMessageNotificationListener ${msg.toJson()}');
//    });
//
//    jmessage.addSyncOfflineMessageListener((conversation,msgs) {
//      print('receive offline message');
//      print('conversation ${conversation}');
//      print('messages ${msgs}');
//
//      for (dynamic msg in msgs) {
//        print('msg ${msg}');
//      }
//      print('flutter receive event verify receive offline message done!');
//    });
//
//    jmessage.addSyncRoamingMessageListener((conversation) {
//      print('flutter receive event receive roaming message');
//    });
//
//    jmessage.addLoginStateChangedListener((JMLoginStateChangedType type) {
//      print('flutter receive event receive login state change ${type}');
//    });
//
//    jmessage.addContactNotifyListener((JMContactNotifyEvent event) {
//      print('flutter receive event contact notify ${event.toJson()}');
//    });
//
//    jmessage.addMessageRetractListener((msg) {
//      print('flutter receive event message retract event');
//    });
//
//
//    jmessage.addReceiveChatRoomMessageListener((msgs) {//+
//      print('flutter receive event receive chat room message ');
//    });
//
//    jmessage.addReceiveTransCommandListener((JMReceiveTransCommandEvent event) {
//      print('flutter receive event receive trans command');
//    });
//
//    jmessage.addReceiveApplyJoinGroupApprovalListener((JMReceiveApplyJoinGroupApprovalEvent event) {
//
//      print('flutter receive event receive apply jocin group approval');
//    });
//
//    jmessage.addReceiveGroupAdminRejectListener((JMReceiveGroupAdminRejectEvent event) {
//      print('flutter receive event receive group admin rejected');
//    });
//
//    jmessage.addReceiveGroupAdminApprovalListener((JMReceiveGroupAdminApprovalEvent event) {
//      print('flutter receive event receive group admin approval');
//
//    });
//
//  }
//
//  @override
//  void dispose() {
//    // TODO: implement dispose
//  }

