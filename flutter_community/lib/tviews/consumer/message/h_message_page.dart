import 'package:flutter/material.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/event/event-bus.dart';
import 'package:helloworld/tviews/widget/message_item.dart';
import 'package:helloworld/tviews/widget/refresh_scaffold.dart';
import 'package:helloworld/tviews/widget/widget_index.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'package:helloworld/utils/util_index.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

import 'h_message_chat_page.dart';
bool isMessageInit = true;
//消息列表页面
class MessagePage extends StatelessWidget {
  const MessagePage({Key key, this.labelId,this.showGroup}) : super(key: key);

  final String labelId;
  final String showGroup;

  @override
  Widget build(BuildContext context) {
    RefreshController _controller = new RefreshController();
    final MainBloc bloc = BlocProvider.of<MainBloc>(context);

    //如果是初始化并且显示群组不是 '1'
    if (isMessageInit && showGroup != "1") {
      isMessageInit = false;
    }

    ApplicationEvent.event.on<StatusEvent>().listen((event) {
      print(event.labelId);
      if(event.labelId == StatusEventConstant.JUMP_CHATPAGE){
        NavigatorUtil.pushPage(context,
            MessageChatPage(model: event.obj, labelId: Ids.titleChatMessage,),pageName: '测试');
      }
    });

    
    return Scaffold(
      appBar: AppBar(
        title: Text('社区e家'),
        flexibleSpace: Image(
          image: AssetImage(Utils.getImgPath('home_top')),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: new RefreshScaffold(
        labelId: labelId,
        controller: _controller,
        enablePullUp: false,
        onRefresh: ({bool isReload}) {
//          bloc.getMessageChatList();
          return bloc.getMessageChatList();
        },
        child:
          new ListView(
            children: <Widget>[
              new StreamBuilder(
                  stream: bloc.conversationsStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<JMConversationInfo>> snapshot) {
                    int loadStatus = Utils.getLoadStatus(snapshot.hasError, snapshot.data);
                    if(loadStatus == LoadStatus.empty){
                      return StatusViews(
                        loadStatus,
                        onTap: (){
                          bloc.getMessageChatList();
                        },
                      );
                    }

                    return buildConverSationInfo(context,snapshot.data,bloc);
                  }),
            ],
          ),
      )
    );
  }

  //构建聊天界面
  Widget buildConverSationInfo(BuildContext context,List<JMConversationInfo> list,bloc){
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }
    List<Widget> _children = list.map((model) {
      return MessageItem(model,bloc:bloc,showGroup:showGroup);
    }).toList();

    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: _children,
    );
  }
}