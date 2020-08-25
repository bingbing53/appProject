
//任务详情

//召开会议请求
import 'package:helloworld/data/api/apis.dart';

class MeetingModelReqs{
  String persons;
  String missionId;
  String content;
  String startTime;
  String endTime;
  String location = '';
  String type = '0';
  String groupId='';

  Map<String, dynamic> toJson() => {
    'persons': persons,
    'missionId': missionId,
    'content': content,
    'startTime': startTime,
    'endTime': endTime,
    'location': location,
    'type': type,
    'groupId': groupId
  };

}

//民意详情
class WillRecordModel{
  String id;
  String departName;//部门名称
  String collectUser;//收录人
  String categoryName;//民意分类
  String createDate;//创建时间
  String title;
  String content;
  String suggest;
  String images;
  String username;
  String mobile;
  String idcard;
  String address;
  double longitude;
  double latitude;

  WillRecordModel.fromJson(Map<String,dynamic> json)
  :     id = json['id'],
        departName = json['departName'],
        collectUser = json['collectUser'],
        categoryName = json['name'],
        createDate = json['create_date'],
        title = json['title'],
        content = json['content'],
        suggest = json['suggest'],
        images = json['image']??'',
        username = json['username'],
        mobile = json['mobile'],
        idcard = json['idcard'],
        address = json['address']??''
        /*longitude = double.tryParse(json['longitude']??'0'),
        latitude = double.tryParse(json['latitude']??'0')*/;

}

//任务消息
class MissionMessageModel{
  String id;
  String missionId;
  String name;
  String des;
  String owner;
  String fileCategory;
  String portrait;
  String realname;
  String createDate;

  MissionMessageModel.fromJson(Map<String,dynamic> json)
  :   id = json['id'],
      missionId = json['mission_id'],
      name = json['name'],
      des = json['des'],
      owner = json['owner'],
      fileCategory = json['file_category'],
      portrait = ShequejiaApi.format(json['portrait']??''),
      createDate = json['create_date'],
      realname = json['realname'];
}

class MissionModel{

  String id;//任务编号
  String cType;//类型
  String createDate;//创建时间
  String missionDes;//任务描述
  String startUserId;//任务发起人
  String needTime;//截止时间
  String closed;//是否关闭
  String parendId;//上级编号
  String missionType;//任务分类
  String relatedId;//任务关联吹哨
  String state;//任务处理人状态
  String finished;//是否处理完毕
  String meetingId;//会议编号
  String startTime;//开始时间
  String endTime;//结束时间
  int start;
  int end;
  int num;
  double plused = 1;
  bool crossDay = false;

  MissionModel.fromJson(Map<String, dynamic> json)
  :   id = json['id'],
      cType = json['cType'],
      createDate = json['create_date'],
      missionDes = json['mission_des'],
      startUserId = json['start_user_id'],
      needTime = json['need_time'],
      closed = json['closed'],
      parendId = json['parend_id'],
      missionType = json['mission_type'],
      relatedId = json['related_id'],
      state = json['state'],
      finished = json['finished'],
      meetingId = json['meeting_id'],
      startTime = json['startTime'],
      endTime = json['endTime'];

  MissionModel.fromNativeJson(Map<String,dynamic> json)
  :   id = json['id'],
      createDate = json['createDate'],
      missionDes = json['missionDes'],
      needTime = json['needTime'],
      closed = json['closed'],
      parendId = json['parendId'],
      state = json['state'],
      finished = json['finished'],
      meetingId = json['meetingId'],
      startTime = json['startTime'],
      endTime = json['endTime'];

  @override
  String toString() {
    return 'MissionModel{id: $id, cType: $cType, createDate: $createDate, missionDes: $missionDes, startUserId: $startUserId, needTime: $needTime, closed: $closed, parendId: $parendId, missionType: $missionType, relatedId: $relatedId, state: $state, finished: $finished, meetingId: $meetingId, startTime: $startTime, endTime: $endTime, start: $start, end: $end, num: $num, plused: $plused}';
  }


}

//日程详情
class ScheduleModel{

  String id;
  String title;
  String des;
  String location;
  String startTime;
  String endTime;

  ScheduleModel.fromJson(Map<String, dynamic> json)
      :   id = json['id'],
          title = json['title'],
          des = json['des'],
          location = json['location'],
          startTime = json['startTime'],
          endTime = json['endTime'];

  Map<String, dynamic> toJson() => {
    'title': title,
    'id': id,
    'des': des,
    'location': location,
    'startTime': startTime,
    'endTime': endTime
  };

}


//创建日程
class ScheduleModelReqs{

  String title;
  String des;
  String location;
  String startTime;
  String endTime;

  Map<String, dynamic> toJson() => {
    'title': title,
    'des': des,
    'location': location,
    'startTime': startTime,
    'endTime': endTime
  };

}

//创建任务
class MissionModelReqs{

  String des;//任务描述
  String persons;//执行人
  String copyPersons;//抄送人
  String needTime;//截止时间
  int notify = 0;//提醒时间
  String parentId='';//上级编号
  String relatedId='';//关联编号
  String type;

  Map<String, dynamic> toJson() => {
    'des': des,
    'persons': persons,
    'copyPersons': copyPersons,
    'needTime': needTime,
    'notify': notify,
    'parentId': parentId,
    'relatedId': relatedId,
    'type': type,
  };

}