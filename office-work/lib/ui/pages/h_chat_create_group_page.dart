import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/blocs/bloc_index.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/ui/dialog/simple_dialog.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

//创建群组页面
class ChatCreateGroup extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ChatCreateGroupPage();
  }
}

class _ChatCreateGroupPage extends State<ChatCreateGroup>{

  WorkBloc bloc;
  MissionBloc missionBloc;

  List<ContactUserModel> selectedUsers;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<WorkBloc>(context);
    bloc.getChatUserList();

    missionBloc = BlocProvider.of<MissionBloc>(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('创建议事厅'),
        actions:<Widget>[
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: (){
              Utils.changeChatUserSort();
              bloc.getChatUserList();
            },
          ),
          MaterialButton(
            textColor: Colors.white,
            shape : const RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(0))),
            child: Text('创建',style: TextStyle(fontSize: Dimens.font_sp18),),
            onPressed: () {
              if(selectedUsers == null || selectedUsers.length <= 0){
                Fluttertoast.showToast(msg:'请选择朋友');
                return;
              }

              SimpleDialogUtil.createGroupDialog(
                context,(name,des){

                saveForm(name,des);

              },'群信息'
              );
            },
          )
        ]
      ),
      body: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new WorkUserSelect(bloc: bloc,callback: selectChange,)
                  ),
              ],
      )
    );
  }

  Future saveForm(name,des) async{
    List<String> usernames = [];
    String persons = '';
    for(var i = 0;i<selectedUsers.length;i++){
      usernames.add(selectedUsers[i].mobilePhone);
      persons += selectedUsers[i].id+",";
    }

    String groupId = await bloc.createGroup(name,des,usernames,groupType: JMGroupType.public);

    MeetingModelReqs meetingModelReqs = new MeetingModelReqs();
    meetingModelReqs.content = des;
    meetingModelReqs.type = '2';
    meetingModelReqs.groupId = groupId;
	  meetingModelReqs.topic=name;
	  meetingModelReqs.persons=persons;

    missionBloc.startMeeting(meetingModelReqs).then((result){
      Fluttertoast.showToast(msg: '议事厅创建成功');
      Navigator.pop(context);
    }).catchError((val){
      Fluttertoast.showToast(msg: '出现了点问题，请稍后重试！');
    });
  }

  //选择改变
  void selectChange(List<ContactUserModel> selectedUser){
    selectedUsers = selectedUser;
  }

}