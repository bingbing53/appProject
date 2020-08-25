//接口地址
class Api{
  //前缀
  static const String BASE_URL = "https://mongo.qicaidonghu.cn/server/rest/wechat/";
  static const String BASE_PICTURE_URL = "https://image.shequyijia.cn/pic/";

  static const String DICTIONARY = "wechatComm/dictionary";//字典表

  //文章列表
  static const String ARTICLE_LIST = "article/list/";
  //文章详情
  static const String ARTICLE_DETAIL = "article/detail/";
  //文章推荐
  static const String ARTICLE_RECOMMEND = "article/recommend/";
  //文章点赞、阅读、浏览
  static const String ARTICLE_BROWSE = "behavior/browse/";//新增文章浏览
  static const String ARTICLE_PRAISE = "behavior/praise/";//文章点赞
  static const String ARTICLE_CANCEL_PRAISE = "behavior/cancelPraise/";//取消文章点赞
  static const String ARTICLE_COLLECT = "behavior/collect/";//文章收藏
  static const String ARTICLE_CANCEL_COLLECT = "behavior/delCollect/";//取消文章收藏
  static const String ARTICLE_REVIEW = "behavior/review/";//获取文章评论
  static const String ARTICLE_SUBMIT_REVIEW = "behavior/review/1/";//提交文章评论
  static const String ARTICLE_HOME = "article/home/";//主页

  //分享
  static const String SHARE_WX_LINK = "wechatComm/getRealmName";

  static const String COMMLIST = "wechatComm/commList";//获取社区列表

  //活动列表
  static const String ACTIVITY_LIST = "activity/list";
  //活动详情
  static const String ACTIVITY_DETAIL = "activity/";
  //活动报名
  static const String ACTIVITY_SIGNUP = "activity/signUp/";
  //活动总结
  static const String ACTIVITY_SUMMARY = "activity/summary/";
  //积分列表展示
  static const String ACTIVITY_SIGNLIST= "activity/integralDisplay/";
  //签到
  static const String ACTIVITY_SIGNIN= "activity/signin/";

  //消息列表
  static const String MESSAGE_LIST = "appUser/messageCount";
  //消息详情列表
  static const String MESSAGE_DETAIL_LIST = "appUser/message";
  //更新消息已读状态
  static const String MESSAGE_UPDATE_READ = "appUser/updateMessage";


  //投票调查列表
  static const String VOTE_LIST= "vote/list";
  //投票调查详情
  static const String VOTE_DETAIL= "vote/detail/";
  //投票给个人
  static const String SUBMIT_VOTE = "vote/praise/";

  //办事
  static const String TRADER_LIST = "trader/list";
  //办事详情
  static const String TRADER_DETAIL = "trader/detail/";
  //提交预约信息
  static const String TRADER_ORDER = "trader/order/";
  //取消预约
  static const String TRADER_CANCEL_ORDER = "trader/cancel/";


  //城市列表
  static const String CITY_LIST = "wechatComm/cityList";
  //区县列表
  static const String AREA_LIST = "wechatComm/areaList";
  //街道列表
  static const String STREET_LIST = "wechatComm/streetList";
  //社区列表
  static const String COMM_LIST = "wechatComm/commListByStreet";
  //获取民呼我应页面基础信息
  static const String BASE_INFO = "wechatComm/getBaseInfo";
  //获取验证码
  static const String SEND_VERIFY_CODE = "wechatComm/sendVerify";
  //登录
  static const String LOGIN = "appUser/login";
  //退出
  static const String LOGOUT = "appUser/logout";
  //注册
  static const String REGISTER = "appUser/register";
  //保存性别、头像、昵称
  static const String SAVE_PERSON_INRO = "wechatComm/savePersonInfo";
  //修改密码
  static const String UPDATE_PWD = "wechatComm/updatePwd";
  //随手拍问题类别
  static const String TYPE_LIST = "wechatComm/typeList";
  //书记信箱
  static const String SEND_WILLRECORD = "takePicture/willRecord";

  //我的个人信息
  static const String MINE_INFOS = "mine/infos";
  //获取我的认证等级
  static const String CERTIFICATION_STEP = "wechatComm/getCertificateStep";
  //我参与过的统计
  static const String MINE_COUNT = "mine/index";
  //用户参与过的行动
  static const String USER_BEHAVIOR = "behavior/count/1,10";
  //获取验证码
  static const String USER_QRCODE = 'wechatComm/getQRCode';
  //检验扫码的活动码
  static const String CHECK_SCAN_CODE = 'activity/getActivityByCode';
  //提交签到信息
  static const String SUBMIT_ACTIVITY_SIGN = 'activity/activityByCodeConfirm';

  //格式化图片地址
  static String formatPicture(String url,[type = 0]){
      if(url != null && url.length > 0){
        if(type == 0){
          return url!=null&&url.length>0?(url.startsWith("http")?url:BASE_PICTURE_URL+url):"";
        }else if(type == 480) {
          return url.startsWith("http") ? url : BASE_PICTURE_URL + url.split('.')[0] + "Zoom." + url.split('.')[1];
        }
      }
      return "";
  }

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
    SUBMIT_VOTE
  ];
  //不登陆就不请求接口，直接返回null
  static const List ReturnNullValue = [
    ARTICLE_COLLECT,
    ARTICLE_PRAISE,
  ];

}