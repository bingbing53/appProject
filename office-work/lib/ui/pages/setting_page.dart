import 'package:flutter/material.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/ui/pages/language_page.dart';
import 'package:flutter_wanandroid/utils/idcard_utils.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WorkBloc workBloc = BlocProvider.of<WorkBloc>(context);
    LogUtil.e("SettingPage build......");
    final ApplicationBloc bloc = BlocProvider.of<ApplicationBloc>(context);

    workBloc.getVersion(context);

    return new Scaffold(
      appBar: AppBar(
        title: Text(
          IntlUtil.getString(context, Ids.titleSetting),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          new ExpansionTile(
            title: new Row(
              children: <Widget>[
                Icon(
                  Icons.color_lens,
                  color: Colours.gray_66,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    IntlUtil.getString(context, Ids.titleTheme),
                  ),
                )
              ],
            ),
            children: <Widget>[
              new Wrap(
                children: themeColorMap.keys.map((String key) {
                  Color value = themeColorMap[key];
                  return new InkWell(
                    onTap: () {
                      SpUtil.putString(Constant.key_theme_color, key);
                      bloc.sendAppEvent(Constant.type_sys_update);
                    },
                    child: new Container(
                      margin: EdgeInsets.all(5.0),
                      width: 36.0,
                      height: 36.0,
                      color: value,
                    ),
                  );
                }).toList(),
              )
            ],
          ),

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
                      Utils.getImgPath('icon_wan_android'),
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
              stream: workBloc.versionStream,
              builder:
                  (BuildContext context, AsyncSnapshot<VersionModel> snapshot) {
                VersionModel model = snapshot.data;
                return new Container(
                  child: new Material(
                    color: Colors.white,
                    child: new ListTile(
                      onTap: () {
                        if (model == null) {
                          workBloc.getVersion(context);
                        } else {
                          if (Utils.getUpdateStatus(model.version) != 0) {
                            NavigatorUtil.launchInBrowser(model.url,
                                title: model.title);
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
        ],
      ),
    );
  }
}
