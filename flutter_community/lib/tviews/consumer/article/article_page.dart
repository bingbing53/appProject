import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helloworld/common/list_article_view_item.dart';
import 'package:helloworld/components/list_refresh.dart' as listComp;
import 'package:helloworld/components/first_page_item.dart';
import 'package:helloworld/components/disclaimer_msg.dart';
import 'package:helloworld/data/api/consumer_apis.dart';
import 'package:helloworld/data/net/dio_util.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/tviews/consumer/article/home_page.dart';
import 'dart:convert';

import '../../../common/net_utils.dart';

GlobalKey<DisclaimerMsgState> key;

class ArticleListPage extends StatefulWidget {

  final String article_type,search;
  final String url,title,showHeader;
  final Map<String, dynamic> param;
  final Map headerItem;
  ArticleListPage(this.article_type,{this.url,this.title,this.param,this.showHeader,this.headerItem,this.search});

  @override
  ArticleListPageState createState() => new ArticleListPageState(article_type);
}

class ArticleListPageState extends State<ArticleListPage> with AutomaticKeepAliveClientMixin{

  final String article_type;
  ArticleListPageState(this.article_type);

  @override
  bool get wantKeepAlive => true;

  List<dynamic> commList = [];

  Future<Map> getIndexListData([Map<String, dynamic> params]) async {
    var pageIndex = (params is Map) ? params['pageIndex'] : 1;
    final _param  = {'pageNo':pageIndex};
    if(widget.search != null && widget.search != ''){
      _param['search'] = widget.search;
    }
    var response;

    if(widget.url != null && widget.url != ''){
      if(commList.length <= 0){
        commList = await NetUtils.get(Api.COMMLIST);
      }

      response = await NetUtils.get(widget.url, params: _param);

      var responseList = response['rows'];
      var  pageTotal = response['totalCount'] ~/ 15 + 1;
      if (!(pageTotal is int) || pageTotal <= 0) {
        pageTotal = 0;
      }
      pageIndex += 1;
      List resultList = new List();
      for (int i = 0; i < responseList.length; i++) {
        try {
          FirstPageItem cellData = new FirstPageItem.fromJson(responseList[i]);
          resultList.add(cellData);
        } catch (e) {
          print(e.toString());
          // No specified type, handles all
        }
      }
      Map<String, dynamic> result = {"list":resultList, 'total':pageTotal, 'pageIndex':pageIndex};
      return result;

    }else {
      if(widget.param != null)
        _param.addAll(widget.param);
      _param['categoryType'] = article_type;

      BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request<Map<String,dynamic>>(Method.get, ConsumerApis.ARTICLE_LIST,data: _param);
      if(baseResp.code == 200) {
        var data = baseResp.data;
        List responseList = data["records"];
        print(responseList);
        var pageTotal = data['total'] ~/ 10 + 1;
        if (!(pageTotal is int) || pageTotal <= 0) {
          pageTotal = 0;
        }
        pageIndex += 1;
        List resultList = new List();
        for (int i = 0; i < responseList.length; i++) {
          try {
            FirstPageItem cellData = new FirstPageItem.fromJson(responseList[i]);
            resultList.add(cellData);
          } catch (e) {
            print(e.toString());
            // No specified type, handles all
          }
        }
        Map<String, dynamic> result = {
          "list": resultList,
          'total': pageTotal,
          'pageIndex': pageIndex
        };

        return result;
      }
    }
  }

  Widget makeCard(index,item){
    return new ListArticleViewItem(item:item,commList: commList,);
  }

  headerView(){
    return
      Column(
        children: <Widget>[
          new HomePage(widget.headerItem)
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Column(
        children: <Widget>[
          new Expanded(
            child: widget.showHeader == '1'? listComp.ListRefresh(getIndexListData,makeCard,headerView):
            listComp.ListRefresh(getIndexListData,makeCard),
          ),
        ]
    );
  }
}


