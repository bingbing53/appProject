import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_wanandroid/utils/util_index.dart' as util;
import 'package:flutter_wanandroid/ui/pages/page_index.dart';
import 'package:flutter_wanandroid/blocs/bloc_index.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/res/res_index.dart';
import 'package:flutter_wanandroid/data/api/apis.dart'
;


class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
//      navigationBar: CupertinoNavigationBar(
//        middle: Text("$_title"),
//      ),
      child: SafeArea(
        child: WebView(
          initialUrl: WanAndroidApi.PROPOSAL_LIST,
          //JS执行模式 是否允许JS执行
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            _controller = controller;
          },

          javascriptChannels: <JavascriptChannel>[
            JavascriptChannel(
                name: "Toaster",
                onMessageReceived: (JavascriptMessage message) {
                  print("参数： ${message.message}");
                  util.NavigatorUtil.pushPage(
                    context,
                    BlocProvider<MissionBloc>(
                      child: CreateMeetingPage(labelId: Ids.titleMeeting),
                      bloc: new MissionBloc(),
                    ),
                    pageName: Ids.titleMeeting,
                  );
                }
            ),
          ].toSet(),

        ),
      ),
    );
  }
}