import 'dart:collection';

import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/repository/wan_repository.dart';

class ComListBloc implements BlocBase {
  BehaviorSubject<List<ReposModel>> _comListData = BehaviorSubject<List<ReposModel>>();

  Sink<List<ReposModel>> get _comListSink => _comListData.sink;

  Stream<List<ReposModel>> get comListStream => _comListData.stream;

  List<ReposModel> comList;


  ///工作通知列表
  BehaviorSubject<List> _comWorkArticleListData = BehaviorSubject<List>();

  Sink<List> get _comWorkArticleListSink => _comWorkArticleListData.sink;

  Stream<List> get comWorkArticleListStream => _comWorkArticleListData.stream;

  List comWorkArticleList;
  ///工作通知列表

//  ///我的收藏
//  BehaviorSubject<List<CollectModel>> _collectModelListData = BehaviorSubject<List<CollectModel>>();
//
//  Sink<List<CollectModel>> get _collectModelListSink => _collectModelListData.sink;
//
//  Stream<List<CollectModel>> get collectModelListStream => _collectModelListData.stream;
//
//  List<CollectModel> collectModelList;
//  ///工作通知列表

  int _comListPage = 1;

  BehaviorSubject<StatusEvent> _comListEvent = BehaviorSubject<StatusEvent>();

  Sink<StatusEvent> get _comListEventSink => _comListEvent.sink;

  Stream<StatusEvent> get comListEventStream =>
      _comListEvent.stream.asBroadcastStream();

  WanRepository wanRepository = new WanRepository();

  @override
  Future getData({String labelId, cid, int page}) {
    switch (labelId) {
      case Ids.titleWorkArticleTree:
        return getWorkArticle(labelId,cid,page);
        break;
      case Ids.titleFocus:
        return collectList(labelId,cid,page);
        break;
      case Ids.titleReposTree:
        return getRepos(labelId, cid, page);
        break;
      case Ids.titleWxArticleTree:
        return getWxArticle(labelId, cid, page);
        break;
      case Ids.titleSystemTree:
        return getArticle(labelId, cid, page);
        break;
      default:
        return Future.delayed(new Duration(seconds: 1));
        break;
    }
  }



  @override
  Future onLoadMore({String labelId, cid}) {
    int _page = 1;
    print('$_comListPage');
    _page = ++_comListPage;

    print("----------onLoadMore $cid   $_page");
    return getData(labelId: labelId, cid: cid, page: _page);
  }

  @override
  Future onRefresh({String labelId, String cid}) {
    print('-----------onRefresh $labelId  $cid');
    switch (labelId) {
      case Ids.titleWorkArticleTree:
        _comListPage = 1;
        break;
      case Ids.titleFocus:
        _comListPage = 1;
        break;
      case Ids.titleReposTree:
        _comListPage = 1;
        break;
      case Ids.titleWxArticleTree:
        _comListPage = 1;
        break;
      case Ids.titleSystemTree:
        _comListPage = 0;
        break;
      default:
        break;
    }

    return getData(labelId: labelId, cid: cid, page: _comListPage);
  }

  //获取收藏列表
  Future collectList(String labelId,cid,int page){
    return wanRepository.getFocusList(page,type:cid).then((result){
      List<CollectModel> list = result;
      if (comWorkArticleList == null) comWorkArticleList = new List();
      if (page == 1) {
        comWorkArticleList.clear();
      }
      comWorkArticleList.addAll(list);
      _comWorkArticleListSink.add(UnmodifiableListView(comWorkArticleList));
      _comListEventSink.add(new StatusEvent(labelId,
          ObjectUtil.isEmpty(list) ? RefreshStatus.noMore : RefreshStatus.idle,
          cid: cid));
    }).catchError((_){
      _comWorkArticleListData.sink.addError('error');
      _comListPage--;
      _comListEventSink.add(new StatusEvent(labelId, RefreshStatus.failed));
    });
  }

  //获取工作通知文章列表
  Future getWorkArticle(String labelId, cid, int page) async {
    print('----------请求page $page');
    return wanRepository.getWorkArticleList(page,type: cid).then((result) {
      List<WorkArticleModel> list = result['workArticle'];
      bool hasMore = result['hasMore'];
      if (comWorkArticleList == null) comWorkArticleList = new List();
      if (page == 1) {
        comWorkArticleList.clear();
      }
      comWorkArticleList.addAll(list);
      _comWorkArticleListSink.add(UnmodifiableListView(comWorkArticleList));
      _comListEventSink.add(new StatusEvent(labelId,
          hasMore ? RefreshStatus.noMore : RefreshStatus.idle,
          cid: cid));

    }).catchError((_) {
      _comListPage--;
      _comListEventSink.add(new StatusEvent(labelId, RefreshStatus.failed));
    });
  }

  Future getRepos(String labelId, int cid, int page) async {
    ComReq _comReq = new ComReq(cid);
    return wanRepository
        .getProjectList(page: page, data: _comReq.toJson())
        .then((list) {
      if (comList == null) comList = new List();
      if (page == 1) {
        comList.clear();
      }
      comList.addAll(list);
      _comListSink.add(UnmodifiableListView<ReposModel>(comList));
      _comListEventSink.add(new StatusEvent(labelId,
          ObjectUtil.isEmpty(list) ? RefreshStatus.noMore : RefreshStatus.idle,
          cid: cid));
    }).catchError((_) {
      _comListPage--;
      _comListEventSink.add(new StatusEvent(labelId, RefreshStatus.failed));
    });
  }

  Future getWxArticle(String labelId, int cid, int page) async {
    return wanRepository.getWxArticleList(id: cid, page: page).then((list) {
      if (comList == null) comList = new List();
      if (page == 1) {
        comList.clear();
      }
      comList.addAll(list);
      _comListSink.add(UnmodifiableListView<ReposModel>(comList));
      _comListEventSink.add(new StatusEvent(labelId,
          ObjectUtil.isEmpty(list) ? RefreshStatus.noMore : RefreshStatus.idle,
          cid: cid));
    }).catchError((_) {
      _comListPage--;
      _comListEventSink.add(new StatusEvent(labelId, RefreshStatus.failed));
    });
  }

  Future getArticle(String labelId, int cid, int page) async {
    ComReq _comReq = new ComReq(cid);
    return wanRepository
        .getArticleList(page: page, data: _comReq.toJson())
        .then((list) {
      if (comList == null) comList = new List();
      if (page == 0) {
        comList.clear();
      }
      comList.addAll(list);
      _comListSink.add(UnmodifiableListView<ReposModel>(comList));
      _comListEventSink.add(new StatusEvent(labelId,
          ObjectUtil.isEmpty(list) ? RefreshStatus.noMore : RefreshStatus.idle,
          cid: cid));
    }).catchError((_) {
      _comListPage--;
      _comListEventSink.add(new StatusEvent(labelId, RefreshStatus.failed));
    });
  }

  @override
  void dispose() {
    _comListData.close();
    _comListEvent.close();
    _comWorkArticleListData.close();
  }
}
