import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/ui/dialog/simple_dialog.dart';
import 'package:flutter_wanandroid/ui/pages/page_index.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';
bool isMessageChatInit = true;

class MessageChatPage extends StatefulWidget{
  const MessageChatPage({Key key, this.labelId,this.model}) : super(key: key);
  final String labelId;
  final JMConversationInfo model;

  @override
  State<StatefulWidget> createState() {
    return _MessageChatPage();
  }
}

//聊天页面
class _MessageChatPage extends State<MessageChatPage> {

  final TextEditingController _textController = new TextEditingController();
  final ScrollController _scrollController = new ScrollController();
  WorkBloc bloc;

  String inputType = 'text';

  Timer _timer;

  @override
  void initState() {
    super.initState();

    bloc = BlocProvider.of<WorkBloc>(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        bloc.onLoadMore(labelId: widget.labelId,model: widget.model);
      }
      if(_scrollController.position.pixels <= 0){
        bloc.resetReposPage();
      }
    });


    _timer = new Timer.periodic(Duration(seconds: 5), (timer){
      bloc.getHistoryMessages(widget.model);
    });

  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e("MessagePage build......");
    return Scaffold(
      backgroundColor: Colours.gray_f0,
      appBar: AppBar(
        title: Text(widget.model.title),
        actions: <Widget>[
          buildFirstButton()
        ],
      ),
      body: WillPopScope(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[

                  Flexible(
                    child:new ListView(
                      reverse: true,
                      controller: _scrollController,
                      children: <Widget>[
                        new StreamBuilder(
                            stream: bloc.historyMessageStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<List> snapshot) {
                              return buildConverChat(context,snapshot.data,bloc);
                            }),
                      ],
                    ),
                  ),
                  new Container(
                    decoration: new BoxDecoration(
                      color: Theme.of(context).cardColor,
                    ),
                    child: _buildTextComposer(bloc),
                  )
                ],
              ),

              start > 0 ? Positioned(
                top: MediaQuery.of(context).size.height / 6,
                left: MediaQuery.of(context).size.width / 4,
                child: Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child:
                      Container(
                        width: MediaQuery.of(context).size.width / 2,height: MediaQuery.of(context).size.width / 2,
                        color: Colours.transparent_80,
                        padding: EdgeInsets.only(top: 30),
                        child: Column(
                          children: <Widget>[
//                            Icon(Icons.speaker_phone,color: Colors.white,size: MediaQuery.of(context).size.width / 4,),
                            new Container(child: SpinKitRipple(color: Colors.white,size: MediaQuery.of(context).size.width / 4,)),
                            Text('开始录音',style: TextStyle(color: Colors.white,fontSize: Dimens.font_sp20),)
                          ],
                        ),
                      )
                  )
                )
              ):Container(height: 0)
            ],
          ),
          onWillPop: (){
            return chatExit();
          })
    );
  }

  Future<bool> chatExit() async{
    _timer?.cancel();
    await bloc.exitConversation(widget.model);
    await bloc.getMessageChatList();
//    Navigator.pop(context);
//    new Future.value(true);
    return true;
  }

  Widget buildFirstButton(){
    return widget.model.conversationType == JMConversationType.group ? IconButton(
      onPressed: (){
        pushPage(context,bloc);
      },
      icon: Icon(Icons.more_horiz,color: Colors.white,),
    ):Container(height: 0);
  }

  void pushPage(context,bloc) async{
    if(widget.model.conversationType == JMConversationType.group) {
      final result = await Navigator.push( //等待
          context, MaterialPageRoute(
          builder: (context) =>
              BlocProvider<MissionBloc>(
                child: new MessageChatDetailPage(labelId: widget.labelId, model: widget.model),
                bloc: new MissionBloc(),
              ),
          )
      );
      //退出页面
      if (result == 'close') {
        Navigator.pop(context);
      }
    }
  }

  int start = 0;
  Widget _buildTextComposer(WorkBloc bloc) {
    return  new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
          new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: GestureDetector(
                  child: new Icon(inputType == 'voice' ? Icons.text_fields:Icons.record_voice_over,color: Colours.text_gray,),
                  onTap: (){
                    if(inputType == 'text') {
                      inputType = 'voice';
                    }else if(inputType == 'voice') {
                      inputType = 'text';
                    }
                    setState(() {});
                  },
                )
            ),
            inputType == 'voice'?Expanded(
              child: GestureDetector(
                  child: RoundButton(
                    bgColor: Colours.app_main,
                    radius:5,
                    width: 60,
                    text: '长摁录音',
                    height: 35,
                    style: TextStyle(fontSize: Dimens.font_sp14,color: Colors.white),
                  ),
                onLongPress: () {
                  bloc.startRecorder();
                  start = DateTime.now().millisecondsSinceEpoch;
                  setState(() {});
                },
                onLongPressUp: (){
                  int end = DateTime.now().millisecondsSinceEpoch;
                  if(end - start < 800){
                    Fluttertoast.showToast(msg: '时间太短');
                    bloc.cancelRecorder();
                  }else {
                    bloc.stopRecorder();
                  }
                  start = 0;
                  setState(() {});
                },
                onLongPressMoveUpdate : (detail){
                    double height = MediaQuery.of(context).size.height;
                    if(height - detail.globalPosition.dy > 50) {
                      bloc.cancelRecorder();
                      Fluttertoast.showToast(msg: '取消发送');
                      start = 0;
                    }

                    setState(() {});
                },
              )
            ):Container(),
            inputType == 'text' ?new Flexible(
              child: Container(
                color: Colors.white,
                child: new TextField(
                    maxLines: null,
                    maxLengthEnforced: false,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _textController,
                    decoration:new InputDecoration(
                      contentPadding: EdgeInsets.only(top: 5.0,bottom: 5.0)
                    ),//.collapsed(hintText: ""),
                    maxLength: 1000,
                    onTap:(){
                      _scrollController.jumpTo(0);
                    }
                )
              ),
            ):Container(height: 0),
            new Container(
                margin: new EdgeInsets.symmetric(horizontal: 2.0),
                child: new IconButton(
                    icon: new Icon(Icons.add_circle_outline,size: 33,color: Colours.text_gray,),
                    onPressed: () => bloc.sendImageMessage(widget.model))
//                  ),
            ),
            inputType == 'text' ? new RoundButton(
              radius:3,
              width: 60,
              text: '发送',
              height: 35,
              style: TextStyle(fontSize: Dimens.font_sp14,color: Colors.white),
              onPressed: () {
                bloc.sendMessage(_textController,widget.model);
              },
            ):Container(height: 0,)
          ],
        ),
    );
  }

  //构建聊天界面
  Widget buildConverChat(BuildContext context,List<dynamic> list,WorkBloc bloc){
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }

    List<Widget> _children = [];
    for(var i = 0 ;i<list.length;i++){
      bool showTime = false;
      var model = list[i];
      if(model == null) continue;
      if(i == 0){
        showTime = true;
      }else{
        var subModel = list[i-1];
        if(subModel == null) continue;
        int splus = model.createTime - subModel.createTime;
        if(splus > 60000)  showTime = true;
      }

      _children.add(MessageChatItem(model,bloc: bloc,showTime: showTime,conversationType:widget.model.conversationType));
    }

//    List<Widget> _children = list.map((model) {
//
//
//      return MessageChatItem(model,bloc: bloc,);
//    }).toList();

    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: _children,
    );
  }
}