import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:flutter_wanandroid/data/api/apis.dart';

class WelfareUserInfoModel{
  String userId;
  String realname;
  String mobile;
  String idcard;
  String polity;
  String houseNo;
  String unitNo;
  String buildingId;
  String villageId;
  String orgCode;
  String image;
  String national;
  String address;

  WelfareUserInfoModel.fromJson(Map<String,dynamic> json)
    :userId = json['userId'],
     realname = json['realname'],
     mobile = json['mobile'],
     idcard = json['idcard'],
     polity = json['polity'],
     houseNo = json['houseNo'],
     unitNo = json['unitNo'],
     buildingId = json['buildingId'],
     villageId = json['villageId'],
     orgCode = json['orgCode'],
     national = json['national'],
     image = json['image'];

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'realname': realname,
    'mobile': mobile,
    'idcard': idcard,
    'polity': polity,
    'houseNo': houseNo,
    'unitNo': unitNo,
    'buildingId': buildingId,
    'villageId': villageId,
    'orgCode': orgCode,
    'image': image,
    'nationality':national,
    'address':address
  };
}

//活动列表
class ActivityModel{
  String id;
  String title;
  String posterUrl;
  String location;
  int total;
  int register;

  ActivityModel.fromJson(Map<String,dynamic> json)
      : title = json['title'],
        total=json['total'],
        posterUrl=json['posterUrl'],
        location=json['location'],
        register=json['register'],
        id = json['id'];
}

//活动列表详情
class ActivitySignModel{
  double points;
  String realname;
  String idcard;
  String headImage;
  String signType;
  double timeLong;
  String update_date;
  String pageSize;
  String image;
  ActivitySignModel.fromJson(Map<String,dynamic> json)
      : points = json['points'],
        realname=json['realname'],
        idcard=json['idcard'],
        headImage=json['headImage'],
        signType=json['signType'],
        timeLong=json['timeLong'],
        update_date=json['update_date'],
        pageSize=json['pageSize'],
        image=json['image'];
}

//获取读取到的身份证信息
class ReadidCardModel{
  String id;
  String name;
  String sex;
  String birthday;
  String national;
  String address;
  String idcard;
  String issued;
  String startData;
  String endData;
  String image;

  String nationalName;
  String polityName;
  String polity;
  String unitNo;
  String houseNo;

  ReadidCardModel.fromJson(Map<String,dynamic> json)
      : name = json['name'],
        sex = json['sex'],
        birthday = json['birthday'],
        nationalName = json['national'],
        address = json['address'],
        idcard = json['idcard'],
        issued = json['issued'],
        startData = json['startData'],
        endData = json['endData'],
        image = json['image'];
}

//获取签到活动列表三级联动(一级社区列表)
class ThreeLevellLinkageOneModel{
  String name;
  String id;
  ThreeLevellLinkageOneModel.fromJson(Map<String,dynamic> json)
   : name = json['name'],
      id=json['id'];
}

//获取签到活动列表三级联动(二级级社区列表)
class ThreeLevellLinkageTwoModel{
  String name;
  String id;
  ThreeLevellLinkageTwoModel.fromJson(Map<String,dynamic> json)
      : name = json['name'],
        id=json['id'];
}

//获取签到活动列表三级联动(三级级社区列表)
class ThreeLevellLinkageThreeModel{
  String name;
  String id;
  ThreeLevellLinkageThreeModel.fromJson(Map<String,dynamic> json)
      : name = json['name'],
        id=json['id'];
}

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
      personType = json['person_type'] == '1' ? '同事':(json['person_type'] == '2'?'社工小组成员':'居干');

  @override
  String getSuspensionTag() => tagIndex;

  @override
  String toString() {
    return 'ContactUserModel{id: $id, realname: $realname, sex: $sex, departname: $departname, portrait: $portrait, personType: $personType, namePinyin: $namePinyin, tagIndex: $tagIndex, mobilePhone: $mobilePhone, checked: $checked}';
  }
  String getDepartName(String id){
    if(this.id==id) {
      return this.departname;
    }
  }


}

//个人信息模块
class UserInfoModel{
  String id;
  String realname;
  String email;
  String sex;
  String sexName = '';
  String birthday = '';
  String national;
  String nationalName = '';
  String eduLevel;
  String eduLevelName = '';
  String workHistory;
  String mobilePhone;
  String portrait;
  String officePhone;
  String address;
  String citizenNo;
  String memo;
  String personType;
  String polity;
  String polityName = '';
  String station;
  String startWork;
  String browser;
  String officeName;
  UserInfoModel.fromJson(Map<String,dynamic> json)
    : id = json['id'],
      realname = json['realname'],
      email = json['email'],
      sex = json['sex'],
      birthday = json['birthday'],
      national = json['national'],
      eduLevel = json['edu_level'],
      workHistory = json['work_history'],
      mobilePhone = json['mobilePhone'],
      portrait = WanAndroidApi.format(json['portrait']),
      officePhone = json['officePhone'],
      address = json['address'],
      citizenNo = json['citizen_no'],
      memo = json['memo'],
      polity = json['polity'],
      station = json['station'],
      startWork = json['startWork'],
      browser = json['browser'],
      officeName = json['officeName'],
      personType = json['personType'];

  UserInfoModel();

  Map<String, dynamic> toJson() => {
    'realname': realname,
    'officePhone': officePhone,
    'address': address,
    'memo': memo,
    'sex': sex,
    'national': national,
    'edu_level': eduLevel,
    'work_history': workHistory,
    'birthday': birthday,
    'birthday': birthday,
    'email': email,
    'polity': polity,
    'station': station,
    'startWork': startWork,
    'officeName': officeName,
    'browser': browser,
  };

  Map<String, dynamic> toJson2() => {
    'realname': realname,
    'officePhone': officePhone,
    'address': address,
    'memo': memo,
    'sex': sex,
    'national': national,
    'edu_level': eduLevel,
    'work_history': workHistory,
    'birthday': birthday,
    'birthday': birthday,
    'email': email,
    'polity': polity,
    'station': station,
    'startWork': startWork,
    'officeName': officeName,
    'browser': browser,
    'portrait': portrait,
    'mobilePhone': mobilePhone,
  };

  @override
  String toString() {
    return 'UserInfoModel{id: $id, realname: $realname, email: $email, sex: $sex, sexName: $sexName, birthday: $birthday, national: $national, nationalName: $nationalName, eduLevel: $eduLevel, eduLevelName: $eduLevelName, workHistory: $workHistory, mobilePhone: $mobilePhone, portrait: $portrait, officePhone: $officePhone, address: $address, citizenNo: $citizenNo, memo: $memo, personType: $personType}';
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
