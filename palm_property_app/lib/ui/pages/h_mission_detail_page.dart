import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:estate/blocs/bloc_index.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/data/api/apis.dart';
import 'package:estate/data/protocol/mission_models.dart';
import 'package:estate/event/event-bus.dart';
import 'package:estate/res/res_index.dart';
import 'package:estate/ui/dialog/simple_dialog.dart';
import 'package:estate/ui/pages/page_index.dart';


//任务详情
class MissionDetailPage extends StatefulWidget{

  const MissionDetailPage({Key key, this.labelId,this.parentId,this.mission}) : super(key: key);

  final String labelId,parentId;
  final MissionModel mission;
  @override
  State<StatefulWidget> createState() {
    return _MissionDetailPageState();
  }
}

class _MissionDetailPageState extends State<MissionDetailPage>{
  MissionBloc missionBloc;
  WorkBloc workBloc;

  MissionModelReqs _missionModelReqs = new MissionModelReqs();
  DateTime _pickerTime;

  MissionModel missionModel;

  @override
  void initState() {
    super.initState();
    missionBloc = BlocProvider.of<MissionBloc>(context);
    workBloc = BlocProvider.of<WorkBloc>(context);

    missionBloc.getMissionDetail(widget.mission.id);

//    _focusNodeFirstName.addListener(() {
//      if (_focusNodeFirstName.hasFocus) {
//        textFiledMarginTop = 40;
//      }else{
//        _focusNodeFirstName.unfocus();
//        textFiledMarginTop = 0;
//      }
//      setState((){});
//    });

    missionBloc.getMissionMessageList(widget.mission.id);
    _judgePermissions();

    ApplicationEvent.event.on<StatusEvent>().listen((event) {
      if(event.labelId == StatusEventConstant.REFRESH_MISSION_DETAIL_PAGE){
        missionBloc.getMissionDetail(widget.mission.id);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('详情'),
        actions: <Widget>[
          isMine == 1 ? IconButton(
            icon: Icon(Icons.restore_from_trash,color: Colors.white,),
            onPressed: (){
              SimpleDialogUtil.confirmDialog(context, (){
                missionBloc.updateMissionState(widget.mission.id,'2');

                Navigator.pop(context);

              },content:'删除任务后子任务也一起删除，并且无法恢复，是否继续删除任务？',title: '删除任务提示',confirmText: '确认删除',confirmType: ConfrimType.warning);
            },
          ):Container(height: 0,),
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.list),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      body:

      Column(
        children: <Widget>[

          Flexible(
            child:new ListView(
              reverse: false,
              children: <Widget>[
                createMissionDetail(),
//
                createDateTime(context),

                createExcutePerson(context),

                subMissionArea(),

                SizedBox(height:10.0),

                new StreamBuilder(
                    stream: missionBloc.moduleMessageReposStream,
                    builder: (BuildContext context,AsyncSnapshot<List<MissionMessageModel>> snapshot){
                      return _createChatList(snapshot.data);
                    }
                )
              ],
            ),
          ),
          new Container(
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          )
        ],
      ),

//      SingleChildScrollView(
//          child:Container(
//            margin: EdgeInsets.only(bottom: 60.0),
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//
//                createMissionDetail(),
//
//                createDateTime(context),
//
//                createExcutePerson(context),
//
//                subMissionArea(),
//
//                SizedBox(height:10.0),
//
//                new StreamBuilder(
//                    stream: missionBloc.moduleMessageReposStream,
//                    builder: (BuildContext context,AsyncSnapshot<List<MissionMessageModel>> snapshot){
//                      return _createChatList(snapshot.data);
//                    }
//                )
//
//              ],
//            ),
//          )
//      ),
      endDrawer: new Drawer(
        child: new StreamBuilder(
            stream: missionBloc.moduleDetailReposStream,builder: (BuildContext context,AsyncSnapshot<Map> snapshot) {
              return StatefulHistory(snapshot.data);
          }
        )
      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//      floatingActionButton: _buildTextComposer(),
    );
  }

  //判断是否有权限显示一个控件
  Widget _judgePermissions(){
    missionBloc.moduleDetailReposStream.listen((data){
      print(data);
      if(!ObjectUtil.isEmpty(data)) {
        //当前用户编号
        String userId = data['userId'];
        //任务拥有者编号
        if (userId == data['mission']['startUserId']) {
          showMissionButton = 1;
          isMine = 1;
        }else{
          List userList = data['receiveUsers'];
          //是否是任务执行人
          if(userList.length > 0) {
            for (var i = 0; i < userList.length; i++) {
              if(userList[i]['userId'] == userId){
                showMissionButton = 2;
              }
            }
          }
        }
        setState((){});
      }
    });
  }

  //构建聊天的消息
  Widget _createChatList(List<MissionMessageModel> list){
    if(ObjectUtil.isEmpty(list)){
      return Container(height:0);
    }

    List<Widget> items = [];
    for(var i = 0;i<list.length;i++){
      print(list[i].createDate);
      items.add(messageItem(list[i]));
    }

    return Column(
        children: items,
    );
  }
  //构建消息条目
  Widget messageItem(MissionMessageModel message){
    Widget item;
    if(message.fileCategory == 'event'){
      item =
        Container(
            padding: EdgeInsets.only(left: Dimens.gap_dp15,right: Dimens.gap_dp10,top: Dimens.gap_dp5,bottom: Dimens.gap_dp5),
            child:Row(
              children: <Widget>[
                Expanded(
                  child: Text(message.des),
                ),
                Text(Utils.timeShortFormat(message.createDate),style: TextStyle(fontSize: Dimens.font_sp14,color: Colours.text_gray))
              ],
            )
        );
    }else if(message.fileCategory == 'text'){
      item = Row(
        children: <Widget>[
          Container(
              height: 30,
              padding: EdgeInsets.only(left: Dimens.gap_dp10,right: Dimens.gap_dp10),
              child: CircleAvatar(
                radius: 23,
                child:  message.portrait == null ?
                Text(message.realname.substring(0,1)):
                ClipOval(
                  child:CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: '${message.portrait}',
                  ),
                ),
              )
          ),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${message.realname}  ${Utils.timeShortFormat(message.createDate)}',style: TextStyle(fontSize: Dimens.font_sp14,color: Colours.text_gray),),
                  SizedBox(height: 5.0,),
                  Text('${message.des}'),
                ],
              )
          )
        ],
      );
    }else if(message.fileCategory.startsWith('file_')){
      //附件形式
      item =
        GestureDetector(
          child: Container(
              padding: EdgeInsets.only(left: Dimens.gap_dp15,right: Dimens.gap_dp10,top: Dimens.gap_dp5,bottom: Dimens.gap_dp5),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text('${message.realname}上传附件 ${message.name}'),
                  ),
                  message.isMine == '1' ? GestureDetector(
                    child: Icon(Icons.delete_outline,color: Colors.red,size: 20),
                    onTap: (){
                      SimpleDialogUtil.confirmDialog(context, (){
                        missionBloc.deleteMissionFile(message.id).then((_){
                          missionBloc.getMissionMessageList(widget.mission.id);
                        });
                      },content:'是否确认删除此附件，删除后无法恢复！',title: '附件删除确认',confirmText: '确认删除',confirmType: ConfrimType.warning);

                    },
                  ):Container(height: 0),
                  Text(' ${Utils.timeShortFormat(message.createDate)}',style: TextStyle(fontSize: Dimens.font_sp14,color: Colours.text_gray),)
                ],
              )
          ),
          onTap: (){
            NavigatorUtil.pushWeb(context,
                url:WanAndroidApi.filePreview(message.des,size: 0),
                title: message.name);
          },
        );
    }
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 1),
      padding: EdgeInsets.only(top: Dimens.gap_dp5,bottom: Dimens.gap_dp5),
      width: double.infinity,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          item
        ],
      ),
    );
  }

  FocusNode _focusNodeFirstName = new FocusNode();
  double textFiledMarginTop = 0;
  TextEditingController _textEditController = new TextEditingController();
  //构建输入框
  Widget _buildTextComposer() {
    return  new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[
          new Flexible(
            child: Container(
                color: Colors.white,
                child: new TextField(
                    maxLines: null,
                    maxLengthEnforced: false,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    controller: _textEditController,
                    decoration:new InputDecoration.collapsed(hintText: ""),
                )
            ),
          ),
          new Container(
              margin: new EdgeInsets.symmetric(horizontal: 2.0),
              child: new IconButton(
                  icon: new Icon(Icons.add_circle_outline,size: 33,color: Colours.text_gray,),
                  onPressed: () => missionBloc.pickerFile(widget.mission.id))
          ),
          new RoundButton(
            radius:3,
            width: 60,
            text: '发送',
            height: 35,
            style: TextStyle(fontSize: Dimens.font_sp14,color: Colors.white),
            onPressed: () {
              if(_textEditController.text.length > 0) {
                String text = _textEditController.text;
                _textEditController.clear();
                _focusNodeFirstName.unfocus();
                missionBloc.sendMissionMessage(widget.mission.id, text);
              }
            },
          )
        ],
      ),
    );

    return  SingleChildScrollView(
      child:new Container(
        margin: EdgeInsets.only(bottom: textFiledMarginTop),
        color: Colors.white,
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textEditController,
                focusNode: _focusNodeFirstName,
                decoration:new InputDecoration.collapsed(hintText: ""),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 2.0),
              child: new IconButton(
                  onPressed: (){
                    if(_textEditController.text.length > 0) {
                      String text = _textEditController.text;
                      _textEditController.clear();
                      _focusNodeFirstName.unfocus();
                      missionBloc.sendMissionMessage(widget.mission.id, text);
                    }
                  },
                  icon: new Icon(Icons.send)
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 2.0),
              child: new IconButton(
                onPressed: (){
                  missionBloc.pickerFile(widget.mission.id);
                },
                icon: new Icon(Icons.attach_file,color: Colors.black,),
              ),
            ),
          ],
        ),
      )
    );
  }

  //任务的历史
  List historys = [];
  Widget StatefulHistory(Map data){
    List<Widget> items = [];
    if(data == null || data['historys'] == null || data['historys'].length <= 0){
      return new Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 50.0),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                Utils.getImgPath("ic_data_empty"),
//                  package: BaseConstant.packageBase,
                width: 60,
                height: 60,
              ),
              Gaps.vGap10,
              new Text(
                "空空如也～",
                style: TextStyles.listContent2,
              ),
            ],
          ),
        ),
      );
    }else {
      historys = data['historys'];
      return  Container(
          width: double.infinity,
          color: Colors.white,
          child:timelineModel(TimelinePosition.Left)
      );
    }
  }

  timelineModel(TimelinePosition position) => Timeline.builder(
      itemBuilder: centerTimelineBuilder,
      itemCount: historys.length,
      physics: position == TimelinePosition.Left
          ? ClampingScrollPhysics()
          : BouncingScrollPhysics(),
      position: position);

  TimelineModel centerTimelineBuilder(BuildContext context, int i) {
    final doodle = historys[i];
    return TimelineModel(
        Card(
          margin: EdgeInsets.only(top: 10.0),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  doodle['des'],
                  style: TextStyle(fontSize: Dimens.font_sp14),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  Utils.timeShortFormat(doodle['createDate']),
                  style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),
                )
              ],
            ),
          ),
        ),
        position: i % 2 == 0 ? TimelineItemPosition.right : TimelineItemPosition.left,
        isFirst: i == 0,
        isLast: i == historys.length,
        iconBackground: Colors.white,
        icon: i == 0 ? Icon(Icons.fiber_manual_record,color: Colors.red,) : Icon(Icons.fiber_manual_record,color: Colors.green,));
  }

  //创建子任务区域
  Widget subMissionArea(){
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          createChildrenMission(),
        StreamBuilder(
            stream: missionBloc.moduleDetailReposStream,
            builder: (BuildContext context,
                AsyncSnapshot<Map> snapshot) {
              return createSubMissionList(snapshot.data);
            }
        )
        ],
      ),
    );
  }

  Widget createSubMissionList(datas){
    if(datas == null){
      return Container(height: 0,);
    }
    List<Widget> items = [];
    List list = datas['subMissions'];
    for(var i = 0;i<list.length;i++){
      items.add(
        ListTile(
          leading: Icon(Icons.flag,color: Theme.of(context).primaryColor,),
          title: Text('${list[i]['missionDes']}'),
          onTap: (){
            NavigatorUtil.pushPage(
              context,
              BlocProvider<MissionBloc>(
                child: MissionDetailPage(labelId: Ids.titleMission,mission:MissionModel.fromNativeJson(list[i])),
                bloc: new MissionBloc(),
              ),
              pageName: Ids.titleMission,
            );
          },
        )
      );
      items.add(
        Divider(height: 1.0,)
      );
    }
    return Container(
      child: Column(
        children: items,
      ),
    );
  }


  int showMissionButton = 0,isMine = 0;
  //创建子任务按钮
  Widget createChildrenMission(){
    return  Row(
      children: <Widget>[
        showMissionButton >= 1 ? Expanded(
          child:  RoundButton(
            text: '创 建 子 任 务',
            margin: EdgeInsets.all(10),
            radius: 5.0,
            height:40.0,
            onPressed: () {
              NavigatorUtil.pushPage(
                context,
                BlocProvider<MissionBloc>(
                  child: CreateMissionPage(labelId: Ids.titleCreateMission,parent:missionModel),
                  bloc: new MissionBloc(),
                ),
                pageName: Ids.titleCreateMission,
              );
            },
          ),
        ):Container(height: 0,),
        showMissionButton >= 2 ? Expanded(
          child: RoundButton(
            text: '转 交 任 务',
            margin: EdgeInsets.all(10),
            radius: 5.0,
            height:40.0,
            onPressed: () {
              Navigator.push(
                  context, new CupertinoPageRoute<void>(builder: (ctx) => UserSelectPage(bloc:workBloc,callback: personSelectChange,showMe: false,maxSelect:1)));
            },
          )
        ):Container(height: 0,),
      ],
    );
  }
  //选择转交人
  List<ContactUserModel> personList = [];
  void personSelectChange(List<ContactUserModel> selectedUser){
    personList = selectedUser;

    if(personList.length > 0){
      SimpleDialogUtil.confirmCustomDialog(context,(){

        missionBloc.diliverMission(widget.mission.id,selectedUser[0].id);
        missionBloc.getMissionDetail(widget.mission.id);

      },'转交任务确认',Container(
        height: 150,
        child: Column(
          children: <Widget>[
            CircleAvatar(
              radius: 30,
              child:  selectedUser[0].portrait == null ?
              Text(selectedUser[0].realname.substring(0,1)):
              ClipOval(
                child:CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: selectedUser[0].portrait,
                ),
              ),
            ),
            Center(
              child: Text(selectedUser[0].realname,style: TextStyle(color: Colors.blueAccent),),
            ),
            SizedBox(height: 10,),
            Text('是否将任务转交给 ${selectedUser[0].realname}，转交后您不再对此任务负责。'),
          ],
        )
      ));
    }
  }

  //创建任务详情区域
  Widget createMissionDetail(){
    return StreamBuilder(
        stream: missionBloc.moduleDetailReposStream,
        builder: (BuildContext context,
            AsyncSnapshot<Map> snapshot) {
          if(ObjectUtil.isEmpty(snapshot.data)){
            return Container(height:0);
          }

          Color btnColor;
          String btnStr = '';
          missionModel = MissionModel.fromNativeJson(snapshot.data['mission']);

          String userId = snapshot.data['userId'];
          List userList = snapshot.data['receiveUsers'];
          //是否是任务执行人
          if(userList.length > 0) {
            for (var i = 0; i < userList.length; i++) {
              if(userList[i]['userId'] == userId){
                showMissionButton = 2;
                missionModel.finished = userList[i]['finished'];
              }
            }
          }

          if(ObjectUtil.isEmpty(missionModel.finished)){
              missionModel.finished = missionModel.closed;
          }
          if(missionModel.finished == '1'){
            btnColor = Theme.of(context).primaryColor;
            btnStr = '已完成';
          }else if(missionModel.finished == '0'){
            btnColor = Colors.red;
            btnStr = '待完成';
          }

          return Container(
              color:Colors.white,
              margin: EdgeInsets.only(bottom: Dimens.gap_dp10),
              padding: EdgeInsets.only(bottom: Dimens.gap_dp10),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text('任务内容',style: TextStyle(color: Colours.text_gray),),
                    leading: Icon(Icons.flag,color: Colors.blueAccent,),
                    trailing: RoundButton(
                      text: btnStr,
                      style:TextStyle(fontSize: Dimens.font_sp12,color: Colors.white),
                      margin: EdgeInsets.all(10),
                      radius: 5.0,
                      height: 25.0,
                      bgColor: btnColor,
                      width:MediaQuery.of(context).size.width / 4,
                      onPressed: () {
                        if(showMissionButton > 0)
                          missionBloc.changeMissionState(context,missionModel);
                      },
                    ),
                  ),
                  Divider(height: 1,),
                  Container(
                    padding: EdgeInsets.only(left: Dimens.gap_dp15,right:Dimens.gap_dp15,top: Dimens.gap_dp10),
                    child: Text('${missionModel.missionDes}'),
                  )
                ],
              )
          );
        }
    );

  }

  //创建时间选择区域
  Widget createDateTime(context){

    return StreamBuilder(
        stream: missionBloc.moduleDetailReposStream,builder: (BuildContext context,AsyncSnapshot<Map> snapshot) {

        if(ObjectUtil.isEmpty(snapshot.data)){
            return Container(height:0);
        }

        MissionModel temp = MissionModel.fromNativeJson(snapshot.data['mission']);
        if(temp != null){
          _pickerTime = DateUtil.getDateTime(temp.needTime);
          return Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('${Utils.timeShortFormat(temp.needTime)} 截止'),
                    trailing:Text('${(_pickerTime.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch)?'已过期':''}',style: TextStyle(color: Colors.red),),
                  ),
                  Divider(height: 1.0,)
                ],
              )
          );
        }
    });


  }

  //创建添加执行人
  Widget createExcutePerson(context){
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: Dimens.gap_dp10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text('任务执行人'),
            onTap: (){
            },
          ),
          Divider(height: 1,),

          StreamBuilder(
            stream: missionBloc.moduleDetailReposStream,builder: (BuildContext context,AsyncSnapshot<Map> snapshot) {
              return buildPerson(snapshot.data);
            }
          )
          //选中的执行人
        ],
      )
    );
  }

  Widget buildPerson(Map data){
    List<Widget> persons = [];
    if(data == null || data['receiveUsers'] == null || data['receiveUsers'].length <= 0){
      persons.add(Container(height: 0,));
    }else{
      List userList = data['receiveUsers'];
      for(var i = 0;i<userList.length;i++){
        persons.add(
            Container(
                width: 70,
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: Dimens.gap_dp5,bottom: Dimens.gap_dp5),
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 18,
                      child:  userList[i]['portrait'] == null ?
                      Text(userList[i]['realname'].substring(0,1)):
                      ClipOval(
                        child:CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: '${WanAndroidApi.format(userList[i]['portrait'],size: 1)}',
                        ),
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('${userList[i]['realname']}',style: TextStyle(fontSize: Dimens.font_sp14),overflow: TextOverflow.ellipsis,),
                        ],
                      )
                    ),
                    Text(userList[i]['finished'] == '1' ? '(已完成)':'(未完成)',style: TextStyle(fontSize: Dimens.font_sp10,color: userList[i]['finished'] == '1'?Colors.blueAccent:Colors.redAccent),),
                  ],
                ),
            )
        );
      }
    }

    //构建

    return Container(
      padding: EdgeInsets.only(left: 10.0,right: 10.0),
      child: Wrap(
          children:persons
      ),
    );
  }

}