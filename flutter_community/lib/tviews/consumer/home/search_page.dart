import 'package:flutter/material.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/consumer/home/search_suggest_page.dart';
import 'package:helloworld/tviews/consumer/mall/search_goods_result_page.dart';
import 'package:helloworld/tviews/widget/gzx_search_card.dart';
import 'package:helloworld/tviews/widget/recomend.dart';
import 'package:helloworld/utils/navigator_util.dart';

class SearchPage extends StatefulWidget {
  final String keywords;

  const SearchPage({Key key, this.keywords}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List _tabsTitle = ['全部','商品','文章', '活动'];
  List recomendWords = [];
  TextEditingController _keywordsTextEditingController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  MainBloc _mainBloc;

  @override
  void initState() {
    _mainBloc = BlocProvider.of<MainBloc>(context);
    _keywordsTextEditingController.text = widget.keywords;
    if (widget.keywords != null) {
      seachTxtChanged(widget.keywords);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colours.mainBackgroundColor,
      appBar: PreferredSize(
          child: AppBar(
//              bottomOpacity: 0,
//              toolbarOpacity: 0,
            brightness: Brightness.light,
            backgroundColor: Colours.mainBackgroundColor,
            elevation: 0,
//              forceElevated: false, //是否显示阴影
          ),
          preferredSize: Size.fromHeight(0)),
      body: DefaultTabController(
          length: _tabsTitle.length,
          initialIndex: 0,
          child: Scaffold(
            resizeToAvoidBottomPadding: false,
            key: _scaffoldKey,
            body: Column(
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
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      flex: 1,
                      child: GZXSearchCardWidget(
                        elevation: 0,
//                      autofocus: widget.keywords!=null,
                        isShowSuffixIcon: true,
                        autofocus: true,
                        textEditingController: _keywordsTextEditingController,
                        isShowLeading: false,
                        onSubmitted: (value) {
                          var tab = DefaultTabController.of(_scaffoldKey.currentState.context).index - 1;
                          if(null == tab || tab <= 0) tab = 0;
                          NavigatorUtil.pushPage(context, SearchGoodsResultPage(keywords: value,defaultTab: tab,),pageName: '搜索');
                          _mainBloc.saveSearchHistory(value);
                          _keywordsTextEditingController.clear();
                          recomendWords = [];
                        },
                        onChanged: (value) {
                          seachTxtChanged(value);
                        },
//                  textEditingController: _keywordTextEditingController,
//                  focusNode: _focus,
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    GestureDetector(
                      child: Text(
                        '搜索',
                        style: TextStyle(fontSize: 13),
                      ),
                      onTap: () {
                        var tab = DefaultTabController.of(_scaffoldKey.currentState.context).index - 1;
                        if(null == tab || tab <= 0) tab = 0;
                        NavigatorUtil.pushPage(context, SearchGoodsResultPage(keywords: _keywordsTextEditingController.text,defaultTab: tab,),pageName: '搜索');
                        _mainBloc.saveSearchHistory(_keywordsTextEditingController.text);
                        _keywordsTextEditingController.clear();
                        recomendWords = [];
                      },
                    ),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),
                Expanded(
                    child: (recomendWords.length == 0
                        ? _buildContentWidget()
                        : RecomendListWidget(recomendWords, onItemTap: (value) {

                      _mainBloc.saveSearchHistory(value['name']);
                      NavigatorUtil.pushPage(context, SearchGoodsResultPage(keywords: value['name'],defaultTab: DefaultTabController.of(_scaffoldKey.currentState.context).index),pageName: '搜索');
                      _keywordsTextEditingController.clear();
                      recomendWords = [];
                    })))
              ],
            )
          )),
    );
  }

  Widget _buildContentWidget() {
    return Column(
      children: <Widget>[
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
//          labelPadding: EdgeInsets.only(left: (ScreenUtil.screenWidth-30*3)/4),
            labelPadding: EdgeInsets.only(left: 25, right: 25),
            labelStyle: TextStyle(fontSize: 12),
            onTap: (i) {
//            _selectedIndex = i;
//
//            setState(() {});
            },
            tabs: _tabsTitle
                .map((i) => Text(
                      i,
                      style: TextStyle(fontSize: 15),
                    ))
                .toList()),
        SizedBox(
          height: 8,
        ),
        Expanded(
            child: TabBarView(
          children: <Widget>[
            SearchSuggestPage(type:0),
            SearchSuggestPage(type:0),
            SearchSuggestPage(type:1),
            SearchSuggestPage(type:2),
          ],
        ))
      ],
    );
  }

  void seachTxtChanged(String q) async {
    var type = DefaultTabController.of(_scaffoldKey.currentState.context).index;
//    if(q.length <= 0){
      recomendWords = [];
//    }
//    else {
//      recomendWords = await _mainBloc.getSearchHints(q,type);
//    }
//    setState(() {});
  }
}
