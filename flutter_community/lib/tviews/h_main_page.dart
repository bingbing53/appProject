import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/blocs/bloc_index.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/common/net_utils.dart';
import 'package:helloworld/event/event-bus.dart';
import 'package:helloworld/event/event-model.dart';
import 'package:helloworld/routers/application.dart';
import 'package:helloworld/tviews/consumer/consumer_page_index.dart';
import 'package:helloworld/tviews/consumer/login/login_base_page.dart';
import 'package:helloworld/tviews/widget/simple_dialog.dart';
import 'package:helloworld/tviews/widget/widget_index.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'package:helloworld/utils/util_index.dart';

import 'consumer/article/index_page.dart';
import 'consumer/message/h_message_page.dart';

class TabMainPage extends StatefulWidget {
  TabMainPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TabMainPageState();
  }
}

class _Item {
  String name, activeIcon, normalIcon,code;
  Widget page;

  _Item(this.name, this.activeIcon, this.normalIcon,this.code,this.page);
}

//List<Widget> pages;

class _TabMainPageState extends State<TabMainPage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  final itemNames = [
    _Item('消息', Utils.getImgPath('ic_tab_subject_active'),
        Utils.getImgPath('ic_tab_subject_normal'),'message',MessagePage()),
    _Item('头条', Utils.getImgPath('ic_tab_home_active'),
        Utils.getImgPath('ic_tab_home_normal'),'work',HeadLineIndexPage()),
    _Item('首页', Utils.getImgPath('ic_tab_index_active'),
        Utils.getImgPath('ic_tab_index_normal'),'user',ConsumerHomePage()),
//    _Item('邻里', Utils.getImgPath('ic_tab_location_active'),
//        Utils.getImgPath('ic_tab_location_normal'),'user',TraderIndexPage()),
    _Item('我的', Utils.getImgPath('ic_tab_profile_active'),
        Utils.getImgPath('ic_tab_profile_normal'),'mine',MinePage(),)
  ];

  List<BottomTabBarItem> itemList;
  var _pageController = new PageController(initialPage: 2);
  int _selectIndex = 2;

  MainBloc _mainBloc;

  @override
  void initState() {
    super.initState();

    Loading.ctx = context;

//    _checkUpdate();

      ApplicationEvent.event.on<GotoLoginEvent>().listen((event) {
//        if(event.name == 'certificateTwo'){
//          BaseUtils.showConfirm(context, '此功能需要二级认证，是否确定认证？', (){
//            Navigator.push(
//                context, new MaterialPageRoute(builder: (BuildContext context) {
//              return new CertificationTwoPage();
//            }));
//          });
//        }else if(event.name == 'certificateThree'){
//            BaseUtils.showConfirm(context, '此功能需要三级认证，是否确定认证？', (){
//              Navigator.push(
//                  context, new MaterialPageRoute(builder: (BuildContext context) {
//                return new CertificationThreePage();
//              }));
//            });
//        }else if(event.name == 'volunteer'){
//          BaseUtils.showConfirm(context, '您还没有认证志愿者，是否认证？', (){
//            Navigator.push(
//                context, new MaterialPageRoute(builder: (BuildContext context) {
//              return new CertificationOnePage(type:'volunteer');
//            }));
//          });
//        }else{
//          Navigator.pushAndRemoveUntil(
//              context, new MaterialPageRoute(builder: (BuildContext context) {
//              return new LoginPage();
//          },));
        Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(
              builder: (context) => new LoginPage()),
              (route) => route == null,
        );

      });

    if(itemList == null){
        itemList = itemNames.map((item) => BottomTabBarItem(
            icon: Image.asset(
              item.normalIcon,
              width: 30.0,
              height: 30.0,
            ),
            title: Text(
              item.name,
              style: TextStyle(fontSize: 10.0),
            ),
            activeIcon:Image.asset(item.activeIcon, width: 25.0, height: 25.0),
        )).toList();
    }

    _mainBloc = BlocProvider.of<MainBloc>(context);
    _mainBloc.userRegister();
    _mainBloc.unreadMsgCountStream.listen((num){
      print(num);
      itemList = itemNames.map((item) => BottomTabBarItem(
        icon: Image.asset(
          item.normalIcon,
          width: 26.0,
          height: 33.0,
        ),
        title: Text(
          item.name,
          style: TextStyle(fontSize: 10.0),
        ),
        activeIcon:Image.asset(item.activeIcon, width: 26.0, height: 33.0),
        badgeNo:(num > 0 && item.code == 'message' )?'${num > 99 ? '99+':num}':null,
      )).toList();

      if (!mounted) return;
      setState((){});
    });
  }

  Future _checkSelectPage(){
    String street = SpUtil.getString(SharedPreferencesKeys.sysOrgCode,defValue: '');
    String token = SpUtil.getString(Constant.key_token_name, defValue: '');
    if(street == '' && token != ''){
      NavigatorUtil.pushReplacePage(context, SelectPlacePage(),pageName: '选择社区');
    }
  }

//Stack（层叠布局）+Offstage组合,解决状态被重置的问题
  Widget _getPagesWidget(int index) {
    return /*Offstage(
      offstage: _selectIndex != index,
      child: TickerMode(
        enabled: _selectIndex == index,
        child: */itemNames[index].page;
//      ),
//    );
  }

  @override
  void didUpdateWidget(TabMainPage oldWidget) {
    super.didUpdateWidget(oldWidget);

  }

  @override
  Widget build(BuildContext context) {
    Loading.ctx = context;
    // 延时2s执行返回
    Future.delayed(Duration(seconds: 2), (){
      _checkSelectPage();
    });

    return WillPopScope(
      onWillPop: AndroidBackTop.backDeskTop, //页面将要消失时，调用
      child: Scaffold(
        body: new PageView.builder(
          onPageChanged: _pageChange,
          controller: _pageController ,
          itemCount: itemNames.length,
          itemBuilder: (BuildContext context, int index){
            return _getPagesWidget(index);
          }
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomTabBar(
            items: itemList,
            onTap: (int index) {
              ///这里根据点击的index来显示，非index的page均隐藏
              setState(() {
                _selectIndex = index;
                //这个是用来控制比较特别的shopPage中WebView不能动态隐藏的问题
//            shopPageWidget.setShowState(pages.indexOf(shopPageWidget) == _selectIndex);
              });
              _pageController.animateToPage(index,duration: const Duration(milliseconds: 1), curve: Curves.ease);
            },
            //图标大小
            iconSize: 24,
            //当前选中的索引
            currentIndex: _selectIndex,
            type: BottomTabBarType.fixed,
            badgeColor:Colors.red
        ),
      )
    );
  }

  void _pageChange(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  _checkUpdate() async{
    String platform = 'jm_android';
    if(Platform.isIOS){
      platform = 'jm_ios';
    }else if(Platform.isAndroid){
      platform = 'jm_android';
    }
    var response = await NetUtils.get('work/version',params:{'platform':platform});
    SimpleDialogUtil.showNewVersionAppDialog(context, response, confirm: () {

    });
  }

}
