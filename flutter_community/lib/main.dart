
//import 'dart:io';

import 'dart:io';

import 'package:amap_base_location/amap_base_location.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:helloworld/res/res_index.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:helloworld/tviews/consumer/consumer_page_index.dart';
import 'package:helloworld/tviews/consumer/login/login_base_page.dart';
import 'package:helloworld/tviews/h_main_page.dart';
import 'package:helloworld/utils/fallback_cupertino_locations.dart';
import 'package:helloworld/utils/util_index.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';
//import 'package:mop/mop.dart';
import 'blocs/bloc_index.dart';
import 'common/component_index.dart';
import 'data/net/dio_util.dart';
import 'event/event-bus.dart';
import 'routers/routers.dart';
import 'routers/application.dart';
import 'common/provider.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

const int ThemeColor = 0xFFFF8A80;
JmessageFlutter jmessage = new JmessageFlutter();
//本地消息通知插件

class MyApp extends StatelessWidget {
  MyApp() {
    final router = new Router();
    Routes.configureRoutes(router);
    Application.router = router;

    final eventBus = new EventBus();
    ApplicationEvent.event = eventBus;

  }

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
      return getErrorWidget(context, errorDetails);
    };

    return new MaterialApp(
      title: '社区e家',
      home: TabMainPage(),
      onGenerateRoute: Application.router.generator,
      debugShowCheckedModeBanner: false,  // 设置这一属性即可
      supportedLocales: [
        //此处
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
      theme:ThemeData(
        canvasColor: Color(0xfff7f7f7),
        primaryColor: Colours.app_main,
        accentColor: Colours.app_main,
        indicatorColor: Colors.white,
        fontFamily: 'NotoSansSc',
        backgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
            border: UnderlineInputBorder(borderSide: BorderSide(color: Colours.divider,width: 1.0)),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colours.divider,width: 1.0)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent,width: 1.0)),
            counterStyle: TextStyle(fontSize: 0),
            hintStyle:TextStyle(color: Colours.text_gray)
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
            subhead: ThemeData.light().textTheme.subhead
                .copyWith(textBaseline: TextBaseline.alphabetic)),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FallbackCupertinoLocalisationsDelegate()
//        CustomLocalizations.delegate
      ],
      routes: {
        '/selectPlacePage': (ctx) => SelectPlacePage(),
        '/loginPage': (ctx) => LoginPage(),
      },
    );
  }

  Widget getErrorWidget(BuildContext context, FlutterErrorDetails error) {
    return SizedBox();
  }

}

var db;
void main() async {
  final provider = new Provider();
  await provider.init(true);
  await SpUtil.getInstance();

//  await AMap.init('27d67839721288be2ddd87b4fd868822');
  await AMap.init('b97cda1874c0b49ff92d57cbc12ee73d');
  db = Provider.db;
  _initFluwx();

  jmessage..setDebugMode(enable: false);
  jmessage.init(isOpenMessageRoaming: false, appkey: kMockAppkey,isProduction: true);
  //推送设置
  if (Platform.isIOS) {
    jmessage.applyPushAuthority(
        new JMNotificationSettingsIOS(
            sound: true,
            alert: true,
            badge: true)
    );
  }

  await initDio();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_){
    runApp(BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: BlocProvider(child: MyApp(), bloc: MainBloc(jmessages:jmessage)),
    ));
  });

  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

}

Future initDio() {
  DioUtil.openDebug();
  HttpConfig config = new HttpConfig();
  DioUtil().setConfig(config);

  String token = SpUtil.getString(Constant.key_token_name, defValue: '');
  DioUtil().setCookie(token);
}

Future _initFluwx() async {

  await fluwx.registerWxApi(
      appId:"wx265c327abbf63da7",
      doOnAndroid: true,
      doOnIOS: true,
      universalLink:"https://jmapp.shequyijia.cn/"
  );

}