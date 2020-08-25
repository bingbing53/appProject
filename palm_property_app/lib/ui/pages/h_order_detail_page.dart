
import 'package:estate/common/component_index.dart';
import 'package:estate/ui/dialog/simple_dialog.dart';
import 'package:estate/ui/pages/page_index.dart';
import 'package:flutter/material.dart';

class OrderDetailPage extends StatelessWidget {

  final String labelId,orderId;

  const OrderDetailPage({Key key, this.labelId,this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EstateBloc bloc = BlocProvider.of<EstateBloc>(context);
    final WorkBloc workBloc = BlocProvider.of<WorkBloc>(context);
    bloc.getOrderDetail(orderId);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(IntlUtil.getString(context,labelId),),
      ),
      body: Container(
        child: new Column(
          children: <Widget>[
            new StreamBuilder(
                stream:  bloc.orderDetailCodeStream,
                builder: (BuildContext context, AsyncSnapshot<OrderModel> snapshot) {
                  if(ObjectUtil.isEmpty(snapshot.data)){
                    return Container();
                  }
                  return titleOrder(context,bloc,snapshot.data);
                }
            )
          ],
        )
      ),
      bottomNavigationBar: buildNavigationBar(bloc,workBloc),
    );
  }

  Widget buildNavigationBar(EstateBloc bloc,WorkBloc workBloc){
      return new StreamBuilder(
          stream:  bloc.orderDetailCodeStream,
          builder: (BuildContext context, AsyncSnapshot<OrderModel> snapshot) {
            if(ObjectUtil.isEmpty(snapshot.data)){
              return Container();
            }
            OrderModel order = snapshot.data;
            return (order.status == '4' || order.status == '5' || order.status == '6') ? Container(height: 0):Container(
              color: Colors.white,
              height: 50,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Text('联系居民'),
                        GestureDetector(
                          child: Image.asset(Utils.getImgPath('contact_phone'),width: 40,),
                          onTap: (){
                            NavigatorUtil.diaMobile(order.userMobile);
                          },
                        ),
                        GestureDetector(
                          child: Image.asset(Utils.getImgPath('contact_message'),width: 40,),
                          onTap: (){
                            workBloc.createConversation(order.userMobile,appkey: shequejiaAppkey).then((model){
                              workBloc.enterConversation(model,appkey:shequejiaAppkey);
                              workBloc.getHistoryMessages(model);
                              Map<String,String> extras = {
                                "orderId":orderId,
                                "msg_type":"normal"
                              };
                              NavigatorUtil.pushPage(context, MessageChatPage(model:model,labelId: Ids.titleChatMessage,extras: extras,),pageName:Ids.titleChatMessage);
                            }).catchError((_){
                              if(_ == 'noregister'){
                                SimpleDialogUtil.showDialogs(context,'提示','该居民没有登录过app，请电话联系！');
                              }
                            });
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    flex: 1,
                  ),
                  getBottomBtn(context,bloc,order)
                ],
              )
            );
          }
      );
  }

  Widget getBottomBtn(BuildContext context,EstateBloc bloc,OrderModel order){
      if(order.status == '1'){
        //待接单页面
        return Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child:Text('接单',textAlign:TextAlign.center,style: TextStyle(fontFamily: 'PingFang',fontWeight: FontWeight.bold),),
                  onTap: (){
                    SimpleDialogUtil.confirmDialog(context, () {
                      CommonUtils.showLoadingDialog(context);
                      bloc.takeOrder(order.id).then((val){
                        Navigator.pop(context);
                      }).catchError((_){
                        Navigator.pop(context);
                      });
                    }, title: '接单提示',
                        content: '是否确认接单？',
                        confirmType: ConfrimType.info,
                        confirmText: '确认'
                    );
                  },
                ),
                flex: 6,
              ),
              Expanded(child: Container(height: Dimens.gap_dp15, child: VerticalDivider(color: Colors.grey)),flex: 1,),
              Expanded(
                child: GestureDetector(
                  child:Text('拒接',textAlign:TextAlign.center,style: TextStyle(fontFamily: 'PingFang',fontWeight: FontWeight.bold),),
                  onTap: (){
                    SimpleDialogUtil.createGroupDialog(context,(des){
                        CommonUtils.showLoadingDialog(context,msg: '加载中');
                        bloc.closeOrder(order.id,des).then((val){
                          Navigator.pop(context);
                        }).catchError((_){
                          Navigator.pop(context);
                        });
                    },'拒接原因','确认拒接','请输入拒接原因');

//                    SimpleDialogUtil.confirmDialog(context, () {
//
//                      CommonUtils.showLoadingDialog(context,msg: '加载中');
//                      bloc.closeOrder(order.id).then((val){
//                        Navigator.pop(context);
//                      }).catchError((_){
//                        Navigator.pop(context);
//                      });
//                    }, title: '接单提示',
//                        content: '是否确认拒绝接单？',
//                        confirmType: ConfrimType.warning,
//                        confirmText: '确认拒接'
//                    );
                  },
                ),
                flex: 6,
              )
            ],
          ),
          flex: 1,
        );
      }else if(order.status == '2' || order.status == '3'){
        //待派单页面 和已派单
        return Expanded(
          child: Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  child:Text('委派',textAlign:TextAlign.center,style: TextStyle(fontFamily: 'PingFang',fontWeight: FontWeight.bold),),
                  onTap: (){
                    NavigatorUtil.pushPage(
                      context,
                      BlocProvider<EstateBloc>(
                        child: SysUserSelectPage(labelId: Ids.titleUserList,orderId:order.id),
                        bloc: new EstateBloc(),
                      ),
                      pageName: Ids.titleUserList,
                    );
                  },
                ),
                flex: 6,
              ),
              Expanded(child: Container(height: Dimens.gap_dp15, child: VerticalDivider(color: Colors.grey)),flex: 1,),
              Expanded(
                child: GestureDetector(
                  child:Text('取消',textAlign:TextAlign.center,style: TextStyle(fontFamily: 'PingFang',fontWeight: FontWeight.bold,color: Colours.text_gray),),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
                flex: 6,
              )
            ],
          ),
          flex: 1,
        );
      }else if(order.status == '4'){
        //已接单
        return Container();
      }else{
        return Container();
      }
  }

  Widget titleOrder(BuildContext context,EstateBloc bloc,OrderModel order){

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
                            border: new Border.all(width: 1, color: Color(0xff09acfe)),
                          ),
                          child: Text(order.statusDictText,style: TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp12,color: Color(0xff09acfe)),),
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
                                Expanded(
                                  child:Row(
                                    children: <Widget>[
                                      Text(order.userName,style: TextStyle(fontFamily: 'PingFang',fontWeight: FontWeight.bold)),
                                      GestureDetector(
                                        child: Container(
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
                                            border: new Border.all(width: 1, color: Color(0xfff9650c)),
                                          ),
                                          child: Text('联系业主',style: TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp12,color: Color(0xfff9650c)),),
                                        ),
                                        onTap: (){
                                          NavigatorUtil.diaMobile(order.userMobile);
                                        },
                                      ),
                                    ],
                                  )
                                ),
                                order.isMine == '1' ?Container(padding:EdgeInsets.only(left: 10),height: 30, child: VerticalDivider(color: Colors.grey)):Container(),
                                order.isMine == '1' ? Expanded(
                                  child:GestureDetector(
                                      child:Image.asset(
                                        Utils.getImgPath('contact_icon'),
                                        width: 22.0,
                                        height: 22.0,
                                        fit: BoxFit.contain,
                                      ),
                                    onTap: (){
                                      Navigator.push(context,PopRoute(child:
                                        BlocProvider<EstateBloc>(
                                          child: BottomMessageDialog(orderId: orderId,),
                                          bloc: new EstateBloc(),
                                        ),
                                        )
                                      );
                                    },
                                    ),
                                  flex: 1,
                                ):Container(),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child:Container(
                                       margin: EdgeInsets.only(left: Dimens.gap_dp20,top: Dimens.gap_dp5),
                                       child: Text(Utils.hideMobile(order.userMobile),style: TextStyle(fontFamily: 'PingFang',color: Colours.text_gray,fontSize: Dimens.font_sp14))
                                   ),
                                  flex: 1,
                                ),
                                order.isMine == '1' ? Expanded(
                                  child:Container(
                                      margin: EdgeInsets.only(left: Dimens.gap_dp20),
                                      child: Text('沟通记录',style: TextStyle(fontFamily: 'PingFang',fontSize: Dimens.font_sp12),textAlign: TextAlign.center,)
                                  ),
                                  flex: 1,
                                ):Container(),
                              ],
                            ),
                          ],
                        ),
                        ),
                      ],
                    ),

                    Container(
                      margin: EdgeInsets.only(top: Dimens.gap_dp10,left: Dimens.gap_dp20),
                      child: Row(
                        children: <Widget>[
                          Text('预约时间：',style:TextStyle(fontFamily: 'PingFang',color: Colours.text_gray,fontSize: Dimens.font_sp14)),
                          Text(Utils.timeShowFormat(order.orderServiceDate),style:TextStyle(fontFamily: 'PingFang',color: Colours.text_normal,fontSize: Dimens.font_sp14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: Dimens.gap_dp15),
                child: Image.asset(Utils.getImgPath('line',format: 'jpg'),fit: BoxFit.fitWidth,width: double.infinity),
              ),
              Container(
                margin: EdgeInsets.only(bottom: Dimens.gap_dp10,left: Dimens.gap_dp15,right:Dimens.gap_dp15),
                padding: EdgeInsets.only(bottom:Dimens.gap_dp10,right:Dimens.gap_dp10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(bottomLeft:Radius.circular(8),bottomRight: Radius.circular(8))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    order.image.length > 0 ? Container(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: order.image.asMap().keys.map((f){
                            return new GestureDetector(
                              onTap: (){
                                NavigatorUtil.pushPage(context, PreviewImagesWidget(order.image,initialPage: f),pageName: 'preview');
                              },
                              child: Container(
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                width: (MediaQuery.of(context).size.width - 60) / 3,
                                padding: EdgeInsets.symmetric(horizontal: 2),
                                child: ClipRRect(child:
                                CachedNetworkImage(
                                  height: 90,
                                  fit: BoxFit.cover,
                                  imageUrl:order.image[f],
                                  placeholder: (context, url) => new ProgressView(),
                                  errorWidget: (context, url, error) => new Icon(Icons.error),
                                ),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                    ):SizedBox(height: 0,),

                    Container(
                      padding: EdgeInsets.only(top: Dimens.gap_dp10,left: Dimens.gap_dp10),
                      child: Text('描述：'+order.content),
                    ),
                    SizedBox(height:Dimens.gap_dp10),

                    buildTime(context,bloc,order),

                    buildButton(context,bloc,order)
                  ],
                ),
              ),
            ],
          ),
    );
  }
  //处理时长
  Widget buildTime(BuildContext context,EstateBloc bloc,OrderModel order){
    if(order.isMine == '1' && order.status == '4'){
        return GestureDetector(
          child: Container(
              padding: EdgeInsets.only(left: Dimens.gap_dp10,bottom: Dimens.gap_dp10),
              child: Row(
                children: <Widget>[
                  Text('处理时长：',style: TextStyle(fontFamily: 'PingFang',color: Colours.text_gray),),
                  Text(getFinishTimeStr(order),style:TextStyle(fontFamily: 'PingFang',color: Colours.text_gray),),
                  Icon(Icons.keyboard_arrow_right,color: Colours.text_gray)
                ],
              )
          ),
          onTap: () async {
            var valueFromSecondPage = await Navigator.push(context,PopRoute(child:
              BlocProvider<EstateBloc>(
                child: BottomMineScheduleDialog(orderId:order.id),
                bloc: new EstateBloc(),
              ),
            )
            );
            if(null != valueFromSecondPage){
              DispatchReqModel dis = new DispatchReqModel();
              dis.orderId = orderId;
              dis.times = valueFromSecondPage;

              CommonUtils.showLoadingDialog(context);
              bloc.changeTime(dis).then((v){
                Navigator.pop(context);
                Navigator.pop(context);
              }).catchError((_){
                Navigator.pop(context);
              });
            }
          },
        );
    }
    return Container();
  }

  String getFinishTimeStr(OrderModel order){
    return '${order.actFinishTime / 2} 小时';
  }

  //新建按钮
  Widget buildButton(BuildContext context,EstateBloc bloc,OrderModel order){
    if(order.status == '4' && order.isMine == '1') {
      return Row(
        children: <Widget>[
          Expanded(
              child:
              MaterialButton(
                color: Colors.orangeAccent,
                shape: const RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.all(
                        Radius.circular(Dimens.gap_dp20))),
                child: Text('取消接单', style: TextStyle(fontFamily: 'PingFang',
                    fontSize: Dimens.font_sp16, color: Colors.white),),
                onPressed: () {

                  SimpleDialogUtil.createGroupDialog(context,(des){
                    CommonUtils.showLoadingDialog(context,msg: '加载中');
                    bloc.empDontTakeOrder(order.id,des).then((val){
                      Navigator.pop(context);
                    }).catchError((_){
                      Navigator.pop(context);
                    });
                  },'取消原因','取消接单','请输入取消原因');

//                  SimpleDialogUtil.confirmDialog(context, () {
//                    bloc.empDontTakeOrder(order.id);
//                  }, title: '接单提示',
//                      content: '是否取消接单？',
//                      confirmType: ConfrimType.info,
//                      confirmText: '确认'
//                  );
                },
              )
          ),
          SizedBox(width: Dimens.gap_dp20,),
          Expanded(
              child:
              MaterialButton(
                color: Colours.app_main,
                shape: const RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.all(
                        Radius.circular(Dimens.gap_dp20))),
                child: Text('处理完毕', style: TextStyle(fontFamily: 'PingFang',
                    fontSize: Dimens.font_sp16, color: Colors.white),),
                onPressed: () {
                  SimpleDialogUtil.confirmDialog(context, () {
                    bloc.finishOrder(order.id);
                  }, title: '接单提示',
                      content: '是否确认已处理完毕？',
                      confirmType: ConfrimType.info,
                      confirmText: '确认'
                  );
                },
              )
          )
        ],
      );
    }else if(order.status == '3' && order.isMine == '1'){
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(Dimens.gap_dp20),
        child: MaterialButton(
          color: Colors.orangeAccent,
          shape: const RoundedRectangleBorder(
              side: BorderSide.none,
              borderRadius: BorderRadius.all(
                  Radius.circular(Dimens.gap_dp20))),
          child: Text('接 单', style: TextStyle(fontFamily: 'PingFang',
              fontSize: Dimens.font_sp16, color: Colors.white),),
          onPressed: () {
            SimpleDialogUtil.confirmDialog(context, () {
              bloc.empTakeOrder(order.id);
            }, title: '接单提示',
                content: '是否确认接单？',
                confirmType: ConfrimType.info,
                confirmText: '确认'
            );
          },
        ),
      );
    }else{
      return Container();
    }
  }
}
