import 'package:flutter/material.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/consumer/activity/search_activitylist_page.dart';
import 'package:helloworld/tviews/consumer/article/search_articlelist_page.dart';
import 'package:helloworld/tviews/consumer/mall/searchlist_page.dart';
import 'package:helloworld/tviews/widget/gzx_search_card.dart';
import 'package:helloworld/utils/util_index.dart';

import 'gzx_filter_goods_page.dart';

class SearchGoodsResultPage extends StatefulWidget {
  final String keywords;
  final int defaultTab;
  const SearchGoodsResultPage({Key key, this.keywords,this.defaultTab}) : super(key: key);

  @override
  _SearchGoodsResultPageState createState() => _SearchGoodsResultPageState();
}

class _SearchGoodsResultPageState extends State<SearchGoodsResultPage> {
  List _tabsTitle = ['商品', '文章', '活动'];
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  TextEditingController _keywordTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _keywordTextEditingController.text = widget.keywords;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
//        endDrawer: GZXFilterGoodsPage(),
        backgroundColor: Colours.mainBackgroundColor,
        appBar: PreferredSize(
            child: AppBar(
//              bottomOpacity: 0,
//              toolbarOpacity: 0,
              brightness: Brightness.light,
              backgroundColor:  Colours.mainBackgroundColor,
              elevation: 0,
//              forceElevated: false, //是否显示阴影
            ),
            preferredSize: Size.fromHeight(0)),
        body: DefaultTabController(
          length: 3,
          initialIndex: widget.defaultTab,
          child:
          Column(
            children: <Widget>[
              Row(
              children: <Widget>[
                SizedBox(
                width: 8,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  GZXIcons.back_light,
                  size: 20,
                ),
              ),
              Expanded(
                flex: 1,
                child:
                GZXSearchCardWidget(
                  isShowLeading: false,
                  isShowSuffixIcon: false,
                  textEditingController: _keywordTextEditingController,
                  onTap: () {
    //                NavigatorUtils.gotoSearchGoodsPage(context, keywords: widget.keywords);
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                width: 8,
              ),
//              Column(
//                children: <Widget>[
//                  Container(
//                      height: 16,
//    //                          padding: const EdgeInsets.only(left: 8,right: 8,top: 8,bottom: 8),
//                      alignment: Alignment.center,
//                      decoration: BoxDecoration(
//    //                    color: randomColor(),
//                          color: Colors.red,
//                          borderRadius: BorderRadius.circular(8)),
//                      padding: EdgeInsets.symmetric(horizontal: 4),
//                      child: Text(
//                        '20',
//                        style: TextStyle(color: Colors.white, fontSize: 10),
//                      )),
//                  Container(
//                    height: 20,
//                    child: GestureDetector(
//                      onTap: () {
//                        Navigator.pop(context);
//                      },
//                      child: Icon(
//                        Icons.more_horiz,
//                        size: 20,
//                      ),
//                    ),
//                  )
//                ],
//              ),
              SizedBox(
                width: 8,
              ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            TabBar(
    //          controller: widget.tabController,
                indicatorColor: Color(0xFFfe5100),
                indicatorSize: TabBarIndicatorSize.label,
                isScrollable: true,
    //          labelColor: KColorConstant.themeColor,
                labelColor: Color(0xFFfe5100),
                unselectedLabelColor: Colors.black,
//                labelPadding: EdgeInsets.only(left: (ScreenUtil.getScreenW(context) - 100 * 3)/3),
                labelPadding: EdgeInsets.only(left: 40, right: 40),
    //                  labelStyle: TextStyle(fontSize: 1),
                onTap: (i) {},
                tabs: _tabsTitle
                    .map((i) =>
                    Text(
                      i,
                    ))
                    .toList()),
            SizedBox(
              height: 8,
            ),
            Expanded(
                child:
                TabBarView(
                  children:
                  _tabsTitle.asMap().keys.map((f) {
                    if(f == 0) {
                      return SearchResultListPage(
                        widget.keywords,
                        isList: false,
                        isShowFilterWidget: false,
                        onTapfilter: () {
                          _scaffoldkey.currentState.openEndDrawer();
                        },
                      );
                    }else if(f == 1){
                      return SearchArticleResultListPage(
                        widget.keywords,
                        isList: true,
                        isShowFilterWidget: false,
                        onTapfilter: () {
                          _scaffoldkey.currentState.openEndDrawer();
                        },
                      );
                    }else if(f == 2){
                      return SearchActivityResultListPage(
                        widget.keywords,
                        isList: true,
                        isShowFilterWidget: false,
                        onTapfilter: () {
                          _scaffoldkey.currentState.openEndDrawer();
                        },
                      );
                    }
                  }).toList(),
//                  _tabsTitle.map((item) {
//                    return SearchResultListPage(
//                        widget.keywords,
//                        isList: true,
//                        isShowFilterWidget: true,
//                        onTapfilter: () {
//                          _scaffoldkey.currentState.openEndDrawer();
//                        },
//                      );
//                  }).toList(),
                )
            )
    ]
    ),));
  }
}
