import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helloworld/blocs/tab_bloc.dart';
import 'package:helloworld/common/component_index.dart';
import 'package:helloworld/tviews/widget/image_preview.dart';
import 'package:helloworld/tviews/widget/web_scaffold.dart';
import 'package:helloworld/utils/util_index.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigatorUtil {

  static void pushPage(BuildContext context, Widget page, {String pageName}) {
    if (context == null || page == null || ObjectUtil.isEmpty(pageName)) return;
    Navigator.push(
        context, new CupertinoPageRoute<void>(builder: (ctx) => page));
  }

  static Future pushPageAsync(BuildContext context, Widget page) async{
    if (context == null || page == null) return;
    final result = await Navigator.push(
        context, new CupertinoPageRoute<void>(builder: (ctx) => page));
    return result;
  }

  static void pushReplacePage(BuildContext context, Widget page, {String pageName}){
    if (context == null || page == null || ObjectUtil.isEmpty(pageName)) return;
    Navigator.pushReplacement(
        context, new CupertinoPageRoute<void>(builder: (ctx) => page));
  }

  static void pushWeb(BuildContext context,
      {String title, String titleId, String url, bool isHome: false,bool refreshCache:false}) {
    print(url);
    if (context == null || ObjectUtil.isEmpty(url)) return;
    if (url.endsWith(".apk")) {
      launchInBrowser(url, title: title ?? titleId);
    } else {
      print(url);
      Navigator.push(
          context,
          new MaterialPageRoute<void>(
              builder: (ctx) => new WebScaffold(
                    title: title,
                    titleId: titleId,
                    url: url,
                    refreshCache:refreshCache
                  )));
    }
  }

  static void imagePreview(BuildContext context,{String netSrc,String localSrc,MainBloc work,String msgId,String msgServerId}){
    Navigator.push(
        context,new MaterialPageRoute(builder: (ctx) => ImagePreview(netSrc:netSrc,localSrc:localSrc,bloc:work,msgId: msgId,msgServerId: msgServerId))
    );
  }

//  static void pushTabPage(BuildContext context,
//      {String labelId, String title, String titleId, TreeModel treeModel}) {
//    if (context == null) return;
//    Navigator.push(
//        context,
//        new CupertinoPageRoute<void>(
//            builder: (ctx) => new BlocProvider<TabBloc>(
//                  child: new TabPage(
//                    labelId: labelId,
//                    title: title,
//                    titleId: titleId,
//                    treeModel: treeModel,
//                  ),
//                  bloc: new TabBloc(),
//                )));
//  }

  static Future<Null> launchInBrowser(String url, {String title}) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  ///弹出 dialog
  static Future<T> showGSYDialog<T>({
    @required BuildContext context,
    bool barrierDismissible = true,
    WidgetBuilder builder,
  }) {
    return showDialog<T>(
        context: context,
        barrierDismissible: barrierDismissible,
        builder: (contexts) {
          return /*MediaQuery(
            ///不受系统字体缩放影响
//              data: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
//                  .copyWith(textScaleFactor: 1),
              child:*/ new SafeArea(child: builder(context));
        });
  }

  //拨打电话
  static void diaMobile(String mobile) async {
    String url='tel:'+mobile;
    if(await canLaunch(url)) {
      await launch(url);
    }
  }
}
