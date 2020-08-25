
import 'dart:async';

import 'package:estate/common/component_index.dart';
import 'package:estate/ui/pages/page_index.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {

  final String labelId;

  const OrderPage({Key key, this.labelId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EstateBloc bloc = BlocProvider.of<EstateBloc>(context);
    RefreshController _controller = new RefreshController();
    bloc.getData(labelId: labelId,page: 1);

    Future.delayed(Duration(seconds: 5), (){
      bloc.getVersion(context);
    });

    bloc.homeEventStream.listen((event) {
      try {
        if (labelId == event.labelId) {
           _controller.sendBack(false, event.status);
        }
      }catch(err){
      }
    });
    return new StreamBuilder(
        stream: labelId == Ids.titleOrder1 ? bloc.orderCodeStream1 : labelId == Ids.titleOrder2 ? bloc.orderCodeStream2 : labelId == Ids.titleOrder3 ? bloc.orderCodeStream3 : bloc.orderCodeStream4,
        builder:
            (BuildContext context, AsyncSnapshot<List<OrderModel>> snapshot) {
              if(snapshot.data == null){
                return Container(height: 0);
              }
              int loadStatus = Utils.getLoadStatus(snapshot.hasError, snapshot.data);
              print(loadStatus);
              return new RefreshScaffold(
                labelId: labelId,
                loadStatus: loadStatus,
                controller: _controller,
//                enablePullUp: false,
                onRefresh: ({bool isReload}) {
                  return bloc.onRefresh(labelId: labelId);
                },
                onLoadMore: (up) {
                  bloc.onLoadMore(labelId: labelId);
                },
                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildCard(context,snapshot.data[index]);
                },
//                child: new ListView(
//                    padding: EdgeInsets.all(0),
//                    children: snapshot.data.map((value) {
//                      return buildCard(context,value);
//                    }).toList()
//                ),
              );

        });
  }

  Widget buildCard(BuildContext context,OrderModel order){
    switch(labelId){
      case Ids.titleOrder1:
        //我的订单
        return titleOrder1(context,order);
        break;
      case Ids.titleOrder2:
        //待接单
        return titleOrder2(context,order);
        break;
      case Ids.titleOrder3:
        //未委派
        return titleOrder2(context,order);
        break;
      case Ids.titleOrder4:
        //已委派
        return titleOrder1(context,order);
        break;
      default:
        return Container();
        break;
    }
  }
  //待接单
  Widget titleOrder2(BuildContext context,OrderModel order){
    return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top:Dimens.gap_dp15,left: Dimens.gap_dp15,right: Dimens.gap_dp15),
                padding: EdgeInsets.all(Dimens.gap_dp10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(8),topRight: Radius.circular(8))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.fiber_manual_record,color: Colors.blueAccent,size: Dimens.gap_dp16,),
                        SizedBox(width: Dimens.gap_dp5,),
                        Text(order.orderTypeDictText,style: TextStyle(fontFamily: 'PingFang',fontWeight: FontWeight.bold)),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: Dimens.gap_dp10,vertical: 0),
                          margin: EdgeInsets.only(left: 10, top: 0),
                          //设置 child 居中
                          alignment: Alignment(0, 0),
                          height: 18,
                          //边框设置
                          decoration: new BoxDecoration(
                            //背景
                            color: Colors.white,
                            //设置四周圆角 角度
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            //设置四周边框
                            border: new Border.all(width: 1, color: Colors.redAccent),
                          ),
                          child: Text(order.statusDictText,style: TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp12,color: Colors.redAccent),),
                        ),
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.only(left: Dimens.gap_dp20,top: Dimens.gap_dp5,bottom: Dimens.gap_dp20),
                        child: Text(order.userAddress,style: TextStyle(fontFamily: 'PingFang',color: Colours.text_gray,fontSize: Dimens.font_sp14))
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(Icons.fiber_manual_record,color: Color(0xfff9650c),size: Dimens.gap_dp16,),
                                SizedBox(width: Dimens.gap_dp5,),
                                Text(order.userName,style: TextStyle(fontFamily: 'PingFang',fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Container(
                                margin: EdgeInsets.only(left: Dimens.gap_dp20,top: Dimens.gap_dp5),
                                child: Text(Utils.hideMobile(order.userMobile),style: TextStyle(fontFamily: 'PingFang',color: Colours.text_gray,fontSize: Dimens.font_sp14))
                            ),
                          ],
                        ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //详情
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: Dimens.gap_dp15),
                child: Image.asset(Utils.getImgPath('line',format: 'jpg'),fit: BoxFit.fitWidth,width: double.infinity),
              ),
              Container(
                  margin: EdgeInsets.only(bottom: Dimens.gap_dp10,left: Dimens.gap_dp15,right:Dimens.gap_dp15),
                  padding: EdgeInsets.only(left:30,bottom:Dimens.gap_dp10,right:Dimens.gap_dp10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(bottomLeft:Radius.circular(8),bottomRight: Radius.circular(8))
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Text('预约时间：',style:TextStyle(fontFamily: 'PingFang',color: Colours.text_gray,fontSize: Dimens.font_sp14)),
                            Text(Utils.timeShowFormat(order.orderServiceDate),style:TextStyle(fontFamily: 'PingFang',color: Colours.text_normal,fontSize: Dimens.font_sp14)),
                          ],
                        ),
                        flex: 6,
                      ),
                      Expanded(child: Container(height: Dimens.gap_dp20, child: VerticalDivider(color: Colors.grey)),flex: 1,),
                      Expanded(
                        child: GestureDetector(
                          child: Text('详情',style:TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp14)),
                          onTap: (){
                            NavigatorUtil.pushPage(
                              context,
                              BlocProvider<EstateBloc>(
                                child: OrderDetailPage(labelId: Ids.titleOrderDetail,orderId: order.id,),
                                bloc: new EstateBloc(),
                              ),
                              pageName: Ids.titleOrderDetail,
                            );
                          },
                        ),
                        flex: 1,
                      )
                    ],
                  )
              ),
            ],
          ),

    );
  }

  //我的订单
  Widget titleOrder1(BuildContext context,OrderModel order){
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top:Dimens.gap_dp15,left: Dimens.gap_dp15,right: Dimens.gap_dp15),
              padding: EdgeInsets.all(Dimens.gap_dp10),
              decoration: BoxDecoration(
                  color: Colors.white,
                 borderRadius: BorderRadius.only(topLeft:Radius.circular(8),topRight: Radius.circular(8))
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(Icons.fiber_manual_record,color: Colors.blueAccent,size: Dimens.gap_dp16,),
                      SizedBox(width: Dimens.gap_dp5,),
                      Text(order.orderTypeDictText,style: TextStyle(fontFamily: 'PingFang',fontWeight: FontWeight.w600)),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: Dimens.gap_dp10,vertical: 0),
                        margin: EdgeInsets.only(left: 10, top: 0),
                        //设置 child 居中
                        alignment: Alignment(0, -1),
                        height: 18,
                        //边框设置
                        decoration: new BoxDecoration(
                          //背景
                          color: Colors.white,
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          //设置四周边框
                          border: new Border.all(width: 1, color: order.status == '5' ? Colours.app_main : Colors.orangeAccent),
                        ),
                        child: Text(order.statusDictText,style: TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp12,color: order.status == '5' ? Colours.app_main : Colors.orangeAccent),),
                      ),
                      order.status == '5' ? Container(
                        padding: EdgeInsets.symmetric(horizontal: Dimens.gap_dp10,vertical: 0),
                        margin: EdgeInsets.only(left: 10, top: 0),
                        //设置 child 居中
                        alignment: Alignment(0, -1),
                        height: 18,
                        //边框设置
                        decoration: new BoxDecoration(
                          //背景
                          color: Colors.white,
                          //设置四周圆角 角度
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          //设置四周边框
                          border: new Border.all(width: 1, color: order.finishTime >= order.actFinishTime ? Colours.app_main : Colors.orangeAccent),
                        ),
                        child: Text('${order.finishTime >= order.actFinishTime ? "按时完成":"超时完成"}',style: TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp12,color: order.finishTime >= order.actFinishTime ? Colours.app_main : Colors.orangeAccent),),
                      ):Container(),
                    ],
                  ),
                  Container(
                      margin: EdgeInsets.only(left: Dimens.gap_dp20,top: Dimens.gap_dp5,bottom: Dimens.gap_dp20),
                      child: Text(order.userAddress,style: TextStyle(fontFamily: 'PingFang',color: Colours.text_gray,fontSize: Dimens.font_sp14))
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.fiber_manual_record,color: Color(0xfff9650c),size: Dimens.gap_dp16,),
                              SizedBox(width: Dimens.gap_dp5,),
                              Text(order.userName,style: TextStyle(fontFamily: 'PingFang',fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Container(
                              margin: EdgeInsets.only(left: Dimens.gap_dp20,top: Dimens.gap_dp5),
                              child: Text(Utils.hideMobile(order.userMobile),style: TextStyle(fontFamily: 'PingFang',color: Colours.text_gray,fontSize: Dimens.font_sp14))
                          ),
                        ],
                      ),
                        flex: 9,
                      ),
                      Expanded(child: Container(height: Dimens.gap_dp20, child: VerticalDivider(color: Colors.grey)),flex: 1,),
                      Expanded(
                        child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                SizedBox(width: Dimens.gap_dp10,),
                                Text("处理人",style: TextStyle(fontFamily: 'PingFang',fontWeight: FontWeight.bold)),
                                SizedBox(width: Dimens.gap_dp10,),
                                GestureDetector(
                                  child: Icon(Icons.phone,color: Colors.green,size: Dimens.gap_dp16,),
                                  onTap: (){
                                    NavigatorUtil.diaMobile(order.workerMobile);
                                  },
                                )
                              ],
                            ),
                            Container(
                                margin: EdgeInsets.only(left: Dimens.gap_dp10,top: Dimens.gap_dp5),
                                child: Text(order.workerName,style: TextStyle(fontFamily: 'PingFang',color: Colours.text_gray,fontSize: Dimens.font_sp14))
                            ),
                          ],
                        ),
                        flex: 9,
                      )
                    ],
                  ),
                ],
              )
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: Dimens.gap_dp15),
              child: Image.asset(Utils.getImgPath('line',format: 'jpg'),fit: BoxFit.fitWidth,width: double.infinity),
            ), //日 9 6
            Container(
              margin: EdgeInsets.only(bottom: Dimens.gap_dp10,left: Dimens.gap_dp15,right:Dimens.gap_dp15),
              padding: EdgeInsets.only(left:30,bottom:Dimens.gap_dp10,right:Dimens.gap_dp10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(bottomLeft:Radius.circular(8),bottomRight: Radius.circular(8))
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(Utils.getTimeDiff(order.orderServiceDate,order.status),style:TextStyle(fontFamily: 'PingFang',color: Colours.text_gray,fontSize: Dimens.font_sp14)),
                    flex: 6,
                  ),
                  Expanded(child: Container(height: Dimens.gap_dp20, child: VerticalDivider(color: Colors.grey)),flex: 1,),
                  Expanded(
                    child: GestureDetector(
                      child: Text('详情',style:TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp14)),
                      onTap: (){
                        NavigatorUtil.pushPage(
                          context,
                          BlocProvider<EstateBloc>(
                            child: OrderDetailPage(labelId: Ids.titleOrderDetail,orderId: order.id,),
                            bloc: new EstateBloc(),
                          ),
                          pageName: Ids.titleOrderDetail,
                        );
                      },
                    ),
                    flex: 1,
                  )
                ],
              )
            ),
          ],
        ),
    );
  }

}
