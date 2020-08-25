import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:estate/common/component_index.dart';
import 'package:estate/data/repository/estate_repository.dart';
import 'package:estate/ui/dialog/simple_dialog.dart';

/**
 * 物业公共bloc
 */
class EstateBloc implements BlocBase {

  EstateRepository estateRepository = new EstateRepository();

  BehaviorSubject<List<DeviceModel>> _deviceCode = BehaviorSubject<List<DeviceModel>>();
  Sink<List<DeviceModel>> get _deviceCodeSink => _deviceCode.sink;
  Stream<List<DeviceModel>> get deviceCodeStream =>  _deviceCode.stream;

  //订单列表
  BehaviorSubject<List<OrderModel>> _orderCode1 = BehaviorSubject<List<OrderModel>>();
  Sink<List<OrderModel>> get _orderCodeSink1 => _orderCode1.sink;
  Stream<List<OrderModel>> get orderCodeStream1 =>  _orderCode1.stream;

  BehaviorSubject<List<OrderModel>> _orderCode2 = BehaviorSubject<List<OrderModel>>();
  Sink<List<OrderModel>> get _orderCodeSink2 => _orderCode2.sink;
  Stream<List<OrderModel>> get orderCodeStream2 =>  _orderCode2.stream;

  BehaviorSubject<List<OrderModel>> _orderCode3 = BehaviorSubject<List<OrderModel>>();
  Sink<List<OrderModel>> get _orderCodeSink3 => _orderCode3.sink;
  Stream<List<OrderModel>> get orderCodeStream3 =>  _orderCode3.stream;

  BehaviorSubject<List<OrderModel>> _orderCode4 = BehaviorSubject<List<OrderModel>>();
  Sink<List<OrderModel>> get _orderCodeSink4 => _orderCode4.sink;
  Stream<List<OrderModel>> get orderCodeStream4 =>  _orderCode4.stream;

  int order1 = 1,order2 = 1,order3 = 1,order4 = 1;
  List<OrderModel> _orderList1 = [],_orderList2 = [],_orderList3 = [],_orderList4 = [];

  //订单详情
  BehaviorSubject<OrderModel> _orderDetailCode = BehaviorSubject<OrderModel>();
  Sink<OrderModel> get _orderDetailCodeSink => _orderDetailCode.sink;
  Stream<OrderModel> get orderDetailCodeStream =>  _orderDetailCode.stream;

  ///****** ****** ****** Version ****** ****** ****** /

  BehaviorSubject<VersionModel> _version = BehaviorSubject<VersionModel>();

  Sink<VersionModel> get _versionSink => _version.sink;

  Stream<VersionModel> get versionStream => _version.stream.asBroadcastStream();

  VersionModel _versionModel;

  ///****** ****** ****** Version ****** ****** ****** /

  //报事详情
  BehaviorSubject<List<FeedBackModel>> _feedBackCode = BehaviorSubject<List<FeedBackModel>>();
  Sink<List<FeedBackModel>> get _feedBackCodeSink => _feedBackCode.sink;
  Stream<List<FeedBackModel>> get feedBackCodeStream =>  _feedBackCode.stream;
  //员工时间表
  BehaviorSubject<List<TimeScheduleModel>> _timeScheduleCode = BehaviorSubject<List<TimeScheduleModel>>();
  Sink<List<TimeScheduleModel>> get _timeScheduleCodeSink => _timeScheduleCode.sink;
  Stream<List<TimeScheduleModel>> get timeScheduleCodeStream =>  _timeScheduleCode.stream;

  int _feedBackPage = 1;
  List<FeedBackModel> _feedBackList = [];

  //用户列表List
  BehaviorSubject<List<SysUserModel>> _sysUserCode = BehaviorSubject<List<SysUserModel>>();
  Sink<List<SysUserModel>> get _sysUserCodeSink => _sysUserCode.sink;
  Stream<List<SysUserModel>> get sysUserCodeStream =>  _sysUserCode.stream;

  //消息历史List
  BehaviorSubject<List<MessageHistoryModel>> _messageHisotryCode = BehaviorSubject<List<MessageHistoryModel>>();
  Sink<List<MessageHistoryModel>> get _messageHisotryCodeSink => _messageHisotryCode.sink;
  Stream<List<MessageHistoryModel>> get messageHisotryCodeStream =>  _messageHisotryCode.stream;
  ///工作通知视频详情
  BehaviorSubject<WorkArticleModel> _articleVideoRepos =  BehaviorSubject<WorkArticleModel>();
  Sink<WorkArticleModel> get _articleVideoReposSink => _articleVideoRepos.sink;
  Stream<WorkArticleModel> get articleVideoReposStream => _articleVideoRepos.stream;
  /// 工作通知视频详情
  //
  List<TimeSelectedModel> timeSelected = [];
  StreamController<List<TimeSelectedModel>> stream = new StreamController();

  ///****** ****** ****** ****** ****** ****** /
  BehaviorSubject<StatusEvent> _homeEvent = BehaviorSubject<StatusEvent>();

  Sink<StatusEvent> get _homeEventSink => _homeEvent.sink;

  Stream<StatusEvent> get homeEventStream =>
      _homeEvent.stream.asBroadcastStream();
  
  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  Future getData({String labelId, int page}) {
    switch(labelId){
      case Ids.titleOrder1:
        return getOrderList(labelId,'0',page);
        break;
      case Ids.titleOrder2:
        return getOrderList(labelId,'1',page);
        break;
      case Ids.titleOrder3:
        return getOrderList(labelId,'2',page);
        break;
      case Ids.titleOrder4:
        return getOrderList(labelId,'3',page);
        break;
      case Ids.titleFeedBack:
        return getFeedBackList(labelId,page);
      case Ids.titleUserList:
        return getSysUserList();
      default:
        return Future.delayed(new Duration(seconds: 1));
        break;
    }
  }

  @override
  Future onLoadMore({String labelId}) {
    int page = 1;
    switch(labelId){
      case Ids.titleOrder1:
        order1++;
        page = order1;
        break;
      case Ids.titleOrder2:
        order2++;
        page = order2;
        break;
      case Ids.titleOrder3:
        order3++;
        page = order3;
        break;
      case Ids.titleOrder4:
        order4++;
        page = order4;
        break;
      case Ids.titleFeedBack:
        _feedBackPage++;
        page = _feedBackPage;
        break;
      default:
        break;
    }
    return getData(labelId: labelId, page: page);
  }

  @override
  Future onRefresh({String labelId}) {
    switch(labelId){
      case Ids.titleOrder1:
        order1 = 1;
        break;
      case Ids.titleOrder2:
        order2 = 1;
        break;
      case Ids.titleOrder3:
        order3 = 1;
        break;
      case Ids.titleOrder4:
        order4 = 1;
        break;
      case Ids.titleFeedBack:
        _feedBackPage = 1;
        break;
    }

    return getData(labelId: labelId, page: 1);
  }
  //获取文章视频详情
  Future getArticleVideoDetail(String id){
    estateRepository.getWorkArticleVideoDetail(id).then((val){
      _articleVideoReposSink.add(val);
    });
  }
  //版本更新
  Future getVersion(context) async {
    String platform = 'estate_android';
    if(Platform.isIOS){
      platform = 'estate_ios';
    }else if(Platform.isAndroid){
      platform = 'estate_android';
    }
    estateRepository.getVersion(platform).then((model) {
      _versionModel = model;
      _versionSink.add(_versionModel);
      int status = Utils.getUpdateStatus(model.version);
//      String exist = SpUtil.getString('version');
      String version_day = SpUtil.getString('version_day');
      String now = DateUtil.formatDate(DateTime.now(),format: 'yyyy-MM-dd');
      if(status != 0 && version_day != now) {
        SimpleDialogUtil.showNewVersionAppDialog(context, model, confirm: () {

        });
        SpUtil.putString('version',model.version);
        SpUtil.putString('version_day',now);
      }
    });
  }

  //获取订单聊天历史记录
  Future getOrderMessageList(String orderId){
    estateRepository.getMessageDataHisotry(orderId).then((value){
      if(value == null){
        _messageHisotryCodeSink.add([]);
      }else {
        _messageHisotryCodeSink.add(value);
      }
    }).catchError((_){
      Fluttertoast.showToast(msg:_.message);
    });
  }

  //根据订单获取用户自己的时间表
  Future getMineTimeSchedule(){
    estateRepository.getMineOrderTimeSchedule().then((value){
      _timeScheduleCodeSink.add(value);
    }).catchError((_){
      Fluttertoast.showToast(msg: _.toString());
    });
  }

  //根据用户id获取时间表
  Future getTimeSchedule(String userId){
    estateRepository.getTimeSchedule(userId).then((value){
      _timeScheduleCodeSink.add(value);
    }).catchError((_){
      Fluttertoast.showToast(msg: _.toString());
    });
  }

  Future feedBackUser(String id,String content,List<File> files) async{
    List<String> fileStr = [];
    if(files.length > 0){
      for(var i = 0;i<files.length;i++){
         String path = await uploadImage(files[i]);
         fileStr.add(path);
      }
    }

    FeedBackModel feedBackModel = new FeedBackModel(id,fileStr, content);

    estateRepository.postFeed(feedBackModel).then((value){
      Fluttertoast.showToast(msg: '提交成功');
      getFeedBackList(Ids.titleFeedBack,1);
    }).catchError((_){
      Fluttertoast.showToast(msg: '提交失败：请稍后重试');
    });

  }

  Future<String> uploadImage(file) async{
    return estateRepository.uploadImage(file);
  }

  //userList
  Future getSysUserList(){
    return estateRepository.getSysUserList().then((data){
      _sysUserCodeSink.add(data);
    }).catchError((_){
      _sysUserCode.sink.addError("error");
    });
  }

  //获取报事列表
  Future getFeedBackList(String labelId,int page){
    return estateRepository.getFeedBackList(page).then((data){
      if (_feedBackList == null) {
        _feedBackList = new List();
      }
      if (page == 1) {
        _feedBackList.clear();
      }
      _feedBackList.addAll(data);
      _feedBackCodeSink.add(UnmodifiableListView<FeedBackModel>(_feedBackList));

      _homeEventSink.add(new StatusEvent(
          labelId,
          ObjectUtil.isEmpty(data)
              ? RefreshStatus.noMore
              : RefreshStatus.idle));

    }).catchError((_){
      _feedBackCode.sink.addError("error");
      _homeEventSink.add(new StatusEvent(labelId, RefreshStatus.failed));
    });
  }

  //员工拒绝接单
  Future<bool> empDontTakeOrder(String orderId,des) async {
    return estateRepository.empDontTakeOrder(orderId,des).then((result){
      Fluttertoast.showToast(msg: '取消接单成功');
      getOrderDetail(orderId);
    }).catchError((_){
      Fluttertoast.showToast(msg: _.message);
    });
  }

  /**
   * 修改时间
   */
  Future changeTime(DispatchReqModel req){
    return estateRepository.changeTime(req).then((result){
      Fluttertoast.showToast(msg: '修改成功');
      getOrderDetail(req.orderId);
    }).catchError((_){
      Fluttertoast.showToast(msg: _.message);
    });
  }

  //员工接单
  Future<bool> empTakeOrder(String orderId) async {
     return estateRepository.empTakeOrder(orderId).then((result){
      Fluttertoast.showToast(msg: '接单成功');
      getOrderDetail(orderId);
    }).catchError((_){
      Fluttertoast.showToast(msg: _.message);
    });
  }

  /**
   *员工完成订单
   */
  Future finishOrder(String id){
    return estateRepository.finishOrder(id).then((result){
      Fluttertoast.showToast(msg: '订单完成');
      getOrderDetail(id);
    }).catchError((_){
      Fluttertoast.showToast(msg: _.message);
    });
  }

  /**
   * 客服关闭订单
   */
  Future closeOrder(String id,String des){
    return estateRepository.closeOrder(id,des).then((result){
      Fluttertoast.showToast(msg: '关闭订单成功');
      getOrderDetail(id);
    }).catchError((_){
      Fluttertoast.showToast(msg: _.message);
    });
  }

  /**
   * 客服派单
   */
  Future dispatch(DispatchReqModel req){
    return estateRepository.dispatch(req).then((result){
      Fluttertoast.showToast(msg: '派单成功');
      getOrderDetail(req.orderId);
    }).catchError((_){
      Fluttertoast.showToast(msg: _.message);
    });
  }

  /**
   * 客服接单
   */
  Future takeOrder(String id){
    return estateRepository.takeOrder(id).then((result){
      Fluttertoast.showToast(msg: '接单成功');
      getOrderDetail(id);
    }).catchError((_){
      Fluttertoast.showToast(msg: _.message);
    });
  }

  /**
   * 获取订单详情
   */
  Future getOrderDetail(String id){
    return estateRepository.getOrderDetail(id).then((result){
      _orderDetailCodeSink.add(result);
    }).catchError((_){
      Fluttertoast.showToast(msg: _.message);
    });
  }

  /**
   * 获取订单列表
   */
  Future getOrderList(String labelId,String type,int page){
    return estateRepository.getOrderList(type,page).then((data){
      Loading.close();
      if(labelId == Ids.titleOrder1) {
        if (_orderList1 == null) {
          _orderList1 = new List();
        }
        if (page == 1) {
          _orderList1.clear();
        }
        _orderList1.addAll(data);
        _orderCodeSink1.add(UnmodifiableListView<OrderModel>(_orderList1));

      }else if(labelId == Ids.titleOrder2) {
        if (_orderList2 == null) {
          _orderList2 = new List();
        }
        if (page == 1) {
          _orderList2.clear();
        }
        _orderList2.addAll(data);
        _orderCodeSink2.add(UnmodifiableListView<OrderModel>(_orderList2));
      } else if(labelId == Ids.titleOrder3) {
        if (_orderList3 == null) {
          _orderList3 = new List();
        }
        if (page == 1) {
          _orderList3.clear();
        }
        _orderList3.addAll(data);
        _orderCodeSink3.add(UnmodifiableListView<OrderModel>(_orderList3));
      }else if(labelId == Ids.titleOrder4) {
        if (_orderList4 == null) {
          _orderList4 = new List();
        }
        if (page == 1) {
          _orderList4.clear();
        }
        _orderList4.addAll(data);
        _orderCodeSink4.add(UnmodifiableListView<OrderModel>(_orderList4));
      }

      _homeEventSink.add(new StatusEvent(
          labelId,
          ObjectUtil.isEmpty(data)
              ? RefreshStatus.noMore
              : RefreshStatus.idle));
    }).catchError((_){
      if(labelId == Ids.titleOrder1)
        _orderCode1.sink.addError("error");
      else if(labelId == Ids.titleOrder2) {
        _orderCode2.sink.addError("error");
      } else if(labelId == Ids.titleOrder3) {
        _orderCode3.sink.addError("error");
      }else if(labelId == Ids.titleOrder4) {
        _orderCode4.sink.addError("error");
      }
      _homeEventSink.add(new StatusEvent(labelId, RefreshStatus.idle));
    });
  }

  /**
   * 获取设备列表
   */
  Future getDeviceList(){
    estateRepository.getDeviceList().then((data){
      _deviceCodeSink.add(UnmodifiableListView<DeviceModel>(data));
    }).catchError((_){
//      Fluttertoast.showToast(msg: "获取");
//      _deviceCodeSink.add(new StatusEvent(labelId, RefreshStatus.failed));
    });
  }

  Future openDoor(String id){
    return estateRepository.openDoor(id).then((_){
      Fluttertoast.showToast(msg: "开门成功");
    }).catchError((_){
      Fluttertoast.showToast(msg: _.message);
    });
  }

}


