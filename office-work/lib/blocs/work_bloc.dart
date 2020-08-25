import 'dart:collection';
import 'dart:io';

import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/android_encoder.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/net/dio_util.dart';
import 'package:flutter_wanandroid/data/repository/mission_repository.dart';
import 'package:flutter_wanandroid/data/repository/wan_repository.dart';
import 'package:flutter_wanandroid/db/db_model.dart';
import 'package:flutter_wanandroid/event/event-bus.dart';
import 'package:flutter_wanandroid/ui/dialog/simple_dialog.dart';
import 'package:flutter_wanandroid/utils/xpush_utils.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';

const String kMockAppkey = 'f3ec3edba9f954c719c2a36a';

final JMSingle kMockUser = JMSingle.fromJson({
  'username': '18301166286',
  'appKey': kMockAppkey
});
class WorkBloc implements BlocBase {
  ///****** ****** ****** Home ****** ****** ****** /

  BehaviorSubject<List<BannerModel>> _banner =
  BehaviorSubject<List<BannerModel>>();

  Sink<List<BannerModel>> get _bannerSink => _banner.sink;

  Stream<List<BannerModel>> get bannerStream => _banner.stream;

  BehaviorSubject<List<ReposModel>> _recRepos =  BehaviorSubject<List<ReposModel>>();

  Sink<List<ReposModel>> get _recReposSink => _recRepos.sink;

  Stream<List<ReposModel>> get recReposStream => _recRepos.stream;

  BehaviorSubject<List<ReposModel>> _recWxArticle =
  BehaviorSubject<List<ReposModel>>();

  Sink<List<ReposModel>> get _recWxArticleSink => _recWxArticle.sink;

  Stream<List<ReposModel>> get recWxArticleStream => _recWxArticle.stream;

  ///****** ****** ****** Home ****** ****** ****** /

  ///****** ****** ****** Repos ****** ****** ****** /
  BehaviorSubject<List<ReposModel>> _repos =
  BehaviorSubject<List<ReposModel>>();

  Sink<List<ReposModel>> get _reposSink => _repos.sink;

  Stream<List<ReposModel>> get reposStream => _repos.stream;

  List<ReposModel> _reposList;
  int _reposPage = 0;

  ///****** ****** ****** Repos ****** ****** ****** /

  ///****** ****** ****** Events ****** ****** ****** /

  BehaviorSubject<List<ReposModel>> _events =
  BehaviorSubject<List<ReposModel>>();

  Sink<List<ReposModel>> get _eventsSink => _events.sink;

  Stream<List<ReposModel>> get eventsStream => _events.stream;

  List<ReposModel> _eventsList;
  int _eventsPage = 0;

  ///****** ****** ****** Events ****** ****** ****** /

  ///****** ****** ****** System ****** ****** ****** /

  BehaviorSubject<List<TreeModel>> _tree = BehaviorSubject<List<TreeModel>>();

  Sink<List<TreeModel>> get _treeSink => _tree.sink;

  Stream<List<TreeModel>> get treeStream => _tree.stream;

  List<TreeModel> _treeList;

  ///****** ****** ****** System ****** ****** ****** /

  ///****** ****** ****** Version ****** ****** ****** /

  BehaviorSubject<VersionModel> _version = BehaviorSubject<VersionModel>();

  Sink<VersionModel> get _versionSink => _version.sink;

  Stream<VersionModel> get versionStream => _version.stream.asBroadcastStream();

  VersionModel _versionModel;

  ///****** ****** ****** Version ****** ****** ****** /

  ///****** ****** ****** ****** ****** ****** /
  BehaviorSubject<StatusEvent> _homeEvent = BehaviorSubject<StatusEvent>();

  Sink<StatusEvent> get _homeEventSink => _homeEvent.sink;

  Stream<StatusEvent> get homeEventStream =>
      _homeEvent.stream.asBroadcastStream();

  ///****** ****** ****** ****** ****** ****** /

  ///****** ****** ****** ****** ****** ****** /

  ///****** ****** ****** ****** ****** ****** /

  ///****** ****** ****** personal ****** ****** ****** /

  BehaviorSubject<ComModel> _recItem = BehaviorSubject<ComModel>();

  Sink<ComModel> get _recItemSink => _recItem.sink;

  Stream<ComModel> get recItemStream => _recItem.stream.asBroadcastStream();

  ComModel hotRecModel;

  BehaviorSubject<List<ComModel>> _recList = BehaviorSubject<List<ComModel>>();

  Sink<List<ComModel>> get _recListSink => _recList.sink;

  Stream<List<ComModel>> get recListStream =>
      _recList.stream.asBroadcastStream();

  List<ComModel> hotRecList;

  ///****** ****** ****** personal ****** ****** ****** /

  ///***********************  办公模块权限
  BehaviorSubject<List<ModuleModel>> _moduleListRepos =  BehaviorSubject<List<ModuleModel>>();

  Sink<List<ModuleModel>> get _moduleListSink => _moduleListRepos.sink;

  Stream<List<ModuleModel>> get moduleListReposStream => _moduleListRepos.stream;
  ///***********************  办公模块权限

  ///***********************  工作通知权限
  BehaviorSubject<List<WorkArticleModel>> _workArticleListRepos =  BehaviorSubject<List<WorkArticleModel>>();

  Sink<List<WorkArticleModel>> get _workArticleListSink => _workArticleListRepos.sink;

  Stream<List<WorkArticleModel>> get workArticleListReposStream => _workArticleListRepos.stream;
  ///***********************  工作通知权限

  ///***********************  用户个人信息
  BehaviorSubject<UserInfoModel> _userinfoRepos =  BehaviorSubject<UserInfoModel>();
  Sink<UserInfoModel> get _userinfoReposSink => _userinfoRepos.sink;
  Stream<UserInfoModel> get userinfoReposStream => _userinfoRepos.stream;
  ///***********************  用户个人信息
  ///***********************  用户个人数据统计
  BehaviorSubject<MineCountData> _userCountRepos =  BehaviorSubject<MineCountData>();
  Sink<MineCountData> get _userCountSink => _userCountRepos.sink;
  Stream<MineCountData> get userCountStream => _userCountRepos.stream;
  ///***********************  用户个人数据统计
  ///***********************  通讯录
  BehaviorSubject<List<ContactUserModel>> _contactUserListRepos =  BehaviorSubject<List<ContactUserModel>>();
  Sink<List<ContactUserModel>> get _contactUserListReposSink => _contactUserListRepos.sink;
  Stream<List<ContactUserModel>> get contactUserListReposStream => _contactUserListRepos.stream;
  ///***********************  通讯录
  ///***********************  组织机构用户
  BehaviorSubject<List<ContactUserModel>> _groupUserListRepos =  BehaviorSubject<List<ContactUserModel>>();
  Sink<List<ContactUserModel>> get _groupUserListReposSink => _groupUserListRepos.sink;
  Stream<List<ContactUserModel>> get groupUserListReposStream => _groupUserListRepos.stream;
  ///***********************  组织机构用户
  ///关注
  BehaviorSubject<dynamic> _focusRepos =  BehaviorSubject<dynamic>();
  Sink<dynamic> get _focusReposSink => _focusRepos.sink;
  Stream<dynamic> get focusReposStream => _focusRepos.stream;
  /// 关注
  ///组织机构
  BehaviorSubject<List<DepartModel>> _departRepos =  BehaviorSubject<List<DepartModel>>();
  Sink<List<DepartModel>> get _departReposSink => _departRepos.sink;
  Stream<List<DepartModel>> get departReposStream => _departRepos.stream;
  /// 组织机构
  ///工作通知视频详情
  BehaviorSubject<WorkArticleModel> _articleVideoRepos =  BehaviorSubject<WorkArticleModel>();
  Sink<WorkArticleModel> get _articleVideoReposSink => _articleVideoRepos.sink;
  Stream<WorkArticleModel> get articleVideoReposStream => _articleVideoRepos.stream;
  /// 工作通知视频详情
  WanRepository wanRepository = new WanRepository();

  MissionRepository missionRepository = new MissionRepository();

  HttpUtils httpUtils = new HttpUtils();

  //db数据库
//  var database;
  ArticleBrowseControlModel articleBrowseControlModel;
  //db数据库

  static JmessageFlutter jmessage;

  WorkBloc({jmessages}) {
    LogUtil.e("MainBloc......");
//    database = db;
    jmessage = jmessages;
  }

  @override
  Future getData({String labelId, int page,db}) {
    LogUtil.e("getData labelId: $labelId" +
        "   _page: $page" +
        "   _reposPage: $_reposPage");
    switch (labelId) {
      case Ids.titleWork:
        return getHomeData(labelId);
        break;
      case Ids.titleHome:
        return getHomeData(labelId);
        break;
      case Ids.titleMessage:
        return getHomeData(labelId);
        break;
      case Ids.titleRepos:
        return getArticleListProject(labelId, page);
        break;
      case Ids.titleEvents:
        return getArticleList(labelId, page);
        break;
      case Ids.titleSystem:
        return getTree(labelId);
        break;
      default:
        return Future.delayed(new Duration(seconds: 1));
        break;
    }
  }

  @override
  Future onLoadMore({String labelId,model}) {
    int _page = 0;
    switch (labelId) {
      case Ids.titleChatMessage:
        _page = ++_reposPage;
        return getHistoryMessages(model);
//        break;
      case Ids.titleHome:
        break;
      case Ids.titleRepos:
        _page = ++_reposPage;
        break;
      case Ids.titleEvents:
        _page = ++_eventsPage;
        break;
      case Ids.titleSystem:
        break;
      default:
        break;
    }
    LogUtil.e("onLoadMore labelId: $labelId" +
        "   _page: $_page" +
        "   _reposPage: $_reposPage");
    return getData(labelId: labelId, page: _page);
  }

  @override
  Future onRefresh({String labelId}) {
    switch (labelId) {
      case Ids.titleHome:
        getHotRecItem();
        break;
      case Ids.titleMessage:
        getHotRecItem();
        break;
      case Ids.titleMine:
        getMineData();
        break;
      case Ids.titleWork:
        getHomeData(labelId);
        break;
      case Ids.titleRepos:
        _reposPage = 0;
        break;
      case Ids.titleEvents:
        _eventsPage = 0;
        break;
      case Ids.titleSystem:
        break;
      default:
        break;
    }
    LogUtil.e("onRefresh labelId: $labelId" + "   _reposPage: $_reposPage");
    return getData(labelId: labelId, page: 0);
  }

  //上传base64图片
  Future<List<ImageFileData>> uploadBase64Image(String base64) async{
    List<ImageFileData> images = await wanRepository.uploadBase64(base64);
    return images;
  }

  ///提交签到信息
  Future submitActivitySign(String activityId,WelfareUserInfoModel welfareUser) async{
     return await wanRepository.submitActivitySign(activityId,welfareUser);
  }

  //根据身份证获取志愿者信息
  Future<List<WelfareUserInfoModel>> getWelfareUserInfos(String idcard) async{
    List<WelfareUserInfoModel> welfareUserInfos = await wanRepository.welfareUserInfos(idcard);
    return welfareUserInfos;
  }

  //获取活动列表
  BehaviorSubject<List<ActivityModel>> _activityModelListRepos =  BehaviorSubject<List<ActivityModel>>();
  Sink<List<ActivityModel>> get _activityModelListReposSink => _activityModelListRepos.sink;
  Stream<List<ActivityModel>> get activityModelListReposStream => _activityModelListRepos.stream;
  Future activltiList(int pageNo) async {
     wanRepository.activltiList(pageNo).then((list){
       _activityModelListReposSink.add(list);
     });
  }


  //签到列表
  BehaviorSubject<List<ActivitySignModel>> _activitySignModelListRepos =  BehaviorSubject<List<ActivitySignModel>>();
  Sink<List<ActivitySignModel>> get _activitySignModelListReposSink => _activitySignModelListRepos.sink;
  Stream<List<ActivitySignModel>> get activitySignModelListReposStream => _activitySignModelListRepos.stream;
  Future activitySignList(String aid) async {
    wanRepository.activitySignList(aid).then((list) async => _activitySignModelListReposSink.add(
        list));
  }



//获取活动列表三级联动（一级社区列表）
  BehaviorSubject<List<ThreeLevellLinkageOneModel>> _ThreeLevelLinkageModelListRepos =  BehaviorSubject<List<ThreeLevellLinkageOneModel>>();
  Sink<List<ThreeLevellLinkageOneModel>> get _ThreeLevelLinkageModelReposSink => _ThreeLevelLinkageModelListRepos.sink;
  Stream<List<ThreeLevellLinkageOneModel>> get ThreeLevellLinkageOneModelListReposStream => _ThreeLevelLinkageModelListRepos.stream;
  Future threeLevelLinkageModelList() async {
    wanRepository.threeLevellLnkageOneList().then((list){
      _ThreeLevelLinkageModelReposSink.add(list);
    }).catchError((_){
      print(_);
    });
  }


  //获取活动列表三级联动（二级社区列表）
  BehaviorSubject<List<ThreeLevellLinkageTwoModel>> _ThreeLevelLinkageModelTwoListRepos =  BehaviorSubject<List<ThreeLevellLinkageTwoModel>>();
  Sink<List<ThreeLevellLinkageTwoModel>> get _ThreeLevelLinkageModelTwoListReposSink => _ThreeLevelLinkageModelTwoListRepos.sink;
  Stream<List<ThreeLevellLinkageTwoModel>> get ThreeLevellLinkageTwoModelListReposStream => _ThreeLevelLinkageModelTwoListRepos.stream;
  Future threeLevelLinkageTwoModelList(String id,{bool init = false}) async {
    wanRepository.threeLevellLinkageTwoList(id).then((list){
      _ThreeLevelLinkageModelTwoListReposSink.add(list);
    });
  }


  //获取活动列表三级联动（三级社区列表）
  BehaviorSubject<List<ThreeLevellLinkageThreeModel>> _ThreeLevelLinkageModelThreeListRepos =  BehaviorSubject<List<ThreeLevellLinkageThreeModel>>();
  Sink<List<ThreeLevellLinkageThreeModel>> get _ThreeLevelLinkageModelThreeListReposSink => _ThreeLevelLinkageModelThreeListRepos.sink;
  Stream<List<ThreeLevellLinkageThreeModel>> get ThreeLevellLinkageThreeModelListReposStream => _ThreeLevelLinkageModelThreeListRepos.stream;
  Future threeLevelLinkageThreeModelList(String id,{bool init = false}) async {
    if(init) {
      _ThreeLevelLinkageModelThreeListReposSink.add([]);
      return;
    }
    wanRepository.threeLevellLinkageThreeList(id).then((list){_ThreeLevelLinkageModelThreeListReposSink.add(list);
    });
  }


  Future getHomeData(String labelId) {
    getModulesList(labelId);
    getWorkArticle(labelId,1);

//    articleBrowseControlModel = new ArticleBrowseControlModel();
//    articleBrowseControlModel.saveArticleBrowse('1', '18518216282');
//
//    articleBrowseControlModel.getArticleBrowseByName("18518216282");

    return baneners(labelId);
  }
  //工商共治联系人列表
  Future getChatUserList(){
    String sort = SpUtil.getString("chat_sort",defValue:"realname");
    return wanRepository.getChatUserList().then((list){
      if (list == null || list.isEmpty) return;
      for (int i = 0, length = list.length; i < length; i++) {
        if (sort == 'realname') {
          String pinyin = PinyinHelper.getPinyinE(list[i].realname);
          print(list[i]);
          String tag = pinyin.substring(0, 1).toUpperCase();
          list[i].namePinyin = pinyin;
          if (RegExp("[A-Z]").hasMatch(tag)) {
            list[i].tagIndex = tag;
          } else {
            list[i].tagIndex = "#";
          }
          list[i].tagSeparator = list[i].tagIndex;
        }else if(sort == 'depart'){
          String depart = list[i].departname;
          if(ObjectUtil.isNotEmpty(depart)){
            List departArr = depart.split(",");
            if(departArr.length > 0){
              if(departArr[0].length <= 2) list[i].tagIndex = departArr[0];
              else list[i].tagIndex = departArr[0].substring(0,2);

              list[i].tagSeparator = departArr[0];
            }
          }
        }else if(sort == 'personType'){
          String personType = list[i].personType;
          if(ObjectUtil.isNotEmpty(personType)){
              list[i].tagIndex = personType;
              list[i].tagSeparator = personType;
          }
        }
      }
      //根据A-Z排序
      SuspensionUtil.sortListBySuspensionTag(list);
      _contactUserListReposSink.add(UnmodifiableListView<ContactUserModel>(list));
    }).catchError((v){
      print(v);
      _contactUserListRepos.sink.addError('error');
    });
  }

  //获取组织机构列表
  Future getChatGroupList() async{
    wanRepository.getDepartList().then((list){

      DepartModel temp;
      for(int i = list.length - 1; i > 0; i--) {
        //进行这一轮的冒泡排序
        for(int j = 0; j < i; j++) {
          //从第一个元素开始和下一个比较，比下一个大则交换
          if(list[j].len > list[j + 1].len) {
            temp = list[j];
            list[j] = list[j + 1];
            list[j + 1] = temp;
          }
        }
      }

      _departReposSink.add(list);
    });
  }

  //根据组织机构获取人员列表
  Future getChatOrgUserList(String orgCode) async{
    if(ObjectUtil.isEmpty(orgCode)){
      _groupUserListReposSink.add([]);
    } else {
      wanRepository.getChatUserListByOrgCode(orgCode).then((list) {
        _groupUserListReposSink.add(list);
      });
    }
  }

  //获取我自己的数据
  Future getMineData(){
    return wanRepository.getUserInfo().then((info){
      _userinfoReposSink.add(info);
    }).catchError((_){
      Fluttertoast.showToast(msg: _.message);
    });
  }
  //是否收藏
  Future isCollect(String id){
    wanRepository.focus(type:Constant.collect_user,method:'get',id:id).then((result){
      _focusReposSink.add(result.data);
    });
  }
  //收藏
  Future collect(String id){
    wanRepository.focus(type:Constant.collect_user,id:id,method: 'post').then((_){
      Fluttertoast.showToast(msg: '关注成功');
    });
  }
  //取消收藏
  Future unCollect(String id){
    wanRepository.unfocus(type:Constant.collect_user,id:id).then((result){
      Fluttertoast.showToast(msg: '取消关注成功');
      _focusReposSink.add(result.data);
    });
  }
  //获取文章视频详情
  Future getArticleVideoDetail(String id){
    wanRepository.getWorkArticleVideoDetail(id).then((val){
      _articleVideoReposSink.add(val);
    });
  }
  //获取我的统计数据
  Future getMineDataCount() {
    wanRepository.getUserCount().then((result){
      _userCountSink.add(result);
    });
  }

  //获取工作通知
  Future getWorkArticle(String labelId,int page){
    wanRepository.getWorkArticleList(page).then((result){
      List<WorkArticleModel> list = result['workArticle'];
      _workArticleListSink.add(UnmodifiableListView<WorkArticleModel>(list));
    }).catchError((_){
      print(_);
    });
  }

  //获取模块权限
  Future getModulesList(String labelId){
    wanRepository.getModuleList().then((list){
      print('$list');
      _moduleListSink.add(UnmodifiableListView<ModuleModel>(list));
    }).catchError((_){
      print('发错误了');
    });
  }
  //获取banner图
  Future baneners(String labelId) {
    return wanRepository.baneners().then((list) {
      _bannerSink.add(UnmodifiableListView<BannerModel>(list));
    }).catchError((_){
      _banner.sink.addError("error");
      _homeEventSink.add(new StatusEvent(labelId, RefreshStatus.failed));
    });
  }
  //版本更新
  Future getVersion(context) async {
    String platform = 'android';
    if(Platform.isIOS){
      platform = 'ios';
    }else if(Platform.isAndroid){
      platform = 'android';
    }
    wanRepository.getVersion(platform).then((model) {
      _versionModel = model;
      _versionSink.add(_versionModel);

      int status = Utils.getUpdateStatus(model.version);
      String exist = SpUtil.getString('version');
      if(status != 0 && exist == '') {
        SimpleDialogUtil.showNewVersionAppDialog(context, model, confirm: () {

        });
        SpUtil.putString('version',model.version);
      }
    });
  }
  Future susTagChanged(String tag){
  }
  //申请权限
  Future requestPermission() async {
    // 申请权限
    Map<PermissionGroup, PermissionStatus> permissions =
    await PermissionHandler().requestPermissions([PermissionGroup.storage,PermissionGroup.camera]);
    // 申请结果
//    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.storage);
//    if (permission == PermissionStatus.granted) {
//      Fluttertoast.showToast(msg: "存储权限申请被拒绝，无法使用本地存储，如需开启，请去设置手动打开！");
//    }
//    permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
//    if (permission == PermissionStatus.granted) {
//      Fluttertoast.showToast(msg: "相机权限申请被拒绝，无法使用相机拍照，如需开启相机权限，请去设置手动打开！");
//    }
  }

  //点击更换头像
  Future<Null> clickAvatar(type) async {
    //选择图片
    ImagePicker.pickImage(source: type).then((file){
      //裁切图片
      ImageCropper.cropImage(
        sourcePath: file.path,
        ratioX: 1.0,
        ratioY: 1.0,
        maxWidth: 512,
        maxHeight: 512,
      ).then((file){
        wanRepository.uploadImage(file).then((list){
          if(list != null && list.length > 0) {
            Fluttertoast.showToast(msg: '图片上传成功');

            wanRepository.modifyUserInfo({'portrait':list[0].url}).then((n){
              Fluttertoast.showToast(msg: '信息修改成功');
              //获取个人基本信息
              getMineData();

              //更新极光头像
              jmessage.updateMyInfo(gender: JMGender.female,
                  nickname: userInfoModel.realname,
                  extras: {
                    "personType": userInfoModel.personType,
                    "portrait": list[0].url /*,"userId":userInfoModel.id*/
                  });

            });
          }
        });
      });
    });
  }
  //修改个人信息
  Future updateMineInfo(context,UserInfoModel userInfoModel){
    wanRepository.modifyUserInfo(userInfoModel.toJson()).then((n){
      Fluttertoast.showToast(msg: '信息修改成功');
      //获取个人基本信息
      getMineData();

      Navigator.pop(context);

    });
  }

  //获取字典列表
  Future getDictionaryList(String name) async{
    return await wanRepository.getDictionary(name);
  }

  //邀请居民代表
  Future invitePerson(context,{String mobile,String realname}) async{
    return wanRepository.invitePerson(mobile: mobile,realname:realname);
  }

  Future getRecRepos(String labelId) async {
    ComReq _comReq = new ComReq(402);
    wanRepository.getProjectList(data: _comReq.toJson()).then((list) {
      if (list.length > 6) {
        list = list.sublist(0, 6);
      }
      _recReposSink.add(UnmodifiableListView<ReposModel>(list));
    });
  }

  Future getRecWxArticle(String labelId) async {
    int _id = 408;
    wanRepository.getWxArticleList(id: _id).then((list) {
      if (list.length > 6) {
        list = list.sublist(0, 6);
      }
      _recWxArticleSink.add(UnmodifiableListView<ReposModel>(list));
    });
  }

  Future getArticleListProject(String labelId, int page) {
    return wanRepository.getArticleListProject(page).then((list) {
      if (_reposList == null) {
        _reposList = new List();
      }
      if (page == 0) {
        _reposList.clear();
      }
      _reposList.addAll(list);
      _reposSink.add(UnmodifiableListView<ReposModel>(_reposList));
      _homeEventSink.add(new StatusEvent(
          labelId,
          ObjectUtil.isEmpty(list)
              ? RefreshStatus.noMore
              : RefreshStatus.idle));
    }).catchError((_) {
      _reposPage--;
      _homeEventSink.add(new StatusEvent(labelId, RefreshStatus.failed));
    });
  }

  Future getArticleList(String labelId, int page) {
    return wanRepository.getArticleList(page: page).then((list) {
      if (_eventsList == null) {
        _eventsList = new List();
      }
      if (page == 0) {
        _eventsList.clear();
      }
      _eventsList.addAll(list);
      _eventsSink.add(UnmodifiableListView<ReposModel>(_eventsList));
      _homeEventSink.add(new StatusEvent(
          labelId,
          ObjectUtil.isEmpty(list)
              ? RefreshStatus.noMore
              : RefreshStatus.idle));
    }).catchError((_) {
      _eventsPage--;
      _homeEventSink.add(new StatusEvent(labelId, RefreshStatus.failed));
    });
  }

  Future getTree(String labelId) {
    return wanRepository.getTree().then((list) {
      if (_treeList == null) {
        _treeList = new List();
      }

      for (int i = 0, length = list.length; i < length; i++) {
        String tag = Utils.getPinyin(list[i].name);
        if (RegExp("[A-Z]").hasMatch(tag)) {
          list[i].tagIndex = tag;
        } else {
          list[i].tagIndex = "#";
        }
      }
      SuspensionUtil.sortListBySuspensionTag(list);

      _treeList.clear();
      _treeList.addAll(list);
      _treeSink.add(UnmodifiableListView<TreeModel>(_treeList));
      _homeEventSink.add(new StatusEvent(
          labelId,
          ObjectUtil.isEmpty(list)
              ? RefreshStatus.noMore
              : RefreshStatus.idle));
    }).catchError((_) {
      _homeEventSink.add(new StatusEvent(labelId, RefreshStatus.failed));
    });
  }

  Future getHotRecItem() async {
    httpUtils.getRecItem().then((model) {
      hotRecModel = model;
      _recItemSink.add(hotRecModel);
    });
  }

  Future getHotRecList(String labelId) async {
    httpUtils.getRecList().then((list) {
      hotRecList = list;
      _recListSink.add(UnmodifiableListView<ComModel>(list));
      _homeEventSink.add(new StatusEvent(
          labelId,
          ObjectUtil.isEmpty(list)
              ? RefreshStatus.noMore
              : RefreshStatus.idle));
    }).catchError((_) {
      _homeEventSink.add(new StatusEvent(labelId, RefreshStatus.failed));
    });
  }

  void test() {
    LogUtil.e("MainBloc test 1.....");
  }

  @override
  void dispose() {
    _banner.close();
    _recRepos.close();
    _recWxArticle.close();
    _repos.close();
    _events.close();
    _tree.close();
    _homeEvent.close();
    _version.close();
    _recItem.close();
    _recList.close();
  }


  ///极光推送消息
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
  UserInfoModel userInfoModel;
//  ScrollController _scrollController;
  JMConversationInfo _conversationInfo;//当前的聊天室

  //语音
  FlutterSound flutterSound;

  //初始化消息
  Future initMessageHome({String labelId}){
    userRegister();
    registerMessage();
  }
  //将消息注册到后端
  Future registerMessage() async {
    String platform,pushToken;
    Map<dynamic,dynamic> map = await XPushUtils.getInfo();
    LogUtil.v(map);
    if(map != null){
      platform = map["platform"];
      pushToken = map["token"];
    }
    if(platform == "" || pushToken == ""){
      return;
    }

    wanRepository.registerMessage(platform: platform,pushToken: pushToken).then((result){

    }).catchError((_){
      print(_);
    });
  }

  String recorderPath = '';
  //开始录音
  void startRecorder() async{
//    Fluttertoast.showToast(msg: '开始录音');
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    if(flutterSound == null){
      flutterSound = new FlutterSound();
    }
    try {
      recorderPath = '$tempPath/${DateTime.now().millisecondsSinceEpoch}${Platform.isIOS?'.m4a':'.mp4'}';
      String path = await flutterSound.startRecorder(recorderPath,androidEncoder:AndroidEncoder.AMR_WB);
      print('startRecorder: $path');
//      recorderPath = path;
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

//    AudioPlayer audioPlayer = AudioPlayer();
//    int result = await audioPlayer.play(uri);
//    print(result);
//    return;
    if(flutterSound == null) flutterSound = new FlutterSound();

    if(flutterSound.isPlaying){
      await flutterSound.stopPlayer();
    }else {
      String path = await flutterSound.startPlayer(uri);
      await flutterSound.setVolume(1.0);

//      print('startPlayer: $path');
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
        type: _conversationInfo.conversationType == JMConversationType.single ? getJMSingle(_conversationInfo.target.username):getJMGroup(_conversationInfo.target.id),
        text: text,
      );
      resetReposPage();
      getHistoryMessages(model);
    }
  }
  //发送图片消息
  Future sendImageMessage(model) async{
    await jiguangLogin();
    ImagePicker.pickImage(source: ImageSource.gallery).then((file){
        jmessage.sendImageMessage(
          type: _conversationInfo.conversationType == JMConversationType.single ? getJMSingle(_conversationInfo.target.username):getJMGroup(_conversationInfo.target.id),
          path: file.path,
        );
        resetReposPage();
        getHistoryMessages(model);
    });
  }
  //发送语音消息
  Future sendVoiceMessage(String path) async{
    await jiguangLogin();
    jmessage.sendVoiceMessage(
      type: _conversationInfo.conversationType == JMConversationType.single ? getJMSingle(_conversationInfo.target.username):getJMGroup(_conversationInfo.target.id),
      path: path,
    );
    resetReposPage();
    getHistoryMessages(_conversationInfo);
  }
  //下载文件
  Future downloadFile(msgId,JMMessageType type,{String origin = '0'}) async{
    print('orgin:$origin');
    switch (type) {
      case JMMessageType.text:
        break;
      case JMMessageType.image:
        if(origin == '0')
        jmessage.downloadThumbImage(
            target: _conversationInfo.conversationType == JMConversationType.single ? getJMSingle(_conversationInfo.target.username):getJMGroup(_conversationInfo.target.id),
            messageId: msgId
        ).then((map){
          map.putIfAbsent('state','1' as dynamic);
          print('下载的内容为：');
          print(map);
//          map.putIfAbsent('type',type as dynamic);
//          map.putIfAbsent('msgId', msgId);
          _downloadThumbImageSink.add(map);
        }).catchError((_){

        });
        if(origin == '1')
        jmessage.downloadOriginalImage(
            target: _conversationInfo.conversationType == JMConversationType.single ? getJMSingle(_conversationInfo.target.username):getJMGroup(_conversationInfo.target.id),
            messageId: msgId
        ).then((map){
          print('下载的内容为：$map');
//          map.putIfAbsent('msgId', msgId);
          _downloadOriginImageSink.add(map);

        }).catchError((_){
          print(_);
        });
        break;
      case JMMessageType.voice:
        jmessage.downloadVoiceFile(
            target: _conversationInfo.conversationType == JMConversationType.single ? getJMSingle(_conversationInfo.target.username):getJMGroup(_conversationInfo.target.id),
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
            target: _conversationInfo.conversationType == JMConversationType.single ? getJMSingle(_conversationInfo.target.username):getJMGroup(_conversationInfo.target.id),
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
    //先通过token获取个人基本信息
    userInfoModel = await wanRepository.getUserInfo();
    //注册用户
    try {
      await jmessage.userRegister(username: userInfoModel.mobilePhone,
          password: Utils.generateMd5(userInfoModel.mobilePhone),
          nickname: userInfoModel.realname);
    }catch(_){

    }finally {
      //存储手机号
      SpUtil.putString(Constant.key_login_name,userInfoModel.mobilePhone);

      try {
        await jmessage.login(username: userInfoModel.mobilePhone,
            password: Utils.generateMd5(userInfoModel.mobilePhone));
        await jmessage.updateMyInfo(gender: JMGender.female,
            nickname: userInfoModel.realname,
            extras: {
              "personType": userInfoModel.personType,
              "portrait": userInfoModel.portrait, /*,"userId":userInfoModel.id*/
            });
      }catch(_){

      }
      addListener(userInfoModel);
      getMessageChatList();
    }
  }
  //退出登录
  void unRegisterJMessage() async{
    jmessage.logout().then((onValue) {

    },onError: (onError) {

    });
  }

  //根据username获取用户信息
  Future<JMUserInfo> getUserInfoByUsername(String username) async{
    JMUserInfo user = await jmessage.getUserInfo( username: username, appKey: kMockAppkey);
    return user;
  }

  //获取未读消息数量
  Future getAllUnreadCount(){
    jmessage.getAllUnreadCount().then((num){
      _unreadMsgCountSink.add(num);
      jmessage.setBadge(badge: num);
      AndroidBackTop.setBadges('$num');
    });
  }

  //创建聊天
  Future<JMConversationInfo> createConversation(String username) async{
    await jmessage.getUserInfo(username: username,appKey:kMockAppkey).then((userInfo){
    }).catchError((_){
      throw '没有注册';
    });

    JMConversationInfo conversation = await jmessage.createConversation(
        target:JMSingle.fromJson({
          'username': username,
          'appKey': kMockAppkey
        })
    ).catchError((_){
    });
    return conversation;
  }
  //进入聊天
  Future enterConversation(JMConversationInfo conversationInfo){
    _reposPage = 0;
    _conversationInfo = conversationInfo;
    switch(conversationInfo.conversationType){
      case JMConversationType.single:
        jmessage.enterConversation(target: getJMSingle(conversationInfo.target.username));
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
        jmessage.exitConversation(target: getJMSingle(conversationInfo.target.username));
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
        jmessage.deleteConversation(target: getJMSingle(conversationInfo.target.username));
        break;
      case JMConversationType.group:
        jmessage.deleteConversation(target:getJMGroup(conversationInfo.target.id));
        break;
      case JMConversationType.chatRoom:
        jmessage.deleteConversation(target: getJMSingle(conversationInfo.target.username));
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
  Future addGroupMembers(String groupId,List<String> usernames) async{
    try {
      await jmessage.addGroupMembers(
          id: groupId,
          usernameArray: usernames,
          appKey: kMockAppkey
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
  Future removeMember(String groupId,List<String> usernames) async{
    await jmessage.removeGroupMembers(
        id: groupId,
        usernames: usernames,
        appKey: kMockAppkey
    );
  }
  //获取群组的详细信息
//  Future getGroupInfo(JMConversationInfo conversationInfo){
//  jmessage.getGroupInfo( id: conversationInfo.target.id).then((list){
//    _groupMemberListSink.add(JMGroupInfo);
//  });
//  }
  void resetReposPage(){
    _reposPage = 0;
  }
  //获取消息记录
  Future getHistoryMessages(JMConversationInfo conversationInfo){
    _conversationInfo = conversationInfo;
    //重置未读数量
    jmessage.resetUnreadMessageCount(target: conversationInfo.conversationType == JMConversationType.single?getJMSingle(conversationInfo.target.username):getJMGroup(conversationInfo.target.id));
    print(_reposPage);
    return jmessage.getHistoryMessages(
        type: conversationInfo.conversationType == JMConversationType.single ? getJMSingle(conversationInfo.target.username):getJMGroup(conversationInfo.target.id),
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

  JMSingle getJMSingle(String username){
    return JMSingle.fromJson({
      'username': username,
      'appKey': kMockAppkey
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
      LogUtil.e('getMessageChatList  $_');
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

    jmessage.retractMessage(
        target: _conversationInfo.conversationType == JMConversationType.single?getJMSingle(_conversationInfo.target.username)
        :getJMGroup(_conversationInfo.target.id),
        serverMessageId: msgId
    ).then((val){

    }).catchError((value){
      Fluttertoast.showToast(msg: '撤回失败，超出时间');
    });
  }

  Future addListener(UserInfoModel userInfoModel) async {
    LogUtil.e('添加消息监听');
    jmessage.addReceiveMessageListener((msg) {
      getMessageChatList();
      if(_conversationInfo != null){
        resetReposPage();
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

      try {
        dynamic clickType = null;
        if(msg.target is JMGroupInfo){
          clickType = getJMGroup(msg.target.id);
        }else if(msg.from is JMUserInfo){
          clickType = getJMSingle(msg.from.username);
        }
        if(clickType != null){
          jmessage.getConversation(target: clickType).then((model){
            enterConversation(model);

            resetReposPage();
            getHistoryMessages(model);

            if(ApplicationEvent.event != null)
              ApplicationEvent.event.fire(StatusEvent(StatusEventConstant.JUMP_CHATPAGE,1,obj: model));

          });
        }
      }catch(err){
        print(err);
      }
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
        resetReposPage();
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