import 'dart:io';

import 'package:estate/common/common.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/data/api/apis.dart';
import 'package:estate/data/net/dio_util.dart';

//任务repository
class MissionRepository {

  //删除任务附件
  Future deleteMissionFile(id) async{
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.DELETE_FILE+id);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp;
  }

  //民意详情
  Future<WillRecordModel> willRecordDetail(id) async{
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request<Map<String,dynamic>>(Method.get, WanAndroidApi.WILLRECORD_DETAIL+id);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    WillRecordModel willRecordModel;
    if(baseResp.data != null){
      willRecordModel = WillRecordModel.fromJson(baseResp.data);
    }
    return willRecordModel;
  }

  //日程详情
  Future<ScheduleModel> scheduleDetail(id) async{
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request<Map<String,dynamic>>(Method.get, WanAndroidApi.SCHEDULE_DETAIL+id);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    ScheduleModel scheduleModel;
    if (baseResp.data != null) {
      scheduleModel = ScheduleModel.fromJson(baseResp.data);
    }
    return scheduleModel;
  }

  //删除日程
  Future<BaseResp> deleteSchedule(id) async{
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.DELETE_SCHEDULE+id);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp;
  }

  //创建日程
  Future<BaseResp> createSchedule(param) async{
    print(param);
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.CREATE_SCHEDULE,data: param);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp;
  }

  //创建任务
  Future<BaseResp> createMission(param) async{
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.CREATE_MISSION,data: param);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp;
  }

  //任务列表
  Future<List<MissionModel>> getMissionList(String startTime,String endTime) async{
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.MISSION_LIST,data: {'startTime':startTime,'endTime':endTime});
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    List<MissionModel> missionModelList;
    if (baseResp.data != null) {
      missionModelList = baseResp.data.map((value) {
        return MissionModel.fromJson(value);
      }).toList();
    }
    return missionModelList;
  }
  //点击任务详情
  Future<Map<String,dynamic>> getMissionDetail(String missionId) async{
    BaseResp<Map> baseResp = await DioUtil().request<Map>(
        Method.get, WanAndroidApi.SUB_MISSION_LIST+missionId);
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }

  //任务聊天记录
  Future<List<MissionMessageModel>> getMissionMessageList(String missionId,String userId,String mine) async{
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.MISSION_MESSAGE + missionId,data: {'userId':userId,'mine':mine});
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    List<MissionMessageModel> missionMessageModelList;
    if (baseResp.data != null) {
      missionMessageModelList = baseResp.data.map((value) {
        return MissionMessageModel.fromJson(value);
      }).toList();
    }
    return missionMessageModelList;
  }

  //发送任务消息
  Future<BaseResp> sendMissionMessage(String missisonId,String message,{String type = 'text',String name=''}) async{
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.MISSION_MESSAGE + missisonId,
        data: {'name':name,'type':type,'value':message});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp;
  }

  //移交任务
  Future<BaseResp> diliverMission(String missisonId,String recieveUserId,String des) async{
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.DELIVER_MISSION + missisonId,
      data: {'recieveUserId':recieveUserId,'des':des});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp;
  }
  //上传文件
  Future<List> uploadFile(File file) async{
    BaseResp<List> baseResp = await DioUtil().requestFile<List>(WanAndroidApi.UPLOADFILE, file);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }
  //更新任务状态
  Future updateMissionState(String missionId,String state,String des) async{
    BaseResp baseResp = await DioUtil().request(Method.post,WanAndroidApi.MISSION_STATE_UPDATE + missionId,
    data: {"state":state,'des':des});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }
  //发起会议
  Future createMeeting(MeetingModelReqs meetingModel) async{
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.CREATE_MEETING,
    data: meetingModel.toJson());

    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }
  //获取会议详情
  Future<Map<String,dynamic>> getMeetingDetail(String id,String type) async{
    BaseResp<Map> baseResp = await DioUtil().request<Map>(Method.get, WanAndroidApi.MEETING_DETAIL+type+"/"+id,);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }
  //获取会议附件
  Future<List> getMeetingFileList(String id,String type) async{
    BaseResp<List> baseResp = await DioUtil().request<List>(Method.get, WanAndroidApi.MEETING_FILE+id,data: {'type':type});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }

  //获取群聊编号获取会议详情
  Future<MeetingDetailModel> getMeetingDetailByGroupId(String groupId) async{
    BaseResp<Map> baseResp = await DioUtil().request<Map>(Method.get, WanAndroidApi.GROUP_MEETING_DETAIL+"/"+groupId);
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    MeetingDetailModel detailModel;
    if (baseResp.data != null) {
      detailModel = MeetingDetailModel.fromJson(baseResp.data);
    }
    return detailModel;
  }

  //接受会议与否
  Future acceptMeeting(String id,String accept,{String reason : ''}) async{
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.MEETING_ACCEPT+id,data:{'reason':reason,'accept':accept});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }

  //根据组织机构获取联系人列表
  Future<List<ContactUserModel>> getMeetingDefaultUserList(String missionId) async{
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.WILL_MEETING_USERLIST,data: {'missionId':missionId});
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    List<ContactUserModel> contactUserModelList;
    if (baseResp.data != null) {
      contactUserModelList = baseResp.data.map((value) {
        return ContactUserModel.fromJson(value);
      }).toList();
    }
    return contactUserModelList;
  }

  //会议取消
  Future meetingCancel(String id,String reason) async{
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.MEETING_CANCEL+id,
    data: {'reason':reason});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }

  //吹哨反馈
  Future willBlowFeedBack(String id,String des) async{
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.WILLBLOW_FEEDBACK+id,
    data: {'des':des});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }

  //获取我的待办
  Future<List<MissionModel>> getMissionPrepare() async{
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.MINE_PREPARE);
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    List<MissionModel> missionModelList;
    if (baseResp.data != null) {
      missionModelList = baseResp.data.map((value) {
        return MissionModel.fromJson(value);
      }).toList();
    }
    return missionModelList;
  }

}
