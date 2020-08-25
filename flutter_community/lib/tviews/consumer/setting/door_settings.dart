
import 'package:flutter/material.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/webview/webview_flutter.dart';
import 'package:helloworld/tviews/widget/web_scaffold.dart';
import 'package:helloworld/utils/doormaster_utils.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'package:helloworld/utils/util_index.dart';
import 'package:permission_handler/permission_handler.dart';

//门禁
class DoorSettings extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return DoorSettingsState();
  }
}

class DoorSettingsState extends State<DoorSettings>{

  double sliderValue = -72;
  bool openDoor = false,timeOut30 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('门禁设置'),
        flexibleSpace: Image(
          image: AssetImage(Utils.getImgPath('home_top')),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text('免按开门'),
                trailing: Icon(Icons.help_outline,color: Colors.black),
              ),
              ListTile(
                title: Text('免按开锁'),
                trailing: Image.asset(openDoor ? Utils.getImgPath('radio_open'):Utils.getImgPath('radio_close'),height: 30),
                onTap: (){
                  openDoor = !openDoor;

                  if(openDoor) {

                    List<Map<dynamic,dynamic>> bluePermissMap = SpUtil.getObjectList(Constant.key_bluepermission);

                    DoormasterUtils.autoOpen(auto: '1',devList: jsonEncode(bluePermissMap));
                  }else{
                    DoormasterUtils.closeAutoOpen();
                  }

                  setState((){});
                },
              ),
              ListTile(
                title: Text('同一设备30秒内不再开启'),
                trailing: Image.asset(timeOut30 ? Utils.getImgPath('radio_open'):Utils.getImgPath('radio_close'),height: 30),
                onTap: (){
                  timeOut30 = !timeOut30;
                  setState((){});
                },
              ),
              ListTile(
                title: Text('开门距离调整'),
                trailing:
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Slider(
                      value: sliderValue,
                      max: -65.0,
                      min: -85.0,
                      activeColor: Colours.app_estate,
                      onChanged: (double val) {
                        sliderValue = val;

                        if(openDoor) {
                          DoormasterUtils.closeAutoOpen();
                          List<Map<dynamic,dynamic>> bluePermissMap = SpUtil.getObjectList(Constant.key_bluepermission);
                          DoormasterUtils.autoOpen(auto: '1', limit: sliderValue.toInt(),devList: jsonEncode(bluePermissMap));
                        }
                        setState((){});
                      },
                    ),
                  )
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Dimens.gap_dp10),
                child: Divider(height: 1),
              ),
              ListTile(
                title: Text('开门记录'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () async {
                  // /#/estate/doorLog
                  NavigatorUtil.pushPage(context, WebScaffold(url:'/#/estate/doorLog',title: '开门记录'),pageName: '开门记录');
                },
              ),
            ],
          ),
        )
      ),
    );
  }
}