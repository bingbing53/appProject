class CollectionEvent{
  final String widgetName;
  final String router;
  final bool isRemove;
  // token uid...
  CollectionEvent(this.widgetName,this.router,this.isRemove);
}

//办事预约
class TraderEvent{

  final String state;

  TraderEvent(this.state);
}

//列表是否需要刷新
class ListRefreshEvent{
  final String id;
  final bool refresh;
  ListRefreshEvent(this.id,this.refresh);
}

//跳转login的事件监听
class GotoLoginEvent{
  final String name;
  GotoLoginEvent(this.name);
}

//我的个人中心刷新数据
class MineIndexEvent{
  final String name;
  MineIndexEvent(this.name);
}