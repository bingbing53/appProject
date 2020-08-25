import 'dart:async';

import 'package:flutter_wanandroid/db/sql.dart';

//文章浏览记录
abstract class ArticleBrowseInterface{
  int get id;
  //文章编号
  String get articleId;
  //所属账户
  String get mobile;
}

class ArticleBrowse implements ArticleBrowseInterface {
  int id;
  String articleId;
  String mobile;

  ArticleBrowse(this.articleId, this.mobile);

  ArticleBrowse.fromJSON(Map json)
      : id = json['id'],
        articleId = json['article_id'],
        mobile = json['mobile'];

  Map<String,dynamic> toMap() {
    return {
      'id': id,
      'article_id': articleId,
      'mobile': mobile
    };
  }

  Map toSqlCondition() {
    Map _map = this.toMap();
    Map condition = {};
    _map.forEach((k, value) {

      if (value != null) {

        condition[k] = value;
      }
    });

    if (condition.isEmpty) {
      return {};
    }
    return condition;
  }
}

class ArticleBrowseControlModel{
  final String table = 'article_browse';
  Sql sql;
  ArticleBrowseControlModel() {
    sql = Sql.setTable(table);
  }

  Future saveArticleBrowse(String id,String mobile) async{
    ArticleBrowse articleBrowse = new ArticleBrowse(id,mobile);
    print(sql.insert(articleBrowse.toMap()));
  }

  // 通过name获取ArticleBrowse对象信息
  Future<ArticleBrowse> getArticleBrowseByName(String mobile) async {
    List json = await sql.getByCondition(conditions: {'mobile': mobile});
    print('-----------');print(json);print('---------------');
    if (json.isEmpty) {
      return null;
    }

    return new ArticleBrowse.fromJSON(json.first);
  }

}
