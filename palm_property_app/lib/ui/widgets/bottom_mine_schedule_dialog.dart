
import 'dart:async';
import 'dart:io';

import 'package:estate/common/component_index.dart';
import 'package:estate/data/protocol/estate_models.dart';
import 'package:estate/res/res_index.dart';
import 'package:estate/ui/dialog/simple_dialog.dart';
import 'package:estate/ui/widgets/widget_index.dart';
import 'package:flutter/material.dart';

/**
 * user schedule dialog
 */
class BottomMineScheduleDialog extends StatelessWidget {

  final String orderId;

  const BottomMineScheduleDialog({Key key, this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final EstateBloc bloc = BlocProvider.of<EstateBloc>(context);

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
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(15),topRight: Radius.circular(15))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20,),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: Dimens.gap_dp10,horizontal: Dimens.gap_dp10),
                    child:Row(
                      children: <Widget>[
                        SizedBox(width: Dimens.gap_dp15),
                        Text('处理时长',style: TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp16),),
                        Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                child: Container(
                                    padding: EdgeInsets.only(right: Dimens.gap_dp20),
                                    child:Icon(Icons.highlight_off,color: Colours.text_gray,)
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

                  Container(
                      height:435,
                      color: Colors.white,
                      child:MineTimeSchedulePage(bloc:bloc,orderId:orderId)
                  ),
                  Container(
                      color: Color(0xfff8f8f8),
                      width: double.infinity,
                      padding: EdgeInsets.only(bottom: Dimens.gap_dp10),
                      child:Text('实际到达时间可能会有30分钟的浮动',textAlign: TextAlign.center,style: TextStyle(fontFamily: 'PingFang',fontWeight: FontWeight.bold,color: Color(0xff5fcd94)),)
                  ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}

class MineTimeSchedulePage extends StatelessWidget{

  final EstateBloc bloc;
  final String orderId;

  const MineTimeSchedulePage({Key key, this.bloc,this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bloc.getMineTimeSchedule();
    return  new DefaultTabController(
      length: 7,
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: new TabBar(
              labelColor: Colours.app_main,
              unselectedLabelColor: Colours.text_normal,
              indicatorWeight: 1,
              isScrollable: false,
               labelPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              labelStyle: TextStyle(fontFamily: 'PingFang',fontSize: 13),
              tabs: getTabsTitle(),
          ),
        ),
        body: StreamBuilder(
            stream:bloc.timeScheduleCodeStream,
            builder:(BuildContext context,
                AsyncSnapshot<List<TimeScheduleModel>> snapshot) {
              if(snapshot.data == null) {
                return buildTabBarView();
              }
              return Container(
                  color: Colors.white,
                  child: buildTabBarTimeView(bloc,context,snapshot.data)
              );
            }
        ),
        bottomNavigationBar: Container(
          color: Color(0xfff8f8f8),
          child:
              RoundButton(
                text: '确定选择',
                margin: EdgeInsets.symmetric(horizontal: Dimens.gap_dp15,vertical: Dimens.gap_dp10),
                radius: Dimens.gap_dp20,
                height: 50.0,
                onPressed: (){
                  bool checkSomethings = false;
                  List<String> timeStr = [];
                  for(int i = 0;i<bloc.timeSelected.length;i++){
                    if(bloc.timeSelected[i].checked){
                      checkSomethings = true;
                      timeStr.add(DateUtil.formatDate(bloc.timeSelected[i].time,format: 'yyyy-MM-dd HH:mm'));
                    }
                  }
                  if(!checkSomethings){
                    Fluttertoast.showToast(msg: '请选择时间');
                    return;
                  }
                  Navigator.pop(context,timeStr);
                },
              )
        ),
      ),
    );
  }

  Widget buildTabBarView(){
    return new TabBarView(
      children: [
        new Icon(Icons.hourglass_empty),
        new Icon(Icons.hourglass_empty),
        new Icon(Icons.hourglass_empty),
        new Icon(Icons.hourglass_empty),
        new Icon(Icons.hourglass_empty),
        new Icon(Icons.hourglass_empty),
        new Icon(Icons.hourglass_empty),
      ],
    );
  }

  Widget buildTabBarTimeView(EstateBloc bloc,BuildContext context,List<TimeScheduleModel> times){
    build7DaysWidget(times);
    List<int> arr = [0,1,2,3,4,5,6];
    return StreamBuilder(
        stream:bloc.stream.stream,
        builder:(BuildContext context,
            AsyncSnapshot<List<TimeSelectedModel>> snapshot) {
            if(snapshot.data == null){
              return buildTabBarView();
            }
            return new TabBarView(
              children: arr.map((value){
                  return Container(
                    padding: EdgeInsets.only(left: 20),
                    child:Wrap(
                      children: bloc.timeSelected.asMap().keys.map((p){
                        if(bloc.timeSelected[p].day == value){
                          return RoundButton(
                            bgColor: bloc.timeSelected[p].enabled ? (bloc.timeSelected[p].checked ? Colours.app_main:Colours.gray_ce):Colours.green_e5,
                            text: '${bloc.timeSelected[p].time.hour}:${bloc.timeSelected[p].time.minute < 10 ? "0${bloc.timeSelected[p].time
                                .minute}" : "${bloc.timeSelected[p].time.minute}"}',
                            style: TextStyle(fontFamily: 'PingFang',fontWeight: FontWeight.bold,color: Colors.white),
                            margin: EdgeInsets.symmetric(
                                horizontal: Dimens.gap_dp5, vertical: Dimens.gap_dp5),
                            radius: Dimens.gap_dp5,
                            height: 30.0,
                            width: (MediaQuery
                                .of(context)
                                .size
                                .width - 80) / 4,
                            onPressed: () {
                              if(bloc.timeSelected[p].enabled) {
                                bloc.timeSelected[p].checked = !bloc.timeSelected[p].checked;
                                bloc.stream.sink.add(bloc.timeSelected);
                              }
                            },
                          );
                        }
                        return Container();
                      }).toList(),
                    )
                  );
              }).toList(),
            );
        }
    );
  }

  void build7DaysWidget(List<TimeScheduleModel> times){
    bloc.timeSelected = [];
    DateTime day = DateTime.now();
    for(int i = 0;i < 7; i++){
      day = day.add(Duration(days: i));
      int startMinute = 0,startHour = 8;
      if(i == 0){
        startHour = day.hour;
        if(day.minute > 30) {
          startMinute = 0;
          startHour ++;
        }
        if(day.minute < 30){
          startMinute = 30;
        }
      }

      DateTime nowDate = new DateTime(day.year,day.month,day.day,startHour,startMinute,0);
      while(nowDate.hour <= 21){
        bool enabled = true,checked = false;
        for(int j = 0;j<times.length;j++){
          if(times[j].startTime == nowDate && times[j].orderId != orderId){
            enabled = false;
          }
          if(times[j].orderId == orderId && times[j].startTime == nowDate){
            checked = true;
          }
        }
        TimeSelectedModel timeSelectedModel = new TimeSelectedModel(nowDate,i,enabled,checked);
        nowDate = nowDate.add(Duration(minutes: 30));
        bloc.timeSelected.add(timeSelectedModel);
      }
    }

    bloc.stream.sink.add(bloc.timeSelected);
  }


  List<Widget> getTabsTitle(){
    List<Widget> widgets = [];
    DateTime today = DateTime.now();
    widgets.add(Text("今天\n${today.month}/${today.day}",textAlign: TextAlign.center,style: TextStyle(fontFamily: 'PingFang',fontWeight: FontWeight.bold)));
    today = today.add(Duration(days: 1));
    widgets.add(Text("明天\n${today.month}/${today.day}",textAlign: TextAlign.center,style: TextStyle(fontFamily: 'PingFang',fontWeight: FontWeight.bold)));
    for(var i = 0;i<5;i++){
      today = today.add(Duration(days: 1));
      var weekStr = '';
      switch(today.weekday){
        case 1:weekStr = '一';break;
        case 2:weekStr = '二';break;
        case 3:weekStr = '三';break;
        case 4:weekStr = '四';break;
        case 5:weekStr = '五';break;
        case 6:weekStr = '六';break;
        case 7:weekStr = '日';break;
      }
      widgets.add(Text("周$weekStr\n${today.month}/${today.day}",textAlign: TextAlign.center,style: TextStyle(fontFamily: 'PingFang',fontWeight: FontWeight.bold)));
    }
    return widgets;
  }

}