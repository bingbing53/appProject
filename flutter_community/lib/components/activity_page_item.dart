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

class ActivityPageItem {
  String id;
  String title;
  String poster_url;
  String end_time;
  String summary;
  String isEnd;
  String isFull;
  String isHot;
  String activity_state;
  String activity_type;
  String activityTypeName = '';
  double timeLong;
  String is_small;
  String commName;
  String location;
  String sysOrgCode;
  String departType;
  String smsCoupon;
  ActivityPageItem(
      {
        this.id,
        this.title,
        this.poster_url,
        this.end_time,
        this.summary,
        this.isEnd,
        this.isFull,
        this.isHot,
        this.activity_state,
        this.activity_type,
        this.activityTypeName,
        this.timeLong,
        this.is_small,
        this.commName,
        this.location,
        this.sysOrgCode,
        this.departType,
        this.smsCoupon
      });

  factory ActivityPageItem.fromJson(Map<String, dynamic> json) {
    return ActivityPageItem(
      id: json['id'],
        title: json['title'],
        poster_url: json['posterUrl'],
        end_time: json['endTime'],
        summary: json['summary'],
        isEnd: json['isEnd'],
        isFull: json['isFull'],
        isHot: json['isHot'],
        activity_state: json['activityState'],
        timeLong: json['timeLong']??0.0,
        activity_type: json['activityType']??'',
        activityTypeName: json['activityType_dictText']??'',
        is_small: json['isSmall'],
        commName: json['sysOrgCode_dictText']??'',
        location: json['location'],
        sysOrgCode: json['sysOrgCode'],
        departType: json['departType'],
        smsCoupon: json['smsCoupon']??''
    );
  }

  factory ActivityPageItem.fromESJson(Map<String, dynamic> json) {
    return ActivityPageItem(
        id: json['id'],
        title: json['title'],
        poster_url: json['posterUrl'],
        end_time: json['endTime'],
        summary: json['summary'],
        isEnd: json['isEnd'],
        isFull: json['isFull'],
        isHot: json['isHot'],
        activity_state: json['activityState'],
        timeLong: json['timeLong']??0.0,
        activity_type: json['activityType']??'',
        activityTypeName: json['activityType_dictText']??'',
        is_small: '${json['isSmall']}',
        commName: json['sysOrgCode_dictText']??'',
        location: json['location'],
        sysOrgCode: json['sysOrgCode'],
        departType: json['departType'],
        smsCoupon: json['smsCoupon']??''
    );
  }

}