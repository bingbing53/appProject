import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:estate/blocs/bloc_index.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/data/protocol/mission_models.dart';
import 'package:estate/event/event-bus.dart';
import 'package:estate/res/res_index.dart';

//新建会议
class CreateMeetingPage extends StatefulWidget{

  const CreateMeetingPage({Key key, this.labelId,this.missionId,this.title}) : super(key: key);

  final String labelId,title;
  final String missionId;//任务编号

  @override
  State<StatefulWidget> createState() {
    return _CreateMeetingPageState();
  }
}

class _CreateMeetingPageState extends State<CreateMeetingPage>{
//  MissionBloc missionBloc;
//  WorkBloc workBloc;
//
//  TextEditingController _controllerContent = new TextEditingController();
//  TextEditingController _controllerLocation = new TextEditingController();
//  MeetingModelReqs _meetingModelReqs = new MeetingModelReqs();
//  DateTime _pickerStartTime;
//  DateTime _pickerEndTime;
//  List<ContactUserModel> excutePersonList = [];
//
//  BlankToolBarModel blankToolBarModel = BlankToolBarModel();
//
//  bool createMeetingLoading = false;

  @override
  void initState() {
//    blankToolBarModel.outSideCallback = focusNodeChange;
//    super.initState();
//    missionBloc = BlocProvider.of<MissionBloc>(context);
//    workBloc = BlocProvider.of<WorkBloc>(context);
//
//    if(ObjectUtil.isNotEmpty(widget.title)){
//      _controllerContent.text = '关于讨论民意“${widget.title}”的会议';
//    }
//
//    if(ObjectUtil.isNotEmpty(widget.missionId)){
//      missionBloc.getMeetingDefaultUserList(widget.missionId).then((data){
//        if(ObjectUtil.isNotEmpty(data)){
//          excutePersonList = data;
//          setState((){});
//        }
//      });
//    }
//
//    workBloc.getMineData();
//    workBloc.userinfoReposStream.listen((val){
//      if(excutePersonList.length <= 0) {
//        ContactUserModel contactUserModel = ContactUserModel.fromJson(
//            val.toJson2());
//        excutePersonList.add(contactUserModel);
//        setState(() {});
//      }
//    });

  }
  // Step1.2: 焦点变化时的响应操作
//  void focusNodeChange(){
//    setState(() {});
//  }
//  @override
//  void dispose() {
//    blankToolBarModel.removeFocusListeners();
//    super.dispose();
//  }
//
  @override
  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('发起会议'),
//      ),
//      body: BlankToolBarTool.blankToolBarWidget(
//        context,
//        model:blankToolBarModel,
//        body:SingleChildScrollView(
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//
//              SizedBox(height: 10,),
//
//              createInput(),
//
//              createExcutePerson(context),
//
//              createDateTime(context),
//
//              createMeetingType(),
//
//              RoundButton(
//                text: '发 起 会 议',
//                margin: EdgeInsets.all(10),
//                bgColor: createMeetingLoading?Colours.text_gray:Theme.of(context).primaryColor,
//                onPressed: () {
//                  if(!createMeetingLoading) sendMission();
//                },
//              ),
//            ],
//          )
//        )
//      )
//    );
  }
//
//  Widget createMeetingType(){
//    return Row(
//      children: <Widget>[
//        Flexible(
//          child: RadioListTile<String>(
//            value: '0',
//            title: Text('线下会议'),
//            groupValue: _meetingModelReqs.type,
//            onChanged: (value) {
//              setState(() {
//                _meetingModelReqs.type = value;
//              });
//            },
//          ),
//        ),
//        Flexible(
//          child: RadioListTile<String>(
//            value: '1',
//            title: Text('线上会议'),
//            groupValue: _meetingModelReqs.type,
//            onChanged: (value) {
//              setState(() {
//                _meetingModelReqs.type = value;
//              });
//            },
//          ),
//        ),
//      ],
//    );
//  }
//
//
//  //发送任务
//  void sendMission() async{
//    _meetingModelReqs.content = _controllerContent.text;
//    if(ObjectUtil.isEmpty(_meetingModelReqs.content)) {
//      Fluttertoast.showToast(msg: '请输入会议内容');
//      return;
//    }
//    if(ObjectUtil.isEmpty(excutePersonList) || excutePersonList.length <= 0){
//      Fluttertoast.showToast(msg: '请添加参会人');
//      return;
//    }
//
//    String persons = '';
//    List<String> usernames = [];
//    for(var i = 0;i<excutePersonList.length;i++){
//      persons += excutePersonList[i].id+",";
//      if(!ObjectUtil.isEmpty(excutePersonList[i].mobilePhone))
//        usernames.add(excutePersonList[i].mobilePhone);
//    }
//    _meetingModelReqs.persons = persons;
//
//    if(ObjectUtil.isEmpty(_meetingModelReqs.startTime)){
//      Fluttertoast.showToast(msg: '请选择开始时间');
//      return;
//    }
////    if(ObjectUtil.isEmpty(_meetingModelReqs.endTime)){
////      Fluttertoast.showToast(msg: '请选择截止时间');
////      return;
////    }
//
//    if(_meetingModelReqs.type == '0'){
//      _meetingModelReqs.location = _controllerLocation.text;
//      if(ObjectUtil.isEmpty(_meetingModelReqs.location)){
//        Fluttertoast.showToast(msg: '请输入会议地点');
//        return;
//      }
//    }
//
//    setState((){
//      createMeetingLoading = true;
//    });
//
//    _meetingModelReqs.missionId = widget.missionId;
//
//    String groupId = '';
//    if(_meetingModelReqs.type == '1'){
//      //创建群组
//      groupId = await workBloc.createGroup(_meetingModelReqs.content, _meetingModelReqs.content, usernames);
//      _meetingModelReqs.groupId = groupId;
//    }
//    await missionBloc.startMeeting(_meetingModelReqs).then((data) {
//      Fluttertoast.showToast(msg: '会议创建成功');
//
//      if (ApplicationEvent.event != null) {
//        ApplicationEvent.event.fire(StatusEvent(StatusEventConstant.REFRESH_BLOW_WILLRECORD_PAGE,1));
//      }
//
//      Navigator.pop(context,"refresh");
//    }).catchError((_) {
//      Fluttertoast.showToast(msg: '出了一点小问题');
//    });
//
//    setState((){
//      createMeetingLoading = false;
//    });
//  }
//
//  //添加参会人
//  Widget createExcutePerson(context){
//    return Container(
//        color: Colors.white,
//        margin: EdgeInsets.only(bottom: Dimens.gap_dp20),
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            ListTile(
//              title: Text('参会人'),
//              trailing: Icon(Icons.add_circle_outline,color: Theme.of(context).primaryColor,),
//              onTap: (){
//                Navigator.push(
//                    context, new CupertinoPageRoute<void>(builder: (ctx) => UserSelectPage(bloc:workBloc,callback: excutePersonSelectChange,selected: excutePersonList,showMe: true,)));
//              },
//            ),
//            Divider(height: 1,),
//
//            //选中的执行人
//            Container(
//              padding: EdgeInsets.only(left: 10.0,right: 10.0),
//              child: Wrap(
//                  children:buildPerson(excutePersonList)
//              ),
//            )
//          ],
//        )
//    );
//  }
//
//  void excutePersonSelectChange(List<ContactUserModel> selectedUser){
//    excutePersonList = selectedUser;
//  }
//
//  List<Widget> buildPerson(List<ContactUserModel> selectedPerson){
//    List<Widget> persons = [];
//    if(ObjectUtil.isEmpty(selectedPerson)){
//      persons.add(Container(height: 0,));
//    }else{
//      selectedPerson.asMap().forEach((index,item){
//        persons.add(Container(
//            height: 45,
//            width: 45,
//            alignment: Alignment.center,
//            child: CircleAvatar(
//              radius: 18,
//              child:  item.portrait == null ?
//              Text(item.realname.substring(0,1)):
//              ClipOval(
//                child:CachedNetworkImage(
//                  fit: BoxFit.fill,
//                  imageUrl: '${item.portrait}',
//                ),
//              ),
//            )
//        ));
//      });
//    }
//    return persons;
//  }
//
//  //创建时间选择区域
//  Widget createDateTime(context){
//    return Column(
//      children: <Widget>[
//        Container(
//            color: Colors.white,
//            child: Column(
//              children: <Widget>[
//                ListTile(
//                  title: Text('开始时间'),
//                  trailing: _pickerStartTime != null ? Text('${Utils.timeShowFormat(_pickerStartTime)}',style:TextStyle(fontSize: Dimens.font_sp16,color: Colours.text_normal)) : Icon(Icons.chevron_right,color: Colours.text_gray,),
//                  onTap: (){
//                    DatePicker.showDateTimePicker(context,
//                        showTitleActions: true,
//                        onChanged: (date) {
//                        },
//                        onConfirm: (date) {
//                          _meetingModelReqs.startTime = DateUtil.getDateStrByDateTime(date);
//                          _pickerStartTime = date;
//
//                          setState((){});
//                        },
//                        currentTime: _pickerStartTime??DateTime.now().add(Duration(days: 1)),
//                        locale: LocaleType.zh
//                    );
//                  },
//                ),
//                Divider(height: 1.0,),
//              ],
//            )
//        ),
//        Container(
//            color: Colors.white,
//            margin: EdgeInsets.only(bottom: Dimens.gap_dp20),
//            child: Column(
//              children: <Widget>[
//                ListTile(
//                  title: Text('截止时间'),
//                  trailing: _pickerEndTime != null ? Text('${Utils.timeShowFormat(_pickerEndTime)}',style:TextStyle(fontSize: Dimens.font_sp16,color: Colours.text_normal)) : Icon(Icons.chevron_right,color: Colours.text_gray,),
//                  onTap: (){
//                    DatePicker.showDateTimePicker(context,
//                        showTitleActions: true,
//                        onChanged: (date) {
//                        },
//                        onConfirm: (date) {
//                          _meetingModelReqs.endTime = DateUtil.getDateStrByDateTime(date);
//                          _pickerEndTime = date;
//
//                          setState((){});
//                        },
//                        currentTime: _pickerEndTime??DateTime.now().add(Duration(days: 1)),
//                        locale: LocaleType.zh
//                    );
//                  },
//                ),
//              ],
//            )
//        ),
//      ],
//    );
//  }
//
//  //创建输入区
//  Widget createInput(){
//
//    FocusNode focusNodeContent = blankToolBarModel.getFocusNodeByController(_controllerContent);
//    FocusNode focusNodeLocation = blankToolBarModel.getFocusNodeByController(_controllerLocation);
//
//    return Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//
//        Container(
//          color: Colors.white,
//          child: TextField(
//            controller: _controllerContent,
//            focusNode: focusNodeContent,
//            maxLines: 8,
//            autofocus: false,
//            style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
//            decoration: new InputDecoration(
//                contentPadding: EdgeInsets.all(Dimens.gap_dp10),
//                hintText: "请输入会议内容",
//                hintStyle:TextStyle(fontSize: Dimens.font_sp16)
//            ),
//          ),
//        ),
//        Container(
//          color: Colors.white,
//          margin: EdgeInsets.only(bottom: Dimens.gap_dp5),
//          child: TextField(
//            controller: _controllerLocation,
//            focusNode: focusNodeLocation,
//            maxLines: 2,
//            autofocus: false,
//            style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
//            decoration: new InputDecoration(
//                contentPadding: EdgeInsets.all(Dimens.gap_dp10),
//                hintText: "请输入会议地点（线上会议不用填写地址）",
//                hintStyle:TextStyle(fontSize: Dimens.font_sp16)
//            ),
//          ),
//        ),
//      ],
//    );
//  }

}