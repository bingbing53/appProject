import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/blocs/bloc_index.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/protocol/mission_models.dart';
import 'package:flutter_wanandroid/event/event-bus.dart';
import 'package:flutter_wanandroid/res/res_index.dart';

//新建任务
class CreateSchedulePage extends StatefulWidget{

  const CreateSchedulePage({Key key, this.labelId,this.scheduleId,this.timeStart,this.timeEnd,this.selectedDay}) : super(key: key);

  final String labelId,scheduleId;final int timeStart,timeEnd;
  final DateTime selectedDay;

  @override
  State<StatefulWidget> createState() {
    return _CreateSchedulePageState();
  }
}

class _CreateSchedulePageState extends State<CreateSchedulePage>{
  MissionBloc missionBloc;
  WorkBloc workBloc;

  TextEditingController _controllerTitle = new TextEditingController();
  TextEditingController _controllerLocation = new TextEditingController();
  TextEditingController _controllerDes = new TextEditingController();
  ScheduleModelReqs _scheduleModelReqs = new ScheduleModelReqs();
  DateTime _pickerStartTime;
  DateTime _pickerEndTime;
  List<String> _options = [];

  int _choiseIndex = 0;
  BlankToolBarModel blankToolBarModel = BlankToolBarModel();
  @override
  void initState() {
    blankToolBarModel.outSideCallback = focusNodeChange;
    super.initState();
    missionBloc = BlocProvider.of<MissionBloc>(context);
    workBloc = BlocProvider.of<WorkBloc>(context);

    _options.add('不提醒');
    _options.add('提前15分钟');
    _options.add('提前1小时');
    _options.add('提前3小时');
    _options.add('提前1天');


    if(widget.selectedDay != null && widget.timeStart != null && widget.timeEnd != null){

      int totalMinute = widget.timeStart * 15;
      int startHour = totalMinute ~/ 60;
      int startMinute = totalMinute - startHour * 60;
      _pickerStartTime = DateTime(widget.selectedDay.year,widget.selectedDay.month,widget.selectedDay.day,startHour,startMinute);

      _scheduleModelReqs.startTime = DateUtil.getDateStrByDateTime(_pickerStartTime);

      totalMinute = (widget.timeEnd + 1) * 15;
      startHour = totalMinute ~/ 60;
      startMinute = totalMinute - startHour * 60;
      _pickerEndTime = DateTime(widget.selectedDay.year,widget.selectedDay.month,widget.selectedDay.day,startHour,startMinute);

      _scheduleModelReqs.endTime = DateUtil.getDateStrByDateTime(_pickerEndTime);
    }

    if(widget.scheduleId != null && widget.scheduleId != ''){
      missionBloc.scheduleDetail(widget.scheduleId);

      missionBloc.scheduleReposStream.listen((schedule){
        _controllerDes.text = schedule.des;
        _controllerLocation.text = schedule.location;
        _controllerTitle.text = schedule.title;

        if(ObjectUtil.isNotEmpty(schedule.startTime)){
          _pickerStartTime = DateUtil.getDateTime(schedule.startTime);
          _scheduleModelReqs.startTime = DateUtil.getDateStrByDateTime(_pickerStartTime);
        }
        if(ObjectUtil.isNotEmpty(schedule.endTime)){
          _pickerEndTime = DateUtil.getDateTime(schedule.endTime);
          _scheduleModelReqs.endTime = DateUtil.getDateStrByDateTime(_pickerEndTime);
        }
        setState((){});
      });

      _scheduleModelReqs.id = widget.scheduleId;
    }
  }
// Step1.2: 焦点变化时的响应操作
  void focusNodeChange(){
    setState(() {});
  }

  @override
  void dispose() {
    blankToolBarModel.removeFocusListeners();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(IntlUtil.getString(context, widget.labelId)),
      ),
      body: BlankToolBarTool.blankToolBarWidget(
        context,
        model:blankToolBarModel,
        body:SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                SizedBox(height: 10,),

                createInput(),

                SizedBox(height: 10,),

                createDateTime(context),

                RoundButton(
                  text: IntlUtil.getString(context, widget.labelId),
                  margin: EdgeInsets.all(50),
                  onPressed: () {
                    sendMission();
                  },
                ),
              ],
            )
          )
      )
    );
  }


  //发送任务
  void sendMission(){
    _scheduleModelReqs.title = _controllerTitle.text;
    _scheduleModelReqs.location = _controllerLocation.text;
    _scheduleModelReqs.des = _controllerDes.text;
    if(ObjectUtil.isEmpty(_scheduleModelReqs.title)) {
      Fluttertoast.showToast(msg: '请输入日程标题');
      return;
    }

    if(ObjectUtil.isEmpty(_scheduleModelReqs.startTime)){
      Fluttertoast.showToast(msg: '请选择截止时间');
      return;
    }

    if(ObjectUtil.isEmpty(_scheduleModelReqs.endTime)){
      Fluttertoast.showToast(msg: '请选择截止时间');
      return;
    }
    _scheduleModelReqs.notify = 0;
    if(_choiseIndex == 1) _scheduleModelReqs.notify = 15;
    if(_choiseIndex == 2) _scheduleModelReqs.notify = 60;
    if(_choiseIndex == 3) _scheduleModelReqs.notify = 180;
    if(_choiseIndex == 4) _scheduleModelReqs.notify = 1440;

    missionBloc.createSchedule(_scheduleModelReqs).then((data){
      Fluttertoast.showToast(msg: IntlUtil.getString(context, widget.labelId)+'成功');

      if(ApplicationEvent.event != null)
        ApplicationEvent.event.fire(StatusEvent(StatusEventConstant.REFRESH_CALENDAR_PAGE,1));

      Navigator.pop(context);
    }).catchError((_){
      Fluttertoast.showToast(msg: '出了一点小问题');
    });
  }

  //创建时间选择区域
  Widget createDateTime(context){
    return Column(
      children: <Widget>[
          Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('开始时间'),
                    trailing: _pickerStartTime != null ? Text('${Utils.timeShowFormat(_pickerStartTime)}',style:TextStyle(fontSize: Dimens.font_sp16,color: Colours.text_normal)) : Icon(Icons.chevron_right,color: Colours.text_gray,),
                    onTap: (){
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          onChanged: (date) {
                          },
                          onConfirm: (date) {
                            _scheduleModelReqs.startTime = DateUtil.getDateStrByDateTime(date);
                            _pickerStartTime = date;

                            setState((){});
                          },
                          currentTime: _pickerStartTime??DateTime.now().add(Duration(days: 1)),
                          locale: LocaleType.zh
                      );
                    },
                  ),
                  Divider(height: 1.0,),
                ],
              )
          ),
          Container(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: Dimens.gap_dp20),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('截止时间'),
                    trailing: _pickerEndTime != null ? Text('${Utils.timeShowFormat(_pickerEndTime)}',style:TextStyle(fontSize: Dimens.font_sp16,color: Colours.text_normal)) : Icon(Icons.chevron_right,color: Colours.text_gray,),
                    onTap: (){
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          onChanged: (date) {
                          },
                          onConfirm: (date) {
                            _scheduleModelReqs.endTime = DateUtil.getDateStrByDateTime(date);
                            _pickerEndTime = date;

                            setState((){});
                          },
                          currentTime: _pickerEndTime??DateTime.now().add(Duration(days: 1)),
                          locale: LocaleType.zh
                      );
                    },
                  ),
                  Divider(height: 1.0,),
                  ListTile(
                    title: Text('到期提醒'),
                    trailing: _choiseIndex >= 0 ? Text('${_options[_choiseIndex]}',style:TextStyle(fontSize: Dimens.font_sp16,color: Colours.text_normal)) : Icon(Icons.chevron_right,color: Colours.text_gray),
                    onTap: (){
                      CommonUtils.showModalActionSheet(context, "请选择到期提醒", _options, (index){
                        _choiseIndex = index;
                        setState(() {});
                      });
                    },
                  ),
                ],
              )
          ),
      ],
    );
  }

  //创建输入区
  Widget createInput(){

    FocusNode focusNodeTitle = blankToolBarModel.getFocusNodeByController(_controllerTitle);
    FocusNode focusNodeLocation = blankToolBarModel.getFocusNodeByController(_controllerLocation);
    FocusNode focusNodeDes = blankToolBarModel.getFocusNodeByController(_controllerDes);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

          Container(
            color: Colors.white,
            child: TextField(
              controller: _controllerTitle,
              focusNode: focusNodeTitle,
              maxLines: 1,
              autofocus: false,
              style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
              decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(Dimens.gap_dp10),
                  hintText: "请输入日程标题",
                  hintStyle:TextStyle(fontSize: Dimens.font_sp16,color: Colours.text_gray)
              ),
            ),
          ),

          Container(
            color: Colors.white,
            child: TextField(
              controller: _controllerLocation,
              focusNode: focusNodeLocation,
              maxLines: 1,
              autofocus: false,
              style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
              decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(Dimens.gap_dp10),
                  hintText: "请输入日程地址",
                  hintStyle:TextStyle(fontSize: Dimens.font_sp16,color: Colours.text_gray),
              ),
            ),
          ),

          Container(
            color: Colors.white,
            margin: EdgeInsets.only(bottom: Dimens.gap_dp5),
            child: TextField(
              controller: _controllerDes,
              focusNode: focusNodeDes,
              maxLines: 5,
              autofocus: false,
              style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
              decoration: new InputDecoration(
                  contentPadding: EdgeInsets.all(Dimens.gap_dp10),
                  hintText: "请输入日程内容",
                  hintStyle:TextStyle(fontSize: Dimens.font_sp16,color: Colours.text_gray)
              ),
            ),
          ),

      ],
    );
  }

}