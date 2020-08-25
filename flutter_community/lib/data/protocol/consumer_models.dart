
import 'package:helloworld/components/activity_page_item.dart';
import 'package:helloworld/components/first_page_item.dart';
import 'package:helloworld/data/api/apis.dart';
import 'package:helloworld/utils/util_index.dart';

/// 居民端model
///
///版本更新
class VersionModel {
  String title;
  String content;
  String url;
  String version;
  String isForce;

  VersionModel({this.title, this.content, this.url, this.version});

  VersionModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        content = json['content'],
        url = json['url'],
        isForce = json['isForce'],
        version = json['version'];

  Map<String, dynamic> toJson() => {
    'title': title,
    'content': content,
    'url': url,
    'version': version,
    'isForce':isForce
  };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"title\":\"$title\"");
    sb.write(",\"content\":\"$content\"");
    sb.write(",\"url\":\"$url\"");
    sb.write(",\"version\":\"$version\"");
    sb.write('}');
    return sb.toString();
  }
}

///轮播图
class BannersModel{
  String id;
  String image;
  BannersModel.fromJson(Map<String,dynamic> json)
    : id = json['id'],
      image = json['image'];
}
///活动搜索结果
class SearchActivityResultListModal{
  List<ActivityPageItem> data;
  SearchActivityResultListModal(this.data);
  factory SearchActivityResultListModal.fromActivityJson(List json) {
    return SearchActivityResultListModal(json.map((i) => ActivityPageItem.fromESJson(i)).toList());
  }
}
///文章搜索结果
class SearchArticleResultListModal {
  List<FirstPageItem> data;
  SearchArticleResultListModal(this.data);
  factory SearchArticleResultListModal.fromArticleJson(List json) {
    return SearchArticleResultListModal(json.map((i) => FirstPageItem.fromESJson(i)).toList());
  }
}
///商品搜索结果
class SearchResultListModal {
  List<MallProdcutInfoModel> mallData;
  SearchResultListModal(this.mallData);
  factory SearchResultListModal.fromMallJson(List json) {
    return SearchResultListModal(json.map((i) => MallProdcutInfoModel.fromJson(i)).toList());
  }
}

///商品列表详情
class MallProdcutInfoModel{
  int id;
  String name;
  double price;
  String pic;
  int goodReviewRatio;
  String subTitle;
  var productAttributeCategoryId;
  String productCategoryCode;
  String companyName;
  String sysCompanyCode;
  String sysOrgCode;
  var distance;
  List<CouponModel> coupon;
  var coin;
  MallProdcutInfoModel.fromJson(Map<String,dynamic> json)
    : id = json['id'],
      name=json['name'],
      price=json['price'],
      pic=json['pic'],
      subTitle=json['subTitle'],
      productAttributeCategoryId=json['productAttributeCategoryId'],
      productCategoryCode = json['productCategoryCode'],
      companyName = json['companyName'],
      sysCompanyCode = json['sysCompanyCode'],
      sysOrgCode = json['sysOrgCode'],
      distance = formatDistance(json['distance']),
      goodReviewRatio=json['goodReviewRatio']??100,
      coin=json['coin'],
      coupon = CouponModel.fromJsonList(json['smsCouponValueList']);

  static String formatDistance(distance){
    if(distance == null) return "";
    if(distance < 1) return '${(distance * 1000).toStringAsFixed(0)}米';
    else return '${distance.toStringAsFixed(1)}公里';
  }

}

//优惠券
class CouponModel{
  int id;
  String smsCouponName;
  var smsCouponEndTime;
  CouponModel.fromJson(Map<String,dynamic> json)
  : id = json['id'],
    smsCouponName = json['smsCouponName'],
    smsCouponEndTime = json['smsCouponEndTime'];

  static List<CouponModel> fromJsonList(List json){
    if(json == null || json.length <= 0) return [];
    List<CouponModel> couponModels = [];
    for(var i = 0;i<json.length;i++){
      if(json[i]['smsCouponEndTime'] != null && json[i]['smsCouponEndTime'] != ''){
        String endTime = json[i]['smsCouponEndTime'];
        String startTime = json[i]['smsCouponStartTime'];
        DateTime endTimeDate = DateUtil.getDateTime(endTime);
        DateTime startTimeDate = DateUtil.getDateTime(startTime);
        if(endTimeDate.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch && startTimeDate.millisecondsSinceEpoch <= DateTime.now().millisecondsSinceEpoch){
          couponModels.add(CouponModel.fromJson(json[i]));
        }
      }
    }
    return couponModels;
  }
}
///支付宝支付
class AliPayInfoModel{
  String appid;
  String partnerid;
  String prepayId;
  String package;
  String nonceStr;
  int time;
  String sign;

  AliPayInfoModel.fromJson(Map<String,dynamic> json)
      : appid = json['appId'],
        partnerid = json['partnerId'],
        prepayId = json['prepayId'],
        package = json['packageStr'],
        nonceStr = json['nonceStr'],
        time = int.parse(json['timeStamp']??'0'),
        sign = json['sign'];
}
///微信支付
class WxPayInfoModel{
  String appid;
  String partnerid;
  String prepayId;
  String package;
  String nonceStr;
  int time;
  String sign;

  WxPayInfoModel.fromJson(Map<String,dynamic> json)
    : appid = json['appId'],
      partnerid = json['partnerId'],
      prepayId = json['prepayId'],
      package = json['packageStr'],
      nonceStr = json['nonceStr'],
      time = int.parse(json['timeStamp']??'0'),
      sign = json['sign'];
}
///文章列表
class ArticleModel{
  String id;
  String title;
  String des;
  String link;
  String outside;
  int hits;
  int praise;
  int comment;
  int collect;
  String articleType;
  String imageType;
  String images;
  String ontop;
  String createTime;
  String allowComment;

  ArticleModel.fromJson(Map<String,dynamic> json)
    : id = json['id'],
      title = json['articleTitle']??'',
      des = json['articleDes']??'',
      link = json['link'],
      outside = json['outside'],
      hits = json['hits'],
      praise = json['praise'],
      comment = json['comment'],
      collect = json['collect'],
      articleType = json['articleType'],
      imageType = json['aimageType'],
      ontop = json['ontop'],
      createTime = json['createDate'];

}
///
///蓝牙设备权限列表
class BluePermissModel{
  String id;
  String devSn;
  String devMac;
  int devType;
  String eKey;

  BluePermissModel.fromJson(Map<String,dynamic> json)
    : id = json['id'],
      devSn = json['devSn'],
      devMac = json['devMac'],
      devType = json['devType'],
      eKey = json['ekey'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'devSn': devSn,
      'devMac': devMac,
      'devType': devType,
      'eKey':eKey,
    };
  }

}

///访客临时密码
class VisitorTempPwd{
  String id;
  String appAccount;
  String memo;
  String startDatetime;
  String endDatetime;
  String tempPwd;
  int useCount;
  String createTime;
  String mobile;
  List<String> devSnList;
  String devName;

  VisitorTempPwd();

  VisitorTempPwd.fromJson(Map<String,dynamic> json)
      : id = json['id'],
        appAccount = json['appAccount'],
        memo = json['memo'],
        mobile = json['mobile'],
        startDatetime = json['startDatetime'],
        endDatetime = json['endDatetime'],
        tempPwd = json['tempPwd'],
        useCount = json['useCount'],
        createTime = json['createTime'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appAccount': appAccount,
      'memo': memo,
      'mobile': mobile,
      'startDatetime':startDatetime,
      'endDatetime':endDatetime,
      'tempPwd':tempPwd,
      'useCount':useCount,
      'devSnList':devSnList
    };
  }

}

///门禁实体
class DeviceModel{
  String id;
  String name;
  String code;
  String state;

  DeviceModel.fromJson(Map<String,dynamic> json)
    : id = json['id'],
      name = json['name'],
      code = json['code'],
      state = json['state'];
}

///需要更新的固定信息
class StaticInfo{
  String sysOrgCode;//社区编码
  String departName;//社区名称
  String villageName;//小区名称
}
///部门信息
class SysDepartModel{
  String id;
  String departName;
  String parentId;
  String orgCode;
  String orgType;
  String mobile;
  String address;
  int departType;
  int departTypeCategory;
  String logo;
  double distance;

  SysDepartModel.fromJson(Map<String,dynamic> json)
    : id = json['id'],
      departName = json['departNameAbbr'] ?? json['departName'],
      orgCode = json['orgCode'],
      orgType = json['orgType'],
      mobile = json['mobile'],
      address = json['address'],
      departType = json['departType'],
      departTypeCategory = json['departTypeCategory'],
      logo = json['logo'],
      distance = json['distance'];

}

//基础信息
class BaseUserInfoModel{
  String id;
  String headImage;
  String mobile;
  String realname;
  String address;
  String nickName;
  String idcard;
  double duration;
  double points;
  String sysOrgCode;

  BaseUserInfoModel.fromJson(Map<String,dynamic> json)
      : headImage = ShequejiaApi.format(json['headImage']??'',size: 1),
        mobile = json['mobile'],
        idcard = json['idcard'],
        address = json['address'],
        nickName = json['nickName'],
        realname = json['realname'],
        duration = json['duration'],
        points = json['points'];

  Map<String, dynamic> toDBJson() {
    return {
      'id': id,
      'mobile': mobile,
      'head_path': headImage,
      'realname':realname,
      'address':address,
      'nick_name':nickName,
      'idcard':idcard,
      'sys_org_code':sysOrgCode,
      'duration':duration,
      'points':points
    };
  }
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


/// 居民个人信息
class ConsumerUserInfoModel{
    WechatInfoModel wechatInfo;
    BaseUserInfoModel baseUserInfo;
    WelfareInfoModel welfareInfo;

    ConsumerUserInfoModel.fromJson(Map<String,dynamic> json)
    : wechatInfo = WechatInfoModel.fromJson(json['wechat']??''),
      baseUserInfo = BaseUserInfoModel.fromJson(json['baseuser']??''),
      welfareInfo = WelfareInfoModel.fromJson(json['welfare']??'');
}
//微信信息
class WechatInfoModel{
  String headImg;
  String nickName;

  WechatInfoModel.fromJson(Map<String,dynamic> json)
  : headImg = json['headImg']??'',
    nickName = json['nickName'];

}

//公益信息
class WelfareInfoModel{
  String points;
  String allPoints;
  String lastActive;
  String level;
  String inDate;

  WelfareInfoModel.fromJson(Map<String,dynamic> json)
  :   points = json['points'],
      allPoints = json['allPoints'],
      lastActive = json['lastActive'],
      level = json['level'],
      inDate = json['inDate'];
}