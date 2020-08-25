
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/components/first_page_item.dart';
import 'package:helloworld/data/protocol/consumer_models.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/consumer/article/video_page.dart';
import 'package:helloworld/tviews/webview/webview_flutter.dart';
import 'package:helloworld/tviews/widget/simple_dialog.dart';
import 'package:helloworld/tviews/widget/web_scaffold.dart';
import 'package:helloworld/tviews/widget/widget_index.dart';
import 'package:helloworld/utils/base_utils.dart';
import 'package:helloworld/utils/doormaster_utils.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'package:helloworld/utils/util_index.dart';

import '../consumer_page_index.dart';


class _EstateItem {
  String name, icon, code;
  Widget page;

  _EstateItem(this.name, this.icon,this.code,this.page);
}
//是否加载过
bool estatePageInited = false;
class ConsumerHomeEstatePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ConsumerHomeEstatePageState();
  }

}

//第二部分 物业首页
class ConsumerHomeEstatePageState extends State<ConsumerHomeEstatePage>{

  MainBloc _mainBloc;

  bool opening = false;

  @override
  void initState() {
//    // 摇一摇阀值,不同手机能达到的最大值不同，如某品牌手机只能达到20。
//    accelerometerEvents.listen((AccelerometerEvent event){
//      int value = 15;
//
//      if (event.x >= value ||
//          event.x <= -value ||
//          event.y >= value ||
//          event.y <= -value ||
//          event.z >= value ||
//          event.z <= -value) {
//
//        Vibration.vibrate(duration: 700);
//        if(!opening)
//          blueOpenDoor();
//      }
//    });

    _mainBloc = BlocProvider.of<MainBloc>(context);
    super.initState();
  }

  SysDepartModel sysDepartModel;

  @override
  Widget build(BuildContext context) {
    if(!estatePageInited) {
      _mainBloc.bluePermissionList();
      _mainBloc.bindEstateInfo();
    }
    final itemNames1 = [
      _EstateItem('联系物业','home_part2_1','contactWuye',null),
      _EstateItem('报修','home_part2_2','',WebScaffold(url:'/#/estate/repair',title: '报修')),
      _EstateItem('报事','home_part2_3','',WebScaffold(url:'/#/estate/report',title: '报事')),
      _EstateItem('缴费','home_part2_4','payAmount',null),
    ];
    final itemNames2 = [
      _EstateItem('开门权限申请','home_part2_5','',WebScaffold(url: '/#/estate/applyDoorAth',title:'开门权限申请')),
      _EstateItem('一键开门','home_part2_6','blue_open',null),
      _EstateItem('远程开门','home_part2_7','',RemoteDeviceListPage()),
      _EstateItem('访客','home_part2_8','',GuestDoorPage()),
    ];

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(Dimens.gap_dp10),
      margin: EdgeInsets.only(top: Dimens.gap_dp10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('物业',style: TextStyle(fontSize: Dimens.font_sp16),),
              Expanded(
                child: GestureDetector(
                  child: StreamBuilder(
                      stream: _mainBloc.estateInfoDataStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<Map<String,dynamic>> snapshot) {
                        String villageName = "请选择您居住的小区";
                        if(null != snapshot.data) {
                          try{
                            sysDepartModel = SysDepartModel.fromJson(snapshot.data['depart']);
                            villageName = snapshot.data['village']['villageName'];
                          }catch(err){}
                        }
                        estatePageInited = true;
                        return Text(Utils.subLength(villageName,10),style: TextStyle(color: Colours.text_gray,fontSize: Dimens.font_sp14),textAlign: TextAlign.end,);
                      }),
                  onTap: () async {
                    var state = await NavigatorUtil.pushPageAsync(context, WebScaffold(url:'/#/estate/bindVillage',title: '绑定小区'));
                    _mainBloc.bindEstateInfo();
                  },
                )
              )
            ],
          ),
          SizedBox(height: 5,),
          Row(
            children: <Widget>[
              StreamBuilder(
                  stream: _mainBloc.estateInfoDataStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String,dynamic>> snapshot) {
                    String showName = "请选择小区绑定物业";
                    if(null != snapshot.data) {
                      try{
                        sysDepartModel = SysDepartModel.fromJson(snapshot.data['depart']);
                        showName = sysDepartModel.departName;
                      }catch(err){}
                    }
                    estatePageInited = true;
                    return Text(showName,style: TextStyle(color: Colours.text_gray,fontSize: Dimens.font_sp12),textAlign: TextAlign.end,);
                  }),
            ],
          ),
          SizedBox(height: Dimens.gap_dp5,),
          Divider(color: Colours.divider),
          SizedBox(height: Dimens.gap_dp10,),
          Row(
            children: <Widget>[
              Image.asset(Utils.getImgPath('home_part2_notice'),width: 40,),
              Container(height: 40, child: VerticalDivider(color: Colours.divider)),
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: 50.0,
                  child: StreamBuilder(
                      stream: _mainBloc.estateArticleListDataStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<FirstPageItem>> snapshot) {
                        if(snapshot.data == null || snapshot.data.length <= 0){
                          return Container(height: 0);
                        }
                        return _buildSwiper(context,snapshot.data);
                      }),
                )
              ),
            ],
          ),
          SizedBox(height: Dimens.gap_dp10,),
          Divider(color: Colours.divider),
          SizedBox(height: Dimens.gap_dp10,),
          Column(
            children: <Widget>[
              Row(
                children: itemNames1.map((value){
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        children: <Widget>[
                          Image.asset(Utils.getImgPath(value.icon),width: 20,),
                          SizedBox(height: Dimens.gap_dp10),
                          Text(value.name,style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),)
                        ],
                      ),
                      onTap: (){
                        if (value.code == 'contactWuye'){
                          if(sysDepartModel != null && !ObjectUtil.isEmpty(sysDepartModel.mobile)){
                            if(sysDepartModel.mobile.trim().contains(",") || sysDepartModel.mobile.trim().contains("，") || sysDepartModel.mobile.trim().contains("/") || sysDepartModel.mobile.trim().contains("、") || sysDepartModel.mobile.trim().contains(".")){
                              List<String> mobiles = sysDepartModel.mobile.trim().split(",");
                              if(mobiles.length <= 1){
                                mobiles = sysDepartModel.mobile.trim().split("，");
                              }
                              if(mobiles.length <= 1){
                                mobiles = sysDepartModel.mobile.trim().split("/");
                              }
                              if(mobiles.length <= 1){
                                mobiles = sysDepartModel.mobile.trim().split("、");
                              }
                              if(mobiles.length <= 1){
                                mobiles = sysDepartModel.mobile.trim().split(".");
                              }
                              if(mobiles.length > 1){
                                Widget item = Container(
                                  child: Column(
                                    children: mobiles.asMap().keys.map((value) {
                                      return ListTile(
//                                        leading:Icon(Icons.phone_forwarded),
                                        title: Text(mobiles[value],style: TextStyle(color: CupertinoColors.activeBlue)),
                                        onTap: (){
                                          NavigatorUtil.diaMobile(mobiles[value]);
                                          Navigator.pop(context);
                                        },
                                      );
                                    }).toList()
                                  ),
                                );
                                SimpleDialogUtil.showModalBottom(context,item,'拨打物业电话');
                              }
                            }else {
                              NavigatorUtil.diaMobile(sysDepartModel.mobile);
                            }
                          }
                        }else if(value.code == 'payAmount'){
                          //缴费
                          BaseUtils.showConfirm(context,'暂未开通此服务',(){

                          });
                        }
                        if(value.page != null)
                          NavigatorUtil.pushPage(context, value.page, pageName: value.name);
                      },
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: Dimens.gap_dp15,),
              Row(
                children: itemNames2.map((value){
                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        children: <Widget>[
                          Image.asset(Utils.getImgPath(value.icon),width: 20,),
                          SizedBox(height: Dimens.gap_dp10),
                          Text(value.name,style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),)
                        ],
                      ),
                      onTap: (){
                        if(value.code == 'blue_open'){
                          blueOpenDoor();
                        }else if(value.code == 'applyDoorAuth'){
                          //开门权限申请
                          BaseUtils.showConfirm(context,'暂未开通此服务',(){

                          });
                        } else {
                          NavigatorUtil.pushPage(context, value.page, pageName: value.name);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSwiper(BuildContext context,List<FirstPageItem> list){
    List<Widget> widgets = [];
    List<Widget> temp = [];
    for(var i = 0;i<list.length;i++){
      if(temp.length <= 1){
        temp.add(
          GestureDetector(
            child: Row(
              children: <Widget>[
                Icon(Icons.brightness_1,size: 10,color: Colours.app_estate),
                Text('${list[i].categoryType_dictText}',style: TextStyle(color:Colours.text_gray)),
                SizedBox(width: 5),
                Text('${list[i].article_title}',style: TextStyle(height: 1.6),maxLines: 1,overflow: TextOverflow.clip)
              ],
            ),
            onTap: (){
              if(list[i].article_type == '0') {
                NavigatorUtil.pushPage(context, WebScaffold(url: "/#/cms/articleDetail/${list[i].id}/", title: '文章详情'), pageName: '文章');
              }else if(list[i].article_type == '1'){
                NavigatorUtil.pushPage(context, VideoDetailPage(list[i].id, list[i].images), pageName: '文章详情');
              }
            },
          )
        );
      }
      if(temp.length == 2 || i == list.length - 1){
        widgets.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: temp,
          )
        );
        temp = [];
      }
    }
    if(widgets.length <= 0){
      return Text('暂无公告');
    }
    return Swiper(
      direction : Axis.vertical,
      interval: const Duration(seconds: 5),
      circular: true,
      children: widgets
    );
  }

  //蓝牙开门
  Future blueOpenDoor() async{
    List<Map<dynamic,dynamic>> bluePermissMap = SpUtil.getObjectList(Constant.key_bluepermission);
    if(bluePermissMap == null || bluePermissMap.length <= 0){
      BaseUtils.showConfirm(context,'暂无开门权限',(){
      });
      return;
      return;
    }
    List<BluePermissModel> bluePermiss = bluePermissMap.map((item){
      return BluePermissModel.fromJson(item);
    }).toList();

    if(bluePermiss == null || bluePermiss.length <= 0){
      BaseUtils.showConfirm(context,'暂无开门权限',(){
      });
      return;
    }
    opening = true;
    Loading.show(text: '设备扫描中...');
    DoormasterUtils.scanDevice().then((devs) async {
      Loading.close();
      opening = false;
      if(ObjectUtil.isEmptyList(devs)){
        Fluttertoast.showToast(msg: '您附件没有设备');
        return;
      }
      try {
        if(ObjectUtil.isNotEmpty(bluePermiss)){
          for(int i = 0;i<bluePermiss.length;i++){
            for(int j = 0;j<devs.length;j++){
              if(bluePermiss[0].devSn == devs[j]){
                Loading.show(text: '开门中...');
                print(bluePermiss[0].toJson());
                String result = await DoormasterUtils.openDoor(eKey: bluePermiss[0].eKey, devSn: bluePermiss[0].devSn, devMac: bluePermiss[0].devMac, devType: bluePermiss[0].devType);
                Loading.close();
                Fluttertoast.showToast(msg: result);
                return;
              }
            }
          }
        }else{
          Fluttertoast.showToast(msg: '您没有门禁权限');
        }
      }catch(_){
      }
    }).catchError((_){
      Loading.close();
      opening = false;
    }).whenComplete((){
      Loading.close();
      opening = false;
    });
  }

}