import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_wanandroid/common/component_index.dart';
import 'package:flutter_wanandroid/data/net/dio_util.dart';
import 'package:flutter_wanandroid/db/provider.dart';
import 'package:flutter_wanandroid/ui/pages/h_activity_sign_page.dart';
import 'package:flutter_wanandroid/ui/pages/h_main_page.dart';
import 'package:flutter_wanandroid/ui/pages/page_index.dart';
import 'package:flutter_wanandroid/utils/chinese_cupertino_localizations.dart';
import 'package:jmessage_flutter/jmessage_flutter.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
JmessageFlutter jmessage = new JmessageFlutter();

void main() async{

//  final provider = new Provider();
//  await provider.init(true);
//  db = Provider.db;
  WidgetsFlutterBinding.ensureInitialized();
  _initFluwx();

  jmessage..setDebugMode(enable: false);
  jmessage.init(isOpenMessageRoaming: false, appkey: kMockAppkey,isProduction: true);
  jmessage.applyPushAuthority(
      new JMNotificationSettingsIOS(
          sound: true,
          alert: true,
          badge: true)
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_){
    runApp(BlocProvider<ApplicationBloc>(
      bloc: ApplicationBloc(),
      child: BlocProvider(child: MyApp(), bloc: WorkBloc(jmessages:jmessage)),
    ));
  });

  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

_initFluwx() async {
  await fluwx.register(
      appId: "wx860945320e3cd006",
      doOnAndroid: true,
      doOnIOS: true,
//      enableMTA: false
  );
  var result = await fluwx.isWeChatInstalled();
}


class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  Locale _locale;
  Color _themeColor = Colours.app_main;

  @override
  void initState() {
    super.initState();
    setLocalizedValues(localizedValues);
    _init();
    _initAsync();
    _initListener();

//    initPlatformState();
  }

//  final JPush jpush = new JPush();
//  String debugLable = 'Unknown';
//  Future<void> initPlatformState() async {
//    String platformVersion;
//
//    jpush.setAlias("18518216282_h");
//    // Platform messages may fail, so we use a try/catch PlatformException.
//    jpush.getRegistrationID().then((rid) {
//    });
//
//    jpush.setup(
//      appKey: "f3ec3edba9f954c719c2a36a",
//      channel: "developer-default",
//      production: false,
//      debug: true,
//    );
//    jpush.applyPushAuthority(new NotificationSettingsIOS(
//        sound: true,
//        alert: true,
//        badge: true));
//
//    try {
//
//      jpush.addEventHandler(
//        onReceiveNotification: (Map<String, dynamic> message) async {
//          print("flutter onReceiveNotification: $message");
//          setState(() {
//            debugLable = "flutter onReceiveNotification: $message";
//          });
//        },
//        onOpenNotification: (Map<String, dynamic> message) async {
//          print("flutter onOpenNotification: $message");
//          setState(() {
//            debugLable = "flutter onOpenNotification: $message";
//          });
//        },
//        onReceiveMessage: (Map<String, dynamic> message) async {
//          print("flutter onReceiveMessage: $message");
//          setState(() {
//            debugLable = "flutter onReceiveMessage: $message";
//          });
//        },
//      );
//
//    } catch(err) {
//      platformVersion = 'Failed to get platform version.';
//    }
//
//    // If the widget was removed from the tree while the asynchronous platform
//    // message was in flight, we want to discard the reply rather than calling
//    // setState to update our non-existent appearance.
//    if (!mounted) return;
//
//    setState(() {
//      debugLable = platformVersion;
//    });
//  }

  void _init() {
    DioUtil.openDebug();
    Options options = DioUtil.getDefOptions();
    options.baseUrl = Constant.server_address;
    HttpConfig config = new HttpConfig(options: options);
    DioUtil().setConfig(config);
  }

  var db;
  void _initAsync() async {
    await SpUtil.getInstance();
    if (!mounted) return;
    _loadLocale();
  }

  void _initListener() {
    final ApplicationBloc bloc = BlocProvider.of<ApplicationBloc>(context);
    bloc.appEventStream.listen((value) {
      if(value == Constant.type_sys_update) {
        _loadLocale();
      }else if(value == Constant.type_sys_login){
        //登录-
      }
    });
  }

  void _loadLocale() {
    setState(() {
      LanguageModel model =
      SpHelper.getObject<LanguageModel>(Constant.keyLanguage);
      if (model != null) {
        _locale = new Locale(model.languageCode, model.countryCode);
      } else {
        _locale = null;
      }

      String _colorKey = SpHelper.getThemeColor();
      if (themeColorMap[_colorKey] != null)
        _themeColor = themeColorMap[_colorKey];
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
//    Loading.ctx = context;
    return new MaterialApp(
      routes: {
        '/MainPage': (ctx) => TabMainPage(),
       '/ActivitySign':(ctx) => ActivitySignPage()
      },
      home: new SplashPage(),
      theme:ThemeData/*.light().copyWith*/(
//        brightness: Brightness.dark,
        primaryColor: _themeColor,
        accentColor: _themeColor,
        indicatorColor: Colors.white,
        fontFamily: 'NotoSansSc',
        backgroundColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          border: UnderlineInputBorder(borderSide: BorderSide(color: Colours.divider,width: 1.0)),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colours.divider,width: 1.0)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent,width: 1.0)),
          counterStyle: TextStyle(fontSize: 0),
          hintStyle:TextStyle(color: Colours.text_gray),
        ),
        textTheme: ThemeData.light().textTheme.copyWith(
            subhead: ThemeData.light().textTheme.subhead
                .copyWith(textBaseline: TextBaseline.alphabetic)),

      ),
      locale: _locale,
      localizationsDelegates: [
        ChineseCupertinoLocalizations.delegate, // 自定义的delegate
        DefaultCupertinoLocalizations.delegate, // 目前只包含英文

        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        CustomLocalizations.delegate
      ],
      supportedLocales: CustomLocalizations.supportedLocales,
    );
  }
}
