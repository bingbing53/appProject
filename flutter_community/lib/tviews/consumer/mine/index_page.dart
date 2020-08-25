
import 'package:flutter/material.dart';
import 'package:helloworld/blocs/bloc_index.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/data/protocol/consumer_models.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/consumer/consumer_page_index.dart';
import 'package:helloworld/tviews/consumer/login/login_base_page.dart';
import 'package:helloworld/tviews/consumer/setting/settings_page.dart';
import 'package:helloworld/tviews/webview/webview_flutter.dart';
import 'package:helloworld/tviews/widget/simple_dialog.dart';
import 'package:helloworld/tviews/widget/web_scaffold.dart';
import 'package:helloworld/tviews/widget/widget_index.dart';
import 'package:helloworld/utils/base_utils.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'package:helloworld/utils/util_index.dart';

class MinePage extends StatefulWidget {
  @override
  MinePageState createState() => new MinePageState();
}


class MinePageState extends State<MinePage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  MainBloc _mainBloc;

  @override
  void initState() {
    super.initState();
    _mainBloc = BlocProvider.of<MainBloc>(context);
    _mainBloc.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    _mainBloc.getUserInfo();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  child: Image.asset(Utils.getImgPath('mine_header'),width: double.infinity),
                ),
                Positioned(
                  top: 50,
                  left: 10,
                  right: 10,
                  child:Column(
                    children: <Widget>[
                      //头像和二维码
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: StreamBuilder(
                                stream: _mainBloc.userInfoDataStream,
                                builder: (BuildContext context,AsyncSnapshot<BaseUserInfoModel> snapshot) {
                                  if(snapshot.data == null || snapshot.hasError || snapshot.data.mobile == null){
                                    return GestureDetector(
                                      child: Row(
                                        children: <Widget>[
                                          SizedBox(width: 20),
                                          ClipOval(
                                            child:  Image.asset(Utils.getImgPath('chat_single'),width: 60),
                                          ),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text('请登录',style: TextStyle(color: Colors.white,fontSize: Dimens.font_sp16),),
                                              Text('',style: TextStyle(color: Colors.white,fontSize: Dimens.font_sp13))
                                            ],
                                          ),
                                        ],
                                      ),
                                      onTap: (){
                                        NavigatorUtil.pushPage(context, LoginPage(),pageName:'登录');
                                      },
                                    );
                                  }
                                  BaseUserInfoModel userInfo = snapshot.data;
                                  return Row(
                                    children: <Widget>[
                                      SizedBox(width: 20),
                                      GestureDetector(
                                        child: userInfo.headImage != null && userInfo.headImage != '' ? ClipOval(
                                          child:  CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl: '${userInfo.headImage}',
                                            width: 60,
                                            height: 60,
                                          ),
                                        ):ClipOval(
                                          child:  Image.asset(Utils.getImgPath('chat_single'),width: 60),
                                        ),
                                        onTap: (){

                                          Widget item = Container(
                                            child: Column(
                                              children: <Widget>[
                                                ListTile(
                                                  leading:Icon(Icons.photo_camera),
                                                  title: Text('拍照'),
                                                  onTap: (){
                                                    _mainBloc.clickAvatar(ImageSource.camera);
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                Divider(height: 1.0,),
                                                ListTile(
                                                  leading:Icon(Icons.photo_library),
                                                  title: Text('相册'),
                                                  onTap: (){
                                                    _mainBloc.clickAvatar(ImageSource.gallery);
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            ),
                                          );

                                          SimpleDialogUtil.showModalBottom(context, item, '更换头像');
                                        },
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text('${userInfo.nickName}',style: TextStyle(color: Colors.white,fontSize: Dimens.font_sp16),),
                                          Text('${Utils.hideMobile(userInfo.mobile)}',style: TextStyle(color: Colors.white,fontSize: Dimens.font_sp13))
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                            flex: 5,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child: GestureDetector(
                                      child: SizedBox(child:Image.asset(Utils.getImgPath('scan_qrcode'),width: 25),width: 25,height: 25),
                                      onTap: () async {
                                        String token = SpUtil.getString(Constant.key_token_name, defValue: '');
                                        if(token != null && token.length > 0) {
                                          String barcode = await BarcodeScanner.scan();
                                          BaseUtils.scanQRResult(barcode, context);
                                        }else{
                                          NavigatorUtil.pushPageAsync(context,LoginPage());
                                        }
                                      },
                                    )
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    child: SizedBox(child: Image.asset(Utils.getImgPath('qrcode'),width: 26),width: 26,height: 26),
                                    onTap: (){
                                      String token = SpUtil.getString(Constant.key_token_name, defValue: '');
                                      if(token != null && token.length > 0) {
                                        NavigatorUtil.pushPage(
                                            context, QrCodePage(),
                                            pageName: '我的二维码');
                                      }else{
                                        NavigatorUtil.pushPageAsync(context,LoginPage());
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            flex: 2,
                          )
                        ],
                      ),
                      //横线
                      Container(
                        padding: EdgeInsets.only(top: 30,bottom: Dimens.gap_dp15),
                        child: Divider(color: Colors.white,height: 1),
                      ),
                      //收藏 评论 关注
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                                child: Column(
                                  children: <Widget>[
                                    Image.asset(Utils.getImgPath('mine_collect'),width: 25,height: 25,),
                                    SizedBox(height: Dimens.gap_dp5),
                                    Text('我的收藏',style: TextStyle(color: Colors.white,fontSize: Dimens.font_sp13))
                                  ],
                                ),
                                onTap: (){
                                  NavigatorUtil.pushPage(context, WebScaffold(url:'/#/mine/collect',title: '我的收藏',hideTitleBar: true),pageName: '我的收藏');
                                },
                              ),
                              flex: 1,
                          ),
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child:Column(
                                children: <Widget>[
                                  Image.asset(Utils.getImgPath('mine_judge'),width: 25,height: 25,),
                                  SizedBox(height: Dimens.gap_dp5),
                                  Text('我的评论',style: TextStyle(color: Colors.white,fontSize: Dimens.font_sp13))
                                ],
                              ),
                              onTap: (){
                                NavigatorUtil.pushPage(context, WebScaffold(url:'/#/comment/',title: '我的评论',hideTitleBar: true),pageName: '我的评论');
                              },
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                                child:Column(
                                  children: <Widget>[
                                    Image.asset(Utils.getImgPath('mine_focus'),width: 25,height: 25,),
                                    SizedBox(height: Dimens.gap_dp5),
                                    Text('我的关注',style: TextStyle(color: Colors.white,fontSize: Dimens.font_sp13))
                                  ],
                                ),
                                onTap: (){
                                  NavigatorUtil.pushPage(context, WebScaffold(url:'/#/focus/',title: '我的关注',hideTitleBar: true),pageName: '我的关注');
                                },
                              ),
                            flex: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //卡券和订单
            Container(
              margin: EdgeInsets.only(top: Dimens.gap_dp10),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Image.asset(Utils.getImgPath('mine_car'),width: 20,height: 20,),
                        SizedBox(width: Dimens.gap_dp10),
                        Text('我的购物车',style: TextStyle(fontSize: Dimens.font_sp16))
                      ],
                    ),
                    trailing: new Icon(Icons.keyboard_arrow_right,color: Colours.app_main),
                    onTap: (){
                      NavigatorUtil.pushPage(context, WebScaffold(url:'/#/ShoppingCar/',title: '我的购物车',hideTitleBar: true),pageName: '我的购物车');
                    },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: Dimens.gap_dp15),
                    child: Divider(color: Colours.divider,height: 2.0),
                  ),
                  ListTile(
                    title: Row(
                    children: <Widget>[
                        Image.asset(Utils.getImgPath('mine_card'),width: 20,height: 20,),
                        SizedBox(width: Dimens.gap_dp10),
                        Text('我的卡券',style: TextStyle(fontSize: Dimens.font_sp16))
                      ],
                    ),
                    trailing: new Icon(Icons.keyboard_arrow_right,color: Colours.app_main),
                    onTap: (){
                      NavigatorUtil.pushPage(context, WebScaffold(url:'/#/vouchers/',title: '我的卡券',hideTitleBar: true),pageName: '我的卡券');
                    },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: Dimens.gap_dp15),
                    child: Divider(color: Colours.divider,height: 2.0),
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Image.asset(Utils.getImgPath('mine_order'),width: 20,height: 20,),
                        SizedBox(width: Dimens.gap_dp10),
                        Text('我的订单',style: TextStyle(fontSize: Dimens.font_sp16))
                      ],
                    ),
                    trailing: new Icon(Icons.keyboard_arrow_right,color: Colours.app_main),
                    onTap: (){
                      NavigatorUtil.pushPage(context, WebScaffold(url:'/#/orderList/',title: '我的订单',hideTitleBar: true),pageName: '我的订单');
                    },
                  ),
                ],
              ),
            ),
            //公益服务
            Container(
              margin: EdgeInsets.only(top: Dimens.gap_dp10),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Image.asset(Utils.getImgPath('mine_serve'),width: 20,height: 20,),
                        SizedBox(width: Dimens.gap_dp10),
                        Text('公益服务',style: TextStyle(fontSize: Dimens.font_sp16))
                      ],
                    ),
                  ),
                  StreamBuilder(
                    stream: _mainBloc.userInfoDataStream,
                    builder: (BuildContext context,AsyncSnapshot<BaseUserInfoModel> snapshot) {
                      if(snapshot.data == null || snapshot.hasError){
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text('0',style: TextStyle(fontSize: Dimens.font_sp20,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                                    SizedBox(height: Dimens.gap_dp10),
                                    Text('公益币',style: TextStyle(fontSize: Dimens.font_sp16),textAlign: TextAlign.center),
                                  ],
                                ),
                                flex: 1
                            ),
                            Expanded(
                                child: Column(
                                    children: <Widget>[
                                      Text('0/h',style: TextStyle(fontSize: Dimens.font_sp20,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                                      SizedBox(height: Dimens.gap_dp10),
                                      Text('时长',style: TextStyle(fontSize: Dimens.font_sp16),textAlign: TextAlign.center),
                                    ]
                                ),
                                flex: 1
                            ),
                          ],
                        );
                      }

                      BaseUserInfoModel userInfo = snapshot.data;
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child: Column(
                                children: <Widget>[
                                  Text('${userInfo.points.floor()}',style: TextStyle(fontSize: Dimens.font_sp20,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                                  SizedBox(height: Dimens.gap_dp10),
                                  Text('公益币',style: TextStyle(fontSize: Dimens.font_sp16),textAlign: TextAlign.center),
                                ],
                              ),
                              flex: 1
                          ),
                          Expanded(
                              child: Column(
                                  children: <Widget>[
                                    Text('${userInfo.duration}/h',style: TextStyle(fontSize: Dimens.font_sp20,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                                    SizedBox(height: Dimens.gap_dp10),
                                    Text('时长',style: TextStyle(fontSize: Dimens.font_sp16),textAlign: TextAlign.center),
                                  ]
                              ),
                              flex: 1
                          ),
                        ],
                      );
                    }
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: Dimens.gap_dp15),
                    padding: EdgeInsets.only(top: Dimens.gap_dp10),
                    child: Divider(color: Colours.divider,height: 1,),
                  ),

                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Image.asset(Utils.getImgPath('mine_activity'),width: 20,height: 20,),
                        SizedBox(width: Dimens.gap_dp10),
                        Text('活动历史',style: TextStyle(fontSize: Dimens.font_sp16))
                      ],
                    ),
                    trailing: new Icon(Icons.keyboard_arrow_right,color: Colours.app_main),
                    onTap: (){
                        NavigatorUtil.pushPage(context, WebScaffold(url:'/#/mine/activityHistory',title: '活动历史'),pageName: '活动历史');
                    },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: Dimens.gap_dp15),
                    child: Divider(color: Colours.divider,height: 1,),
                  ),
//                  ListTile(
//                    title: Row(
//                      children: <Widget>[
//                        Image.asset(Utils.getImgPath('mine_serve_his'),width: 20,height: 20,),
//                        SizedBox(width: Dimens.gap_dp10),
//                        Text('公益服务历史',style: TextStyle(fontSize: Dimens.font_sp16))
//                      ],
//                    ),
//                    trailing: new Icon(Icons.keyboard_arrow_right,color: Colours.app_main),
//                    onTap: (){
//
//                    },
//                  ),

                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: Dimens.gap_dp10,bottom: Dimens.gap_dp20),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Image.asset(Utils.getImgPath('mine_mall'),width: 20,height: 20,),
                        SizedBox(width: Dimens.gap_dp10),
                        Text('我的店铺',style: TextStyle(fontSize: Dimens.font_sp16))
                      ],
                    ),
                    trailing: new Icon(Icons.keyboard_arrow_right,color: Colours.app_main),
                    onTap: (){
                      NavigatorUtil.pushPage(context, WebScaffold(url:'/#/myStore/',title: '我的店铺',hideTitleBar: true),pageName: '我的店铺');
                    },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: Dimens.gap_dp15),
                    child: Divider(color: Colours.divider,height: 1,),
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Image.asset(Utils.getImgPath('mine_setting'),width: 20,height: 20,),
                        SizedBox(width: Dimens.gap_dp10),
                        Text('系统设置',style: TextStyle(fontSize: Dimens.font_sp16))
                      ],
                    ),
                    trailing: new Icon(Icons.keyboard_arrow_right,color: Colours.app_main),
                    onTap: (){
                      NavigatorUtil.pushPage(context, SettingsPage(),pageName: '系统设置');
                    },
                  ),
                ],
              ),
            ),
//            Container(
//              margin: EdgeInsets.only(top: Dimens.gap_dp10,bottom: Dimens.gap_dp10),
//              color: Colors.white,
//              child: Column(
//                children: <Widget>[
//                  ListTile(
//                    title: TextField(
//                      style: TextStyle(fontSize: Dimens.font_sp16),
//                      keyboardType: TextInputType.url,
//                      controller: _controller,
//                      decoration: InputDecoration(
//                          hintText: '请输入地址',
//                          border:InputBorder.none,
//                          focusedBorder:InputBorder.none,
//                          enabledBorder:InputBorder.none
//                      ),
//                    ),
//                    trailing: new Icon(Icons.keyboard_arrow_right,color: Colours.app_main),
//                    onTap: (){
//                      if(_controller.text != null && _controller.text.length > 0){
////                        WebViewFlutterPage
//                        NavigatorUtil.pushPage(context, WebViewFlutterPage(url: _controller.text,showTitle: true),pageName: '测试');
//                      }
//                    },
//                  ),
//                ],
//              ),
//            ),
          ],
        ),
      )
    );
  }

  TextEditingController _controller = new TextEditingController();

}