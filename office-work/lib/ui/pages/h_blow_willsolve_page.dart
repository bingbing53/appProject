import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/api/apis.dart';
import 'package:flutter_wanandroid/event/event-bus.dart';
import 'package:flutter_wanandroid/ui/dialog/simple_dialog.dart';
import 'package:flutter_wanandroid/utils/util_index.dart';

//民情民意吹哨处理页面
class BlowWillSolvePage extends StatefulWidget {

  final String labelId,missionId,ownerUser;
  final WillRecordModel willRecordModel;

  const BlowWillSolvePage({Key key, this.labelId, this.missionId,this.ownerUser,this.willRecordModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _BlowWillSolvePageState();
  }

}

class _BlowWillSolvePageState extends State<BlowWillSolvePage> with WidgetsBindingObserver{

  MissionBloc missionBloc;
  WorkBloc workBloc;
  TextEditingController _controllerName = new TextEditingController();
  @override
  void initState() {
    super.initState();
    missionBloc = BlocProvider.of<MissionBloc>(context);
    workBloc = BlocProvider.of<WorkBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    print(widget.labelId);
    return Scaffold(
      appBar: AppBar(
        title: Text(IntlUtil.getString(context, widget.labelId)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            buildContentBody(),

            SizedBox(height: 50.0),

            showSubmitButton()
          ],
        )
      )
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("--" + state.toString());
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        print('暂停');
        break;
      case AppLifecycleState.resumed:// 应用程序可见，前台
        print('可见');
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        print('不可见');
        break;
      case AppLifecycleState.detached: // 申请将暂时暂停
        print('暂停1');
        break;
    }
  }

  //构建体
  Widget buildContentBody(){
    switch(widget.labelId){
      case Ids.titleWillBlowTans:
        //移交
        return willBlowTans();
        break;
      case Ids.titleWillFinish:
        //办结
        return willFinish();
        break;
      case Ids.titleWillFeedback:
        //反馈
        return willFeedback();
        break;
      case Ids.titleBlowFinishDetail:
        missionBloc.getMissionMessageList(widget.missionId,userId: widget.ownerUser);
        return showFile();
    }
    return Container(height: 0);
  }

  Widget showSubmitButton(){
    if(widget.labelId == Ids.titleBlowFinishDetail){
      return Container(height: 0);
    }
    return RoundButton(
      text: '提  交',
      margin: EdgeInsets.all(10),
      onPressed: () {
        submitWillBlow();
      },
    );
  }

  //提交
  submitWillBlow() async{
    if(widget.labelId == Ids.titleWillBlowTans){
      //移交
      if(ObjectUtil.isEmptyList(excutePersonList)){
        Fluttertoast.showToast(msg: '请选择移交人');
        return;
      }
      String des = _controllerName.text;
      if(ObjectUtil.isEmpty(des)){
        Fluttertoast.showToast(msg: '请输入处理意见');
        return;
      }
      await missionBloc.diliverMission(widget.missionId,excutePersonList[0].id,des: des);
    }else if(widget.labelId == Ids.titleWillFinish){
      //办结
      String des = _controllerName.text;
      if(ObjectUtil.isEmpty(des)){
        Fluttertoast.showToast(msg: '请输入处理意见');
        return;
      }
      await missionBloc.updateMissionState(widget.missionId,'0',des:des);

    }else if(widget.labelId == Ids.titleWillFeedback){
      //反馈
      String des = _controllerName.text;
      if(ObjectUtil.isEmpty(des)){
        Fluttertoast.showToast(msg: '请输入反馈意见');
        return;
      }
      await missionBloc.willBlowFeedBack(widget.missionId, des);
    }

//    if (ApplicationEvent.event != null) {
//      ApplicationEvent.event.fire(StatusEvent(StatusEventConstant.REFRESH_BLOW_WILLRECORD_PAGE,1));
//    }

    Navigator.pop(context,"refresh");
  }

  List<ContactUserModel> excutePersonList = [];
  //移交
  Widget willBlowTans(){
    return Container(
      child: Column(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: Text('移交人'),
                trailing: Icon(Icons.add_circle_outline,color: Theme.of(context).primaryColor,),
                onTap: (){
                    Navigator.push(
                        context, new CupertinoPageRoute<void>(builder: (ctx) =>
                        UserSelectPage(bloc: workBloc,
                          callback: excutePersonSelectChange,
//                          selected: excutePersonList,
                          showMe: true,
                          maxSelect: 1,))
                    );
                },
              ),
              Divider(height: 1,),
              //选中的执行人
              Container(
                padding: EdgeInsets.only(left: 10.0,right: 10.0),
                child: Wrap(
                    children:buildPerson(excutePersonList)
                ),
              ),
              TextField(
                controller: _controllerName,
                maxLines: 5,
                autofocus: false,
                style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
                decoration: new InputDecoration(
                    contentPadding: EdgeInsets.all(Dimens.gap_dp10),
                    hintText: "请输入处理意见",
                    hintStyle:TextStyle(fontSize: Dimens.font_sp16)
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
  void excutePersonSelectChange(List<ContactUserModel> selectedUser){
    excutePersonList = selectedUser;
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
                  placeholder: (context, url) => new ProgressView(),
                  errorWidget: (context, url, error) => new Icon(Icons.person,color: Colors.white,),
                ),
              ),
            )
        ));
      });
    }
    return persons;
  }

  //办结
  Widget willFinish(){

    missionBloc.getMissionMessageList(widget.missionId,mine: '1');

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            controller: _controllerName,
            maxLines: 5,
            autofocus: false,
            style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
            decoration: new InputDecoration(
                contentPadding: EdgeInsets.all(Dimens.gap_dp10),
                hintText: "请输入处理意见",
                hintStyle:TextStyle(fontSize: Dimens.font_sp16)
            ),
          ),

          showFile(),

          RoundButton(
            height: 30,
            width: 100,
            text: '添加附件',
            margin: EdgeInsets.all(10),
            onPressed: () {

              Widget item = Container(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading:Icon(Icons.photo_camera),
                      title: Text('相册'),
                      onTap: (){
                        missionBloc.pickerFile(widget.missionId,mine:'1',type: FileType.IMAGE);
                        Navigator.pop(context);
                      },
                    ),
                    Divider(height: 1.0,),
                    ListTile(
                      leading:Icon(Icons.photo_library),
                      title: Text('文件'),
                      onTap: (){
                        missionBloc.pickerFile(widget.missionId,mine:'1');
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              );
              SimpleDialogUtil.showModalBottom(context,item,'选择分类');


            },
          ),
        ],
      ),
    );
  }

  //反馈
  Widget willFeedback(){
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          ObjectUtil.isNotEmpty(widget.willRecordModel)?
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('反馈人姓名：${widget.willRecordModel.username}'),
              Row(
                children: <Widget>[
                  Text('反馈人电话：'),
                  GestureDetector(
                    onTap: (){
                        NavigatorUtil.diaMobile(widget.willRecordModel.mobile);
                    },
                    child: Text('${widget.willRecordModel.mobile}',style: TextStyle(color: Colors.blueAccent),),
                  )
                ],
              )
            ],
          )
          :
          Container(height: 0),

          SizedBox(height: 10,),

          Divider(height: 1,),

          TextField(
            controller: _controllerName,
            maxLines: 5,
            autofocus: false,
            style: new TextStyle(fontSize: 14.0, color: Colors.grey[900]),
            decoration: new InputDecoration(
                contentPadding: EdgeInsets.all(Dimens.gap_dp10),
                hintText: "请输入反馈意见",
                hintStyle:TextStyle(fontSize: Dimens.font_sp16)
            ),
          ),

          SizedBox(height: 10.0,),

          Wrap(
            runSpacing: 10,
            spacing: 10,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(3),
                child: Text('快捷回复',style: TextStyle(fontSize:Dimens.font_sp12),),
              ),
              GestureDetector(
                onTap: (){
                  _controllerName.text = '已拨打电话反馈';
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                  padding: EdgeInsets.all(3),
                  child:Text('已拨打电话反馈',style: TextStyle(fontSize: Dimens.font_sp12),),
                  decoration: new BoxDecoration(
                    border: new Border.all(color: Colours.text_gray, width: 0.5), // 边色与边宽度
                    borderRadius: new BorderRadius.all(Radius.circular(5)), // 也可控件一边圆角大小
                  ),
                )
              ),
              GestureDetector(
                onTap: (){
                  _controllerName.text = '已处理完成';
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Container(
                  padding: EdgeInsets.all(3),
                  child:Text('已处理完成',style: TextStyle(fontSize: Dimens.font_sp12),),
                  decoration: new BoxDecoration(
                    border: new Border.all(color: Colours.text_gray, width: 0.5), // 边色与边宽度
                    borderRadius: new BorderRadius.all(Radius.circular(5)), // 也可控件一边圆角大小
                  ),
                )
              ),
            ],
          )

        ],
      ),
    );
  }

  //展示附件
  Widget showFile(){

    return new StreamBuilder(
        stream: missionBloc.moduleMessageReposStream,
        builder: (BuildContext context,AsyncSnapshot<List<MissionMessageModel>> snapshot){
          return _createChatList(snapshot.data);
        }
    );
  }

  //构建聊天的消息
  Widget _createChatList(List<MissionMessageModel> list){
    if(ObjectUtil.isEmpty(list)){
      return Container(height:0);
    }

    List<Widget> items = [];
    for(var i = 0;i<list.length;i++){
      items.add(messageItem(list[i]));
    }

    return Column(
      children: items,
    );
  }
  //构建消息条目
  Widget messageItem(MissionMessageModel message){
    Widget item = Container(height: 0,);
    if(message.fileCategory.startsWith('file_')){
      //附件形式

      bool image = new RegExp('.(jpg|gif|jpeg)+').hasMatch(message.des);
      item =Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                            missionBloc.getMissionMessageList(widget.missionId,userId: widget.ownerUser);
                          });
                        },content:'是否确认删除此附件，删除后无法恢复！',title: '附件删除确认',confirmText: '确认删除',confirmType: ConfrimType.warning);
                      },
                    ):Container(height: 0),
                    Text(' ${Utils.timeShortFormat(message.createDate)}',style: TextStyle(fontSize: Dimens.font_sp14,color: Colours.text_gray),)
                  ],
                )
            ),
            onTap: (){
              NavigatorUtil.launchInBrowser(WanAndroidApi.format(message.des,size: 0),title: message.name);
            },
          ),
          image ? Container(
            width: MediaQuery.of(context).size.width / 2,
            padding: EdgeInsets.only(left: 10.0),
            child: new CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: WanAndroidApi.format(message.des,size: 0),
              placeholder: (context, url) => new ProgressView(),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          ):Container(height: 0)
        ],
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

}
