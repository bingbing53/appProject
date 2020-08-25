import 'dart:async';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:helloworld/data/api/consumer_apis.dart';
import 'package:helloworld/data/net/dio_util.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/consumer/activity/index_page.dart';
import 'package:helloworld/common/net_utils.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/tviews/consumer/mine/mine_focus_page.dart';
import 'package:helloworld/tviews/consumer/survey/index_page.dart';
import 'package:helloworld/utils/util_index.dart';

import 'article_page.dart';

class _Page {
  final Widget label;
  final String labelName;
  _Page(this.labelName,this.label);
}

List<_Page> _allPages = <_Page>[];

class HeadLineIndexPage extends StatefulWidget {
  @override
  HeadLinePageState createState() => new HeadLinePageState();
}

class HeadLinePageState extends State<HeadLineIndexPage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _allPages = [];

    _allPages.add(new _Page('全部',new ArticleListPage('-998')));
    _allPages.add(new _Page('活动报名',new ActivityPage()));
    _allPages.add(new _Page('投票调查',new SurveyPage()));
    _allPages.add(new _Page('视频',new ArticleListPage('-997')));
    _allPages.add(new _Page('关注',new MineFocusPage()));

    getCateTypeList();
  }

  @override
  Widget build(BuildContext context) {
    return _allPages.length <= 4 ? SpinKitCubeGrid(size: 51.0, color: Colors.redAccent):new DefaultTabController(
        length: _allPages.length,
        child: new Scaffold(
          appBar: new MyAppBar(
            centerTitle: false,
            title: new TabLayout(),
            flexibleSpace: Image(
              image: AssetImage(Utils.getImgPath('home_top')),
              fit: BoxFit.cover,
            ),
            backgroundColor: Colors.transparent,
//            actions: <Widget>[
//              new IconButton(
//                  icon: new Icon(Icons.search),
//                  onPressed: () {
//                    showSearch(context: context,delegate: SearchBar());
//                  })
//            ],
          ),
          body: new TabBarViewLayout(),
        ));
  }

  Future getCateTypeList() async{
      if(_allPages.length > 5)
        return;

      BaseResp<List> baseResp = await DioUtil().request(Method.get, ConsumerApis.ARTICLE_CATEGORY);
      var cateType = baseResp.data;
      for(int i = 0;i<cateType.length;i++){
        _allPages.add(new _Page(cateType[i]['text'],new ArticleListPage(cateType[i]['value'])));
      }
      setState((){});
  }
}

class TabLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      isScrollable: true,
      labelPadding: EdgeInsets.all(8.0),
      indicatorSize: TabBarIndicatorSize.label,
      tabs: _allPages.map((_Page page) =>
      new Tab(text: page.labelName)).toList(),
    );
  }
}

class TabBarViewLayout extends StatelessWidget{
  Widget buildTabView(BuildContext context, _Page page) {
    return page.label;
  }

  @override
  Widget build(BuildContext context) {
    print('tabView长度 ：${_allPages.length}');
    return new TabBarView(
        children: _allPages.map((_Page page) {
          return buildTabView(context, page);
        }).toList());
  }
}

// 模拟的假数据
const searchList = [

];

const recentSuggest = [

];

class SearchBar extends SearchDelegate<String>{

  // 点击清楚的方法
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        // 点击把文本空的内容清空
        onPressed: (){
          query = "";
        },
      ),
    ];
  }

  // 点击箭头返回
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        // 使用动画效果返回
        icon: AnimatedIcons.menu_arrow,progress: transitionAnimation,
      ),
      // 点击的时候关闭页面（上下文）
      onPressed: (){
        close(context, null);
      },
    );
  }

  // 点击搜索出现结果
  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: new ArticleListPage('-998',search:query),
    );
  }

  // 搜索下拉框提示的方法
  @override
  Widget buildSuggestions(BuildContext context) {
    // 定义变量 并进行判断
    final suggestionList = query.isEmpty
        ? recentSuggest
        :searchList.where((input) => input.startsWith(query)).toList();
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context,index){
          return  ListTile(
              title:
              RichText(
                  text: TextSpan(
                    // 获取搜索框内输入的字符串，设置它的颜色并让让加粗
                      text: suggestionList[index].substring(0, query.length),
                      style: TextStyle(color: Colors.white, fontSize: Dimens.font_sp14),
                      children: [
                        TextSpan(
                          //获取剩下的字符串，并让它变成灰色
                            text: suggestionList[index].substring(query.length),
                            style: TextStyle(color: Colors.white,fontSize: Dimens.font_sp14))
                      ]
                  )
              )
          );
        }
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: Colors.white,
      fontFamily: 'NotoSansSc',
      backgroundColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
          border: UnderlineInputBorder(borderSide: BorderSide(color: Colours.divider,width: 1.0)),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colours.divider,width: 1.0)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent,width: 1.0)),
          counterStyle: TextStyle(fontSize: 0),
          hintStyle:TextStyle(color: Colours.text_gray)
      ),
      textTheme: ThemeData.light().textTheme.copyWith(
          subhead: ThemeData.light().textTheme.subhead
              .copyWith(textBaseline: TextBaseline.alphabetic)),
    );
  }
}