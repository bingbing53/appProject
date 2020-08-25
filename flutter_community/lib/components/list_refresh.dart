/**
 * Created with Android Studio.
 * User: 一晟
 * Date: 2019/1/4
 * Time: 上午1:16
 * email: zhu.yan@alibaba-inc.com
 * tartget: FlatButton 的示例
 */
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:helloworld/common/style.dart';
import 'package:helloworld/event/event-bus.dart';
import 'package:helloworld/event/event-model.dart';
import 'package:event_bus/event_bus.dart';

class ListRefresh extends StatefulWidget {
  final renderItem;
  final requestApi;
  final headerView;

  const ListRefresh([this.requestApi, this.renderItem, this.headerView]) : super();

  @override
  State<StatefulWidget> createState() => _ListRefreshState();
}

class _ListRefreshState extends State<ListRefresh> {
  bool isLoading = false; // 是否正在请求数据中
  bool _hasMore = true; // 是否还有更多数据可加载
  int _pageIndex = 1; // 页面的索引
  int _pageTotal = 0; // 页面的索引
  List items = new List();
  ScrollController _scrollController = new ScrollController();

  _ListRefreshState(){
//    final eventBus = new EventBus();
//    ApplicationEvent.event = eventBus;
    ApplicationEvent.event.on<ListRefreshEvent>().listen((event) {
      print('刷新');
        _handleRefresh();
    });
  }

  @override
  void initState() {
    super.initState();
    _getMoreData();
    _scrollController.addListener(() {
      // 如果下拉的当前位置到scroll的最下面
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
  }

  /*
  * 回弹效果
  * */
  backElasticEffect() {
//    double edge = 50.0;
//    double offsetFromBottom = _scrollController.position.maxScrollExtent - _scrollController.position.pixels;
//    if (offsetFromBottom < edge) { // 添加一个动画没有更多数据的时候 ListView 向下移动覆盖正在加载更多数据的标志
//      _scrollController.animateTo(
//          _scrollController.offset - (edge -offsetFromBottom),
//          duration: new Duration(milliseconds: 1000),
//          curve: Curves.easeOut);
//    }
  }

  /*
  * list探底，执行的具体事件
  * */
  Future _getMoreData() async {
    if (!isLoading && _hasMore) {
      // 如果上一次异步请求数据完成 同时有数据可以加载
      setState(() => isLoading = true);
      //if(_hasMore){ // 还有数据可以拉新
      List newEntries = await mokeHttpRequest();
      //if (newEntries.isEmpty) {
      _hasMore = (_pageIndex <= _pageTotal);
      if (this.mounted) {
        setState(() {
          items.addAll(newEntries);
          isLoading = false;
        });
      }
      backElasticEffect();
    } else if (!isLoading && !_hasMore) {
      // 这样判断,减少以后的绘制
      _pageIndex = 1;
      backElasticEffect();
    }
  }

  /*
  * 伪装吐出新数据
  * */
  Future<List> mokeHttpRequest() async {
    if (widget.requestApi is Function) {
      print(_pageIndex);
      final listObj = await widget.requestApi({'pageIndex': _pageIndex});
      _pageIndex = listObj['pageIndex'];
      _pageTotal = listObj['total'];
      print(_pageIndex);
      return listObj['list'];
    } else {
      return Future.delayed(Duration(seconds: 1), () {
        return [];
      });
    }
  }

  /*
  * 下拉加载的事件，清空之前list内容，取前X个
  * 其实就是列表重置
  * */
  Future<Null> _handleRefresh() async {
    _pageIndex = 1;
    List newEntries = await mokeHttpRequest();
    _hasMore = (_pageIndex <= _pageTotal);
    print(this.mounted);
    if (this.mounted) {
      setState(() {
        items.clear();
        items.addAll(newEntries);
        isLoading = false;
//        _hasMore = true;
//        if(_hasMore)
//          _pageIndex += 1;
//        return null;
      });
    }
  }

  /*
  * 加载中的提示
  * */
  Widget _buildLoadText() {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Center(
        child: Text("- 已加载全部 -",style: AppText.Info_Size_Big_Gray,),
      ),
    ));
  }

  /*
  * 上提加载loading的widget,如果数据到达极限，显示没有更多
  * */
  Widget _buildProgressIndicator() {
    if (_hasMore) {
      return new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Center(
            child: Column(
          children: <Widget>[
            new Opacity(
              opacity: isLoading ? 1.0 : 0.0,
              child: SpinKitWave(size: 25.0, color: Colors.redAccent)
//              new CircularProgressIndicator(
//                  valueColor: AlwaysStoppedAnimation(Colors.blue)),
            ),
            SizedBox(height: 20.0),
            Text(
              '稍等片刻更精彩...',
              style: TextStyle(fontSize: 14.0),
            )
          ],
        )
            //child:
            ),
      );
    } else {
      return _buildLoadText();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //flutter_easyrefresh
    return new RefreshIndicator(
      child: ListView.builder(
        itemCount: items.length + 2,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if(index == 0){
            return widget.headerView is Function ? widget.headerView() : SizedBox(height: 0,);
          }else if (index > items.length) {
            //return _buildLoadText();
            return _buildProgressIndicator();
          } else {
            if (widget.renderItem is Function) {
              return widget.renderItem(index, items[index-1]);
            }
          }
        },
        controller: _scrollController,
      ),
      onRefresh: _handleRefresh,
    );
  }
}
