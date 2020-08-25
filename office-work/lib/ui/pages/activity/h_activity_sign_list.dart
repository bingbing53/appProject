
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_wanandroid/blocs/bloc_index.dart';
import 'package:flutter_wanandroid/common/component_index.dart';

import 'h_activity_sign_Information.dart';

class  ActivitySignPages extends StatefulWidget {

  final String activityId;

  const ActivitySignPages({Key key, this.activityId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _ActivitySignPagetates();
  }
}
class _ActivitySignPagetates extends State<ActivitySignPages>{
  int _selectedIndex = 1;

  WorkBloc workBloc;

  @override
  void initState() {
    super.initState();
    workBloc = BlocProvider.of<WorkBloc>(context);
    workBloc.activitySignList(widget.activityId);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      appBar: AppBar(
        title: Text('签到表'),
//          actions: <Widget>[
//            IconButton(icon: Icon(Icons.share),onPressed: (){}),
//          ],
      ),
      floatingActionButton: FloatingActionButton( //悬浮按钮
          child: Icon(Icons.add),
          onPressed:_onAdd
      ),
      body:SingleChildScrollView(
        child: StreamBuilder(
            stream: workBloc.activitySignModelListReposStream,
            builder: (BuildContext context,
                AsyncSnapshot<List<ActivitySignModel>> snapshot) {
              if(ObjectUtil.isEmpty(snapshot.data)){
                return Container(height: 0);
              }
              List<ActivitySignModel> activitySign=snapshot.data;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: activitySign.map((value){
                  return buildItem(value);
                }).toList(),
              );
            }
        ),
      )
    );
  }



  Widget buildItem(ActivitySignModel ActivitySign) {
    //手机触屏手势
    return GestureDetector(
        child: Container(
          margin:EdgeInsets.only(bottom: 1),
          color: Colors.white,
          padding:EdgeInsets.symmetric(horizontal: 14,vertical: 15),
          child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Row(
                children: <Widget>[
                  Expanded(
                    child:Text('${ActivitySign.realname??''}',style:TextStyle(fontSize:Dimens.font_sp16)),
                    flex: 1,
                  ),
                  Expanded(
                    child: Text('获得：${ActivitySign.points}积分 | ${ActivitySign.timeLong}小时',style:TextStyle(fontSize:Dimens.font_sp14,color: Colours.text_normal),),
                    flex: 2,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child:Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: Dimens.gap_dp10,vertical: 0),
                          margin: EdgeInsets.only(top: 0),
                          //设置 child 居中
                          alignment: Alignment(0, 0),
                          height: 18,
                          //边框设置
                          decoration: new BoxDecoration(
                            //背景
                            color: Colors.blue,
                            //设置四周圆角 角度
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            //设置四周边框
                            border: new Border.all(width: 1, color: Colors.blue),
                          ),
                          child: Text('${ActivitySign.signType == '2' ? '电子签到':(ActivitySign.signType == '3' ? "扫码签到":(ActivitySign.signType == '4'?"身份证签到":"其它"))}',style:TextStyle(fontSize:Dimens.font_sp12,color: Colors.white)),
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Text('${ActivitySign.update_date??''}',style:TextStyle(fontSize:Dimens.font_sp14,color: Colours.text_gray),),
                    flex: 2,
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
  void _onAdd() async{
    await NavigatorUtil.pushPageAsync(context, new ActivitySignInformationsPages(activityId: widget.activityId));
    workBloc.activitySignList(widget.activityId);
  }
  }



