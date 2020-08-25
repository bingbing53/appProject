import 'package:estate/ui/pages/page_index.dart';
import 'package:estate/ui/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/ui/pages/rec_hot_page.dart';

import 'main_left_page.dart';

class _Page {
  final String labelId;

  _Page(this.labelId);
}

List<_Page> _allPages = <_Page>[
  new _Page(Ids.titleOrder1),
  new _Page(Ids.titleOrder2),
  new _Page(Ids.titleOrder3),
  new _Page(Ids.titleOrder4),
];

class HomePage extends StatelessWidget {

  final String lableId;

  const HomePage({Key key, this.lableId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LogUtil.e("MainPagess build......");

    return new DefaultTabController(
        length: _allPages.length,
        child: new Scaffold(
          appBar: new AppBar(
//            leading: new Container(
//              height: 30,
//              width: 30,
//              decoration: BoxDecoration(
//                shape: BoxShape.circle,
//                image: DecorationImage(
//                  image: AssetImage(
//                    Utils.getImgPath('chat_single'),
//                  ),
//                ),
//              ),
//            ),
          elevation: 0,
            bottom: PreferredSize(child:
                Container(
                  color: Color(0xfff6f6f6),
                  child:Column(
                    children: <Widget>[
                      Container(
                        height: 20,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 30,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(Dimens.gap_dp15))
                        ),
                        child: Center(
                          child: TabLayout(),
                        ),
                      ),
                    ],
                  )
                ),
              preferredSize: Size.fromHeight(70.0)
            ),
            centerTitle: true,
//            title: new TabLayout(),
            title: Text('我的订单'),
//            actions: <Widget>[
//              new IconButton(
//                  icon: new Icon(Icons.search),
//                  onPressed: () {
//                    NavigatorUtil.pushPage(context, new SearchPage(),
//                        pageName: "SearchPage");
//                    // NavigatorUtil.pushPage(context,  new TestPage());
//                    //  NavigatorUtil.pushPage(context,  new DemoApp());
//                  })
//            ],
          ),
          body: new TabBarViewLayout(),
//          drawer: new Drawer(
//            child: new MainLeftPage(),
//          ),
        ));
  }
}

class TabLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new TabBar(
      isScrollable: true,
      labelPadding: EdgeInsets.only(left:Dimens.gap_dp15,right: Dimens.gap_dp15),
      indicatorColor: Color(0xff5ec193),
      indicatorWeight:3,
      indicatorPadding: EdgeInsets.symmetric(horizontal: Dimens.gap_dp5),
      labelColor:Colours.app_main,
      labelStyle: TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp16,color: Color(0xff4eb885)),
      unselectedLabelColor:Colours.text_gray,
      unselectedLabelStyle: TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp16),
      indicatorSize: TabBarIndicatorSize.label,
      tabs: _allPages
          .map((_Page page) =>
      new Tab(text: IntlUtil.getString(context, page.labelId)))
          .toList(),
    );
  }
}

class TabBarViewLayout extends StatelessWidget {
  Widget buildTabView(BuildContext context, _Page page) {
    String labelId = page.labelId;
    switch (labelId) {
      case Ids.titleOrder1:
        return OrderPage(labelId: labelId);
        break;
      case Ids.titleOrder2:
        return OrderPage(labelId: labelId);
        break;
      case Ids.titleOrder3:
        return OrderPage(labelId: labelId);
        break;
      case Ids.titleOrder4:
        return OrderPage(labelId: labelId);
        break;
      case Ids.titleFeedNotFinish:
        return FeedBackPage(labelId:Ids.titleFeedNotFinish);
        break;
      case Ids.titleFeedFinished:
        return FeedBackPage(labelId:Ids.titleFeedFinished);
        break;
      default:
        return Container();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.e("TabBarViewLayout build.......");
    return new TabBarView(
        children: _allPages.map((_Page page) {
          return buildTabView(context, page);
        }).toList());
  }
}