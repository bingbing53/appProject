
import 'package:helloworld/common/component_index.dart';

class ShequejiaApi {
  /// 首页banner http://www.wanandroid.com/banner/json
  static const String BANNER = "banner";

  /// 最新项目tab (首页的第二个tab) http://wanandroid.com/article/listproject/0/json
  static const String ARTICLE_LISTPROJECT = "article/listproject";

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
//    return "http://192.168.0.101:8080"+path;
    return "https://jmapp.dev.shequyijia.cn"+path;
  }

  //app版本检测
  static const String APP_VERSION = 'work/version';

  //通用上传文件
  static const String UPLOADFILE = 'wechatComm/uploadFile';

  //获取验证码
  static const String USER_VALIDCODE = 'user/appVerify';
  //手机端登录
  static const String USER_APPLOGIN = 'user/appLogin';
  //绑定组织机构
  static const String USER_BINDORG = 'user/bindOrg';
  ///获取我自己的信息
  static const String USER_INFOS = 'user/infos';
  //修改个人信息
  static const String MODIFY_USERINFO = 'user/modify';
  //获取我自己的统计数据
  static const String WORK_COUNTDATA = 'work/countData';
  //邀请居民代表
  static const String INVITE_PERSON = 'work/invitePerson';
  //上传图片
  static const String UPLOAD_IMAGE = 'wechatComm/upload';

  //获取banner图
  static const String WORK_BANNER = 'work/banners';
  //获取所有权限列表
  static const String WORK_MODULE_LIST = 'module/list';
  //获取工作通知列表
  static const String WORK_ARTICLE_LIST = 'work/articleList';

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

  ///民意详情
  static const String WILLRECORD_DETAIL = 'work/willRecordDetail/';


  //文章详情
  static const String ARTICLE_DETAIL_PREFIX = 'https://mongo.qicaidonghu.cn/work/#/articleDetail?id=';
  //我的小组
  static const String MYGROUP = "https://mongo.qicaidonghu.cn/work/#/group";
  //个人的工作记录
  static const String MINE_WORK_HISTORY = "https://mongo.qicaidonghu.cn/work/#/worksort?type=-997&code=0&id=#id#";
  //民情民意
  static const String WILL_RECORD_LIST = "https://mongo.qicaidonghu.cn/work/#/publicopinion";
  //新增工作记录
  static const String ADD_WORKHISTORY = 'https://mongo.qicaidonghu.cn/work/#/torecord';
}
