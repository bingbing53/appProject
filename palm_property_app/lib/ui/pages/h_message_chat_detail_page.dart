import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/data/api/apis.dart';
import 'package:estate/ui/dialog/simple_dialog.dart';
import 'package:estate/ui/pages/page_index.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';
bool isMessageChatDetailInit = true;
//聊天群的信息
class MessageChatDetailPage extends StatefulWidget {

  const MessageChatDetailPage({Key key, this.labelId,this.model}) : super(key: key);

  final String labelId;
  final JMConversationInfo model;

  @override
  State<StatefulWidget> createState() {
    return _MessageChatDetailPageState();
  }
}

class _MessageChatDetailPageState extends State<MessageChatDetailPage>{

  WorkBloc bloc;
  MissionBloc missionBloc;

  String meetingName = '群聊';
  String mineCreate = '0';
  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<WorkBloc>(context);
    missionBloc = BlocProvider.of<MissionBloc>(context);

    bloc.getGroupMembers(widget.model);
    missionBloc.getMeetingDetailByGroupId(widget.model.target.id);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colours.gray_f0,
      appBar: AppBar(
        title: Text(widget.model.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new StreamBuilder(
                stream: bloc.groupMemberListStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<JMGroupMemberInfo>> snapshot) {
                  return buildConverChat(context,snapshot.data,bloc);
                }),
          ],
        )
      )
    );
  }

  Widget buildMeetingDetail(MeetingDetailModel detail){
    if(detail == null)
      return Container(height: 0);

    List<Widget> items = [];

    items.add(Container(
      padding: EdgeInsets.only(top: 20),
    ));

    if(ObjectUtil.isNotEmpty(detail)) {
      items.add(Container(
        padding: EdgeInsets.all(10.0),
        child: Text(
          detail.content ?? '', style: TextStyle(fontSize: Dimens.font_sp16),),
      ));
    }

    if(detail.type == '1')
      meetingName = '会议';
    else if(detail.type == '2')
      meetingName = '议事厅';

    items.add(addCanRemove());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    );
  }

  //构建聊天界面
  Widget buildConverChat(BuildContext context,List<JMGroupMemberInfo> list,WorkBloc bloc){
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }

    double width = (MediaQuery.of(context).size.width - 60) / 5;

    List<String> usernames = [];

    List<Widget> _children = list.map((model) {
      usernames.add(model.user.username);
      return buildPersonArea(model,width);
    }).toList();

    bool canAdd = false,canRemove = false;
    String mobile = SpUtil.getString(Constant.key_login_name);
    for(var i = 0;i<list.length;i++){
      if(list[i].user.username == mobile){
        if(list[i].memberType == JMGroupMemberType.owner || list[i].memberType == JMGroupMemberType.admin){
          canAdd = true;canRemove = true;
        }
      }
    }
    if(canAdd) {
      _children.add(
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(
                  left: Dimens.gap_dp10, top: Dimens.gap_dp15),
              height: width,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Image.asset(Utils.getImgPath('add'),width: 65)
              ),
            ),
            onTap: (){
              NavigatorUtil.pushPage(context, GroupPersonManage(labelId: Ids.titleGroupPersonAdd,model:widget.model,usernames: usernames,),pageName: Ids.titleGroupPersonAdd);
            },
          ),
      );
    }
    if(canRemove){
      _children.add(
          GestureDetector(
            child: Container(
              margin: const EdgeInsets.only(
                  left: Dimens.gap_dp10, top: Dimens.gap_dp15),
              height: width,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Image.asset(Utils.getImgPath('cut'),width: 65)
              ),
            ),
            onTap: (){
              NavigatorUtil.pushPage(context, GroupPersonManage(labelId: Ids.titleGroupPersonDel,model:widget.model,showUsernames: usernames,),pageName: Ids.titleGroupPersonDel);
            },
          )
      );

      mineCreate = '1';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          children: _children,
        ),
        new StreamBuilder(
            stream: missionBloc.meetingDetailStream,
            builder: (BuildContext context,
                AsyncSnapshot<MeetingDetailModel> snapshot) {
              return buildMeetingDetail(snapshot.data);
            }),
      ],
    );
  }

  Widget addCanRemove(){
    if(mineCreate == '1') {
      return Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(left: 30,right: 30),
          child: Row(
            children: <Widget>[
              Expanded(child: MaterialButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text('解散$meetingName'),
                  shape: const RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  onPressed: () {
                    SimpleDialogUtil.confirmDialog(context, () {
                      bloc.dissolveGroup(widget.model).then((_) {
                        Navigator.pop(context, 'close');
                      });
                    }, title: '解散$meetingName提示',
                        content: '是否确认解散$meetingName？',
                        confirmType: ConfrimType.warning,
                        confirmText: '确认');
                  }
              ))
            ],
          )
      );
    }else{
      return Container(
        height: 0
      );
    }
  }

  //构建个人信息
  Widget buildPersonArea(JMGroupMemberInfo model,double width){
    String portrait = WanAndroidApi.format(model.user.extras['portrait'],size: 1);
    String realname = model.user.nickname;
    return Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: Dimens.gap_dp10,top: Dimens.gap_dp15),
            height: width,
            padding: EdgeInsets.all(3.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child:portrait == '' || portrait == null? Image.asset(Utils.getImgPath('chat_single')) :CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: '$portrait',
                errorWidget: (context, url, error) => Image.asset(Utils.getImgPath('chat_single'))
              ),
            ),
          ),
          Container(
            alignment:Alignment.center,
            margin: const EdgeInsets.only(left: Dimens.gap_dp10),
            width: width,
            child: Text(realname,style: TextStyle(color: Colours.text_gray,fontSize: Dimens.font_sp14,),overflow: TextOverflow.ellipsis,)
          ),

        ],
    );
  }
}