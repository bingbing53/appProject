import 'dart:async';

import 'package:flutter/material.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/event/event-bus.dart';
import 'package:estate/ui/pages/page_index.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';
//我的待办
class PreparePage extends StatefulWidget{

  final String labelId;
  const PreparePage({Key key, this.labelId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PreparePageState();
  }
}
class PreparePageState extends State<PreparePage>{

  MissionBloc bloc;
  StreamSubscription subscription;
  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<MissionBloc>(context);
    subscription = ApplicationEvent.event.on<StatusEvent>().listen((event) {
      if(event.labelId == StatusEventConstant.REFRESH_BLOW_WILLRECORD_PAGE
          || event.labelId == StatusEventConstant.REFRESH_CALENDAR_PAGE){
        bloc.getMissionPrepare();
      }
    });

    bloc.getMissionPrepare();
  }

  @override
  void dispose() {
//    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e("MessagePage build......");
    RefreshController _controller = new RefreshController();

    return Scaffold(
      appBar: AppBar(
        title: Text('我的待办'),
      ),
      body: new RefreshScaffold(
        labelId: widget.labelId,
        controller: _controller,
        enablePullUp: false,
        onRefresh: ({bool isReload}) {
          return bloc.getMissionPrepare();
        },
        child:
          new ListView(
            children: <Widget>[
              new StreamBuilder(
                  stream: bloc.prepareStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<MissionModel>> snapshot) {
                    int loadStatus = Utils.getLoadStatus(snapshot.hasError, snapshot.data);
                    if(loadStatus == LoadStatus.empty){
                      return StatusViews(
                        loadStatus,
                        onTap: (){
                          bloc.getMissionPrepare();
                        },
                      );
                    }
                    return buildPrepare(snapshot.data,context);
                  }),
            ],
          ),
      )
    );
  }

  //构建聊天界面
  Widget buildPrepare(List<MissionModel> _selectedEvents,context){
    if (ObjectUtil.isEmpty(_selectedEvents)) {
      return new Container(height: 0.0);
    }

    List<Widget> items = [];

    List newSelectdEvents= [];
    if(ObjectUtil.isNotEmpty(_selectedEvents)){
      //计算任务是否重叠
      for(var i = 0;i<_selectedEvents.length;i++){
        _selectedEvents[i].start = (DateUtil.getDateTime(_selectedEvents[i].needTime).millisecondsSinceEpoch) * 1.0;

        if(DateUtil.getDateTime(_selectedEvents[i].needTime).isBefore(DateTime.now())){
          _selectedEvents[i].plused = 2;
        }
        newSelectdEvents.add(_selectedEvents[i]);
      }

      //先升序排序
      var temp;
      for(int i = newSelectdEvents.length - 1; i > 0; i--) {
        //进行这一轮的冒泡排序
        for(int j = 0; j < i; j++) {
          //从第一个元素开始和下一个比较，比下一个大则交换
          if(newSelectdEvents[j].start < newSelectdEvents[j + 1].start) {
            temp = newSelectdEvents[j];
            newSelectdEvents[j] = newSelectdEvents[j + 1];
            newSelectdEvents[j + 1] = temp;
          }
        }
      }

      for(var i = 0;i<newSelectdEvents.length;i++){

        items.add(
            GestureDetector(
              child:Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: EdgeInsets.only(left:10.0,right: 10.0,top: 10.0,bottom: 10.0),
                  margin: EdgeInsets.only(left: 5.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                            margin: EdgeInsets.only(right: 5.0),
                            decoration: BoxDecoration(
                                color: newSelectdEvents[i].cType == 'misson' ? newSelectdEvents[i].missionType == 'user' ? Colors.orange : Colors.red : Colors.blueAccent,
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Text('${newSelectdEvents[i].cType == 'misson' ? (newSelectdEvents[i].missionType == 'user'?'任务':'吹哨'):newSelectdEvents[i].cType == 'schedule'?'日程':(newSelectdEvents[i].cType == 'meeting'?'会议':'')}',style: TextStyle(fontSize: Dimens.font_sp12,color: Colors.white,fontWeight: FontWeight.bold),)
                          ),
                          Expanded(
                            child: Text('${newSelectdEvents[i].missionDes}',maxLines: 2,overflow: TextOverflow.ellipsis,style:TextStyle(fontSize: Dimens.font_sp16,color: Colours.text_normal),),
                          )
                        ],
                      ),
                      SizedBox(height: 5.0,),
                      Text(newSelectdEvents[i].needTime,style: TextStyle(fontSize: Dimens.font_sp12,color:newSelectdEvents[i].plused == 2 ? Colors.red:Colours.text_gray),),
                    ],
                  )
              ),
              onTap: (){
                scheduleOnTap(context,newSelectdEvents[i]);
              },
            )
        );
        items.add(Divider(height:1));
      }
    }

    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: items,
    );
  }

  scheduleOnTap(context,selectdEvent){
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
            title: new Text('我的${selectdEvent.cType == 'misson' ? (selectdEvent.missionType == 'user'?'任务':'吹哨'):selectdEvent.cType == 'schedule'?'日程':(selectdEvent.cType == 'meeting'?'会议':'')}'),
            content: Container(
              height: 70,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.flag),
                      Text('${selectdEvent.missionDes}',)
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(Icons.access_time),
                      Text('${Utils.timeShowFormat(DateUtil.getDateTime(selectdEvent.needTime))}',style: TextStyle(color: Colours.text_normal),)
                    ],
                  )
                ],
              ),
            ),
            actions:<Widget>[
              new FlatButton(child:new Text('详情',style: TextStyle(color:Colors.blueAccent),), onPressed: (){
                Navigator.of(context).pop();

                if(selectdEvent.cType == 'misson') {
                  if(selectdEvent.missionType == 'user') {
                    NavigatorUtil.pushPage(
                      context,
                      BlocProvider<MissionBloc>(
                        child: MissionDetailPage(
                            labelId: Ids.titleMission,
                            mission: selectdEvent),
                        bloc: new MissionBloc(),
                      ),
                      pageName: Ids.titleMission,
                    );
                  }else if(selectdEvent.missionType == 'willblow'){
                    NavigatorUtil.pushPage(
                      context,
                      BlocProvider<MissionBloc>(
                        child: BlowWillRecordPage(missionId: selectdEvent.id,
                            willId: selectdEvent.relatedId),
                        bloc: new MissionBloc(),
                      ),
                      pageName: Ids.titleMission,
                    );
                  }
                }else if(selectdEvent.cType == 'schedule'){
                  NavigatorUtil.pushPage(
                    context,
                    BlocProvider<MissionBloc>(
                      child: SchedulePage(
                          labelId: Ids.titleMission,
                          scheduleId: selectdEvent.id),
                      bloc: new MissionBloc(),
                    ),
                    pageName: Ids.titleMission,
                  );
                }else if(selectdEvent.cType == 'meeting'){
                  NavigatorUtil.pushPage(
                    context,
                    BlocProvider<MissionBloc>(
                      child: MeetingDetailPage(
                        labelId: Ids.titleMeeting,
                        meetingId: selectdEvent.id,),
                      bloc: new MissionBloc(),
                    ),
                    pageName: Ids.titleMission,
                  );
                }
              },)
            ]

        ));
  }

}