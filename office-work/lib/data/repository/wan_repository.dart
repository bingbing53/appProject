import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_wanandroid/common/common.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/api/apis.dart';
import 'package:flutter_wanandroid/data/net/dio_util.dart';
import 'package:flutter_wanandroid/data/protocol/models.dart';

class WanRepository {

  ///提交活动签到信息
  Future submitActivitySign(String activityId,WelfareUserInfoModel welfareUser) async{
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.ACTIVITY_SIGN + activityId,data:welfareUser.toJson());
    print(baseResp);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }

  ///根据身份证号获取志愿者信息
  Future<List<WelfareUserInfoModel>> welfareUserInfos(String idcard) async {
    BaseResp<List> baseResp = await DioUtil().request<List>(Method.get, WanAndroidApi.WELFAREINFOBYIDCARD,data:{'idcard':idcard});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    List<WelfareUserInfoModel> wefareUsers;
    if(baseResp.data != null){
      wefareUsers = baseResp.data.map((value){
        return WelfareUserInfoModel.fromJson(value);
      }).toList();
    }
    return wefareUsers;
  }

  //获取活动列表
  Future<List<ActivityModel>> activltiList(int pageNo) async{
    BaseResp<List> baseResp = await DioUtil().request<List>(Method.get, WanAndroidApi.ACTIVITY_LIST,data:{'pageNo':pageNo});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    List<ActivityModel> activityModels;
    if(baseResp.data != null){
      activityModels = baseResp.data.map((value){
        return ActivityModel.fromJson(value);
      }).toList();
    }
    return activityModels;
  }

   //获取活动列表详情页
  Future<List<ActivitySignModel>>  activitySignList(String aid) async{
    BaseResp<List> baseResp = await DioUtil().request<List>(Method.get, WanAndroidApi. ACTIVITY_SIGN_LIST+aid);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    List<ActivitySignModel> activitySignModels;
    if(baseResp.data != null){
      activitySignModels = baseResp.data.map((value){
        return ActivitySignModel.fromJson(value);
      }).toList();
    }
    return activitySignModels;
  }


  //获取活动列表三级联动（一级社区列表）
  Future<List<ThreeLevellLinkageOneModel>>  threeLevellLnkageOneList() async{
    BaseResp<List> baseResp = await DioUtil().request<List>(Method.get, WanAndroidApi. THREE_LEVEL_LINKAGE_ONE);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    List<ThreeLevellLinkageOneModel> ThreeLevellLinkageOneModels;
    if(baseResp.data != null){
      ThreeLevellLinkageOneModels = baseResp.data.map((value){
        return ThreeLevellLinkageOneModel.fromJson(value);
      }).toList();
    }
    return ThreeLevellLinkageOneModels;
  }

  //获取活动列表三级联动（二级社区列表）
  Future<List<ThreeLevellLinkageTwoModel>>  threeLevellLinkageTwoList(String id) async{
    BaseResp<List> baseResp = await DioUtil().request<List>(Method.get, WanAndroidApi. THREE_LEVEL_LINKAGE_TWO,data:{'sysOrgCode':id});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    List<ThreeLevellLinkageTwoModel> ThreeLevellLinkageTwoModels;
    if(baseResp.data != null){
      ThreeLevellLinkageTwoModels = baseResp.data.map((value){
        return ThreeLevellLinkageTwoModel.fromJson(value);
      }).toList();
    }
    return ThreeLevellLinkageTwoModels;
  }

  //获取活动列表三级联动（三级社区列表）
  Future<List<ThreeLevellLinkageThreeModel>>  threeLevellLinkageThreeList(String id) async{
    BaseResp<List> baseResp = await DioUtil().request<List>(Method.get, WanAndroidApi. THREE_LEVEL_LINKAGE_THREE,data:{'village':id});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    List<ThreeLevellLinkageThreeModel> ThreeLevellLinkageThreeModels;
    if(baseResp.data != null){
      ThreeLevellLinkageThreeModels = baseResp.data.map((value){
        return ThreeLevellLinkageThreeModel.fromJson(value);
      }).toList();
    }
    return ThreeLevellLinkageThreeModels;
  }

  //注册推送平台到后台
  Future registerMessage({platform,pushToken}) async{
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request(Method.post, WanAndroidApi.REGISTER_MESSAGE,
        data: {"platform":platform,"token":pushToken,"mobile":SpUtil.getString(Constant.key_login_name),"appcode":"office"});
  }

  Future<List<BannerModel>> getBanner() async {
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.getPath(path: WanAndroidApi.BANNER));
    List<BannerModel> bannerList;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      bannerList = baseResp.data.map((value) {
        return BannerModel.fromJson(value);
      }).toList();
    }
    return bannerList;
  }

  Future<List<ReposModel>> getArticleListProject(int page) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
            Method.get,
            WanAndroidApi.getPath(
                path: WanAndroidApi.ARTICLE_LISTPROJECT, page: page));
    List<ReposModel> list;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      ComData comData = ComData.fromJson(baseResp.data);
      list = comData.datas.map((value) {
        return ReposModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  Future<List<ReposModel>> getArticleList({int page, data}) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.get,
            WanAndroidApi.getPath(path: WanAndroidApi.ARTICLE_LIST, page: page),
            data: data);
    List<ReposModel> list;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      ComData comData = ComData.fromJson(baseResp.data);
      list = comData.datas.map((value) {
        return ReposModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  Future<List<TreeModel>> getTree() async {
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.getPath(path: WanAndroidApi.TREE));
    List<TreeModel> treeList;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      treeList = baseResp.data.map((value) {
        return TreeModel.fromJson(value);
      }).toList();
    }
    return treeList;
  }

  Future<List<ReposModel>> getProjectList({int page: 1, data}) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(Method.get,
            WanAndroidApi.getPath(path: WanAndroidApi.PROJECT_LIST, page: page),
            data: data);
    List<ReposModel> list;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      ComData comData = ComData.fromJson(baseResp.data);
      list = comData.datas.map((value) {
        return ReposModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  Future<List<ReposModel>> getWxArticleList({int id, int page: 1, data}) async {
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil()
        .request<Map<String, dynamic>>(
        Method.get,
            WanAndroidApi.getPath(
                path: WanAndroidApi.WXARTICLE_LIST + '/$id', page: page),
            data: data);
    List<ReposModel> list;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      ComData comData = ComData.fromJson(baseResp.data);
      list = comData.datas.map((value) {
        return ReposModel.fromJson(value);
      }).toList();
    }
    return list;
  }

  Future<List<TreeModel>> getWxArticleChapters() async {
    BaseResp<List> baseResp = await DioUtil().request<List>(Method.get,
        WanAndroidApi.getPath(path: WanAndroidApi.WXARTICLE_CHAPTERS));
    List<TreeModel> treeList;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      treeList = baseResp.data.map((value) {
        return TreeModel.fromJson(value);
      }).toList();
    }
    return treeList;
  }

  Future<List<TreeModel>> getProjectTree() async {
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.getPath(path: WanAndroidApi.PROJECT_TREE));
    List<TreeModel> treeList;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      treeList = baseResp.data.map((value) {
        return TreeModel.fromJson(value);
      }).toList();
    }
    return treeList;
  }

  //发送验证码
  Future<bool> sendVerify({mobile}) async {
    BaseResp baseResp = await DioUtil().request(Method.get, WanAndroidApi.USER_VALIDCODE,
        data: {"mobile":mobile});
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    return true;
  }

  //登录
  Future login({username,password,type,code,address,idcard,invite}) async {
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.USER_APPLOGIN,
        data: {"mobile":username,"code":code,"type":type,"password":password,"address":address,"idcard":idcard,"invite":invite});

    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }
  //手机号码校验
  Future checkMobile(String mobile) async {
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.CHECK_MOBILE,
        data: {"mobile":mobile});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }
  //绑定组织机构
  Future bindOrg({tokens,orgCode,random}) async {
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.USER_BINDORG,
        data: {"tokens":tokens,"orgCode":orgCode,"random":random});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }

  //获取banner图
  Future baneners() async{
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.WORK_BANNER);
    List<BannerModel> bannerList;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      bannerList = baseResp.data.map((value) {
        return BannerModel.fromJson(value);
      }).toList();
    }
    return bannerList;
  }

  //获取模块列表
  Future<List<ModuleModel>> getModuleList() async{
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.WORK_MODULE_LIST);
    List<ModuleModel> moduleList;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      moduleList = baseResp.data.map((value) {
        return ModuleModel.fromJson(value);
      }).toList();
    }
    return moduleList;
  }

  //获取工作通知列表
  Future<Map<String,dynamic>> getWorkArticleList(int page,{type}) async{
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil().request<Map<String, dynamic>>(
        Method.get, WanAndroidApi.WORK_ARTICLE_LIST,
        data:{"pageNo":page,"type":type});
    List<WorkArticleModel> workArticle = [];
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    Map<String,dynamic> result = {};
    if (baseResp.data != null) {
      RowsData comData = RowsData.fromJson(baseResp.data);
      result["hasMore"] = comData.lastPage;
      workArticle = comData.list.map((value) {
        return WorkArticleModel.fromJson(value);
      }).toList();
      result["workArticle"] = workArticle;
    }
    return result;
  }
  //获取文章详情
  Future<WorkArticleModel> getWorkArticleVideoDetail(String id) async{
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil().request<Map<String, dynamic>>(
        Method.get, WanAndroidApi.WORK_ARTICLE_DETAIL + id);
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    WorkArticleModel workArticleModel;
    if (baseResp.data != null) {
      workArticleModel = WorkArticleModel.fromJson2(baseResp.data);
    }
    return workArticleModel;
  }

  //获取工作通知分类列表
  Future<List<TreeModel>> getWorkArticleTree(String name) async{
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil().request<Map<String, dynamic>>(
        Method.get, WanAndroidApi.DICTIONARY_LIST,data: {"name":name});
    List<TreeModel> treeModels;
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    if (baseResp.data != null) {
      List dictList = baseResp.data[name];
      treeModels = dictList.map((value) {
        DictionaryModel dict = DictionaryModel.fromJson(value);
        return TreeModel.fromJson(dict.toTreeModelJson());
      }).toList();
    }
    return treeModels;
  }

  //获取字典表
  Future<Map<String,dynamic>> getDictionary(String name) async{
    BaseResp<Map<String, dynamic>> baseResp = await DioUtil().request<Map<String, dynamic>>(
        Method.get, WanAndroidApi.DICTIONARY_LIST,data: {"name":name});
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }

  //获取个人信息
  Future<UserInfoModel> getUserInfo() async{
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request<Map<String,dynamic>>(
        Method.get, WanAndroidApi.USER_INFOS);
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    UserInfoModel userInfoModel;
    if (baseResp.data != null) {
      userInfoModel = UserInfoModel.fromJson(baseResp.data);
    }
    return userInfoModel;
  }

  //修改个人信息
  Future<Null> modifyUserInfo(Map<String,dynamic> json) async{
    DioUtil().request(Method.post, WanAndroidApi.MODIFY_USERINFO,
    data: json
    );
  }

  //修改密码信息
  Future<Null> modifyPasswd(Map<String,dynamic> json) async{
    DioUtil().request(Method.post, WanAndroidApi.MODIFY_PASSWORD,
        data: json
    );
  }

  //重置个人信息
  Future<Null> resetPasswd(Map<String,dynamic> json) async{
    DioUtil().request(Method.post, WanAndroidApi.RESET_PASSWORD,
        data: json
    );
  }

  //获取共商共治联系人列表
  Future<List<ContactUserModel>> getChatUserList() async{
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.CHAT_USER_LIST);
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

  //根据组织机构获取联系人列表
  Future<List<ContactUserModel>> getChatUserListByOrgCode(String orgCode) async{
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.CHAT_GROUP_USER,data: {'orgCode':orgCode});
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

  //获取组织机构列表
  Future<List<DepartModel>> getDepartList() async{
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.CHAT_GROUP_LIST);
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    List<DepartModel> departList;
    if (baseResp.data != null) {
      departList = baseResp.data.map((value) {
        return DepartModel.fromJson(value);
      }).toList();
    }
    return departList;
  }

  //我的个人中心统计数据
  Future<MineCountData> getUserCount() async{
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request<Map<String,dynamic>>(
        Method.get, WanAndroidApi.WORK_COUNTDATA);
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    MineCountData mineCountData;
    if (baseResp.data != null) {
      mineCountData = MineCountData.fromJson(baseResp.data);
    }
    return mineCountData;
  }

  //上传base64图片
  Future<List<ImageFileData>> uploadBase64(String base64) async{
    base64 = "data:image/jpg;base64,"+base64.trim().replaceAll("\n", "");
    FormData formData = new FormData.from({
      "baseImage_1": base64
    });
    BaseResp<List> baseResp = await DioUtil().request<List>(Method.post,WanAndroidApi.UPLOAD_IMAGE,data:formData);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    List<ImageFileData> images;
    images = baseResp.data.map((value){
      return ImageFileData.fromJson(value);
    }).toList();
    return images;
  }

  //图片上传
  Future<List<ImageFileData>> uploadImage(File file) async{
    BaseResp<List> baseResp = await DioUtil().requestFile<List>(WanAndroidApi.UPLOAD_IMAGE, file);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    List<ImageFileData> images;
    images = baseResp.data.map((value){
      return ImageFileData.fromJson(value);
    }).toList();
    return images;
  }

  //邀请居民
  Future<BaseResp> invitePerson({String mobile,String realname}) async{
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.INVITE_PERSON,
    data:{"mobile":mobile,"realname":realname});

    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }

    return baseResp;
  }

  //关注某人
  Future<BaseResp> focus({String type,String id,String method}) async{
    BaseResp baseResp = await DioUtil().request(method, WanAndroidApi.COLLECT+type+"/"+id);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp;
  }

  //取消关注
  Future<BaseResp> unfocus({String type,String id}) async{
    BaseResp baseResp = await DioUtil().request(Method.post, WanAndroidApi.DELCOLLECT+type+"/"+id);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp;
  }

  //我的关注列表
  Future<List<CollectModel>> getFocusList(int page,{type}) async{
    BaseResp<List> baseResp = await DioUtil().request<List>(
        Method.get, WanAndroidApi.COLLECTLIST+type,
        data:{"pageNo":page});
    List<CollectModel> collectModel = [];
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    Map<String,dynamic> result = {};
    if (baseResp.data != null) {
      collectModel = baseResp.data.map((value) {
        return CollectModel.fromJson(value);
      }).toList();
    }
    return collectModel;
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


}
