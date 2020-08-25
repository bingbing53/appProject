import 'apis.dart';

//用户端api接口
class ConsumerApis {

  //app版本更新
  static const String APP_VERSION = "community-user/api/app/version";

  ///图片上传
  static const String UPLOAD_IMAGE = "community-user/api/common/upload?action=uploadimage";

  //注册平台推送
  static const String REGISTER_MESSAGE = "community-message/api/estate/message/register";

  ///我的小区
  static const String MINE_ESTATE = "community-estate/api/portal/estate/info";
  ///我的门禁
  static const String MINE_ESTATE_DOOR = "community-estate/api/portal/estate/list";
  ///远程开门
  static const String REMOTE_DOOR = "community-estate/api/portal/estate/remoteOpen/";
  ///访客密码
  static const String VISITOR_PWD = "community-estate/api/portal/estate/tempPwd";
  ///设备权限列表
  static const String DEVICE_INFO_LIST = "community-estate/api/portal/estate/devInfos";
  ///物业文章
  static const String ESTATE_ARTICLE_LIST = "community-estate/api/portal/estate/estateArticleList";
  ///绑定的物业信息
  static const String BIND_ESTATE_INFO = "community-estate/api/portal/estate/dinfo";

  //根据经纬度获取最近的部门
  static const String LOCATION_SEARCH = "community-user/api/common/getDepartByLonlat/";
  ///区域选择
  static const String LOCATION_SELECT = "community-user/portal/getArea";
  ///登录接口
  static const String LOGIN = "community-server/api/portal/login";
  ///微信登录接口
  static const String WXMPLOGIN = "community-server/api/portal/auth/mpLogin";
  ///苹果登录
  static const String APPLELOGIN = "community-server/api/portal/auth/checkIdentifyToken";
  ///支付宝登陆接口
  static const String ALILOGIN = "community-server/api/portal/auth/aliLogin";
  ///支付宝生成参数
  static const String GENAliParam = "community-server/api/portal/auth/genAliParam";
  ///验证码
  static const String VERIFY = "community-server/api/portal/sendVerify/";
  ///获取用户基本信息
  static const String INFO = "community-server/api/portal/info";
  //退出登录
  static const String LOGOUT = "community-server/api/portal/logout";
  ///轮播图
  static const String BANNER_LIST = "community-server/api/portal/banners";
  ///获取我的二维码
  static const String MINE_QRCODE = "community-server/api/portal/getQRCode";

  ///获取文章列表
  static const String ARTICLE_LIST = "community-cms/api/portal/v1/article/list";
  ///获取文章分类列表
  static const String ARTICLE_CATEGORY = "community-cms/api/portal/v1/article/category";
  ///获取关注的文章用户列表
  static const String FOCUS_ARTICLE_USER = "community-cms/api/portal/v1/article/focusList";
  ///获取社区的统计信息
  static const String ARTICLE_USER_STATICS = "community-cms/api/portal/v1/article/departStatis/";
  ///是否关注或收藏
  static const String IS_FOCUSED = "community-server/api/portal/behavior/collect/";

  ///获取投票调查列表
  static const String SURVEY_LIST = "community-cms/api/portal/v1/vote/list";

  ///获取我绑定的社区信息
  static const String MINE_ORG_INFO = "community-server/api/portal/orgInfo";
  ///绑定社区
  static const String BIND_ORG = "community-server/api/portal/bind";
  ///活动列表
  static const String ACTIVITY_LIST = "community-cms/api/portal/v1/activity/list";

  ///搜索推荐
  static const String SEARCH_HINTS = "community-cms/api/portal/v1/search/searchHint";

  ///从es中搜索商品
  static const String SEARCH_PRODUCT = "community-mall/api/client/esProduct/search";
  ///从es中搜索活动
  static const String SEARCH_ACTIVITY = "community-cms/api/portal/v1/search/searchActivity";
  ///从es中搜索文章
  static const String SEARCH_ARTICLE = "community-cms/api/portal/v1/search/searchArticle";

  ///微信支付接口
  static const String WECHAT_ORDER_PAY = "community-mall/api/client/pay/createWxPayParam";
  ///支付宝支付接口
  static const String ALI_ORDER_PAY = "community-mall/api/client/pay/createAliPayParam";
  ///首页获取商品接口
  static const String INDEX_PRODUCT_LIST = "community-mall/api/client/product/queryListByCategory";

  ///==========================下方待删除

  ///字典表列表
  static const String DICTIONARY = "wechatComm/dictionary";

  ///文章列表
//  static const String ARTICLE_LIST = "article/list/";
  ///文章详情
  static const String ARTICLE_DETAIL = "article/detail/";
  ///文章推荐
  static const String ARTICLE_RECOMMEND = "article/recommend/";
  ///文章点赞、阅读、浏览
  static const String ARTICLE_BROWSE = "behavior/browse/";//新增文章浏览
  static const String ARTICLE_PRAISE = "behavior/praise/";//文章点赞
  static const String ARTICLE_CANCEL_PRAISE = "behavior/cancelPraise/";//取消文章点赞
  static const String ARTICLE_COLLECT = "behavior/collect/";//文章收藏
  static const String ARTICLE_CANCEL_COLLECT = "behavior/delCollect/";//取消文章收藏
  static const String ARTICLE_REVIEW = "behavior/review/";//获取文章评论
  static const String ARTICLE_SUBMIT_REVIEW = "behavior/review/1/";//提交文章评论
  static const String ARTICLE_HOME = "article/home/";//主页

  ///分享
  static const String SHARE_WX_LINK = "wechatComm/getRealmName";

  ///获取社区列表
  static const String COMMLIST = "wechatComm/commList";//获取社区列表

  ///活动列表
//  static const String ACTIVITY_LIST = "activity/list";
  ///活动详情
  static const String ACTIVITY_DETAIL = "activity/";
  ///活动报名
  static const String ACTIVITY_SIGNUP = "activity/signUp/";
  ///活动总结
  static const String ACTIVITY_SUMMARY = "activity/summary/";
  ///积分列表展示
  static const String ACTIVITY_SIGNLIST= "activity/integralDisplay/";
  ///签到
  static const String ACTIVITY_SIGNIN= "activity/signin/";

  ///消息列表
  static const String MESSAGE_LIST = "appUser/messageCount";
  ///消息详情列表
  static const String MESSAGE_DETAIL_LIST = "appUser/message";
  ///更新消息已读状态
  static const String MESSAGE_UPDATE_READ = "appUser/updateMessage";


  ///投票调查列表
  static const String VOTE_LIST= "vote/list";
  ///投票调查详情
  static const String VOTE_DETAIL= "vote/detail/";
  ///投票给个人
  static const String SUBMIT_VOTE = "vote/praise/";

  ///办事
  static const String TRADER_LIST = "trader/list";
  ///办事详情
  static const String TRADER_DETAIL = "trader/detail/";
  ///提交预约信息
  static const String TRADER_ORDER = "trader/order/";
  ///取消预约
  static const String TRADER_CANCEL_ORDER = "trader/cancel/";

  ///获取验证码
  static const String SEND_VERIFY_CODE = "wechatComm/sendVerify";
  ///登录
//  static const String LOGIN = "appUser/login";
  ///退出
//  static const String LOGOUT = "appUser/logout";
  ///注册
  static const String REGISTER = "appUser/register";
  ///保存性别、头像、昵称
  static const String SAVE_PERSON_INRO = "wechatComm/savePersonInfo";
  ///修改密码
  static const String UPDATE_PWD = "wechatComm/updatePwd";

  ///城市列表
  static const String CITY_LIST = "wechatComm/cityList";
  ///区县列表
  static const String AREA_LIST = "wechatComm/areaList";
  ///街道列表
  static const String STREET_LIST = "wechatComm/streetList";
  ///社区列表
  static const String COMM_LIST = "wechatComm/commListByStreet";
  ///获取民呼我应页面基础信息
  static const String BASE_INFO = "wechatComm/getBaseInfo";
  ///随手拍问题类别
  static const String TYPE_LIST = "wechatComm/typeList";
  ///书记信箱
  static const String SEND_WILLRECORD = "takePicture/willRecord";

  ///我的个人信息
  static const String MINE_INFOS = "mine/infos";
  ///获取我的认证等级
  static const String CERTIFICATION_STEP = "wechatComm/getCertificateStep";
  ///我参与过的统计
  static const String MINE_COUNT = "mine/index";
  ///用户参与过的行动
  static const String USER_BEHAVIOR = "behavior/count/1,10";
  ///获取认证状态信息
  static const String CERTIFICATION_INFO = 'wechatComm/getCertificateInfo';

  //get请求需要登录
  static const List GETNeedLogin = [
    ACTIVITY_SIGNUP,ACTIVITY_SIGNIN,
    SUBMIT_VOTE,
    TRADER_ORDER,TRADER_CANCEL_ORDER,
    SEND_WILLRECORD
  ];
  //post请求需要登录
  static const List POSTNeedLogin = [
    ARTICLE_COLLECT,ARTICLE_CANCEL_COLLECT,
    ARTICLE_PRAISE,ARTICLE_CANCEL_PRAISE,
    ARTICLE_SUBMIT_REVIEW,
  ];
  //不登陆就不请求接口，直接返回null
  static const List ReturnNullValue = [
    ARTICLE_COLLECT,
    ARTICLE_PRAISE,
  ];

}