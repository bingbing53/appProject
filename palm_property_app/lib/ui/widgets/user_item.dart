import 'package:flutter/material.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/data/api/apis.dart';

//用户的列表
class UserItem extends StatelessWidget{

  const UserItem(this.model, {Key key}) : super(key: key);

  final CollectModel model;

  @override
  Widget build(BuildContext context) {

    model.portrait = WanAndroidApi.format(model.portrait,size: 1);

    return Column(
      children: <Widget>[
        GestureDetector(
          child:
          Row(
            children: <Widget>[
              Container(
                  height: 65,
                  padding: EdgeInsets.only(left: 15.0,right: 20.0),
                  child: CircleAvatar(
                    radius: 23,
                    child:  ObjectUtil.isEmpty(model.portrait) ?
                    Text(model.realname.substring(0,1)):
                    ClipOval(
                      child:CachedNetworkImage(
                        fit: BoxFit.fill,
                        imageUrl: '${model.portrait}',
                      ),
                    ),
                  )
              ),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('${model.realname}',style: TextStyle(fontSize: Dimens.font_sp16),),
                      SizedBox(height: 5.0,),
                    ],
                  )
              )
            ],
          ),
          onTap: (){
//            NavigatorUtil.pushPage(context, ChatUserPage(userModel: model,),pageName: model.realname);
            NavigatorUtil.pushWeb(context,url: WanAndroidApi.MINE_WORK_HISTORY.replaceAll('#id#', model.id).replaceAll('#title#', model.realname),title: model.realname);
          },
          behavior: HitTestBehavior.translucent,
        ),
        Divider(height: 1.0,color: Colours.gray_ce,)
      ],
    );
  }
}