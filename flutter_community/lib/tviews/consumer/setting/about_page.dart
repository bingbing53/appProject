
import 'package:flutter/material.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/data/protocol/consumer_models.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:helloworld/tviews/webview/webview_flutter.dart';
import 'package:helloworld/tviews/widget/web_scaffold.dart';
import 'package:helloworld/tviews/widget/widget_index.dart';
import 'package:helloworld/utils/base_utils.dart';
import 'package:helloworld/utils/navigator_util.dart';
import 'package:helloworld/utils/util_index.dart';

import 'door_settings.dart';


//系统设置界面
class AboutPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final MainBloc _mainBloc = BlocProvider.of<MainBloc>(context);
    _mainBloc.getVersion(context,download:false);
    return Scaffold(
      appBar: AppBar(
        title: Text('关于'),
        flexibleSpace: Image(
          image: AssetImage(Utils.getImgPath('home_top')),
          fit: BoxFit.cover,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            new Container(
                height: 160.0,
                alignment: Alignment.center,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Card(
                      color: Theme.of(context).primaryColor,
                      elevation: 0.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0))),
                      child: new Image.asset(
                        Utils.getImgPath('ic_launcher'),
                        width: 72.0,
                        fit: BoxFit.fill,
                        height: 72.0,
                      ),
                    ),
                    Gaps.vGap5,
                    new Text(
                      '版本号 ' + AppConfig.version,
                      style: new TextStyle(color: Colours.gray_99, fontSize: 14.0),
                    )
                  ],
                ),
                decoration: new BoxDecoration(
                    color: Colors.white,
                    border: new Border.all(width: 0.33, color: Colours.divider))),
            new StreamBuilder(
                stream: _mainBloc.versionStream,
                builder:
                    (BuildContext context, AsyncSnapshot<VersionModel> snapshot) {
                  VersionModel model = snapshot.data;
                  return new Container(
                    child: new Material(
                      color: Colors.white,
                      child: new ListTile(
                        onTap: () {
                          if (model == null) {
                            _mainBloc.getVersion(context);
                          } else {
                            if (Utils.getUpdateStatus(model.version) != 0) {
//                              NavigatorUtil.launchInBrowser(model.url,
//                                  title: model.title);
                              _mainBloc.getVersion(context,download:true);
                            }
                          }
                        },
                        title: new Text('版本更新'),
                        //dense: true,
                        trailing: new Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              model == null
                                  ? ''
                                  : (Utils.getUpdateStatus(model.version) == 0
                                  ? '已是最新版'
                                  : '有新版本，去更新吧'),
                              style: TextStyle(
                                  color: (model != null &&
                                      Utils.getUpdateStatus(model.version) !=
                                          0)
                                      ? Colors.red
                                      : Colors.grey,
                                  fontSize: 14.0),
                            ),
                            new Icon(
                              Icons.navigate_next,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    decoration: Decorations.bottom,
                  );
                }),
          ]
        ),
      ),
    );
  }
}