import 'dart:convert' as JSON;
import 'package:estate/data/api/apis.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

//版本更新
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


//消息历史
class MessageHistoryModel{
  String id;
  String target_type;
  String msg_type;
  String target_id;
  String from_id;
  String from_type;
  String from_platform;
  String from_appkey;
  String target_appkey;
  Map<String,Object> msg_body;
  DateTime create_time;
  int version;
  double msgid;
  int msg_level;
  DateTime msg_ctime;
  String filePath;

  JMUserInfo fromUser;
  JMUserInfo targetUser;

  MessageHistoryModel.fromJson(Map<String,dynamic> json)
    : id = json['id'],
      target_type = json['target_type'],
      msg_type = json['msg_type'],
      target_id = json['target_id'],
      from_id = json['from_id'],
      from_type = json['from_type'],
      from_platform = json['from_platform'],
      from_appkey = json['from_appkey'],
      target_appkey = json['target_appkey'],
      msg_body = json['msg_body'],
      create_time = DateTime.fromMicrosecondsSinceEpoch(json['create_time']*1000),
      msg_ctime = DateTime.fromMicrosecondsSinceEpoch(json['msg_ctime']*1000),
      filePath = WanAndroidApi.format(json['filePath'],size: 0);
}

//客服派单请求
class DispatchReqModel{

  String orderId;
  String userId;
  List<String> times;

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'times':times,
    'userId':userId,
  };

}

//时间控件选择
class TimeSelectedModel{
  bool checked = false;
  DateTime time;
  bool enabled = true;
  int day;

  TimeSelectedModel(this.time,this.day,this.enabled,this.checked);

}

class TimeScheduleModel{
  String id;
  String userId;
  String username;
  DateTime startTime;
  DateTime endTime;
  String orderId;

  TimeScheduleModel.fromJson(Map<String,dynamic> json)
    :id = json['id'],
     userId = json['userId'],
     username = json['username'],
     startTime = DateTime.parse(json['startTime']??''),
//     endTime = DateTime.parse(json['endTime']??''),
     orderId = json['orderId'];
}

//sysuser
class SysUserModel{
  String id;
  String username;
  String realname;
  String avatar;
  int sex;
  String email;
  String phone;
  String orgCode;
  String areaCode;

  SysUserModel.fromJson(Map<String,dynamic> json)
      :id = json['id'],
       username = json['username'],
       realname = json['realname'],
       avatar = json['avatar'],
       sex = json['sex'],
       email = json['email'],
       orgCode = json['orgCode'],
       areaCode = json['areaCode'],
       phone = json['phone'];

}

class FeedBackModel{
  /**id*/
  String id;
  /**反馈内容*/
  String content;
  /**反馈图片*/
  List<String> image;
  /**反馈人编号*/
  String userId;
  DateTime inDate;
  DateTime createTime;
  /**反馈分类*/
  String feedType;
  String feedTypeDictText;
  /**反馈来源*/
  String feedOrgin;
  /**所属部门*/
  String sysOrgCode;
  /**所属公司*/
  String sysCompanyCode;
  /**所属地区*/
  String areaCode;
  /**是否处理*/
  String isHandle;

  String userName;
  String userMobile;
  String userAddress;
  FeedBackModel.fromJson(Map<String,dynamic> json)
      : id = json['id'],
        content = json['content']??'',
        image = getImages(json['image']??''),
        feedType = json['feedType']??'',
        feedTypeDictText = json['feedType_dictText'],
        feedOrgin = json['feedOrgin']??'',
        createTime = DateTime.parse(json['createTime']??''),
        isHandle = json['isHandle']??'',
        userName = json['userName']??'',
        userMobile = json['userMobile']??'',
        userAddress = json['userAddress']??'';

  FeedBackModel(this.id,this.image,this.content);

  Map<String, dynamic> toJson() => {
    'image': JSON.jsonEncode(image??[]),
    'handleDes':content,
    'feedId':id
  };

  //获取图片
  static List<String> getImages(String images){
    List<String> image = [];
    if(images != ''){
      List<String> imageArr = images.split(",");
      if(imageArr != null && imageArr.length > 0){
        for(var i = 0;i<imageArr.length;i++){
          image.add(WanAndroidApi.format(imageArr[i]));
        }
      }
    }
    return image;
  }

}

class PageData {
  int size;
  int total;
  int current;
  int pages;
  List records;

  PageData.fromJson(Map<String, dynamic> json)
      : size = json['size'],
        total = json['total'],
        current = json['current'],
        pages = json['pages'],
        records = json['records'];

}

/**
 * 订单
 */
class OrderModel{
  String id;
  /**预约类型*/
  String orderType;
  String orderTypeDictText;
  /**预约描述*/
  String content;
  /**用户id*/
  String userId;
  /**现场图片*/
  List<String> image;
  /**是否已评价*/
  String userRate;
  /**评分*/
  int judge;
  /**评价*/
  String judgeContent;
  /**物业预约服务状态 1待接单 2客服已接单 3已派单 4师傅已接单 5已结束 6 已关闭*/
  String status;
  String statusDictText;

  String userName;
  String userMobile;
  String userAddress;
  String workerName;
  String workerMobile;
  DateTime orderServiceDate;
  String isMine;
  int finishTime;
  int actFinishTime;


  OrderModel.fromJson(Map<String,dynamic> json)
      : id = json['id'],
        orderServiceDate =  DateTime.parse(json['orderServiceDate']),
        orderType = json['orderType']??'',
        orderTypeDictText = json['orderType_dictText']??'',
        content = json['content']??'',
        userId = json['userId']??'',
        image = getImages(json['image']??''),
        userRate = json['userRate']??'',
        judge = json['judge'],
        judgeContent = json['judgeContent']??'',
        status = json['status']??'',
        statusDictText = json['status_dictText']??'',
        userName = json['userName']??'',
        userMobile = json['userMobile']??'',
        userAddress = json['userAddress']??'',
        workerName = json['workerName']??'',
        isMine = json['isMine']??'0',
        finishTime = json['finishTime']??0,
        actFinishTime = json['actFinishTime']??0,
        workerMobile = json['workerMobile']??'';


  //获取图片
  static List<String> getImages(String images){
    List<String> image = [];
    if(images != ''){
      List<String> imageArr = images.split(",");
      if(imageArr != null && imageArr.length > 0){
        for(var i = 0;i<imageArr.length;i++){
          image.add(WanAndroidApi.format(imageArr[i]));
        }
      }
    }
    return image;
  }

}

/**
 * 设备
 */
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