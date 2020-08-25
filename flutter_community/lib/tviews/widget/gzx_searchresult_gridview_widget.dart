import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/data/protocol/consumer_models.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/widget/web_scaffold.dart';
import 'package:helloworld/utils/navigator_util.dart';

class GZXSearchResultGridViewWidget extends StatelessWidget {
  final SearchResultListModal list;
  final ValueChanged<String> onItemTap;
  final VoidCallback getNextPage;
  BuildContext _context;

  GZXSearchResultGridViewWidget(this.list, {Key key, this.onItemTap, this.getNextPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _context = context;
    return list.mallData == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: productGrid(list.mallData),
          );
  }

  Widget imageStack(String img) => Image.network(
        img,
//        height: 100,
        fit: BoxFit.cover,
      );

  Widget productGrid(List<MallProdcutInfoModel> data) => GridView.builder(
//    primary: false,
//    shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(_context).orientation == Orientation.portrait ? 2 : 3,
        // 左右间隔
        crossAxisSpacing: 8,
        // 上下间隔
        mainAxisSpacing: 8,
        //宽高比 默认1
        childAspectRatio: 6 / 10,
      ),
//        shrinkWrap: true,
      itemCount: list.mallData.length,
//        children: data.map((product) {
      itemBuilder: (BuildContext context, int index) {
        var product = list.mallData[index];
        if ((index + 4) == list.mallData.length) {
          print(
              'SearchResultGridViewWidget.productGrid next page,current data count ${data.length},current index $index');
          getNextPage();
        }
        return GestureDetector(
          onTap: (){
            print(product);
            if(product.productCategoryCode.startsWith("G01")) {
              NavigatorUtil.pushPage(context, WebScaffold(
                  url: '/#/goodsDetail/${product.id}/', title: '商品详情',hideTitleBar: true),
                  pageName: '服务商品详情');
            }else if(product.productCategoryCode.startsWith("G02")){
              NavigatorUtil.pushPage(context, WebScaffold(
                  url: '/#/goodsDetails/${product.id}/', title: '商品详情',hideTitleBar: true),
                  pageName: '实体商品详情');
            }
//            NavigatorUtil.pushPage(context, WebScaffold(url:'/#/goodsDetail/${product.id}/${product.productAttributeCategoryId}/',title: '商品详情'),pageName: '商品详情');
          },
          child: Container(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  clipBehavior: Clip.antiAlias,
//                      elevation: 2.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
//                        fit: StackFit.expand,
                    children: <Widget>[
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            ConstrainedBox(
                              child: CachedNetworkImage(
                                fadeInDuration: Duration(milliseconds: 0),
                                fadeOutDuration: Duration(milliseconds: 0),
                                fit: BoxFit.fill,
                                imageUrl: Api.formatPicture(product.pic, 480),
                              ),
                              constraints: new BoxConstraints.expand(),
                            ),
                            product.productCategoryCode.startsWith("G01") && product.distance != null && product.distance != '' ? Positioned(child: ClipRRect(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0),bottomRight: Radius.circular(5.0)),
                                child: Container(
                                  color: Colours.transparent_80,
                                  padding: EdgeInsets.only(left: 5,right: 5,bottom: 3,top: 3),
                                  child: Text('距您:${product.distance}',style: TextStyle(color: Colors.white,fontSize: 13),),
                                )
                            )):SizedBox()
                          ],
                        ),
                      ),

//                          SizedBox(
//                            height: 10,
//                          ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(product.name,maxLines: 2,style:TextStyle(fontSize: Dimens.font_sp15),overflow: TextOverflow.ellipsis,textAlign: TextAlign.justify),
                            SizedBox(height: 5),
//                            Text(product.subTitle,style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),maxLines: 1,overflow: TextOverflow.ellipsis),
                            Row(
                              children: <Widget>[
                                product.coin != null && product.coin > 0 ?Container(
                                  margin: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
                                  padding: EdgeInsets.only(left: 2,right: 2),
                                  child: Text(
                                    '公益',
                                    style: TextStyle(color: Color(0xFFff692d), fontSize: 10),maxLines: 1,overflow: TextOverflow.clip,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(3)),
                                      border: Border.all(width: 1, color: Color(0xFFff692d))),
                                ):SizedBox(),
                                SizedBox(width: 5),
                                product.coupon.length <= 0
                                    ? SizedBox()
                                    : Container(
                                        margin: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
                                        padding: EdgeInsets.only(left: 2,right: 2),
                                        child: Text(
                                          product.coupon[0].smsCouponName,
                                          style: TextStyle(color: Color(0xFFff692d), fontSize: 10),maxLines: 1,overflow: TextOverflow.clip,
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(3)),
                                            border: Border.all(width: 1, color: Color(0xFFff692d))),
                                      ),
                              ],
                            ),
                            SizedBox(height: 18),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '￥',
                                  style: TextStyle(fontSize: 10, color: Color(0xFFff5410)),
                                ),
                                Text(
                                  '${product.price}',
                                  style: TextStyle(fontSize: 16, color: Color(0xFFff5410)),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: product.goodReviewRatio != 0 ? Text(
                                    '${product.goodReviewRatio}%好评',
                                    style: TextStyle(fontSize: 10, color: Color(0xFF979896)),
                                  ):SizedBox(),
                                ),
                                SizedBox(
                                  width: 8,
                                )
                              ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: Text(
                                          '${product.companyName}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),

                                    ],
                                  )),
                              GestureDetector(
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text('进店', style: TextStyle(fontSize: 12)),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(
                                          Icons.chevron_right,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                behavior: HitTestBehavior.translucent,
                                onTap: (){
                                  NavigatorUtil.pushPage(context,WebScaffold(url:'/#/enter-store/${product.sysOrgCode}/',title: '${product.companyName}',hideTitleBar: true,),pageName: '进店');
                                },
                              )
                            ],
                          ),
                      ])),
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        children: <Widget>[
//                          SizedBox(
//                            width: 5,
//                          ),
//                          Text(
//                            '￥',
//                            style: TextStyle(fontSize: 10, color: Color(0xFFff5410)),
//                          ),
//                          Text(
//                            '${product.price}',
////                          '27.5',
//                            style: TextStyle(fontSize: 16, color: Color(0xFFff5410)),
//                          ),
//                          SizedBox(
//                            width: 10,
//                          ),
//                          Expanded(
//                            child: Text(
//                              '人评价',
////                            '23234人评价',
////                          product
//                              style: TextStyle(fontSize: 10, color: Color(0xFF979896)),
//                            ),
//                          ),
//                          Icon(
//                            Icons.more_horiz,
//                            size: 15,
//                            color: Color(0xFF979896),
//                          ),
//                          SizedBox(
//                            width: 8,
//                          )
//                        ],
//                      ),
//                      SizedBox(
//                        height: 8,
//                      )
                    ],
                  ),
//              ),
                ),
              ))
        );
      });

//  );
}
