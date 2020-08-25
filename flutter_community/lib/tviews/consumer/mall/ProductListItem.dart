
import 'package:flutter/material.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/data/protocol/consumer_models.dart';
import 'package:helloworld/model/api.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/widget/web_scaffold.dart';
import 'package:helloworld/utils/base_utils.dart';
import 'package:helloworld/utils/navigator_util.dart';

class ProductListItem extends StatelessWidget {
  final MallProdcutInfoModel item;
  const ProductListItem({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      width: width / 2 - 5,
//      height: (width / 2 - 5) / 6 * 10,
      margin: EdgeInsets.only(left: 2),
      child: GestureDetector(
        child: Card(
            elevation: 1.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              clipBehavior: Clip.antiAlias,
              child: buildCard(context)
            )
        ),
        behavior:HitTestBehavior.translucent,
        onTap: (){
          if(item.productCategoryCode.startsWith("G01")) {
            NavigatorUtil.pushPage(context, WebScaffold(
                url: '/#/goodsDetail/${item.id}/', title: '商品详情',hideTitleBar: true),
                pageName: '服务商品详情');
          }else if(item.productCategoryCode.startsWith("G02")){
            NavigatorUtil.pushPage(context, WebScaffold(
                url: '/#/goodsDetails/${item.id}/', title: '商品详情',hideTitleBar: true),
                pageName: '实体商品详情');
          }
        },
      )
    );
  }

  Widget buildCard(context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Stack(
            children: <Widget>[
              AspectRatio(
                aspectRatio:10/9,
                child:CachedNetworkImage(
                  fadeInDuration: Duration(milliseconds: 0),
                  fadeOutDuration: Duration(milliseconds: 0),
                  fit: BoxFit.fill,
                  imageUrl: Api.formatPicture(item.pic, 480),
                ),
              ),
              item.productCategoryCode.startsWith("G01") && item.distance != null && item.distance != '' ? Positioned(child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0),bottomRight: Radius.circular(5.0)),
                  child: Container(
                    color: Colours.transparent_80,
                    padding: EdgeInsets.only(left: 5,right: 5,bottom: 3,top: 3),
                    child: Text('距您:${item.distance}',style: TextStyle(color: Colors.white,fontSize: 13),),
                  )
              )):SizedBox()
            ],
          )
        ),
//        Expanded(
//          child: Stack(
//            children: <Widget>[
//              Container(
//              height:100
//          ),
////              ConstrainedBox(
////                child: CachedNetworkImage(
////                  fadeInDuration: Duration(milliseconds: 0),
////                  fadeOutDuration: Duration(milliseconds: 0),
////                  fit: BoxFit.fill,
////                  imageUrl: Api.formatPicture(item.pic, 480),
////                ),
////                constraints: new BoxConstraints(maxHeight: 100),
////              ),
//              item.productCategoryCode.startsWith("G01") && item.distance != null && item.distance != '' ? Positioned(child: ClipRRect(
//                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0),bottomRight: Radius.circular(5.0)),
//                  child: Container(
//                    color: Colours.transparent_80,
//                    padding: EdgeInsets.only(left: 5,right: 5,bottom: 3,top: 3),
//                    child: Text('距您:${item.distance}',style: TextStyle(color: Colors.white,fontSize: 13),),
//                  )
//              )):SizedBox()
//            ],
//          ),
//        ),

        Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(item.name,maxLines: 2,style:TextStyle(fontSize: Dimens.font_sp15),overflow: TextOverflow.ellipsis,textAlign: TextAlign.justify,),
              SizedBox(height: 5),
              Text(item.subTitle,style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),maxLines: 1,overflow: TextOverflow.ellipsis),
              SizedBox(height: 5),
              Row(
                children: <Widget>[
                  item.coin != null && item.coin > 0 ?Container(
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
                  item.coupon.length <= 0
                      ? SizedBox(height: 15,)
                      : Container(
                    margin: const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 0),
                    padding: EdgeInsets.only(left: 2,right: 2),
                    child: Text(
                      item.coupon[0].smsCouponName,
                      style: TextStyle(color: Color(0xFFff692d), fontSize: 10),maxLines: 1,overflow: TextOverflow.clip,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        border: Border.all(width: 1, color: Color(0xFFff692d))),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '￥',
                    style: TextStyle(fontSize: 10, color: Color(0xFFff5410)),
                  ),
                  Text(
                    '${item.price}',
                    style: TextStyle(fontSize: 16, color: Color(0xFFff5410)),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: item.goodReviewRatio != 0 ? Text(
                      '${item.goodReviewRatio}%好评',
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
                              '${item.companyName}',
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
                        NavigatorUtil.pushPage(context,WebScaffold(url:'/#/enter-store/${item.sysOrgCode}/',title: '${item.companyName}',hideTitleBar: true,),pageName: '进店');
                      },
                    )
                ],
              ),
              SizedBox(height: 2),
            ],
          )
        )
      ],
    );
  }

}