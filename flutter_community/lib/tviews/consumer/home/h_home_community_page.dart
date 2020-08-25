
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helloworld/blocs/bloc_index.dart';
import 'package:helloworld/data/protocol/consumer_models.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/consumer/comm/free_shoot_page.dart';
import 'package:helloworld/tviews/webview/webview_flutter.dart';
import 'package:helloworld/tviews/widget/simple_dialog.dart';
import 'package:helloworld/tviews/widget/web_scaffold.dart';
import 'package:helloworld/utils/base_utils.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'package:helloworld/utils/util_index.dart';

import '../consumer_page_index.dart';


class _CommunityItem {
  String name, icon, code;
  Widget page;

  _CommunityItem(this.name, this.icon,this.code,this.page);
}

//第一部分 社区首页
bool initedCommunityPage = false;
class ConsumerHomeCommunityPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    final MainBloc _mainBloc = BlocProvider.of<MainBloc>(context);

    String departName = "";

    _mainBloc.staticInfoDataStream.listen((value){
      departName = value.departName;
    });

    final itemNames = [
      _CommunityItem('办事','home_part1_1','trader',WebScaffold(url:'/#/community/traderList',title: '办事')),
      _CommunityItem('街道热线','home_part1_2','streetHotLine',null),
      _CommunityItem('社区热线','home_part1_3','commHotLine',null),
      _CommunityItem('随手拍','home_part1_4','takePicture',WebScaffold(url:'/#/community/takePictureList',title: '随手拍',))//TakePicturePage()),
    ];
//    if(!initedCommunityPage) {
      getMineOrg(_mainBloc);
//    }

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left:Dimens.gap_dp10,right: Dimens.gap_dp10,bottom: Dimens.gap_dp10,top: Dimens.gap_dp15),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              StreamBuilder(
                  stream: _mainBloc.staticInfoDataStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<StaticInfo> snapshot) {
                    initedCommunityPage = true;
                    if(null != snapshot.data) {
                      return Text(Utils.subLength(snapshot.data.departName, 10),
                        style: TextStyle(fontSize: Dimens.font_sp16),);
                    }else {
                      return Text('');
                    }
                  }),
              Expanded(
                child: GestureDetector(
                  child: Text('选择',style: TextStyle(fontSize: Dimens.font_sp14,color: Colours.text_gray),textAlign: TextAlign.end),
                  onTap: (){
                    NavigatorUtil.pushPage(context, SelectPlacePage(),pageName: '选择社区');
                  },
                ),
              )
            ],
          ),
          SizedBox(height: Dimens.gap_dp10,),
          Divider(color: Colours.divider),
          SizedBox(height: Dimens.gap_dp10,),
          Row(
            children: itemNames.map((value){
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    children: <Widget>[
                      Image.asset(Utils.getImgPath(value.icon),width: 20),
                      SizedBox(height: Dimens.gap_dp10),
                      Text(value.name,style: TextStyle(fontSize: Dimens.font_sp12,color: Colours.text_gray),)
                    ],
                  ),
                  onTap: (){
                    if(value.page != null && value.code == 'takePicture'){
                      BaseUtils.showConfirm(context, "您的随手拍信息将被发送至:\n"
                          "[${departName}]居委会进行处理！", () {
                        NavigatorUtil.pushPage(context, value.page,pageName: value.name);
                      });
                    }else{
                      NavigatorUtil.pushPage(context, value.page,pageName: value.name);
                    }
                    String mobile = "";
                    if(value.code == 'streetHotLine'){
                      mobile = community['street'].mobile;
                    }else if(value.code == 'commHotLine'){
                      mobile = community['community'].mobile;
                    }

                    print(community['street'].departName);
                    print(community['community'].departName);

                    if(value.code == 'streetHotLine' || value.code == 'commHotLine'){
                      if(mobile == ''){
                        Fluttertoast.showToast(msg: '暂未设置联系热线');
                      }else {
                        if (mobile.trim().contains(",") ||
                            mobile.trim().contains("，") ||
                            mobile.trim().contains("/") ||
                            mobile.trim().contains("、") ||
                            mobile.trim().contains(".")) {
                          List<String> mobiles = mobile.trim().split(",");
                          if (mobiles.length <= 1) {
                            mobiles = mobile.trim().split("，");
                          }
                          if (mobiles.length <= 1) {
                            mobiles = mobile.trim().split("/");
                          }
                          if (mobiles.length <= 1) {
                            mobiles = mobile.trim().split("、");
                          }
                          if (mobiles.length <= 1) {
                            mobiles = mobile.trim().split(".");
                          }
                          if (mobiles.length > 1) {
                            Widget item = Container(
                              child: Column(
                                  children: mobiles
                                      .asMap()
                                      .keys
                                      .map((value) {
                                    return ListTile(
                                      title: Text(mobiles[value],
                                          style: TextStyle(
                                              color: CupertinoColors
                                                  .activeBlue)),
                                      onTap: () {
                                        NavigatorUtil.diaMobile(mobiles[value]);
                                        Navigator.pop(context);
                                      },
                                    );
                                  }).toList()
                              ),
                            );
                            SimpleDialogUtil.showModalBottom(context, item,
                                value.code == 'streetHotLine'
                                    ? '拨打街道电话'
                                    : '拨打社区电话');
                          }
                        } else {
                          NavigatorUtil.diaMobile(mobile);
                        }
                      }
                    }
                  },
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
  Map<String,SysDepartModel> community = {};
  getMineOrg(MainBloc _mainBloc){
    _mainBloc.getMineOrg().then((result){
      community = result;
    });
  }
  
}