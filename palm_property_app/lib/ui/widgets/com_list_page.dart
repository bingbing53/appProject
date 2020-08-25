import 'package:flutter/material.dart';
import 'package:estate/common/component_index.dart';

class ComListPage extends StatelessWidget {
  const ComListPage({Key key, this.labelId, this.cid}) : super(key: key);
  final String labelId;
  final String cid;

  @override
  Widget build(BuildContext context) {
    LogUtil.e("ComListPage build......");
    RefreshController _controller = new RefreshController();
    final ComListBloc bloc = BlocProvider.of<ComListBloc>(context);
    bloc.comListEventStream.listen((event) {
      if (cid == event.cid) {
        _controller.sendBack(false, event.status);
      }
    });

//    return new StreamBuilder(
//        stream: bloc.collectModelListStream,
//        builder: (BuildContext context, AsyncSnapshot<List> snapshot)
//    {
//      if (bloc.comWorkArticleList == null) {
//        bloc.onRefresh(labelId: labelId, cid: cid);
//      }

//      return new RefreshScaffold(
//        labelId: cid.toString(),
//        isLoading: snapshot.data == null,
//        controller: _controller,
//        onRefresh: () {
//          return bloc.onRefresh(labelId: labelId, cid: cid);
//        },
//        onLoadMore: (up) {
//          bloc.onLoadMore(labelId: labelId, cid: cid);
//        },
//        itemCount: snapshot.data == null ? 0 : snapshot.data.length,
//        itemBuilder: (BuildContext context, int index) {
//          switch (labelId) {
//            case Ids.titleWorkArticleTree:
//              return WorkArticleItem(snapshot.data[index]);
//            case Ids.titleFocus:
//              return UserItem(snapshot.data[index]);
//          }
//        },
//      );
//    });

    return new StreamBuilder(
        stream: bloc.comWorkArticleListStream,
        builder:
            (BuildContext context, AsyncSnapshot<List> snapshot) {
          int loadStatus = Utils.getLoadStatus(snapshot.hasError, snapshot.data);
          if (loadStatus == LoadStatus.loading) {
            bloc.onRefresh(labelId: labelId, cid: cid);
          }

          return new RefreshScaffold(
            labelId: cid.toString(),
            loadStatus: loadStatus,
            controller: _controller,
            onRefresh: ({bool isReload}) {
              return bloc.onRefresh(labelId: labelId, cid: cid);
            },
            onLoadMore: (up) {
              bloc.onLoadMore(labelId: labelId, cid: cid);
            },
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              switch(labelId){
                case Ids.titleWorkArticleTree:
                  return WorkArticleItem(snapshot.data[index]);
                case Ids.titleFocus:
                  return UserItem(snapshot.data[index]);
              }
            },
          );
        });
  }
}
