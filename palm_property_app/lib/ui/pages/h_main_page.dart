import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/event/event-bus.dart';
import 'package:estate/ui/pages/page_index.dart';

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

  _TabMainPageState(){
    final eventBus = new EventBus();
    ApplicationEvent.event = eventBus;

    ApplicationEvent.event.on<StatusEvent>().listen((event) {
      if(event.labelId == 'login' && event.status == 1){
        SpUtil.remove(Constant.key_token_name);
        Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
            return BlocProvider<LoginBloc>(
                child: LoginMainPage(),
                bloc: LoginBloc());
          }),
          (Route route) => false
        );
      }
    });
  }

  final itemNames = [
    _Item('消息', Utils.getImgPath('ic_tab_subject_active'),
        Utils.getImgPath('ic_tab_subject_normal'),'message',MessagePage(labelId: Ids.titleMessage),),
    _Item('订单', Utils.getImgPath('ic_tab_home_active'),
        Utils.getImgPath('ic_tab_home_normal'),'work',
      BlocProvider<EstateBloc>(
        child:  HomePage(),
        bloc: new EstateBloc(),
      ),
      ),
    _Item('报事', Utils.getImgPath('ic_tab_shiji_active'),
      Utils.getImgPath('ic_tab_shiji_normal'),'work',
      BlocProvider<EstateBloc>(
        child: FeedBackPage(labelId: Ids.titleFeedBack,),
        bloc: new EstateBloc(),
      ),
    ),
    _Item('开门', Utils.getImgPath('ic_tab_group_active'),
        Utils.getImgPath('ic_tab_group_normal'),'user',
      BlocProvider<EstateBloc>(
        child: DevicePage(),
        bloc: new EstateBloc(),
      ),
    )
//    _Item('我的', Utils.getImgPath('ic_tab_profile_active'),
//        Utils.getImgPath('ic_tab_profile_normal'),'mine',MinePage(),)
  ];

  List<BottomTabBarItem> itemList;
  WorkBloc bloc;
  var _pageController = new PageController(initialPage: 1);
  int _selectIndex = 1;

  @override
  void initState() {
    super.initState();
    Loading.ctx = context;


    bloc = BlocProvider.of<WorkBloc>(context);

    bloc.initMessageHome();

    bloc.unreadMsgCountStream.listen((num){
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
    if(itemList == null){
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
      )).toList();
    }
  }

  //Stack（层叠布局）+Offstage组合,解决状态被重置的问题
  Widget _getPagesWidget(int index) {
    return itemNames[index].page;
  }


  @override
  void didUpdateWidget(TabMainPage oldWidget) {
    super.didUpdateWidget(oldWidget);

  }

  @override
  Widget build(BuildContext context) {
    print('build _ContainerPageState');
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
        bottomNavigationBar: Theme(
          data: ThemeData(canvasColor: Colors.white),
          child:BottomTabBar(
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
              fixedColor:Color(0xff2d535f),
              badgeColor:Colors.red
          )
        ),
      )
    );
  }

  void _pageChange(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

}
