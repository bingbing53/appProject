import 'dart:io';

import 'package:estate/common/common.dart';
import 'package:estate/common/component_index.dart';
import 'package:estate/data/api/apis.dart';
import 'package:estate/data/net/dio_util.dart';

class EstateRepository {

  //获取文章详情
  Future<WorkArticleModel> getWorkArticleVideoDetail(String id) async{
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil().request<Map<String, dynamic>>(
        Method.get, WanAndroidApi.WORK_ARTICLE_DETAIL + id);
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    WorkArticleModel workArticleModel;
    if (baseResp.data != null) {
      workArticleModel = WorkArticleModel.fromJson2(baseResp.data['article']);
    }
    return workArticleModel;
  }

  //版本更新
  Future<VersionModel> getVersion(String platform) async{
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request<Map<String,dynamic>>(
        Method.get, WanAndroidApi.APP_VERSION,data:{'platform':platform});
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    VersionModel versionModel;
    if (baseResp.data != null) {
      versionModel = VersionModel.fromJson(baseResp.data);
    }
    return versionModel;
  }

  //获取订单编号获取消息历史
  Future<List<MessageHistoryModel>> getMessageDataHisotry(String orderId) async{
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request(Method.get, WanAndroidApi.ORDER_MESSAGE_LIST,
    data: {"orderId":orderId});

    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    List<MessageHistoryModel> historyModels;
    if (baseResp.data != null) {
      PageData pageData = PageData.fromJson(baseResp.data);
      historyModels = pageData.records.map((value){
        return MessageHistoryModel.fromJson(value);
      }).toList();
    }
    return historyModels;
  }

  //获取我自己的信息
  Future<SysUserModel> getMineInfoData() async{
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request(Method.get, WanAndroidApi.USER_INFOS);

    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    SysUserModel sysUserModel;
    if (baseResp.data != null) {
      sysUserModel = SysUserModel.fromJson(baseResp.data);
    }
    return sysUserModel;
  }

  //获取员工订单自己的时间安排表
  Future<List<TimeScheduleModel>> getMineOrderTimeSchedule() async{
    BaseResp<List> baseResp = await DioUtil().request(Method.get, WanAndroidApi.USER_TIME_MINELIST);
    List<TimeScheduleModel> timeSchedules;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      timeSchedules = baseResp.data.map((value){
        return TimeScheduleModel.fromJson(value);
      }).toList();
    }
    return timeSchedules;
  }

  //获取员工时间安排表
  Future<List<TimeScheduleModel>> getTimeSchedule(String userId) async{
    BaseResp<List> baseResp = await DioUtil().request(Method.get, WanAndroidApi.USER_TIME_SCHEDULE,data: {"userId":userId});
    List<TimeScheduleModel> timeSchedules;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      timeSchedules = baseResp.data.map((value){
        return TimeScheduleModel.fromJson(value);
      }).toList();
    }
    return timeSchedules;
  }

  //upload image
  Future<String> uploadImage(File file) async{
    BaseResp<Map<String,Object>> baseResp = await DioUtil().requestFile<Map<String,Object>>(WanAndroidApi.UPLOAD_IMAGE, file);
    print(baseResp);
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    String imagePath = baseResp.data['url'];
    print(imagePath);
    return imagePath;
  }

  Future<List<SysUserModel>> getSysUserList() async{
    BaseResp<List> baseResp = await DioUtil().request(Method.get, WanAndroidApi.USER_LIST);
    List<SysUserModel> sysUserList;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      sysUserList = baseResp.data.map((value){
        return SysUserModel.fromJson(value);
      }).toList();
    }
    return sysUserList;
  }

  //居民报事列表
  Future<List<FeedBackModel>> getFeedBackList(int pageNo) async {
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request(Method.get, WanAndroidApi.USER_FEED_BACK,
        data: {'type':'1','pageNo':pageNo});
    List<FeedBackModel> feeBackList;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      PageData pageData = PageData.fromJson(baseResp.data);
      feeBackList = pageData.records.map((value) {
        return FeedBackModel.fromJson(value);
      }).toList();
    }
    return feeBackList;
  }
  //提交居民报事
  Future<bool> postFeed(FeedBackModel fee) async {
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.POST_USER_FEED_BACK,
        data: fee.toJson());
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    return true;
  }

  //员工拒绝接单
  Future<bool> empDontTakeOrder(String orderId,des) async {
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.ORDER_EMP_DONTTAKE,
        data: {'id':orderId,'content':des});

    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    return true;
  }

  //员工修改时间
  Future<bool> changeTime(DispatchReqModel dispatchReqModel) async {
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.ORDER_CHANGE_TIME,
        data: dispatchReqModel.toJson());

    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }

    return true;
  }

  //员工接单
  Future<bool> empTakeOrder(String orderId) async {
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.ORDER_EMP_TAKE,
        data: {'id':orderId});

    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    return true;
  }

  //员工完成订单
  Future<bool> finishOrder(String orderId) async {
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.ORDER_FINISH,
        data: {'id':orderId});

    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    return true;
  }

  //客服关闭订单
  Future<bool> closeOrder(String orderId,String des) async {
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.ORDER_CLOSE,
        data: {'id':orderId,'content':des});

    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }

    return true;
  }

  //客服派单
  Future<bool> dispatch(DispatchReqModel dispatchReqModel) async {
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.ORDER_DISPATCHER,
        data: dispatchReqModel.toJson());

    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }

    return true;
  }

  //客服接单
  Future<bool> takeOrder(String orderId) async {
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.ORDER_TAKE,
        data: {'id':orderId});

    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }

    return true;
  }

  //获取订单详情
  Future<OrderModel> getOrderDetail(String orderId) async {
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request(Method.get, WanAndroidApi.ORDER_DETAIL,
        data: {'id':orderId});

    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    OrderModel orderModel;
    if(baseResp.data != null){
      orderModel = OrderModel.fromJson(baseResp.data);
    }
    return orderModel;
  }

  //获取订单列表
  Future<List<OrderModel>> getOrderList(String type,int pageNo) async {
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request(Method.get, WanAndroidApi.ORDER_LIST,
      data: {'type':type,'pageNo':pageNo});
    List<OrderModel> orderList;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      PageData pageData = PageData.fromJson(baseResp.data);
      orderList = pageData.records.map((value) {
        return OrderModel.fromJson(value);
      }).toList();
    }

    print('$type $pageNo -- ${orderList.length}');

    return orderList;
   }

  //获取设备列表
  Future<List<DeviceModel>> getDeviceList() async {
    BaseResp<List> baseResp = await DioUtil().request(Method.get, WanAndroidApi.DEVICE_LIST);
    List<DeviceModel> deviceList;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      deviceList = baseResp.data.map((value) {
        return DeviceModel.fromJson(value);
      }).toList();
    }

    return deviceList;
  }
  //开门
  Future openDoor(String id) async{
    await DioUtil().request(Method.post, WanAndroidApi.OPEN_DOOR+id);
  }
}
