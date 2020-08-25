import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/blocs/bloc_index.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/api/apis.dart';
import 'package:flutter_wanandroid/data/protocol/mission_models.dart';
import 'package:flutter_wanandroid/res/res_index.dart';

//会议详情
class MeetingDetailPage extends StatefulWidget{

  const MeetingDetailPage({Key key, this.labelId,this.missionHisotryId,this.meetingId}) : super(key: key);

  final String labelId;
  final String missionHisotryId;//任务关联历史编号
  final String meetingId;//会议编号

  @override
  State<StatefulWidget> createState() {
    return _MeetingDetailPageState();
  }
}

class _MeetingDetailPageState extends State<MeetingDetailPage>{
  MissionBloc missionBloc;
  WorkBloc workBloc;

  List<ContactUserModel> excutePersonList;

  @override
  void initState() {
    super.initState();
    missionBloc = BlocProvider.of<MissionBloc>(context);
    workBloc = BlocProvider.of<WorkBloc>(context);

    if(widget.labelId == Ids.titleMeeting){
      missionBloc.meetingDetail(widget.meetingId, 'id');
      missionBloc.getMeetingFileList(widget.meetingId);
    }else if(widget.labelId == Ids.titleWillMeeting){
      missionBloc.meetingDetail(widget.missionHisotryId, 'relatedId');
      missionBloc.getMeetingFileList(widget.meetingId,type: 'relatedId');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('会议详情'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder(
              stream: missionBloc.meetingStream,
              builder: (BuildContext context,
                  AsyncSnapshot<dynamic> snapshot) {
              return meetingDetail(snapshot.data);
            }),

            StreamBuilder(
              stream: missionBloc.meetingFileStream,
              builder: (BuildContext context,
              AsyncSnapshot<dynamic> snapshot) {
                return meetingFileList(snapshot.data);
              }
            )
          ],
        )
      )
    );
  }

  Widget meetingFileList(List data){
    if(ObjectUtil.isEmpty(data) || data.length <= 0){
      return new Container(height: 0);
    }

    List<Widget> widgets = [];
    widgets.add(
      ListTile(
        title: Text('会议纪要'),
      )
    );

    for(var i = 0;i<data.length;i++){
      widgets.add(Divider(height: 1,));
      widgets.add(
        ListTile(
          title: Text('${data[i]['content']}'),
          subtitle: Text('${data[i]['createdDate']}',style: TextStyle(fontSize: Dimens.font_sp12),),
          onTap: (){
            NavigatorUtil.pushWeb(context,
                url:WanAndroidApi.filePreview(data[i]['fileUrl'],size: 0),
                title: data[i]['content']);
          },
        )
      );
    }

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      ),
    );
  }

  //构建会议详情页
  Widget meetingDetail(data){
    if(ObjectUtil.isEmpty(data)){
      return Container(height: 0,);
    }
    final detail = data['meetingDetail'];

    List<Widget> items = [];

    items.add(ListTile(
      subtitle: Text(detail['content']),
      title: Text('会议内容'),
    ));

    items.add(Divider(height: 1,));

    items.add(ListTile(
      title: Text('开始时间'),
      trailing:Text(detail['startTime'])
    ));
    items.add(Divider(height: 1,));

    items.add(ListTile(
        title: Text('截止时间'),
        trailing:Text(detail['endTime']??'')
    ));
    items.add(Divider(height: 1,));

    String type = detail['type'];
    items.add(ListTile(
        title: Text('会议类型'),
        trailing:Text(type == '0'?'线下会议':'线上会议')
    ));
    items.add(Divider(height: 1,));
    if(type == '0'){
      items.add(ListTile(
        subtitle: Text(detail['location']??''),
        title: Text('会议地点'),
      ));
    }
    items.add(Divider(height: 1,));
    items.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text('参会人'),
//              trailing: Text('会议统计',style: TextStyle(color: Colours.text_gray),),
            ),
            //选中的执行人
            Container(
              padding: EdgeInsets.only(left: 10.0,right: 10.0,bottom: 10.0),
              child: Wrap(
                  children:buildPerson(data['parties'])
              ),
            )
          ],
        )
    );

    if(detail['state'] == '0'){

      items.add(
        RoundButton(
          bgColor: Colors.grey,
          text: '会议已取消',
          margin: EdgeInsets.all(10),
          radius: 5.0,
          height: 40.0,
        )
      );

      items.add(
          ListTile(
              title: Text('取消原因'),
              subtitle:Text(detail['cancelReason']??'')
          )
      );

    }else {
      final party = data['party'];
      final mine = data['mine'];

      var reason = '';
      if (ObjectUtil.isNotEmpty(party) && party['accept'] != '1' && mine != 1) {
        items.add(
            Row(
              children: <Widget>[
                Expanded(
                  child: RoundButton(
                    text: '接受会议',
                    margin: EdgeInsets.all(10),
                    radius: 5.0,
                    height: 40.0,
                    onPressed: () {
                      missionBloc.acceptMeeting(detail['id'], "1");
                    },
                  ),
                ),
                Expanded(
                  child: RoundButton(
                    bgColor: Colors.red,
                    text: '拒绝会议',
                    margin: EdgeInsets.all(10),
                    radius: 5.0,
                    height: 40.0,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) =>
                          new AlertDialog(
                              title: new Text('拒绝会议原因'),
                              content: Container(
                                height: 150,
                                child: Column(
                                  children: <Widget>[
                                    TextField(
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        labelText: '请输入拒绝会议原因',
                                      ),
                                      autofocus: true,
                                      maxLines: 4,
                                      onChanged: (val) {
                                        reason = val;
                                      },
                                    ),
                                  ],),
                              ),
                              actions: <Widget>[
                                new FlatButton(
                                  child: new Text('再想想'), onPressed: () {
                                  Navigator.of(context).pop();
                                },),
                                new FlatButton(child: new Text(
                                  '确认拒绝', style: TextStyle(color: Colors.red),),
                                  onPressed: () {
                                    if (reason
                                        .trim()
                                        .length <= 0) {
                                      Fluttertoast.showToast(msg: '请输入拒绝原因');
                                      return;
                                    }
                                    missionBloc.acceptMeeting(
                                        detail['id'], "2", reason: reason);
                                    Navigator.pop(context);
                                  },)
                              ]

                          ));
                    },
                  ),
                ),
              ],
            )
        );
      }


      String cancelReason = '';
      if (!ObjectUtil.isEmpty(mine) && mine == 1) {
        items.add(
            Container(
                margin: EdgeInsets.only(top: 20.0),
                child: RoundButton(
                  bgColor: Colors.red,
                  text: '取消会议',
                  margin: EdgeInsets.all(10),
                  radius: 5.0,
                  height: 40.0,
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) =>
                        new AlertDialog(
                            title: new Text('取消会议原因'),
                            content: Container(
                              height: 150,
                              child: Column(
                                children: <Widget>[
                                  TextField(
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: '请输入取消会议原因',
                                    ),
                                    autofocus: true,
                                    maxLines: 4,
                                    onChanged: (val) {
                                      cancelReason = val;
                                    },
                                  ),
                                ],),
                            ),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text('再想想'), onPressed: () {
                                Navigator.of(context).pop();
                              },),
                              new FlatButton(child: new Text(
                                '确认取消', style: TextStyle(color: Colors.red),),
                                onPressed: () {
                                  if (cancelReason
                                      .trim()
                                      .length <= 0) {
                                    Fluttertoast.showToast(msg: '请输入取消原因');
                                    return;
                                  }
                                  missionBloc.cancelMeeting(
                                      detail['id'], cancelReason);
                                  Navigator.pop(context);
                                },)
                            ]

                        ));
                  },
                )
            )
        );
      }
    }

    return Container(
      color: Colors.white,
      child: Column(
        children: items,
      ),
    );
  }

  List<Widget> buildPerson(parties){
    List<Widget> persons = [];
    if(ObjectUtil.isEmpty(parties)){
      persons.add(Container(height: 0,));
    }else{
      parties.asMap().forEach((index,item){

        Color acceptColor = Colors.grey;
        String acceptText = '待接受';
        if(item['accept'] == '1'){
          acceptColor = Colors.blue;
          acceptText='接受';
        }else if(item['accept'] == '2'){
          acceptColor = Colors.red;
          acceptText='拒绝';
        }

        Color readColor = Colors.grey;
        String readText = '未读';
        if(item['read_state'] == '1'){
          readColor = Colors.blue;
          readText='已读';
        }

        persons.add(
            Row(
              children: <Widget>[
                Container(
                    height: 55,
                    padding: EdgeInsets.only(left: 15.0,right: 20.0),
                    child: CircleAvatar(
                      radius: 23,
                      child:  item['portrait'] == null ?
                      Text(item['realname'].substring(0,1)):
                      ClipOval(
                        child:CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: '${WanAndroidApi.format(item['portrait'])}',
                        ),
                      ),
                    )
                ),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text('${item['realname']}',style: TextStyle(fontSize: Dimens.font_sp16),),
//                            Container(
//                                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
//                                margin: EdgeInsets.only(left: 10.0),
//                                decoration: BoxDecoration(
//                                    color: readColor,
//                                    borderRadius: BorderRadius.circular(5.0)),
//                                child: Text(readText,style: TextStyle(fontSize: Dimens.font_sp12,color: Colors.white,fontWeight: FontWeight.bold),)
//                            ),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                                margin: EdgeInsets.only(left: 10.0),
                                decoration: BoxDecoration(
                                    color: acceptColor,
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Text(acceptText,style: TextStyle(fontSize: Dimens.font_sp12,color: Colors.white,fontWeight: FontWeight.bold),)
                            ),
                          ],
                        ),
                        SizedBox(height: 5.0,),
                        Text('回复：${item['reject_reason']??''}')
                      ],
                    )
                )
              ],
            ),
        );
        persons.add(SizedBox(height: 10.0,));
        persons.add(Divider(height:1));
        persons.add(SizedBox(height: 5.0,));
      });
    }
    return persons;
  }

}