import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/data/api/apis.dart';
import 'package:helloworld/data/net/dio_util.dart';
import 'package:helloworld/data/protocol/consumer_models.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/consumer/consumer_page_index.dart';
import 'package:helloworld/tviews/consumer/home/search_page.dart';
import 'package:helloworld/tviews/consumer/mall/ProductListItem.dart';
import 'package:helloworld/tviews/widget/simple_dialog.dart';
import 'package:helloworld/tviews/widget/widget_index.dart';
import 'package:helloworld/utils/base_utils.dart';
import 'package:helloworld/utils/installapk_utils.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'package:helloworld/utils/util_index.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:permission_handler/permission_handler.dart';

import 'h_home_mall_page.dart';
import 'h_home_community_page.dart';
import 'h_home_estate_page.dart';

//主页
class ConsumerHomePage extends StatefulWidget{
  final String labelId;

  const ConsumerHomePage({Key key, this.labelId}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new ConsumerHomePageState();
  }

}

class ConsumerHomePageState extends State<ConsumerHomePage> with AutomaticKeepAliveClientMixin{

  MainBloc _mainBloc;

  ScrollController _scrollController = ScrollController(); //listview的控制器

  bool loading = false;

  @override
  void initState() {
    _mainBloc = BlocProvider.of<MainBloc>(context);
    _mainBloc.getStaticInfo();
    //获取商品
//    _mainBloc.getMallProductList(1);
    //获取轮播图
    _mainBloc.getBannersList('4');

    _mainBloc.getUserInfo();

    _scrollController.addListener(() async {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if(!loading) {
          loading = true;
          await _mainBloc.onLoadMore(labelId: 'homePage');
          loading = false;
        }
      }
    });

    Future.delayed(Duration(seconds: 3), (){
      _mainBloc.getVersion(context,download: false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _mainBloc.onRefresh(labelId: 'homePage');
    return Scaffold(
        appBar: AppBar(

          title:Row(
              children:[
                Container(
                  width: 25,
                  height: 25,
                  margin: EdgeInsets.only(right: Dimens.gap_dp15),
                  child: StreamBuilder(
                      stream: _mainBloc.userInfoDataStream,
                      builder: (BuildContext context,AsyncSnapshot<BaseUserInfoModel> snapshot) {
                        if(snapshot.data == null || snapshot.hasError || snapshot.data.mobile == null){
                          return ClipOval(
                            child:  Image.asset(Utils.getImgPath('chat_single'),width: 25),
                          );
                        }
                        BaseUserInfoModel userInfo = snapshot.data;
                        return userInfo.headImage != null && userInfo.headImage != '' ? ClipOval(
                            child:  CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: '${userInfo.headImage}',
                              width: 25,
                              height: 25,
                            ),
                          ):ClipOval(
                          child:  Image.asset(Utils.getImgPath('chat_single'),width: 25),
                        );
                      }),
//                  decoration: BoxDecoration(
//                    shape: BoxShape.circle,
//                    image: DecorationImage(
//                      image: AssetImage(
//                        Utils.getImgPath('chat_single'),
//                      ),
//                    ),
//                  ),
                ),
                GestureDetector(
                  child:  StreamBuilder(
                      stream: _mainBloc.staticInfoDataStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<StaticInfo> snapshot) {
                        if(null != snapshot.data)
                          return Text(Utils.subLength(snapshot.data.departName,4),style: TextStyle(fontSize: Dimens.font_sp15),);
                        else
                          return Text('');
                      }),
                  onTap: (){
                    NavigatorUtil.pushPage(context, SelectPlacePage(),pageName: '选择社区');
//                    Navigator.of(context).popUntil(ModalRoute.withName("/selectPlacePage"));
//                    NavigatorUtil.push(context, SelectPlacePage(),pageName: '选择社区');
                  },
                ),

                Icon(Icons.location_on,color: Colors.white,size: 16,),
                Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: Dimens.gap_dp10),
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: new Border.all(width: 0, color: Colors.white),
                      ),
                      child: GestureDetector(
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: Dimens.gap_dp5,),
                            Icon(Icons.search,color: Colors.grey,size: 16,),
                            Text('搜索',style: TextStyle(fontSize: Dimens.font_sp14,color: Colors.grey),)
                          ],
                        ),
                        behavior: HitTestBehavior.translucent,
                        onTap: (){
                          NavigatorUtil.pushPage(context, SearchPage(),pageName: '搜索页面');
                        },
                      ),
                    )
                )
              ]
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[
            GestureDetector(
              child: Container(
                  margin:EdgeInsets.only(right: Dimens.gap_dp10),
                  child: Icon(Icons.add,color: Colors.white,size: 30)
              ),
              onTap: () async {
                final result = await showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(100, kToolbarHeight + MediaQuery.of(context).padding.top, 0.0, 0.0),
                    color: Colours.gray_33,
                    items: <PopupMenuItem<String>>[
                      new PopupMenuItem<String>( value: 'value01', child: Row(
                        children: <Widget>[
                          Image.asset(Utils.getImgPath('index_share'),width: 20),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text("分  享",style: TextStyle(color: Colors.white),textAlign: TextAlign.center),
                          ),
                        ],
                      )),
                      new PopupMenuItem<String>( value: 'value02', child: Row(
                        children: <Widget>[
                          Image.asset(Utils.getImgPath('index_scan'),width: 20),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text("扫一扫",style: TextStyle(color: Colors.white),textAlign: TextAlign.center),
                          ),
                        ],
                      )),
//                      new PopupMenuItem<String>( value: 'value02', child: Row(
//                        children: <Widget>[
//                          Image.asset(Utils.getImgPath('qrcode'),width: 25),
//                          Expanded(
//                              child: Text("二维码",style: TextStyle(color: Colors.white),textAlign: TextAlign.center),
//                          ),
//                        ],
//                      )),
                    ] );

                if(result == 'value02'){
                  String barcode = await BarcodeScanner.scan();
                  BaseUtils.scanQRResult(barcode, context);
                }else if(result == 'value01'){
                  var model = fluwx.WeChatShareWebPageModel(
                      webPage: ShequejiaApi.formatH5Path('/#/download/'),
                      title: '社区e家',
                      thumbnail: 'https://image.shequyijia.cn/pic/notification/shequyijia/ic_launcher.png',
                      scene: WeChatScene.SESSION,
                      transaction: "社区e家",
                      description: "社区信息、物业服务、居家购物尽在社区e家"
                  );
                  fluwx.share(model);
                }

              },
            ),
          ],
          flexibleSpace: Image(
            image: AssetImage(Utils.getImgPath('home_top')),
            fit: BoxFit.cover,
          ),
        ),
        body:RefreshIndicator(
          onRefresh: () async{
            _mainBloc.onRefresh(labelId: 'homePage');
            _mainBloc.estateArticleList();
            _mainBloc.bluePermissionList();
          },
          child: ListView(
            controller: _scrollController,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding:EdgeInsets.only(bottom: 45),
                    color: Colors.white,
                    child: Image.asset(Utils.getImgPath('home_top')),
                  ),
                  new Positioned(
                      top: 30,
                      left: Dimens.gap_dp15,
                      right: Dimens.gap_dp15,
                      child:StreamBuilder(
                      stream: _mainBloc.bannersListDataStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<BannersModel>> snapshot) {
                        List<BannersModel> banners = snapshot.data;
                        if (banners == null || banners.length <= 0) {
                          return AspectRatio(
                            aspectRatio: 16.0 / 9.0,
                            child: Swiper(
                              indicatorAlignment: AlignmentDirectional.bottomCenter,
                              circular: true,
                              direction : Axis.horizontal,
                              interval: const Duration(seconds: 5),
                              indicator: NumberWorkSwiperIndicator(),
                              children:<Widget>[
                                Image(
                                  image: AssetImage(Utils.getImgPath('banner',format: 'jpg')),
                                  fit: BoxFit.cover,
                                )
                              ]
                            )
                          );
                        }
                        return AspectRatio(
                          aspectRatio: 16.0 / 9.0,
                          child: Swiper(
                              indicatorAlignment: AlignmentDirectional.bottomCenter,
                              circular: true,
                              direction : Axis.horizontal,
                              interval: const Duration(seconds: 5),
                              indicator: NumberWorkSwiperIndicator(),
                              children: banners.map((item){
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(Dimens.gap_dp5),
                                    child:  new CachedNetworkImage(
                                      fit: BoxFit.fill,
                                      imageUrl:  Api.formatPicture(item.image, 480),//'https://img.zcool.cn/community/0123005667ee036ac7259f6ec40e07.jpg@1280w_1l_2o_100sh.jpg',
                                    ),
                                  );
                              }).toList()
                          ),
                        );

                      })

                  ),
                ],
              ),

              ConsumerHomeCommunityPage(),

              ConsumerHomeEstatePage(),

              ConsumerHomeBizPage(),

              new StreamBuilder(
                  stream: _mainBloc.productListDataStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<MallProdcutInfoModel>> snapshot) {
//                    loadStatus = Utils.getLoadStatus(snapshot.hasError, snapshot.data);
                    return _renderRow(context, snapshot.data);
                  }),

//              Container(
//                height: 150,
//                child: WeChatExpression((Expression exp){
//
//                }),
//              )

            ],
          ),
        ),
    );
  }

  Widget _renderRow(BuildContext context, List<MallProdcutInfoModel> list) {
    if (ObjectUtil.isEmpty(list)) {
      return Container(
      );
    }
    List<Widget> _children = list.map((model) {
      return new ProductListItem(
        item: model,
      );
    }).toList();
    List<Widget> children = new List();
    children.add(Container(height: 10.0,color: Colors.white,));
    children.addAll(_children);

    return Wrap(
      spacing: 0.0, // 主轴(水平)方向间距
      runSpacing: 4.0, // 纵轴（垂直）方向间距
      alignment: WrapAlignment.start, //沿主轴方向居中
      children: children,
    );
  }

  @override
  bool get wantKeepAlive => true;


}

class NumberWorkSwiperIndicator extends SwiperIndicator {
  @override
  Widget build(BuildContext context, int index, int itemCount) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black45, borderRadius: BorderRadius.circular(20.0)),
      margin: EdgeInsets.only(top: 20.0, right: 5.0),
      padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      child: Text("${++index}/$itemCount",
          style: TextStyle(color: Colors.white70, fontSize: 11.0)),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}