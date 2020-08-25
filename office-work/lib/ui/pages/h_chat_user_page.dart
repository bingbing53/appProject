import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/api/apis.dart';
import 'package:flutter_wanandroid/ui/dialog/simple_dialog.dart';
import 'package:flutter_wanandroid/ui/pages/page_index.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
//用户个人信息页面
class ChatUserPage extends StatelessWidget {
  const ChatUserPage({Key key, this.labelId,this.userModel}) : super(key: key);

  final String labelId;
  final ContactUserModel userModel;

  @override
  Widget build(BuildContext context) {
    LogUtil.e("ChatPage build......");
    final WorkBloc bloc = BlocProvider.of<WorkBloc>(context);
    bloc.isCollect(userModel.id);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.grey),
            actions: <Widget>[
              buildLikeBtn(bloc)
            ],
          ),
          body: Container(
              color: Colours.gray_f0,
              child:Column(
                children: <Widget>[
                  //基本信息
                  Container(
                    padding: EdgeInsets.only(left:1.0,right: 10.0,top: 15.0,bottom: 30.0),
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            width: 90,
                            child: CircleAvatar(
                                radius: 30,
                                child: ObjectUtil.isEmpty(userModel.portrait) ?
                                Text(userModel.realname.length > 2 ? userModel.realname.substring(1,3):userModel.realname):
                                ClipOval(
                                  child:CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    imageUrl: '${userModel.portrait}',
                                    height: 60,
                                    width: 60,
                                  ),
                                )
                            )
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('${userModel.realname}',style: TextStyle(fontSize: Dimens.font_sp18,fontWeight: FontWeight.bold),),
                                  Text('  ${ObjectUtil.isNotEmpty(userModel.officeName) ? '（${userModel.officeName}）':''}',style: TextStyle(color:Colours.text_gray,fontSize: Dimens.font_sp16,fontWeight: FontWeight.bold),),
                                ],
                              ),
                              Text('所属部门：${userModel.departname}',style: TextStyle(color: Colours.text_gray,fontSize: Dimens.font_sp12),),
                              SizedBox(height: 5.0,),
                              Text('类型：${userModel.personType}',style: TextStyle(color: Colours.text_gray,fontSize: Dimens.font_sp12),),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 10.0,),

//                  GestureDetector(
//                    behavior: HitTestBehavior.translucent,
//                    child: Container(
//                    color: Colors.white,
//                    padding: EdgeInsets.only(left: 15.0,right: 10.0,top: 15.0,bottom: 15.0),
//                    child: Row(
//                        children: <Widget>[
//                          Text('工作记录')
//                        ],
//                      ),
//                    ),
//                    onTap: (){
//                      print('点击工作记录');
//                    },
//                  ),
//
//                  SizedBox(height: 1.0,),

                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(top: 10.0,bottom: 10.0),
                    child: GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Image.asset(Utils.getImgPath('icon_send_message'),width: 25,),
                          Text('  发消息',style: TextStyle(color: Colours.app_main,fontSize: Dimens.font_sp16),)
                        ],
                      ),
                      onTap: (){
                        bloc.createConversation(userModel.mobilePhone).then((model){
                            bloc.enterConversation(model);
                            bloc.getHistoryMessages(model);
                            NavigatorUtil.pushPage(context, MessageChatPage(model:model,labelId: Ids.titleChatMessage,),pageName:'测试');
                        }).catchError((_){
                            SimpleDialogUtil.confirmDialog(context, (){

                              var model = fluwx.WeChatShareWebPageModel(
                                title: '掌上社区',
                                description:'快来下载掌上社区app吧，我在这里等你哦~',
                                webPage: WanAndroidApi.APP_DOWNLOAD,
                                thumbnail: "https://mongo.qicaidonghu.cn/pic/app/icon_wan_android.png",
                                scene: fluwx.WeChatScene.SESSION,
                              );

                              fluwx.share(model);


//                              var model = fluwx.WeChatShareTextModel(
//                                  text:'快来下载掌上社区app吧，我在这里等你哦~',
//                                  scene: fluwx.WeChatScene.SESSION,
//                              );
//                              fluwx.share(model);
                            },title:'提示信息',content: '${userModel.realname}还没有登录过app，分享下载链接给TA。',confirmText: '去分享',cancelText: '稍后');
                        });
                      },
                    ),
                  ),
                ],
              )
          )
      )
    );
  }

  Widget buildLikeBtn(WorkBloc bloc){
    return StreamBuilder(
        stream: bloc.focusReposStream,
        builder: (BuildContext context,
            AsyncSnapshot<dynamic> snapshot) {
          return buildLike(snapshot.data,bloc);
        });

  }

  Widget buildLike(dynamic isCollect,WorkBloc bloc){
    if(isCollect == 1){
      return GestureDetector(
        child:Container(
          padding: EdgeInsets.only(right: 17.0),
          child: Icon(Icons.favorite,color: Colors.red,size: 23,)
        ),
        onTap: (){
          bloc.unCollect(userModel.id);
        },
      );
    }else{
      return LikeButton(
          width: 56.0,
          duration: Duration(milliseconds: 500),
          onIconClicked:(val){
            if(val){
              bloc.collect(userModel.id);
            }else{
              bloc.unCollect(userModel.id);
            }
          }
      );
    }
  }
}
