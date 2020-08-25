
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_wanandroid/blocs/bloc_index.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/api/apis.dart';

import 'activity/h_activity_sign_list.dart';

class  ActivitySignPage extends StatefulWidget {

  final String willId,missionId;

  const ActivitySignPage({Key key,this.missionId,this.willId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _ActivitySignPagetate();
  }
}
class _ActivitySignPagetate extends State<ActivitySignPage>{
  int _selectedIndex = 0;

  WorkBloc workBloc;

  @override
  void initState() {
    super.initState();
    workBloc = BlocProvider.of<WorkBloc>(context);
    workBloc.activltiList(1);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
        appBar: AppBar(
          title: Text('选择活动'),
        ),
        body:SingleChildScrollView(
          child: StreamBuilder(
              stream: workBloc.activityModelListReposStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<ActivityModel>> snapshot) {
                if(ObjectUtil.isEmpty(snapshot.data)){
                  return Container(height: 0);
                }
                List<ActivityModel> activitis = snapshot.data;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: activitis.map((value){
                    return buildItem(value);
                  }).toList(),
                );
              }
          ),
        )
    );
  }
  Widget buildItem(ActivityModel activity){

    return GestureDetector(
      child: Container(
        padding: EdgeInsets.only(left: 10,right: 10,top: 6),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: new AspectRatio(
                      aspectRatio: 5 / 4,
                      child: new CachedNetworkImage(
                          imageUrl: WanAndroidApi.format(activity.posterUrl),
                          fit: BoxFit.cover
                      ),
                    ),
                  ),
                  flex: 3,
                ),
                Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: new FractionalOffset(0.0, 0.0),
                            child: new Text(activity.title, style: TextStyle(fontSize: Dimens.font_sp16),
                                textAlign: TextAlign.left,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ),
                          SizedBox(height: 15),
                          new Row(
                            children: <Widget>[
                              Icon(Icons.business,size: 15.0,color: Colors.green,),
                              SizedBox(width: 5),
                              Flexible(
                                child: Text(activity.location == null?'':activity.location,style:TextStyle(fontSize: Dimens.font_sp12),maxLines:1,overflow:TextOverflow.ellipsis,textAlign: TextAlign.left,),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text('报名人数：${activity.total}   签到人数：${activity.register}',style:TextStyle(fontSize: Dimens.font_sp12))
                        ],
                      ),
                    ),
                    flex: 7
                ),
              ],
            ),
            SizedBox(height: 6),
            Divider()
          ],
        )
      ),
      onTap: () async{
        await NavigatorUtil.pushPageAsync(context, new ActivitySignPages(activityId:activity.id));
        workBloc.activltiList(1);
      },
    );

    //手机触屏手势
    return GestureDetector(
        child: Container(
          margin:EdgeInsets.only(bottom: 1),
          color: Colors.white,
          padding:EdgeInsets.symmetric(horizontal: 14,vertical: 15),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(activity.title,style:TextStyle(fontSize: Dimens.font_sp18),),
              Container(
                margin: EdgeInsets.only(left: 0, right:0,top: 10),
                child: Row(
                  children: <Widget>[
                   Expanded(
                     flex: 1,
                     child:  Text('报名人数：${activity.total}人', style:TextStyle(color:Colors.grey,fontSize: Dimens.font_sp14)),
                   ),
                    Expanded(
                      flex: 1,
                      child:  Text('签到人数：${activity.register}人', style:TextStyle(color:Colors.grey,fontSize: Dimens.font_sp14),
                          textAlign:TextAlign.center
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child:   Text('签到表>' ,style:TextStyle(color:Colors.grey,fontSize: Dimens.font_sp14),
                          textAlign:TextAlign.right
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 30,
              ),
            ],
          ),
        ),
      onTap: (){
          NavigatorUtil.pushPage(context, new ActivitySignPages(activityId:activity.id),pageName: "签到列表");
      }
    );
  }
}
