
//居民app

import 'dart:io';
import 'dart:convert' as convert;
import 'package:amap_base_location/amap_base_location.dart';
import 'package:helloworld/common/common.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/common/net_utils.dart';
import 'package:helloworld/common/sql.dart';
import 'package:helloworld/components/first_page_item.dart';
import 'package:helloworld/data/api/consumer_apis.dart';
import 'package:helloworld/data/net/dio_util.dart';
import 'package:helloworld/data/protocol/consumer_models.dart';
import 'package:helloworld/utils/util_index.dart';

class ConsumerRepository {

  final String table = 'user';
  Sql sql;

  //版本更新
  Future<VersionModel> getVersion(String platform) async{
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request<Map<String,dynamic>>(
        Method.get, ConsumerApis.APP_VERSION,data:{'platform':platform});
    if (baseResp.code != Constant.status_success) {
      return new Future.error(baseResp.msg);
    }
    VersionModel versionModel;
    if (baseResp.data != null) {
      versionModel = VersionModel.fromJson(baseResp.data);
    }
    return versionModel;
  }

  //获取搜索的结果
  Future<String> getQRCodeResult() async{
    BaseResp<String> baseResp = await DioUtil().request(Method.get, ConsumerApis.MINE_QRCODE);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }

  //获取搜索的结果
  Future<Map> getSearchResult(String keywords,int type,int pageNo,Location locate) async{
    String typeValue = 'all';
    if(type == 1) typeValue = 'pms';
    else if(type == 2) typeValue = 'article';
    else if(type == 3) typeValue = 'activity';
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request(Method.get, ConsumerApis.SEARCH_PRODUCT,data: {'keyword':keywords,'location':'street','hint':'0','type':typeValue,'pageNum':pageNo,'pageSize':14,
      'latitude':locate!= null ? locate.latitude : '',
      'longitude':locate!= null ? locate.longitude :''
    });
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data['data'];
  }
  //获取活动搜索结果
  Future<Map> getSearchESActivityResult(String keywords,int pageNo) async {
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request(Method.get, ConsumerApis.SEARCH_ACTIVITY,data:{'name':keywords,'pageNo':pageNo,'pageSize':15});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }
  //获取文章搜索结果
  Future<Map> getSearchESArticleResult(String keywords,int pageNo) async {
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request(Method.get, ConsumerApis.SEARCH_ARTICLE,data:{'name':keywords,'pageNo':pageNo,'pageSize':15});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }

  //获取搜索的词
  Future<Map> getSearchHints(String keywords,int type,String hint) async{
    String typeValue = 'all';
    if(type == 1) typeValue = 'pms';
    else if(type == 2) typeValue = 'article';
    else if(type == 3) typeValue = 'activity';
    BaseResp<Map> baseResp = await DioUtil().request(Method.get, ConsumerApis.SEARCH_HINTS,
        data:{
          'name':keywords,
          'hint':hint,
          'type':typeValue,
          'pageNo':0,
          'pageSize':15
        }
        );
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }

  //社区轮播图
  Future<List<BannersModel>> bannerList(String categoryType) async{
    BaseResp<List> baseResp = await DioUtil().request(Method.get, ConsumerApis.BANNER_LIST,data:{'type':categoryType});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    List<BannersModel> banners;
    if(baseResp.data != null){
      banners = baseResp.data.map((value){
        return BannersModel.fromJson(value);
      }).toList();
    }
    return banners;
  }

  //获取商品列表
  Future<List<MallProdcutInfoModel>> getMallProductList(int page) async{
    var param = {
      'categoryCode': 'all',
      'location': 'street',
      'distance': '',
      'sort': '',
      'pageNum': page,
      'pageSize': 10,
      'search': "",
      'latitude': "0",
      'longitude': "0"
    };
    BaseResp baseResp = await DioUtil().request(Method.get, ConsumerApis.INDEX_PRODUCT_LIST, data: param);
    print('----------------');
    print(baseResp);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    List<MallProdcutInfoModel> articles;
    if(baseResp.data != null){
      Map<String,dynamic> dataMap = baseResp.data['data'];
      print(dataMap.toString());
      List list = dataMap['list'];
      articles = list.map((value){
        print(value);
        return MallProdcutInfoModel.fromJson(value);
      }).toList();
    }
    return articles;
  }

  //支付宝支付
  Future<String> aliOrderPay(String orderId) async{
      BaseResp baseResp = await DioUtil().request(
          Method.get, ConsumerApis.ALI_ORDER_PAY, data: {'orderSn': orderId});
      if (baseResp.code != Constant.status_success) {
        return new Future.error(baseResp.msg);
      }
      return baseResp.data['data'];
  }

  //微信支付
  Future<WxPayInfoModel> wechatOrderPay(String orderId) async{
    BaseResp baseResp = await DioUtil().request(Method.get,ConsumerApis.WECHAT_ORDER_PAY,data: {'orderSn':orderId});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    WxPayInfoModel wxPayInfoModel;
    if(baseResp.data != null){
      var data = baseResp.data['data'];
      try {
        wxPayInfoModel = WxPayInfoModel.fromJson(data);
      }catch(err){
        print('接口错误$err');
      }
    }
    return wxPayInfoModel;
  }

  //图片上传
  Future uploadImage(File file) async{
    BaseResp baseResp = await DioUtil().requestFile(ConsumerApis.UPLOAD_IMAGE, file);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }

  //注册平台到后台
  Future registerMessage({platform,pushToken}) async{
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request(Method.post, ConsumerApis.REGISTER_MESSAGE,
        data: {"platform":platform,"token":pushToken,"mobile":SpUtil.getString(Constant.key_login_name),"appcode":"shequyijia"});
  }

  //绑定组织机构
  Future bindOrg(String orgCode) async{
      BaseResp baseResp = await DioUtil().request(Method.post, ConsumerApis.BIND_ORG,data: {'sysOrgCode':orgCode});
  }

  //获取我绑定的组织信息
  Future<Map<String,SysDepartModel>> getMineOrg() async {
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request(Method.get, ConsumerApis.MINE_ORG_INFO);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    SysDepartModel sysDepartModel;
    Map<String,SysDepartModel> map = {};
    if(baseResp.data != null){
      var result = baseResp.data;
      SysDepartModel sysDepartModel = SysDepartModel.fromJson(result['street']);
      map['community'] = sysDepartModel;
      SysDepartModel sysDepartModel2 = SysDepartModel.fromJson(result['community']);
      map['street'] = sysDepartModel2;
    }
    return map;
  }

  //社区文章列表
  Future<List<ArticleModel>> articleList(int pageNo,String categoryType) async{
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request(Method.get, ConsumerApis.ARTICLE_LIST,data:{'pageNo':pageNo,'categoryType':categoryType});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    List<ArticleModel> articles;
    if(baseResp.data != null){
      List list = baseResp.data['result'];
      articles = list.map((value){
        return ArticleModel.fromJson(value);
      }).toList();
    }
    return articles;
  }

  //物业文章列表
  Future<List<FirstPageItem>> estateArticleList() async{
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request(Method.get, ConsumerApis.ESTATE_ARTICLE_LIST,data:{'pageNo':1,'pageSize':6});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    List<FirstPageItem> articles;
    if(baseResp.data != null){
      List list = baseResp.data['records'];
      articles = list.map((value){
        return FirstPageItem.fromJson(value);
      }).toList();
    }
    return articles;
  }

  //获取绑定的物业信息
  Future<Map<String,dynamic>> bindEstateInfo() async{
    BaseResp baseResp = await DioUtil().request(Method.get, ConsumerApis.BIND_ESTATE_INFO);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }

  //获取蓝牙设备权限列表
  Future<List> bluePermissionList() async{
    BaseResp<List> baseResp = await DioUtil().request(Method.get, ConsumerApis.DEVICE_INFO_LIST);
    print(baseResp);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }

  //创建访客临时密码
  Future<VisitorTempPwd> createTempPwd(VisitorTempPwd visitor) async {
    BaseResp baseResp = await DioUtil().request(Method.post,ConsumerApis.VISITOR_PWD,data:visitor.toJson());
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    VisitorTempPwd visitorTempPwd;
    if(baseResp.data != null){
      visitorTempPwd = VisitorTempPwd.fromJson(baseResp.data);
    }
    return visitorTempPwd;
  }

  //远程开门
  Future<bool> remoteOpenDoor(String id) async{
    BaseResp baseResp = await DioUtil().request(Method.post,ConsumerApis.REMOTE_DOOR+id);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return true;
  }

  //获取门禁列表
  Future<List<DeviceModel>> getDeviceList() async {
    BaseResp<List> baseResp = await DioUtil().request<List>(Method.get,ConsumerApis.MINE_ESTATE_DOOR);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    List<DeviceModel> devices;
    if(baseResp.data != null){
      devices = baseResp.data.map((value){
        return DeviceModel.fromJson(value);
      }).toList();
    }
    return devices;
  }


  //根据父id获取区域
  Future<List<SysDepartModel>> getDepartByParentId({String parentId = ''}) async {
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request(Method.get, ConsumerApis.LOCATION_SELECT,data:{'parentId':parentId});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    List<SysDepartModel> departs;
    if(baseResp.data != null){
      List list = baseResp.data['result'];
      departs = list.map((value){
        print(value);
        return SysDepartModel.fromJson(value);
      }).toList();
    }
    return departs;
  }

  //更新固定的展示信息
  Future<StaticInfo> getStaticInfo() async{
    String sysOrgCode = SpUtil.getString(SharedPreferencesKeys.sysOrgCode,defValue: '');
    String departName = SpUtil.getString(SharedPreferencesKeys.streetValue,defValue: '');
    String villageName = SpUtil.getString(SharedPreferencesKeys.streetValue,defValue: '请选择您居住的小区');
    StaticInfo staticInfo = new StaticInfo();
    staticInfo.departName = departName;
    staticInfo.sysOrgCode = sysOrgCode;
    staticInfo.villageName = villageName;
    return staticInfo;
  }

  //根据经纬度获取信息
  Future<List<SysDepartModel>> getDepartByLonlat(double longitude,double latitude,String departType) async {
    BaseResp<List> baseResp = await DioUtil().request<List>(Method.get,ConsumerApis.LOCATION_SEARCH + departType,data: {'longitude':longitude,'latitude':latitude});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    List<SysDepartModel> departs;
    if(baseResp.data != null){
      departs = baseResp.data.map((value){
        print(value);
        print('-------${value['departName']}');
        return SysDepartModel.fromJson(value);
      }).toList();
    }
    return departs;
  }

  //获取登录信息
  Future<BaseUserInfoModel> infos() async {
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request(Method.get,ConsumerApis.INFO);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    print('#########$baseResp');
    BaseUserInfoModel baseUserInfoModel;
    if(baseResp.data != null){
      baseUserInfoModel = BaseUserInfoModel.fromJson(baseResp.data);
    }
    return baseUserInfoModel;
  }
  //更新我的登录信息
  Future<bool> updateInfos(String headPath) async {
    BaseResp baseResp = await DioUtil().request(Method.put,ConsumerApis.INFO,data:{"headImage":headPath});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return true;
  }
  //保存登录信息
  Future saveLogin(Map<String,dynamic> baseuser) async {
    BaseUserInfoModel baseUserInfoModel = BaseUserInfoModel.fromJson(baseuser);
    sql = Sql.setTable(table);
    List json = await sql.getByCondition(conditions: {'mobile': baseUserInfoModel.mobile});
    if (json.isNotEmpty) {
      sql.delete('mobile', baseUserInfoModel.mobile);
    }
    sql.insert(baseUserInfoModel.toDBJson());
    SpUtil.putString(Constant.key_login_name, baseUserInfoModel.mobile);
  }

  //登录
  Future login(String mobile,String code,{String relateId = ""}) async{
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request(Method.post,ConsumerApis.LOGIN,data: {"mobile":mobile,"code":code,"type":1,"thirdUserId":relateId});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }
  //微信登录
  Future wxMpLogin(String code) async{
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request(Method.get,ConsumerApis.WXMPLOGIN,data: {"code":code});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }
  //苹果登录
  Future appleIdLogin(String code) async{
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request(Method.get,ConsumerApis.APPLELOGIN,data: {"identifyToken":code});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }
  //支付宝登录
  Future aliLogin(String code) async{
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request(Method.get,ConsumerApis.ALILOGIN,data: {"code":code});
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }
  //支付宝参数生成
  Future genAliLoginParam() async{
    BaseResp baseResp = await DioUtil().request(Method.get,ConsumerApis.GENAliParam);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }
  //退出登录
  Future logout() async{
    BaseResp<Map<String,dynamic>> baseResp = await DioUtil().request(Method.post,ConsumerApis.LOGOUT);
    if(baseResp.code != Constant.status_success){
      return new Future.error(baseResp.msg);
    }
    return baseResp.data;
  }

  //发送验证码
  Future sendVerify(String mobile) async {
     BaseResp baseResp = await DioUtil().request(Method.get,ConsumerApis.VERIFY+mobile);
     if(baseResp.code != Constant.status_success){
       return new Future.error(baseResp.msg);
     }
     return true;
  }

  // 通过mobile获取用户信息
  Future<BaseUserInfoModel> getUserByMobile(String mobile) async {
    sql = Sql.setTable(table);
    List json = await sql.getByCondition(conditions: {'mobile': mobile});
    if (json.isEmpty) {
      return null;
    }
    return new BaseUserInfoModel.fromJson(json.first);
  }

  //我的个人信息
  Future<ConsumerUserInfoModel> getConsumerUserInfo() async{
    Map<String,dynamic> resp = await NetUtils.get(ConsumerApis.MINE_INFOS);
    ConsumerUserInfoModel userInfoModel;
    if(ObjectUtil.isNotEmpty(resp)){
      userInfoModel = ConsumerUserInfoModel.fromJson(resp);
    }
    return userInfoModel;
  }

}