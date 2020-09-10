import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/ui/dialog/simple_dialog.dart';
import 'package:flutter_wanandroid/ui/pages/page_index.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MinePageState();
  }
}

class PageInfo {
  PageInfo(this.titleId, this.iconData, this.page,this.tabPage, [this.withScaffold = true,this.isWeb = false,this.url]);

  String titleId;
  IconData iconData;
  Widget page;
  bool withScaffold;
  bool tabPage;
  bool isWeb;
  String url;
}

class _MinePageState extends State<MinePage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  List<PageInfo> _pageInfo = new List();

  WorkBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<WorkBloc>(context);

    _bloc.getMineData();
    _bloc.getMineDataCount();
  }

  Widget buildMineInfo(UserInfoModel user,WorkBloc bloc){
    if (user == null) {
      return new Container(height: 0.0);
    }
    return new Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          child: Container(
              width: 64.0,
              height: 64.0,
              margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
              child:CircleAvatar(
                radius: 23,
                child:  ObjectUtil.isEmpty(user.portrait) ?
                Text(user.realname.length > 2 ? user.realname.substring(1,3) : user.realname):
                ClipOval(
                  child:CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: '${user.portrait}',
                    width: 64,
                    height: 64,
                  ),
                ),
              )
          ),
          onTap: (){

            Widget item = Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading:Icon(Icons.photo_camera),
                    title: Text('拍照'),
                    onTap: (){
                      bloc.clickAvatar(ImageSource.camera);
                      Navigator.pop(context);
                    },
                  ),
                  Divider(height: 1.0,),
                  ListTile(
                    leading:Icon(Icons.photo_library),
                    title: Text('相册'),
                    onTap: (){
                      bloc.clickAvatar(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            );
            SimpleDialogUtil.showModalBottom(context,item,'更换头像');
          },
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(top: 50,left: 10,right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  '${user.realname}',
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                new Text(
                  "${user.memo??''}",
                  style:
                  new TextStyle(color: Colors.white, fontSize: 10.0),
                ),
              ],
            )
          )
        ),
      ],
    );

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          child: Container(
              width: 64.0,
              height: 64.0,
              margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
              child: ClipOval(
                child: CachedNetworkImage(
                  width: 64,
                  height: 64,
                  fit: BoxFit.fill,
                  imageUrl: '${user.portrait}',
                  placeholder: (context, url) => new ProgressView(),
                  errorWidget: (context, url, error) => new Icon(Icons.person,size: 64,color: Colors.white,),
                ),
              )
          ),
          onTap: (){

            Widget item = Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading:Icon(Icons.photo_camera),
                    title: Text('拍照'),
                    onTap: (){
                      bloc.clickAvatar(ImageSource.camera);
                      Navigator.pop(context);
                    },
                  ),
                  Divider(height: 1.0,),
                  ListTile(
                    leading:Icon(Icons.photo_library),
                    title: Text('相册'),
                    onTap: (){
                      bloc.clickAvatar(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            );
            SimpleDialogUtil.showModalBottom(context,item,'更换头像');
          },
        ),
        new Text(
          '${user.realname}',
          style: new TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.bold),
        ),
        new Text(
          "${user.memo??''}",
          style:
          new TextStyle(color: Colors.white, fontSize: 10.0),
        ),
      ],
    );
  }

  //构建我的统计
  Widget buildMineCountView(MineCountData data){
    if(data == null){
      return SizedBox(height: 0,);
    }

    List<Widget> _children = [];

    _children.add(Divider(height: 1,color: Colors.white,));

    _children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          data.invest != null?Expanded(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0,),
                Text('调查',style: TextStyle(color: Colors.white,fontSize: 12),textAlign: TextAlign.center,),
                SizedBox(height: 2.0,),
                Text('${data.invest}',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                SizedBox(height: 5.0,),
              ],
            ),
          ):SizedBox(),
          data.willRecord != null ?Expanded(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0,),
                Text('民意',style: TextStyle(color: Colors.white,fontSize: 12),textAlign: TextAlign.center,),
                SizedBox(height: 2.0,),
                Text('${data.willRecord}',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                SizedBox(height: 5.0,),
              ],
            ),
          ):SizedBox(),
          data.groups != null ?Expanded(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0,),
                Text('小组人数',style: TextStyle(color: Colors.white,fontSize: 12),textAlign: TextAlign.center,),
                SizedBox(height: 2.0,),
                Text('${data.groups}',style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                SizedBox(height: 5.0,),
              ],
            ),
          ):SizedBox()
        ],
      )
    );

    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
          children: _children
      )
    );

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.only(
                top: ScreenUtil.getInstance().statusBarHeight, left: 20.0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: (){
                _bloc.getMineData();
                _bloc.getMineDataCount();
              },
              child: new SizedBox(
                height: 140.0,
                width: double.infinity,
                child: Stack(
                  children: <Widget>[
                    //我的个人记录
                    new StreamBuilder(
                        stream: _bloc.userinfoReposStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<UserInfoModel> snapshot) {
                          return buildMineInfo(snapshot.data,_bloc);
                        }),
                    new Align(
                      alignment: Alignment.topRight,
                      child: new IconButton(
                          iconSize: 18.0,
                          icon: new Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            NavigatorUtil.pushPage(context, MineInfoPage(),pageName: 'mineInfo');
                          }),
                    )
                  ],
                ),
              ),
            ),
            ),
          //我的统计
          new StreamBuilder(
              stream: _bloc.userCountStream,
              builder: (BuildContext context,
                  AsyncSnapshot<MineCountData> snapshot) {
                return buildMineCountView(snapshot.data);
              }),

          new StreamBuilder(
              stream: _bloc.moduleListReposStream,
              builder: (BuildContext context,
                  AsyncSnapshot<List<ModuleModel>> snapshot) {
                _pageInfo = new List();
                if(!ObjectUtil.isEmpty(snapshot.data)){
                  for(var i = 0;i<snapshot.data.length;i++){
                    if(snapshot.data[i].superCode == 'mine' && snapshot.data[i].code == 'collect'){
                      _pageInfo.add(PageInfo(Ids.titleCollection, Icons.collections, CollectionPage(),false,false,true,snapshot.data[i].target));
                    }else if(snapshot.data[i].superCode == 'mine' && snapshot.data[i].code == 'focus'){
                      _pageInfo.add(PageInfo(Ids.titleFocus, Icons.favorite, SettingPage(),true));
                    }else if(snapshot.data[i].superCode == 'mine' && snapshot.data[i].code == 'prepare'){
                      _pageInfo.add(PageInfo(Ids.titlePrepare, Icons.calendar_today, BlocProvider<MissionBloc>(
                        child: PreparePage(),
                        bloc: new MissionBloc(),
                      ),false));
                    }else if(snapshot.data[i].superCode == 'mine' && snapshot.data[i].code == 'modifypwd'){
                      _pageInfo.add(PageInfo(Ids.titleModifyPwd, Icons.mode_edit, BlocProvider<LoginBloc>(
                        child: ModifyPasswdPage(labelId: Ids.titleModifyPwd),
                        bloc: new LoginBloc(),
                      ),false));
                    }
                  }
                }
                _pageInfo.add(PageInfo(Ids.titleSetting, Icons.settings, SettingPage(),false));
                _pageInfo.add(PageInfo(Ids.titleSignOut, Icons.power_settings_new, null,false));
                return Expanded(
                  child: new ListView.builder(
                      padding: const EdgeInsets.all(0.0),
                      itemCount: _pageInfo.length,
                      itemBuilder: (BuildContext context, int index) {
                        PageInfo pageInfo = _pageInfo[index];
                        return new ListTile(
                            leading: new Icon(pageInfo.iconData),
                          title:
                          new Text(IntlUtil.getString(context, pageInfo.titleId)),
                          onTap: () {
                            if (pageInfo.titleId != Ids.titleSignOut) {
                              if(pageInfo.isWeb){
                                NavigatorUtil.pushWeb(context,title: '加载中...',url: pageInfo.url,refreshCache: true);
                              }else {
                                if (pageInfo.tabPage) {
                                  NavigatorUtil.pushTabPage(context,
                                      labelId: pageInfo.titleId,
                                      titleId: pageInfo.titleId);
                                } else {
                                  NavigatorUtil.pushPage(context, pageInfo.page,
                                      pageName: pageInfo.titleId);
                                }
                              }
                            } else {
                              SimpleDialogUtil.confirmDialog(context,(){
                                SpUtil.remove(Constant.key_token_name);
                                _bloc.unRegisterJMessage();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) {
                                    return BlocProvider<LoginBloc>(
                                        child: LoginMainPage(),
                                        bloc: LoginBloc());
                                  }),
                                );
                              },title: '退出提醒',content: '您确认退出吗？退出后您可以重新登陆。',confirmText: '确认退出',confirmType:ConfrimType.warning);
                            }
                          },
                        );
                      }),
                  flex: 1,
                );
          }),
        ],
      ),
    );
  }
}
