
import 'package:flutter/material.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/webview/webview_flutter.dart';
import 'package:helloworld/tviews/widget/web_scaffold.dart';
import 'package:helloworld/tviews/widget/widget_index.dart';
import 'package:helloworld/utils/base_utils.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'package:helloworld/utils/util_index.dart';

import 'door_settings.dart';

class _SettingItem {
  String name;
  Widget page;
  _SettingItem(this.name,this.page);
}
//系统设置界面
class AccountPage extends StatelessWidget{


  @override
  Widget build(BuildContext context) {

    var itemNames = [
      _SettingItem('一级认证', WebScaffold(url:'/#/certificate/cert1',title:'一级认证')),
      _SettingItem('二级认证', WebScaffold(url:'/#/estate/bindEstate/',title:'二级认证')),
      _SettingItem('三级认证', WebScaffold(url:'/#/estate/bindEstate/?type=cert3',title:'三级认证')),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('账号与安全'),
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
    );
  }
}