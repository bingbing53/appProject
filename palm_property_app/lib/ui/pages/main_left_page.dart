import 'package:estate/data/api/apis.dart';
import 'package:estate/ui/dialog/simple_dialog.dart';
import 'package:flutter/material.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/ui/pages/page_index.dart';

class MainLeftPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MainLeftPageState();
  }
}

class PageInfo {
  PageInfo(this.titleId, this.iconData, this.page, [this.withScaffold = true]);

  String titleId;
  IconData iconData;
  Widget page;
  bool withScaffold;
}

class _MainLeftPageState extends State<MainLeftPage> {
  List<PageInfo> _pageInfo = new List();
  PageInfo loginOut = PageInfo(Ids.titleSignOut, Icons.power_settings_new, null);
  String _userName;

  WorkBloc _bloc;

  @override
  void initState() {
    super.initState();
    _pageInfo.add(PageInfo(Ids.titleSetting, Icons.settings, SettingPage()));
    _pageInfo.add(PageInfo(Ids.titleSignOut, Icons.power_settings_new, SharePage()));
    _bloc = BlocProvider.of<WorkBloc>(context);

  }

  void _showLoginOutDialog(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    _bloc.getMineInfoData();
    _userName = "";
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new Container(
            height: 186.0,
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.only(
                top: ScreenUtil.getInstance().statusBarHeight, left: 10.0),
            child: new Stack(
              children: <Widget>[
                buildMineDataPage(),
                new Align(
                  alignment: Alignment.topRight,
                  child: new IconButton(
                      iconSize: 18.0,
                      icon: new Icon(Icons.edit, color: Colors.transparent),
                      onPressed: () {}),
                )
              ],
            ),
          ),
          new Expanded(
            child: new ListView.builder(
                padding: const EdgeInsets.all(0.0),
                itemCount: _pageInfo.length,
                itemBuilder: (BuildContext context, int index) {
                  PageInfo pageInfo = _pageInfo[index];
                  return new ListTile(
                    leading: new Icon(pageInfo.iconData),
                    title: Text(IntlUtil.getString(context, pageInfo.titleId),style: TextStyle(fontSize: Dimens.font_sp16)),
                    onTap: () {
                      if(pageInfo.titleId == Ids.titleSignOut){
                        _showLoginOutDialog(context);
                      }else{
                        NavigatorUtil.pushPage(context,
                            BlocProvider<EstateBloc>(
                              child:pageInfo.page,
                              bloc: new EstateBloc(),
                            ), pageName: pageInfo.titleId);
                      }
                    },
                  );
                }),
            flex: 1,
          )
        ],
      ),
    );
  }

  Widget buildMineDataPage(){
    return StreamBuilder(
        stream: _bloc.sysUserInfoReposStream,
        builder: (BuildContext context, AsyncSnapshot<SysUserModel> snapshot) {
          print(snapshot.data);
            if(snapshot.data == null){
                return Container(
                  height:100
                );
            }
            SysUserModel user = snapshot.data;
            return Container(
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0,left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    height: 64.0,
                    width: 64.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32.0),
                      child: ObjectUtil.isEmpty(user.avatar) ? Image.asset(Utils.getImgPath('chat_single')) :CachedNetworkImage(
                        fit: BoxFit.cover,
                        height: 45,
                        width: 45,
                        imageUrl: '${WanAndroidApi.format(user.avatar)}',
                        errorWidget: (context, url, error) => Image.asset(Utils.getImgPath('chat_single')),
                      ),
                    ),
                  ),
//                  new Container(
//                    width: 64.0,
//                    height: 64.0,
//                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
//                    decoration: BoxDecoration(
//                      shape: BoxShape.circle,
//                      image: DecorationImage(
//                        image: AssetImage(
//                          Utils.getImgPath('chat_single'),
//                        ),
//                      ),
//                    ),
//                  ),
                  new Text(
                    user.realname,
                    style: new TextStyle(
                        color: Colors.white,
                        fontSize: Dimens.font_sp16,
                        fontWeight: FontWeight.bold),
                  ),
                  Gaps.vGap5,
                  new Text(
                    '${user.orgCode}（${user.areaCode}）',
                    style: new TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                ],
              ),
            );
        });
  }
}
