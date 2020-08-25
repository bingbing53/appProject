
import 'package:flutter/material.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/consumer/setting/about_page.dart';
import 'package:helloworld/tviews/webview/webview_flutter.dart';
import 'package:helloworld/tviews/widget/web_scaffold.dart';
import 'package:helloworld/tviews/widget/widget_index.dart';
import 'package:helloworld/utils/base_utils.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'package:helloworld/utils/util_index.dart';

import 'account_page.dart';
import 'door_settings.dart';

class _SettingItem {
  String name;
  Widget page;
  _SettingItem(this.name,this.page);
}
//系统设置界面
class SettingsPage extends StatelessWidget{


  @override
  Widget build(BuildContext context) {

    final MainBloc _mainBloc = BlocProvider.of<MainBloc>(context);

    var itemNames = [
      _SettingItem('账号与安全', AccountPage()),
//      _SettingItem('通用消息', null),
//      _SettingItem('消息设置', null),
      _SettingItem('门禁设置', DoorSettings()),
      _SettingItem('问题与反馈', WebScaffold(url:"/#/report/",title: '问题与反馈',)),
      _SettingItem('关于社区e家', AboutPage()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('系统设置'),
        flexibleSpace: Image(
          image: AssetImage(Utils.getImgPath('home_top')),
          fit: BoxFit.cover,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: itemNames.map((val){
            return Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(val.name),
                    trailing: Icon(Icons.keyboard_arrow_right,color: Colours.divider),
                    onTap: (){
                      if(val.page != null){
                        NavigatorUtil.pushPage(context, val.page,pageName:val.name);
                      }
                    },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: Dimens.gap_dp20),
                    child: Divider(height: 1),
                  )
                ],
              ),
            );
          }).toList(),
        ),
      ),
      bottomNavigationBar:
        RoundButton(
          radius: 0,
          text: '退出登录',
          bgColor: Colours.app_main,
          onPressed: (){
            BaseUtils.showConfirm(context, "是否确认退出登录？", () {
              //退出登录
              _mainBloc.logout();
            });
          },
        )
    );
  }
}