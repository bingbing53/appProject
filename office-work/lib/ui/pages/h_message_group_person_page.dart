import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';
//群成员管理
class GroupPersonManage extends StatefulWidget {
  const GroupPersonManage({Key key, this.labelId,this.model,this.usernames,this.showUsernames}) : super(key: key);

  final String labelId;
  final JMConversationInfo model;
  final List<String> usernames;
  final List<String> showUsernames;

  @override
  State<StatefulWidget> createState() {
    return _GroupPersonManagePage();
  }
}

class _GroupPersonManagePage extends State<GroupPersonManage>{

  List<ContactUserModel> selectedUsers;

  @override
  Widget build(BuildContext context) {
    final WorkBloc bloc = BlocProvider.of<WorkBloc>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(IntlUtil.getString(context, widget.labelId)),
        actions: <Widget>[
          MaterialButton(
            textColor: Colors.white,
            shape : const RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(0))),
            child: Text(widget.labelId == Ids.titleGroupPersonAdd?'添加':'移除',style: TextStyle(fontSize: Dimens.font_sp18),),
            onPressed: () async{
              List<String> usernames = [];
              for(var i = 0;i<selectedUsers.length;i++){
                usernames = [];
                print(selectedUsers[i].mobilePhone);
                usernames.add(selectedUsers[i].mobilePhone);
                try {
                  print(widget.labelId);
                  if (widget.labelId == Ids.titleGroupPersonAdd) {
                    print(widget.model.target.id);
                    await bloc.addGroupMembers(widget.model.target.id, usernames);
                  } else if (widget.labelId == Ids.titleGroupPersonDel) {
                    print(widget.model.target.id);
                    print(usernames);
                    String mobile = SpUtil.getString(Constant.key_login_name);
                    print('mine----------$mobile');
                    await bloc.removeMember(widget.model.target.id, usernames);
                  }
                }catch(err){
                  print(err);
                }
              }
              bloc.getGroupMembers(widget.model);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body:Column(
          children: <Widget>[
          Expanded(
            flex: 1,
            child: new WorkUserSelect(bloc: bloc,callback: selectChange,activeColor: widget.labelId == Ids.titleGroupPersonDel?Colors.redAccent:null,selected: widget.usernames,showList: widget.showUsernames,unShowList: widget.usernames,)
          )]
      )
    );
  }

  //选择改变
  void selectChange(List<ContactUserModel> selectedUser){
    selectedUsers = selectedUser;
  }
}