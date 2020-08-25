import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:estate/blocs/bloc_index.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/data/protocol/mission_models.dart';
import 'package:estate/event/event-bus.dart';
import 'package:estate/res/res_index.dart';

//新建任务
final String hintText = "抄送人可以查看任务执行情况";

class CreateMissionPage extends StatefulWidget{

  const CreateMissionPage({Key key, this.labelId,this.parent,this.willId}) : super(key: key);

  final String labelId;
  final MissionModel parent;
  final String willId;//民意记录id

  @override
  State<StatefulWidget> createState() {
    return _CreateMissionPageState();
  }
}

class _CreateMissionPageState extends State<CreateMissionPage>{
  MissionBloc missionBloc;
  WorkBloc workBloc;

  TextEditingController _controllerName = new TextEditingController();
  MissionModelReqs _missionModelReqs = new MissionModelReqs();
  DateTime _pickerTime;
  List<String> _options = [];
  int _choiseIndex = 0;
  List<ContactUserModel> excutePersonList,copyPersonList;
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

    if(widget.labelId == Ids.titleMissionBlow){
      missionBloc.willRecordDetail(widget.willId);
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

                        createParentAreaDes(),

                        createWillRecordArea(),

                        createInput(),

                        createExcutePerson(context),

                        createDateTime(context),

                        createCopyPerson(context),

                        createHintText(),

                        RoundButton(
                          text: '发 送',
                          margin: EdgeInsets.all(10),
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

  Widget createParentAreaDes(){
    if(widget.parent == null){
      return Container(height: 0,);
    }else{
      return Container(
        padding: EdgeInsets.all(10.0),
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('父任务内容为：',style: TextStyle(color: Colours.text_gray,fontSize: Dimens.font_sp14),),
            SizedBox(height: 10.0,),
            Text('${widget.parent.missionDes}',style: TextStyle(fontSize: Dimens.font_sp16),),
            SizedBox(height: 10.0,),
            Divider(height: 1.0,)
          ],
        )
      );
    }
  }

  //发送任务
  void sendMission(){
    _missionModelReqs.des = _controllerName.text;
    if(ObjectUtil.isEmpty(_missionModelReqs.des)) {
      Fluttertoast.showToast(msg: '请输入任务描述');
      return;
    }
    if(ObjectUtil.isEmpty(excutePersonList)){
      Fluttertoast.showToast(msg: '请添加执行人');
      return;
    }
    if(ObjectUtil.isEmpty(_missionModelReqs.needTime)){
      Fluttertoast.showToast(msg: '请选择截止时间');
      return;
    }
    String excutePersonIds = '',copyPersonIds = '';
    excutePersonList.asMap().forEach((index,item){
      excutePersonIds += item.id;
      if(index < excutePersonList.length){
        excutePersonIds += ',';
      }
    });
    _missionModelReqs.persons = excutePersonIds;
    if(ObjectUtil.isNotEmpty(copyPersonList)){
      copyPersonList.asMap().forEach((index,item){
        copyPersonIds += item.id;
        if(index < copyPersonList.length){
          copyPersonIds += ',';
        }
      });
    }
    _missionModelReqs.copyPersons = copyPersonIds;
    if(widget.parent != null)
      _missionModelReqs.parentId = widget.parent.id;

    if(widget.labelId == Ids.titleCreateMission){
      _missionModelReqs.type = 'user';
    }else if(widget.labelId == Ids.titleMissionBlow){
      _missionModelReqs.type = 'willblow';
      _missionModelReqs.relatedId = widget.willId;
    }
    if(_choiseIndex == 1) _missionModelReqs.notify = 15;
    if(_choiseIndex == 2) _missionModelReqs.notify = 60;
    if(_choiseIndex == 3) _missionModelReqs.notify = 180;
    if(_choiseIndex == 4) _missionModelReqs.notify = 1440;

    missionBloc.createMission(_missionModelReqs).then((data){
      Fluttertoast.showToast(msg: '创建成功');

      if(ApplicationEvent.event != null)
        ApplicationEvent.event.fire(StatusEvent(StatusEventConstant.REFRESH_MISSION_DETAIL_PAGE,1));

      Navigator.pop(context);
    }).catchError((_){
      Fluttertoast.showToast(msg: '出了一点小问题');
    });
  }

  //创建民意详情区域
  Widget createWillRecordArea(){
    if(widget.labelId == Ids.titleMissionBlow){
      return StreamBuilder(
        stream: missionBloc.willRecordModelReposStream,
        builder: (BuildContext context,
            AsyncSnapshot<WillRecordModel> snapshot) {
          if(ObjectUtil.isEmpty(snapshot.data)){
            return Container(height: 0);
          }
          WillRecordModel willRecordModel = snapshot.data;
          return Container(
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 10.0),
            padding: EdgeInsets.all(10.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('反馈标题：${willRecordModel.title}'),
                SizedBox(height: 5.0,),
                Text('反馈内容：${willRecordModel.content}'),

                SizedBox(height: 5.0,),
                Text('收 录 人：${willRecordModel.collectUser}'),
                SizedBox(height: 5.0,),
                Text('反 馈 人：${willRecordModel.username}'),
                SizedBox(height: 5.0,),
                Text('反馈人地址：${willRecordModel.address}'),
                SizedBox(height: 5.0,),
                Text('反馈人手机号：${willRecordModel.mobile}'),
              ],
            ),
          );
        }
      );

    }
    return Container(height: 0,);
  }

  //创建提示文字
  Widget createHintText(){
    return Container(
      padding: EdgeInsets.all(Dimens.gap_dp10),
      child: Text(hintText,style: TextStyle(color: Colours.text_gray,fontSize: Dimens.font_sp14),),
    );
  }

  //创建时间选择区域
  Widget createDateTime(context){
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: Dimens.gap_dp20),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('截止时间'),
            trailing: _pickerTime != null ? Text('${Utils.timeShowFormat(_pickerTime)}',style:TextStyle(fontSize: Dimens.font_sp16,color: Colours.text_normal)) : Icon(Icons.chevron_right,color: Colours.text_gray,),
            onTap: (){
              DatePicker.showDateTimePicker(context,
                  showTitleActions: true,
                  onChanged: (date) {
                  },
                  onConfirm: (date) {
                    _missionModelReqs.needTime = DateUtil.getDateStrByDateTime(date);
                    _pickerTime = date;

                    setState((){});
                  },
                  currentTime: _pickerTime??DateTime.now().add(Duration(days: 1)),
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
    );
  }

  //创建抄送人
  Widget createCopyPerson(context){
    return
      Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text('抄送人'),
              trailing: Icon(Icons.add_circle_outline,color: Theme.of(context).primaryColor,),
              onTap: (){
                  Navigator.push(
                      context, new CupertinoPageRoute<void>(builder: (ctx) => UserSelectPage(bloc:workBloc,callback: copyPersonSelectChange,selected: copyPersonList,showMe: false,)));
              },
            ),

            Divider(height: 1,),

            //选中的执行人
            Container(
              padding: EdgeInsets.only(left: 10.0,right: 10.0),
              child: Wrap(
                  children:buildPerson(copyPersonList)
              ),
            )
          ],
        )
      );
  }

  void excutePersonSelectChange(List<ContactUserModel> selectedUser){
    excutePersonList = selectedUser;
  }
  void copyPersonSelectChange(List<ContactUserModel> selectedUser){
    copyPersonList = selectedUser;
  }

  //创建添加执行人
  Widget createExcutePerson(context){
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: Dimens.gap_dp20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text('执行人'),
            trailing: Icon(Icons.add_circle_outline,color: Theme.of(context).primaryColor,),
            onTap: (){
              if(widget.labelId == Ids.titleMissionBlow){
                Navigator.push(
                    context, new CupertinoPageRoute<void>(builder: (ctx) =>
                    UserSelectPage(bloc: workBloc,
                      callback: excutePersonSelectChange,
//                      selected: excutePersonList,
                      showMe: true,
                      maxSelect: 1,)));
              }else {
                Navigator.push(
                    context, new CupertinoPageRoute<void>(builder: (ctx) =>
                    UserSelectPage(bloc: workBloc,
                      callback: excutePersonSelectChange,
                      selected: excutePersonList,
                      showMe: true,)));
              }
            },
          ),
          Divider(height: 1,),

          //选中的执行人
          Container(
            padding: EdgeInsets.only(left: 10.0,right: 10.0),
            child: Wrap(
              children:buildPerson(excutePersonList)
            ),
          )
        ],
      )
    );
  }

  List<Widget> buildPerson(List<ContactUserModel> selectedPerson){
    List<Widget> persons = [];
    if(ObjectUtil.isEmpty(selectedPerson)){
      persons.add(Container(height: 0,));
    }else{
      selectedPerson.asMap().forEach((index,item){
        persons.add(Container(
            height: 45,
            width: 45,
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 18,
              child:  item.portrait == null ?
              Text(item.realname.substring(0,1)):
              ClipOval(
                child:CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: '${item.portrait}',
                ),
              ),
            )
        ));
      });
    }
    return persons;
  }

  //创建输入区
  Widget createInput(){

    FocusNode focusNode = blankToolBarModel.getFocusNodeByController(_controllerName);

    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: Dimens.gap_dp20),
      child: TextField(
        controller: _controllerName,
        focusNode: focusNode,
        maxLines: 5,
        autofocus: false,
        textInputAction: TextInputAction.done,
        style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
        decoration: new InputDecoration(
            contentPadding: EdgeInsets.all(Dimens.gap_dp10),
            hintText: "请输入任务内容",
            hintStyle:TextStyle(fontSize: Dimens.font_sp16)
        ),
        onChanged: (value) {

        },
      ),
    );
  }

}