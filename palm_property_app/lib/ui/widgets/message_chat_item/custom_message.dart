
import 'package:flutter/material.dart';
import 'package:estate/blocs/bloc_index.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/data/api/apis.dart';
import 'package:estate/ui/pages/page_index.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

//自定义消息
class CustomMessage extends StatelessWidget{
  const CustomMessage({Key key, this.model,this.bloc}) : super(key: key);

  final model;
  final WorkBloc bloc;

  @override
  Widget build(BuildContext context) {

    CustomMessageModel message = CustomMessageModel.fromJson(model.extras);

    return Column(
      children: <Widget>[
        Center(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(3.0),
              child:Container(
//                color: Colors.white30,
                padding: EdgeInsets.only(left:10.0,right: 10.0,top: 3.0,bottom: 3.0),
                child: Text(DateUtil.getDateStrByMs(model.createTime,format: DateFormat.ZH_YEAR_MONTH_DAY_HOUR_MINUTE),style: TextStyle(fontSize: Dimens.font_sp12),),
              )
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: buildContent(context,message)
        )

      ],
    );
  }

  Widget buildContent(BuildContext context,CustomMessageModel message){

    List<Widget> _children = [];

    double padding = 0;

    if(message.showType == '0'){
      //只显示一个内容即可
    _children.add(
      GestureDetector(
        onTap: (){
          if(ObjectUtil.isNotEmpty(message.prefix) && ObjectUtil.isNotEmpty(message.rid)){
            NavigatorUtil.pushWeb(context,title:message.data,url: '${message.prefix}${message.rid}');
          }
        },
        child: Row(
            children: <Widget>[
              Container(
                height: 30,
                padding: EdgeInsets.only(left: 10.0,right: 10.0),
                child: ClipOval(
                    child:CachedNetworkImage(imageUrl: WanAndroidApi.format(message.image))
                ),
              ),
              Expanded(
                  child: Text(message.data,maxLines: 2,style: TextStyle(fontSize: Dimens.font_sp16),overflow: TextOverflow.ellipsis)
              ),
            ]
        )
      )
    );

    }else if(message.showType == '1'){
      //显示图片加内容
      print(message.image);
      if(message.image != null && message.image != ''){

        if(message.thumb == '1'){
          _children.add(Row(
            children: <Widget>[
              Expanded(
                  child: Text(message.data,maxLines: 2,style: TextStyle(fontSize: Dimens.font_sp16),overflow: TextOverflow.ellipsis)
              ),
              Container(
                  width: 60.0,
                  height: 60.0,
                  child: CachedNetworkImage(imageUrl: WanAndroidApi.format(message.image,size: 0))
              ),
            ],
          ));
          padding = Dimens.gap_dp10;
        }else {
          _children.add(CachedNetworkImage(imageUrl: WanAndroidApi.format(message.image,size: 0)));
          _children.add(Container(
            padding: EdgeInsets.all(Dimens.gap_dp10),
            child: Text(message.data, maxLines: 2,
              style: TextStyle(fontSize: Dimens.font_sp16),overflow: TextOverflow.ellipsis,),
          ));
        }
//        _children.add(buildUrl(context,message));
        return GestureDetector(
            onTap: (){
              if(ObjectUtil.isNotEmpty(message.prefix) && ObjectUtil.isNotEmpty(message.rid)){
                NavigatorUtil.pushWeb(context,title:message.data,url: '${message.prefix}${message.rid}');
              }else if(message.action == 'articleVideo'){
                NavigatorUtil.pushPage(
                  context,
                  BlocProvider<EstateBloc>(
                    child: VideoPage(articleId: message.rid,title: message.title,),
                    bloc: new EstateBloc(),
                  ),
                  pageName: "articleVideo",
                );
//                NavigatorUtil.pushPage(context, VideoPage(articleId: message.rid,title: message.title,),pageName: "articleVideo");
              }
            },
            behavior:HitTestBehavior.translucent,
            child:Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.all(Dimens.gap_dp15),
              padding: EdgeInsets.all(padding),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _children
              ),
            )
        );
      }else{
//        _children.add(buildTitle(context,message));
        _children.add(Text(DateUtil.getDateStrByMs(model.createTime),style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),),);
        _children.add(SizedBox(height: Dimens.gap_dp10,));
        _children.add(Text(message.data??''),);
        _children.add(buildUrl(context,message));
      }


    }else if(message.showType == '2'){
      //要显示详情和查看详情，不用图片
      _children.add(buildTitle(context,message));

      _children.add(
        Container(
          child: Text(message.data,softWrap: true,),
        )
      );

      _children.add(buildUrl(context,message));
    }

    return Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(Dimens.gap_dp15),
        padding: EdgeInsets.all(Dimens.gap_dp10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _children
        )
    );

  }

  Widget buildTitle(BuildContext context,CustomMessageModel message){
    if(message.title != null && message.title != ''){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(message.title,style: TextStyle(fontSize: Dimens.font_sp18),),
          SizedBox(height:Dimens.gap_dp10),
        ],
      );
    }
    return SizedBox();
  }

  //构建资源链接
  Widget buildUrl(BuildContext context,CustomMessageModel message){
    if(message.rid != null && message.rid != ''){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: Dimens.gap_dp10,),
          Divider(height: 1.0,),
          SizedBox(height:Dimens.gap_dp10),

          GestureDetector(
            child: Text('查看详情',style: TextStyle(color: Colors.blue,fontSize: Dimens.font_sp14),),
            onTap: () async {

              if(ObjectUtil.isNotEmpty(message.prefix) && ObjectUtil.isNotEmpty(message.rid)){
                NavigatorUtil.pushWeb(context,title:message.data,url: '${message.prefix}${message.rid}');
              }else {
                if (message.action == 'order') {
                  await bloc.exitConversations();
                  NavigatorUtil.pushReplacePage(
                    context,
                    BlocProvider<EstateBloc>(
                      child: OrderDetailPage(
                          labelId: Ids.titleOrderDetail, orderId: message.rid,),
                      bloc: new EstateBloc(),
                    ),
                    pageName: Ids.titleOrderDetail,
                  );
                }else if(message.action == 'articleVideo'){
                  NavigatorUtil.pushPage(
                    context,
                    BlocProvider<EstateBloc>(
                      child: VideoPage(articleId: message.rid,title: message.title,),
                      bloc: new EstateBloc(),
                    ),
                    pageName: Ids.titleOrderDetail,
                  );
                }
              }
            },
          )

        ],
      );
    }
    return SizedBox();
  }

}