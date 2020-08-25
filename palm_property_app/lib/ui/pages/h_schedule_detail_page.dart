import 'package:flutter/material.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/ui/dialog/simple_dialog.dart';
import 'package:estate/ui/pages/page_index.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';
class SchedulePage extends StatelessWidget {
  const SchedulePage({Key key, this.labelId,this.scheduleId}) : super(key: key);

  final String labelId;
  final String scheduleId;
  @override
  Widget build(BuildContext context) {
    LogUtil.e("MessagePage build......");
    final MissionBloc bloc = BlocProvider.of<MissionBloc>(context);
    bloc.scheduleDetail(scheduleId);

    return Scaffold(
      backgroundColor: Colours.gray_f0,
      appBar: AppBar(
        title: Text('日程详情'),
        actions: <Widget>[
          IconButton(icon: new Image.asset(Utils.getImgPath('icon_schedule_delete'),height: 20,), onPressed: (){
            SimpleDialogUtil.confirmDialog(context, (){
              bloc.deleteSchedule(scheduleId).then((v){
                Fluttertoast.showToast(msg: '删除成功');
                Navigator.pop(context);
              });
            },title: '日程删除提醒',content: '是否确认删除此日程',confirmText: '确认删除',confirmType: ConfrimType.warning);
          }),
          IconButton(
            icon: new Image.asset(Utils.getImgPath('icon_schedule_edit'),height: 20,),
            onPressed: (){
              NavigatorUtil.pushReplacePage(
                context,
                BlocProvider<MissionBloc>(
                  child: CreateSchedulePage(labelId: Ids.titleEditSchedule,scheduleId: scheduleId,),
                  bloc: new MissionBloc(),
                ),
                pageName: Ids.titleMission,
              );
            },
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            new StreamBuilder(
                stream: bloc.scheduleReposStream,
                builder: (BuildContext context,
                    AsyncSnapshot<ScheduleModel> snapshot){
                  return buildScheduleDetail(snapshot.data);
                })
//              Flexible(
//                child:new ListView(
//                    reverse: true,
//                    controller: bloc.initScrollController(labelId:labelId),
//                    children: <Widget>[
//                      new StreamBuilder(
//                          stream: bloc.historyMessageStream,
//                          builder: (BuildContext context,
//                              AsyncSnapshot<List> snapshot) {
//                            return buildConverChat(context,snapshot.data,bloc);
//                          }),
//                    ],
//                  ),
//              ),
//              new Container(
//                decoration: new BoxDecoration(
//                  color: Theme.of(context).cardColor,
//                ),
//                child: _buildTextComposer(bloc),
//              )
          ],
        ),
      )
    );
  }

  Widget buildScheduleDetail(ScheduleModel model){
    if(ObjectUtil.isEmpty(model))
      return Container(height: 0,);
    return new ListView(
      shrinkWrap: true,
//      padding: const EdgeInsets.all(20.0),
      children: <Widget>[
        ListTile(
          title: Text(model.title),
          subtitle: Text('日程标题'),
        ),
        Divider(height: 1,),
        ListTile(
          title: Text(model.des),
          subtitle: Text('日程描述'),
        ),
        Divider(height: 1,),
        ListTile(
          title: Text(model.location),
          subtitle: Text('日程地点'),
        ),
        Divider(height: 1,),
        ListTile(
          title: Text(model.startTime),
          subtitle: Text('开始时间'),
        ),
        Divider(height: 1,),
        ListTile(
          title: Text(model.endTime),
          subtitle: Text('结束时间'),
        ),
      ],
    );
  }

//  Widget _buildTextComposer(WorkBloc bloc) {
//    return  new Container(
//        margin: const EdgeInsets.symmetric(horizontal: 8.0),
//        child: new Row(
//          children: <Widget>[
//            new Container(
//                margin: new EdgeInsets.symmetric(horizontal: 4.0),
//                child: GestureDetector(
//                  child: new Icon(Icons.video_library),
//                  onLongPress: () {
//                    bloc.startRecorder();
//                  },
//                  onLongPressUp: (){
//                    bloc.stopRecorder();
//                  },
//                )
//            ),
//            new Flexible(
//              child: new TextField(
//                controller: bloc.initTextEditController(),
////                onSubmitted: _handleSubmitted,
////                focusNode: bloc.focusNodeInit(),
//                decoration:new InputDecoration.collapsed(hintText: ""),
//                onTap:bloc.scroll2Bottom
//              ),
//            ),
//            new Container(
//              margin: new EdgeInsets.symmetric(horizontal: 4.0),
//              child: new IconButton(
//                  icon: new Icon(Icons.send),
//                  onPressed: () => bloc.sendMessage(model))
////                  ),
//            ),
//            new Container(
//                margin: new EdgeInsets.symmetric(horizontal: 4.0),
//                child: new IconButton(
//                    icon: new Icon(Icons.add_a_photo),
//                    onPressed: () => bloc.sendImageMessage(model))
////                  ),
//            ),
//          ],
//        ),
//    );
//  }

  //构建聊天界面
  Widget buildConverChat(BuildContext context,List<dynamic> list,WorkBloc bloc){
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }
    List<Widget> _children = list.map((model) {
      return MessageChatItem(model,bloc: bloc,);
    }).toList();

    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: _children,
    );
  }
}