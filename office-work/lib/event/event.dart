class StatusEvent {
  String labelId;
  int status;
  var cid;
  dynamic obj;

  StatusEvent(this.labelId, this.status, {this.cid,this.obj});
}


//事件名称
class StatusEventConstant{

  //跳转登录页面
  static final String TO_LOGIN_PAGE = 'login';

  //刷新日程页面
  static final String REFRESH_CALENDAR_PAGE = 'refresh_calendar_page';

  //跳转聊天详情页面
  static final String JUMP_CHATPAGE = 'jump_chat_page';

  //刷新吹哨详情页面
  static final String REFRESH_BLOW_WILLRECORD_PAGE = 'refresh_blowwillrecord_page';

  //刷新任务详情页面
  static final String REFRESH_MISSION_DETAIL_PAGE = 'refresh_mission_detail_page';
}