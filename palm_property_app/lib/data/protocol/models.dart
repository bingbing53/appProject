import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:estate/data/api/apis.dart';

//个人信息模块
class UserInfoModel{
  String id;
  String username;
  String realname;
  String avatar;
  String mobilePhone;
  UserInfoModel.fromJson(Map<String,dynamic> json)
      : id = json['id'],
        realname = json['realname'],
        username = json['username'],
        mobilePhone = json['phone'];


  Map<String, dynamic> toJson() => {
    'realname': realname,
    'username': username,
  };

}

//***********************************下面的无用

class CollectModel{
  String realname;
  String portrait;
  String id;

  CollectModel.fromJson(Map<String,dynamic> json)
    : realname = json['realname'],
      portrait = json['portrait'],
      id = json['id'];
}

//自定义消息模板内容
class CustomMessageModel{
  String title;
  String url;
  String thumb;
  String data;
  String image;
  String showType;
  String rid;
  String prefix;
  String action;
  CustomMessageModel.fromJson(Map<dynamic,dynamic> json)
    : title = json['title'],
      url = json['url'],
      rid = json['rid'],
      prefix = json['prefix'],
      thumb = json['thumb'],
      data = json['data'],
      showType = json['showType'],
      action = json['action'],
      image = json['image'];
}

//图片数据
class ImageFileData {
  String url;
  String title;

  ImageFileData.fromJson(Map<String,dynamic> json)
    :  url = json['url'],
       title = json['title'];
}

//个人中心统计数据
class MineCountData {
  int invest;
  int willRecord;
  int groups;
  int workHisCount;

  MineCountData.fromJson(Map<String,dynamic> json)
    : invest = json['invest'],
      willRecord = json['willRecord'],
      groups = json['groups'],
      workHisCount = json['workHisCount'];
}

//组织机构
class DepartModel{
  String id;
  String orgCode;
  String departname;
  String logo;
  int len;

  DepartModel.fromJson(Map<String,dynamic> json)
    : id = json['id'],
      orgCode = json['org_code'],
      logo = WanAndroidApi.format(json['logo']),
      departname = json['departname'],
        len = json['org_code'].length;

}

//共商共治联系人模块
class ContactUserModel extends ISuspensionBean{

  String id;
  String realname;
  String sex;
  String departname;
  String officeName;
  String portrait;
  String personType;
  String namePinyin;
  String tagIndex;
  String mobilePhone;
  bool checked = false;
  String tagSeparator;
  String browser;

  ContactUserModel.fromJson(Map<String,dynamic> json)
    : realname = json['realname'],
      sex = json['sex'],
      id = json['id'],
      departname = json['departName'],
      officeName = json['officeName']??'',
      portrait = WanAndroidApi.format(json['portrait']),
      mobilePhone = json['mobilePhone'],
      browser = json['browser'],
      personType = json['person_type'] == '1' ? '同事':(json['personType'] == '2'?'社工小组成员':'居干');

  @override
  String getSuspensionTag() => tagIndex;

  @override
  String toString() {
    return 'ContactUserModel{id: $id, realname: $realname, sex: $sex, departname: $departname, portrait: $portrait, personType: $personType, namePinyin: $namePinyin, tagIndex: $tagIndex, mobilePhone: $mobilePhone, checked: $checked}';
  }


}

//字典表模块
class DictionaryModel{
  String typecode;
  String typename;

  DictionaryModel.fromJson(Map<String,dynamic> json)
      : typecode = json['typecode'],
        typename = json['typename'];

  @override
  String toString() {
    return 'DictionaryModel{typecode: $typecode, typename: $typename}';
  }

  Map<String, dynamic> toTreeModelJson() =>
  {
    'id': typecode,
    'name':typename
  };

}

//工作通知
class WorkArticleModel{
  String id;
  String departname;
  String articleTitle;
  int hits;
  String articleType;//
  String aimageType;//图片类型
  String categoryType;//所属栏目
  List<String> images;
  DateTime createDate;

  WorkArticleModel.fromJson(Map<String,dynamic> json)
      : id = json['id'],
        departname   = json['departname'],
        articleTitle = json['article_title'],
        hits = json['hits'],
        articleType = json['article_type'],
        aimageType = json['aimage_type'],
        categoryType = json['category_type'],
        createDate = DateTime.parse(json['create_date']),
        images = getImages(json['article_type'],json['images']);

  WorkArticleModel.fromJson2(Map<String,dynamic> json)
      : id = json['id'],
        departname   = json['departname'],
        articleTitle = json['articleTitle'],
        hits = json['hits'],
        articleType = json['articleType'],
        aimageType = json['aimageType'],
        createDate = DateTime.parse(json['createDate']),
        images = getImages(json['articleType'],json['images']);

  @override
  String toString() {
    return 'WorkArticleModel{departname: $departname, articleTitle: $articleTitle, hits: $hits, articleType: $articleType, aimageType: $aimageType, categoryType: $categoryType, images: $images}';
  }

  //获取图片
  static List<String> getImages(String articleType,String images){
    List<String> image = [];
    if(articleType == '1'){
      //视频类型
      try {
        Map<String, dynamic> video = json.decode(images);
        image.add(WanAndroidApi.format(video['img'],size: 0));
        image.add(WanAndroidApi.format(video['video'],size: 0));
      }catch(err){
      }
    }else{
      //文章类型
      if(null != images && images != ''){
        List<String> splitImage = images.split(',');
        if(splitImage != null && splitImage.length > 0){
          for(var i = 0;i<splitImage.length;i++){
            image.add(WanAndroidApi.format(splitImage[i]));
          }
        }
      }
    }
    return image;
  }
}

//获取所有办公模块权限
class ModuleModel {

  String showName;
  String showIcon;
  String isWeb;
  String target;
  String code;
  String superCode;
  String version;

  ModuleModel.fromJson(Map<String,dynamic> json)
      : showName = json['showName'],
        showIcon = WanAndroidApi.format(json['showIcon'],size: 0),
        isWeb = json['isWeb'],
        target = json['target'],
        superCode = json['superCode'],
        version = json['version'],
        code = json['code'];

  @override
  String toString() {
    return 'ModuleModel{showName: $showName, showIcon: $showIcon, isWeb: $isWeb, target: $target, code: $code}';
  }
}

//办公banner图
class BannerModel {
  String title;
  String action;
  String actionContent;
  String image;

  BannerModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        action = json['action'],
        actionContent = json['actionContent'],
        image = WanAndroidApi.format(json['image'],size:0);

  Map<String, dynamic> toJson() => {
    'title': title,
    'action': action,
    'actionContent': actionContent,
    'image': image,
  };

  @override
  String toString() {
    return 'BannerModel{title: $title, action: $action, actionContent: $actionContent, image: $image}';
  }
}

class RowsData {
  int totalRow;
  bool lastPage;
  List list;
//  int pageSize;
//  int totalPage;
//  int currentPage;

  RowsData.fromJson(Map<String, dynamic> json)
      : totalRow = json['totalRow'],
        lastPage = json['lastPage'],
        list = json['list'];
//        pageSize = json['pageSize'],
//        totalPage = json['totalPage'],
//        currentPage = json['currentPage'];
}







class ComData {
  int size;
  List datas;

  ComData.fromJson(Map<String, dynamic> json)
      : size = json['size'],
        datas = json['datas'];
}

class ComReq {
  int cid;

  ComReq(this.cid);

  ComReq.fromJson(Map<String, dynamic> json) : cid = json['cid'];

  Map<String, dynamic> toJson() => {
        'cid': cid,
      };
}

class ComListResp<T> {
  int status;
  List<T> list;

  ComListResp(this.status, this.list);
}

class ReposModel {
  int id;
  String title;
  String desc;
  String author;
  String link;
  String projectLink;
  String envelopePic;
  String superChapterName;
  int publishTime;
  bool collect;

  ReposModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        desc = json['desc'],
        author = json['author'],
        link = json['link'],
        projectLink = json['projectLink'],
        envelopePic = json['envelopePic'],
        superChapterName = json['superChapterName'],
        publishTime = json['publishTime'],
        collect = json['collect'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'desc': desc,
        'author': author,
        'link': link,
        'projectLink': projectLink,
        'envelopePic': envelopePic,
        'superChapterName': superChapterName,
        'publishTime': publishTime,
        'collect': collect,
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"title\":\"$title\"");
    sb.write(",\"id\":$id");
    sb.write(",\"author\":\"$author\"");
    sb.write(",\"envelopePic\":\"$envelopePic\"");
    sb.write('}');
    return sb.toString();
  }
}

class BannerModels {
  String title;
  int id;
  String url;
  String imagePath;

  BannerModels.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        id = json['id'],
        url = json['url'],
        imagePath = json['imagePath'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'id': id,
        'url': url,
        'imagePath': imagePath,
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"title\":\"$title\"");
    sb.write(",\"id\":$id");
    sb.write(",\"url\":\"$url\"");
    sb.write(",\"imagePath\":\"$imagePath\"");
    sb.write('}');
    return sb.toString();
  }
}


class TreeModel extends ISuspensionBean {
  String name;
  var id;
  List<TreeModel> children;
  String tagIndex;

  TreeModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        children = (json['children'] as List)
            ?.map((e) => e == null
                ? null
                : new TreeModel.fromJson(e as Map<String, dynamic>))
            ?.toList();

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'children': children,
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"name\":\"$name\"");
    sb.write(",\"id\":$id");
    sb.write(",\"children\":$children");
    sb.write('}');
    return sb.toString();
  }

  @override
  String getSuspensionTag() {
    return tagIndex;
  }
}

class LoginReq {
  String username;
  String password;

  LoginReq(this.username, this.password);

  LoginReq.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };

  @override
  String toString() {
    return '{' +
        " \"username\":\"" +
        username +
        "\"" +
        ", \"password\":\"" +
        password +
        "\"" +
        '}';
  }
}

class RegisterReq {
  String username;
  String password;
  String repassword;

  RegisterReq(this.username, this.password, this.repassword);

  RegisterReq.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        password = json['password'],
        repassword = json['repassword'];

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'repassword': repassword,
      };

  @override
  String toString() {
    return '{' +
        " \"username\":\"" +
        username +
        "\"" +
        ", \"password\":\"" +
        password +
        "\"" +
        ", \"repassword\":\"" +
        repassword +
        "\"" +
        '}';
  }
}
