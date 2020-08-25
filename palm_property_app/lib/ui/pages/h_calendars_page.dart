import 'dart:math' as math;

import 'package:date_utils/date_utils.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:estate/blocs/bloc_index.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/data/api/apis.dart';
import 'package:estate/event/event-bus.dart';
import 'package:estate/res/res_index.dart';
import 'package:estate/ui/dialog/simple_dialog.dart';
import 'package:estate/ui/pages/page_index.dart';
import 'package:estate/ui/widgets/table_calendar/table_calendar.dart';
import 'package:estate/ui/widgets/widget_index.dart';

import 'package:estate/utils/util_index.dart' as util;

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};

class CalendarsPage extends StatefulWidget {
  CalendarsPage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CalendarsPage> with TickerProviderStateMixin,AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  DateTime _selectedDay;
  Map<DateTime, List<MissionModel>> _events;
  Map<DateTime, List<MissionModel>> _visibleEvents;
  Map<DateTime, List> _visibleHolidays;
  List _selectedEvents;
  AnimationController _controller;
  CalendarController _calendarController = CalendarController();

  DateTime savedStartTime,savedEndTime;

  MissionBloc missionBloc;
  WorkBloc workBloc;

  bool viewer = true;
  
  @override
  void initState() {
    super.initState();
    var nowDate = DateTime.now();
    _selectedDay = new DateTime(nowDate.year,nowDate.month,nowDate.day);

    missionBloc = BlocProvider.of<MissionBloc>(context);
    workBloc = BlocProvider.of<WorkBloc>(context);
    //获取权限
    workBloc.getModulesList('work');

    _events = {
    };

    _selectedEvents = [];
    _visibleEvents = _events;
    _visibleHolidays = _holidays;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 0),
    );

    _controller.forward();

    int weekday = DateTime.now().weekday;
    DateTime startDay = DateTime.now().add(Duration(days: -weekday));
    DateTime endDay = DateTime.now().add(Duration(days: 7 - weekday));
    getCalendarEvent(startDay,endDay,defaultSelect: true);

    ApplicationEvent.event.on<StatusEvent>().listen((event) {
      if(event.labelId == StatusEventConstant.REFRESH_CALENDAR_PAGE){
        getCalendarEvent(savedStartTime,savedEndTime,refreshDay: true);
      }
    });
  }


  //点击某天
  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedDay = day;
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    //获取当前的日程
    if(_selectedDay == null || _selectedDay.isBefore(first) || _selectedDay.isAfter(last)){
      _onDaySelected(null,[]);
    }

    getCalendarEvent(first,last);
  }

  void getCalendarEvent(DateTime first, DateTime last,{bool defaultSelect = false,refreshDay = false}){
    savedStartTime = first;
    savedEndTime = last;
    missionBloc.getMineMissionList(util.DateUtil.getDateStrByDateTime(first,format: util.DateFormat.YEAR_MONTH_DAY),util.DateUtil.getDateStrByDateTime(last,format: util.DateFormat.YEAR_MONTH_DAY)).then((list){
      _events.clear();
      for(var i = 0;i<list.length;i++){
        DateTime dateTime = util.DateUtil.getDateTime(util.DateUtil.formatDateTime(list[i].needTime, DateFormat.YEAR_MONTH_DAY,'-',':'));
        if(!_events.containsKey(dateTime)){
          _events[dateTime] = [];
        }
        _events[dateTime].add(list[i]);

        //添加日程
        if(list[i].cType == 'schedule'){
          dateTime = util.DateUtil.getDateTime(util.DateUtil.formatDateTime(list[i].startTime, DateFormat.YEAR_MONTH_DAY,'-',':'));

          if(dateTime.isBefore(first))
            dateTime = first.add(Duration(days:-1));

          DateTime endTime = util.DateUtil.getDateTime(util.DateUtil.formatDateTime(list[i].endTime, DateFormat.YEAR_MONTH_DAY,'-',':'));
          dateTime = dateTime.add(Duration(days: 1));
          while(dateTime.isBefore(endTime.add(Duration(days: 1))) && last.add(const Duration(days:1)).isAfter(dateTime)){
            dateTime = new DateTime(dateTime.year, dateTime.month, dateTime.day, 0, 0);
            if(!_events.containsKey(dateTime)){
              _events[dateTime] = [];
            }
            _events[dateTime].add(list[i]);
            dateTime = dateTime.add(Duration(days: 1));
          }
        }
      }

      _events.keys.forEach((time){
        if(time.isAfter(first.subtract(const Duration(days:1))) && time.isBefore(last.add(const Duration(days:1)))){
          _visibleEvents[time] = _events[time];
        }
      });

      if(defaultSelect){
        DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
        if(_events[now] !=null){
          _onDaySelected(now,_events[now]);
        }
      }

      if(refreshDay){
        _selectedDay = new DateTime(_selectedDay.year,_selectedDay.month,_selectedDay.day);
        _selectedEvents = _events[_selectedDay];
        _onDaySelected(_selectedDay,_selectedEvents);
      }
      
      setState((){});
      
    });
  }

  ScrollController _scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('日程'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.format_list_numbered_rtl,color: Colors.white,),
            onPressed: (){
              viewer = !viewer;
              setState(() {

              });
            },
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            color: Colors.white,
            child: _buildTableCalendar(),
          ),
          _buildAllDay(),
          Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: viewer ? Stack(
                    children:buildTimeLine()
                ):listViewerShow()
              )
          )
        ],
      ),
      floatingActionButton:  new FloatingActionButton(
        onPressed: () {
          gotoDetailPage();
        },
        tooltip: '新建任务',
        child: new Icon(Icons.add),
      )
    );
  }

  void gotoDetailPage() async{
    SimpleDialogUtil.showModalBottom(context,
        Container(
          padding: EdgeInsets.only(top: 0.0,bottom: 40.0),
          child:new StreamBuilder(
                  stream: workBloc.moduleListReposStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ModuleModel>> snapshot) {
                    return buildModule(context, snapshot.data);
                  }),
        ),
        ''
    );
  }

  Widget buildModule(context,List<ModuleModel> model){

    double width = MediaQuery.of(context).size.width / 5;
    List<Widget> items = [];
    items.add(Container(
        width: width,
        alignment: Alignment.center,
        child: new InkWell(
          onTap: () {
            Navigator.pop(context);

            util.NavigatorUtil.pushPage(
              context,
              BlocProvider<MissionBloc>(
                child: CreateSchedulePage(labelId: Ids.titleCreateSchedule,
                    selectedDay: _selectedDay),
                bloc: new MissionBloc(),
              ),
              pageName: Ids.titleMission,
            );
          },
          child: Column(
            children: <Widget>[
              new ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: new Image.asset(
                    util.Utils.getImgPath('create_schedule')),
              ),
              SizedBox(height: 5.0,),
              Text('添加日程', style: TextStyle(fontSize: Dimens.font_sp12),)
            ],
          ),
        )
    ),
    );

    if(!ObjectUtil.isEmpty(model))
    for(var i = 0;i<model.length;i++) {
      if(model[i].superCode == 'calendar' && model[i].code == 'mission')
      items.add(Container(
          width: width,
          alignment: Alignment.center,
          child: new InkWell(
            onTap: () {
              Navigator.pop(context);

              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) {
                    return BlocProvider<MissionBloc>(
                      child: CreateMissionPage(
                        labelId: Ids.titleCreateMission,),
                      bloc: new MissionBloc(),
                    );
                  })
              );
            },
            child: Column(
              children: <Widget>[
                new ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: new Image.asset(
                      util.Utils.getImgPath('create_mission')),
                ),
                SizedBox(height: 5.0,),
                Text('创建任务', style: TextStyle(fontSize: Dimens.font_sp12),)
              ],
            ),
          )
      )
      );
      if(model[i].superCode == 'calendar' && model[i].code == 'willblow')
      items.add(
        Container(
            width: width,
            alignment: Alignment.center,
            child: new InkWell(
              onTap: () {
                Navigator.pop(context);

                util.NavigatorUtil.pushWeb(
                    context,
                    url: WanAndroidApi.WILL_RECORD_LIST,
                    title: '民情民意'
                );
              },
              child: Column(
                children: <Widget>[
                  new ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: new Image.asset(
                        util.Utils.getImgPath('create_willblow')),
                  ),
                  SizedBox(height: 5.0,),
                  Text('我要吹哨', style: TextStyle(fontSize: Dimens.font_sp12),)
                ],
              ),
            )
        ),
      );

      if(model[i].superCode == 'calendar' && model[i].code == 'meeting')
      items.add(
        Container(
            width: width,
            alignment: Alignment.center,
            child: new InkWell(
              onTap: () {
                Navigator.pop(context);

                util.NavigatorUtil.pushPage(
                  context,
                  BlocProvider<MissionBloc>(
                    child: CreateMeetingPage(labelId: Ids.titleMeeting),
                    bloc: new MissionBloc(),
                  ),
                  pageName: Ids.titleMeeting,
                );
              },
              child: Column(
                children: <Widget>[
                  new ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: new Image.asset(
                        util.Utils.getImgPath('create_meeting')),
                  ),
                  SizedBox(height: 5.0,),
                  Text('发起会议', style: TextStyle(fontSize: Dimens.font_sp12),)
                ],
              ),
            )
        ),
      );
      if(model[i].superCode == 'work' && model[i].code == 'worknote')
      items.add(Container(
          width: width,
          alignment: Alignment.center,
          child: new InkWell(
            onTap: () {
              Navigator.pop(context);

              util.NavigatorUtil.pushWeb(
                  context,
                  url: WanAndroidApi.ADD_WORKHISTORY,
                  title: '我要记录'
              );
            },
            child: Column(
              children: <Widget>[
                new ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: new Image.asset(util.Utils.getImgPath('create_will')),
                ),
                SizedBox(height: 5.0,),
                Text('我要记录', style: TextStyle(fontSize: Dimens.font_sp12),)
              ],
            ),
          )
      ),
      );
    }

    return Wrap(
        runSpacing: Dimens.gap_dp15,
        children: items
    );
  }

  //全天日程
  Widget _buildAllDay(){

    if(ObjectUtil.isEmpty(_selectedEvents))
      return Container(height: 0,);

    List<Widget> items = [];
    double height = 0;
    for(var i = 0;i<_selectedEvents.length;i++){
      if(_selectedEvents[i].cType == 'schedule') {
        DateTime endTime = util.DateUtil.getDateTime(
            util.DateUtil.formatDateTime(
                _selectedEvents[i].endTime, DateFormat.YEAR_MONTH_DAY, '-',
                ':'));
        DateTime startTime = util.DateUtil.getDateTime(
            util.DateUtil.formatDateTime(
                _selectedEvents[i].startTime, DateFormat.YEAR_MONTH_DAY, '-',
                ':'));
//        if (!startTime.isAtSameMomentAs(endTime)) {
        if (!isOneDay(startTime,endTime)){
          height ++;
          items.add(
            GestureDetector(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(3.0),
                  margin: EdgeInsets.only(left: viewer ? 40:5,right: viewer?10.0:0),
                  decoration: new BoxDecoration(
                    border: Border(left: BorderSide(color: Theme.of(context).primaryColor,width: 2.5),top: BorderSide(color: Colours.divider,width: 1),right: BorderSide(color: Colours.divider,width: 1),bottom: BorderSide(color: Colours.divider,width: 1)),
                  ),
                  child: Text('日程 | ${_selectedEvents[i].missionDes}',maxLines: 1,overflow: TextOverflow.ellipsis,)
              ),
              onTap: (){
                scheduleOnTap(_selectedEvents[i]);
              },
            )

          );
          items.add(Divider(height: 1,));
        }
      }
    }
    return Container(
      height: height * 31.0,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items,
      ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      calendarController: _calendarController,
      locale: 'zh_CN',
      events: _visibleEvents,
      holidays: _visibleHolidays,
      initialCalendarFormat: CalendarFormat.week,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        selectedColor: Colours.text_gray,
        todayColor: Theme.of(context).primaryColor,
        markersColor: Colours.text_gray,
        markersMaxAmount: 1,
        weekendStyle: TextStyle(),
        weekdayStyle: TextStyle(),
        outsideWeekendStyle: TextStyle()
      ),
      rowHeight: 40,
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
        leftChevronIcon: Icon(Icons.chevron_left,color: Colors.grey,),
        rightChevronIcon: Icon(Icons.chevron_right,color: Colors.grey,)
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(fontSize: Dimens.font_sp12),
        weekendStyle: TextStyle(fontSize: Dimens.font_sp12)
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  ///长摁了哪个块
  int timeAreaPositionStart = -1,timeAreaPositionEnd = -1;

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  final double itemHeight = 10.0;
  bool isDraging = false,showKuai = false;
  Widget _buildEventList() {
    List<int> items = [];
    for(var i = 0;i<96;i++){
      items.add(i);
    }
    return DragAndDropList<int>(
      items,
      itemBuilder: (BuildContext context, item) {
        return buildListItem(item);
      },
      onDragFinish: (before, after) {
        int data = items[after];
        print('after$data');
        timeAreaPositionStart = data;
        timeAreaPositionEnd = timeAreaPositionStart + 3;

        setState((){});
        isDraging = false;
        showKuai = true;

      },
      onDragChange:(index){
          isDraging = true;
          if(showKuai)
            setState((){showKuai = false;});
      },
      canBeDraggedTo: (one, two) => true,
      scrollController:_scrollController,
    );
  }
  //添加15分钟为一个刻度的线
  Widget buildListItem(int i){
    if(i == null){
      return Container(height: 0);
    }
    Widget
      item =
        Column(
          key: ObjectKey(i),
          children: <Widget>[
            i >= timeAreaPositionStart && i <= timeAreaPositionEnd ? GestureDetector(
              child: Container(
                height: itemHeight,
                width: MediaQuery.of(context).size.width - 50,
                margin: EdgeInsets.only(left: 30),
                color: /*(i >= timeAreaPositionStart && i <= timeAreaPositionEnd) && !isDraging ? Theme.of(context).primaryColor:*/Colors.white,
              ),
            ):GestureDetector(
              child: Container(
                  height: itemHeight,
                  width: MediaQuery.of(context).size.width - 50,
                  margin: EdgeInsets.only(left: 30),
                  color: (i >= timeAreaPositionStart && i <= timeAreaPositionEnd) && !isDraging ? Theme.of(context).primaryColor:Colors.white,
              ),
              onTap: (){
                if(i < timeAreaPositionStart || i > timeAreaPositionEnd){
                  setState((){
                    timeAreaPositionStart = -1;
                    timeAreaPositionEnd = -1;
                    showKuai = false;
                  });
                }
              },
            ),
          ],
        );
    return item;
  }

  static bool isOneDay(DateTime startTime, DateTime endTime) {
    return startTime.year == endTime.year && startTime.month == endTime.month && startTime.day == endTime.day;
  }

  //改变视图，改为list视图
  Widget listViewerShow(){
    List<Widget> items = [];

    List newSelectdEvents= [];
    if(util.ObjectUtil.isNotEmpty(_selectedEvents)){
      //计算任务是否重叠
      for(var i = 0;i<_selectedEvents.length;i++){

        double start = (util.DateUtil.getDateTime(_selectedEvents[i].needTime).hour * 60 + util.DateUtil.getDateTime(_selectedEvents[i].needTime).minute)*1.0;
        double end = 30.0;
        if(_selectedEvents[i].cType == 'schedule'){

          DateTime startTime = DateUtil.getDateTime(_selectedEvents[i].startTime);
          DateTime endTime = DateUtil.getDateTime(_selectedEvents[i].endTime);

          if(!isOneDay(startTime,endTime)){
            continue;
          }

          //跨天
//          if(!DateUtil.isToday(startTime.millisecondsSinceEpoch) || !DateUtil.isToday(endTime.millisecondsSinceEpoch)){
//            continue;
//          }

          double ex = (endTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch)*1.0;

          double minute = (ex ~/ 60000)*1.0;

          end  = minute < 30 ? 30 : minute;

        }

        _selectedEvents[i].start = start;
        _selectedEvents[i].end = start+end;
        _selectedEvents[i].num = 1;
        _selectedEvents[i].plused = 1.0;

        newSelectdEvents.add(_selectedEvents[i]);

      }

      //先升序排序
      var temp;
      for(int i = newSelectdEvents.length - 1; i > 0; i--) {
        //进行这一轮的冒泡排序
        for(int j = 0; j < i; j++) {
          //从第一个元素开始和下一个比较，比下一个大则交换
          if(newSelectdEvents[j].start > newSelectdEvents[j + 1].start) {
            temp = newSelectdEvents[j];
            newSelectdEvents[j] = newSelectdEvents[j + 1];
            newSelectdEvents[j + 1] = temp;
          }
        }
      }

      BorderSide otherSide = BorderSide(color: Colors.transparent,width: 1);
      for(var i = 0;i<newSelectdEvents.length;i++){
        Color leftColor = Theme.of(context).primaryColor;
        if(newSelectdEvents[i].finished == '0'){
          leftColor = Colors.yellow;
          if(util.DateUtil.getDateTime(newSelectdEvents[i].needTime).isBefore(DateTime.now())){
            leftColor = Colors.red;
          }
        }

        items.add(Divider(height:1));
        items.add(
            GestureDetector(
              child:Container(
                  width: double.infinity,
//                  color: Colors.white,
                  padding: EdgeInsets.only(left:10.0,right: 10.0,top: 5.0,bottom: 5.0),
                  margin: EdgeInsets.only(left: 5.0),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    border: Border(left: BorderSide(color: leftColor,width: 3),top: otherSide,right: otherSide,bottom: otherSide),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('${newSelectdEvents[i].cType == 'misson' ? (newSelectdEvents[i].missionType == 'user'?'任务|':'吹哨|'):newSelectdEvents[i].cType == 'schedule'?'日程|':(newSelectdEvents[i].cType == 'meeting'?'会议|':'')}${newSelectdEvents[i].missionDes}',maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize:Dimens.font_sp12,color: Colours.text_normal),),
                      SizedBox(height: 5.0,),
                      Text(newSelectdEvents[i].needTime,style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),),
                    ],
                  )
              ),
              onTap: (){
                scheduleOnTap(newSelectdEvents[i]);
              },
            )
        );
        if(i == newSelectdEvents.length - 1)
          items.add(Divider(height:1));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }

  //添加底部的时间线
  List<Widget> buildTimeLine(){
    List<Widget> item = [];
    item.add(
      Container(
        height: 40.0*25.0 ,
        padding: EdgeInsets.only(top:7.5),
        width: MediaQuery.of(context).size.width,
        child: _buildEventList(),
      )
    );

    int hour = DateTime.now().hour;
    int minute = DateTime.now().minute;
    for(var i = 0;i<24;i++){
      item.add(
        Positioned(
            top: i*40.0,
            left: 0,
            child:
                Container(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 35,
                        padding: EdgeInsets.only(left: 5.0),
                        child: Text("${i < 10 ? '0$i' : '$i'}:00",style: TextStyle(color: Colours.text_gray, fontSize: Dimens.font_sp12)),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 50,
                        margin: EdgeInsets.only(left: 5.0),
                        child: Divider(height: 1.0)
                      ),
                    ],
                  )
                )
        )
      );
    }


    buildMissionArea(item);

    buildSelectedTimeArea(item);

    //添加当前时间线
    if(_selectedDay != null && _selectedDay.isAtSameMomentAs(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day))) {
      item.add(
          Positioned(
              top: hour * 40.0 + minute * (2/3),
              left: 0,
              child:
              Row(
                children: <Widget>[
                  Container(
                    width: 35,
                    padding: EdgeInsets.only(left: 5.0),
                    child: Text("${hour < 10 ? '0$hour' : '$hour'}:${minute < 10
                        ? '0$minute'
                        : '$minute'}", style: TextStyle(color: Colors.red,
                        fontSize: Dimens.font_sp12,
                        fontWeight: FontWeight.bold)),
                  ),
                  Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 50,
                      margin: EdgeInsets.only(left: 5.0),
                      child: Divider(height: 1.5, color: Colors.red,)
                  ),
                ],
              )
          )
      );

    }

    return item;
  }
  //滑动结束添加点击新建日程
  void buildSelectedTimeArea(item){
    if(timeAreaPositionStart > 0){
      String timeRange = '';
      int totalMinute = timeAreaPositionStart * 15;
      int startHour = totalMinute ~/ 60;
      int startMinute = totalMinute - startHour * 60;

      timeRange += '${startHour < 10 ? '0$startHour':startHour}:${startMinute<10 ? '0$startMinute':startMinute} - ';

      totalMinute = (timeAreaPositionEnd + 1) * 15;
      startHour = totalMinute ~/ 60;
      startMinute = totalMinute - startHour * 60;
      timeRange += '${startHour < 10 ? '0$startHour':startHour}:${startMinute<10 ? '0$startMinute':startMinute}';

      if(showKuai) {
        print(timeAreaPositionStart);
        item.add(
            Positioned(
              top: timeAreaPositionStart * itemHeight + 7.5,
              height: itemHeight * 4,
              left: 40,
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 50,
                height: double.infinity,
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
            )
        );
      }

      item.add(
        Positioned(
          top: timeAreaPositionStart * itemHeight + 7.5,
          left: 40,
          child: GestureDetector(
            child: Container(
              width: MediaQuery.of(context).size.width - 50,
              margin: EdgeInsets.all(Dimens.gap_dp5),
              child: Text('点击新建日程 （$timeRange）',style: TextStyle(color: Colors.white,fontSize: Dimens.font_sp14),),
            ),
            onTap: (){
              util.NavigatorUtil.pushPage(
                context,
                BlocProvider<MissionBloc>(
                  child: CreateSchedulePage(labelId: Ids.titleCreateSchedule,selectedDay:_selectedDay,timeStart:timeAreaPositionStart,timeEnd:timeAreaPositionEnd),
                  bloc: new MissionBloc(),
                ),
                pageName: Ids.titleCreateSchedule,
              );

              setState((){
                timeAreaPositionStart = -1;
                timeAreaPositionEnd = -1;
                showKuai = false;
              });

            },
          )
        )
      );
    }
    item.add(Container(height: 0));
  }

  //添加任务区域
  void buildMissionArea(item){

    List newSelectdEvents= [];

    if(util.ObjectUtil.isNotEmpty(_selectedEvents)){
      //计算任务是否重叠
      for(var i = 0;i<_selectedEvents.length;i++){
        double start = util.DateUtil.getDateTime(_selectedEvents[i].needTime).hour * 40 + util.DateUtil.getDateTime(_selectedEvents[i].needTime).minute*(2/3);
        double end = 40;

        if(_selectedEvents[i].cType == 'schedule'){

          DateTime startTime = DateUtil.getDateTime(_selectedEvents[i].startTime);
          DateTime endTime = DateUtil.getDateTime(_selectedEvents[i].endTime);
//          if(endTime.difference(startTime) > Duration(days: 1)){
//            _selectedEvents[i].crossDay = true;
//            continue;
//          }

//          print(DateUtil.isToday(startTime.millisecondsSinceEpoch));
//          print(DateUtil.isToday(endTime.millisecondsSinceEpoch));
//          if(!DateUtil.isToday(startTime.millisecondsSinceEpoch) || !DateUtil.isToday(endTime.millisecondsSinceEpoch)){
//            continue;
//          }

          if(!isOneDay(startTime,endTime)){
            continue;
          }


          double ex = (endTime.millisecondsSinceEpoch - startTime.millisecondsSinceEpoch) * (2/3);

          double minute = (ex ~/ 60000) * 1.0;

          end  = minute < 30 ? 30 : minute;

//          continue;

        }

        _selectedEvents[i].start = start;
        _selectedEvents[i].end = start+end;
        _selectedEvents[i].num = -1;
        _selectedEvents[i].plused = 1.0;

        newSelectdEvents.add(_selectedEvents[i]);

      }

      //先升序排序
      var temp;
      for(int i = newSelectdEvents.length - 1; i > 0; i--) {
        //进行这一轮的冒泡排序
        for(int j = 0; j < i; j++) {
          //从第一个元素开始和下一个比较，比下一个大则交换
          if(newSelectdEvents[j].start > newSelectdEvents[j + 1].start) {
            temp = newSelectdEvents[j];
            newSelectdEvents[j] = newSelectdEvents[j + 1];
            newSelectdEvents[j + 1] = temp;
          }
        }
      }

//      int _position = 0;
//      for(int i = 1; i <newSelectdEvents.length; i++){
//        //如果相交，把当前的和初始的都加1
//        if(newSelectdEvents[i].start >= newSelectdEvents[i-1].start && newSelectdEvents[i].start < newSelectdEvents[i-1].end){
//          newSelectdEvents[i].num ++;
//        }else{
//          bool find = false;
//          //如果不相交，拿着这个与之前的全部再比较一遍
//          for(var j = _position;j<i;j++){
//            if(newSelectdEvents[i].start <= newSelectdEvents[j].start && newSelectdEvents[i].start > newSelectdEvents[j].end){
//              newSelectdEvents[_position].num ++;
//              find = !find;
//            }
//          }
//          if(!find) {
//            int pp = _position + 1;
//            while(pp < i){
//              newSelectdEvents[pp].num = newSelectdEvents[_position].num;
//              newSelectdEvents[pp].plused += newSelectdEvents[pp-1].plused;
//              pp++;
//            }
//            _position = i;
//          }
//
//        }
//      }


      var stack = [];
      var len = newSelectdEvents.length;
      var s = 0,i = 0;
      var curmax = 0.0;
      for (i = 0; i < len - 1; i++) {
        if (curmax < newSelectdEvents[i].end) {
          curmax = newSelectdEvents[i].end;
        }
        if (curmax <= newSelectdEvents[i + 1].start) {
          stack.add(newSelectdEvents.sublist(s, i + 1));
          s = i + 1;
        }
      }
      try {
        stack.add(newSelectdEvents.sublist(s, i + 1));
      }catch(err){}
      for (var m = 0; m < stack.length; m++) {
        var data = stack[m];
        print(data);
        var k = 0;
        var len = data.length;
        for (var i = 0; i < len; i++) {
          if (data[i].num != -1) continue;
          data[i].num = k;
          var curmax = data[i].end;
          for (var j = i + 1; j < len; j++) {
            if (curmax <= data[j].start && data[j].num == -1) {
              data[j].num = k;
              curmax = data[j].end;
            }
          }
          k++;
        }
        draw(item,data,MediaQuery.of(context).size.width - 50,k);
      }



//      BorderSide otherSide = BorderSide(color: Colours.divider,width: 1);
//      for(var i = 0;i<newSelectdEvents.length;i++){
//        Color leftColor = Theme.of(context).primaryColor;
//        if(newSelectdEvents[i].finished == '0'){
//          leftColor = Colors.yellow;
//          if(util.DateUtil.getDateTime(newSelectdEvents[i].needTime).isBefore(DateTime.now())){
//            leftColor = Colors.red;
//          }
//        }
//
//        //获取小时
//        int hour = util.DateUtil.getDateTime(newSelectdEvents[i].needTime).hour;
//        //获取分钟
//        int minute = util.DateUtil.getDateTime(newSelectdEvents[i].needTime).minute;
//        double length = 80,left = 40;
//        length = (MediaQuery.of(context).size.width - 50) / newSelectdEvents[i].num;
//        if(newSelectdEvents[i].plused > 1) {
//          left = 40 + (newSelectdEvents[i].plused-1) * length;
//        }
//        print(newSelectdEvents[i].missionType);
//        item.add(
//            Positioned(
//                top:hour * 40.0 + minute*(2/3) + 8.5,
//                height:(newSelectdEvents[i].end - newSelectdEvents[i].start*1.0) * (2/3),
//                left: left,
//                width: length,
//                child:GestureDetector(
//                  child:Container(
//                      padding: EdgeInsets.all(3.0),
//                      decoration: new BoxDecoration(
////                        borderRadius: BorderRadius.all(Radius.circular(1)),
//                        border: Border(left: BorderSide(color: leftColor,width: 2.5),top: otherSide,right: otherSide,bottom: otherSide),
//                        color: Colors.white
//                      ),
//                      child: Text('${newSelectdEvents[i].cType == 'misson' ? (newSelectdEvents[i].missionType == 'user'?'任务 | ':'吹哨 | '):newSelectdEvents[i].cType == 'schedule'?'日程 | ':(newSelectdEvents[i].cType == 'meeting'?'会议 | ':'')}${newSelectdEvents[i].missionDes}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize:Dimens.font_sp12,color: Colours.text_normal),)
//                  ),
//                  onTap: (){
//                    scheduleOnTap(newSelectdEvents[i]);
//                  },
//                )
//            )
//        );
//      }

    }
  }

  BorderSide otherSide = BorderSide(color: Colours.divider,width: 1);
  draw(item,data,bar,group){
    var len = data.length;
    if (group == -1) group = len;
    bar = bar / group;

    for (var i = 0; i < len; i++) {
//      print(group);
      var index = i;
      if (data[i].num != -1) index = data[i].num;

      Color leftColor = Theme.of(context).primaryColor;
      if(data[i].finished == '0'){
        leftColor = Colors.yellow;
        if(util.DateUtil.getDateTime(data[i].needTime).isBefore(DateTime.now())){
          leftColor = Colors.red;
        }
      }
//      print(MediaQuery.of(context).size.width);
//      print('${data[i].start*1.0}   ${(data[i].end - data[i].start)*1.0}   ${40 + bar * index * 1.0}  ${bar}');
//      print(bar);
      item.add(
          Positioned(
              top:data[i].start*1.0 + 8.5,
              height:(data[i].end - data[i].start)*1.0,
              left: 40 + bar * index * 1.0,
              width: bar*1.0,
              child:GestureDetector(
                child:Container(
                    padding: EdgeInsets.all(3.0),
                    decoration: new BoxDecoration(
//                        borderRadius: BorderRadius.all(Radius.circular(1)),
                        border: Border(left: BorderSide(color: leftColor,width: 2.5),top: otherSide,right: otherSide,bottom: otherSide),
                        color: Colors.white
                    ),
                    child: Text('${data[i].cType == 'misson' ? (data[i].missionType == 'user'?'任务 | ':'吹哨 | '):data[i].cType == 'schedule'?'日程 | ':(data[i].cType == 'meeting'?'会议 | ':'')}${data[i].missionDes}',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize:Dimens.font_sp12,color: Colours.text_normal),)
                ),
                onTap: (){
                  scheduleOnTap(data[i]);
                },
              )
          )
      );
    }
  }

  //日程里面的横向点击
  scheduleOnTap(selectdEvent){
    var prefixStr = '起';
    if(selectdEvent.cType == 'misson'){
      prefixStr = '截止';
    }
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
            title: new Text('我的${selectdEvent.cType == 'misson' ? (selectdEvent.missionType == 'user'?'任务':'吹哨'):selectdEvent.cType == 'schedule'?'日程':(selectdEvent.cType == 'meeting'?'会议':'')}',),
            content: Container(
              height: 90,
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.flag,color:Colours.text_normal,),
                      Text('${selectdEvent.missionDes}',maxLines: 1,style: TextStyle(color:Colours.text_normal,),overflow: TextOverflow.ellipsis,)
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: <Widget>[
//                      Icon(Icons.access_time,color:Colours.text_normal,),
                      Text('$prefixStr：${util.Utils.timeShowFormat(util.DateUtil.getDateTime(selectdEvent.needTime))}',style: TextStyle(color:Colours.text_normal,),)
                    ],
                  ),
                  SizedBox(height: 5,),
                  selectdEvent.cType == 'schedule'?
                  Row(
                    children: <Widget>[
//                      Icon(Icons.av_timer,color:Colours.text_normal,),
                      Text('止：${util.Utils.timeShowFormat(util.DateUtil.getDateTime(selectdEvent.endTime))}',style: TextStyle(color:Colours.text_normal,))
                    ],
                  ):Container(height: 0,),
                ],
              ),
            ),
            actions:<Widget>[
              new FlatButton(child:new Text('详情',style: TextStyle(color:Colors.blueAccent),), onPressed: (){
                Navigator.of(context).pop();

                if(selectdEvent.cType == 'misson') {
                  if(selectdEvent.missionType == 'user') {
                    util.NavigatorUtil.pushPage(
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
                    util.NavigatorUtil.pushPage(
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
                  util.NavigatorUtil.pushPage(
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
                  util.NavigatorUtil.pushPage(
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