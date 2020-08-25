import 'package:helloworld/utils/util_index.dart';

/**
 * Created with Android Studio.
 * User: 一晟
 * Date: 2019/1/5
 * Time: 下午10:20
 * email: zhu.yan@alibaba-inc.com
 * tartget: FirstPageItem
 */

import '../common/Util.dart';

class FirstPageItem {
  String id;
  String article_title;
  String create_date;
  String images;
  int hits;
  int comment;
  int praise;
  int collect;
  String create_name;
  String article_type;
  String sys_org_code;
  String article_utype;
  String create_user;
  String allow_comment;
  String departName;
  String categoryType_dictText;
  String link;
  FirstPageItem(
      {
        this.id,
        this.article_title,
        this.create_date,
        this.images,
        this.hits,
        this.create_name,
        this.article_type,
        this.sys_org_code,
        this.article_utype,
        this.create_user,
        this.allow_comment,
        this.comment,
        this.praise,
        this.collect,
        this.departName,
        this.categoryType_dictText,
        this.link
      });

  factory FirstPageItem.fromJson(Map<String, dynamic> json) {
    if(json['hits'] == null)
      json['hits'] = 0;
    return FirstPageItem(
      id: json['id'],
      article_title: json['articleTitle'],
      create_date: json['createDate'],
      images: json['images'],
      hits: json['hits'],
      create_name:json['createName'],
      article_type:json['articleType'],
      departName:json['sysOrgCode_dictText'],
      sys_org_code:json['sysOrgCode'],
      allow_comment:json['allowComment'],
      comment:json['comment']??0,
      praise:json['praise']??0,
      collect:json['collect']??0,
      categoryType_dictText:json['categoryType_dictText']??'',
      link:json['link']??''
    );
  }

  factory FirstPageItem.fromESJson(Map<String, dynamic> json) {
    if(json['hits'] == null)
      json['hits'] = 0;

    return FirstPageItem(
      id: json['id'],
      article_title: json['articleTitle'],
      create_date: json['createDate'],
      images: json['images'],
      hits: json['hits'],
      create_name:json['createName'],
      article_type:json['articleType'],
      departName:json['sysOrgCode_dictText'],
      sys_org_code:json['sysOrgCode'],
      allow_comment:json['allowComment'],
      comment:json['comment']??0,
      praise:json['praise']??0,
      collect:json['collect']??0,
      categoryType_dictText:json['categoryType_dictText']??'',
      link:json['link']??''
    );
  }

  @override
  String toString() {
    return 'FirstPageItem{id: $id,link:$link, article_title: $article_title, create_date: $create_date, images: $images, hits: $hits, create_name: $create_name, article_type: $article_type, sys_org_code: $sys_org_code, article_utype: $article_utype, create_user: $create_user, allow_comment: $allow_comment}';
  }


}