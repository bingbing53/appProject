
import 'dart:io';

import 'package:amap_base_location/amap_base_location.dart';
import 'package:collection/collection.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/android_encoder.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:helloworld/blocs/bloc_provider.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/components/first_page_item.dart';
import 'package:helloworld/data/api/apis.dart';
import 'package:helloworld/data/net/dio_util.dart';
import 'package:helloworld/data/protocol/consumer_models.dart';
import 'package:helloworld/data/repository/consumer_repository.dart';
import 'package:helloworld/event/event-bus.dart';
import 'package:helloworld/event/event-model.dart';
import 'package:helloworld/tviews/widget/simple_dialog.dart';
import 'package:helloworld/utils/download_utils.dart';
import 'package:helloworld/utils/installapk_utils.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'package:helloworld/utils/util_index.dart';
import 'package:helloworld/utils/xpush_utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//社区e家的app key
const String kMockAppkey = '247b688324c3363a535d5bdd';
const String estateAppkey = 'eb96f1250b8f12c15f46e491';
const String officeAppkey = 'eb96f1250b8f12c15f46e491';
//final JMSingle kMockUser = JMSingle.fromJson({
//  'username': '18301166286',
//  'appKey': kMockAppkey
//});
//final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class MainBloc implements BlocBase{

  ConsumerRepository _consumerRepository = new ConsumerRepository();

  BehaviorSubject<StatusEvent> _homeEvent = BehaviorSubject<StatusEvent>();
  Sink<StatusEvent> get _homeEventSink => _homeEvent.sink;
  Stream<StatusEvent> get homeEventStream => _homeEvent.stream.asBroadcastStream();

  @override
  void dispose() {
  }

  @override
  Future getData({String labelId, int page}) {
    switch(labelId){
      case Ids.titleArticleList:
        //文章列表
        return articleList(page,'');
        break;
    }
    return null;
  }

  @override
  Future onLoadMore({String labelId,model}) {
    if(labelId == 'homePage'){
      _productListPageNo++;
      return getMallProductList(_productListPageNo);
    }
    return null;
  }

  @override
  Future onRefresh({String labelId}) {
    if(labelId == 'homePage'){
      _productListPageNo = 1;
      return getMallProductList(_productListPageNo);
    }else if(labelId == 'searchMall'){
      _totalPage = 1;
      _activitySearchPage = 1;
      _articleSearchPage = 1;
    }
    return null;
  }

  final _amapLocation = AMapLocation();
  Location _resultLocation;

  var lat,lon;
  Future<Location> getLocation() async {
    await PermissionHandler().requestPermissions([PermissionGroup.location]);
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.location);
    if (permission == PermissionStatus.granted) {
      _amapLocation.init();
      final options = LocationClientOptions(
        isOnceLocation: true,
        locatingWithReGeocode: true,
      );
      List<Location> _result = [];
      await _amapLocation.startLocate(options).map(_result.add).listen((_){
        if(_result.length > 0){
          _resultLocation = _result[0];
        }
      });
      return _resultLocation;
    } else {
//      Fluttertoast.showToast(msg: '拒绝了获取您的位置');
//      await PermissionHandler().openAppSettings();//打开应用设置
    }
    return null;
  }

  ///****** ****** ****** Version ****** ****** ****** /

  BehaviorSubject<VersionModel> _version = BehaviorSubject<VersionModel>();

  Sink<VersionModel> get _versionSink => _version.sink;

  Stream<VersionModel> get versionStream => _version.stream.asBroadcastStream();

  VersionModel _versionModel;

  ///****** ****** ****** Version ****** ****** ****** /
  //版本更新
  Future getVersion(context,{download = true}) async {
    String platform = 'jm_android';
    if(Platform.isIOS){
      platform = 'jm_ios';
    }else if(Platform.isAndroid){
      platform = 'jm_android';
    }
    _consumerRepository.getVersion(platform).then((model) {
      _versionModel = model;
      _versionSink.add(_versionModel);
      int status = Utils.getUpdateStatus(model.version);
      String version_day = SpUtil.getString('version_day');
      String version = SpUtil.getString('version');
      String now = DateUtil.formatDate(DateTime.now(),format: 'yyyy-MM-dd');
      if(status != 0 && ((version_day != now || version != model.version) || download)) {
        SimpleDialogUtil.showNewVersionAppDialog(context, model, confirm: () async {
          if(platform == 'jm_ios'){
            NavigatorUtil.launchInBrowser(_versionModel.url, title: _versionModel.title);
          }else {
            await PermissionHandler().requestPermissions([PermissionGroup.storage]);
            PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
            if (permission == PermissionStatus.granted) {

              SimpleDialogUtil.confirmDialogCustomWidget(context, (){

              },title:'下载进度',content: DownloadNewVersion(versionModel: _versionModel,));

            }else{
              Fluttertoast.showToast(msg: '没有读写设备权限');
            }
          }
        });
        SpUtil.putString('version',model.version);
        SpUtil.putString('version_day',now);
      }
    });
  }

//  Future<void> _showProgressNotification() async {
//    var maxProgress = 5;
//    for (var i = 0; i <= maxProgress; i++) {
//      await Future.delayed(Duration(seconds: 1), () async {
//        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//            'progress channel',
//            'progress channel',
//            'progress channel description',
//            channelShowBadge: false,
//            importance: Importance.Max,
//            priority: Priority.High,
//            onlyAlertOnce: true,
//            showProgress: true,
//            maxProgress: maxProgress,
//            progress: i);
//        var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//        var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//        await flutterLocalNotificationsPlugin.show(
//            0,
//            'progress notification title',
//            'progress notification body',
//            platformChannelSpecifics,
//            payload: 'item x');
//      });
//    }
//  }


  //获取我的二维码
  Future getMineQRCode() async{
//    _showProgressNotification();
    var result = await _consumerRepository.getQRCodeResult();
    return result;
  }

  //获取搜索的活动列表
  int _activitySearchPage = 1;
  Future<List> getSearchActivityList(String keywords,int page) async{
    if(page > _activitySearchPage) return [];
    var result = await _consumerRepository.getSearchESActivityResult(keywords,page);
    _activitySearchPage = result['pages'];
    return result['records'];
  }
  //获取搜索的文章列表
  int _articleSearchPage = 1;
  Future<List> getSearchArticleList(String keywords,int page) async{
    if(page > _articleSearchPage) return [];
    var result = await _consumerRepository.getSearchESArticleResult(keywords,page);
    _articleSearchPage = result['pages'];
    return result['records'];
  }

  //获取搜索提示
  Future<List> getSearchHints(String keywords,int type) async {
    var result = await _consumerRepository.getSearchHints(keywords,type,'1');
    return result['records'];
  }

  //获取搜索记录
  //获取轮播图
  BehaviorSubject<List<String>> _searchHisListData = BehaviorSubject<List<String>>();
  Sink<List<String>> get _searchHisListDataSink => _searchHisListData.sink;
  Stream<List<String>> get searchHisListDataStream => _searchHisListData.stream;
  Future<List<String>> getSearchHistory() async{
    List<String> searchHisList = await SpUtil.getStringList(SharedPreferencesKeys.searchHistory);
    _searchHisListDataSink.add(searchHisList);
  }
  Future saveSearchHistory(String keywords) async{
    if(keywords.trim().length > 0) {
      List<String> searchHisList = await SpUtil.getStringList(SharedPreferencesKeys.searchHistory);
      List<String> newHisList = [];
      if (searchHisList == null) {
        searchHisList = [];
      }
      newHisList.addAll(searchHisList);
      newHisList.remove(keywords);
      newHisList.insert(0,keywords);
      if(newHisList.length > 10){
        newHisList.removeLast();
      }
      SpUtil.putStringList(SharedPreferencesKeys.searchHistory, newHisList);
      getSearchHistory();
    }
  }

  //获取轮播图
  BehaviorSubject<List<BannersModel>> _bannersListData = BehaviorSubject<List<BannersModel>>();
  Sink<List<BannersModel>> get _bannersListDataSink => _bannersListData.sink;
  Stream<List<BannersModel>> get bannersListDataStream => _bannersListData.stream;
  Future getBannersList(String type){
    _consumerRepository.bannerList(type).then((result){
      _bannersListDataSink.add(result);
    }).catchError((_){
      _bannersListData.sink.addError(_.message);
    });
  }
  //获取商品
  List<MallProdcutInfoModel> _reposList;
  BehaviorSubject<List<MallProdcutInfoModel>> _productListData = BehaviorSubject<List<MallProdcutInfoModel>>();
  Sink<List<MallProdcutInfoModel>> get _productListDataSink => _productListData.sink;
  Stream<List<MallProdcutInfoModel>> get productListDataStream => _productListData.stream;
  int _productListPageNo = 1;//商品列表页码

  //根据关键字获取商品
  int _totalPage = 1;
  Future<List> getMallProductFromEs(String keywords,int pageNo) async{
    if(pageNo > _totalPage)
      return [];
    Location locate = await getLocation();
    var resultMap = await _consumerRepository.getSearchResult(keywords,1,pageNo,locate);
    _totalPage = resultMap['totalPage'];
    print(_totalPage);
    resultMap['list'].map((item){
      print(item);
    });
    return resultMap['list'];
  }

  int _indexMallPage = 1;
  Future getMallProductList(int page) async{
    Location locate;
    try {
      locate = await getLocation();
    }catch(err){

    }
    var resultMap = await _consumerRepository.getSearchResult('',1,page,locate);
    _indexMallPage = resultMap['totalPage'];
    if (_reposList == null) {
      _reposList = new List();
    }
    if (page == 1) {
      _reposList.clear();
    }

    List<MallProdcutInfoModel> products = [];
    for(var i = 0;i<resultMap['list'].length;i++){
      print(resultMap['list'][i]);
      products.add(MallProdcutInfoModel.fromJson(resultMap['list'][i]));
    }
    _reposList.addAll(products);
    _productListDataSink.add(UnmodifiableListView<MallProdcutInfoModel>(_reposList));
    resultMap['list'].map((item){
      print(item);
    });

//    _consumerRepository.getMallProductList(page).then((result){
//
//      _reposList.addAll(result);
//      _productListDataSink.add(UnmodifiableListView<MallProdcutInfoModel>(_reposList));
//
//    }).catchError((_){
//      _productListData.sink.addError(_.message);
//    });
  }

  //支付宝支付接口
  Future<String> aliOrderPay(String orderId) async {
    String aliPay = await _consumerRepository.aliOrderPay(orderId);
    return aliPay;
  }

  //微信支付接口
  Future<WxPayInfoModel> wechatOrderPay(String orderId) async {
    WxPayInfoModel wxPayInfoModel = await _consumerRepository.wechatOrderPay(orderId);
    return wxPayInfoModel;
  }

  //绑定组织机构
  Future bindOrg(String orgCode){
    _consumerRepository.bindOrg(orgCode).then((result){

    }).catchError((_){

    });
  }

  //获取我绑定的组织信息
  Future getMineOrg(){
    return _consumerRepository.getMineOrg();
  }

  //获取我绑定的物业信息
  BehaviorSubject<Map<String,dynamic>> _estateInfoData = BehaviorSubject<Map<String,dynamic>>();
  Sink<Map<String,dynamic>> get _estateInfoDataSink => _estateInfoData.sink;
  Stream<Map<String,dynamic>> get estateInfoDataStream => _estateInfoData.stream;
  Future bindEstateInfo(){
    _consumerRepository.bindEstateInfo().then((result){
      _estateInfoDataSink.add(result);
    }).catchError((_){

    });

    //获取文章信息
    this.estateArticleList();

  }

  //获取物业文章列表
  BehaviorSubject<List<FirstPageItem>> _estateArticleListData = BehaviorSubject<List<FirstPageItem>>();
  Sink<List<FirstPageItem>> get _estateArticleListDataSink => _estateArticleListData.sink;
  Stream<List<FirstPageItem>> get estateArticleListDataStream => _estateArticleListData.stream;
  Future estateArticleList(){
    _consumerRepository.estateArticleList().then((result){
      _estateArticleListDataSink.add(result);
    }).catchError((_){
      print(_);
      _estateArticleListData.sink.addError(_.message);
    });
  }

  //获取文章列表
  BehaviorSubject<List<ArticleModel>> _articleListData = BehaviorSubject<List<ArticleModel>>();
  Sink<List<ArticleModel>> get _articleListDataSink => _articleListData.sink;
  Stream<List<ArticleModel>> get articleListDataStream => _articleListData.stream;
  int _articleListPageNo = 0;//文章列表页码
  Future articleList(int page,String articleType){
    _consumerRepository.articleList(page,articleType).then((result){
      _articleListDataSink.add(result);
    }).catchError((_){
      _articleListData.sink.addError(_.message);
    });
  }

  //获取蓝牙设备权限列表
  Future bluePermissionList(){
    _consumerRepository.bluePermissionList().then((result){
      print("蓝牙门禁权限：$result");
        SpUtil.putObjectList(Constant.key_bluepermission, result);
    }).catchError((_){
      print("蓝牙门禁错误：${_.message}");
    });
  }

  //创建访客临时密码
  Future<VisitorTempPwd> createTempPwd(VisitorTempPwd visitor){
    return _consumerRepository.createTempPwd(visitor);
  }

  //远程开门
  Future remoteOpenDoor(String id){
    return _consumerRepository.remoteOpenDoor(id).then((result){
      Fluttertoast.showToast(msg: '开门成功');
    }).catchError((_){
      Fluttertoast.showToast(msg: '请稍后重试');
    });
  }

  //获取门禁列表
  BehaviorSubject<List<DeviceModel>> _deviceListData = BehaviorSubject<List<DeviceModel>>();
  Sink<List<DeviceModel>> get _deviceListDataSink => _deviceListData.sink;
  Stream<List<DeviceModel>> get deviceListDataStream => _deviceListData.stream;
  Future getDeviceList(){
    _consumerRepository.getDeviceList().then((result){
      _deviceListDataSink.add(result);
    });
  }

  //根据经纬度获取部门信息
  BehaviorSubject<List<SysDepartModel>> _selectDepartListData = BehaviorSubject<List<SysDepartModel>>();
  Sink<List<SysDepartModel>> get _firstSelectDepartListDataSink => _selectDepartListData.sink;
  Stream<List<SysDepartModel>> get firstSelectDepartListDataStream => _selectDepartListData.stream;
  BehaviorSubject<List<SysDepartModel>> _secondSelectDepartListData = BehaviorSubject<List<SysDepartModel>>();
  Sink<List<SysDepartModel>> get _secondSelectDepartListDataSink => _secondSelectDepartListData.sink;
  Stream<List<SysDepartModel>> get secondSelectDepartListDataStream => _secondSelectDepartListData.stream;
  BehaviorSubject<List<SysDepartModel>> _thirdSelectDepartListData = BehaviorSubject<List<SysDepartModel>>();
  Sink<List<SysDepartModel>> get _thirdSelectDepartListDataSink => _thirdSelectDepartListData.sink;
  Stream<List<SysDepartModel>> get thirdSelectDepartListDataStream => _thirdSelectDepartListData.stream;
  BehaviorSubject<List<SysDepartModel>> _forthSelectDepartListData = BehaviorSubject<List<SysDepartModel>>();
  Sink<List<SysDepartModel>> get _forthSelectDepartListDataSink => _forthSelectDepartListData.sink;
  Stream<List<SysDepartModel>> get forthSelectDepartListDataStream => _forthSelectDepartListData.stream;
  Future getDepartAreaByParentId({String parentId = '',int level}){
    if(level == 0){
      _secondSelectDepartListDataSink.add(null);
      _thirdSelectDepartListDataSink.add(null);
      _forthSelectDepartListDataSink.add(null);
    }
    _consumerRepository.getDepartByParentId(parentId:parentId).then((result){
      switch(level){
        case 0 :_firstSelectDepartListDataSink.add(result);break;
        case 1 : _secondSelectDepartListDataSink.add(result);break;
        case 2 : _thirdSelectDepartListDataSink.add(result);break;
        case 3 : _forthSelectDepartListDataSink.add(result);break;
        default:break;
      }
    });
  }

  //获取展示的固定信息
  BehaviorSubject<StaticInfo> _staticInfoData = BehaviorSubject<StaticInfo>();
  Sink<StaticInfo> get _staticInfoDataSink => _staticInfoData.sink;
  Stream<StaticInfo> get staticInfoDataStream => _staticInfoData.stream;
  Future getStaticInfo(){
    _consumerRepository.getStaticInfo().then((result){
      _staticInfoDataSink.add(result);
    });
  }

  //根据经纬度获取部门信息
  BehaviorSubject<List<SysDepartModel>> _sysDepartListData = BehaviorSubject<List<SysDepartModel>>();
  Sink<List<SysDepartModel>> get _sysDepartListDataSink => _sysDepartListData.sink;
  Stream<List<SysDepartModel>> get sysDepartListDataStream => _sysDepartListData.stream;
  Future getDepartByLonlat(double longitude,double latitude,String departType){
    _consumerRepository.getDepartByLonlat(longitude,latitude,departType).then((result){
      _sysDepartListDataSink.add(result);
    }).catchError((_){
      Fluttertoast.showToast(msg: '获取失败');
    });
  }

  //获取用户信息
  BehaviorSubject<BaseUserInfoModel> _userInfoData = BehaviorSubject<BaseUserInfoModel>();
  Sink<BaseUserInfoModel> get _userInfoDataDataSink => _userInfoData.sink;
  Stream<BaseUserInfoModel> get userInfoDataStream => _userInfoData.stream;
  Future getUserInfoFromDB() async {
    String mobile = SpUtil.getString(Constant.key_login_name, defValue: '');
    if(mobile != '' && mobile != null) {
      _consumerRepository.getUserByMobile(mobile).then((result) {
        _userInfoDataDataSink.add(result);
      }).catchError((_) {
        _userInfoData.sink.addError('error');
      });
    }
  }
  Future getUserInfo(){
    _consumerRepository.infos().then((result){
      _userInfoDataDataSink.add(result);
//      getUserInfoFromDB();
    }).catchError((err){
      _userInfoDataDataSink.add(null);
      _userInfoData.sink.addError("获取失败");
    });
  }
  //选择头像
  Future<Null> clickAvatar(type) async{
    //选择图片
    ImagePicker.pickImage(source: type).then((file){
      //裁切图片
      ImageCropper.cropImage(
        sourcePath: file.path,

        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: '图片裁剪',
            toolbarColor: Colours.app_main,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        )
      ).then((file){

        _consumerRepository.uploadImage(file).then((result){
          var headImage = result['url'];
          _consumerRepository.updateInfos(headImage).then((result){
            getUserInfo();
            jmessage.updateMyInfo(
                extras: {
                  "portrait": headImage
                }
            );
          });
        });

//        wanRepository.uploadImage(file).then((list){
//          if(list != null && list.length > 0) {
//            Fluttertoast.showToast(msg: '图片上传成功');
//
//            wanRepository.modifyUserInfo({'portrait':list[0].url}).then((n){
//              Fluttertoast.showToast(msg: '信息修改成功');
//              //获取个人基本信息
//              getMineData();
//
//              //更新极光头像
//              jmessage.updateMyInfo(gender: JMGender.female,
//                  nickname: userInfoModel.realname,
//                  extras: {
//                    "personType": userInfoModel.personType,
//                    "portrait": list[0].url /*,"userId":userInfoModel.id*/
//                  });
//
//            });
//          }
//        });
      });
    });
  }
  //保存登录信息
  Future saveLogin(Map<String,dynamic> map){
    _consumerRepository.saveLogin(map).then((value){
      getUserInfoFromDB();
    });

    this.userRegister();
  }
  //登录
  Future login(String mobile,String code,{String relateId}){
    return _consumerRepository.login(mobile, code,relateId:relateId);
  }
  //微信登录
  Future wxMpLogin(String code){
    return _consumerRepository.wxMpLogin(code);
  }
  //支付宝登录
  Future aliLogin(String code){
    return _consumerRepository.aliLogin(code);
  }
  //苹果登录
  Future appleIdLogin(String code){
    return _consumerRepository.appleIdLogin(code);
  }
  //支付宝参数生成
  Future genAliLoginParam(){
    return _consumerRepository.genAliLoginParam();
  }
  //退出登录
  Future logout(){
    SpUtil.remove(Constant.key_token_name);
    DioUtil().setCookie('');
    _consumerRepository.logout();
    ApplicationEvent.event.fire(GotoLoginEvent('login'));
//    getUserInfo();
//    return _consumerRepository.logout();
  }
  //发送验证码
  Future sendVerify(String mobile){
    return _consumerRepository.sendVerify(mobile).then((result){
      Fluttertoast.showToast(msg: '验证码发送成功');
    }).catchError((_){
      Fluttertoast.showToast(msg: _.message);
    });
  }

  ///极光推送消息
  int _reposPage = 0;
  ///****** ****** ****** 注册极光 ****** ****** ****** /
  BehaviorSubject<JmessageFlutter> _sendCode = BehaviorSubject<JmessageFlutter>();
  Sink<JmessageFlutter> get _sendCodeSink => _sendCode.sink;
  Stream<JmessageFlutter> get sendCodeStream =>  _sendCode.stream;
  ///****** ****** ****** 注册极光 ****** ****** ****** ///


  //************************获取聊天窗口的聊天记录
  BehaviorSubject<List> _historyMessage = BehaviorSubject<List>();
  Sink<List> get _historyMessageSink => _historyMessage.sink;
  Stream<List> get historyMessageStream =>  _historyMessage.stream;
  List _historyMessageList;
  //************************获取聊天窗口的聊天记录
  //************************下载聊天缩略图
  BehaviorSubject<Map> _downloadThumbImage = BehaviorSubject<Map>();
  Sink<Map> get _downloadThumbImageSink => _downloadThumbImage.sink;
  Stream<Map> get downloadThumbImageStream =>  _downloadThumbImage.stream;
  //************************下载聊天缩略图
  //************************下载聊天原图
  BehaviorSubject<Map> _downloadOriginImage = BehaviorSubject<Map>();
  Sink<Map> get _downloadOriginImageSink => _downloadOriginImage.sink;
  Stream<Map> get downloadOriginImageStream =>  _downloadOriginImage.stream;
  //************************下载聊天原图
  ///***** ****** ******获取聊天列表
  BehaviorSubject<List<JMConversationInfo>> _conversations = BehaviorSubject<List<JMConversationInfo>>();
  Sink<List<JMConversationInfo>> get _conversationsSink => _conversations.sink;
  Stream<List<JMConversationInfo>> get conversationsStream =>  _conversations.stream;
  ///***** ****** ******获取聊天列表
  ///***** ****** ******获取群成员列表
  BehaviorSubject<List<JMGroupMemberInfo>> _groupMemberList = BehaviorSubject<List<JMGroupMemberInfo>>();
  Sink<List<JMGroupMemberInfo>> get _groupMemberListSink => _groupMemberList.sink;
  Stream<List<JMGroupMemberInfo>> get groupMemberListStream =>  _groupMemberList.stream;
  ///***** ****** ******获取聊天列表
  ///
  ///***** ****** ******未读消息数
  BehaviorSubject<int> _unreadMsgCount = BehaviorSubject<int>();
  Sink<int> get _unreadMsgCountSink => _unreadMsgCount.sink;
  Stream<int> get unreadMsgCountStream =>  _unreadMsgCount.stream;
  ///***** ****** ******获取聊天列表
  JMConversationInfo _conversationInfo;//当前的聊天室
  static JmessageFlutter jmessage;

  MainBloc({jmessages}) {
    LogUtil.e("MainBloc......");
//    database = db;
    jmessage = jmessages;
  }

  FlutterSound flutterSound;

  //初始化消息
  Future initMessageHome({String labelId}){
    userRegister();
  }
  String recorderPath = '';
  //开始录音
  void startRecorder() async{
    if(flutterSound == null){
      flutterSound = new FlutterSound();
    }
    try {
      recorderPath = '${DateTime.now().millisecondsSinceEpoch}${Platform.isIOS?'.m4a':'.mp4'}';
      String path = await flutterSound.startRecorder(recorderPath,androidEncoder:AndroidEncoder.AMR_WB);
      print('startRecorder: $path');
      recorderPath = path;
    } catch (err) {
      print('startRecorder error: $err');
    }
  }
  //停止录音
  void stopRecorder() async{
    if(!flutterSound.isRecording)
      return;
    try {
      String result = await flutterSound.stopRecorder();
      print('stopRecorder: $result');
      sendVoiceMessage(recorderPath);
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }
  void cancelRecorder() async{
    if(flutterSound != null && flutterSound.isRecording)
      flutterSound.stopRecorder();
  }
  void startPlayer(String uri) async{

    if(flutterSound == null) flutterSound = new FlutterSound();

    if(flutterSound.isPlaying){
      await flutterSound.stopPlayer();
    }else {
      String path = await flutterSound.startPlayer(uri);
      await flutterSound.setVolume(1.0);

      print('startPlayer: $path');
    }

  }

  void stopPlayer() async{
    if(flutterSound.isPlaying) {
//      Fluttertoast.showToast(msg: '停止音乐');
      try {
        String result = await flutterSound.stopPlayer();
        print('stopPlayer: $result');
      } catch (err) {
        print('error: $err');
      }
    }
  }

  //发送文字消息
  Future sendMessage(_textEditController,model) async{
    if(_textEditController.text.length > 0) {
      String text = _textEditController.text;
      _textEditController.clear();
      await jiguangLogin();
      JMTextMessage msg = await jmessage.sendTextMessage(
        type: _conversationInfo.conversationType == JMConversationType.single ? getJMSingle(_conversationInfo.target.username,appkey: _conversationInfo.target.appKey):getJMGroup(_conversationInfo.target.id),
        text: text,
      );
      getHistoryMessages(model);
    }
  }
  //发送图片消息
  Future sendImageMessage(model) async{
    await jiguangLogin();
    ImagePicker.pickImage(source: ImageSource.gallery).then((file) async {
      await jmessage.sendImageMessage(
        type: _conversationInfo.conversationType == JMConversationType.single ? getJMSingle(_conversationInfo.target.username,appkey: _conversationInfo.target.appKey):getJMGroup(_conversationInfo.target.id),
        path: file.path,
      );
      resetReposPage();
      getHistoryMessages(model);
    });
  }
  //发送语音消息
  Future sendVoiceMessage(String path) async{
    await jiguangLogin();
//    if(Platform.isIOS && path.startsWith("file://")) path = path.replaceAll("file://","");
    print(path);
    jmessage.sendVoiceMessage(
      type: _conversationInfo.conversationType == JMConversationType.single ? getJMSingle(_conversationInfo.target.username,appkey: _conversationInfo.target.appKey):getJMGroup(_conversationInfo.target.id),
      path: path
    );
    resetReposPage();
    getHistoryMessages(_conversationInfo);
  }
  void resetReposPage(){
    _reposPage = 0;
  }
  //下载文件
  Future downloadFile(msgId,JMMessageType type,{String origin = '0'}) async{
    switch (type) {
      case JMMessageType.text:
        break;
      case JMMessageType.image:
        if(origin == '0')
          jmessage.downloadThumbImage(
              target: _conversationInfo.conversationType == JMConversationType.single ? getJMSingle(_conversationInfo.target.username,appkey: _conversationInfo.target.appKey):getJMGroup(_conversationInfo.target.id),
              messageId: msgId
          ).then((map){
            map.putIfAbsent('state','1' as dynamic);
//          map.putIfAbsent('type',type as dynamic);
//          map.putIfAbsent('msgId', msgId);
            print(map);
            _downloadThumbImageSink.add(map);
          }).catchError((_){

          });
        if(origin == '1')
          jmessage.downloadOriginalImage(
              target: _conversationInfo.conversationType == JMConversationType.single ? getJMSingle(_conversationInfo.target.username,appkey: _conversationInfo.target.appKey):getJMGroup(_conversationInfo.target.id),
              messageId: msgId
          ).then((map){
//          map.putIfAbsent('msgId', msgId);
//            print(map);
//            Fluttertoast.showToast(msg: '$map');
            _downloadOriginImageSink.add(map);
            print(map);
          }).catchError((_){
//            print(_);
//            Fluttertoast.showToast(msg: '$_');
          });
        break;
      case JMMessageType.voice:
        jmessage.downloadVoiceFile(
            target: _conversationInfo.conversationType == JMConversationType.single ? getJMSingle(_conversationInfo.target.username,appkey: _conversationInfo.target.appKey):getJMGroup(_conversationInfo.target.id),
            messageId: msgId
        ).then((map){
          map.putIfAbsent('state','1' as dynamic);
//          map.putIfAbsent('type',type as dynamic);
          _downloadThumbImageSink.add(map);
        }).catchError((_){

        });
        break;
      case JMMessageType.file:
        await jmessage.downloadFile(
            target: _conversationInfo.conversationType == JMConversationType.single ? getJMSingle(_conversationInfo.target.username,appkey: _conversationInfo.target.appKey):getJMGroup(_conversationInfo.target.id),
            messageId: msgId
        ).then((map){
          map.putIfAbsent('state','1' as dynamic);
//          map.putIfAbsent('type',type as dynamic);
          _downloadThumbImageSink.add(map);
        }).catchError((_){

        });
        break;
      case JMMessageType.custom:
      // TODO: Handle this case.
        break;
      case JMMessageType.location:
      // TODO: Handle this case.
        break;
      case JMMessageType.event:
      // TODO: Handle this case.
        break;
      case JMMessageType.prompt:
        // TODO: Handle this case.
        break;
    }

  }

  //注册用户
  void userRegister() async{

    registerMessage();

    BaseUserInfoModel baseUserInfoModel = await _consumerRepository.infos();
    if(baseUserInfoModel != null){
      try {
        await jmessage.userRegister(username: baseUserInfoModel.mobile,
            password: Utils.generateMd5(baseUserInfoModel.mobile),
            nickname: baseUserInfoModel.nickName);
      }catch(_){
        print(_);
      }finally {
        //存储手机号
        await jmessage.login(username: baseUserInfoModel.mobile,
            password: Utils.generateMd5(baseUserInfoModel.mobile));
        await jmessage.updateMyInfo(gender: JMGender.female,
            nickname: baseUserInfoModel.nickName,
            extras: {
              "portrait": ShequejiaApi.format(baseUserInfoModel.headImage,size:0),
            });
        addListener();
        getMessageChatList();
      }
    }

    //先通过token获取个人基本信息
//    var response = await NetUtils.get(Api.MINE_INFOS);
//    if(response != null){
//      String name = "",mobile = "",headImage = "";
//      var wechat = response['wechat']??{};
//      var baseuser = response['baseuser']??{};
//      mobile = baseuser['mobile'];
//      if(ObjectUtil.isEmpty(baseuser['realname'])){
//        name = wechat['nickName'];
//      }else{
//        name = baseuser['realname'];
//      }
//      if(ObjectUtil.isEmpty(baseuser['headImage'])){
//        headImage = wechat['headImg'];
//      }else{
//        headImage = baseuser['headImage'];
//      }
//
//      try {
//        await jmessage.userRegister(username: mobile,
//            password: Utils.generateMd5(mobile),
//            nickname: name);
//      }catch(_){
//          print(_);
//      }finally {
//        //存储手机号
//        await jmessage.login(username: mobile,
//            password: Utils.generateMd5(mobile));
//        await jmessage.updateMyInfo(gender: JMGender.female,
//            nickname: name,
//            extras: {
//              "portrait": headImage,
//            });
//        addListener();
//        getMessageChatList();
//      }
//    }
  }

  //将消息注册到后端
  Future registerMessage() async {
    String platform,pushToken;
    Map<dynamic,dynamic> map = await XPushUtils.getInfo();
    LogUtil.e(map);
    if(map != null){
      platform = map["platform"];
      pushToken = map["token"];
    }

    _consumerRepository.registerMessage(platform: platform,pushToken: pushToken).then((result){

    }).catchError((_){
      print(_);
    });
  }

  //根据username获取用户信息
  Future<JMUserInfo> getUserInfoByUsername(String username,{String appKey = kMockAppkey}) async{
    JMUserInfo user = await jmessage.getUserInfo( username: username, appKey: appKey);
    return user;
  }

  //获取未读消息数量
  Future getAllUnreadCount(){
    jmessage.getAllUnreadCount().then((num){
//      jmessage.setBadge(badge: num);
      _unreadMsgCountSink.add(num);
      if(Platform.isAndroid)
        AndroidBackTop.setBadges('$num');
    });
  }

  //创建聊天
  Future<JMConversationInfo> createConversation(String username,{String appKey = kMockAppkey}) async{
    await jmessage.getUserInfo(username: username,appKey:appKey).then((userInfo){
    }).catchError((_){
      throw '没有注册';
    });

    JMConversationInfo conversation = await jmessage.createConversation(
        target:JMSingle.fromJson({
          'username': username,
          'appKey': appKey
        })
    ).catchError((_){
    });
    return conversation;
  }
  //进入聊天
  Future enterConversation(JMConversationInfo conversationInfo,{String appkey = kMockAppkey}){
    _reposPage = 0;
    _conversationInfo = conversationInfo;
    switch(conversationInfo.conversationType){
      case JMConversationType.single:
        jmessage.enterConversation(target: getJMSingle(conversationInfo.target.username,appkey: conversationInfo.target.appKey));
        break;
      case JMConversationType.group:
        jmessage.enterConversation(target:getJMGroup(conversationInfo.target.id));
        break;
      case JMConversationType.chatRoom:
        break;
    }
  }
  //离开聊天
  Future exitConversation(JMConversationInfo conversationInfo){
    _conversationInfo = null;
    switch(conversationInfo.conversationType){
      case JMConversationType.single:
        jmessage.exitConversation(target: getJMSingle(conversationInfo.target.username,appkey: conversationInfo.target.appKey));
        break;
      case JMConversationType.group:
        jmessage.exitConversation(target:getJMGroup(conversationInfo.target.id));
        break;
      case JMConversationType.chatRoom:
        break;
    }
  }
  //删除聊天会话，同时也会删除本地聊天记录。
  Future deleteConversation(JMConversationInfo conversationInfo){
    _conversationInfo = null;
    switch(conversationInfo.conversationType){
      case JMConversationType.single:
        jmessage.deleteConversation(target: getJMSingle(conversationInfo.target.username,appkey: conversationInfo.target.appKey));
        break;
      case JMConversationType.group:
        jmessage.deleteConversation(target:getJMGroup(conversationInfo.target.id));
        break;
      case JMConversationType.chatRoom:
        jmessage.deleteConversation(target: getJMSingle(conversationInfo.target.username,appkey: conversationInfo.target.appKey));
        break;
    }
    getMessageChatList();
  }
  //获取群组成员列表
  Future getGroupMembers(JMConversationInfo conversationInfo){
    _conversationInfo = conversationInfo;
    jmessage.getGroupMembers( id: conversationInfo.target.id).then((list){
      _groupMemberListSink.add(list);
    });
  }
  //创建群聊
  Future createGroup(String groupName,String desc,List<String> usernames,{JMGroupType groupType = JMGroupType.private}) async{
    await jiguangLogin();
    if(ObjectUtil.isNotEmpty(groupName) && groupName.length > 15){
      groupName = groupName.substring(0,15);
    }
    String groupId = await jmessage.createGroup(groupType:groupType,name: groupName, desc: desc);
    for(var i = 0;i<usernames.length;i++) {
      try {
        await addGroupMembers(groupId, [usernames[i]]);
      }catch(err){
      }
    }
    await jmessage.sendTextMessage(type: getJMGroup(groupId), text: desc,);
//    Fluttertoast.showToast(msg: '群组创建成功');
    return groupId;
  }
  //批量添加群成员
  Future addGroupMembers(String groupId,List<String> usernames,{String appkey = kMockAppkey}) async{
    try {
      await jmessage.addGroupMembers(
          id: groupId,
          usernameArray: usernames,
          appKey: appkey
      );
    }catch(err){
      print(err);
    }
  }
  //解散群
  Future dissolveGroup(JMConversationInfo conversationInfo) async{
    await jmessage.dissolveGroup(groupId:conversationInfo.target.id);

    deleteConversation(conversationInfo);

  }
  //移除群成员
  Future removeMember(String groupId,List<String> usernames,{String appkey = kMockAppkey}) async{
    await jmessage.removeGroupMembers(
        id: groupId,
        usernames: usernames,
        appKey: appkey
    );
  }
  //获取群组的详细信息
//  Future getGroupInfo(JMConversationInfo conversationInfo){
//  jmessage.getGroupInfo( id: conversationInfo.target.id).then((list){
//    _groupMemberListSink.add(JMGroupInfo);
//  });
//  }
  //获取消息记录
  Future getHistoryMessages(JMConversationInfo conversationInfo){
    _conversationInfo = conversationInfo;
    //重置未读数量
    jmessage.resetUnreadMessageCount(target: conversationInfo.conversationType == JMConversationType.single?getJMSingle(conversationInfo.target.username,appkey:conversationInfo.target.appKey):getJMGroup(conversationInfo.target.id));
    return jmessage.getHistoryMessages(
        type: conversationInfo.conversationType == JMConversationType.single ? getJMSingle(conversationInfo.target.username,appkey:conversationInfo.target.appKey):getJMGroup(conversationInfo.target.id),
        from: _reposPage *10,
        limit: 10,
        isDescend: false
    ).then((list){
      if (_historyMessageList == null) {
        _historyMessageList = new List();
      }
      if (_reposPage == 0) {
        _historyMessageList.clear();
      }

      _historyMessageList.insertAll(0, list);

      _historyMessageSink.add(UnmodifiableListView(_historyMessageList));
    });
  }

  JMSingle getJMSingle(String username,{String appkey = kMockAppkey}){
    return JMSingle.fromJson({
      'username': username,
      'appKey': appkey
    });
  }

  JMGroup getJMGroup(String groupId){
    return JMGroup.fromJson({
      'type': JMGroupType.private,
      'groupId': groupId
    });
  }

  //极光登录
  Future jiguangLogin() async{
    String mobile = SpUtil.getString(Constant.key_login_name);
    await jmessage.login(username: mobile, password: Utils.generateMd5(mobile));
  }

  //获取本地的聊天窗口列表
  Future getMessageChatList() async{

    await jiguangLogin();


    //获取聊天记录列表
    return jmessage.getConversations().then((jmConversations){
      List<JMConversationInfo> list = [];
      bool needRefresh = false;
      print(jmConversations.length);
      for(var i = 0;i<jmConversations.length;i++){
        if(jmConversations[i].conversationType == JMConversationType.group){
          //群组
          JMGroupInfo groupInfo = jmConversations[i].target;
          if(groupInfo.ownerAppKey == '' && groupInfo.owner == ''){
            jmessage.deleteConversation(target: getJMGroup(groupInfo.id));
          }else{
            list.add(jmConversations[i]);
          }
        }else{

          if(ObjectUtil.isEmptyString(jmConversations[i].target.nickname)){
            needRefresh = true;
          }

          list.add(jmConversations[i]);
        }
      }
      _conversationsSink.add(list);
      print('$list-------------');
      getAllUnreadCount();
      if(needRefresh){
        Future.delayed(Duration(seconds: 2),(){
          getMessageChatList();
        });
      }
    }).catchError((_){
      _conversations.sink.addError('error');
    });

//    for(var i = 0;i < jmConversations.length; i++){
//      jmConversations[i].
//    }


//    jmessage.resetUnreadMessageCount(
//        target: kMockUser
//    );

//    getAllUnreadCount();

  }

  //消息撤回
  Future retractMessage(String msgId) {
//    jmessage.re

//    jmessage.retractMessage(
//        type: kMockUser,
//        messageId: 'target_msg_id'
//    );

    jmessage.retractMessage(
        target: _conversationInfo.conversationType == JMConversationType.single?getJMSingle(_conversationInfo.target.username,appkey:_conversationInfo.target.appKey)
            :getJMGroup(_conversationInfo.target.id),
        serverMessageId: msgId
    ).then((val){

    }).catchError((value){
      Fluttertoast.showToast(msg: '撤回失败，超出时间');
    });
  }

  Future addListener() async {
    jmessage.addReceiveMessageListener((msg) {
      getMessageChatList();
      if(_conversationInfo != null){
        getHistoryMessages(_conversationInfo);
      }

      if (msg is JMVoiceMessage) {
        print('send voice message11');
      }

      if (msg is JMImageMessage) {

      }

      if(msg is JMCustomMessage){
//        jmessage.dissolveGroup(groupId: '37626134');

      }

      if (msg is JMFileMessage) {

        jmessage.downloadFile(
          target: msg.from.targetType,
          messageId: msg.id,
        ).then((Map res) {

        }).catchError((err) {
          print('download file error');
        });
      }

    });

    jmessage.addClickMessageNotificationListener((msg) {//+
      print('flutter receive event  receive addClickMessageNotificationListener ${msg.target}');

//      try {
//        dynamic clickType = null;
//        if(msg.target is JMGroupInfo){
//          clickType = getJMGroup(msg.target.id);
//        }else if(msg.from is JMUserInfo){
//          clickType = getJMSingle(msg.from.username,appkey:msg.from.appKey);
//        }
//        if(clickType != null){
//          jmessage.getConversation(target: clickType).then((model){
//            enterConversation(model);
//            getHistoryMessages(model);
//
//            if(ApplicationEvent.event != null)
//              ApplicationEvent.event.fire(StatusEvent(StatusEventConstant.JUMP_CHATPAGE,1,obj: model));
//
//          });
//        }
//      }catch(err){
//        print(err);
//      }
    });

    jmessage.addSyncOfflineMessageListener((conversation,msgs) {
      print('receive offline message');
      print('conversation ${conversation}');
      print('messages ${msgs}');

      for (dynamic msg in msgs) {
        print('msg ${msg}');
      }
      print('flutter receive event verify receive offline message done!');

      getMessageChatList();

    });

//    jmessage.addSyncRoamingMessageListener((conversation) {
//      print('flutter receive event receive roaming message');
//    });

    jmessage.addLoginStateChangedListener((JMLoginStateChangedType type) {
      print('flutter receive event receive login state change ${type}');
    });

    jmessage.addContactNotifyListener((JMContactNotifyEvent event) {
      print('flutter receive event contact notify ${event.toJson()}');
    });

    jmessage.addMessageRetractListener((msg) {
      //消息撤回
      getMessageChatList();
      if(_conversationInfo != null){
        getHistoryMessages(_conversationInfo);
      }
      print('flutter receive event message retract event');
    });


    jmessage.addReceiveChatRoomMessageListener((msgs) {//+
      print('flutter receive event receive chat room message ${msgs}');
    });

    jmessage.addReceiveTransCommandListener((JMReceiveTransCommandEvent event) {
      print('flutter receive event receive trans command');
    });

    jmessage.addReceiveApplyJoinGroupApprovalListener((JMReceiveApplyJoinGroupApprovalEvent event) {

      print('flutter receive event receive apply jocin group approval');
    });

    jmessage.addReceiveGroupAdminRejectListener((JMReceiveGroupAdminRejectEvent event) {
      print('flutter receive event receive group admin rejected');
    });

    jmessage.addReceiveGroupAdminApprovalListener((JMReceiveGroupAdminApprovalEvent event) {
      print('flutter receive event receive group admin approval');

    });

  }

///极光推送

}