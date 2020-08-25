import 'package:estate/common/common.dart';

class WanAndroidApi {
  /// 首页banner http://www.wanandroid.com/banner/json
  static const String BANNER = "banner";

  /// 最新项目tab (首页的第二个tab) http://wanandroid.com/article/listproject/0/json
  static const String ARTICLE_LISTPROJECT = "article/listproject";

//  static const String WEBPAGR_PREFIX = "https://api.dev.shequyijia.cn/";
  static const String WEBPAGR_PREFIX = "https://mongo.qicaidonghu.cn/property/";

  //文件预览
  static const String FILEPREVIEW = "https://image.shequyijia.cn/onlinePreview?url=";

  /// 项目分类 http://www.wanandroid.com/project/tree/json
  static const String PROJECT_TREE = "project/tree";

  /// 项目列表数据 http://www.wanandroid.com/project/list/1/json?cid=294
  static const String PROJECT_LIST = "project/list";

  /// 体系数据 http://www.wanandroid.com/tree/json
  static const String TREE = "tree";

  /// 首页文章列表 http://www.wanandroid.com/article/list/0/json
  /// 知识体系下的文章 http://www.wanandroid.com/article/list/0/json?cid=60
  static const String ARTICLE_LIST = "article/list";

  /// 获取公众号列表 http://wanandroid.com/wxarticle/chapters/json
  static const String WXARTICLE_CHAPTERS = "wxarticle/chapters";

  /// 查看某个公众号历史数据 http://wanandroid.com/wxarticle/list/405/1/json
  /// 在某个公众号中搜索历史文章 http://wanandroid.com/wxarticle/list/405/1/json?k=Java
  static const String WXARTICLE_LIST = "wxarticle/list";

  static const String USER_REGISTER = "user/register"; //注册
  static const String USER_LOGIN = "user/login"; //登录
  static const String USER_LOGOUT = "user/logout"; //退出

  static String getPath({String path: '', int page, String resType: 'json'}) {
    StringBuffer sb = new StringBuffer(path);
    if (page != null) {
      sb.write('/$page');
    }
    if (resType != null && resType.isNotEmpty) {
      sb.write('/$resType');
    }
    return sb.toString();
  }

  //格式化图片地址
  static String format(String path,{int size = 1}){
    if(path == null || path.trim().length == 0 || path.startsWith('http') || path.split('.').length <= 1)
      return path;
    if(size == 1){
      path = path.split('.')[0]+'Zoom.'+path.split('.')[1];
      return Constant.test_pic_server+path;
    }
    return Constant.test_pic_server+path;
  }

  static String formatH5Path(String path){
    if(path == null || path.trim().length <= 0 || path.startsWith("http")){
      return path;
    }
    if(path.contains("?")){
      path += "&times=${new DateTime.now().millisecondsSinceEpoch}";
    }else{
      path += "?times=${new DateTime.now().millisecondsSinceEpoch}";
    }
//    return "http://192.168.1.112:8080"+path;
    return WEBPAGR_PREFIX+path;
  }

  //文件预览
  static String filePreview(String path,{int size = 1}){
    if(path.toLowerCase().endsWith(".jpg") || path.toLowerCase().endsWith(".png") || path.toLowerCase().endsWith(".jpeg")){
      return format(path,size:size);
    }
    return FILEPREVIEW + format(path,size:size);
  }
  //手机端登录
  static const String USER_APPLOGIN = "community-user/api/estate/user/login";

  //获取验证码
  static const String USER_VALIDCODE = 'community-user/api/estate/user/appVerify';
  ///手机号码校验
  static const String CHECK_MOBILE = 'community-user/api/estate/user/checkMobile';

  ///获取我自己的信息
  static const String USER_INFOS = 'community-user/api/estate/user/info';
  //注册平台推送
  static const String REGISTER_MESSAGE = "community-message/api/estate/message/register";
  //获取设备列表
  static const String DEVICE_LIST = "community-estate/api/estate/device/list";
  //开门
  static const String OPEN_DOOR = "community-estate/api/estate/device/openDoor/";
  //订单列表
  static const String ORDER_LIST = "community-estate/api/estate/order/list";
  //订单详情
  static const String ORDER_DETAIL = "community-estate/api/estate/order/detail";
  //客服接单
  static const String ORDER_TAKE = "community-estate/api/estate/order/take";
  //客服关闭订单
  static const String ORDER_CLOSE = "community-estate/api/estate/order/dontTake";
  //客服派单
  static const String ORDER_DISPATCHER = "community-estate/api/estate/order/dispatch";
  //完成订单
  static const String ORDER_FINISH = "community-estate/api/estate/order/finish";
  //员工接单
  static const String ORDER_EMP_TAKE = "community-estate/api/estate/order/empTake";
  //获取员工自己的时间列表
  static const String USER_TIME_MINELIST = "community-estate/api/estate/orderTime/list";
  //员工修改订单完成时间
  static const String ORDER_CHANGE_TIME = "community-estate/api/estate/order/changeTime";
  //员工拒绝接单
  static const String ORDER_EMP_DONTTAKE = "community-estate/api/estate/order/empDontTake";
  //获取员工列表
  static const String USER_LIST = "community-estate/api/estate/order/userList";
  //获取员工时间列表
  static const String USER_TIME_SCHEDULE = "community-estate/api/estate/orderTime/listByUser";
  //居民报事
  static const String USER_FEED_BACK = "community-estate/api/estate/feed/list";
  //上传报事
  static const String POST_USER_FEED_BACK = "community-estate/api/estate/feed/feedBack";
  //上传图片
  static const String UPLOAD_IMAGE = 'community-user/api/common/upload?action=uploadimage';
  ///根据订单获取聊天客服记录
  static const String ORDER_MESSAGE_LIST = "community-estate/api/estate/order/messageHistoryList";
  //app版本检测
  static const String APP_VERSION = 'community-user/api/app/version';
  ///获取文章详情
  static const String WORK_ARTICLE_DETAIL = 'community-cms/api/office/v1/article/detail/';

  //***************下面的都可以删了

  //通用上传文件
  static const String UPLOADFILE = 'wechatComm/uploadFile';

  //绑定组织机构
  static const String USER_BINDORG = 'user/bindOrg';
  //修改个人信息
  static const String MODIFY_USERINFO = 'user/modify';
  ///重置密码
  static const String RESET_PASSWORD = 'user/resetPasswd';
  ///修改密码
  static const String MODIFY_PASSWORD = 'user/modifyPasswd';

  //获取我自己的统计数据
  static const String WORK_COUNTDATA = 'work/countData';
  //邀请居民代表
  static const String INVITE_PERSON = 'work/invitePerson';

  //获取banner图
  static const String WORK_BANNER = 'work/banners';
  //获取所有权限列表
  static const String WORK_MODULE_LIST = 'module/list';
  //获取工作通知列表
  static const String WORK_ARTICLE_LIST = 'work/articleList';
  ///获取文章详情
  //获取字典表
  static const String DICTIONARY_LIST = 'work/dictionary';

  ///获取工商共治联系人列表
  static const String CHAT_USER_LIST = 'chat/list';
  ///获取组织部门列表
  static const String CHAT_GROUP_LIST = 'chat/streetDepartList';
  ///获取组织下的人员列表
  static const String CHAT_GROUP_USER = 'chat/getUserByOrgCode';

  //添加关注
  static const String COLLECT = 'motion/collect/';
  //删除关注
  static const String DELCOLLECT = 'motion/delCollect/';
  //获取关注列表
  static const String COLLECTLIST = 'motion/collectList/';
  ///创建任务
  static const String CREATE_MISSION = 'mission/create';
  ///任务列表
  static const String MISSION_LIST = 'mission/list';
  ///任务详情
  static const String SUB_MISSION_LIST = 'mission/detail/';
  ///转交任务
  static const String DELIVER_MISSION = 'mission/deliver/';
  ///任务消息
  static const String MISSION_MESSAGE = 'mission/message/';
  ///更新任务
  static const String MISSION_STATE_UPDATE = 'mission/updateState/';
  ///新建日程
  static const String CREATE_SCHEDULE = 'mission/saveSchedule';
  ///删除日程
  static const String DELETE_SCHEDULE = 'mission/deleteSchedule/';
  ///任务详情getMeeting
  static const String SCHEDULE_DETAIL = 'mission/scheduleDetail/';
  ///删除任务和吹哨的附件
  static const String DELETE_FILE  = 'mission/delete/';

  ///我的待办
  static const String MINE_PREPARE = 'mission/prepare';

  ///吹哨反馈
  static const String WILLBLOW_FEEDBACK = 'mission/blowillFeedBack/';
  ///创建会议
  static const String CREATE_MEETING = 'meeting/startMeeting';
  ///获取会议的详情
  static const String MEETING_DETAIL = 'meeting/getMeeting/';
  ///会议接受状态
  static const String MEETING_ACCEPT = 'meeting/accept/';
  ///取消会议
  static const String MEETING_CANCEL = 'meeting/cancel/';
  ///会议附件
  static const String MEETING_FILE = 'meeting/meetingFile/';
  ///吹哨将人默认带过来
  static const String WILL_MEETING_USERLIST = 'meeting/getMeetingDefaultUser';

  ///根据群聊编号获取群组详情
  static const String GROUP_MEETING_DETAIL = 'meeting/meetingDetail/';

  ///民意详情
  static const String WILLRECORD_DETAIL = 'work/willRecordDetail/';

  //文章详情
  static const String ARTICLE_DETAIL_PREFIX = WEBPAGR_PREFIX+'/#/articleDetail?id=';
  //我的小组
  static const String MYGROUP = WEBPAGR_PREFIX+"/#/group";
  //个人的工作记录
  static const String MINE_WORK_HISTORY = WEBPAGR_PREFIX+"/#/worksort?type=-997&code=0&id=#id#";
  //民情民意
  static const String WILL_RECORD_LIST = WEBPAGR_PREFIX+"/#/publicopinion?type=1";
  //新增工作记录
  static const String ADD_WORKHISTORY = WEBPAGR_PREFIX+'/#/torecord';
  //工作记录详情
  static const String WORKRECORD_DETAIL = WEBPAGR_PREFIX + '/#/hisDetail?id=';
  //app下载链接
  static const String APP_DOWNLOAD = WEBPAGR_PREFIX + '/#/download';
}
