import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/ui/pages/page_index.dart';
import 'package:flutter_wanandroid/ui/pages/rec_hot_page.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_wanandroid/utils/util_index.dart' as util;
import 'package:flutter_wanandroid/ui/pages/page_index.dart';

bool isWorkInit = true;
class WorkPage extends StatelessWidget {
  const WorkPage({Key key, this.labelId}) : super(key: key);

  final String labelId;

  Widget buildBanner(BuildContext context, List<BannerModel> list) {
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }
    return new AspectRatio(
      aspectRatio: 16.0 / 9.0,
      child: Swiper(
        indicatorAlignment: AlignmentDirectional.topEnd,
        circular: true,
        interval: const Duration(seconds: 5),
        indicator: NumberWorkSwiperIndicator(),
        children: list.map((model) {
          return new InkWell(
            onTap: () {
              LogUtil.e("BannerModel: " + model.toString());
              NavigatorUtil.pushWeb(context,
                  title: model.title, url: model.actionContent);
            },
            child: new CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: model.image,
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          );
        }).toList(),
      ),
    );
  }

  //有权限的所有模块
  Widget buildModule(BuildContext context, List<ModuleModel> list) {
    if (ObjectUtil.isEmpty(list)) {
      return new Container(height: 0.0);
    }
    double width = MediaQuery.of(context).size.width / 4 ;
    List<Widget> _children = list.map((model) {
      if(model.superCode != 'work')
        return SizedBox();
      return Container(
        width: width,
        color: Colors.white,
        alignment: Alignment.center,
        child: new InkWell(
          onTap: () {
            LogUtil.e("BannerModel: " + model.toString());
            if(model.isWeb=='0'){
              Navigator.pushNamed(context, model.code);
            }else {
              if(model.code=="proposal"){
                util.NavigatorUtil.pushPage(
                  context,
                  BlocProvider<MissionBloc>(
                    child: WebViewPage( ),
                    bloc: new MissionBloc(),
                  ),
                  pageName: Ids.titleMeeting,
                );
              }
              else {
                String version = SpUtil.getString(model.code);
                SpUtil.putString(model.code, model.version);
                NavigatorUtil.pushWeb(context,
                    title: model.showName,
                    url: model.target,
                    refreshCache: Utils.getRefreshWeb(version, model.version));
              }
            }
          },
          child: Column(
            children: <Widget>[
                CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: model.showIcon,
                  width: width / 2,
//                  placeholder: (context, url) => new ProgressView(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
                SizedBox(height: 5.0,),
                Text(model.showName,style: TextStyle(fontSize:Dimens.font_sp12),)
            ],
          ),
        )
      );
    }).toList();
    List<Widget> children = new List();
    children.add(new HeaderItem(
//      leftIcon: Icons.dashboard,
      titleId: Ids.titleFunction,
    ));
    children.addAll(_children);
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
//        HeaderItem(
//          leftIcon: Icons.dashboard,
//          titleId: Ids.titleFunction,
//          extra: '',
//          rightIcon:IconData(0x1),
//        ),
          Container(
              child:Column(
                children: <Widget>[
//              SizedBox(height:Dimens.gap_dp15),
                  Wrap(
                    runSpacing: Dimens.gap_dp20,
                    children: _children,
                  ),
                  SizedBox(height:Dimens.gap_dp20),
                ],
              ),
              decoration: new BoxDecoration(
                color: Colors.white,
              )
          )
        ],
      )
    );
  }

  Widget buildWorkArticle(BuildContext context, List<WorkArticleModel> list) {
    if (ObjectUtil.isEmpty(list)) {
      return Container(
        child: Image.asset(Utils.getImgPath('no_article'))
      );
    }
    List<Widget> _children = list.map((model) {
      return new WorkArticleItem(
        model,
        isHome: true,
      );
    }).toList();
    List<Widget> children = new List();
    children.add(Container(height: 10.0,color: Colors.white,));
    children.addAll(_children);
    return new Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e("WorkPage build......");
    RefreshController _controller = new RefreshController();
    final WorkBloc bloc = BlocProvider.of<WorkBloc>(context);
    bloc.homeEventStream.listen((event) {
      if (labelId == event.labelId) {
        _controller.sendBack(false, event.status);
      }
    });

    bloc.getHomeData(labelId);
    //获取版本更新
    bloc.getVersion(context);
    //申请权限
    bloc.requestPermission();

    return new StreamBuilder(
          stream: bloc.bannerStream,
          builder:
              (BuildContext context, AsyncSnapshot<List<BannerModel>> snapshot) {
            int loadStatus = Utils.getLoadStatus(snapshot.hasError, snapshot.data);
            print('$loadStatus---------------');
            return new RefreshScaffold(
              labelId: labelId,
              loadStatus: loadStatus,
              controller: _controller,
              enablePullUp: false,
              onRefresh: ({bool isReload}) {
                bloc.getVersion(context);
                return bloc.onRefresh(labelId: labelId);
              },
              child: new ListView(
                padding: EdgeInsets.all(0),
                children: <Widget>[
                  buildBanner(context, snapshot.data),

                  new HeaderItem(
//                    leftIcon: Icon(Icons.widgets,color: Theme.of(context).primaryColor,size: 25.0,),
                    leftWidget: Image.asset(Utils.getImgPath('work_functions'),width: 25,),
                    titleId: Ids.titleFunction,
                    titleColor: Colors.black,
                    trailing: false,
                    onTap: () {
                      NavigatorUtil.pushTabPage(context,
                          labelId: Ids.titleWorkArticleTree, titleId: Ids.titleWorkArticleTree);
                    },
                  ),

                  Container(
                    color: Colors.white,
                    height: 20.0,
                  ),

                  new StreamBuilder(
                      stream: bloc.moduleListReposStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ModuleModel>> snapshot) {
                        return buildModule(context, snapshot.data);
                      }),
                  Container(height:10,color: Colors.white,),

                  new StreamBuilder(
                      stream: bloc.versionStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<VersionModel> snapshot) {
                        VersionModel version = snapshot.data;
                        if (ObjectUtil.isEmpty(version)) {
                          return new Container(
                            height: 0.0,
                          );
                        }
                        int status = Utils.getUpdateStatus(version.version);
                        if(status != 0){
                          return GestureDetector(
                            child: Container(
                                color: Colors.yellow,
                                padding: EdgeInsets.only(left: 10,right: 10,top: 5.0,bottom: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text('${status != 0 ? version.title??'' : version.title??''}',style: TextStyle(color: Colors.redAccent),maxLines: 1,),
                                    ),
                                    Text('${status != 0 ? '去下载 >' : ""}',style: TextStyle(fontSize: Dimens.font_sp14),),
                                  ],
                                )
                            ),
                            onTap: (){
                              if (status != 0) {
                                NavigatorUtil.launchInBrowser(version.url,
                                    title: version.title);
                              }
                            },
                          );
                        }
                        return new Container(height: 0,);
                      }),

                  new HeaderItem(
//                    leftIcon: Icon(Icons.add_alert,color: Theme.of(context).primaryColor,size: 25.0,),
                    leftWidget: Image.asset(Utils.getImgPath('work_notification'),width: 25,),
                    titleId: Ids.titleWorkNotificate,
                    titleColor: Colors.black,
                    onTap: () {
                      NavigatorUtil.pushTabPage(context,
                          labelId: Ids.titleWorkArticleTree, titleId: Ids.titleWorkArticleTree);
                    },
                  ),

                  Container(
                    color: Colors.white,
                    height: 10.0,
                  ),

                  new StreamBuilder(
                      stream: bloc.workArticleListReposStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<WorkArticleModel>> snapshot) {
                        return buildWorkArticle(context, snapshot.data);
                      }),
                ],
              ),
            );
        });
  }
}

class NumberWorkSwiperIndicator extends SwiperIndicator {
  @override
  Widget build(BuildContext context, int index, int itemCount) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black45, borderRadius: BorderRadius.circular(20.0)),
      margin: EdgeInsets.only(top: 20.0, right: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      child: Text("${++index}/$itemCount",
          style: TextStyle(color: Colors.white70, fontSize: 11.0)),
    );
  }
}
