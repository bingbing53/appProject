
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/data/protocol/mission_models.dart';
import 'package:estate/data/repository/mission_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:estate/event/event-bus.dart';
import 'package:estate/ui/dialog/simple_dialog.dart';

import 'bloc_index.dart';

//任务bloc
class MissionBloc implements BlocBase{

  MissionRepository missionRepository = new MissionRepository();

  ///***********************  日程列表
  BehaviorSubject<Map> _missionDetailRepos =  BehaviorSubject<Map>();

  Sink<Map> get _moduleDetailSink => _missionDetailRepos.sink;

  Stream<Map> get moduleDetailReposStream => _missionDetailRepos.stream;
  ///***********************  日程列表
  ///***********************  任务聊天记录
  BehaviorSubject<List<MissionMessageModel>> _missionMessageRepos =  BehaviorSubject<List<MissionMessageModel>>();

  Sink<List<MissionMessageModel>> get _moduleMessageSink => _missionMessageRepos.sink;

  Stream<List<MissionMessageModel>> get moduleMessageReposStream => _missionMessageRepos.stream;
  ///***********************  任务聊天记录

  ///***********************  任务聊天记录
  BehaviorSubject<ScheduleModel> _scheduleRepos =  BehaviorSubject<ScheduleModel>();

  Sink<ScheduleModel> get _scheduleSink => _scheduleRepos.sink;

  Stream<ScheduleModel> get scheduleReposStream => _scheduleRepos.stream;
  ///***********************  任务聊天记录

  ///***********************  民意记录详情
  BehaviorSubject<WillRecordModel> _willRecordModelRepos =  BehaviorSubject<WillRecordModel>();

  Sink<WillRecordModel> get _willRecordModelReposSink => _willRecordModelRepos.sink;

  Stream<WillRecordModel> get willRecordModelReposStream => _willRecordModelRepos.stream;
  ///***********************  民意记录详情
  ///***********************  会议详情
  BehaviorSubject<Map<String,dynamic>> _meetingRepos =  BehaviorSubject<Map<String,dynamic>>();

  Sink<Map<String,dynamic>> get _meetingReposSink => _meetingRepos.sink;

  Stream<Map<String,dynamic>> get meetingStream => _meetingRepos.stream;
  ///***********************  会议详情
  ///***********************  群聊会议详情
  BehaviorSubject<MeetingDetailModel> _meetingDetailRepos =  BehaviorSubject<MeetingDetailModel>();

  Sink<MeetingDetailModel> get _meetingDetailReposSink => _meetingDetailRepos.sink;

  Stream<MeetingDetailModel> get meetingDetailStream => _meetingDetailRepos.stream;
  ///***********************  会议详情
  ///***********************  会议附件列表
  BehaviorSubject<List> _meetingFileRepos =  BehaviorSubject<List>();
  Sink<List> get _meetingFileReposSink => _meetingFileRepos.sink;
  Stream<List> get meetingFileStream => _meetingFileRepos.stream;
  ///***********************  会议附件列表
  ///***********************  我的待办
  BehaviorSubject<List<MissionModel>> _prepareRepos =  BehaviorSubject<List<MissionModel>>();

  Sink<List<MissionModel>> get _prepareReposSink => _prepareRepos.sink;

  Stream<List<MissionModel>> get prepareStream => _prepareRepos.stream;
  ///***********************  我的待办
  MissionBloc() {
    LogUtil.e("MissionBloc......");
  }
  @override
  void dispose() {
  }

  @override
  Future getData({String labelId, int page}) {
    return null;
  }

  @override
  Future onLoadMore({String labelId}) {
    return null;
  }

  @override
  Future onRefresh({String labelId}) {
    return null;
  }

  //我的待办
  Future getMissionPrepare() async{
    missionRepository.getMissionPrepare().then((result){
      _prepareReposSink.add(result);
    });
  }

  //民意反馈
  Future willBlowFeedBack(String id,String res) async{
    await missionRepository.willBlowFeedBack(id, res);
  }

  //会议取消
  Future cancelMeeting(String id,String reason) async{

    await missionRepository.meetingCancel(id, reason);

    meetingDetail(id, 'id');

  }

  //会议接受与否
  Future acceptMeeting(String id,String accept,{String reason:''}) async{
    missionRepository.acceptMeeting(id,accept,reason: reason).then((value){
      Fluttertoast.showToast(msg: '操作成功');

      meetingDetail(id,'id');

    });
  }

  //获取会议详情
  Future meetingDetail(String id,String type) async{
    missionRepository.getMeetingDetail(id, type).then((result){
      _meetingReposSink.add(result);
    });
  }

  //获取会议附件列表
  Future getMeetingFileList(String id,{String type = "id"}) async{
    missionRepository.getMeetingFileList(id,type).then((result){
      _meetingFileReposSink.add(result);
    });
  }

  //根据群聊编号获取会议详情
  Future getMeetingDetailByGroupId(String groupId) async{
    missionRepository.getMeetingDetailByGroupId(groupId).then((result){
      _meetingDetailReposSink.add(result);
    });
  }

  //发起会议
  Future startMeeting(MeetingModelReqs meetingModel) async{
    await missionRepository.createMeeting(meetingModel);
    refreshCalendar();
  }

  //获取记录详情
  Future willRecordDetail(String id) async{
    missionRepository.willRecordDetail(id).then((value){
      _willRecordModelReposSink.add(value);
    });
  }

  //日程详情
  Future scheduleDetail(String id) async{
    missionRepository.scheduleDetail(id).then((value){
      _scheduleSink.add(value);
    });
  }

  //删除日程
  Future deleteSchedule(String id) async{
    await missionRepository.deleteSchedule(id);
    refreshCalendar();
  }
  //创建日程
  Future createSchedule(ScheduleModelReqs scheduleModelReqs) async{
    await missionRepository.createSchedule(scheduleModelReqs.toJson());
    refreshCalendar();
  }

  /**
   * 修改状态
   */
  Future changeMissionState(context,MissionModel missionModel,{String close = '0'}) async{
      String content = '',state = '0';
      if(missionModel.finished == '0'){
        content = '标记任务已完成？';
        state = '1';
      }else if(missionModel.finished == '1'){
        content = '标记任务为待完成？';
        state = '0';
      }

      SimpleDialogUtil.confirmDialog(context, (){
        updateMissionState(missionModel.id,state);
      },title: '任务提示',content: content);
  }

  //吹哨办结
  Future willBlowFinish(String id,state,{String des:''}) async{
    await missionRepository.updateMissionState(id,state,des);
    refreshCalendar();
  }

  //更新任务状态
  Future updateMissionState(String id,state,{String des:''}) async{
    await missionRepository.updateMissionState(id,state,des).then((value){

      getMissionDetail(id);

      getMissionMessageList(id);

      refreshCalendar();

    }).catchError((_){
    });
  }

  /***
   * 选择文件上传
   */
  Future pickerFile(String missionId,{String mine:'',FileType type = FileType.ANY}) async {
    File file;
    if(type == FileType.IMAGE){
      file = await ImagePicker.pickImage(source: ImageSource.gallery);
    }else{
      file = await FilePicker.getFile(type: type);
    }

    missionRepository.uploadFile(file).then((list){
      if(!ObjectUtil.isEmpty(list)){
        sendMissionMessage(missionId, list[0]['url'],type: 'file_${list[0]['type']}',name: list[0]['original'],mine:mine);
      }
    }).catchError((_){
      Fluttertoast.showToast(msg: '文件上传失败，请稍后重试');
    });
  }

  //删除任务附件
  Future deleteMissionFile(String id) async{
    return missionRepository.deleteMissionFile(id);
  }

  /***
   * 转交任务
   */
  Future diliverMission(String missionId,String recieveUserId,{String des:''}) async{
    await missionRepository.diliverMission(missionId,recieveUserId,des).then((val){
      Fluttertoast.showToast(msg: '转交成功');

      refreshCalendar();
    }).catchError((_){
      Fluttertoast.showToast(msg: _.message);
    });
  }

  /**
   * 发送任务消息
   */
  Future sendMissionMessage(String missionId,String message,{String type = 'text',String name='',mine:''}){
    missionRepository.sendMissionMessage(missionId, message,type: type,name: name).then((list){
      Fluttertoast.showToast(msg: '发送成功');
      getMissionMessageList(missionId,mine:mine);
    });
  }

  /**
   * 获取任务聊天记录信息
   */
  Future getMissionMessageList(String missionId,{String userId:'',String mine:''}){
    missionRepository.getMissionMessageList(missionId,userId,mine).then((list){
      _moduleMessageSink.add(UnmodifiableListView<MissionMessageModel>(list));
    });
  }

  /***
   * 获取任务详情
   */
  Future getMissionDetail(String missionId){
    missionRepository.getMissionDetail(missionId).then((map){
      _moduleDetailSink.add(map);
    });
  }

  /***
   * 获取会议默认人员列表
   */
  Future<List<ContactUserModel>> getMeetingDefaultUserList(String missionId) async{
    return missionRepository.getMeetingDefaultUserList(missionId);
  }

  /***
   * 获取任务列表
   */
  Future<List<MissionModel>> getMineMissionList(String startTime,String endTime) async{
    return await missionRepository.getMissionList(startTime,endTime);
  }

  /**
   * 创建任务
   */
  Future createMission(MissionModelReqs missionModelReqs) async{
    await missionRepository.createMission(missionModelReqs.toJson());
    refreshCalendar();
  }

  refreshCalendar(){
    if (ApplicationEvent.event != null) {
      ApplicationEvent.event.fire(StatusEvent(StatusEventConstant.REFRESH_CALENDAR_PAGE,1));
    }
  }

}