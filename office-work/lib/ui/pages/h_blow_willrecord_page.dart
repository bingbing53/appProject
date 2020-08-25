
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/blocs/bloc_index.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/api/apis.dart';
import 'package:flutter_wanandroid/event/event-bus.dart';
import 'package:flutter_wanandroid/res/res_index.dart';
import 'package:flutter_wanandroid/ui/dialog/simple_dialog.dart';
import 'package:flutter_wanandroid/ui/pages/page_index.dart';

import 'package:flutter_wanandroid/utils/util_index.dart';

//民情民意吹哨
class BlowWillRecordPage extends StatefulWidget {

  final String willId,missionId;

  const BlowWillRecordPage({Key key,this.missionId,this.willId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _BlowWillRecordState();
  }
}
class _BlowWillRecordState extends State<BlowWillRecordPage>{
  MissionBloc missionBloc;
  WorkBloc workBloc;
  bool _isExpanded = true;
  ScrollController _timeLineScrollController = new ScrollController();

  bool showButtonBar = false;

  WillRecordModel willRecordModel;

  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    missionBloc = BlocProvider.of<MissionBloc>(context);
    workBloc = BlocProvider.of<WorkBloc>(context);

    if(ObjectUtil.isNotEmpty(widget.willId))
      missionBloc.willRecordDetail(widget.willId);
    missionBloc.getMissionDetail(widget.missionId);


    subscription = ApplicationEvent.event.on<StatusEvent>().listen((event) {
      if(event.labelId == StatusEventConstant.REFRESH_BLOW_WILLRECORD_PAGE){
        missionBloc.getMissionDetail(widget.missionId);
      }
    });

    missionBloc.moduleDetailReposStream.listen((data){
      showButtonBar = false;
      final String mineUserId = data['userId'];
      final String owner = data['owner']['id'];
      if(mineUserId == owner){
        showButtonBar = true;
      }
      final List receiveUsers = data['receiveUsers'];
      if(!ObjectUtil.isEmptyList(receiveUsers)){
        for(var i = 0;i<receiveUsers.length;i++){
          if(receiveUsers[i]['userId'] == mineUserId){
            showButtonBar = true;
          }
        }
      }
      setState((){});
    });

    missionBloc.willRecordModelReposStream.listen((val){
      setState((){
        willRecordModel = val;
      });
    });

  }

  @override
  void dispose() {
//    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('民意处理'),
      ),
      body: Column(
          children: <Widget>[
            StreamBuilder(
                stream: missionBloc.willRecordModelReposStream,
                builder: (BuildContext context,
                    AsyncSnapshot<WillRecordModel> snapshot) {
                  if(ObjectUtil.isEmpty(snapshot.data)){
                    return Container(height: 0);
                  }
                  willRecordModel = snapshot.data;

                  return Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(bottom: Dimens.gap_dp5),
                    padding: EdgeInsets.all(10.0),
                    width: double.infinity,
                    child: Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: <Widget>[
                                ExpansionPanelList(
                                  children : <ExpansionPanel>[
                                    ExpansionPanel(
                                      headerBuilder:(context, isExpanded){
                                        return ListTile(
                                          title: Text('${willRecordModel.categoryName}问题'),
                                        );
                                      },
                                      body: Padding(
                                        padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                                        child: ListBody(
                                          children: <Widget>[
                                            Text('反馈标题：${willRecordModel.title}'),
                                            SizedBox(height: 5.0,),
                                            Text('反馈内容：${willRecordModel.content}'),
                                            SizedBox(height: 5.0,),
                                            buildWillRecordImages(willRecordModel.images),
                                            SizedBox(height: 5.0,),
                                            Text('反 馈 人：${willRecordModel.username}  ${willRecordModel.mobile}'),
                                            SizedBox(height: 5,),
                                            Text('反馈人地址：${willRecordModel.address}'),
                                            SizedBox(height: 4.0,),
                                            Row(
                                              children: <Widget>[
                                                Text('${willRecordModel.collectUser}收录',style: TextStyle(color: Colors.blueAccent,fontSize: Dimens.font_sp12),),
                                                Expanded(
                                                  child: Text('${willRecordModel.createDate}',style: TextStyle(color: Colours.text_gray,fontSize: Dimens.font_sp12),textAlign: TextAlign.end,),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      isExpanded: _isExpanded,
                                      canTapOnHeader: true,
                                    ),

                                  ],
                                  expansionCallback:(panelIndex, isExpanded){
                                    setState(() {
                                      _isExpanded = !isExpanded;
                                    });
                                  },
                                  animationDuration : kThemeAnimationDuration,
                                ),
                              ],
                        ),
                    ),
                  );
                }
            ),
            Expanded(
              child: StreamBuilder(
                  stream: missionBloc.moduleDetailReposStream,builder: (BuildContext context,AsyncSnapshot<Map> snapshot) {
                return StatefulHistory(snapshot.data);
              }
              ),
            ),
          ],
      ),
      bottomNavigationBar: buildBottomNavigation(),
    );
  }

  Widget buildWillRecordImages(String images){
    List<Widget> widgets = [];
    if(!ObjectUtil.isEmpty(images)) {
      try {
        var arr = json.decode(images);
        if (!ObjectUtil.isEmpty(arr)) {
          for (var i = 0; i < arr.length; i++) {
            widgets.add(GestureDetector(
              onTap: () {
                NavigatorUtil.imagePreview(
                    context, netSrc: WanAndroidApi.format(arr[i]));
              },
              child: new CachedNetworkImage(
                width: 80,
                height: 80,
                fit: BoxFit.fill,
                imageUrl: WanAndroidApi.format(arr[i]),
              ),)
            );
          }
        }
      }catch(err){

      }
    }

    return Container(
      child: Wrap(
        direction:Axis.horizontal,
        spacing: 5,
        children: widgets,
      ),
    );
  }

  List historys = [];
  Widget StatefulHistory(datas){
    var data = datas;
    if(ObjectUtil.isEmpty(datas) || ObjectUtil.isEmpty(datas['historys']) || datas['historys'].length <= 0)
      return Container(height: 0,);

    historys.clear();
    if(ObjectUtil.isEmpty(widget.willId))
      missionBloc.willRecordDetail(data['mission']['relatedId']);

    for(var i = 0;i<data['historys'].length;i++){
      data['historys'][i]['work'] = '0';
      historys.add(data['historys'][i]);
    }
    if(ObjectUtil.isNotEmpty(data['workHistorys'])){
      List workHistorys = data['workHistorys'];
      for(var i = 0;i<workHistorys.length;i++){
        workHistorys[i]['work'] = '1';
        historys.add(workHistorys[i]);
      }

      dynamic temp;
      for(int i = historys.length - 1; i > 0; i--) {
        //进行这一轮的冒泡排序
        for(int j = 0; j < i; j++) {
          //从第一个元素开始和下一个比较，比下一个大则交换
          var start = 0,end = 0;
          start = DateUtil.getDateMsByTimeStr(historys[j]['create_date']);
          end = DateUtil.getDateMsByTimeStr(historys[j+1]['create_date']);

          if(start < end){
            temp = historys[j];
            historys[j] = historys[j + 1];
            historys[j + 1] = temp;
          }
        }
      }
    }

    print(historys.length);

    return Container(
      width: double.infinity,
//      color: Colors.white,
      margin: EdgeInsets.only(left: 10.0),
      child: timelineModel(TimelinePosition.Left)
    );
  }

  timelineModel(TimelinePosition position) => Timeline.builder(
      controller: _timeLineScrollController,
      lineColor:Colours.text_gray,
      lineWidth:1.0,
      shrinkWrap:true,
      iconSize: 16,
      itemBuilder: centerTimelineBuilder,
      itemCount: historys.length,
      physics: position == TimelinePosition.Center
          ? ClampingScrollPhysics()
          : BouncingScrollPhysics(),
      position: position);

  TimelineModel centerTimelineBuilder(BuildContext context, int i) {
    final doodle = historys[i];
    print(doodle);
    return TimelineModel(
      Card(
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.0)),
        elevation: 0.0,
        clipBehavior: Clip.antiAlias,
        child: doodle['work'] == '1'?createWorkHistoryTimeLine(doodle):createWillTimeLine(doodle)
      ),
//      position: i % 2 == 0 ? TimelineItemPosition.right : TimelineItemPosition.left,
      isFirst: i == 0,
      isLast: i == historys.length,
      iconBackground: i == 0 ? Colors.blueAccent:Colors.grey,
//      icon: Icon(Icons.fiber_manual_record,color: Colours.divider,size: 1,)
      );
  }

  Widget createWillTimeLine(doodle){
    return Container(
      margin: EdgeInsets.all(10.0),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              getStateLabel(doodle),
              Expanded(
                  child: Text(
                    Utils.timeShortFormat(doodle['create_date']??''),
                    style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),
                    textAlign: TextAlign.end,
                  )
              ),
            ],
          ),

          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              children: <Widget>[
                Text('发  送  人：',style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),),
                Text('${doodle['startDepart']??''}：${doodle['startName']??''}')
              ],
            ),
          ),

          doodle['state'] != '6'?Container(
            child: Row(
              children: <Widget>[
                Text('接  收  人：',style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),),
                doodle['state'] == '8' ?
                (ObjectUtil.isEmpty(willRecordModel) ? Container(height: 0):Text('${willRecordModel.username??''} ${willRecordModel.mobile??''}'))
                    : Text('${doodle['endDepart']??''}：${doodle['endName']??''}')
              ],
            ),
          ):Container(height: 0,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child:
            Wrap(
              children: <Widget>[
                Text('处理意见：',style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),),
                Text(doodle['des']??'',style: TextStyle(fontSize: Dimens.font_sp14),softWrap: true),
              ],
            ),
          ),
          gotoDetail(doodle)
        ],
      ),
    );
  }

  Widget createWorkHistoryTimeLine(doodle){
    return Container(
      margin: EdgeInsets.all(10.0),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5.0)),
                child: Text('工作记录',style: TextStyle(fontSize: Dimens.font_sp12,color: Colors.white),)
              ),
              Expanded(
                  child: Text(
                    Utils.timeShortFormat(doodle['create_date']??''),
                    style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),
                    textAlign: TextAlign.end,
                  )
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 5.0,bottom: 10),
            child: Text(doodle['content'],style: TextStyle(fontSize: Dimens.font_sp14),)
          ),
          Row(
            children: <Widget>[
              Expanded(
                child:Text(doodle['realname'],style: TextStyle(fontSize: Dimens.font_sp12),),
              ),
              gotoDetail(doodle)
            ],
          ),
//          gotoDetail(doodle)
        ],
      ),
    );
  }

  //去往查看详情
  Widget gotoDetail(history){
    if(history['work'] == '1'){
      return GestureDetector(
        child: Container(
//          width: double.infinity,
          child: Text('查看详情',style: TextStyle(fontSize: Dimens.font_sp12,color: Colors.blue),textAlign: TextAlign.end,),
        ),
        onTap: (){
          NavigatorUtil.pushWeb(context,url: WanAndroidApi.WORKRECORD_DETAIL + history['id'] ,title: '记录详情');
        },
      );
    }

    String state = history['state'];
    if(state == '6' || state == '7'){
      return  GestureDetector(
        child: Container(
          width: double.infinity,
          child: Text('查看详情',style: TextStyle(fontSize: Dimens.font_sp12,color: Colors.blue),textAlign: TextAlign.end,),
        ),
        onTap: () {
          if(state == '6'){
            //会议
            NavigatorUtil.pushPage(
              context,
              BlocProvider<MissionBloc>(
                child: MeetingDetailPage(
                  labelId: Ids.titleWillMeeting,
                  missionHisotryId: history['id'],),
                bloc: new MissionBloc(),
              ),
              pageName: '查看详情'
            );
          }else if(state == '7'){
            //办结
            NavigatorUtil.pushPage(
              context,
              BlocProvider<MissionBloc>(
                child: BlowWillSolvePage(
                  labelId: Ids.titleBlowFinishDetail,
                  missionId: widget.missionId,
                  ownerUser:history['start_user_id']
                ),
                bloc: new MissionBloc(),
              ),
              pageName: Ids.titleBlowFinishDetail,
            );
          }else if(state == '8'){
            //反馈
//            NavigatorUtil.pushPage(
//              context,
//              BlocProvider<MissionBloc>(
//                child: CreateMeetingPage(
//                  labelId: Ids.title,
//                  missionId: widget.missionId,),
//                bloc: new MissionBloc(),
//              ),
//              pageName: Ids.titleMission,
//            );
          }
        },
      );
    }
    return Container(height: 0,);
  }

  Widget getStateLabel(history){
    String state = history['state'];
    Color btnColor = Colors.grey;
    String text = '';
    switch(state){
      case '0':
        btnColor = Colors.red;
        text = '吹哨';
        break;
      case '3':
        btnColor = Colors.blueAccent;
        text = '移交';
        break;
      case '6':
        btnColor = Colors.orange;
        text = '会议';
        break;
      case '7':
        btnColor = Colors.green;
        text = '办结';
        break;
      case '8':
        btnColor = Colors.red;
        text = '反馈';
        break;
    }
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.circular(5.0)),
        child: Text(text,style: TextStyle(fontSize: Dimens.font_sp12,color: Colors.white,fontWeight: FontWeight.bold),)
    );
  }

  Widget buildBottomNavigation(){
    return !showButtonBar?Container(height: 0):Container(
      height: 50.0,
      decoration: new BoxDecoration(
        color: Colors.white,
        border: new Border(top: BorderSide(color: Colours.divider,width: 0.2))
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child:InkWell(
              child: Text('移交',textAlign: TextAlign.center,style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
              onTap: () async {
                final result = await NavigatorUtil.pushPageAsync(
                    context, BlocProvider<MissionBloc>(
                  child: BlowWillSolvePage(
                    labelId: Ids.titleWillBlowTans,
                    missionId: widget.missionId,),
                    bloc: new MissionBloc(),
                  ),
                );
                print(result);
                if(result == 'refresh'){
                  missionBloc.getMissionDetail(widget.missionId);
                }
              },
            )
          ),
          Expanded(
            child:InkWell(
              child: Text('会议',textAlign: TextAlign.center,style: TextStyle(color: Colors.orangeAccent,fontWeight: FontWeight.bold),),
              onTap: () async {
                 final result = await NavigatorUtil.pushPageAsync(
                    context,
                    BlocProvider<MissionBloc>(
                      child: CreateMeetingPage(
                          labelId: Ids.titleMission,
                          missionId: widget.missionId,
                          title:willRecordModel.title),
                      bloc: new MissionBloc(),
                    ),
                  );
                 print(result);
                 if(result == 'refresh'){
                   missionBloc.getMissionDetail(widget.missionId);
                 }
              },
            )
          ),
          Expanded(
            child:InkWell(
            child:Text('办结',textAlign: TextAlign.center,style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
              onTap: () async {
//                final result = await Navigator.push(
//                    context, new CupertinoPageRoute<void>(builder: (ctx) => BlocProvider<MissionBloc>(
//                    child:  BlocProvider<MissionBloc>(
//                      child: BlowWillSolvePage(
//                        labelId: Ids.titleWillFinish,
//                        missionId: widget.missionId,),
//                      bloc: new MissionBloc(),
//                    ),)));
//                missionBloc.getMissionDetail(widget.missionId);

                final result = await NavigatorUtil.pushPageAsync(
                  context,
                  BlocProvider<MissionBloc>(
                    child: BlowWillSolvePage(
                      labelId: Ids.titleWillFinish,
                      missionId: widget.missionId,),
                    bloc: new MissionBloc(),
                  ),
                );
                print(result);
                if(result == 'refresh'){
                  missionBloc.getMissionDetail(widget.missionId);
                }
              },
            )
          ),
          Expanded(
            child:
            InkWell(
              child: Text('反馈',textAlign: TextAlign.center,style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
              onTap: () async {

//                final result = await Navigator.push(
//                    context, new CupertinoPageRoute<void>(builder: (ctx) => BlocProvider<MissionBloc>(
//                  child:  BlocProvider<MissionBloc>(
//                    child: BlowWillSolvePage(
//                      labelId: Ids.titleWillFeedback,
//                      missionId: widget.missionId,
//                      willRecordModel: willRecordModel,
//                    ),
//                    bloc: new MissionBloc(),
//                  ),)));
//                missionBloc.getMissionDetail(widget.missionId);

                final result = await NavigatorUtil.pushPageAsync(
                  context,
                  BlocProvider<MissionBloc>(
                    child: BlowWillSolvePage(
                      labelId: Ids.titleWillFeedback,
                      missionId: widget.missionId,
                      willRecordModel: willRecordModel,
                    ),
                    bloc: new MissionBloc(),
                  ),
                );
                print(result);
                if(result == 'refresh'){
                  missionBloc.getMissionDetail(widget.missionId);
                }
              },
            )
          ),
          Expanded(
            child:InkWell(
              child: Text('稍后',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),),
              onTap: (){
                Navigator.pop(context);
              },
            ),
          ),
        ],
      )
    );
  }

}
